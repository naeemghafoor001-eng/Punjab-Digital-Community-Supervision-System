import 'package:flutter/material.dart';
import 'package:officer_app/core/theme/officer_app_theme.dart';
import 'package:officer_app/features/caseload/screens/caseload_screen.dart';
import 'package:officer_app/features/alerts/screens/alerts_screen.dart';
import 'package:officer_app/features/field_visit/screens/field_visit_screen.dart';
import 'package:officer_app/core/backend/raahnuma_backend_service.dart';
import 'package:officer_app/core/backend/models.dart';

class OfficerHomeScreen extends StatefulWidget {
  const OfficerHomeScreen({Key? key}) : super(key: key);

  @override
  State<OfficerHomeScreen> createState() => _OfficerHomeScreenState();
}

class _OfficerHomeScreenState extends State<OfficerHomeScreen> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _OfficerDashboardTab(onNavigateToTab: _navigateToTab),
      const CaseloadScreen(),
      const _CheckInReviewScreen(),
      const AlertsScreen(),
      const FieldVisitPlannerScreen(),
      const _OfficerProfileTab(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: kGovWhite,
        indicatorColor: kGovGreenSurface,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: kGovGreen),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_shared_outlined),
            selectedIcon: Icon(Icons.folder_shared, color: kGovGreen),
            label: 'Caseload',
          ),
          NavigationDestination(
            icon: Icon(Icons.fact_check_outlined),
            selectedIcon: Icon(Icons.fact_check, color: kGovGreen),
            label: 'Check-Ins',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications_active, color: kGovGreen),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_walk_outlined),
            selectedIcon: Icon(Icons.directions_walk, color: kGovGreen),
            label: 'Visits',
          ),
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge, color: kGovGreen),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN OFFICER DASHBOARD TAB
// ─────────────────────────────────────────────────────────────────────────────
class _OfficerDashboardTab extends StatefulWidget {
  final Function(int) onNavigateToTab;
  const _OfficerDashboardTab({required this.onNavigateToTab, Key? key})
      : super(key: key);

  @override
  State<_OfficerDashboardTab> createState() => _OfficerDashboardTabState();
}

class _OfficerDashboardTabState extends State<_OfficerDashboardTab> {
  late Future<List<SuperviseeBrief>> _casesFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _casesFuture = RaahnumaBackendService.instance.getAssignedCases();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SuperviseeBrief>>(
      future: _casesFuture,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: Column(
            children: [
              const DepartmentalAppBar(screenTitle: 'Executive Operational Dashboard'),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _loadData();
                    });
                  },
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Officer Identity Card ────────────────────────
                        _buildOfficerIdentityCard(),
                        const SizedBox(height: 18),

                        // ── 8 Executive Summary Cards ────────────────────
                        const SectionHeading(
                          title: 'Caseload Metrics & Operational Status',
                          icon: Icons.analytics_outlined,
                        ),
                        _buildSummaryMetricsGrid(context),
                        const SizedBox(height: 20),

                        // ── Today's Priorities Section ───────────────────
                        const SectionHeading(
                          title: "Today's Priorities & Action Items",
                          icon: Icons.checklist_outlined,
                        ),
                        _buildTodayPrioritiesCard(),
                        const SizedBox(height: 20),

                        // ── Rehabilitation & Reintegration Referrals ────
                        const SectionHeading(
                          title: 'Rehabilitation & Reintegration Referrals',
                          icon: Icons.volunteer_activism_outlined,
                        ),
                        _buildRehabReferralsCard(),
                        const SizedBox(height: 20),

                        // ── Reports Summary Panel ────────────────────────
                        const SectionHeading(
                          title: 'Monthly Supervision Reports Summary',
                          icon: Icons.assessment_outlined,
                        ),
                        _buildReportsSummaryCard(),
                        const SizedBox(height: 20),

                        // ── Recent Activity / Timeline ───────────────────
                        const SectionHeading(
                          title: 'Recent Audit Activity & Case Log',
                          icon: Icons.history_outlined,
                        ),
                        _buildRecentActivityList(),
                        const SizedBox(height: 24),

