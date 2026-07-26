import 'package:flutter/material.dart';
import 'package:supervisee_app/features/checkin/screens/checkin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _DashboardTab(onNavigateToCheckIn: () {
        setState(() => _currentIndex = 1);
      }),
      const CheckInScreen(),
      const _ScheduleTab(),
      const _ProfileTab(),
    ];
  }

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
            label: 'Home / ہوم',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: 'Check-In / حاضری',
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
        ],
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  final VoidCallback onNavigateToCheckIn;
  const _DashboardTab({required this.onNavigateToCheckIn});

  void _showHelpModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.help_outline, color: Color(0xFF0F766E), size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Help & Support / مدد اور معلومات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(height: 24),
              const Text(
                'Assigned Officer / مقررہ افسر: Officer Tahir Mahmood\nDistrict Office / ڈسٹرکٹ دفتر: Lahore Central Office\nDemo Helpline / ڈیمو ہیلپ لائن: 0800-00000',
                style: TextStyle(fontSize: 14, height: 1.6),
              ),
              const SizedBox(height: 16),
              const Text(
                'Instructions / ہدایات:\n• Check-in on or before your scheduled reporting date.\n• مقررہ تاریخ پر یا اس سے پہلے اپنی حاضری مکمل کریں۔\n• Contact your officer for any emergency schedule adjustments.\n• کسی بھی ہنگامی تبدیلی کے لیے اپنے پروبیشن افسر سے رابطہ کریں۔',
                style:
                    TextStyle(fontSize: 13, color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close / بند کریں'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDCSS Supervisee / پنجاب ڈیجیٹل نگہداشت'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpModal(context),
            tooltip: 'Help / مدد',
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
                      'Demonstration Prototype / ڈیمو پروٹو ٹائپ',
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
                        color: Color(0xFF0F766E), size: 20),
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

            // Supervisee Summary Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Supervisee / زیرِ نگہداشت فرد',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Tariq Mehmood / طارق محمود',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Case Ref / کیس نمبر: LHR-2026-089',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF0F766E),
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.green),
                          ),
                          child: const Text(
                            'Compliant / تعمیل کنندہ',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 28),
                    _buildInfoRow('Next Reporting Date / اگلی حاضری',
                        '28 July 2026 / 28 جولائی 2026'),
                    _buildInfoRow('Assigned Officer / مقررہ افسر',
                        'Officer Tahir Mahmood / افسر طاہر محمود'),
                    _buildInfoRow('District Office / ڈسٹرکٹ دفتر',
                        'Lahore Central Office / لاہور سینٹرل دفتر'),
                    _buildInfoRow('Supervision Expiry / اختتامِ نگرانی',
                        '15 December 2026 / 15 دسمبر 2026'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.check_circle_outline,
                        color: Colors.white),
                    label: const Text('Check-In / حاضری'),
                    onPressed: onNavigateToCheckIn,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.help_outline,
                        color: Color(0xFF0F766E)),
                    label: const Text('Help / مدد'),
                    onPressed: () => _showHelpModal(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Activity Section
            const Text(
              'Recent Activity / حالیہ سرگرمی',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _ActivityTile(
              icon: Icons.check_circle,
              color: Colors.green,
              title: 'Digital Check-In / ڈیجیٹل حاضری',
              time: 'Yesterday 2:30 PM / کل دوپہر 2:30',
              statusLabel: 'Verified / تصدیق شدہ',
            ),
            const SizedBox(height: 8),
            _ActivityTile(
              icon: Icons.event_available,
              color: const Color(0xFF0F766E),
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
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ),
          Expanded(
            flex: 3,
            child: Text(value,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
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
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(25),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(time,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(38),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(statusLabel,
              style: TextStyle(
                  fontSize: 11, color: color, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class _ScheduleTab extends StatelessWidget {
  const _ScheduleTab();

  void _showRescheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Request Reschedule / تبدیلی وقت کی درخواست'),
          content: const Text(
            'Demonstration Mode / ڈیمو وضع:\n\nIn production, this submits a formal request to your probation officer Tahir Mahmood. No external message was sent.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK / ٹھیک ہے'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule / شیڈول'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions Banner
            Card(
              color: const Color(0xFFEFF6FF),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Instructions / ہدایات',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please report punctually for your scheduled appointments. Bring your original CNIC and case card.\nبراہِ کرم مقررہ وقت پر تشریف لائیں۔ اپنا اصل شناختی کارڈ اور کیس کارڈ ساتھ رکھیں۔',
                      style: TextStyle(fontSize: 12, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Upcoming Appointment / اگلی ملاقات',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFF0F766E), width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Office Reporting / دفتری حاضری',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F766E)),
                        ),
                        Chip(
                          label: Text('Upcoming',
                              style:
                                  TextStyle(fontSize: 11, color: Colors.white)),
                          backgroundColor: Color(0xFF0F766E),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 16, color: Colors.black54),
                        SizedBox(width: 8),
                        Text(
                            '28 July 2026 at 10:00 AM / 28 جولائی 2026 - صبح 10:00',
                            style: TextStyle(fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 16, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('Lahore Central Office / لاہور سینٹرل دفتر',
                            style: TextStyle(fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      children: [
                        Icon(Icons.person, size: 16, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('Officer Tahir Mahmood / افسر طاہر محمود',
                            style: TextStyle(fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.edit_calendar, size: 18),
                        label: const Text(
                            'Request Reschedule / تبدیلی وقت کی درخواست'),
                        onPressed: () => _showRescheduleDialog(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Completed Appointment / مکمل شدہ ملاقات',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 1,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFDCFCE7),
                  child: Icon(Icons.check, color: Colors.green),
                ),
                title: const Text('Initial Assessment / ابتدائی جائزہ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text(
                    '15 June 2026 at 11:30 AM · Lahore Central Office'),
                trailing: const Chip(
                  label: Text('Completed',
                      style: TextStyle(fontSize: 10, color: Colors.white)),
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile / پروفائل')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: Color(0xFF0F766E),
              child: Icon(Icons.person, size: 54, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Tariq Mehmood / طارق محمود',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Center(
            child: Text(
              'Case / کیس نمبر: LHR-2026-089',
              style: TextStyle(
                  color: Color(0xFF0F766E), fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 24),

          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _ProfileItem(
                      icon: Icons.badge,
                      label: 'CNIC / شناختی کارڈ',
                      value: '00000-0000000-0 (Masked / پوشیدہ)'),
                  const Divider(),
                  _ProfileItem(
                      icon: Icons.assignment,
                      label: 'Case Reference / کیس نمبر',
                      value: 'LHR-2026-089'),
                  const Divider(),
                  _ProfileItem(
                      icon: Icons.category,
                      label: 'Supervision Category / نوعیت',
                      value: 'Probation Order / پروبیشن حکم'),
                  const Divider(),
                  _ProfileItem(
                      icon: Icons.person_pin,
                      label: 'Assigned Officer / مقررہ افسر',
                      value: 'Officer Tahir Mahmood'),
                  const Divider(),
                  _ProfileItem(
                      icon: Icons.business,
                      label: 'District Office / ڈسٹرکٹ دفتر',
                      value: 'Lahore Central Office'),
                  const Divider(),
                  _ProfileItem(
                      icon: Icons.language,
                      label: 'Preferred Language / منتخب زبان',
                      value: 'English & Urdu / انگریزی اور اردو'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Privacy Note
          Card(
            color: const Color(0xFFF8FAFC),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.privacy_tip_outlined,
                          color: Color(0xFF0F766E)),
                      SizedBox(width: 8),
                      Text(
                        'Privacy Guarantee / رازداری کی ضمانت',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'All supervisee records are confidential under probation regulations. Masked CNIC 00000-0000000-0 and synthetic indicators are used in this demonstration.',
                    style: TextStyle(
                        fontSize: 12, color: Colors.black54, height: 1.4),
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

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ProfileItem(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0F766E), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        const TextStyle(fontSize: 11, color: Colors.black54)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
