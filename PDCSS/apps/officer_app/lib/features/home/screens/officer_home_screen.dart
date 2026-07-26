import 'package:flutter/material.dart';
import 'package:officer_app/features/enrolment/screens/enrolment_screen.dart';
import 'package:officer_app/features/assessment/screens/rna_screen.dart';
import 'package:officer_app/features/violation/screens/violation_screen.dart';
import 'package:officer_app/features/caseload/screens/caseload_screen.dart';

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
    OfficerEnrolmentScreen(),
    _OfficerProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'ڈیش بورڈ / Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'کیسز / Caseload',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_add_outlined),
            selectedIcon: Icon(Icons.person_add),
            label: 'اندراج / Enrol',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'پروفائل / Profile',
          ),
        ],
      ),
    );
  }
}

class _OfficerDashboardTab extends StatelessWidget {
  const _OfficerDashboardTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D9488),
        title: const Text('پنجاب پروبیشن / Officer Dashboard', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
            tooltip: 'Alerts',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _MetricCard('کل کیسز\nTotal Cases', '87', Colors.teal, Icons.people),
                const SizedBox(width: 12),
                _MetricCard('آج کی حاضری\nCheck-Ins Today', '74', Colors.green, Icons.check_circle_outline),
                const SizedBox(width: 12),
                _MetricCard('زیرِ التواء\nPending Alerts', '3', Colors.orange, Icons.warning_amber),
              ],
            ),
            const SizedBox(height: 24),
            const Text('فوری کارروائی / Quick Actions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _QuickAction(
                    icon: Icons.assignment_outlined,
                    label: 'رسک تشخیص\nRNA Assessment',
                    color: const Color(0xFF0D9488),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RNAScreen()),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.report_problem_outlined,
                    label: 'خلاف ورزی\nViolation Report',
                    color: const Color(0xFFB91C1C),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ViolationScreen()),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  const _MetricCard(this.title, this.value, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 11, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 36),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _OfficerProfileTab extends StatelessWidget {
  const _OfficerProfileTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D9488),
        title: const Text('افسر پروفائل / Officer Profile', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Color(0xFF0D9488),
              child: Icon(Icons.badge, size: 56, color: Colors.white),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Text('طاہر محمود / Tahir Mahmood',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Center(
            child: Text('پروبیشن افسر / Probation Officer — District Lahore',
                style: TextStyle(color: Colors.black54, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
