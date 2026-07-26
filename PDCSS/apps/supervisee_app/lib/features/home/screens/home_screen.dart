import 'package:flutter/material.dart';
import 'package:supervisee_app/features/checkin/screens/checkin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _DashboardTab(),
    CheckInScreen(),
    _ScheduleTab(),
    _ProfileTab(),
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
            label: 'ہوم / Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.fingerprint_outlined),
            selectedIcon: Icon(Icons.fingerprint),
            label: 'حاضری / Check-In',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'شیڈول / Schedule',
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

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('پنجاب ڈیجیٹل نگہداشت / PDCSS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compliance Status Card
            Card(
              color: const Color(0xFFF0FDF4),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Semantics(
                      label: 'Compliance status: Compliant',
                      child: const Icon(Icons.check_circle, color: Colors.green, size: 48),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('حالت / Status',
                              style: TextStyle(fontSize: 13, color: Colors.black54)),
                          SizedBox(height: 4),
                          Text('تعمیل کنندہ\nCompliant',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Next Check-In Alert
            Card(
              child: ListTile(
                leading: Semantics(
                  label: 'Next check-in icon',
                  child: const Icon(Icons.schedule, color: Color(0xFF0F766E), size: 36),
                ),
                title: const Text('اگلی حاضری / Next Check-In',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('آج شام 5:00 بجے تک / By 5:00 PM today'),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 44),
                  ),
                  onPressed: () {},
                  child: const Text('جائیں\nGo'),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Recent Activity
            const Text('حالیہ سرگرمی / Recent Activity',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _ActivityTile(
              icon: Icons.check_circle_outline,
              color: Colors.green,
              label: 'ڈیجیٹل حاضری مکمل\nCheck-In Submitted',
              time: 'کل / Yesterday 2:30 PM',
              statusLabel: 'تصدیق شدہ / Verified',
            ),
            const SizedBox(height: 8),
            _ActivityTile(
              icon: Icons.event_available,
              color: const Color(0xFF0F766E),
              label: 'دفتری ملاقات\nOffice Appointment',
              time: '22 جولائی / 22 July 2026',
              statusLabel: 'مکمل / Completed',
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String time;
  final String statusLabel;

  const _ActivityTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.time,
    required this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(label, style: const TextStyle(fontSize: 14)),
        subtitle: Text(time, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        trailing: Chip(
          label: Text(statusLabel, style: const TextStyle(fontSize: 11, color: Colors.white)),
          backgroundColor: color,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class _ScheduleTab extends StatelessWidget {
  const _ScheduleTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('شیڈول / Upcoming Schedule')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _ScheduleItem(
            dateLabel: '28 جولائی / 28 Jul',
            typeLabel: 'ڈیجیٹل حاضری / Digital Check-In',
            timeLabel: '5:00 PM',
            isUrgent: true,
          ),
          const SizedBox(height: 12),
          _ScheduleItem(
            dateLabel: '1 اگست / 1 Aug',
            typeLabel: 'دفتری ملاقات / Office Visit',
            timeLabel: '10:00 AM',
            isUrgent: false,
          ),
          const SizedBox(height: 12),
          _ScheduleItem(
            dateLabel: '7 اگست / 7 Aug',
            typeLabel: 'بحالی پروگرام / Rehab Session',
            timeLabel: '2:00 PM',
            isUrgent: false,
          ),
        ],
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final String dateLabel;
  final String typeLabel;
  final String timeLabel;
  final bool isUrgent;

  const _ScheduleItem({
    required this.dateLabel,
    required this.typeLabel,
    required this.timeLabel,
    required this.isUrgent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isUrgent ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
          child: Icon(
            isUrgent ? Icons.priority_high : Icons.event,
            color: isUrgent ? const Color(0xFFB91C1C) : const Color(0xFF0F766E),
          ),
        ),
        title: Text(typeLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text('$dateLabel — $timeLabel'),
        trailing: isUrgent
            ? const Chip(
                label: Text('ضروری\nUrgent', style: TextStyle(fontSize: 10, color: Colors.white)),
                backgroundColor: Color(0xFFB91C1C),
              )
            : null,
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('پروفائل / My Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Color(0xFF0F766E),
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text('محمد علی / Muhammad Ali',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const Center(
            child: Text('LHR-2026-089 · Probation',
                style: TextStyle(color: Colors.black54)),
          ),
          const SizedBox(height: 24),
          _ProfileRow(icon: Icons.badge_outlined, label: 'شناختی کارڈ / CNIC', value: '35202-******-1'),
          _ProfileRow(icon: Icons.category_outlined, label: 'نوعیت / Type', value: 'پروبیشن / Probation'),
          _ProfileRow(icon: Icons.person_outline, label: 'افسر / Officer', value: 'طاہر محمود / Tahir Mahmood'),
          _ProfileRow(icon: Icons.phone_outlined, label: 'رابطہ / Contact', value: '0300-******7'),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ProfileRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0F766E), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
