import 'package:flutter/material.dart';

// ─── Color Palette ──────────────────────────────────────────────────────────
const Color kGovGreen = Color(0xFF1B5E20);
const Color kGovGreenMid = Color(0xFF2E7D32);
const Color kGovGreenLight = Color(0xFF4CAF50);
const Color kGovGreenSurface = Color(0xFFF1F8F5);
const Color kGovWhite = Colors.white;
const Color kTextDark = Color(0xFF1E293B);
const Color kTextMuted = Color(0xFF64748B);
const Color kBgGrey = Color(0xFFF8FAFC);
const Color kBorderGrey = Color(0xFFE2E8F0);

// Restrained Accents for Status
const Color kStatusNormal = Color(0xFF2E7D32); // Green
const Color kStatusInfo = Color(0xFF1565C0); // Blue
const Color kStatusPending = Color(0xFFE65100); // Amber
const Color kStatusOverdue = Color(0xFFC62828); // Red

class DistrictDashboardScreen extends StatefulWidget {
  const DistrictDashboardScreen({Key? key}) : super(key: key);

  @override
  State<DistrictDashboardScreen> createState() =>
      _DistrictDashboardScreenState();
}

class _DistrictDashboardScreenState extends State<DistrictDashboardScreen> {
  int _selectedNavIndex = 0;