                        // ── Safeguard Footnote ───────────────────────────
                        Center(
                          child: Text(
                            'Public prototype using fictional records for review and presentation purposes.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOfficerIdentityCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: kGovGreen, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: kGovGreen,
              child: Icon(Icons.person_pin, size: 34, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Officer Tahir Mahmood',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: kTextDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Senior Probation & Parole Officer · District ID: LHR-OFF-104',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: kGovGreen,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'District Office: Lahore Central Office, Home Department',
                    style: TextStyle(
                      fontSize: 11,
                      color: kTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryMetricsGrid(BuildContext context) {
    final wide = MediaQuery.of(context).size.width > 600;
    return GridView.count(
      crossAxisCount: wide ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: wide ? 2.4 : 1.6,
      children: [
        _buildMetricTile(
          title: 'Assigned Cases',
          value: '48',
          subtext: 'Active Caseload',
          icon: Icons.folder_shared,
          color: kGovGreen,
          onTap: () => widget.onNavigateToTab(1),
        ),
        _buildMetricTile(
          title: 'Due Today',
          value: '6',
          subtext: 'Scheduled Reporting',
          icon: Icons.today,
          color: const Color(0xFF1565C0),
          onTap: () => widget.onNavigateToTab(1),
        ),
        _buildMetricTile(
          title: 'Pending Check-Ins',
          value: '4',
          subtext: 'Awaiting Review',
          icon: Icons.fact_check,
          color: const Color(0xFFD97706),
          onTap: () => widget.onNavigateToTab(2),
        ),
        _buildMetricTile(
          title: 'Open Alerts',
          value: '3',
          subtext: 'Review Triggers',
          icon: Icons.warning_amber_rounded,
          color: const Color(0xFFDC2626),
          onTap: () => widget.onNavigateToTab(3),
        ),
        _buildMetricTile(
          title: 'Field Visits Due',
          value: '5',
          subtext: 'Home/Office Visits',
          icon: Icons.directions_walk,
          color: const Color(0xFF0284C7),
          onTap: () => widget.onNavigateToTab(4),
        ),
        _buildMetricTile(
          title: 'High Risk Cases',
          value: '7',
          subtext: 'Enhanced Oversight',
          icon: Icons.shield_outlined,
          color: const Color(0xFF7C3AED),
          onTap: () => widget.onNavigateToTab(1),
        ),
        _buildMetricTile(
          title: 'Referrals Pending',
          value: '4',
          subtext: 'Rehab Support',
          icon: Icons.volunteer_activism,
          color: const Color(0xFF059669),
          onTap: () => widget.onNavigateToTab(0),
        ),
        _buildMetricTile(
          title: 'Completed Reviews',
          value: '38',
          subtext: 'Processed this Month',
          icon: Icons.task_alt,
          color: const Color(0xFF0F5A47),
          onTap: () => widget.onNavigateToTab(2),
        ),
      ],
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required String subtext,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1.5,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: color.withAlpha(20),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(icon, color: color, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 1),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtext,
                style: const TextStyle(
                  fontSize: 9,
                  color: kTextMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayPrioritiesCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPriorityItem(
              icon: Icons.fact_check,
              color: const Color(0xFFD97706),
              title: 'Review Submitted Check-Ins',
              subtitle: '4 digital reporting check-ins submitted today require officer verification.',
              actionLabel: 'Review (4)',
              onPressed: () => widget.onNavigateToTab(2),
            ),
            const Divider(height: 18),
            _buildPriorityItem(
              icon: Icons.warning_amber_rounded,
              color: const Color(0xFFDC2626),
              title: 'Address Active Supervision Alerts',
              subtitle: '1 missed reporting alert for Tariq Mehmood (LHR-2026-089) pending review.',
              actionLabel: 'Alerts (3)',
              onPressed: () => widget.onNavigateToTab(3),
            ),
            const Divider(height: 18),
            _buildPriorityItem(
              icon: Icons.directions_walk,
              color: const Color(0xFF0284C7),
              title: 'Conduct Scheduled Field Visits',
              subtitle: '2 home visits scheduled in Model Town & Gulberg sector today.',
              actionLabel: 'Visits (5)',
              onPressed: () => widget.onNavigateToTab(4),
            ),
            const Divider(height: 18),
            _buildPriorityItem(
              icon: Icons.volunteer_activism,
              color: const Color(0xFF059669),
              title: 'Follow Up Rehabilitation Referrals',
              subtitle: 'Verify TEVTA vocational training attendance for Muhammad Usama.',
              actionLabel: 'View Plan',
              onPressed: () => widget.onNavigateToTab(1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String actionLabel,
    required VoidCallback onPressed,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: color.withAlpha(25),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: kTextDark),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: kTextMuted),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: color,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            minimumSize: Size.zero,
          ),
          child: Text(
            actionLabel,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildRehabReferralsCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Active Reintegration & Support Referrals',
              style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: kGovGreen),
            ),
            const SizedBox(height: 12),
            _buildRehabRow(
              title: 'TEVTA Vocational Skills Training',
              category: 'Employment Support',
              supervisee: 'Muhammad Usama (LHR-2026-042)',
              status: 'Enrolled',
              statusColor: Colors.green,
            ),
            const Divider(height: 16),
            _buildRehabRow(
              title: 'District Addiction & Mental Health Support',
              category: 'Counselling',
              supervisee: 'Ali Raza (LHR-2026-118)',
              status: 'In Progress',
              statusColor: Colors.blue,
            ),
            const Divider(height: 16),
            _buildRehabRow(
              title: 'Bait-ul-Mal Financial Welfare Assistance',
              category: 'Welfare Support',
              supervisee: 'Shahid Iqbal (LHR-2026-091)',
              status: 'Approved',
              statusColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRehabRow({
    required String title,
    required String category,
    required String supervisee,
    required String status,
    required Color statusColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: kTextDark),
              ),
              const SizedBox(height: 1),
              Text(
                '$category · $supervisee',
                style: const TextStyle(fontSize: 11, color: kTextMuted),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: statusColor.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: statusColor.withAlpha(80)),
          ),
          child: Text(
            status,
            style: TextStyle(
                fontSize: 10,
                color: statusColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildReportsSummaryCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _buildReportStatItem('38', 'Check-Ins\nReviewed', kGovGreen),
            ),
            Container(width: 1, height: 40, color: Colors.grey.shade300),
            Expanded(
              child: _buildReportStatItem('24', 'Office Visits\nCompleted', Colors.blue.shade700),
            ),
            Container(width: 1, height: 40, color: Colors.grey.shade300),
            Expanded(
              child: _buildReportStatItem('3', 'Alerts\nResolved', Colors.purple.shade700),
            ),
            Container(width: 1, height: 40, color: Colors.grey.shade300),
            Expanded(
              child: _buildReportStatItem('5', 'Rehab\nReferrals', Colors.orange.shade800),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportStatItem(String count, String label, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: kTextMuted, height: 1.2),
        ),
      ],
    );
  }

  Widget _buildRecentActivityList() {
    return Column(
      children: [
        _buildActivityRow(
          icon: Icons.check_circle_outline,
          color: kGovGreen,
          text: 'Officer Tahir Mahmood verified check-in for Tariq Mehmood (LHR-2026-089)',
          time: 'Today at 10:15 AM',
        ),
        const SizedBox(height: 8),
        _buildActivityRow(
          icon: Icons.warning_amber_rounded,
          color: const Color(0xFFDC2626),
          text: 'Reporting alert triggered for Usman Ahmed (LHR-2026-014)',
          time: 'Today at 09:30 AM',
        ),
        const SizedBox(height: 8),
        _buildActivityRow(
          icon: Icons.directions_walk,
          color: const Color(0xFF0284C7),
          text: 'Field visit report recorded for Muhammad Usama (LHR-2026-042)',
          time: 'Yesterday at 03:45 PM',
        ),
        const SizedBox(height: 8),
        _buildActivityRow(
          icon: Icons.volunteer_activism,
          color: const Color(0xFF059669),
          text: 'TEVTA skill referral status updated to Enrolled',
          time: '24 July 2026',
        ),
      ],
    );
  }

  Widget _buildActivityRow({
    required IconData icon,
    required Color color,
    required String text,
    required String time,
  }) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: color.withAlpha(25),
          child: Icon(icon, color: color, size: 18),
        ),
        title: Text(
          text,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: kTextDark),
        ),
        subtitle: Text(
          time,
          style: const TextStyle(fontSize: 10.5, color: kTextMuted),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 3: CHECK-IN REVIEW SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class _CheckInReviewScreen extends StatefulWidget {
  const _CheckInReviewScreen({Key? key}) : super(key: key);

  @override
  State<_CheckInReviewScreen> createState() => _CheckInReviewScreenState();
}

class _CheckInReviewScreenState extends State<_CheckInReviewScreen> {
  List<CheckInRecord> _checkIns = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCheckIns();
  }

  Future<void> _loadCheckIns() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await RaahnumaBackendService.instance.getSubmittedCheckIns();
      setState(() {
        _checkIns = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load check-in submissions.';
        _isLoading = false;
      });
    }
  }

