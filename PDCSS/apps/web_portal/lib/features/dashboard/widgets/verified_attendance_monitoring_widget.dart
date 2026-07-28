import 'package:flutter/material.dart';
import 'package:web_portal/core/backend/models.dart';
import 'package:web_portal/core/backend/raahnuma_portal_service.dart';

class VerifiedAttendanceMonitoringWidget extends StatefulWidget {
  const VerifiedAttendanceMonitoringWidget({Key? key}) : super(key: key);

  @override
  State<VerifiedAttendanceMonitoringWidget> createState() =>
      _VerifiedAttendanceMonitoringWidgetState();
}

class _VerifiedAttendanceMonitoringWidgetState
    extends State<VerifiedAttendanceMonitoringWidget> {
  late Future<PortalVerifiedAttendanceSummary> _summaryFuture;
  late Future<List<PortalActivityAttendanceRow>> _rowsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _summaryFuture =
        RaahnumaPortalService.instance.getVerifiedAttendanceSummary();
    _rowsFuture = RaahnumaPortalService.instance.getActivityAttendanceRows();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PortalVerifiedAttendanceSummary>(
      future: _summaryFuture,
      builder: (context, summarySnapshot) {
        if (summarySnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F5A47)),
            ),
          );
        }

        final summary =
            summarySnapshot.data ?? PortalVerifiedAttendanceSummary.fallback();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Verified Attendance Monitoring',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Provincial dashboard for assigned activities & verified attendance tracking',
                        style:
                            TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _loadData()),
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Refresh Monitoring'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Legal Safeguard Notice Banner
              _buildSafeguardNoticeCard(),
              const SizedBox(height: 20),

              // 8 Core Summary Cards
              _buildMetricsGrid(summary),
              const SizedBox(height: 24),

              // Category Breakdown Section
              _buildCategoryBreakdownCard(summary),
              const SizedBox(height: 24),

              // Attendance Submissions Monitoring Table
              const Text(
                'Recent Verified Attendance Submissions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              _buildSubmissionsTable(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSafeguardNoticeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF93C5FD)),
      ),
      child: Row(
        children: const [
          Icon(Icons.shield_outlined, color: Color(0xFF1D4ED8), size: 24),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Institutional Safeguard Note: “GPS/photo/liveness indicators support officer review and do not constitute automatic violation findings.” All electronic indicators serve exclusively for probation officer assessment and decision support in accordance with legal due process.',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E40AF),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(PortalVerifiedAttendanceSummary summary) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900 ? 4 : 2;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 2.3,
          children: [
            _buildMetricCard(
              'Active Activities',
              summary.activeAssignedActivities.toString(),
              'Assigned in System',
              Icons.assignment,
              const Color(0xFF0F5A47),
            ),
            _buildMetricCard(
              'Submitted Today',
              summary.attendanceSubmittedToday.toString(),
              'Daily Verified Count',
              Icons.check_circle_outline,
              const Color(0xFF157A62),
            ),
            _buildMetricCard(
              'Pending Reviews',
              summary.pendingAttendanceReviews.toString(),
              'Awaiting Officer Review',
              Icons.pending_actions,
              const Color(0xFFD97706),
            ),
            _buildMetricCard(
              'GPS Within Radius',
              summary.gpsWithinRadius.toString(),
              'Location Verified',
              Icons.gps_fixed,
              const Color(0xFF059669),
            ),
            _buildMetricCard(
              'GPS Outside Radius',
              summary.gpsOutsideRadius.toString(),
              'Location Alert',
              Icons.wrong_location,
              const Color(0xFFDC2626),
            ),
            _buildMetricCard(
              'GPS Unavailable',
              summary.gpsUnavailable.toString(),
              'Permission/Sensor Issue',
              Icons.location_off,
              const Color(0xFF6B7280),
            ),
            _buildMetricCard(
              'Photo Verified',
              summary.photoVerifiedSubmissions.toString(),
              'Camera Image Captured',
              Icons.camera_alt,
              const Color(0xFF2563EB),
            ),
            _buildMetricCard(
              'Liveness Completed',
              summary.livenessPromptCompleted.toString(),
              'Prompt Verified',
              Icons.face,
              const Color(0xFF7C3AED),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard(
      String title, String value, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withAlpha(25),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdownCard(PortalVerifiedAttendanceSummary summary) {
    final catMap = summary.activitiesByCategory;

    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assigned Activities by Category',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildCategoryPill('Reporting', catMap['Reporting'] ?? 45,
                    const Color(0xFF0F5A47)),
                _buildCategoryPill(
                    'Skills', catMap['Skills'] ?? 32, const Color(0xFF2563EB)),
                _buildCategoryPill('Counselling', catMap['Counselling'] ?? 26,
                    const Color(0xFF7C3AED)),
                _buildCategoryPill('Community Service',
                    catMap['Community Service'] ?? 20, const Color(0xFF059669)),
                _buildCategoryPill(
                    'Health', catMap['Health'] ?? 15, const Color(0xFFD97706)),
                _buildCategoryPill(
                    'Personal Discipline',
                    catMap['Personal Discipline'] ?? 10,
                    const Color(0xFF0284C7)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPill(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionsTable() {
    return FutureBuilder<List<PortalActivityAttendanceRow>>(
      future: _rowsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final rows = snapshot.data ?? [];

        return Card(
          elevation: 1.5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F5F9)),
              columns: const [
                DataColumn(
                    label: Text('Supervisee & Case',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Activity Title',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Category',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('GPS Status',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Distance',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Photo',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Liveness',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Review Status',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: rows.map((r) {
                return DataRow(cells: [
                  DataCell(Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(r.superviseeName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      Text(r.caseNumber,
                          style: const TextStyle(
                              fontSize: 10, color: Colors.grey)),
                    ],
                  )),
                  DataCell(Text(r.activityTitle,
                      style: const TextStyle(fontSize: 12))),
                  DataCell(Text(r.activityCategory,
                      style: const TextStyle(fontSize: 11))),
                  DataCell(Chip(
                    label: Text(r.locationMatchStatus,
                        style: const TextStyle(
                            fontSize: 9.5, color: Colors.white)),
                    backgroundColor: r.locationMatchStatus == 'Within Radius'
                        ? const Color(0xFF0F5A47)
                        : r.locationMatchStatus == 'Outside Radius'
                            ? Colors.orange.shade800
                            : Colors.grey.shade700,
                    visualDensity: VisualDensity.compact,
                  )),
                  DataCell(Text(
                    r.distanceFromExpectedMeters != null
                        ? '${r.distanceFromExpectedMeters!.toStringAsFixed(0)}m'
                        : 'N/A',
                    style: const TextStyle(fontSize: 11),
                  )),
                  DataCell(Text(r.photoStatus,
                      style: const TextStyle(fontSize: 11))),
                  DataCell(Text(r.livenessStatus,
                      style: const TextStyle(fontSize: 11))),
                  DataCell(Chip(
                    label: Text(r.reviewStatus,
                        style: const TextStyle(
                            fontSize: 9.5, fontWeight: FontWeight.bold)),
                    backgroundColor: const Color(0xFFEFF6FF),
                    visualDensity: VisualDensity.compact,
                  )),
                ]);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
