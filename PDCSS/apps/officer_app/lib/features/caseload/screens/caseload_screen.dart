import 'package:flutter/material.dart';

class CaseloadScreen extends StatefulWidget {
  const CaseloadScreen({Key? key}) : super(key: key);

  @override
  State<CaseloadScreen> createState() => _CaseloadScreenState();
}

class _CaseloadScreenState extends State<CaseloadScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'ALL';

  final List<Map<String, dynamic>> _cases = [
    {
      'name': 'Tariq Mehmood',
      'reg': 'LHR-2026-089',
      'cnic': '00000-0000000-0',
      'district': 'Lahore',
      'type': 'Probation',
      'risk': 'Low',
      'status': 'Compliant',
      'nextAppointment': '28 July 2026, 10:00 AM',
      'startDate': '15 January 2026',
      'expiryDate': '15 December 2026',
      'conditions':
          '• Monthly office reporting\n• Retain employment\n• 40 hours community service',
      'contacts':
          '• 22 July: Office Visit (Completed)\n• 15 June: Initial Assessment',
      'rnaScore': 'Low Risk (Score: 14/100)',
      'rehabPlan': 'TEVTA Vocational Computer Course (Enrolled)',
      'nextAction': 'Review upcoming digital check-in due 28 July',
    },
    {
      'name': 'Ahmed Hassan',
      'reg': 'LHR-2026-142',
      'cnic': '00000-0000000-0',
      'district': 'Lahore',
      'type': 'Parole',
      'risk': 'High',
      'status': 'Overdue',
      'nextAppointment': '25 July 2026 (Missed)',
      'startDate': '01 March 2026',
      'expiryDate': '01 March 2027',
      'conditions':
          '• Bi-weekly office reporting\n• Travel restriction outside Lahore district\n• Substance counseling',
      'contacts': '• 10 July: Phone Call\n• 25 June: Workplace Visit',
      'rnaScore': 'High Risk (Score: 68/100)',
      'rehabPlan': 'Substance Avoidance Counseling & Family Support',
      'nextAction': 'Issue overdue reporting warning notice',
    },
    {
      'name': 'Umar Farooq',
      'reg': 'LHR-2026-031',
      'cnic': '00000-0000000-0',
      'district': 'Lahore',
      'type': 'Probation',
      'risk': 'Medium',
      'status': 'Compliant',
      'nextAppointment': '01 August 2026, 11:00 AM',
      'startDate': '10 February 2026',
      'expiryDate': '10 February 2027',
      'conditions': '• Monthly office reporting\n• Vocational skill training',
      'contacts': '• 18 July: Office Visit\n• 02 June: Home Visit',
      'rnaScore': 'Medium Risk (Score: 42/100)',
      'rehabPlan': 'TEVTA Electrical Trade Certification',
      'nextAction': 'Conduct 90-day periodic RNA assessment',
    },
    {
      'name': 'Zubair Khan',
      'reg': 'LHR-2026-217',
      'cnic': '00000-0000000-0',
      'district': 'Lahore',
      'type': 'Probation',
      'risk': 'High',
      'status': 'Violation',
      'nextAppointment': '29 July 2026, 11:30 AM (Field Visit)',
      'startDate': '20 April 2026',
      'expiryDate': '20 April 2027',
      'conditions':
          '• Weekly office reporting\n• Mandatory residence verification',
      'contacts': '• 12 July: Phone Call (Unanswered)\n• 28 June: Office Visit',
      'rnaScore': 'High Risk (Score: 74/100)',
      'rehabPlan': 'Behavioral Intervention Program',
      'nextAction': 'Execute planned field visit for residence verification',
    },
  ];

  List<Map<String, dynamic>> get _filteredCases {
    return _cases.where((c) {
      final matchesSearch =
          c['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
              c['reg'].toLowerCase().contains(_searchQuery.toLowerCase());
      if (_selectedFilter == 'ALL') return matchesSearch;
      return matchesSearch && c['status'].toUpperCase() == _selectedFilter;
    }).toList();
  }

  void _openCaseProfile(Map<String, dynamic> c) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CaseProfileScreen(caseData: c),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D9488),
        title: const Text('My Caseload', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search by supervisee name or reg #...',
                    prefixIcon:
                        const Icon(Icons.search, color: Color(0xFF0D9488)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['ALL', 'COMPLIANT', 'OVERDUE', 'VIOLATION']
                        .map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          selectedColor: const Color(0xFFCCFBF1),
                          onSelected: (_) =>
                              setState(() => _selectedFilter = filter),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Case List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredCases.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final c = _filteredCases[index];
                return _CaseCard(caseData: c, onTap: () => _openCaseProfile(c));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CaseCard extends StatelessWidget {
  final Map<String, dynamic> caseData;
  final VoidCallback onTap;
  const _CaseCard({required this.caseData, required this.onTap});

  Color get _statusColor {
    switch (caseData['status']) {
      case 'Compliant':
        return Colors.green;
      case 'Overdue':
        return Colors.orange;
      case 'Violation':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFCCFBF1),
          child: Text(
            caseData['name'].substring(0, 1),
            style: const TextStyle(
                color: Color(0xFF0D9488), fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(caseData['name'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
                '${caseData['reg']} · ${caseData['district']} · CNIC: ${caseData['cnic']}',
                style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                Chip(
                  label: Text(caseData['type'],
                      style:
                          const TextStyle(fontSize: 10, color: Colors.white)),
                  backgroundColor: const Color(0xFF0D9488),
                  visualDensity: VisualDensity.compact,
                ),
                Chip(
                  label: Text('Risk: ${caseData['risk']}',
                      style:
                          const TextStyle(fontSize: 10, color: Colors.white)),
                  backgroundColor: caseData['risk'] == 'High'
                      ? Colors.red
                      : (caseData['risk'] == 'Medium'
                          ? Colors.orange
                          : Colors.blue),
                  visualDensity: VisualDensity.compact,
                ),
                Chip(
                  label: Text(caseData['status'],
                      style:
                          const TextStyle(fontSize: 10, color: Colors.white)),
                  backgroundColor: _statusColor,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}

class CaseProfileScreen extends StatelessWidget {
  final Map<String, dynamic> caseData;
  const CaseProfileScreen({Key? key, required this.caseData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Case Profile - ${caseData['reg']}'),
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Card(
              color: const Color(0xFF0D9488),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person,
                          size: 40, color: Color(0xFF0D9488)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            caseData['name'],
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Case Ref: ${caseData['reg']} · ${caseData['type']}',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.white70),
                          ),
                          Text(
                            'District: ${caseData['district']} · CNIC: ${caseData['cnic']}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildSectionCard(
              '1. Basic Case Information',
              Icons.badge,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                      'Supervision Order Start', caseData['startDate']),
                  _buildDetailRow(
                      'Supervision Expiry Date', caseData['expiryDate']),
                  _buildDetailRow(
                      'Current Compliance Status', caseData['status']),
                  _buildDetailRow('Next Scheduled Appointment',
                      caseData['nextAppointment']),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildSectionCard(
              '2. Supervision Conditions',
              Icons.gavel,
              Text(caseData['conditions'],
                  style: const TextStyle(fontSize: 13, height: 1.5)),
            ),
            const SizedBox(height: 16),

            _buildSectionCard(
              '3. Recent Contacts',
              Icons.history,
              Text(caseData['contacts'],
                  style: const TextStyle(fontSize: 13, height: 1.5)),
            ),
            const SizedBox(height: 16),

            _buildSectionCard(
              '4. Risk & Needs Summary (RNA)',
              Icons.analytics,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RNA Category: ${caseData['rnaScore']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 6),
                  const Text(
                      'Identified Needs: Vocational stability, pro-social support network.',
                      style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildSectionCard(
              '5. Rehabilitation Plan',
              Icons.school,
              Text(caseData['rehabPlan'],
                  style: const TextStyle(fontSize: 13, height: 1.5)),
            ),
            const SizedBox(height: 16),

            _buildSectionCard(
              '6. Next Required Action',
              Icons.pending_actions,
              Text(caseData['nextAction'],
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D9488))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, Widget content) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF0D9488), size: 20),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
            const Divider(height: 20),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          Text(value,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
