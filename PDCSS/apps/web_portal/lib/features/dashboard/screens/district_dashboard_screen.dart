import 'package:flutter/material.dart';
import 'package:web_portal/features/audit/screens/audit_log_screen.dart';

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
    'Compliance Dashboard',
    'Reports',
    'Administration',
    'Audit Log',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F766E),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Punjab Digital Community Supervision System',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              'Directorate of Probation and Parole Service · Home Department, Govt of Punjab',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Banner & Mandatory Disclaimer Top Bar
          Container(
            width: double.infinity,
            color: const Color(0xFFFEF3C7),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: Color(0xFF92400E), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Demonstration prototype using fictional data only. Not connected to any official PP&PS database, court record, prison system or government identity service.',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF92400E)),
                  ),
                ),
              ],
            ),
          ),

          // Main Layout with Navigation Tabs
          Expanded(
            child: Row(
              children: [
                // Navigation Sidebar
                Container(
                  width: 240,
                  color: const Color(0xFF0F172A),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        ...List.generate(_navItems.length, (index) {
                          final isSelected = _selectedNavIndex == index;
                          return ListTile(
                            selected: isSelected,
                            selectedTileColor: const Color(0xFF0F766E),
                            leading: Icon(
                              _getNavIcon(index),
                              color: isSelected ? Colors.white : Colors.white70,
                            ),
                            title: Text(
                              _navItems[index],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected ? Colors.white : Colors.white70,
                              ),
                            ),
                            onTap: () =>
                                setState(() => _selectedNavIndex = index),
                          );
                        }),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Prototype Demo v1.2\nJuly 2026',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Main Content View
                Expanded(
                  child: Container(
                    color: const Color(0xFFF8FAFC),
                    child: _buildSelectedSection(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNavIcon(int index) {
    switch (index) {
      case 0:
        return Icons.dashboard;
      case 1:
        return Icons.location_city;
      case 2:
        return Icons.map;
      case 3:
        return Icons.pie_chart;
      case 4:
        return Icons.assessment;
      case 5:
        return Icons.admin_panel_settings;
      case 6:
        return Icons.security;
      default:
        return Icons.circle;
    }
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
        return _buildComplianceDashboard();
      case 4:
        return _buildReportsSection();
      case 5:
        return _buildAdministrationSection();
      case 6:
        return const AuditLogScreen();
      default:
        return _buildProvincialOverview();
    }
  }

  // 1. PROVINCIAL OVERVIEW
  Widget _buildProvincialOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Provincial Supervision Overview',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 4),
          const Text(
              'Provincial statistics across Punjab Probation and Parole Service',
              style: TextStyle(color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 24),

          // 8 Required Fictional Metric Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildStatCard('Total Active Supervisees', '14,850',
                      const Color(0xFF0F766E), Icons.people),
                  _buildStatCard('Active Probationers', '10,420', Colors.teal,
                      Icons.gavel),
                  _buildStatCard('Active Parolees', '4,430', Colors.indigo,
                      Icons.verified_user),
                  _buildStatCard(
                      'Districts Covered', '36', Colors.blue, Icons.map),
                  _buildStatCard(
                      'Active Officers', '412', Colors.purple, Icons.badge),
                  _buildStatCard('Check-Ins This Month', '38,920', Colors.green,
                      Icons.check_circle_outline),
                  _buildStatCard(
                      'Overdue Cases', '142', Colors.red, Icons.warning_amber),
                  _buildStatCard('Rehabilitation Referrals', '1,890',
                      Colors.orange, Icons.school),
                ],
              );
            },
          ),
          const SizedBox(height: 32),

          const Text('Recent High-Priority Activity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Card(
              elevation: 2,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Registration #')),
                  DataColumn(label: Text('District')),
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Compliance Status')),
                  DataColumn(label: Text('Assigned Officer')),
                  DataColumn(label: Text('Last Activity Date')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('LHR-2026-089')),
                    DataCell(Text('Lahore')),
                    DataCell(Chip(
                        label: Text('Probation',
                            style: TextStyle(fontSize: 10, color: Colors.white)),
                        backgroundColor: Color(0xFF0F766E))),
                    DataCell(Text('Compliant',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold))),
                    DataCell(Text('Tahir Mahmood')),
                    DataCell(Text('26 July 2026')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('RWP-2026-114')),
                    DataCell(Text('Rawalpindi')),
                    DataCell(Chip(
                        label: Text('Parole',
                            style: TextStyle(fontSize: 10, color: Colors.white)),
                        backgroundColor: Colors.indigo)),
                    DataCell(Text('Compliant',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold))),
                    DataCell(Text('Sajid Hussain')),
                    DataCell(Text('25 July 2026')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('LHR-2026-142')),
                    DataCell(Text('Lahore')),
                    DataCell(Chip(
                        label: Text('Parole',
                            style: TextStyle(fontSize: 10, color: Colors.white)),
                        backgroundColor: Colors.indigo)),
                    DataCell(Text('Overdue',
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.bold))),
                    DataCell(Text('Kamran Akhtar')),
                    DataCell(Text('25 July 2026')),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  // 2. DISTRICT MONITORING
  Widget _buildDistrictMonitoring() {
    final districts = [
      {
        'div': 'Lahore',
        'dist': 'Lahore',
        'active': '3,140',
        'dueToday': '142',
        'overdue': '28',
        'officers': '42',
        'comp': '94.2%'
      },
      {
        'div': 'Rawalpindi',
        'dist': 'Rawalpindi',
        'active': '2,210',
        'dueToday': '98',
        'overdue': '14',
        'officers': '34',
        'comp': '95.6%'
      },
      {
        'div': 'Multan',
        'dist': 'Multan',
        'active': '1,890',
        'dueToday': '85',
        'overdue': '19',
        'officers': '28',
        'comp': '92.8%'
      },
      {
        'div': 'Faisalabad',
        'dist': 'Faisalabad',
        'active': '2,450',
        'dueToday': '110',
        'overdue': '22',
        'officers': '38',
        'comp': '93.5%'
      },
      {
        'div': 'Gujranwala',
        'dist': 'Gujranwala',
        'active': '1,780',
        'dueToday': '76',
        'overdue': '15',
        'officers': '26',
        'comp': '94.8%'
      },
      {
        'div': 'Bahawalpur',
        'dist': 'Bahawalpur',
        'active': '1,120',
        'dueToday': '48',
        'overdue': '12',
        'officers': '18',
        'comp': '91.4%'
      },
      {
        'div': 'Sargodha',
        'dist': 'Sargodha',
        'active': '940',
        'dueToday': '40',
        'overdue': '11',
        'officers': '16',
        'comp': '90.8%'
      },
      {
        'div': 'Sahiwal',
        'dist': 'Sahiwal',
        'active': '720',
        'dueToday': '32',
        'overdue': '8',
        'officers': '14',
        'comp': '93.1%'
      },
      {
        'div': 'D.G. Khan',
        'dist': 'D.G. Khan',
        'active': '600',
        'dueToday': '24',
        'overdue': '13',
        'officers': '12',
        'comp': '88.5%'
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('District Supervision Monitoring',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 4),
          const Text(
              'District-wise active caseload, check-in compliance, and staffing metrics',
              style: TextStyle(color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            child: SizedBox(
              width: double.infinity,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Division')),
                  DataColumn(label: Text('District')),
                  DataColumn(label: Text('Active Cases')),
                  DataColumn(label: Text('Due Today')),
                  DataColumn(label: Text('Overdue')),
                  DataColumn(label: Text('Officers')),
                  DataColumn(label: Text('Compliance %')),
                ],
                rows: districts.map((d) {
                  return DataRow(cells: [
                    DataCell(Text(d['div']!,
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(d['dist']!)),
                    DataCell(Text(d['active']!)),
                    DataCell(Text(d['dueToday']!)),
                    DataCell(Text(d['overdue']!,
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold))),
                    DataCell(Text(d['officers']!)),
                    DataCell(Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(d['comp']!,
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. DIVISIONAL SUMMARY
  Widget _buildDivisionalSummary() {
    final divisions = [
      {
        'name': 'Lahore Division',
        'districts': 'Lahore, Kasur, Sheikhupura, Nankana Sahib',
        'cases': '4,850',
        'probation': '3,400',
        'parole': '1,450',
        'rate': '94.5%'
      },
      {
        'name': 'Rawalpindi Division',
        'districts': 'Rawalpindi, Attock, Jhelum, Chakwal',
        'cases': '3,100',
        'probation': '2,200',
        'parole': '900',
        'rate': '95.2%'
      },
      {
        'name': 'Faisalabad Division',
        'districts': 'Faisalabad, Jhang, T.T. Singh, Chiniot',
        'cases': '3,250',
        'probation': '2,300',
        'parole': '950',
        'rate': '93.8%'
      },
      {
        'name': 'Multan Division',
        'districts': 'Multan, Khanewal, Vehari, Lodhran',
        'cases': '2,400',
        'probation': '1,650',
        'parole': '750',
        'rate': '92.6%'
      },
      {
        'name': 'Gujranwala Division',
        'districts':
            'Gujranwala, Gujrat, Sialkot, Narowal, Hafizabad, Wazirabad',
        'cases': '2,800',
        'probation': '1,950',
        'parole': '850',
        'rate': '94.1%'
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Divisional Executive Summary',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 4),
          const Text(
              'High-level divisional summaries across Punjab administrative divisions',
              style: TextStyle(color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 24),
          ...divisions.map((div) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(div['name']!,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F766E))),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F766E),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text('Average Compliance: ${div['rate']}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('Districts: ${div['districts']}',
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 13)),
                    const Divider(height: 20),
                    Row(
                      children: [
                        Expanded(
                            child:
                                _buildMiniStat('Total Cases', div['cases']!)),
                        Expanded(
                            child: _buildMiniStat(
                                'Probationers', div['probation']!)),
                        Expanded(
                            child: _buildMiniStat('Parolees', div['parole']!)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // 4. COMPLIANCE DASHBOARD
  Widget _buildComplianceDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Compliance & Rehabilitation Dashboard',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 4),
          const Text(
              'Visual breakdowns of compliance rates, risk distributions, and rehab referrals',
              style: TextStyle(color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildVisualCard(
                  'Compliance Status Breakdown',
                  Icons.pie_chart,
                  [
                    _buildProgressBar('Compliant (13,720 cases)', 0.924,
                        Colors.green, '92.4%'),
                    _buildProgressBar('Overdue Check-In (712 cases)', 0.048,
                        Colors.orange, '4.8%'),
                    _buildProgressBar('Flagged Violations (418 cases)', 0.028,
                        Colors.red, '2.8%'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildVisualCard(
                  'Risk-Level Distribution (RNA)',
                  Icons.analytics,
                  [
                    _buildProgressBar(
                        'Low Risk (8,610 cases)', 0.58, Colors.blue, '58.0%'),
                    _buildProgressBar('Medium Risk (4,600 cases)', 0.31,
                        Colors.amber.shade700, '31.0%'),
                    _buildProgressBar(
                        'High Risk (1,640 cases)', 0.11, Colors.red, '11.0%'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildVisualCard(
                  'Alert Categories Summary',
                  Icons.warning,
                  [
                    _buildProgressBar('Missed Appointments (112 alerts)', 0.40,
                        Colors.red, '40%'),
                    _buildProgressBar('Overdue Risk Assessments (84 alerts)',
                        0.30, Colors.orange, '30%'),
                    _buildProgressBar(
                        'Address Verification Pending (56 alerts)',
                        0.20,
                        Colors.blue,
                        '20%'),
                    _buildProgressBar('Order Nearing Expiry (28 alerts)', 0.10,
                        Colors.teal, '10%'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildVisualCard(
                  'Rehabilitation Referral Breakdown',
                  Icons.school,
                  [
                    _buildProgressBar(
                        'TEVTA Vocational Courses (850 referrals)',
                        0.45,
                        Colors.purple,
                        '45%'),
                    _buildProgressBar(
                        'Addiction Support & Counseling (567 referrals)',
                        0.30,
                        Colors.indigo,
                        '30%'),
                    _buildProgressBar('Employment Placement (473 referrals)',
                        0.25, Colors.teal, '25%'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 5. REPORTS SECTION
  Widget _buildReportsSection() {
    final reports = [
      {
        'title': 'Monthly Probation Work Statement',
        'desc':
            'Statutory monthly report of probation orders and case outcomes.'
      },
      {
        'title': 'District Performance Report',
        'desc': 'Comparative compliance performance across all 36 districts.'
      },
      {
        'title': 'Officer Caseload Report',
        'desc':
            'Workload distribution and active supervision metrics per officer.'
      },
      {
        'title': 'Check-In Compliance Report',
        'desc': 'Digital reporting completion rates and overdue trends.'
      },
      {
        'title': 'Rehabilitation Referral Report',
        'desc':
            'Vocational training, employment, and counseling enrollment tracking.'
      },
      {
        'title': 'Alert Summary Report',
        'desc':
            'System alert trends, resolution speed, and pending review queue.'
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Management Reports & Analytics',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 4),
          const Text(
              'Generate and preview demonstration supervision reports for directorate review',
              style: TextStyle(color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.2,
            children: reports.map((rep) {
              return Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(rep['title']!,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F766E))),
                          const SizedBox(height: 6),
                          Text(rep['desc']!,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F766E),
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.preview, size: 16),
                            label: const Text('Preview Demo Report',
                                style: TextStyle(fontSize: 12)),
                            onPressed: () => _showReportPreview(rep['title']!),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showReportPreview(String reportTitle) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.assessment, color: Color(0xFF0F766E)),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(reportTitle,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold))),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Demonstration Report Preview (Fictional Data):',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(
                  '• Reporting Period: 01 July 2026 – 26 July 2026\n• Total Supervisees Covered: 14,850\n• Overall Compliance Rate: 92.4%\n• Active Probation Officers: 412\n• Generated By: Directorate Management Web Portal'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                color: const Color(0xFFF1F5F9),
                child: const Text(
                    'Note: Download action exports synthetic sample data only.',
                    style: TextStyle(fontSize: 12, color: Colors.black87)),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  foregroundColor: Colors.white),
              icon: const Icon(Icons.download, size: 16),
              label: const Text('Export Demo Report (PDF/CSV)'),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Exported Demo File for "$reportTitle"'),
                      backgroundColor: const Color(0xFF0F766E)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // 6. ADMINISTRATION SECTION
  Widget _buildAdministrationSection() {
    final adminModules = [
      {
        'title': 'User Management',
        'desc':
            'Manage 412 active officer accounts, roles, and administrative credentials.',
        'icon': Icons.people
      },
      {
        'title': 'Role Permissions',
        'desc':
            'Configure role-based access control policies across provincial and district levels.',
        'icon': Icons.security
      },
      {
        'title': 'District Configuration',
        'desc':
            'Configure 36 district offices, boundaries, and regional oversight params.',
        'icon': Icons.business
      },
      {
        'title': 'Officer Assignment',
        'desc':
            'Reallocate caseloads and reassign supervisees between probation officers.',
        'icon': Icons.swap_horiz
      },
      {
        'title': 'Audit Logs',
        'desc':
            'Inspect tamper-evident system ledger and cryptographic verification hashes.',
        'icon': Icons.verified
      },
      {
        'title': 'System Settings',
        'desc':
            'Manage global demonstration parameters, notice banners, and portal preferences.',
        'icon': Icons.settings
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('System Administration',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 4),
          const Text(
              'Administrative control panel and policy management placeholders',
              style: TextStyle(color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.8,
            children: adminModules.map((mod) {
              return Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(mod['icon'] as IconData,
                              color: const Color(0xFF0F766E), size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(mod['title'] as String,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))),
                        ],
                      ),
                      Text(mod['desc'] as String,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Demonstration Mode: ${mod['title']} settings loaded.'),
                                  backgroundColor: const Color(0xFF0F766E)),
                            );
                          },
                          child: const Text('Manage (Demo)',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF0F766E))),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // HELPER WIDGETS
  Widget _buildStatCard(
      String title, String value, Color color, IconData icon) {
    return SizedBox(
      width: 210,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 10),
              Text(value,
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Text(title,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, color: Colors.black54)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F766E))),
      ],
    );
  }

  Widget _buildVisualCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF0F766E), size: 20),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(
      String label, double value, Color color, String percentText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600)),
              Text(percentText,
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: value,
            backgroundColor: color.withAlpha(38),
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
