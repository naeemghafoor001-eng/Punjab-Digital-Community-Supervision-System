import 'package:flutter/material.dart';
import 'package:web_portal/core/backend/raahnuma_portal_service.dart';
import 'package:web_portal/core/backend/models.dart';
import 'package:web_portal/core/backend/supabase_config.dart';

// ─── Color Palette ──────────────────────────────────────────────────────────
const Color kGovGreen = Color(0xFF0F5A47); // Official PP&PS Green
const Color kGovGreenDark = Color(0xFF09382C);
const Color kGovGreenMid = Color(0xFF157A62);
const Color kGovGreenLight = Color(0xFF4CAF50);
const Color kGovGreenSurface = Color(0xFFF0F7F4);
const Color kGovGold = Color(0xFFD4AF37);
const Color kGovGoldLight = Color(0xFFFFFBF0);
const Color kGovWhite = Colors.white;
const Color kTextDark = Color(0xFF0F172A);
const Color kTextMuted = Color(0xFF475569);
const Color kBgGrey = Color(0xFFF8FAFC);
const Color kBorderGrey = Color(0xFFE2E8F0);

// Status Colors
const Color kStatusNormal = Color(0xFF0F5A47); // Green
const Color kStatusInfo = Color(0xFF1565C0); // Blue
const Color kStatusPending = Color(0xFFD97706); // Amber
const Color kStatusOverdue = Color(0xFFDC2626); // Red

class DistrictDashboardScreen extends StatefulWidget {
  const DistrictDashboardScreen({Key? key}) : super(key: key);

  @override
  State<DistrictDashboardScreen> createState() =>
      _DistrictDashboardScreenState();
}

class _DistrictDashboardScreenState extends State<DistrictDashboardScreen> {
  int _selectedNavIndex = 0;

