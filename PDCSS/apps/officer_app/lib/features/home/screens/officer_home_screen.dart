import 'package:flutter/material.dart';
import 'package:officer_app/core/theme/officer_app_theme.dart';
import 'package:officer_app/features/caseload/screens/caseload_screen.dart';
import 'package:officer_app/features/contact/screens/contact_recording_screen.dart';
import 'package:officer_app/features/alerts/screens/alerts_screen.dart';
import 'package:officer_app/features/field_visit/screens/field_visit_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Root shell with bottom navigation
// ─────────────────────────────────────────────────────────────────────────────
class OfficerHomeScreen extends StatefulWidget {
  const OfficerHomeScreen({Key? key}) : super(key: key);

  @override
  State<OfficerHomeScreen> createState() => _OfficerHomeScreenState();
}

class _OfficerHomeScreenState extends State<OfficerHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _OfficerDashboardTab(),
    CaseloadScreen(),
    AlertsScreen(),
    FieldVisitPlannerScreen(),
    _OfficerProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: kGovWhite,
        indicatorColor: kGovGreenSurface,
        height: 62,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: kGovGreenMid),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_open_outlined),
            selectedIcon: Icon(Icons.folder_open, color: kGovGreenMid),
            label: 'Cases',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications_active, color: kGovGreenMid),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_walk_outlined),
            selectedIcon: Icon(Icons.directions_walk, color: kGovGreenMid),
            label: 'Field Visits',
          ),
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge, color: kGovGreenMid),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dashboard Tab
// ─────────────────────────────────────────────────────────────────────────────
class _OfficerDashboardTab extends StatelessWidget {
  const _OfficerDashboardTab();

  static const _metrics = [
    _MetricData(
      title: 'Assigned Cases',
      value: '124',
      icon: Icons.folder_shared_outlined,
      color: kGovGreen,
      note: 'Active caseload',
    ),
    _MetricData(
      title: 'Due Today',
      value: '18',
      icon: Icons.today_outlined,
      color: Color(0xFF1565C0),
      note: 'Appointments today',
    ),
    _MetricData(
      title: 'Missed Check-Ins',
      value: '6',
      icon: Icons.event_busy_outlined,
      color: Color(0xFFC62828),
      note: 'Require follow-up',
    ),
    _MetricData(
      title: 'Pending Field Visits',
      value: '5',
      icon: Icons.directions_walk_outlined,
      color: Color(0xFFE65100),
      note: 'Scheduled this week',
    ),
    _MetricData(
      title: 'Risk Assessments',
      value: '9',
      icon: Icons.analytics_outlined,
      color: Color(0xFF4527A0),
      note: 'Overdue reviews',
    ),
    _MetricData(
      title: 'Alerts',
      value: '3',
      icon: Icons.warning_amber_outlined,
      color: Color(0xFFBF360C),
      note: 'Requiring review',
    ),
  ];

  static const _priorities = [
    'Review all missed check-ins and initiate follow-up contacts.',
    'Complete pending field visit plans and confirm appointment times.',
    'Update Risk and Needs Assessments for overdue cases.',
    'Record contact notes from this week\'s office reporting sessions.',
  ];

