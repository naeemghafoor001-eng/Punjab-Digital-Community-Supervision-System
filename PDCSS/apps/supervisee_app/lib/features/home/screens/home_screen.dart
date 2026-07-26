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
      const _HelpTab(),
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
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F5A47), // Official green
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        bottom: 16,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Logo (Contained in white circular background, 50px)
              Container(
                width: 50,
                height: 50,
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
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Brand Titles
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Punjab Probation and Parole Service',
                      style: TextStyle(
                        fontSize: 14,
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
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Punjab Digital Community Supervision System',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                urduTitle,
                style: const TextStyle(
                  fontSize: 14,
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
  Size get preferredSize => const Size.fromHeight(135);
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE FOOTER DISCLAIMER
// ─────────────────────────────────────────────────────────────────────────────
class _FooterDisclaimer extends StatelessWidget {
  const _FooterDisclaimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      child: Column(
        children: const [
          Divider(),
          SizedBox(height: 8),
          Text(
            'This is a sample interface with fictional records for review and presentation purposes.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.black54,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 4),
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
class _DashboardTab extends StatelessWidget {
  final VoidCallback onNavigateToCheckIn;
  const _DashboardTab({required this.onNavigateToCheckIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _BrandingHeader(
        title: 'PDCSS Supervisee Dashboard',
        urduTitle: 'نگہداشت ڈیش بورڈ',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Supervisee Summary Card
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
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
                                'Supervisee Name / نام',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.black54),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Tariq Mehmood / طارق محمود',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B)),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Case Ref / کیس نمبر: LHR-2026-089',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF0F5A47),
                                    fontWeight: FontWeight.bold),
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
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 28),
                    _buildInfoRow(
                      Icons.calendar_month,
                      'Next Reporting Date / اگلی حاضری',
                      '28 July 2026 / 28 جولائی 2026',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.person,
                      'Assigned Officer / مقررہ افسر',
                      'Officer Tahir Mahmood / افسر طاہر محمود',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.business,
                      'District Office / ڈسٹرکٹ دفتر',
                      'Lahore Central Office / لاہور سینٹرل دفتر',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.timer,
                      'Supervision Expiry / اختتامِ نگرانی',
                      '15 December 2026 / 15 دسمبر 2026',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Main Large Action Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 58),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.check_circle_outline,
                  color: Colors.white, size: 24),
              label: const Text(
                'Start Digital Check-In / حاضری رپورٹ شروع کریں',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: onNavigateToCheckIn,
            ),
            const SizedBox(height: 24),

            // Recent Activity Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Recent Activity / حالیہ سرگرمی',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B)),
                ),
                Icon(Icons.history, color: Colors.black54),
              ],
            ),
            const SizedBox(height: 12),
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
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF0F5A47)),
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
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B)),
              ),
            ],
          ),
        ),
      ],
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(25),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(title,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B))),
        subtitle: Text(time,
            style: const TextStyle(fontSize: 11, color: Colors.black54)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(38),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            statusLabel,
            style: TextStyle(
                fontSize: 10, color: color, fontWeight: FontWeight.w800),
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
        padding: const EdgeInsets.all(20),
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
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF1E3A8A)),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please report punctually for your scheduled appointments. Bring your original CNIC and case card.\nبراہِ کرم مقررہ وقت پر تشریف لائیں۔ اپنا اصل شناختی کارڈ اور کیس کارڈ ساتھ رکھیں۔',
                      style: TextStyle(
                          fontSize: 12, height: 1.5, color: Color(0xFF1E3A8A)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Upcoming Appointment / اگلی ملاقات',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFF0F5A47), width: 1.5),
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
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F5A47)),
                        ),
                        Chip(
                          label: Text(
                            'Upcoming',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Color(0xFF0F5A47),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildAppointmentRow(Icons.calendar_today,
                        '28 July 2026 at 10:00 AM / 28 جولائی 2026 - صبح 10:00'),
                    const SizedBox(height: 8),
                    _buildAppointmentRow(Icons.location_on,
                        'Lahore Central Office / لاہور سینٹرل دفتر'),
                    const SizedBox(height: 8),
                    _buildAppointmentRow(Icons.person,
                        'Officer Tahir Mahmood / افسر طاہر محمود'),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
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
              'Past/Completed Appointments / ماضی کی ملاقاتیں',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 1,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(0xFFDCFCE7),
                  child: Icon(Icons.check, color: Colors.green),
                ),
                title: Text('Initial Assessment / ابتدائی جائزہ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text(
                    '15 June 2026 at 11:30 AM · Lahore Central Office',
                    style: TextStyle(fontSize: 11)),
                trailing: Text(
                  'Completed',
                  style: TextStyle(
                      fontSize: 11,
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
      children: [
        Icon(icon, size: 16, color: Colors.black54),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
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
        padding: const EdgeInsets.all(20),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: Color(0xFF0F5A47),
              child: Icon(Icons.person, size: 54, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Tariq Mehmood / طارق محمود',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B)),
            ),
          ),
          const Center(
            child: Text(
              'Case Ref / کیس نمبر: LHR-2026-089',
              style: TextStyle(
                  color: Color(0xFF0F5A47), fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),

          Card(
            elevation: 2,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _ProfileItem(
                      icon: Icons.badge,
                      label: 'CNIC / شناختی کارڈ',
                      value: '35201-xxxxxxx-x (Masked / پوشیدہ)'),
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
                      value: 'Officer Tahir Mahmood / افسر طاہر محمود'),
                  const Divider(),
                  _ProfileItem(
                      icon: Icons.business,
                      label: 'District Office / ڈسٹرکٹ دفتر',
                      value: 'Lahore Central Office / لاہور سینٹرل دفتر'),
                  const Divider(),
                  _ProfileItem(
                      icon: Icons.language,
                      label: 'Preferred Language / زبان',
                      value: 'English & Urdu / انگریزی اور اردو'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Privacy Note
          Card(
            color: const Color(0xFFF8FAFC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.privacy_tip_outlined,
                          color: Color(0xFF0F5A47)),
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
                    'All supervisee records are confidential under probation regulations. Masked CNIC 35201-xxxxxxx-x and synthetic indicators are used in this demonstration.',
                    style: TextStyle(
                        fontSize: 12, color: Colors.black54, height: 1.4),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'تمام ریکارڈز پروبیشن قوانین کے تحت خفیہ رکھے جاتے ہیں۔ اس ڈیمو میں فرضی ڈیٹا استعمال کیا گیا ہے۔',
                    style: TextStyle(
                        fontSize: 11, color: Colors.black54, height: 1.4),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0F5A47), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        const TextStyle(fontSize: 11, color: Colors.black54)),
                const SizedBox(height: 1),
                Text(value,
                    style: const TextStyle(
                        fontSize: 13,
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
                'Dialing: 0800-00000',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Demonstration Mode / ڈیمو وضع:\nIn production, this initiates a phone call to the PP&PS Central Office Helpline.',
                style: TextStyle(fontSize: 13, height: 1.4),
              ),
              SizedBox(height: 8),
              Text(
                'حقیقی ماحول میں یہ پی پی اینڈ پی ایس ہیلپ لائن پر کال شروع کرتا ہے۔',
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
        title: 'Help & Support',
        urduTitle: 'مدد اور معلومات',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Card
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade100),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Official Contacts / اہم رابطے',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F5A47)),
                    ),
                    const Divider(height: 24),
                    _buildHelpContactRow(
                        Icons.person,
                        'Assigned Officer / مقررہ افسر',
                        'Officer Tahir Mahmood\n0300-1234567 (Demo)'),
                    const SizedBox(height: 12),
                    _buildHelpContactRow(
                        Icons.business,
                        'Office Address / دفتری پتہ',
                        'Lahore Central Office, Home Department, Lahore'),
                    const SizedBox(height: 12),
                    _buildHelpContactRow(
                        Icons.phone,
                        'Central Helpline / مرکزی ہیلپ لائن',
                        '0800-00000 (Toll-Free)'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Call Helpline Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5A47),
                minimumSize: const Size(double.infinity, 54),
              ),
              icon: const Icon(Icons.phone_in_talk, color: Colors.white),
              label: const Text('Call Helpline / ہیلپ لائن پر کال کریں'),
              onPressed: () => _showCallSimulation(context),
            ),
            const SizedBox(height: 24),

            const Text(
              'Frequently Asked Questions / عام سوالات',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 12),
            _buildFAQTile(
              'How to do Check-In? / حاضری کیسے رپورٹ کریں؟',
              'Go to the Check-In tab, verify your name, answer the 4 simple questions, and click submit. Make sure to do it on or before your scheduled reporting date.',
              'حاضری کے صفحے پر جائیں، اپنا نام چیک کریں، اور 4 بنیادی سوالات کے جواب دے کر جمع کریں۔ مقررہ تاریخ سے پہلے حاضری یقینی بنائیں۔',
            ),
            _buildFAQTile(
              'Emergency / ہنگامی صورتحال',
              'If you missed your reporting date due to a medical emergency, contact your probation officer immediately at the central office.',
              'اگر آپ بیماری کی وجہ سے وقت پر رپورٹ نہیں کر سکے، تو فوری طور پر پروبیشن افسر سے رابطہ کریں۔',
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
                      fontSize: 13,
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
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B)),
        ),
        iconColor: const Color(0xFF0F5A47),
        childrenPadding: const EdgeInsets.all(16),
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