  final List<String> _navItems = [
    'Overview',
    'Districts',
    'Divisions',
    'Officers',
    'Compliance',
    'Alerts',
    'Rehabilitation',
    'Reports',
    'Audit Trail',
    'System Safeguards',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGrey,
      body: Column(
        children: [
          // ── Fixed Top Header ──────────────────────────────────────────────
          const _TopHeader(),

          // ── Main Content Layout ───────────────────────────────────────────
          Expanded(
            child: Row(
              children: [
                // Navigation Sidebar
                _Sidebar(
                  navItems: _navItems,
                  selectedIndex: _selectedNavIndex,
                  onSelect: (index) {
                    setState(() {
                      _selectedNavIndex = index;
                    });
                  },
                ),

                // Main Content Area
                Expanded(
                  child: Container(
                    color: kBgGrey,
                    child: _buildSelectedSection(),
                  ),
                ),
              ],
            ),
          ),

          // ── Main Footer ───────────────────────────────────────────────────
          const _Footer(),
        ],
      ),
    );
  }

  Widget _buildSelectedSection() {
    switch (_selectedNavIndex) {
      case 0:
        return _buildExecutiveOverview();
      case 1:
        return _buildDistrictMonitoring();
      case 2:
        return _buildDivisionalSummary();
      case 3:
        return _buildOfficerWorkload();
      case 4:
        return _buildComplianceDashboard();
      case 5:
        return _buildAlertsDashboard();
      case 6:
        return _buildRehabReferrals();
      case 7:
        return _buildReports();
      case 8:
        return _buildAuditTrail();
      case 9:
        return _buildSystemSafeguards();
      default:
        return _buildExecutiveOverview();
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // SECTION 1: EXECUTIVE OVERVIEW
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildExecutiveOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Directorate General Executive Dashboard',
            subtitle:
                'Provincial command overview for Punjab Probation and Parole Service',
          ),
          const SizedBox(height: 18),

          // 10 Executive KPI Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              final cardWidth = isWide
                  ? (constraints.maxWidth - (4 * 12)) / 5
                  : (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatCard(
                    title: 'Total Supervisees',
                    value: '1,482',
                    supportingText: 'Active Provincial Caseload',
                    icon: Icons.people_outline,
                    accentColor: kGovGreen,
                    statusText: 'Active',
                    width: cardWidth,
                  ),
                  _StatCard(
                    title: 'Probationers',
                    value: '1,024',
                    supportingText: 'Court Order Supervision',
                    icon: Icons.gavel_outlined,
                    accentColor: kStatusInfo,
                    statusText: '69.1%',
                    width: cardWidth,
                  ),
                  _StatCard(
                    title: 'Parolees',
                    value: '458',
                    supportingText: 'Parole Release Supervision',
                    icon: Icons.verified_user_outlined,
                    accentColor: kStatusPending,
                    statusText: '30.9%',
                    width: cardWidth,
                  ),
                  _StatCard(
                    title: 'Active Officers',
                    value: '36',
                    supportingText: 'Field Probation Officers',
                    icon: Icons.badge_outlined,
                    accentColor: kGovGreenMid,
                    statusText: 'Deployed',
                    width: cardWidth,
                  ),
                  _StatCard(
                    title: 'Pending Check-Ins',
                    value: '42',
                    supportingText: 'Awaiting Officer Review',
                    icon: Icons.fact_check_outlined,
                    accentColor: kStatusPending,
                    statusText: 'Review Due',
                    width: cardWidth,
                  ),
                  _StatCard(
                    title: 'Open Alerts',
                    value: '18',
                    supportingText: 'Active Compliance Triggers',
                    icon: Icons.warning_amber_outlined,
                    accentColor: kStatusOverdue,
                    statusText: 'Requires Review',
                    width: cardWidth,
                  ),
                  _StatCard(
                    title: 'Appointments Due',
                    value: '84',
                    supportingText: 'Scheduled this Week',
                    icon: Icons.today_outlined,
                    accentColor: kStatusInfo,
                    statusText: 'Scheduled',
                    width: cardWidth,
                  ),
                  _StatCard(
                    title: 'Referrals Pending',
                    value: '29',
                    supportingText: 'Rehabilitation Support',
                    icon: Icons.volunteer_activism_outlined,
                    accentColor: kGovGreen,
                    statusText: 'Rehab Active',
                    width: cardWidth,
                  ),
                  _StatCard(
                    title: 'Reviews Completed',
                    value: '1,240',
                    supportingText: 'Verified this Month',
                    icon: Icons.task_alt_outlined,
                    accentColor: kGovGreen,
                    statusText: '83.6%',
                    width: cardWidth,
                  ),
                  _StatCard(
                    title: 'Compliance Rate',
                    value: '94.2%',
                    supportingText: 'Provincial Average',
                    icon: Icons.trending_up,
                    accentColor: kGovGreen,
                    statusText: 'High Standard',
                    width: cardWidth,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),

          // Punjab Supervision Snapshot Panel
          _buildPunjabSupervisionSnapshot(),
          const SizedBox(height: 20),

          // Double Column: Operational Summary & High Priority Triggers
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 750;
              final summaryCard = Card(
                elevation: 1.5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: kBorderGrey),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Provincial Operational Summary',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: kTextDark,
                        ),
                      ),
                      const Divider(height: 20, color: kBorderGrey),
                      _buildSnapshotItem(
                          'Overall Provincial Compliance', '94.2%', kGovGreen),
                      _buildSnapshotItem(
                          'Check-Ins Submitted Today', '142', kStatusInfo),
                      _buildSnapshotItem(
                          'Alerts Resolved this Week', '34', kGovGreen),
                      _buildSnapshotItem(
                          'Rehabilitation Referrals Active', '29', kGovGreen),
                      _buildSnapshotItem(
                          'Districts Under Monitoring', '36', kGovGreen),
                    ],
                  ),
                ),
              );

              final priorityCard = Card(
                elevation: 1.5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: kBorderGrey),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Directorate General Priorities',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: kTextDark,
                        ),
                      ),
                      const Divider(height: 20, color: kBorderGrey),
                      _buildPriorityBullet(
                        'Review reporting compliance rate in Lahore Central Office district.',
                        kStatusInfo,
                      ),
                      _buildPriorityBullet(
                        'Address 3 high-severity alerts in Rawalpindi & Multan divisions.',
                        kStatusOverdue,
                      ),
                      _buildPriorityBullet(
                        'Verify TEVTA vocational skills placement for enrolled supervisees.',
                        kGovGreen,
                      ),
                      _buildPriorityBullet(
                        'Monitor officer workload balance across 36 district offices.',
                        kStatusPending,
                      ),
                    ],
                  ),
                ),
              );

              return isNarrow
                  ? Column(children: [
                      summaryCard,
                      const SizedBox(height: 16),
                      priorityCard,
                    ])
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: summaryCard),
                        const SizedBox(width: 16),
                        Expanded(child: priorityCard),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPunjabSupervisionSnapshot() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: kGovGreen, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  child: Text(
                    'Punjab Supervision Snapshot — Provincial Analytics',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: kGovGreen),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Command View',
                  style: TextStyle(fontSize: 11, color: kTextMuted, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 650;
                final bar1 = _buildSnapshotBarItem(
                  label: 'Probation Orders vs Parole Releases',
                  valueStr: '1,024 Probation (69%) / 458 Parole (31%)',
                  percentage: 0.69,
                  barColor: kGovGreen,
                );
                final bar2 = _buildSnapshotBarItem(
                  label: 'Provincial Compliance Status Distribution',
                  valueStr: '1,396 Compliant (94.2%) / 86 Under Review',
                  percentage: 0.942,
                  barColor: const Color(0xFF1565C0),
                );

                return isNarrow
                    ? Column(
                        children: [
                          bar1,
                          const SizedBox(height: 14),
                          bar2,
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(child: bar1),
                          const SizedBox(width: 20),
                          Expanded(child: bar2),
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSnapshotBarItem({
    required String label,
    required String valueStr,
    required double percentage,
    required Color barColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextDark)),
        const SizedBox(height: 2),
        Text(valueStr, style: const TextStyle(fontSize: 11, color: kTextMuted)),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // SECTION 2: DISTRICT MONITORING
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildDistrictMonitoring() {
    final districts = [
      {'name': 'Lahore', 'cases': 342, 'prob': 238, 'parole': 104, 'checkins': 12, 'alerts': 4, 'rate': '95.2%', 'load': 'Moderate'},
      {'name': 'Rawalpindi', 'cases': 218, 'prob': 152, 'parole': 66, 'checkins': 8, 'alerts': 3, 'rate': '93.8%', 'load': 'High'},
      {'name': 'Multan', 'cases': 184, 'prob': 128, 'parole': 56, 'checkins': 6, 'alerts': 2, 'rate': '94.0%', 'load': 'Moderate'},
      {'name': 'Faisalabad', 'cases': 196, 'prob': 136, 'parole': 60, 'checkins': 7, 'alerts': 3, 'rate': '92.5%', 'load': 'High'},
      {'name': 'Gujranwala', 'cases': 142, 'prob': 98, 'parole': 44, 'checkins': 4, 'alerts': 2, 'rate': '95.8%', 'load': 'Balanced'},
      {'name': 'Bahawalpur', 'cases': 112, 'prob': 78, 'parole': 34, 'checkins': 2, 'alerts': 1, 'rate': '96.2%', 'load': 'Balanced'},
      {'name': 'Sahiwal', 'cases': 98, 'prob': 68, 'parole': 30, 'checkins': 1, 'alerts': 1, 'rate': '94.9%', 'load': 'Balanced'},
      {'name': 'Sargodha', 'cases': 104, 'prob': 72, 'parole': 32, 'checkins': 1, 'alerts': 1, 'rate': '95.1%', 'load': 'Balanced'},
      {'name': 'D.G. Khan', 'cases': 86, 'prob': 54, 'parole': 32, 'checkins': 1, 'alerts': 1, 'rate': '93.0%', 'load': 'Balanced'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'District Supervision Monitoring',
            subtitle: 'District-level caseload, compliance rate and active workload across Punjab',
          ),
          const SizedBox(height: 18),
          Card(
            elevation: 2,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 22,
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F5F9)),
                  columns: const [
                    DataColumn(label: Text('District', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Total Cases', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Probation', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Parole', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Pending Check-Ins', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Open Alerts', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Compliance Rate', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Workload Status', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: districts.map((d) {
                    return DataRow(cells: [
                      DataCell(Text(d['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text('${d['cases']}')),
                      DataCell(Text('${d['prob']}')),
                      DataCell(Text('${d['parole']}')),
                      DataCell(Text('${d['checkins']}')),
                      DataCell(Text('${d['alerts']}', style: TextStyle(color: (d['alerts'] as int) > 2 ? kStatusOverdue : kTextDark, fontWeight: FontWeight.bold))),
                      DataCell(Text(d['rate'] as String, style: const TextStyle(color: kGovGreen, fontWeight: FontWeight.bold))),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: d['load'] == 'High' ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            d['load'] as String,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: d['load'] == 'High' ? Colors.red.shade800 : Colors.green.shade800,
                            ),
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // SECTION 3: DIVISIONAL SUMMARY
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildDivisionalSummary() {
    final divisions = [
      {'division': 'Lahore Division', 'districts': 'Lahore, Kasur, Sheikhupura, Nankana', 'cases': 480, 'compliance': '95.2%', 'alerts': 5, 'rehab': 12},
      {'division': 'Rawalpindi Division', 'districts': 'Rawalpindi, Attock, Jhelum, Chakwal', 'cases': 310, 'compliance': '93.8%', 'alerts': 4, 'rehab': 8},
      {'division': 'Multan Division', 'districts': 'Multan, Khanewal, Vehari, Lodhran', 'cases': 260, 'compliance': '94.0%', 'alerts': 3, 'rehab': 6},
      {'division': 'Faisalabad Division', 'districts': 'Faisalabad, Jhang, T.T. Singh, Chiniot', 'cases': 275, 'compliance': '92.5%', 'alerts': 4, 'rehab': 5},
      {'division': 'Gujranwala Division', 'districts': 'Gujranwala, Gujrat, Sialkot, Narowal', 'cases': 210, 'compliance': '95.8%', 'alerts': 2, 'rehab': 4},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Divisional Supervision Performance',
            subtitle: 'Division-level operational summary across Punjab administrative divisions',
          ),
          const SizedBox(height: 18),
          ...divisions.map((div) {
            return Card(
              elevation: 1.5,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(div['division'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: kGovGreen)),
                subtitle: Text('Districts: ${div['districts']} · Active Cases: ${div['cases']}'),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    Chip(label: Text('Compliance: ${div['compliance']}'), backgroundColor: const Color(0xFFDCFCE7)),
                    Chip(label: Text('Alerts: ${div['alerts']}'), backgroundColor: const Color(0xFFFEF3C7)),
                    Chip(label: Text('Rehab: ${div['rehab']}'), backgroundColor: const Color(0xFFEFF6FF)),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // SECTION 4: OFFICER WORKLOAD
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildOfficerWorkload() {
    return FutureBuilder<List<PortalOfficerRow>>(
      future: RaahnumaPortalService.instance.getOfficers(),
      builder: (context, snapshot) {
        final list = snapshot.data ?? [];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeading(
                title: 'Officer Workload & Deployment Overview',
                subtitle: 'Supervision load per field officer across district offices',
              ),
              const SizedBox(height: 18),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kGovGreen)))
              else
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F5F9)),
                        columns: const [
                          DataColumn(label: Text('Officer Name', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Designation', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('District Office', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Assigned Cases', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Workload Status', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: list.map((o) {
                          final isHigh = o.caseCount > 40;
                          return DataRow(cells: [
                            DataCell(Text(o.fullName, style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(o.designation)),
                            DataCell(Text(o.district)),
                            DataCell(Text('${o.caseCount}', style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isHigh ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  isHigh ? 'High Load' : 'Moderate',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: isHigh ? Colors.red.shade800 : Colors.green.shade800,
                                  ),
                                ),
                              ),
                            ),
                          ]);
                        }).toList(),
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

  // ───────────────────────────────────────────────────────────────────────────
  // SECTION 5: COMPLIANCE & CHECK-INS
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildComplianceDashboard() {
    return FutureBuilder<List<PortalCheckInRow>>(
      future: RaahnumaPortalService.instance.getCheckIns(),
      builder: (context, snapshot) {
        final list = snapshot.data ?? [];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeading(
                title: 'Compliance & Digital Check-In Monitoring',
                subtitle: 'Verification stream of probationer and parolee reporting check-ins',
              ),
              const SizedBox(height: 18),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kGovGreen)))
              else
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final c = list[i];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: c.isReviewed ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                            child: Icon(c.isReviewed ? Icons.check : Icons.access_time, color: c.isReviewed ? Colors.green : Colors.amber),
                          ),
                          title: Text(c.superviseeName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Receipt: ${c.receiptNumber} · Date: ${c.scheduledReportingDate}'),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: c.isReviewed ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              c.isReviewed ? 'Reviewed' : 'Awaiting Review',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: c.isReviewed ? Colors.green.shade800 : Colors.amber.shade900,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // SECTION 6: ALERTS DASHBOARD
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildAlertsDashboard() {
    return FutureBuilder<List<PortalAlertRow>>(
      future: RaahnumaPortalService.instance.getAlerts(),
      builder: (context, snapshot) {
        final list = snapshot.data ?? [];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeading(
                title: 'Supervision Alerts & Compliance Triggers',
                subtitle: 'Administrative triggers for officer review and verification',
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF0),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kGovGold),
                ),
                child: const Text(
                  'Alerts support officer review and do not constitute automatic violation findings.',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF854D0E)),
                ),
              ),
              const SizedBox(height: 16),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kGovGreen)))
              else
                ...list.map((a) {
                  return Card(
                    elevation: 1.5,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text('${a.category} — ${a.superviseeName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(a.description),
                      trailing: Chip(
                        label: Text(a.severity),
                        backgroundColor: a.severity == 'High' || a.severity == 'Violation' ? const Color(0xFFFEE2E2) : const Color(0xFFEFF6FF),
                      ),
                    ),
                  );
                }).toList(),
            ],
          ),
        );
      },
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // SECTION 7: REHABILITATION REFERRALS
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildRehabReferrals() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Rehabilitation & Reintegration Referrals',
            subtitle: 'Vocational training, employment, counselling and welfare support dashboard',
          ),
          const SizedBox(height: 18),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.school, color: kGovGreen, size: 28),
                    title: Text('TEVTA Vocational Skills Training', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('28 Supervisees Enrolled across Lahore & Rawalpindi centres'),
                    trailing: Text('Active Support', style: TextStyle(color: kGovGreen, fontWeight: FontWeight.bold)),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.psychology, color: Colors.blue, size: 28),
                    title: Text('District Addiction & Psychological Counselling', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('14 Supervisees undergoing active counselling sessions'),
                    trailing: Text('In Progress', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.account_balance_wallet, color: Colors.purple, size: 28),
                    title: Text('Punjab Bait-ul-Mal Financial Welfare Grants', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('9 Family welfare applications approved'),
                    trailing: Text('Approved', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // SECTION 8: REPORTS & ANALYTICS
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildReports() {
    final reports = [
      'Monthly Supervision & Compliance Summary',
      'District Office Performance & Workload Audit',
      'Rehabilitation & Reintegration Impact Assessment',
      'Supervision Alerts & Administrative Trigger Log',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Management Reports & Analytics',
            subtitle: 'Official reporting exports for the Directorate General',
          ),
          const SizedBox(height: 18),
          ...reports.map((r) {
            return Card(
              elevation: 1.5,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: kGovGreen),
                title: Text(r, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Format: Executive PDF · Generated: 26 July 2026'),
                trailing: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Exporting report: "$r"'), backgroundColor: kGovGreen),
                    );
                  },
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Download PDF'),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // SECTION 9: AUDIT TRAIL
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildAuditTrail() {
    return FutureBuilder<List<PortalActivityRow>>(
      future: RaahnumaPortalService.instance.getActivities(),
      builder: (context, snapshot) {
        final list = snapshot.data ?? [];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeading(
                title: 'System Activity & Audit Trail',
                subtitle: 'Immutable record of system events and officer actions',
              ),
              const SizedBox(height: 18),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kGovGreen)))
              else
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final act = list[i];
                        return ListTile(
                          leading: const Icon(Icons.history, color: kGovGreen),
                          title: Text(act.eventType, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: Text(act.description),
                          trailing: Text(act.createdAt, style: const TextStyle(fontSize: 11, color: kTextMuted)),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // SECTION 10: SYSTEM SAFEGUARDS
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildSystemSafeguards() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'System Architecture & Data Safeguards',
            subtitle: 'Security, privacy and legal compliance protocol overview',
          ),
          const SizedBox(height: 18),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('1. Fictional Data Protocol', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kGovGreen)),
                  SizedBox(height: 4),
                  Text('This public presentation environment operates exclusively on synthetic demo records for system review and demonstration purposes.', style: TextStyle(fontSize: 12, color: kTextDark)),
                  Divider(height: 24),
                  Text('2. Data Privacy & Isolation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kGovGreen)),
                  SizedBox(height: 4),
                  Text('No live integration exists with NADRA, Courts, Police, or Prison databases in this presentation version. All CNIC numbers are masked.', style: TextStyle(fontSize: 12, color: kTextDark)),
                  Divider(height: 24),
                  Text('3. Legal Oversight & Decision Making', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kGovGreen)),
                  SizedBox(height: 4),
                  Text('System alerts act purely as administrative review triggers for probation officers and do not constitute automatic violation findings.', style: TextStyle(fontSize: 12, color: kTextDark)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSnapshotItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12.5, color: kTextDark)),
          Text(value, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildPriorityBullet(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.brightness_1, size: 7, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: kTextDark, height: 1.3))),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HEADER COMPONENT
// ─────────────────────────────────────────────────────────────────────────────
class _TopHeader extends StatelessWidget {
  const _TopHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasBackend = SupabaseConfig.hasBackend;
    final isNarrow = MediaQuery.of(context).size.width < 900;

    return Container(
      height: 96,
      decoration: const BoxDecoration(
        color: kGovWhite,
        border: Border(bottom: BorderSide(color: kBorderGrey, width: 1.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Logo Container
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: kGovGold, width: 1.5),
            ),
            padding: const EdgeInsets.all(2),
            child: ClipOval(
              child: Image.asset(
                'assets/images/ppps_logo.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.account_balance,
                  color: kGovGreen,
                  size: 26,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Titles & Subtitles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Flexible(
                      child: Text(
                        'Raahnuma Management Portal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: kGovGreen,
                          letterSpacing: 0.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: hasBackend ? const Color(0xFF065F46) : const Color(0xFF92400E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        hasBackend ? 'Connected' : 'Local Demo',
                        style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                const Text(
                  'Directorate General Management and Monitoring Portal',
                  style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: kGovGreenMid),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                const Text(
                  'Punjab Probation and Parole Service · Home Department, Government of the Punjab',
                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: kTextMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          if (!isNarrow)
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Directorate General Command Office',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: kTextDark),
                    ),
                    Text(
                      'Provincial Oversight Level',
                      style: TextStyle(fontSize: 9.5, color: kTextMuted),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final List<String> navItems;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _Sidebar({
    Key? key,
    required this.navItems,
    required this.selectedIndex,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      decoration: const BoxDecoration(
        color: kGovGreenDark,
        border: Border(right: BorderSide(color: kBorderGrey, width: 1.5)),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 14),
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;
                return Material(
                  color: Colors.transparent,
                  child: ListTile(
                    selected: isSelected,
                    selectedTileColor: kGovGreen.withAlpha(80),
                    leading: Icon(
                      _getIcon(index),
                      color: isSelected ? kGovGold : Colors.white70,
                      size: 19,
                    ),
                    title: Text(
                      navItems[index],
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.white70,
                      ),
                    ),
                    onTap: () => onSelect(index),
                    horizontalTitleGap: 6,
                    dense: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.dashboard_outlined;
      case 1:
        return Icons.location_city_outlined;
      case 2:
        return Icons.map_outlined;
      case 3:
        return Icons.badge_outlined;
      case 4:
        return Icons.pie_chart_outline;
      case 5:
        return Icons.warning_amber_outlined;
      case 6:
        return Icons.volunteer_activism_outlined;
      case 7:
        return Icons.assessment_outlined;
      case 8:
        return Icons.verified_user_outlined;
      case 9:
        return Icons.shield_outlined;
      default:
        return Icons.circle_outlined;
    }
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeading({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 22,
              decoration: BoxDecoration(
                color: kGovGreen,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold, color: kTextDark),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(
            subtitle,
            style: const TextStyle(fontSize: 11.5, color: kTextMuted),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String supportingText;
  final IconData icon;
  final Color accentColor;
  final String statusText;
  final double? width;

  const _StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.supportingText,
    required this.icon,
    required this.accentColor,
    required this.statusText,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: kGovWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kBorderGrey),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: accentColor, size: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                      color: accentColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: accentColor,
                height: 1.1),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.bold, color: kTextDark),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            supportingText,
            style: const TextStyle(fontSize: 9, color: kTextMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: const BoxDecoration(
        color: kGovWhite,
        border: Border(top: BorderSide(color: kBorderGrey, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Expanded(
            child: Text(
              'Public prototype using fictional records for review and presentation purposes.',
              style: TextStyle(
                  fontSize: 10, color: kTextMuted, fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 16),
          Text(
            'Directorate General Monitoring Cell | PP&PS',
            style: TextStyle(
                fontSize: 10, color: kTextMuted, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
