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
  final String _superviseeId = 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f';

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
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(128),
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

                // Calculate 7 required summary metrics
                final dueTodayCount = activities
                    .where((a) => a.dueTime != null || a.frequency == 'Daily')
                    .length;
                final pendingReviewCount = activities
                    .where((a) => a.reviewStatus == 'Pending Review')
                    .length;
                final acceptedCount = activities
                    .where((a) => a.reviewStatus == 'Accepted')
                    .length;
                final needsFollowUpCount = activities
                    .where((a) => a.reviewStatus == 'Needs Follow-up')
                    .length;
                final gpsRequiredCount =
                    activities.where((a) => a.requiresLocation).length;
                final photoRequiredCount =
                    activities.where((a) => a.requiresPhoto).length;
                final livenessRequiredCount =
                    activities.where((a) => a.requiresLiveness).length;

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Supervisee Banner
                      _buildOverviewBanner(profile),
                      const SizedBox(height: 14),

                      // Top Summary Cards Section (7 Metrics)
                      const Text(
                        'Activity Status Summary / خلاصہ سرگرمیاں',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 8),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _SummaryMetricBadge(
                              label: 'Due Today',
                              urduLabel: 'آج کی سرگرمی',
                              count: dueTodayCount,
                              color: Colors.amber.shade900,
                              backgroundColor: const Color(0xFFFEF3C7),
                              icon: Icons.today,
                            ),
                            const SizedBox(width: 8),
                            _SummaryMetricBadge(
                              label: 'Pending Review',
                              urduLabel: 'زیرِ جائزہ',
                              count: pendingReviewCount,
                              color: Colors.blue.shade900,
                              backgroundColor: const Color(0xFFEFF6FF),
                              icon: Icons.pending_actions,
                            ),
                            const SizedBox(width: 8),
                            _SummaryMetricBadge(
                              label: 'Accepted',
                              urduLabel: 'منظور شدہ',
                              count: acceptedCount,
                              color: Colors.green.shade800,
                              backgroundColor: const Color(0xFFDCFCE7),
                              icon: Icons.check_circle_outline,
                            ),
                            const SizedBox(width: 8),
                            _SummaryMetricBadge(
                              label: 'Needs Follow-up',
                              urduLabel: 'پیروی درکار',
                              count: needsFollowUpCount,
                              color: Colors.purple.shade800,
                              backgroundColor: const Color(0xFFF3E8FF),
                              icon: Icons.contact_support_outlined,
                            ),
                            const SizedBox(width: 8),
                            _SummaryMetricBadge(
                              label: 'GPS Required',
                              urduLabel: 'جی پی ایس درکار',
                              count: gpsRequiredCount,
                              color: const Color(0xFF0F5A47),
                              backgroundColor: const Color(0xFFF0F7F4),
                              icon: Icons.gps_fixed,
                            ),
                            const SizedBox(width: 8),
                            _SummaryMetricBadge(
                              label: 'Photo Required',
                              urduLabel: 'تصویر درکار',
                              count: photoRequiredCount,
                              color: const Color(0xFF157A62),
                              backgroundColor: const Color(0xFFE6F4F1),
                              icon: Icons.camera_alt_outlined,
                            ),
                            const SizedBox(width: 8),
                            _SummaryMetricBadge(
                              label: 'Liveness Required',
                              urduLabel: 'لائیو نیس درکار',
                              count: livenessRequiredCount,
                              color: const Color(0xFF334155),
                              backgroundColor: const Color(0xFFF1F5F9),
                              icon: Icons.face_outlined,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // List Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Lawful Assigned Activities',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Chip(
                            label: Text(
                              '${activities.length} Assigned',
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
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
              radius: 20,
              backgroundColor: const Color(0xFF0F5A47).withAlpha(30),
              child: const Icon(Icons.assignment,
                  color: Color(0xFF0F5A47), size: 22),
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
            // Top Row: Category & Review Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(10),
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
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: reviewColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: reviewColor, width: 0.8),
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
            const SizedBox(height: 8),

            // Activity Title
            Text(
              activity.activityTitle,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),

            // Instructions
            if (activity.instructions.isNotEmpty) ...[
              Text(
                activity.instructions,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
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
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    Icons.history_toggle_off,
                    'Last Submitted / گزشتہ ترسیل',
                    activity.lastSubmittedDate ?? 'Not Yet Submitted',
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
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 15, color: Color(0xFF0F5A47)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Expected Location: ${activity.expectedLocationName}',
                      style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155)),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 10),
            // Verification indicators bar
            Row(
              children: [
                const Text(
                  'Requirements: ',
                  style: TextStyle(
                      fontSize: 10.5,
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
                    style: TextStyle(fontSize: 10.5, color: Colors.black54),
                  ),
              ],
            ),
            const SizedBox(height: 12),

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
                    fontSize: 12.5,
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
        Icon(icon, size: 14, color: const Color(0xFF64748B)),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 9.5, color: Colors.black54),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
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
            Icon(Icons.fingerprint, color: Color(0xFF475569), size: 22),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '“Biometric verification may be considered in a restricted pilot after legal, administrative and cybersecurity approval.”\n'
                'قانونی، انتظامی اور سائبر سیکیورٹی منظوری کے بعد پائلٹ میں بائیو میٹرک تصدیق پر غور کیا جا سکتا ہے۔',
                style: TextStyle(
                  fontSize: 10,
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
        return Colors.amber.shade900;
      case 'Needs Follow-up':
        return Colors.purple.shade800;
      case 'Rejected':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade700;
    }
  }
}

class _SummaryMetricBadge extends StatelessWidget {
  final String label;
  final String urduLabel;
  final int count;
  final Color color;
  final Color backgroundColor;
  final IconData icon;

  const _SummaryMetricBadge({
    required this.label,
    required this.urduLabel,
    required this.count,
    required this.color,
    required this.backgroundColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(76)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label: $count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                urduLabel,
                style: const TextStyle(fontSize: 8.5, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
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
          Icon(icon, size: 10, color: const Color(0xFF1D4ED8)),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
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
        bottom: 12,
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
                width: 42,
                height: 42,
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
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: hasBackend
                      ? const Color(0xFF065F46)
                      : const Color(0xFF92400E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  hasBackend ? 'Online' : 'Demo Mode',
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
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                urduTitle,
                style: const TextStyle(
                    fontSize: 12.5,
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
            fontWeight: FontWeight.w600,
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