  final List<String> _navItems = [
    'Provincial Overview',
    'District Monitoring',
    'Divisional Summary',
    'Officer Workload',
    'Compliance Dashboard',
    'Risk and Needs Overview',
    'Rehabilitation Referrals',
    'Reports',
    'Audit Log',
    'Administration',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGrey,
      body: Column(
        children: [
          // ── Fixed Top Header (80-110px) ────────────────────────────────────
          const _TopHeader(),

          // ── Main Content Layout ────────────────────────────────────────────
          Expanded(
            child: Row(
              children: [
                // Navigation Sidebar (scrollable if viewport is short)
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
        return _buildProvincialOverview();
      case 1:
        return _buildDistrictMonitoring();
      case 2:
        return _buildDivisionalSummary();
      case 3:
        return _buildOfficerWorkload();
      case 4:
        return _buildComplianceDashboard();
      case 5:
        return _buildRiskNeedsOverview();
      case 6:
        return _buildRehabReferrals();
      case 7:
        return _buildReports();
      case 8:
        return _buildAuditLog();
      case 9:
        return _buildAdministration();
      default:
        return _buildProvincialOverview();
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // SECTION 1: PROVINCIAL OVERVIEW
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildProvincialOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Provincial Overview',
            subtitle:
                'Executive monitoring dashboard for the Directorate General',
          ),
          const SizedBox(height: 20),

          // 8 Metric Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth - (3 * 16)) / 4;
              final isWide = constraints.maxWidth > 800;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _StatCard(
                    title: 'Total Active Supervisees',
                    value: '40,000',
                    supportingText: 'Province-wide supervised population',
                    icon: Icons.people_outline,
                    accentColor: kStatusInfo,
                    statusText: 'Active',
                    width: isWide ? cardWidth : (constraints.maxWidth - 16) / 2,
                  ),
                  _StatCard(
                    title: 'Active Probationers',
                    value: '39,992',
                    supportingText: 'Community-based probation supervision',
                    icon: Icons.gavel_outlined,
                    accentColor: kStatusNormal,
                    statusText: 'Compliant',
                    width: isWide ? cardWidth : (constraints.maxWidth - 16) / 2,
                  ),
                  _StatCard(
                    title: 'Active Parolees',
                    value: '8',
                    supportingText: 'Active parole supervision cases',
                    icon: Icons.verified_user_outlined,
                    accentColor: kStatusPending,
                    statusText: 'Supervised',
                    width: isWide ? cardWidth : (constraints.maxWidth - 16) / 2,
                  ),
                  _StatCard(
                    title: 'Districts Covered',
                    value: '36',
                    supportingText: 'Punjab-wide coverage',
                    icon: Icons.map_outlined,
                    accentColor: kGovGreenMid,
                    statusText: 'Full coverage',
                    width: isWide ? cardWidth : (constraints.maxWidth - 16) / 2,
                  ),
                  _StatCard(
                    title: 'Officers',
                    value: '412',
                    supportingText: 'Field supervision workforce',
                    icon: Icons.badge_outlined,
                    accentColor: kStatusInfo,
                    statusText: 'Assigned',
                    width: isWide ? cardWidth : (constraints.maxWidth - 16) / 2,
                  ),
                  _StatCard(
                    title: 'Check-Ins This Month',
                    value: '38,920',
                    supportingText: 'Digital and officer-recorded contacts',
                    icon: Icons.assignment_turned_in_outlined,
                    accentColor: kStatusNormal,
                    statusText: 'Verified',
                    width: isWide ? cardWidth : (constraints.maxWidth - 16) / 2,
                  ),
                  _StatCard(
                    title: 'Overdue Cases',
                    value: '142',
                    supportingText: 'Require supervisory attention',
                    icon: Icons.warning_amber_outlined,
                    accentColor: kStatusOverdue,
                    statusText: 'Attention',
                    width: isWide ? cardWidth : (constraints.maxWidth - 16) / 2,
                  ),
                  _StatCard(
                    title: 'Rehabilitation Referrals',
                    value: '1,890',
                    supportingText: 'Referrals for reintegration support',
                    icon: Icons.school_outlined,
                    accentColor: kStatusPending,
                    statusText: 'Enrolled',
                    width: isWide ? cardWidth : (constraints.maxWidth - 16) / 2,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Double panel (Executive Snapshot & Priorities)
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 800;
              final children = [
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: kBorderGrey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Executive Snapshot',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kTextDark,
                          ),
                        ),
                        const Divider(height: 24, color: kBorderGrey),
                        _buildSnapshotItem(
                            'Overall Compliance Rate', '94.2%', kStatusNormal),
                        _buildSnapshotItem(
                            'Cases Due Today', '1,126', kStatusInfo),
                        _buildSnapshotItem(
                            'Alerts Pending Review', '213', kStatusPending),
                        _buildSnapshotItem('Districts Requiring Attention', '5',
                            kStatusOverdue),
                        _buildSnapshotItem('Reports Generated This Month', '84',
                            kStatusNormal),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: kBorderGrey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Directorate General Priorities',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kTextDark,
                          ),
                        ),
                        const Divider(height: 24, color: kBorderGrey),
                        _buildPriorityItem(
                            1, 'Review districts with overdue cases.'),
                        _buildPriorityItem(
                            2, 'Monitor high-caseload officers.'),
                        _buildPriorityItem(
                            3, 'Track pending risk and needs assessments.'),
                        _buildPriorityItem(
                            4, 'Review rehabilitation referral progress.'),
                        _buildPriorityItem(
                            5, 'Verify monthly work statement submission.'),
                      ],
                    ),
                  ),
                ),
              ];

              if (isNarrow) {
                return Column(
                  children: [
                    children[0],
                    const SizedBox(height: 16),
                    children[1],
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4, child: children[0]),
                  const SizedBox(width: 16),
                  Expanded(flex: 5, child: children[1]),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSnapshotItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: kTextMuted)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityItem(int num, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: kGovGreenSurface,
            child: Text(
              '$num',
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: kGovGreenMid),
            ),
          ),
          const SizedBox(width: 12),
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

  // ─────────────────────────────────────────────────────────────────────────────
  // SECTION 2: DISTRICT MONITORING
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildDistrictMonitoring() {
    final districts = [
      {
        'division': 'Lahore',
        'district': 'Lahore',
        'active': '8,450',
        'due': '231',
        'overdue': '45',
        'officers': '84',
        'compliance': '94.2%',
        'status': 'Stable'
      },
      {
        'division': 'Rawalpindi',
        'district': 'Rawalpindi',
        'active': '6,120',
        'due': '164',
        'overdue': '22',
        'officers': '62',
        'compliance': '95.6%',
        'status': 'Stable'
      },
      {
        'division': 'Faisalabad',
        'district': 'Faisalabad',
        'active': '7,340',
        'due': '210',
        'overdue': '38',
        'officers': '74',
        'compliance': '91.8%',
        'status': 'Watch'
      },
      {
        'division': 'Multan',
        'district': 'Multan',
        'active': '5,820',
        'due': '155',
        'overdue': '29',
        'officers': '58',
        'compliance': '92.5%',
        'status': 'Watch'
      },
      {
        'division': 'Gujranwala',
        'district': 'Gujranwala',
        'active': '4,900',
        'due': '132',
        'overdue': '8',
        'officers': '50',
        'compliance': '96.4%',
        'status': 'Stable'
      },
      {
        'division': 'Sahiwal',
        'district': 'Sahiwal',
        'active': '2,400',
        'due': '76',
        'overdue': '14',
        'officers': '24',
        'compliance': '93.1%',
        'status': 'Stable'
      },
      {
        'division': 'Bahawalpur',
        'district': 'Bahawalpur',
        'active': '3,110',
        'due': '92',
        'overdue': '21',
        'officers': '32',
        'compliance': '89.4%',
        'status': 'Attention Required'
      },
      {
        'division': 'Dera Ghazi Khan',
        'district': 'Dera Ghazi Khan',
        'active': '1,980',
        'due': '60',
        'overdue': '19',
        'officers': '22',
        'compliance': '88.5%',
        'status': 'Attention Required'
      },
      {
        'division': 'Sargodha',
        'district': 'Sargodha',
        'active': '2,110',
        'due': '62',
        'overdue': '11',
        'officers': '21',
        'compliance': '90.8%',
        'status': 'Watch'
      },
      {
        'division': 'Sheikhupura',
        'district': 'Sheikhupura',
        'active': '1,780',
        'due': '48',
        'overdue': '5',
        'officers': '19',
        'compliance': '95.9%',
        'status': 'Stable'
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'District Monitoring',
            subtitle:
                'Supervision compliance status across key districts in Punjab',
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 800;
              final mainTable = Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: kBorderGrey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Punjab Districts Caseload Ledger',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kTextDark),
                      ),
                    ),
                    const Divider(height: 1, color: kBorderGrey),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 28,
                        columns: const [
                          DataColumn(
                              label: Text('Division',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                          DataColumn(
                              label: Text('District',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                          DataColumn(
                              label: Text('Active Cases',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                          DataColumn(
                              label: Text('Due Today',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                          DataColumn(
                              label: Text('Overdue Cases',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                          DataColumn(
                              label: Text('Officers',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                          DataColumn(
                              label: Text('Compliance %',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                          DataColumn(
                              label: Text('Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                        ],
                        rows: districts.map((d) {
                          Color badgeColor;
                          if (d['status'] == 'Stable') {
                            badgeColor = kStatusNormal;
                          } else if (d['status'] == 'Watch') {
                            badgeColor = kStatusPending;
                          } else {
                            badgeColor = kStatusOverdue;
                          }

                          return DataRow(cells: [
                            DataCell(Text(d['division']!,
                                style: const TextStyle(fontSize: 13))),
                            DataCell(Text(d['district']!,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600))),
                            DataCell(Text(d['active']!,
                                style: const TextStyle(fontSize: 13))),
                            DataCell(Text(d['due']!,
                                style: const TextStyle(fontSize: 13))),
                            DataCell(Text(d['overdue']!,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: int.parse(d['overdue']!) > 15
                                        ? kStatusOverdue
                                        : kTextDark,
                                    fontWeight: FontWeight.w600))),
                            DataCell(Text(d['officers']!,
                                style: const TextStyle(fontSize: 13))),
                            DataCell(Text(d['compliance']!,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold))),
                            DataCell(Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: badgeColor.withAlpha(20),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                d['status']!,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: badgeColor),
                              ),
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );

              final sidePanel = Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: kBorderGrey),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Districts Requiring Attention',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kTextDark),
                      ),
                      const Divider(height: 24, color: kBorderGrey),
                      _buildAttentionItem(
                          'Lahore',
                          'Overdue check-ins flagged in regional sectors',
                          kStatusOverdue),
                      _buildAttentionItem(
                          'Faisalabad',
                          'High caseload threshold exceeded per officer',
                          kStatusPending),
                      _buildAttentionItem(
                          'Multan',
                          'Pending periodic risk assessments overdue',
                          kStatusPending),
                      _buildAttentionItem(
                          'Rawalpindi',
                          'Report reviews pending supervisory release',
                          kStatusInfo),
                    ],
                  ),
                ),
              );

              if (isNarrow) {
                return Column(
                  children: [
                    mainTable,
                    const SizedBox(height: 16),
                    sidePanel,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: mainTable),
                  const SizedBox(width: 16),
                  Expanded(flex: 3, child: sidePanel),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAttentionItem(String district, String reason, Color labelColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 8, color: labelColor),
              const SizedBox(width: 8),
              Text(district,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: kTextDark)),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(reason,
                style: const TextStyle(
                    fontSize: 11, color: kTextMuted, height: 1.3)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SECTION 3: DIVISIONAL SUMMARY
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildDivisionalSummary() {
    final List<Map<String, dynamic>> divisions = [
      {
        'name': 'Lahore',
        'cases': '12,540',
        'officers': '112',
        'avg': '111.9',
        'rate': '94.5%',
        'alerts': '42',
        'rehab': '480',
        'val': 0.945
      },
      {
        'name': 'Rawalpindi',
        'cases': '8,210',
        'officers': '78',
        'avg': '105.2',
        'rate': '95.2%',
        'alerts': '18',
        'rehab': '310',
        'val': 0.952
      },
      {
        'name': 'Faisalabad',
        'cases': '9,110',
        'officers': '88',
        'avg': '103.5',
        'rate': '93.8%',
        'alerts': '36',
        'rehab': '390',
        'val': 0.938
      },
      {
        'name': 'Multan',
        'cases': '6,540',
        'officers': '64',
        'avg': '102.1',
        'rate': '92.6%',
        'alerts': '29',
        'rehab': '280',
        'val': 0.926
      },
      {
        'name': 'Gujranwala',
        'cases': '7,890',
        'officers': '72',
        'avg': '109.5',
        'rate': '94.1%',
        'alerts': '31',
        'rehab': '340',
        'val': 0.941
      },
      {
        'name': 'Sahiwal',
        'cases': '3,450',
        'officers': '34',
        'avg': '101.4',
        'rate': '93.5%',
        'alerts': '14',
        'rehab': '150',
        'val': 0.935
      },
      {
        'name': 'Bahawalpur',
        'cases': '4,120',
        'officers': '42',
        'avg': '98.0',
        'rate': '91.2%',
        'alerts': '25',
        'rehab': '190',
        'val': 0.912
      },
      {
        'name': 'Dera Ghazi Khan',
        'cases': '2,650',
        'officers': '30',
        'avg': '88.3',
        'rate': '88.9%',
        'alerts': '22',
        'rehab': '110',
        'val': 0.889
      },
      {
        'name': 'Sargodha',
        'cases': '3,210',
        'officers': '32',
        'avg': '100.3',
        'rate': '92.1%',
        'alerts': '16',
        'rehab': '140',
        'val': 0.921
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Divisional Summary',
            subtitle:
                'Provincial performance matrices structured by administrative division',
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: kBorderGrey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Division Overview Ledger',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: kTextDark),
                  ),
                ),
                const Divider(height: 1, color: kBorderGrey),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 34,
                    columns: const [
                      DataColumn(
                          label: Text('Division',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(
                          label: Text('Active Cases',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(
                          label: Text('Officers',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(
                          label: Text('Average Caseload',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(
                          label: Text('Compliance Rate',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(
                          label: Text('Pending Alerts',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(
                          label: Text('Rehabilitation Referrals',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                    ],
                    rows: divisions.map((div) {
                      return DataRow(cells: [
                        DataCell(Text(div['name']!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13))),
                        DataCell(Text(div['cases']!,
                            style: const TextStyle(fontSize: 13))),
                        DataCell(Text(div['officers']!,
                            style: const TextStyle(fontSize: 13))),
                        DataCell(Text(div['avg']!,
                            style: const TextStyle(fontSize: 13))),
                        DataCell(
                          Row(
                            children: [
                              Text(div['rate']!,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 80,
                                child: LinearProgressIndicator(
                                  value: div['val'] as double,
                                  backgroundColor: kGovGreenSurface,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    (div['val'] as double) > 0.92
                                        ? kStatusNormal
                                        : kStatusPending,
                                  ),
                                  minHeight: 6,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(div['alerts']!,
                            style: const TextStyle(fontSize: 13))),
                        DataCell(Text(div['rehab']!,
                            style: const TextStyle(fontSize: 13))),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SECTION 4: OFFICER WORKLOAD
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildOfficerWorkload() {
    final officers = [
      {
        'name': 'Demo Officer A',
        'desig': 'Probation Officer',
        'district': 'Lahore',
        'cases': '145',
        'due': '12',
        'visits': '4',
        'pending': '8',
        'alerts': '3',
        'status': 'Critical'
      },
      {
        'name': 'Demo Officer B',
        'desig': 'Parole Officer',
        'district': 'Rawalpindi',
        'cases': '98',
        'due': '8',
        'visits': '2',
        'pending': '2',
        'alerts': '0',
        'status': 'Normal'
      },
      {
        'name': 'Demo Officer C',
        'desig': 'Probation Officer',
        'district': 'Faisalabad',
        'cases': '124',
        'due': '14',
        'visits': '3',
        'pending': '5',
        'alerts': '4',
        'status': 'High'
      },
      {
        'name': 'Demo Officer D',
        'desig': 'Assistant Parole Officer',
        'district': 'Multan',
        'cases': '75',
        'due': '5',
        'visits': '1',
        'pending': '3',
        'alerts': '1',
        'status': 'Normal'
      },
      {
        'name': 'Demo Officer E',
        'desig': 'Senior Probation Officer',
        'district': 'Gujranwala',
        'cases': '110',
        'due': '9',
        'visits': '3',
        'pending': '6',
        'alerts': '2',
        'status': 'Review'
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Officer Workload Audit',
            subtitle:
                'Supervisory oversight of field officer caseload distributions and backlogs',
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 800;
              final mainTable = Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: kBorderGrey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Workload Ledger',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kTextDark),
                      ),
                    ),
                    const Divider(height: 1, color: kBorderGrey),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 22,
                        columns: const [
                          DataColumn(
                              label: Text('Officer Name',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                          DataColumn(
                              label: Text('Designation',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                          DataColumn(
                              label: Text('District',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                          DataColumn(
                              label: Text('Assigned Cases',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                          DataColumn(
                              label: Text('Due Today',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                          DataColumn(
                              label: Text('Field Visits',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                          DataColumn(
                              label: Text('Pending Assessments',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                          DataColumn(
                              label: Text('Alerts',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                          DataColumn(
                              label: Text('Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))),
                        ],
                        rows: officers.map((off) {
                          Color badgeColor;
                          if (off['status'] == 'Normal') {
                            badgeColor = kStatusNormal;
                          } else if (off['status'] == 'Review') {
                            badgeColor = kStatusInfo;
                          } else if (off['status'] == 'High') {
                            badgeColor = kStatusPending;
                          } else {
                            badgeColor = kStatusOverdue;
                          }

                          return DataRow(cells: [
                            DataCell(Text(off['name']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13))),
                            DataCell(Text(off['desig']!,
                                style: const TextStyle(fontSize: 13))),
                            DataCell(Text(off['district']!,
                                style: const TextStyle(fontSize: 13))),
                            DataCell(Text(off['cases']!,
                                style: const TextStyle(fontSize: 13))),
                            DataCell(Text(off['due']!,
                                style: const TextStyle(fontSize: 13))),
                            DataCell(Text(off['visits']!,
                                style: const TextStyle(fontSize: 13))),
                            DataCell(Text(off['pending']!,
                                style: const TextStyle(fontSize: 13))),
                            DataCell(Text(off['alerts']!,
                                style: const TextStyle(fontSize: 13))),
                            DataCell(Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: badgeColor.withAlpha(20),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                off['status']!,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: badgeColor),
                              ),
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );

              final sidePanel = Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: kBorderGrey),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Workload Insights',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kTextDark),
                      ),
                      const Divider(height: 24, color: kBorderGrey),
                      _buildInsightRow(
                          'Highest Caseload District',
                          'Lahore District (Avg: 111.9 cases per officer)',
                          kStatusPending),
                      _buildInsightRow(
                          'Caseload Outliers',
                          '12 Officers exceed the recommended threshold of 120 cases',
                          kStatusOverdue),
                      _buildInsightRow(
                          'Assessment Backlog',
                          '48 Pending risk and needs assessments across sectors',
                          kStatusPending),
                      _buildInsightRow(
                          'Suggested Review',
                          'Reassign 15 cases in Sector B to balance active workload',
                          kStatusInfo),
                    ],
                  ),
                ),
              );

              if (isNarrow) {
                return Column(
                  children: [
                    mainTable,
                    const SizedBox(height: 16),
                    sidePanel,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: mainTable),
                  const SizedBox(width: 16),
                  Expanded(flex: 3, child: sidePanel),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInsightRow(String title, String desc, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 16, color: dotColor),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: kTextDark))),
            ],
          ),
          const SizedBox(height: 4),
          Text(desc,
              style: const TextStyle(
                  fontSize: 11, color: kTextMuted, height: 1.3)),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SECTION 5: COMPLIANCE DASHBOARD
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildComplianceDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Compliance Metrics',
            subtitle:
                'Overview of supervision compliance, risk divisions, and activity summaries',
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildVisualCard(
                  'Compliance Status Breakdown',
                  Icons.pie_chart_outline,
                  [
                    _buildProgressBar('Compliant (37,680 cases)', 0.942,
                        kStatusNormal, '94.2%'),
                    _buildProgressBar('Pending Review (1,640 cases)', 0.041,
                        kStatusPending, '4.1%'),
                    _buildProgressBar('Overdue Check-In (680 cases)', 0.017,
                        kStatusOverdue, '1.7%'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildVisualCard(
                  'Risk Level Distribution (RNA)',
                  Icons.analytics_outlined,
                  [
                    _buildProgressBar(
                        'Low Risk (23,200 cases)', 0.58, kStatusInfo, '58.0%'),
                    _buildProgressBar('Medium Risk (12,800 cases)', 0.32,
                        kStatusPending, '32.0%'),
                    _buildProgressBar('High Risk (4,000 cases)', 0.10,
                        kStatusOverdue, '10.0%'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildVisualCard(
                  'Alert Categories Summary',
                  Icons.warning_amber_outlined,
                  [
                    _buildProgressBar(
                        'Missed Check-Ins', 0.42, kStatusOverdue, '42%'),
                    _buildProgressBar(
                        'Missed Appointments', 0.28, kStatusOverdue, '28%'),
                    _buildProgressBar('Address Verification Pending', 0.15,
                        kStatusPending, '15%'),
                    _buildProgressBar(
                        'Risk Assessment Overdue', 0.10, kStatusPending, '10%'),
                    _buildProgressBar(
                        'Order Expiry Nearing', 0.05, kStatusInfo, '5%'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildVisualCard(
                  'Monthly Activity Summary',
                  Icons.event_note_outlined,
                  [
                    _buildProgressBar('Check-Ins Recorded (38,920)', 0.90,
                        kStatusNormal, '90%'),
                    _buildProgressBar('Office Visits Conducted (8,410)', 0.65,
                        kStatusInfo, '65%'),
                    _buildProgressBar('Field Visits Completed (1,240)', 0.45,
                        kStatusInfo, '45%'),
                    _buildProgressBar('Contacts Recorded (12,850)', 0.75,
                        kStatusNormal, '75%'),
                    _buildProgressBar(
                        'Referrals Made (1,890)', 0.30, kStatusPending, '30%'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVisualCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: kBorderGrey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: kGovGreenMid, size: 20),
                const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: kTextDark)),
              ],
            ),
            const Divider(height: 24, color: kBorderGrey),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(
      String label, double val, Color color, String trailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12,
                      color: kTextDark,
                      fontWeight: FontWeight.w500)),
              Text(trailing,
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: val,
            backgroundColor: kBorderGrey,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SECTION 6: RISK AND NEEDS OVERVIEW
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildRiskNeedsOverview() {
    final needs = [
      {'need': 'Employment & Vocational Training', 'pct': 0.48, 'val': '48%'},
      {'need': 'Accommodation & Housing Stability', 'pct': 0.32, 'val': '32%'},
      {
        'need': 'Family Support & Social Reintegration',
        'pct': 0.25,
        'val': '25%'
      },
      {'need': 'Substance Misuse Rehabilitation', 'pct': 0.18, 'val': '18%'},
      {
        'need': 'Mental Health & Psychological Counseling',
        'pct': 0.14,
        'val': '14%'
      },
      {
        'need': 'Education & Basic Skill Enhancement',
        'pct': 0.20,
        'val': '20%'
      },
      {'need': 'Cognitive Behavioural Counselling', 'pct': 0.15, 'val': '15%'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Risk and Needs Overview (RNA)',
            subtitle:
                'Strategic analysis of rehabilitation needs and risk levels across the province',
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Assessments Completed',
                  value: '35,420',
                  supportingText: 'Completed risk evaluation matrices',
                  icon: Icons.assignment_outlined,
                  accentColor: kStatusNormal,
                  statusText: 'Verified',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Assessments Pending',
                  value: '4,580',
                  supportingText: 'Due for periodic evaluation review',
                  icon: Icons.pending_actions_outlined,
                  accentColor: kStatusPending,
                  statusText: 'Pending',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'High-Risk Reviews Due',
                  value: '412',
                  supportingText: 'Immediate safety review tasks',
                  icon: Icons.notification_important_outlined,
                  accentColor: kStatusOverdue,
                  statusText: 'Overdue',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Needs Plans Created',
                  value: '18,450',
                  supportingText: 'Active rehabilitative structures',
                  icon: Icons.checklist_outlined,
                  accentColor: kStatusInfo,
                  statusText: 'Active',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Supervision Plans Updated',
                  value: '12,980',
                  supportingText: 'Updates submitted this quarter',
                  icon: Icons.edit_calendar_outlined,
                  accentColor: kGovGreenMid,
                  statusText: 'Updated',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: kBorderGrey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Identified Needs Categories Breakdown',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: kTextDark),
                        ),
                        const Divider(height: 24, color: kBorderGrey),
                        ...needs.map((n) => _buildProgressBar(
                            n['need'] as String,
                            n['pct'] as double,
                            kStatusInfo,
                            n['val'] as String)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50.withAlpha(80),
                    border: Border.all(color: Colors.amber.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.shield_outlined,
                              color: Colors.amber.shade800, size: 22),
                          const SizedBox(width: 10),
                          Text(
                            'Administrative Advisory',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Risk and needs indicators are displayed for management review only and do not represent automated decisions.',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber.shade900,
                            height: 1.5,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'All statistical metrics are modeled synthetically for the purpose of demonstrating supervision dashboards to criminal justice sector stakeholders.',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.amber.shade800,
                            height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SECTION 7: REHABILITATION REFERRALS
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildRehabReferrals() {
    final rehabData = [
      {
        'district': 'Lahore',
        'type': 'TEVTA Vocational Training',
        'referred': '245',
        'completed': '180',
        'pending': '50',
        'followup': '15'
      },
      {
        'district': 'Rawalpindi',
        'type': 'Substance Avoidance Counseling',
        'referred': '180',
        'completed': '124',
        'pending': '42',
        'followup': '14'
      },
      {
        'district': 'Faisalabad',
        'type': 'Employment Skill Placement',
        'referred': '210',
        'completed': '145',
        'pending': '50',
        'followup': '15'
      },
      {
        'district': 'Multan',
        'type': 'Cognitive Behavioural Counselling',
        'referred': '155',
        'completed': '98',
        'pending': '43',
        'followup': '14'
      },
      {
        'district': 'Gujranwala',
        'type': 'TEVTA Vocational Training',
        'referred': '190',
        'completed': '132',
        'pending': '45',
        'followup': '13'
      },
      {
        'district': 'Sahiwal',
        'type': 'Family Reintegration Therapy',
        'referred': '95',
        'completed': '70',
        'pending': '18',
        'followup': '7'
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Rehabilitation Referrals',
            subtitle:
                'Monitoring referrals and completion tracking for partner social services',
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Total Referrals',
                  value: '1,890',
                  supportingText: 'Referrals processed this year',
                  icon: Icons.school_outlined,
                  accentColor: kStatusInfo,
                  statusText: 'Processed',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Referrals Completed',
                  value: '1,240',
                  supportingText: 'Completed partner programs',
                  icon: Icons.check_circle_outline,
                  accentColor: kStatusNormal,
                  statusText: 'Completed',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Referrals Pending',
                  value: '530',
                  supportingText: 'Active program enrollments',
                  icon: Icons.hourglass_empty_outlined,
                  accentColor: kStatusPending,
                  statusText: 'Enrolled',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Partner Services',
                  value: '18',
                  supportingText: 'Active partner organizations',
                  icon: Icons.handshake_outlined,
                  accentColor: kGovGreenMid,
                  statusText: 'Partners',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Employment Referrals',
                  value: '473',
                  supportingText: 'Referrals for job placement',
                  icon: Icons.work_outline,
                  accentColor: kStatusInfo,
                  statusText: 'Placed',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Counselling Referrals',
                  value: '567',
                  supportingText: 'Therapy & behavior programs',
                  icon: Icons.psychology_outlined,
                  accentColor: kStatusPending,
                  statusText: 'Enrolled',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: kBorderGrey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Rehabilitation Outcomes Tracking Ledger',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: kTextDark),
                  ),
                ),
                const Divider(height: 1, color: kBorderGrey),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 40,
                    columns: const [
                      DataColumn(
                          label: Text('District',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(
                          label: Text('Referral Type',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(
                          label: Text('Cases Referred',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(
                          label: Text('Completed',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(
                          label: Text('Pending',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(
                          label: Text('Follow-up Required',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                    ],
                    rows: rehabData.map((r) {
                      return DataRow(cells: [
                        DataCell(Text(r['district']!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13))),
                        DataCell(Text(r['type']!,
                            style: const TextStyle(fontSize: 13))),
                        DataCell(Text(r['referred']!,
                            style: const TextStyle(fontSize: 13))),
                        DataCell(Text(r['completed']!,
                            style: const TextStyle(
                                fontSize: 13,
                                color: kStatusNormal,
                                fontWeight: FontWeight.bold))),
                        DataCell(Text(r['pending']!,
                            style: const TextStyle(fontSize: 13))),
                        DataCell(Text(r['followup']!,
                            style: TextStyle(
                                fontSize: 13,
                                color: int.parse(r['followup']!) > 14
                                    ? kStatusOverdue
                                    : kTextDark,
                                fontWeight: FontWeight.bold))),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SECTION 8: REPORTS
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildReports() {
    final reports = [
      {
        'title': 'Monthly Probation Work Statement',
        'desc':
            'Statutory monthly summary of all probation supervision orders, completions, and court submissions.',
        'date': '2026-07-01'
      },
      {
        'title': 'Monthly Parole Work Statement',
        'desc':
            'Statutory monthly summary of active parole releases, rehabilitation progress, and monitoring violations.',
        'date': '2026-07-01'
      },
      {
        'title': 'District Performance Report',
        'desc':
            'Comparative compliance monitoring report evaluating active supervision stats across all 36 districts of Punjab.',
        'date': '2026-07-15'
      },
      {
        'title': 'Officer Caseload Report',
        'desc':
            'Workload audit details tracking assigned cases, overdue assessments, and field visits per probation officer.',
        'date': '2026-07-20'
      },
      {
        'title': 'Digital Check-In Compliance Report',
        'desc':
            'Provincial compliance stats tracking check-ins completed via the mobile application.',
        'date': '2026-07-22'
      },
      {
        'title': 'Risk and Needs Assessment Report',
        'desc':
            'Provincial statistics summary of Risk and Needs assessments completed and rehabilitation plans.',
        'date': '2026-07-23'
      },
      {
        'title': 'Rehabilitation Referral Report',
        'desc':
            'Progress report tracking enrollments, partner services, and job placement stats.',
        'date': '2026-07-24'
      },
      {
        'title': 'Alert Summary Report',
        'desc':
            'System security logs compiling missed check-ins, missed appointments, and violation tasks.',
        'date': '2026-07-25'
      },
      {
        'title': 'Supervision Order Expiry Report',
        'desc':
            'List of supervision orders due to expire within 60 days requiring discharge summaries.',
        'date': '2026-07-26'
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Reports Management Centre',
            subtitle:
                'Generate and review formal departmental statements and performance audit reports',
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1000
                  ? 3
                  : constraints.maxWidth > 700
                      ? 2
                      : 1;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: reports.map((rep) {
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: kBorderGrey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rep['title']!,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: kGovGreen),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                rep['desc']!,
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: kTextMuted,
                                    height: 1.4),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Last Generated: ${rep['date']}',
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: kTextMuted,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: kGovGreenMid,
                                  side: const BorderSide(color: kGovGreenMid),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  minimumSize: Size.zero,
                                ),
                                onPressed: () =>
                                    _previewReportDialog(rep['title']!),
                                child: const Text('Preview',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                        Icons.picture_as_pdf_outlined,
                                        color: kStatusOverdue,
                                        size: 20),
                                    onPressed: () => _showExportMessage(
                                        rep['title']!, 'PDF'),
                                    tooltip: 'Export PDF',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.table_view_outlined,
                                        color: kStatusNormal, size: 20),
                                    onPressed: () => _showExportMessage(
                                        rep['title']!, 'Excel'),
                                    tooltip: 'Export Excel',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  void _previewReportDialog(String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: kTextDark)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Supervision Audit Report Preview (Fictional Records Only):',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 12),
              const Text(
                'Reporting Period: 01 July 2026 – 26 July 2026\n'
                'Provincial Active Cases: 40,000\n'
                'Overall Compliance Rate: 94.2%\n'
                'Integrity Check Status: Cryptographically Signed & Verified\n'
                'Authority Level: Directorate General Management and Monitoring Portal',
                style: TextStyle(fontSize: 12, height: 1.5, color: kTextDark),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                color: kBgGrey,
                child: const Text(
                  'This document compiles synthetic performance parameters for administrative review.',
                  style:
                      TextStyle(fontSize: 11, color: kTextMuted, height: 1.3),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close',
                  style: TextStyle(
                      color: kGovGreenMid, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showExportMessage(String report, String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Exporting report "$report" in $format format... (Fictional Data)'),
        backgroundColor: kGovGreenMid,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SECTION 9: AUDIT LOG
  // ─────────────────────────────────────────────────────────────────────────────
  bool _verifyingAudit = false;
  bool _verifiedAuditIntact = true;
  String _auditMessage =
      "Audit chain cryptographically verified intact. All ledger logs are tamper-evident.";

  Widget _buildAuditLog() {
    final auditLogs = [
      {
        'time': '2026-07-26 13:02:15',
        'role': 'DG_MANAGEMENT',
        'action': 'Provincial dashboard viewed',
        'module': 'Provincial Overview',
        'ref': 'N/A',
        'status': 'Verified'
      },
      {
        'time': '2026-07-26 12:45:10',
        'role': 'DG_MANAGEMENT',
        'action': 'District monitoring report opened',
        'module': 'District Monitoring',
        'ref': 'LHR-LEDGER',
        'status': 'Verified'
      },
      {
        'time': '2026-07-26 11:30:22',
        'role': 'MONITORING_CELL',
        'action': 'Officer workload panel reviewed',
        'module': 'Officer Workload',
        'ref': 'OFF-012',
        'status': 'Verified'
      },
      {
        'time': '2026-07-26 10:15:05',
        'role': 'MONITORING_CELL',
        'action': 'Alert summary previewed',
        'module': 'Compliance Dashboard',
        'ref': 'ALT-089',
        'status': 'System Entry'
      },
      {
        'time': '2026-07-26 09:12:00',
        'role': 'DG_MANAGEMENT',
        'action': 'Rehabilitation report generated',
        'module': 'Reports',
        'ref': 'REP-REHAB',
        'status': 'Verified'
      },
      {
        'time': '2026-07-26 08:30:45',
        'role': 'SYSTEM_ADMIN',
        'action': 'Administration settings viewed',
        'module': 'Administration',
        'ref': 'CFG-GLOBAL',
        'status': 'Review'
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Audit & Integrity Ledger',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: kTextDark),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Provincial tamper-evident security audit trails and log integrity verification',
                      style: TextStyle(fontSize: 13, color: kTextMuted),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGovGreen,
                  foregroundColor: kGovWhite,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                icon: _verifyingAudit
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            color: kGovWhite, strokeWidth: 2))
                    : const Icon(Icons.lock_reset, size: 18),
                label: const Text('Verify Ledger Integrity',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                onPressed: _verifyingAudit ? null : _runLedgerVerification,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            color: _verifiedAuditIntact
                ? const Color(0xFFF0FDF4)
                : const Color(0xFFFEF2F2),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                  color: _verifiedAuditIntact
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFFEE2E2)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    _verifiedAuditIntact
                        ? Icons.check_circle_outline
                        : Icons.error_outline,
                    color:
                        _verifiedAuditIntact ? kStatusNormal : kStatusOverdue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _auditMessage,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _verifiedAuditIntact
                              ? kStatusNormal
                              : kStatusOverdue),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: kBorderGrey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Tamper-Evident System Activities Log',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: kTextDark),
                  ),
                ),
                const Divider(height: 1, color: kBorderGrey),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 32,
                    columns: const [
                      DataColumn(
                          label: Text('Date and Time',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(
                          label: Text('User Role',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(
                          label: Text('Action',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(
                          label: Text('Module',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(
                          label: Text('Record Reference',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(
                          label: Text('Integrity Status',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13))),
                    ],
                    rows: auditLogs.map((log) {
                      Color badgeColor;
                      if (log['status'] == 'Verified') {
                        badgeColor = kStatusNormal;
                      } else if (log['status'] == 'System Entry') {
                        badgeColor = kStatusInfo;
                      } else {
                        badgeColor = kStatusPending;
                      }

                      return DataRow(cells: [
                        DataCell(Text(log['time']!,
                            style: const TextStyle(fontSize: 13))),
                        DataCell(Text(log['role']!,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600))),
                        DataCell(Text(log['action']!,
                            style: const TextStyle(fontSize: 13))),
                        DataCell(Text(log['module']!,
                            style: const TextStyle(fontSize: 13))),
                        DataCell(Text(log['ref']!,
                            style: const TextStyle(fontSize: 13))),
                        DataCell(Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: badgeColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            log['status']!,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: badgeColor),
                          ),
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Audit records shown here are fictional and for interface review only.',
              style: TextStyle(
                  fontSize: 10, color: kTextMuted, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  void _runLedgerVerification() {
    setState(() {
      _verifyingAudit = true;
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _verifyingAudit = false;
        _verifiedAuditIntact = true;
        _auditMessage =
            'HMAC-SHA256 Hash Chain Verification Succeeded: Audit records verified as intact and authentic.';
      });
    });
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SECTION 10: ADMINISTRATION
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildAdministration() {
    final adminCards = [
      {
        'title': 'User Management',
        'desc':
            'Manage active Directorate General, division and district level user accounts, roles and credentials.',
        'icon': Icons.supervisor_account_outlined,
        'status': 'Online'
      },
      {
        'title': 'Role Permissions',
        'desc':
            'Configure granular role-based access control policies across administrative zones.',
        'icon': Icons.admin_panel_settings_outlined,
        'status': 'Enforced'
      },
      {
        'title': 'District Configuration',
        'desc':
            'Configure sectors and supervision limits for the 36 district offices in Punjab.',
        'icon': Icons.home_work_outlined,
        'status': 'Stable'
      },
      {
        'title': 'Officer Assignment',
        'desc':
            'Automated caseload thresholds and reassignment procedures for supervision staff.',
        'icon': Icons.assignment_ind_outlined,
        'status': 'Active'
      },
      {
        'title': 'Data Export Controls',
        'desc':
            'Set cryptographic signature validation and download parameters for data audits.',
        'icon': Icons.import_export_outlined,
        'status': 'Restricted'
      },
      {
        'title': 'Notification Settings',
        'desc':
            'Configure system triggers for missed appointments and overdue assessments.',
        'icon': Icons.notifications_active_outlined,
        'status': 'Active'
      },
      {
        'title': 'Security Settings',
        'desc':
            'Enforce session timeouts and cryptographic signature protocols for audit logs.',
        'icon': Icons.security_outlined,
        'status': 'Optimal'
      },
      {
        'title': 'System Configuration',
        'desc':
            'Configure overall system rules, backup configurations, and active dashboard models.',
        'icon': Icons.settings_applications_outlined,
        'status': 'Stable'
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Administration Control Panel',
            subtitle:
                'Configure operational parameters, permissions, and system configurations',
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1000
                  ? 3
                  : constraints.maxWidth > 700
                      ? 2
                      : 1;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: adminCards.map((card) {
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: kBorderGrey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(card['icon'] as IconData,
                                  color: kGovGreenMid, size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      card['title'] as String,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: kTextDark),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      card['desc'] as String,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: kTextMuted,
                                          height: 1.4),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: kGovGreenSurface,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: kGovGreenLight.withAlpha(80)),
                                ),
                                child: Text(
                                  card['status'] as String,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: kGovGreenMid),
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: kGovGreenMid,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Administrative control panel loaded for "${card['title']}"'),
                                      backgroundColor: kGovGreenMid,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: const Text('Open Module',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPACT WIDGETS
// ─────────────────────────────────────────────────────────────────────────────
class _TopHeader extends StatelessWidget {
  const _TopHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 1000;

    return Container(
      height: 95,
      decoration: const BoxDecoration(
        color: kGovWhite,
        border: Border(bottom: BorderSide(color: kBorderGrey, width: 1.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Logo (Clear, balanced, 60px)
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kBgGrey,
            ),
            child: ClipOval(
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
          const SizedBox(width: 16),

          // Titles & Subtitles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Punjab Probation and Parole Service',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: kGovGreen,
                    letterSpacing: 0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                const Text(
                  'Home Department, Government of the Punjab',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: kGovGreenMid),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Wrap(
                  spacing: 8,
                  runSpacing: 2,
                  children: [
                    const Text(
                      'Punjab Digital Community Supervision System',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: kTextMuted),
                    ),
                    if (!isNarrow) ...[
                      const Text('|',
                          style: TextStyle(fontSize: 10, color: kTextMuted)),
                      const Text(
                        'Directorate General Management and Monitoring Portal',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: kGovGreen),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Current role and profile
          Row(
            children: [
              if (!isNarrow) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: kGovGreenSurface,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: kGovGreenLight.withAlpha(80)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Directorate General View',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: kGovGreenMid),
                      ),
                      Text(
                        'Level: Provincial Oversight',
                        style: TextStyle(
                            fontSize: 8,
                            color: kTextMuted,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.notifications_none_outlined,
                    color: kTextMuted, size: 24),
                const SizedBox(width: 16),
                Container(
                  height: 40,
                  width: 1.5,
                  color: kBorderGrey,
                ),
                const SizedBox(width: 16),
              ],
              Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: kGovGreenMid,
                    child: Icon(Icons.person, color: kGovWhite, size: 18),
                  ),
                  if (!isNarrow) ...[
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Monitoring Cell',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: kTextDark),
                        ),
                        Text(
                          'DG Office, Lahore',
                          style: TextStyle(fontSize: 10, color: kTextMuted),
                        ),
                      ],
                    ),
                  ],
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
      width: 250,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A), // Sleek executive dark slate
        border: Border(right: BorderSide(color: kBorderGrey, width: 1.5)),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;
                return Material(
                  color: Colors.transparent,
                  child: ListTile(
                    selected: isSelected,
                    selectedTileColor: kGovGreen.withAlpha(40),
                    leading: Icon(
                      _getIcon(index),
                      color: isSelected ? kGovGreenLight : Colors.white70,
                      size: 20,
                    ),
                    title: Text(
                      navItems[index],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.white70,
                      ),
                    ),
                    onTap: () => onSelect(index),
                    horizontalTitleGap: 8,
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
        return Icons.analytics_outlined;
      case 6:
        return Icons.school_outlined;
      case 7:
        return Icons.assessment_outlined;
      case 8:
        return Icons.verified_user_outlined;
      case 9:
        return Icons.admin_panel_settings_outlined;
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
              height: 24,
              decoration: BoxDecoration(
                color: kGovGreenMid,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: kTextDark),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: kTextMuted),
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
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: kBorderGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 4,
            offset: const Offset(0, 1),
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
              Icon(icon, color: accentColor, size: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: accentColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
      height: 40,
      decoration: const BoxDecoration(
        color: kGovWhite,
        border: Border(top: BorderSide(color: kBorderGrey, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'Sample interface with fictional records for review and presentation purposes.',
              style: TextStyle(
                  fontSize: 10, color: kTextMuted, fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Prototype Demo Version v1.3 | PP&PS',
            style: TextStyle(
                fontSize: 10, color: kTextMuted, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
