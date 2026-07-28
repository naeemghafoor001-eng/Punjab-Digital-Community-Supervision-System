import 'package:flutter/material.dart';
import 'package:supervisee_app/core/backend/models.dart';
import 'package:supervisee_app/core/backend/raahnuma_backend_service.dart';
import 'package:supervisee_app/core/backend/supabase_config.dart';
import 'package:supervisee_app/features/activities/widgets/attendance_submission_dialog.dart';

class AssignedActivitiesScreen extends StatefulWidget {
  const AssignedActivitiesScreen({Key? key}) : super(key: key);

  @override
  State<AssignedActivitiesScreen> createState() =>
      _AssignedActivitiesScreenState();
}

class _AssignedActivitiesScreenState extends State<AssignedActivitiesScreen> {
  late Future<List<AssignedActivityModel>> _activitiesFuture;
  late Future<SuperviseeProfile> _profileFuture;
  String _superviseeId = 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _profileFuture = RaahnumaBackendService.instance.getProfile();
    _activitiesFuture =
        RaahnumaBackendService.instance.getAssignedActivities(_superviseeId);
  }

  Future<void> _refresh() async {
    setState(() {
      _loadData();
    });
  }

  void _openAttendanceSubmission(
      BuildContext context, AssignedActivityModel activity) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AttendanceSubmissionDialog(
        activity: activity,
        superviseeId: _superviseeId,
      ),
    );

    if (result == true) {
      _refresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Verified attendance record submitted. Pending officer review.'),
            backgroundColor: Color(0xFF0F5A47),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SuperviseeProfile>(
      future: _profileFuture,
      builder: (context, profileSnapshot) {
        final profile = profileSnapshot.data ?? SuperviseeProfile.fallback();

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(132),
            child: _ActivitiesHeader(
              title: 'Assigned Activities',
              urduTitle: 'تفویض کردہ سرگرمیاں',
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: FutureBuilder<List<AssignedActivityModel>>(
              future: _activitiesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF0F5A47)),
                    ),
                  );
                }

                final activities = snapshot.data ?? [];

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Overview Banner
                      _buildOverviewBanner(profile),
                      const SizedBox(height: 16),

                      // Section Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Lawful Assigned Activities',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Chip(
                            label: Text(
                              '${activities.length} Assigned',
                              style: const TextStyle(
                                  fontSize: 10.5, fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: const Color(0xFFEFF6FF),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      if (activities.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Text(
                              'No assigned activities found.',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: activities.length,
                          itemBuilder: (context, index) {
                            return _buildActivityCard(
                                context, activities[index]);
                          },
                        ),

                      const SizedBox(height: 16),
                      // Future Biometric Placeholder Note
                      _buildBiometricPlaceholderCard(),
                      const SizedBox(height: 16),
                      const _ActivitiesFooter(),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildOverviewBanner(SuperviseeProfile profile) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFF0F5A47).withAlpha(25),
              child: const Icon(Icons.assignment,
                  color: Color(0xFF0F5A47), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Supervisee: ${profile.fullName}',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Case: ${profile.caseNumber} | Officer: ${profile.officerName}',
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(
      BuildContext context, AssignedActivityModel activity) {
    final reviewColor = _getReviewColor(activity.reviewStatus);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Category & Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    activity.activityCategory,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F5A47),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: reviewColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: reviewColor),
                  ),
                  child: Text(
                    'Review: ${activity.reviewStatus}',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: reviewColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Activity Title
            Text(
              activity.activityTitle,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),

            // Instructions
            if (activity.instructions.isNotEmpty) ...[
              Text(
                activity.instructions,
                style: const TextStyle(fontSize: 12.5, color: Colors.black87),
              ),
              const SizedBox(height: 8),
            ],

            const Divider(height: 16),

            // Details Grid
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    Icons.repeat,
                    'Frequency / تعدد',
                    activity.frequency,
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    Icons.access_time,
                    'Due Time / وقت',
                    activity.dueTime ?? 'Anytime',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    Icons.date_range,
                    'Start Date / تاریخ آغاز',
                    activity.startDate,
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    Icons.event,
                    'End Date / تاریخ اختتام',
                    activity.endDate,
                  ),
                ),
              ],
            ),

            if (activity.expectedLocationName != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 16, color: Color(0xFF0F5A47)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Expected Location: ${activity.expectedLocationName}',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155)),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),
            // Verification indicators bar
            Row(
              children: [
                const Text(
                  'Requirements: ',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                if (activity.requiresLocation)
                  const _SmallReqChip(label: 'GPS', icon: Icons.gps_fixed),
                if (activity.requiresPhoto)
                  const _SmallReqChip(label: 'Photo', icon: Icons.camera_alt),
                if (activity.requiresLiveness)
                  const _SmallReqChip(label: 'Liveness', icon: Icons.face),
                if (!activity.requiresLocation &&
                    !activity.requiresPhoto &&
                    !activity.requiresLiveness)
                  const Text(
                    'Standard Check',
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
              ],
            ),
            const SizedBox(height: 14),

            // Submit Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
                backgroundColor: const Color(0xFF0F5A47),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.verified_user_outlined,
                  color: Colors.white, size: 18),
              label: const Text(
                'Submit Verified Attendance / تصدیق شدہ حاضری جمع کروائیں',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onPressed: () => _openAttendanceSubmission(context, activity),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: const Color(0xFF64748B)),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBiometricPlaceholderCard() {
    return Card(
      elevation: 1,
      color: const Color(0xFFF8FAFC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: const [
            Icon(Icons.fingerprint, color: Color(0xFF475569), size: 24),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '“Biometric verification may be considered in a restricted pilot after legal, administrative and cybersecurity approval.”\n'
                'قانونی، انتظامی اور سائبر سیکیورٹی منظوری کے بعد پائلٹ میں بائیو میٹرک تصدیق پر غور کیا جا سکتا ہے۔',
                style: TextStyle(
                  fontSize: 10.5,
                  color: Color(0xFF475569),
                  fontStyle: FontStyle.italic,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getReviewColor(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.green.shade800;
      case 'Pending Review':
        return Colors.orange.shade800;
      case 'Needs Follow-up':
        return Colors.blue.shade800;
      case 'Rejected':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade700;
    }
  }
}

class _SmallReqChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SmallReqChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: const Color(0xFF1D4ED8)),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E40AF),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivitiesHeader extends StatelessWidget {
  final String title;
  final String urduTitle;

  const _ActivitiesHeader({
    Key? key,
    required this.title,
    required this.urduTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasBackend = SupabaseConfig.hasBackend;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F5A47),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 14,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(2),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/ppps_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.account_balance,
                      color: Color(0xFF0F5A47),
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Punjab Probation and Parole Service',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Home Department, Government of the Punjab',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: hasBackend
                      ? const Color(0xFF065F46)
                      : const Color(0xFF92400E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  hasBackend ? 'Connected' : 'Local Demo',
                  style: const TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                urduTitle,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivitiesFooter extends StatelessWidget {
  const _ActivitiesFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Divider(),
        SizedBox(height: 4),
        Text(
          'Public prototype using fictional records for review and presentation purposes.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10.5,
            color: Colors.black54,
            fontStyle: FontStyle.italic,
          ),
        ),
        Text(
          'یہ ریویو اور پریزنٹیشن کے مقاصد کے لیے فرضی ریکارڈز کے ساتھ ایک نمونہ انٹرفیس ہے۔',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9.5,
            color: Colors.black54,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