  void _markReviewed(CheckInRecord record) async {
    setState(() => _isLoading = true);
    try {
      await RaahnumaBackendService.instance.reviewCheckIn(
        record.id,
        record.superviseeId,
        record.scheduledReportingDate,
        record.receiptNumber,
      );
      await _loadCheckIns();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Check-in for ${record.superviseeName} marked as Reviewed.'),
            backgroundColor: kGovGreen,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update check-in status.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          const DepartmentalAppBar(screenTitle: 'Digital Check-In Verification'),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kGovGreen),
                    ),
                  )
                : _errorMessage != null
                    ? Center(
                        child: Text(_errorMessage!,
                            style: const TextStyle(color: Colors.red)),
                      )
                    : _checkIns.isEmpty
                        ? const Center(
                            child: Text(
                              'No pending check-ins for review.',
                              style: TextStyle(color: kTextMuted),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadCheckIns,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _checkIns.length,
                              itemBuilder: (context, i) {
                                final item = _checkIns[i];
                                return _buildCheckInCard(item);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInCard(CheckInRecord item) {
    final isReviewed = item.isReviewed;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.superviseeName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kTextDark,
                        ),
                      ),
                      Text(
                        'Receipt: ${item.receiptNumber} · District: Lahore',
                        style: const TextStyle(fontSize: 11.5, color: kGovGreen, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isReviewed
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isReviewed ? Colors.green : Colors.amber,
                    ),
                  ),
                  child: Text(
                    isReviewed ? 'Reviewed' : 'Awaiting Review',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: isReviewed
                          ? Colors.green.shade800
                          : Colors.amber.shade900,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Text(
              'Submitted: ${item.submittedAt} · Reporting Date: ${item.scheduledReportingDate}',
              style: const TextStyle(fontSize: 11, color: kTextMuted),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildAnswerRow('Residing at approved address?', item.residingAtAddress),
                  _buildAnswerRow('Changed employment status?', !item.changedEmployment),
                  _buildAnswerRow('Requested PP&PS assistance?', item.needAssistance, isPositive: true),
                  _buildAnswerRow('Complying with rules?', item.complyingConditions),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: isReviewed ? null : () => _markReviewed(item),
                  icon: const Icon(Icons.check, size: 16, color: Colors.white),
                  label: Text(isReviewed ? 'Reviewed' : 'Mark Reviewed', style: const TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGovGreen,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    minimumSize: Size.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerRow(String question, bool isPassed, {bool isPositive = false}) {
    final textColor = isPositive
        ? kGovGreen
        : isPassed
            ? Colors.green.shade800
            : Colors.red.shade800;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(question, style: const TextStyle(fontSize: 11.5, color: kTextDark)),
          Text(
            isPassed ? 'Yes' : 'No',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 6: OFFICER PROFILE & SETTINGS
// ─────────────────────────────────────────────────────────────────────────────
class _OfficerProfileTab extends StatelessWidget {
  const _OfficerProfileTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          const DepartmentalAppBar(screenTitle: 'Officer Credentials & Settings'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: kGovGreen,
                    child: Icon(Icons.person, size: 48, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Officer Tahir Mahmood',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: kTextDark),
                  ),
                ),
                const Center(
                  child: Text(
                    'Senior Probation & Parole Officer',
                    style: TextStyle(
                        color: kGovGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: const [
                        _ProfileInfoRow(
                            icon: Icons.badge_outlined,
                            label: 'Officer ID',
                            value: 'LHR-OFF-104'),
                        Divider(),
                        _ProfileInfoRow(
                            icon: Icons.business_outlined,
                            label: 'District Office',
                            value: 'Lahore Central Office, Home Dept'),
                        Divider(),
                        _ProfileInfoRow(
                            icon: Icons.folder_shared_outlined,
                            label: 'Assigned Active Cases',
                            value: '48 Active Supervisees'),
                        Divider(),
                        _ProfileInfoRow(
                            icon: Icons.security_outlined,
                            label: 'Access Authorization',
                            value: 'Level 3 — Field Officer Access'),
                        Divider(),
                        _ProfileInfoRow(
                            icon: Icons.language_outlined,
                            label: 'System Language',
                            value: 'English (Official Administrative)'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Card(
                  color: const Color(0xFFFFFBF0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: kGovGold),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Public prototype using fictional records for review and presentation purposes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF854D0E),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ProfileInfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: kGovGreen, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        const TextStyle(fontSize: 10.5, color: kTextMuted)),
                const SizedBox(height: 1),
                Text(value,
                    style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: kTextDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
