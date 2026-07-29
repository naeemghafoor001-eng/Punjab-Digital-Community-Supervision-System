import 'package:flutter/material.dart';
import 'package:supervisee_app/features/checkin/screens/checkin_screen.dart';
import 'package:supervisee_app/features/activities/screens/assigned_activities_screen.dart';
import 'package:supervisee_app/features/plan/screens/supervision_plan_screen.dart';
import 'package:supervisee_app/core/backend/raahnuma_backend_service.dart';
import 'package:supervisee_app/core/backend/supabase_config.dart';
import 'package:supervisee_app/core/backend/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: _ProfileContent(scrollController: scrollController),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _DashboardTab(
        onNavigateToTab: _navigateToTab,
        onOpenProfile: () => _showProfileModal(context),
      ),
      const CheckInScreen(),
      const AssignedActivitiesScreen(),
      const SupervisionPlanScreen(),
      const _ScheduleTab(),
      const _HelpTab(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home / ہوم',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: 'Check-In / حاضری',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Activities / سرگرمیاں',
          ),
          NavigationDestination(
            icon: Icon(Icons.stars_outlined),
            selectedIcon: Icon(Icons.stars),
            label: 'Plan / منصوبہ',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Schedule / شیڈول',
          ),
          NavigationDestination(
            icon: Icon(Icons.help_outline),
            selectedIcon: Icon(Icons.help),
            label: 'Help / مدد',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE BRANDING HEADER
// ─────────────────────────────────────────────────────────────────────────────
class _BrandingHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String urduTitle;
  final VoidCallback? onProfileTap;

  const _BrandingHeader({
    Key? key,
    required this.title,
    required this.urduTitle,
    this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasBackend = SupabaseConfig.hasBackend;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F5A47), // Official green
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo in white circular container with gold border
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border:
                      Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
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
              // Official Department Titles
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
                        letterSpacing: 0.1,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Home Department, Government of the Punjab',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Raahnuma | Punjab Community Supervision System',
                      style: TextStyle(
                        fontSize: 9,
                        color: Color(0xFFFEE180),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              // Profile Icon Button & Backend status badge
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: hasBackend
                          ? const Color(0xFF065F46)
                          : const Color(0xFF92400E),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: hasBackend
                            ? const Color(0xFF34D399)
                            : const Color(0xFFFBBF24),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      hasBackend ? 'Online' : 'Demo Mode',
                      style: const TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (onProfileTap != null) ...[
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(Icons.account_circle,
                          color: Colors.white, size: 28),
                      tooltip: 'View Profile',
                      onPressed: onProfileTap,
                    ),
                  ],
                ],
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                urduTitle,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(128);
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE FOOTER DISCLAIMER
// ─────────────────────────────────────────────────────────────────────────────
class _FooterDisclaimer extends StatelessWidget {
  const _FooterDisclaimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: const [
          Divider(),
          SizedBox(height: 6),
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
          SizedBox(height: 2),
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
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 1: HOME DASHBOARD
// ─────────────────────────────────────────────────────────────────────────────
class _DashboardTab extends StatefulWidget {
  final Function(int) onNavigateToTab;
  final VoidCallback onOpenProfile;

  const _DashboardTab({
    required this.onNavigateToTab,
    required this.onOpenProfile,
    Key? key,
  }) : super(key: key);

  @override
  State<_DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<_DashboardTab> {
  late Future<SuperviseeProfile> _profileFuture;
  late Future<List<AssignedActivityModel>> _activitiesFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _profileFuture = RaahnumaBackendService.instance.getProfile();
    _activitiesFuture = RaahnumaBackendService.instance
        .getAssignedActivities('f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SuperviseeProfile>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            appBar: _BrandingHeader(
              title: 'Raahnuma Dashboard',
              urduTitle: 'نگہداشت ڈیش بورڈ',
            ),
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F5A47)),
              ),
            ),
          );
        }
        final profile = snapshot.data ?? SuperviseeProfile.fallback();

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _loadData();
            });
          },
          child: Scaffold(
            appBar: _BrandingHeader(
              title: 'Raahnuma Dashboard',
              urduTitle: 'نگہداشت ڈیش بورڈ',
              onProfileTap: widget.onOpenProfile,
            ),
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Supervisee Profile Banner
                  _buildSuperviseeBanner(context, profile),
                  const SizedBox(height: 16),

                  // Section Title: 9 Required Home Cards
                  const Text(
                    'Supervision Status & Overview / خلاصہ نگہداشت',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Grid / Row of the 9 required dashboard cards
                  FutureBuilder<List<AssignedActivityModel>>(
                    future: _activitiesFuture,
                    builder: (context, actSnapshot) {
                      final activities = actSnapshot.data ?? [];
                      final dueTodayCount = activities
                          .where((a) =>
                              a.dueTime != null || a.frequency == 'Daily')
                          .length;
                      final pendingReviewCount = activities
                          .where((a) => a.reviewStatus == 'Pending Review')
                          .length;

                      return Column(
                        children: [
                          // Top 3 Primary Status Cards
                          Row(
                            children: [
                              Expanded(
                                child: _DashboardCard(
                                  icon: Icons.shield_outlined,
                                  title: 'Supervision Status',
                                  urduTitle: 'حیثیت نگہداشت',
                                  value: profile.complianceStatus,
                                  accentColor: const Color(0xFF0F5A47),
                                  badgeColor: const Color(0xFFDCFCE7),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _DashboardCard(
                                  icon: Icons.calendar_month,
                                  title: 'Next Reporting Date',
                                  urduTitle: 'اگلی حاضری تاریخ',
                                  value: profile.nextReportingDate,
                                  accentColor: const Color(0xFF0F5A47),
                                  isHighlight: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Middle 3 Cards
                          Row(
                            children: [
                              Expanded(
                                child: _DashboardCard(
                                  icon: Icons.person_pin_outlined,
                                  title: 'Assigned Officer',
                                  urduTitle: 'مقررہ پروبیشن افسر',
                                  value: profile.officerName,
                                  accentColor: const Color(0xFF157A62),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _DashboardCard(
                                  icon: Icons.business_outlined,
                                  title: 'District Office',
                                  urduTitle: 'ڈسٹرکٹ دفتر',
                                  value: profile.district,
                                  accentColor: const Color(0xFF334155),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Expanded(
                                child: _DashboardCard(
                                  icon: Icons.timer_outlined,
                                  title: 'Probation End Date',
                                  urduTitle: 'اختتامِ پروبیشن',
                                  value: profile.supervisionEndDate,
                                  accentColor: const Color(0xFF0F5A47),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _DashboardCard(
                                  icon: Icons.task_alt,
                                  title: "Today's Required Actions",
                                  urduTitle: 'آج کے اقدامات',
                                  value: '$dueTodayCount Action(s) Due',
                                  accentColor: Colors.orange.shade900,
                                  badgeColor: const Color(0xFFFEF3C7),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Bottom 3 Cards
                          Row(
                            children: [
                              Expanded(
                                child: _DashboardCard(
                                  icon: Icons.pending_actions,
                                  title: 'Pending Attendance',
                                  urduTitle: 'زیرِ جائزہ حاضری',
                                  value: '$pendingReviewCount Pending Review',
                                  accentColor: Colors.blue.shade900,
                                  badgeColor: const Color(0xFFEFF6FF),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _DashboardCard(
                                  icon: Icons.check_circle_outline,
                                  title: 'Pending Check-In',
                                  urduTitle: 'چیک ان صورتحال',
                                  value: 'Check-In Recorded',
                                  accentColor: Colors.green.shade800,
                                  badgeColor: const Color(0xFFDCFCE7),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Full Width Plan Progress Card
                          Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: const Color(0xFF0F5A47)
                                        .withAlpha(30),
                                    child: const Icon(Icons.stars,
                                        color: Color(0xFF0F5A47), size: 22),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Supervision Plan Progress / منصوبہ پیشرفت',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          '3 Goals Active | On Track for Rehabilitation',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: const Color(0xFF0F5A47)),
                                    ),
                                    child: const Text(
                                      'Active',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F5A47),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // ── Quick Actions ───────────────────────────────────────────
                  const Text(
                    'Quick Actions / فوری اقدامات',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Primary Large Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            backgroundColor: const Color(0xFF0F5A47),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.check_circle_outline,
                              color: Colors.white, size: 18),
                          label: const Text(
                            'Submit Check-In\nحاضری جمع کروائیں',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          onPressed: () => widget.onNavigateToTab(1),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            backgroundColor: const Color(0xFF157A62),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.assignment_outlined,
                              color: Colors.white, size: 18),
                          label: const Text(
                            'Assigned Activities\nتفویض کردہ سرگرمیاں',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          onPressed: () => widget.onNavigateToTab(2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Secondary Quick Action Cards
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionTile(
                          icon: Icons.calendar_month,
                          title: 'Schedule',
                          urduTitle: 'شیڈول',
                          color: const Color(0xFF157A62),
                          onTap: () => widget.onNavigateToTab(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _QuickActionTile(
                          icon: Icons.person_outline,
                          title: 'Profile',
                          urduTitle: 'پروفائل',
                          color: const Color(0xFF0F172A),
                          onTap: widget.onOpenProfile,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _QuickActionTile(
                          icon: Icons.help_outline,
                          title: 'Help',
                          urduTitle: 'مدد',
                          color: const Color(0xFFD4AF37),
                          onTap: () => widget.onNavigateToTab(5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ── Recent Activity Section ─────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Recent Case Activity / حالیہ سرگرمی',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Icon(Icons.history, color: Colors.black54, size: 18),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const _ActivityTile(
                    icon: Icons.check_circle,
                    color: Colors.green,
                    title: 'Digital Check-In / ڈیجیٹل حاضری رپورٹ',
                    time: 'Yesterday 2:30 PM / کل دوپہر 2:30',
                    statusLabel: 'Verified / تصدیق شدہ',
                  ),
                  const SizedBox(height: 6),
                  const _ActivityTile(
                    icon: Icons.event_available,
                    color: Color(0xFF0F5A47),
                    title: 'Office Reporting / دفتری حاضری',
                    time: '22 July 2026 / 22 جولائی 2026',
                    statusLabel: 'Completed / مکمل',
                  ),
                  const SizedBox(height: 6),
                  const _ActivityTile(
                    icon: Icons.school,
                    color: Colors.blue,
                    title: 'TEVTA Skills Session / فنی تربیت',
                    time: '20 July 2026 / 20 جولائی 2026',
                    statusLabel: 'Attended / حاضری مکمل',
                  ),
                  const _FooterDisclaimer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuperviseeBanner(
      BuildContext context, SuperviseeProfile profile) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFF0F5A47),
              child: const Icon(Icons.person, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.fullName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Case Ref / کیس نمبر: ${profile.caseNumber}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF0F5A47),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Category / نوعیت: ${profile.supervisionCategory}',
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.shade600),
              ),
              child: Text(
                profile.complianceStatus,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DASHBOARD CARD WIDGET
// ─────────────────────────────────────────────────────────────────────────────
class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String urduTitle;
  final String value;
  final Color accentColor;
  final Color? badgeColor;
  final bool isHighlight;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.urduTitle,
    required this.value,
    required this.accentColor,
    this.badgeColor,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isHighlight ? 3 : 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isHighlight ? const Color(0xFF0F5A47) : Colors.grey.shade200,
          width: isHighlight ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: accentColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              urduTitle,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 9.5, color: Colors.black45),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: isHighlight
                    ? const Color(0xFF0F5A47)
                    : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String urduTitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.urduTitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          child: Column(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: color.withAlpha(30),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                urduTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 9.5, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String time;
  final String statusLabel;

  const _ActivityTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.time,
    required this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(38),
          radius: 16,
          child: Icon(icon, color: color, size: 18),
        ),
        title: Text(title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A))),
        subtitle: Text(time,
            style: const TextStyle(fontSize: 10.5, color: Colors.black54)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: color.withAlpha(38),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            statusLabel,
            style: TextStyle(
                fontSize: 9, color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 5: SCHEDULE SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class _ScheduleTab extends StatelessWidget {
  const _ScheduleTab();

  void _showRescheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.edit_calendar, color: Color(0xFF0F5A47)),
              SizedBox(width: 10),
              Text('Reschedule Request / تبدیلی وقت'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Demonstration Mode / ڈیمو وضع:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
              SizedBox(height: 6),
              Text(
                'In production, this submits a formal request to your probation officer Tahir Mahmood. No external message was sent.',
                style: TextStyle(fontSize: 12, height: 1.4),
              ),
              SizedBox(height: 6),
              Text(
                'حقیقی ماحول میں یہ آپ کے پروبیشن افسر طاہر محمود کو تبدیلی وقت کی درخواست ارسال کرتا ہے۔',
                style:
                    TextStyle(fontSize: 11, color: Colors.black54, height: 1.4),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK / ٹھیک ہے',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _BrandingHeader(
        title: 'Reporting Schedule',
        urduTitle: 'حاضری شیڈول',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions Banner
            Card(
              color: const Color(0xFFEFF6FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.blue, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Reporting Instructions / حاضری ہدایات',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Please report punctually for your scheduled appointments. Bring your original CNIC and supervision case card.\nبراہِ کرم مقررہ وقت پر تشریف لائیں۔ اپنا اصل شناختی کارڈ اور کیس کارڈ ساتھ رکھیں۔',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Calendar-Style Cards Section
            const Text(
              'Schedule Calendar & Reminders / شیڈول اور یاد دہانیاں',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 10),

            // Card 1: Next Reporting Date
            _buildCalendarCard(
              dayNumber: '28',
              monthYear: 'JUL 2026',
              dayName: 'TUESDAY',
              titleEn: 'Next Office Reporting Date',
              titleUr: 'اگلی دفتری حاضری تاریخ',
              timeLocEn: '10:00 AM @ Lahore Central Office',
              badgeText: 'Mandatory',
              badgeColor: Colors.red.shade800,
              onTapAction: () => _showRescheduleDialog(context),
            ),
            const SizedBox(height: 10),

            // Card 2: Upcoming Appointment
            _buildCalendarCard(
              dayNumber: '05',
              monthYear: 'AUG 2026',
              dayName: 'WEDNESDAY',
              titleEn: 'Bi-Weekly Officer Progress Review',
              titleUr: 'پروبیشن افسر کے ساتھ پیشرفت جائزہ',
              timeLocEn: '11:30 AM @ District Office Room 4',
              badgeText: 'Upcoming',
              badgeColor: const Color(0xFF0F5A47),
            ),
            const SizedBox(height: 10),

            // Card 3: Activity Due Dates
            _buildCalendarCard(
              dayNumber: '10',
              monthYear: 'AUG 2026',
              dayName: 'MONDAY',
              titleEn: 'TEVTA Vocational Certificate Assessment',
              titleUr: 'ٹیوٹا ووکیشنل الیکٹریشن جائزہ',
              timeLocEn: '02:00 PM @ TEVTA Center Lahore',
              badgeText: 'Activity Due',
              badgeColor: Colors.blue.shade800,
            ),
            const SizedBox(height: 10),

            // Card 4: Plan Review Date
            _buildCalendarCard(
              dayNumber: '15',
              monthYear: 'SEP 2026',
              dayName: 'TUESDAY',
              titleEn: 'Formal Supervision Plan Review Date',
              titleUr: 'نگرانی منصوبے کی جائزہ تاریخ',
              timeLocEn: 'Official Case Review with Parole Officer',
              badgeText: 'Plan Review',
              badgeColor: Colors.purple.shade800,
            ),
            const SizedBox(height: 10),

            // Card 5: Court / Legal Reminders (if available)
            _buildCalendarCard(
              dayNumber: '14',
              monthYear: 'NOV 2026',
              dayName: 'SATURDAY',
              titleEn: 'Supervision Completion & Final Court Report',
              titleUr: 'پروبیشن معیاد اختتام اور عدالت کی حتمی رپورٹ',
              timeLocEn: 'Formal Probation Completion Review',
              badgeText: 'Legal Reminder',
              badgeColor: const Color(0xFFD4AF37),
            ),

            const _FooterDisclaimer(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard({
    required String dayNumber,
    required String monthYear,
    required String dayName,
    required String titleEn,
    required String titleUr,
    required String timeLocEn,
    required String badgeText,
    required Color badgeColor,
    VoidCallback? onTapAction,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Calendar Left Block
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F5A47),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    monthYear,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFEE180),
                    ),
                  ),
                  Text(
                    dayNumber,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    dayName,
                    style: const TextStyle(
                      fontSize: 8,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Right Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          titleEn,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: badgeColor, width: 0.8),
                        ),
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: badgeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    titleUr,
                    style:
                        const TextStyle(fontSize: 10.5, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 13, color: Color(0xFF0F5A47)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          timeLocEn,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF334155)),
                        ),
                      ),
                    ],
                  ),
                  if (onTapAction != null) ...[
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: onTapAction,
                      child: Row(
                        children: const [
                          Icon(Icons.edit_calendar,
                              size: 13, color: Color(0xFF0F5A47)),
                          SizedBox(width: 4),
                          Text(
                            'Request Reschedule / تبدیلی وقت',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF0F5A47),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 6: HELP SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class _HelpTab extends StatelessWidget {
  const _HelpTab();

  void _showCallSimulation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.phone_in_talk, color: Color(0xFF0F5A47)),
              SizedBox(width: 10),
              Text('Call Helpline / ہیلپ لائن کال'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Dialing Helpline: 0800-00000',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
              ),
              SizedBox(height: 6),
              Text(
                'Demonstration Mode / ڈیمو وضع:\nIn production, this initiates a toll-free call to the PP&PS Central Office Helpline.',
                style: TextStyle(fontSize: 12, height: 1.4),
              ),
              SizedBox(height: 6),
              Text(
                'حقیقی ماحول میں یہ پی پی اینڈ پی ایس ہیلپ لائن پر ٹول فری کال شروع کرتا ہے۔',
                style:
                    TextStyle(fontSize: 11, color: Colors.black54, height: 1.4),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK / ٹھیک ہے',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _BrandingHeader(
        title: 'Help & Guidance',
        urduTitle: 'مدد اور معلومات',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // How-To Guidance Card
            Card(
              elevation: 2,
              color: const Color(0xFFF0F7F4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFF0F5A47), width: 1.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.help_center,
                            color: Color(0xFF0F5A47), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'App Instructions & Guidance / رہنمائی',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F5A47),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 18),
                    _HelpGuideBullet(
                      titleEn: '1. How to Submit Check-In',
                      titleUr: 'حاضری کیسے جمع کریں؟',
                      bodyEn:
                          'Open Check-In tab, confirm your details, answer the 4 questions, review summary, and click Submit.',
                      bodyUr:
                          'حاضری ٹیب کھولیں، تفصیلات چیک کریں، سوالات کا جواب دیں اور تصدیق کریں۔',
                    ),
                    SizedBox(height: 10),
                    _HelpGuideBullet(
                      titleEn: '2. How to Submit Verified Attendance',
                      titleUr: 'تصدیق شدہ حاضری کیسے دیں؟',
                      bodyEn:
                          'Open Activities tab, select the activity, accept the consent notice, allow single GPS capture, take photo/liveness prompt if required, and submit.',
                      bodyUr:
                          'سرگرمیاں ٹیب کھولیں، سرگرمی منتخب کریں اور جی پی ایس/تصویر کے ساتھ جمع کریں۔',
                    ),
                    SizedBox(height: 10),
                    _HelpGuideBullet(
                      titleEn: '3. What to do if GPS Fails',
                      titleUr: 'جی پی ایس ناکام ہونے پر کیا کریں؟',
                      bodyEn:
                          'Ensure Location Service (GPS) is turned ON in phone settings. If issue persists, submit attendance and notify your officer.',
                      bodyUr:
                          'فون سیٹنگز میں لوکیشن آن کریں۔ اگر مسئلہ رہے تو آفیسر کو اطلاع دیں۔',
                    ),
                    SizedBox(height: 10),
                    _HelpGuideBullet(
                      titleEn: '4. What to do if Camera Fails',
                      titleUr: 'کیمرہ کام نہ کرے تو کیا کریں؟',
                      bodyEn:
                          'Click "Camera Unavailable" option in the photo step. Your attendance will be submitted for manual officer review.',
                      bodyUr:
                          'کیمرہ دستیاب نہیں پر کلک کریں۔ آپ کی حاضری آفیسر جائزہ کے لیے چلی جائے گی۔',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Official Contacts Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Official Contacts / اہم رابطے',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F5A47),
                      ),
                    ),
                    const Divider(height: 18),
                    _buildHelpContactRow(
                      Icons.person_pin,
                      'Assigned Probation Officer / مقررہ پروبیشن افسر',
                      'Officer Tahir Mahmood (0300-1234567 Demo)',
                    ),
                    const SizedBox(height: 10),
                    _buildHelpContactRow(
                      Icons.business,
                      'District Supervision Office / ڈسٹرکٹ دفتر',
                      'Lahore Central Office, Home Department, Lahore',
                    ),
                    const SizedBox(height: 10),
                    _buildHelpContactRow(
                      Icons.phone_in_talk,
                      'PP&PS Toll-Free Helpline / مرکزی ہیلپ لائن',
                      '0800-00000 (Toll-Free / ٹول فری)',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Call Helpline Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5A47),
                minimumSize: const Size(double.infinity, 48),
              ),
              icon: const Icon(Icons.phone_in_talk, color: Colors.white),
              label: const Text('Call Helpline / ہیلپ لائن پر کال کریں'),
              onPressed: () => _showCallSimulation(context),
            ),
            const SizedBox(height: 16),

            // Emergency Disclaimer & Data Privacy Note
            Card(
              color: const Color(0xFFFFFBEB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFFFDE68A)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.privacy_tip_outlined,
                            color: Color(0xFFD97706), size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Emergency Disclaimer & Privacy Note',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '• Emergency Disclaimer: In medical or urgent emergencies, seek medical help immediately and inform your probation officer as soon as possible.\n'
                      '• Data Privacy Note: Your location is captured ONLY ONCE at the exact time of attendance submission. No background tracking or continuous monitoring takes place.',
                      style: TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF78350F),
                          height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const _FooterDisclaimer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpContactRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF0F5A47), size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HelpGuideBullet extends StatelessWidget {
  final String titleEn;
  final String titleUr;
  final String bodyEn;
  final String bodyUr;

  const _HelpGuideBullet({
    required this.titleEn,
    required this.titleUr,
    required this.bodyEn,
    required this.bodyUr,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titleEn,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A))),
            Text(titleUr,
                style:
                    const TextStyle(fontSize: 10.5, color: Color(0xFF0F5A47))),
          ],
        ),
        const SizedBox(height: 2),
        Text(bodyEn,
            style: const TextStyle(fontSize: 11, color: Color(0xFF334155))),
        Text(bodyUr,
            style: const TextStyle(fontSize: 10, color: Colors.black54)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PROFILE CONTENT SHEET / TAB
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileContent extends StatelessWidget {
  final ScrollController? scrollController;

  const _ProfileContent({this.scrollController, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SuperviseeProfile>(
      future: RaahnumaBackendService.instance.getProfile(),
      builder: (context, snapshot) {
        final profile = snapshot.data ?? SuperviseeProfile.fallback();

        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(18),
          children: [
            const Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: Color(0xFF0F5A47),
                child: Icon(Icons.person, size: 44, color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                profile.fullName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            Center(
              child: Text(
                'Case Ref / کیس نمبر: ${profile.caseNumber}',
                style: const TextStyle(
                  color: Color(0xFF0F5A47),
                  fontWeight: FontWeight.bold,
                  fontSize: 12.5,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Profile Details Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _buildProfileItem(
                      Icons.badge_outlined,
                      'Masked CNIC / شناختی کارڈ',
                      profile.cnicMasked,
                    ),
                    const Divider(),
                    _buildProfileItem(
                      Icons.assignment_outlined,
                      'Case Reference / کیس نمبر',
                      profile.caseNumber,
                    ),
                    const Divider(),
                    _buildProfileItem(
                      Icons.category_outlined,
                      'Supervision Category / نوعیتِ نگرانی',
                      profile.supervisionCategory,
                    ),
                    const Divider(),
                    _buildProfileItem(
                      Icons.check_circle_outline,
                      'Compliance Status / تعمیل حیثیت',
                      profile.complianceStatus,
                    ),
                    const Divider(),
                    _buildProfileItem(
                      Icons.person_pin_outlined,
                      'Assigned Officer / مقررہ پروبیشن افسر',
                      profile.officerName,
                    ),
                    const Divider(),
                    _buildProfileItem(
                      Icons.business_outlined,
                      'District Office / ڈسٹرکٹ دفتر',
                      '${profile.officeAddress} (${profile.district})',
                    ),
                    const Divider(),
                    _buildProfileItem(
                      Icons.calendar_today,
                      'Supervision Start Date / آغازِ تاریخ',
                      profile.supervisionStartDate,
                    ),
                    const Divider(),
                    _buildProfileItem(
                      Icons.timer_outlined,
                      'Supervision End Date / اختتامِ تاریخ',
                      profile.supervisionEndDate,
                    ),
                    const Divider(),
                    _buildProfileItem(
                      Icons.phone_outlined,
                      'Contact Phone / فون نمبر',
                      '0300-XXXX567 (Masked)',
                    ),
                    const Divider(),
                    _buildProfileItem(
                      Icons.email_outlined,
                      'Contact Email / ای میل',
                      profile.email.isNotEmpty
                          ? profile.email
                          : 'sup******@example.com',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Privacy Note Card
            Card(
              color: const Color(0xFFF8FAFC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.privacy_tip_outlined,
                            color: Color(0xFF0F5A47), size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Privacy Guarantee / رازداری کی ضمانت',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'CNIC is masked (35201-XXXXXXX-9) for public prototype protection. Supervisee records remain strictly confidential.',
                      style: TextStyle(
                          fontSize: 10.5, color: Colors.black54, height: 1.3),
                    ),
                  ],
                ),
              ),
            ),
            const _FooterDisclaimer(),
          ],
        );
      },
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0F5A47), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
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
