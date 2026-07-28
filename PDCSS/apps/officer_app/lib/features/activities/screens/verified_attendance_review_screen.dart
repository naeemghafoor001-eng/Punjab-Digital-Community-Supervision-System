import 'package:flutter/material.dart';
import 'package:officer_app/core/backend/models.dart';
import 'package:officer_app/core/backend/raahnuma_backend_service.dart';
import 'package:officer_app/core/theme/officer_app_theme.dart';

class VerifiedAttendanceReviewScreen extends StatefulWidget {
  const VerifiedAttendanceReviewScreen({Key? key}) : super(key: key);

  @override
  State<VerifiedAttendanceReviewScreen> createState() =>
      _VerifiedAttendanceReviewScreenState();
}

class _VerifiedAttendanceReviewScreenState
    extends State<VerifiedAttendanceReviewScreen> {
  List<ActivityAttendanceReviewRecord> _submissions = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _filterStatus = 'All';

  @override
  void initState() {
    super.initState();
    _loadSubmissions();
  }

  Future<void> _loadSubmissions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await RaahnumaBackendService.instance
          .getSubmittedActivityAttendance();
      setState(() {
        _submissions = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load verified attendance records.';
        _isLoading = false;
      });
    }
  }

  void _reviewRecord(
      ActivityAttendanceReviewRecord record, String status) async {
    final remarksController = TextEditingController(text: record.remarks ?? '');
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text(
            'Confirm Review Action ($status)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: status == 'Accepted'
                  ? kGovGreen
                  : status == 'Needs Follow-up'
                      ? Colors.orange.shade900
                      : Colors.red.shade900,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Supervisee: ${record.superviseeName} (${record.caseNumber})',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                'Activity: ${record.activityTitle}',
                style: const TextStyle(fontSize: 12, color: kTextMuted),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: remarksController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Officer Review Remarks',
                  hintText: 'Enter observation or instructions...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: status == 'Accepted'
                    ? kGovGreen
                    : status == 'Needs Follow-up'
                        ? Colors.orange.shade800
                        : Colors.red.shade800,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Submit Review',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      await RaahnumaBackendService.instance.reviewActivityAttendance(
        record.id,
        status,
        remarksController.text.trim(),
      );
      await _loadSubmissions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Attendance for ${record.superviseeName} marked as $status.'),
            backgroundColor: kGovGreen,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filterStatus == 'All'
        ? _submissions
        : _submissions.where((s) => s.reviewStatus == _filterStatus).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          const DepartmentalAppBar(screenTitle: 'Verified Attendance Review'),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadSubmissions,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Institutional Safeguard Banner
                    _buildSafeguardBanner(),
                    const SizedBox(height: 14),

                    // Filter chips
                    Row(
                      children: [
                        const Text(
                          'Filter Review Status: ',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: kTextDark),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildFilterChip('All'),
                                _buildFilterChip('Pending Review'),
                                _buildFilterChip('Accepted'),
                                _buildFilterChip('Needs Follow-up'),
                                _buildFilterChip('Rejected'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(kGovGreen),
                          ),
                        ),
                      )
                    else if (_errorMessage != null)
                      Center(
                        child: Text(_errorMessage!,
                            style: const TextStyle(color: Colors.red)),
                      )
                    else if (filtered.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: Text(
                            'No activity attendance records match the selected filter.',
                            style: TextStyle(color: kTextMuted),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return _buildAttendanceCard(filtered[index]);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafeguardBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF93C5FD)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.shield_outlined, color: Color(0xFF1D4ED8), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Safeguard Notice: Location, photo, and liveness verification indicators serve strictly as decision support aids for officer review and must NOT create automatic legal violation findings.',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E40AF),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _filterStatus == label;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        selected: isSelected,
        label: Text(label, style: const TextStyle(fontSize: 11)),
        selectedColor: kGovGreenSurface,
        checkmarkColor: kGovGreen,
        labelStyle: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? kGovGreen : kTextDark,
        ),
        onSelected: (val) {
          setState(() {
            _filterStatus = label;
          });
        },
      ),
    );
  }

  Widget _buildAttendanceCard(ActivityAttendanceReviewRecord record) {
    final gpsColor = _getGpsColor(record.locationMatchStatus);
    final reviewColor = _getReviewColor(record.reviewStatus);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Supervisee & Review Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.superviseeName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: kTextDark,
                        ),
                      ),
                      Text(
                        'Case No: ${record.caseNumber} | Receipt: ${record.receiptNo}',
                        style: const TextStyle(fontSize: 11, color: kTextMuted),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: reviewColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: reviewColor),
                  ),
                  child: Text(
                    record.reviewStatus,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: reviewColor,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 18),

            // Activity Info
            Row(
              children: [
                Chip(
                  label: Text(record.activityCategory,
                      style: const TextStyle(fontSize: 10, color: kGovGreen)),
                  backgroundColor: kGovGreenSurface,
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    record.activityTitle,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: kTextDark),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 4 Key Indicators (GPS, Distance, Photo, Liveness)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildIndicatorRow(
                          Icons.gps_fixed,
                          'GPS Status',
                          record.locationMatchStatus,
                          gpsColor,
                        ),
                      ),
                      Expanded(
                        child: _buildIndicatorRow(
                          Icons.straighten,
                          'Distance',
                          record.distanceFromExpectedMeters != null
                              ? '${record.distanceFromExpectedMeters!.toStringAsFixed(0)}m'
                              : 'N/A',
                          record.distanceFromExpectedMeters != null &&
                                  record.distanceFromExpectedMeters! <= 300
                              ? kGovGreen
                              : Colors.orange.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildIndicatorRow(
                          Icons.camera_alt,
                          'Photo Status',
                          record.photoStatus,
                          record.photoStatus == 'Uploaded'
                              ? kGovGreen
                              : Colors.orange.shade800,
                        ),
                      ),
                      Expanded(
                        child: _buildIndicatorRow(
                          Icons.face,
                          'Liveness',
                          record.livenessStatus,
                          record.livenessStatus == 'Prompt Completed'
                              ? kGovGreen
                              : kTextMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            if (record.remarks != null && record.remarks!.isNotEmpty) ...[
              Text(
                'Remarks: ${record.remarks}',
                style: const TextStyle(
                    fontSize: 11.5,
                    color: kTextMuted,
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 10),
            ],

            // Action Buttons for Officer
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade800,
                    side: BorderSide(color: Colors.red.shade300),
                  ),
                  icon: const Icon(Icons.cancel_outlined, size: 16),
                  label: const Text('Reject',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  onPressed: () => _reviewRecord(record, 'Rejected'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange.shade900,
                    side: BorderSide(color: Colors.orange.shade300),
                  ),
                  icon: const Icon(Icons.help_outline, size: 16),
                  label: const Text('Follow-up',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  onPressed: () => _reviewRecord(record, 'Needs Follow-up'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGovGreen,
                  ),
                  icon: const Icon(Icons.check_circle,
                      size: 16, color: Colors.white),
                  label: const Text('Accept',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  onPressed: () => _reviewRecord(record, 'Accepted'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicatorRow(
      IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 9.5, color: kTextMuted)),
            Text(
              value,
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ],
    );
  }

  Color _getGpsColor(String status) {
    switch (status) {
      case 'Within Radius':
        return kGovGreen;
      case 'Outside Radius':
        return Colors.orange.shade800;
      case 'GPS Unavailable':
        return Colors.red.shade800;
      default:
        return kTextMuted;
    }
  }

  Color _getReviewColor(String status) {
    switch (status) {
      case 'Accepted':
        return kGovGreen;
      case 'Pending Review':
        return Colors.orange.shade900;
      case 'Needs Follow-up':
        return Colors.blue.shade900;
      case 'Rejected':
        return Colors.red.shade900;
      default:
        return kTextMuted;
    }
  }
}
