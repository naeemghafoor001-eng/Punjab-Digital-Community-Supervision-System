import 'package:flutter/material.dart';
import 'package:supervisee_app/features/checkin/screens/checkin_screen.dart';
import 'package:supervisee_app/features/activities/screens/assigned_activities_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _DashboardTab(
        onNavigateToTab: _navigateToTab,
      ),
      const CheckInScreen(),
      const AssignedActivitiesScreen(),
      const _ScheduleTab(),
      const _ProfileTab(),
      const _HelpTab(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
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
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Schedule / شیڈول',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile / پروفائل',
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

  const _BrandingHeader({
    Key? key,
    required this.title,
    required this.urduTitle,
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
        bottom: 14,
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border:
                      Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2)),
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
                      size: 26,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Official Department Titles
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Punjab Probation and Parole Service',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.1,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Home Department, Government of the Punjab',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Raahnuma | Punjab Community Supervision System',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: Color(0xFFFEE180),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              // Connection Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: hasBackend
                      ? const Color(0xFF065F46)
                      : const Color(0xFF92400E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasBackend
                        ? const Color(0xFF34D399)
                        : const Color(0xFFFBBF24),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasBackend
                            ? const Color(0xFF34D399)
                            : const Color(0xFFFBBF24),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      hasBackend ? 'Connected' : 'Local Demo',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                urduTitle,
                style: const TextStyle(
                  fontSize: 13,
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
  Size get preferredSize => const Size.fromHeight(132);
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE FOOTER DISCLAIMER
// ─────────────────────────────────────────────────────────────────────────────
class _FooterDisclaimer extends StatelessWidget {
  const _FooterDisclaimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: Column(
        children: const [
          Divider(),
          SizedBox(height: 8),
          Text(
            'Public prototype using fictional records for review and presentation purposes.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.black54,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 3),
          Text(
            'یہ ریویو اور پریزنٹیشن کے مقاصد کے لیے فرضی ریکارڈز کے ساتھ ایک نمونہ انٹرفیس ہے۔',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
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
// TAB 1: DASHBOARD
// ─────────────────────────────────────────────────────────────────────────────
class _DashboardTab extends StatefulWidget {
  final Function(int) onNavigateToTab;
  const _DashboardTab({required this.onNavigateToTab, Key? key})
      : super(key: key);

  @override
  State<_DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<_DashboardTab> {
  late Future<SuperviseeProfile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _profileFuture = RaahnumaBackendService.instance.getProfile();
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
            appBar: const _BrandingHeader(
              title: 'Raahnuma Dashboard',
              urduTitle: 'نگہداشت ڈیش بورڈ',
            ),
            body: _buildDashboard(context, profile),
          ),
        );
      },
    );
  }

  Widget _buildDashboard(BuildContext context, SuperviseeProfile profile) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Main Supervisee Summary Card ────────────────────────────────
          Card(
            elevation: 3,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Name & Status Banner
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Supervisee Name / نام',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              profile.fullName,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Case Ref / کیس نمبر: ${profile.caseNumber}',
                              style: const TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF0F5A47),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.shade600),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle,
                                size: 12, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(
                              profile.complianceStatus,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // 8 Comprehensive Fields Grid
                  _buildDashboardInfoRow(
                    Icons.category_outlined,
                    'Supervision Type / نوعیتِ نگرانی',
                    profile.supervisionCategory,
                  ),
                  const SizedBox(height: 10),
                  _buildDashboardInfoRow(
                    Icons.calendar_month,
                    'Next Reporting Date / اگلی حاضری تاریخ',
                    profile.nextReportingDate,
                    highlight: true,
                  ),
                  const SizedBox(height: 10),
                  _buildDashboardInfoRow(
                    Icons.person_outline,
                    'Assigned Officer / مقررہ پروبیشن افسر',
                    profile.officerName,
                  ),
                  const SizedBox(height: 10),
                  _buildDashboardInfoRow(
                    Icons.business_outlined,
                    'District Office / ڈسٹرکٹ دفتر',
                    profile.officeAddress,
                  ),
                  const SizedBox(height: 10),
                  _buildDashboardInfoRow(
                    Icons.timer_outlined,
                    'Supervision Expiry / اختتامِ نگرانی',
                    profile.supervisionEndDate,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Quick Action Panel ───────────────────────────────────────────
          const Text(
            'Quick Actions / فوری اقدامات',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 10),

          // Primary Large Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xFF0F5A47),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.check_circle_outline,
                      color: Colors.white, size: 20),
                  label: const Text(
                    'Submit Check-In\nحاضری جمع کروائیں',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => widget.onNavigateToTab(1),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xFF157A62),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.assignment_outlined,
                      color: Colors.white, size: 20),
                  label: const Text(
                    'Assigned Activities\nتفویض کردہ سرگرمیاں',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                child: _QuickActionCard(
                  icon: Icons.calendar_month,
                  title: 'View Schedule',
                  urduTitle: 'شیڈول دیکھیں',
                  color: const Color(0xFF157A62),
                  onTap: () => widget.onNavigateToTab(3),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.person,
                  title: 'View Profile',
                  urduTitle: 'پروفائل دیکھیں',
                  color: const Color(0xFF1E293B),
                  onTap: () => widget.onNavigateToTab(4),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  urduTitle: 'مدد',
                  color: const Color(0xFFD4AF37),
                  onTap: () => widget.onNavigateToTab(5),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Recent Activity Section ─────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Recent Case Activity / حالیہ سرگرمی',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B)),
              ),
              Icon(Icons.history, color: Colors.black54, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          _ActivityTile(
            icon: Icons.check_circle,
            color: Colors.green,
            title: 'Digital Check-In / ڈیجیٹل حاضری رپورٹ',
            time: 'Yesterday 2:30 PM / کل دوپہر 2:30',
            statusLabel: 'Verified / تصدیق شدہ',
          ),
          const SizedBox(height: 8),
          _ActivityTile(
            icon: Icons.event_available,
            color: const Color(0xFF0F5A47),
            title: 'Office Visit / دفتری ملاقات',
            time: '22 July 2026 / 22 جولائی 2026',
            statusLabel: 'Completed / مکمل',
          ),
          const SizedBox(height: 8),
          _ActivityTile(
            icon: Icons.school,
            color: Colors.blue,
            title: 'Rehab Session / بحالی سیشن',
            time: '15 July 2026 / 15 جولائی 2026',
            statusLabel: 'Attended / حاضری مکمل',
          ),
          const _FooterDisclaimer(),
        ],
      ),
    );
  }

  Widget _buildDashboardInfoRow(IconData icon, String label, String value,
      {bool highlight = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            size: 18,
            color:
                highlight ? const Color(0xFF0F5A47) : const Color(0xFF64748B)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: highlight
                      ? const Color(0xFF0F5A47)
                      : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Quick Action Card Widget
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String urduTitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
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
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: color.withAlpha(25),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B)),
              ),
              Text(
                urduTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: Colors.black54),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(25),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B))),
        subtitle: Text(time,
            style: const TextStyle(fontSize: 11, color: Colors.black54)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: color.withAlpha(38),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            statusLabel,
            style: TextStyle(
                fontSize: 9.5, color: color, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 3: SCHEDULE
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                'In production, this submits a formal request to your probation officer Tahir Mahmood. No external message was sent.',
                style: TextStyle(fontSize: 13, height: 1.4),
              ),
              SizedBox(height: 8),
              Text(
                'حقیقی ماحول میں یہ آپ کے پروبیشن افسر طاہر محمود کو تبدیلی وقت کی درخواست ارسال کرتا ہے۔',
                style:
                    TextStyle(fontSize: 12, color: Colors.black54, height: 1.4),
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
        padding: const EdgeInsets.all(18),
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
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Reporting Instructions / حاضری ہدایات',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              color: Color(0xFF1E3A8A)),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Please report punctually for your scheduled appointments. Bring your original CNIC and supervision case card.\nبراہِ کرم مقررہ وقت پر تشریف لائیں۔ اپنا اصل شناختی کارڈ اور کیس کارڈ ساتھ رکھیں۔',
                      style: TextStyle(
                          fontSize: 11.5,
                          height: 1.45,
                          color: Color(0xFF1E3A8A)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Next Scheduled Appointment / اگلی ملاقات',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFF0F5A47), width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.event_available,
                                color: Color(0xFF0F5A47), size: 20),
                            SizedBox(width: 6),
                            Text(
                              'Office Reporting / دفتری حاضری',
                              style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F5A47)),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F5A47),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Upcoming',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    _buildAppointmentRow(Icons.calendar_today,
                        'Date & Time / تاریخ و وقت: 28 July 2026 at 10:00 AM'),
                    const SizedBox(height: 8),
                    _buildAppointmentRow(Icons.location_on,
                        'Office / دفتر: Lahore Central Office / لاہور سینٹرل دفتر'),
                    const SizedBox(height: 8),
                    _buildAppointmentRow(Icons.person,
                        'Officer / افسر: Officer Tahir Mahmood / افسر طاہر محمود'),
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      icon: const Icon(Icons.edit_calendar, size: 18),
                      label: const Text(
                          'Request Reschedule / تبدیلی وقت کی درخواست'),
                      onPressed: () => _showRescheduleDialog(context),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Past Appointments / ماضی کی حاضری تاریخچہ',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 1,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(0xFFDCFCE7),
                  child: Icon(Icons.check, color: Colors.green, size: 20),
                ),
                title: Text('Initial Assessment / ابتدائی جائزہ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                subtitle: Text(
                    '15 June 2026 at 11:30 AM · Lahore Central Office',
                    style: TextStyle(fontSize: 11)),
                trailing: Text(
                  'Completed',
                  style: TextStyle(
                      fontSize: 10.5,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const _FooterDisclaimer(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF0F5A47)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF1E293B)),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 4: PROFILE
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _BrandingHeader(
        title: 'Supervisee Profile',
        urduTitle: 'زیرِ نگہداشت پروفائل',
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF0F5A47),
              child: Icon(Icons.person, size: 48, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Tariq Mehmood / طارق محمود',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B)),
            ),
          ),
          const Center(
            child: Text(
              'Case Ref / کیس نمبر: LHR-2026-089',
              style: TextStyle(
                  color: Color(0xFF0F5A47),
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
          ),
          const SizedBox(height: 20),

          // Case & Supervision Info Card
          Card(
            elevation: 2,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  _ProfileItem(
                      icon: Icons.badge_outlined,
                      label: 'CNIC / شناختی کارڈ',
                      value: '35201-xxxxxxx-x (Masked / پوشیدہ)'),
                  Divider(),
                  _ProfileItem(
                      icon: Icons.assignment_outlined,
                      label: 'Case Reference / کیس نمبر',
                      value: 'LHR-2026-089'),
                  Divider(),
                  _ProfileItem(
                      icon: Icons.category_outlined,
                      label: 'Supervision Category / نوعیتِ نگرانی',
                      value: 'Probation Order / پروبیشن حکم'),
                  Divider(),
                  _ProfileItem(
                      icon: Icons.check_circle_outline,
                      label: 'Compliance Status / تعمیل حیثیت',
                      value: 'Compliant / تعمیل کا پابند'),
                  Divider(),
                  _ProfileItem(
                      icon: Icons.person_pin_outlined,
                      label: 'Assigned Officer / مقررہ پروبیشن افسر',
                      value: 'Officer Tahir Mahmood / افسر طاہر محمود'),
                  Divider(),
                  _ProfileItem(
                      icon: Icons.business_outlined,
                      label: 'District Office / ڈسٹرکٹ دفتر',
                      value: 'Lahore Central Office / لاہور سینٹرل دفتر'),
                  Divider(),
                  _ProfileItem(
                      icon: Icons.timer_outlined,
                      label: 'Supervision Period / دورانیہ نگرانی',
                      value: '15 May 2026 – 14 Nov 2026'),
                  Divider(),
                  _ProfileItem(
                      icon: Icons.language,
                      label: 'Preferred Language / زبان',
                      value: 'Bilingual (English & Urdu / انگریزی اور اردو)'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Privacy Note
          Card(
            color: const Color(0xFFF8FAFC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.privacy_tip_outlined,
                          color: Color(0xFF0F5A47), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Privacy Guarantee / رازداری کی ضمانت',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'All supervisee records are confidential under probation regulations. Masked CNIC 35201-xxxxxxx-x and synthetic indicators are used in this demonstration.',
                    style: TextStyle(
                        fontSize: 11.5, color: Colors.black54, height: 1.4),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'تمام ریکارڈز پروبیشن قوانین کے تحت خفیہ رکھے جاتے ہیں۔ اس ڈیمو میں فرضی ڈیٹا استعمال کیا گیا ہے۔',
                    style: TextStyle(
                        fontSize: 10.5, color: Colors.black54, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          const _FooterDisclaimer(),
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ProfileItem(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0F5A47), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        const TextStyle(fontSize: 10.5, color: Colors.black54)),
                const SizedBox(height: 1),
                Text(value,
                    style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 5: HELP
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 8),
              Text(
                'Demonstration Mode / ڈیمو وضع:\nIn production, this initiates a toll-free call to the PP&PS Central Office Helpline.',
                style: TextStyle(fontSize: 12.5, height: 1.4),
              ),
              SizedBox(height: 8),
              Text(
                'حقیقی ماحول میں یہ پی پی اینڈ پی ایس ہیلپ لائن پر ٹول فری کال شروع کرتا ہے۔',
                style: TextStyle(
                    fontSize: 11.5, color: Colors.black54, height: 1.4),
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
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Formal Help Guidance Card
            Card(
              elevation: 2,
              color: const Color(0xFFF0F7F4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFF0F5A47), width: 1.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.gavel, color: Color(0xFF0F5A47), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Official Guidelines / سرکاری ہدایات',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F5A47)),
                        ),
                      ],
                    ),
                    Divider(height: 20),
                    _GuidelineBullet(
                      textEn:
                          'Contact your assigned probation officer for any correction in profile or case details.',
                      textUr:
                          'پروفائل یا کیس کی تفصیلات میں کسی تصحیح کے لیے اپنے پروبیشن افسر سے رابطہ کریں۔',
                    ),
                    SizedBox(height: 8),
                    _GuidelineBullet(
                      textEn:
                          'Attend your reporting punctually on or before scheduled dates.',
                      textUr:
                          'مقررہ تاریخوں پر وقت کی پابندی کے ساتھ حاضری یقینی بنائیں۔',
                    ),
                    SizedBox(height: 8),
                    _GuidelineBullet(
                      textEn:
                          'Do not submit false or misleading information in digital check-ins.',
                      textUr:
                          'ڈیجیٹل حاضری میں غلط یا گمراہ کن معلومات فراہم نہ کریں۔',
                    ),
                    SizedBox(height: 8),
                    _GuidelineBullet(
                      textEn:
                          'Emergency matters must be reported immediately through proper official channels.',
                      textUr:
                          'ہنگامی امور کی اطلاع فوری طور پر سرکاری ذرائع کے ذریعے دینی چاہیے۔',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Official Contacts Card
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Official Contacts / اہم رابطے',
                      style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F5A47)),
                    ),
                    const Divider(height: 20),
                    _buildHelpContactRow(
                        Icons.person_pin,
                        'Assigned Probation Officer / مقررہ پروبیشن افسر',
                        'Officer Tahir Mahmood\n0300-1234567 (Demo)'),
                    const SizedBox(height: 12),
                    _buildHelpContactRow(
                        Icons.business,
                        'District Supervision Office / ڈسٹرکٹ دفتر',
                        'Lahore Central Office, Home Department, Lahore'),
                    const SizedBox(height: 12),
                    _buildHelpContactRow(
                        Icons.phone_in_talk,
                        'PP&PS Toll-Free Helpline / مرکزی ہیلپ لائن',
                        '0800-00000 (Toll-Free / ٹول فری)'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Call Helpline Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5A47),
                minimumSize: const Size(double.infinity, 52),
              ),
              icon: const Icon(Icons.phone_in_talk, color: Colors.white),
              label: const Text('Call Helpline / ہیلپ لائن پر کال کریں'),
              onPressed: () => _showCallSimulation(context),
            ),
            const SizedBox(height: 24),

            const Text(
              'Frequently Asked Questions / عام سوالات',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 10),
            _buildFAQTile(
              'How to submit Digital Check-In? / حاضری کیسے جمع کریں؟',
              'Go to the Check-In tab, confirm your details, answer the supervision questions, review your answers, and click submit to receive a verified receipt.',
              'حاضری کے صفحے پر جائیں، تفصیلات چیک کریں، سوالات کے جواب دیں، اور تصدیق کرکے جمع کریں۔',
            ),
            _buildFAQTile(
              'What to do in case of Emergency? / ہنگامی صورتحال میں کیا کریں؟',
              'If you miss your reporting date due to a medical emergency, contact your probation officer immediately at the central district office.',
              'اگر آپ بیماری یا ہنگامی وجہ سے رپورٹ نہیں کر سکے، تو فوری پروبیشن افسر سے رابطہ کریں۔',
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
        Icon(icon, color: const Color(0xFF0F5A47), size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFAQTile(String question, String answerEn, String answerUr) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B)),
        ),
        iconColor: const Color(0xFF0F5A47),
        childrenPadding: const EdgeInsets.all(14),
        children: [
          Text(
            answerEn,
            style: const TextStyle(
                fontSize: 12, color: Color(0xFF1E293B), height: 1.4),
          ),
          const SizedBox(height: 6),
          Text(
            answerUr,
            style: const TextStyle(
                fontSize: 11, color: Colors.black54, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _GuidelineBullet extends StatelessWidget {
  final String textEn;
  final String textUr;

  const _GuidelineBullet({required this.textEn, required this.textUr});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ',
            style: TextStyle(
                color: Color(0xFF0F5A47),
                fontWeight: FontWeight.bold,
                fontSize: 14)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(textEn,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B))),
              Text(textUr,
                  style: const TextStyle(fontSize: 11, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}
