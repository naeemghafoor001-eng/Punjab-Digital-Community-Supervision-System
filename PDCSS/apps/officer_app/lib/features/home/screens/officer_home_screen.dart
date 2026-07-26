import 'package:flutter/material.dart';
import 'package:officer_app/features/caseload/screens/caseload_screen.dart';
import 'package:officer_app/features/contact/screens/contact_recording_screen.dart';
import 'package:officer_app/features/alerts/screens/alerts_screen.dart';
import 'package:officer_app/features/field_visit/screens/field_visit_screen.dart';

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
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Cases',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_active_outlined),
            selectedIcon: Icon(Icons.notifications_active),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_walk_outlined),
            selectedIcon: Icon(Icons.directions_walk),
            label: 'Field Visits',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
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
        title: const Text('PDCSS Officer Dashboard',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AlertsScreen()));
            },
            tooltip: 'Alerts',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Demonstration Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFF59E0B)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.science, color: Color(0xFFB45309), size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Demonstration Prototype · Punjab Probation and Parole Service',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF92400E)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Mandatory Disclaimer Card
            Card(
              color: const Color(0xFFF8FAFC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        color: Color(0xFF0D9488), size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Demonstration prototype using fictional data only. Not connected to any official PP&PS database, court record, prison system or government identity service.',
                        style: TextStyle(
                            fontSize: 11, color: Colors.black87, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Caseload & Monitoring Overview',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 12),

            // 6 Required Metric Cards Grid
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: const [
                _MetricCard(
                    'Assigned Cases', '124', Color(0xFF0D9488), Icons.people),
                _MetricCard('Due Today', '18', Colors.green, Icons.today),
                _MetricCard(
                    'Missed Check-Ins', '6', Colors.red, Icons.event_busy),
                _MetricCard('Pending Field Visits', '5', Colors.orange,
                    Icons.directions_walk),
                _MetricCard('Pending Risk Assessments', '9', Colors.indigo,
                    Icons.analytics),
                _MetricCard('Alerts Requiring Review', '3', Colors.deepOrange,
                    Icons.warning_amber),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'Officer Workflows',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _QuickAction(
                    icon: Icons.note_add_outlined,
                    label: 'Record Contact',
                    color: const Color(0xFF0D9488),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ContactRecordingScreen()),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.notifications_active_outlined,
                    label: 'Manage Alerts',
                    color: Colors.deepOrange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AlertsScreen()),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.map_outlined,
                    label: 'Field Visit Planner',
                    color: Colors.indigo,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FieldVisitPlannerScreen()),
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: color)),
                Icon(icon, color: color, size: 24),
              ],
            ),
            const SizedBox(height: 6),
            Text(title,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500)),
          ],
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
  const _QuickAction(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

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
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600)),
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
        title: const Text('Officer Profile',
            style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: Color(0xFF0D9488),
              child: Icon(Icons.badge, size: 52, color: Colors.white),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Text('Officer Tahir Mahmood',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Center(
            child: Text('Probation Officer — District Lahore Central',
                style: TextStyle(color: Colors.black54, fontSize: 13)),
          ),
          SizedBox(height: 24),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading:
                        Icon(Icons.badge_outlined, color: Color(0xFF0D9488)),
                    title: Text('Officer ID'),
                    subtitle: Text('PO-LHR-1042'),
                  ),
                  Divider(),
                  ListTile(
                    leading:
                        Icon(Icons.business_outlined, color: Color(0xFF0D9488)),
                    title: Text('Jurisdiction'),
                    subtitle: Text('Lahore Central Division'),
                  ),
                  Divider(),
                  ListTile(
                    leading:
                        Icon(Icons.cases_outlined, color: Color(0xFF0D9488)),
                    title: Text('Active Caseload'),
                    subtitle:
                        Text('124 Active Cases (88 Probation, 36 Parole)'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