  static const _recentActivity = [
    _ActivityItem(
      icon: Icons.edit_note,
      color: kGovGreen,
      text: 'Office visit recorded for DEMO-PB-0001',
      time: 'Today, 10:15 AM',
    ),
    _ActivityItem(
      icon: Icons.check_circle_outline,
      color: Color(0xFF1565C0),
      text: 'Digital check-in reviewed for DEMO-PB-0007',
      time: 'Today, 09:42 AM',
    ),
    _ActivityItem(
      icon: Icons.directions_walk,
      color: Color(0xFFE65100),
      text: 'Field visit scheduled for DEMO-PR-0003',
      time: 'Yesterday, 04:00 PM',
    ),
    _ActivityItem(
      icon: Icons.analytics_outlined,
      color: Color(0xFF4527A0),
      text: 'Risk assessment due for DEMO-PB-0012',
      time: 'Yesterday, 02:30 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F0),
      body: Column(
        children: [
          // ── Departmental Header ──────────────────────────────────────────
          _DashboardHeader(),

          // ── Scrollable Content ───────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Metric Cards
                  const SectionHeading(
                    title: 'Caseload Overview',
                    icon: Icons.bar_chart_outlined,
                  ),
                  GridView.count(
                    crossAxisCount: wide ? 3 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: wide ? 3.0 : 2.2,
                    children:
                        _metrics.map((m) => _MetricCard(data: m)).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Today's Priorities
                  const SectionHeading(
                    title: "Today's Priorities",
                    icon: Icons.checklist_outlined,
                  ),
                  ..._priorities.asMap().entries.map(
                        (e) => _PriorityRow(index: e.key + 1, text: e.value),
                      ),
                  const SizedBox(height: 20),

                  // Recent Case Activity
                  const SectionHeading(
                    title: 'Recent Case Activity',
                    icon: Icons.history_outlined,
                  ),
                  ..._recentActivity.map((a) => _ActivityRow(item: a)),
                  const SizedBox(height: 20),

                  // Quick Actions
                  const SectionHeading(
                    title: 'Quick Actions',
                    icon: Icons.flash_on_outlined,
                  ),
                  _QuickActionsGrid(),
                  const SizedBox(height: 24),

                  // Discreet footer note
                  Center(
                    child: Text(
                      'Sample interface with fictional records for review and presentation purposes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dashboard Header (non-AppBar custom header)
// ─────────────────────────────────────────────────────────────────────────────
class _DashboardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGovGreen, kGovGreenMid],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
              color: Color(0x3300000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // PP&PS Logo
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.asset(
                      'assets/images/ppps_logo.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.account_balance,
                        color: kGovGreenMid,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Department titles
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Punjab Probation and Parole Service',
                      style: TextStyle(
                        color: kGovWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Home Department, Government of the Punjab',
                      style: TextStyle(
                          color: Color(0xFFB9F6CA), fontSize: 11, height: 1.3),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Officer Supervision Dashboard',
                      style: TextStyle(
                          color: Color(0xFF81C784), fontSize: 10, height: 1.3),
                    ),
                  ],
                ),
              ),

              // Notification + officer chip
              Column(
                children: [
                  Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.notifications_outlined,
                          color: kGovWhite, size: 22),
                      onPressed: () => Navigator.push(
                        ctx,
                        MaterialPageRoute(builder: (_) => const AlertsScreen()),
                      ),
                      tooltip: 'Supervision Alerts',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: kGovGreen,
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: const Color(0xFF81C784), width: 1),
                    ),
                    child: const Text(
                      'Demo Officer',
                      style: TextStyle(
                          color: Color(0xFFB9F6CA),
                          fontSize: 9,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data models (private)
// ─────────────────────────────────────────────────────────────────────────────
class _MetricData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String note;
  const _MetricData(
      {required this.title,
      required this.value,
      required this.icon,
      required this.color,
      required this.note});
}

class _ActivityItem {
  final IconData icon;
  final Color color;
  final String text;
  final String time;
  const _ActivityItem(
      {required this.icon,
      required this.color,
      required this.text,
      required this.time});
}

// ─────────────────────────────────────────────────────────────────────────────
// Metric Card
// ─────────────────────────────────────────────────────────────────────────────
class _MetricCard extends StatelessWidget {
  final _MetricData data;
  const _MetricCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: kGovWhite,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: data.color,
                    height: 1.0,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: data.color.withAlpha(20),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(data.icon, color: data.color, size: 14),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: kTextDark,
                height: 1.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              data.note,
              style: const TextStyle(
                fontSize: 8,
                color: kTextMuted,
                height: 1.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Priority Row
// ─────────────────────────────────────────────────────────────────────────────
class _PriorityRow extends StatelessWidget {
  final int index;
  final String text;
  const _PriorityRow({required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: kGovGreenSurface,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: kGovGreenMid),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style:
                  const TextStyle(fontSize: 13, color: kTextDark, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Activity Row
// ─────────────────────────────────────────────────────────────────────────────
class _ActivityRow extends StatelessWidget {
  final _ActivityItem item;
  const _ActivityRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: item.color.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item.icon, color: item.color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.text,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: kTextDark)),
                const SizedBox(height: 2),
                Text(item.time,
                    style: const TextStyle(fontSize: 11, color: kTextMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick Actions Grid
// ─────────────────────────────────────────────────────────────────────────────
class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      _QAData(Icons.folder_open_outlined, 'View Assigned Cases', kGovGreen,
          () => _navigate(context, const CaseloadScreen())),
      _QAData(
          Icons.edit_note_outlined,
          'Record Contact',
          const Color(0xFF1565C0),
          () => _navigate(context, const ContactRecordingScreen())),
      _QAData(
          Icons.notifications_outlined,
          'Review Alerts',
          const Color(0xFFC62828),
          () => _navigate(context, const AlertsScreen())),
      _QAData(
          Icons.directions_walk_outlined,
          'Plan Field Visit',
          const Color(0xFFE65100),
          () => _navigate(context, const FieldVisitPlannerScreen())),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 3.0,
      children: actions.map((a) => _QuickActionButton(data: a)).toList(),
    );
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _QAData {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QAData(this.icon, this.label, this.color, this.onTap);
}

class _QuickActionButton extends StatelessWidget {
  final _QAData data;
  const _QuickActionButton({required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kGovWhite,
      borderRadius: BorderRadius.circular(8),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: data.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(data.icon, color: data.color, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  data.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: data.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Tab
// ─────────────────────────────────────────────────────────────────────────────
class _OfficerProfileTab extends StatelessWidget {
  const _OfficerProfileTab();

  static const _fields = [
    ['Designation', 'Probation Officer'],
    ['District', 'Lahore Demo District'],
    ['Office', 'Lahore Central Office'],
    ['Assigned Cases', '124'],
    ['Officer ID (Demo)', 'PO-LHR-DEMO-01'],
    ['Role', 'Officer App Demo User'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F0),
      body: Column(
        children: [
          DepartmentalAppBar(screenTitle: 'Officer Profile'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Avatar
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: kGovGreenSurface,
                          shape: BoxShape.circle,
                          border: Border.all(color: kGovGreenMid, width: 2),
                        ),
                        child: const Icon(Icons.badge,
                            size: 44, color: kGovGreenMid),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Demo Officer',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: kTextDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Probation Officer · Lahore Central Office',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Punjab Probation and Parole Service',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Details card
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        for (var i = 0; i < _fields.length; i++) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    _fields[i][0],
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: kTextMuted,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    _fields[i][1],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: kTextDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (i < _fields.length - 1)
                            Divider(height: 1, color: Colors.grey.shade100),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Sample data for interface preview.',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade400,
                        fontStyle: FontStyle.italic),
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
