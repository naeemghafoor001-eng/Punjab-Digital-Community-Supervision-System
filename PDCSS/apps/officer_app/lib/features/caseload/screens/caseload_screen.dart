import 'package:flutter/material.dart';
import 'package:officer_app/core/theme/officer_app_theme.dart';

class CaseloadScreen extends StatefulWidget {
  const CaseloadScreen({Key? key}) : super(key: key);

  @override
  State<CaseloadScreen> createState() => _CaseloadScreenState();
}

class _CaseloadScreenState extends State<CaseloadScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _cases = [
    {
      'name': 'Tariq Mehmood',
      'reg': 'LHR-2026-089',
      'district': 'Lahore',
      'type': 'Probation',
      'risk': 'Low',
      'status': 'Compliant',
      'nextAppointment': '28 Jul 2026',
      'startDate': '15 January 2026',
      'expiryDate': '15 December 2026',
      'conditions':
          '• Monthly office reporting\n• Retain lawful employment\n• 40 hours community service',
      'contacts':
          '• 22 July 2026: Office Visit (Completed)\n• 15 June 2026: Initial Assessment',
      'rnaScore': 'Low Risk — Score: 14 / 100',
      'rehabPlan': 'TEVTA Vocational Computer Course (Enrolled)',
      'nextAction': 'Review digital check-in scheduled for 28 July 2026',
    },
    {
      'name': 'Ahmed Hassan',
      'reg': 'LHR-2026-142',
      'district': 'Lahore',
      'type': 'Parole',
      'risk': 'High',
      'status': 'Overdue',
      'nextAppointment': '25 Jul 2026 (Missed)',
      'startDate': '01 March 2026',
      'expiryDate': '01 March 2027',
      'conditions':
          '• Bi-weekly office reporting\n• Travel restriction within Lahore district\n• Substance misuse counselling',
      'contacts':
          '• 10 July 2026: Telephone Contact\n• 25 June 2026: Workplace Visit',
      'rnaScore': 'High Risk — Score: 68 / 100',
      'rehabPlan':
          'Substance Avoidance Counselling and Family Support Programme',
      'nextAction': 'Issue overdue reporting notice and schedule welfare visit',
    },
    {
      'name': 'Umar Farooq',
      'reg': 'LHR-2026-031',
      'district': 'Lahore',
      'type': 'Probation',
      'risk': 'Medium',
      'status': 'Compliant',
      'nextAppointment': '01 Aug 2026',
      'startDate': '10 February 2026',
      'expiryDate': '10 February 2027',
      'conditions':
          '• Monthly office reporting\n• Enrolment in approved vocational training',
      'contacts':
          '• 18 July 2026: Office Visit\n• 02 June 2026: Residence Visit',
      'rnaScore': 'Medium Risk — Score: 42 / 100',
      'rehabPlan': 'TEVTA Electrical Trade Certification (In Progress)',
      'nextAction': 'Conduct 90-day periodic Risk and Needs Assessment',
    },
    {
      'name': 'Zubair Khan',
      'reg': 'LHR-2026-217',
      'district': 'Lahore',
      'type': 'Probation',
      'risk': 'High',
      'status': 'Violation',
      'nextAppointment': '29 Jul 2026 (Field Visit)',
      'startDate': '20 April 2026',
      'expiryDate': '20 April 2027',
      'conditions':
          '• Weekly office reporting\n• Mandatory residence verification\n• No change of address without approval',
      'contacts':
          '• 12 July 2026: Telephone (Unanswered)\n• 28 June 2026: Office Visit',
      'rnaScore': 'High Risk — Score: 74 / 100',
      'rehabPlan': 'Behavioural Intervention Programme (Referral Pending)',
      'nextAction': 'Execute planned field visit for residence verification',
    },
  ];

  List<Map<String, dynamic>> get _filteredCases {
    return _cases.where((c) {
      final q = _searchQuery.toLowerCase();
      final matchesSearch = (c['name'] as String).toLowerCase().contains(q) ||
          (c['reg'] as String).toLowerCase().contains(q);
      if (_selectedFilter == 'All') return matchesSearch;
      if (_selectedFilter == 'Probation')
        return matchesSearch && c['type'] == 'Probation';
      if (_selectedFilter == 'Parole')
        return matchesSearch && c['type'] == 'Parole';
      return matchesSearch &&
          (c['status'] as String).toLowerCase() ==
              _selectedFilter.toLowerCase();
    }).toList();
  }

  void _openCaseProfile(Map<String, dynamic> c) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CaseProfileScreen(caseData: c)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F0),
      body: Column(
        children: [
          DepartmentalAppBar(screenTitle: 'Case Management — My Caseload'),
          // Search + Filter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search by supervisee name or reference number…',
                    hintStyle: const TextStyle(fontSize: 13),
                    prefixIcon:
                        const Icon(Icons.search, color: kGovGreenMid, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    filled: true,
                    fillColor: kGovWhite,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      'All',
                      'Probation',
                      'Parole',
                      'Compliant',
                      'Overdue',
                      'Violation'
                    ].map((f) {
                      final sel = _selectedFilter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(f,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: sel ? kGovWhite : kTextDark,
                                  fontWeight: FontWeight.w500)),
                          selected: sel,
                          selectedColor: kGovGreenMid,
                          backgroundColor: kGovWhite,
                          onSelected: (_) =>
                              setState(() => _selectedFilter = f),
                          visualDensity: VisualDensity.compact,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // List
          Expanded(
            child: _filteredCases.isEmpty
                ? const Center(
                    child: Text('No cases match the selected filter.',
                        style: TextStyle(color: kTextMuted)))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: _filteredCases.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (ctx, i) {
                      final c = _filteredCases[i];
                      return _CaseCard(
                          caseData: c, onTap: () => _openCaseProfile(c));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Case List Card ──────────────────────────────────────────────────────────
class _CaseCard extends StatelessWidget {
  final Map<String, dynamic> caseData;
  final VoidCallback onTap;
  const _CaseCard({required this.caseData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final sc = statusColor(caseData['status'] as String);
    final rc = riskColor(caseData['risk'] as String);
    return Material(
      color: kGovWhite,
      borderRadius: BorderRadius.circular(10),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Left accent bar
              Container(
                width: 4,
                height: 54,
                decoration: BoxDecoration(
                  color: sc,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          caseData['name'] as String,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: kTextDark),
                        ),
                        _MiniChip(
                            label: caseData['status'] as String, color: sc),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${caseData['reg']}',
                          style: const TextStyle(
                              fontSize: 12,
                              color: kTextMuted,
                              fontWeight: FontWeight.w500),
                        ),
                        const Text(' · ', style: TextStyle(color: kTextMuted)),
                        _MiniChip(
                            label: caseData['type'] as String,
                            color: kGovGreenMid),
                        const SizedBox(width: 4),
                        _MiniChip(
                            label: 'Risk: ${caseData['risk']}', color: rc),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 11, color: kTextMuted),
                        const SizedBox(width: 4),
                        Text(
                          'Next: ${caseData['nextAppointment']}',
                          style:
                              const TextStyle(fontSize: 11, color: kTextMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  final Color color;
  const _MiniChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(22),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

// ─── Case Profile Screen ─────────────────────────────────────────────────────
class CaseProfileScreen extends StatelessWidget {
  final Map<String, dynamic> caseData;
  const CaseProfileScreen({Key? key, required this.caseData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sc = statusColor(caseData['status'] as String);
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F0),
      body: Column(
        children: [
          DepartmentalAppBar(screenTitle: 'Case Profile — ${caseData['reg']}'),
          // Case header band
          Container(
            color: kGovGreen,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: kGovWhite.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: kGovWhite, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(caseData['name'] as String,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: kGovWhite)),
                      const SizedBox(height: 2),
                      Text(
                        '${caseData['reg']} · ${caseData['type']} · ${caseData['district']}',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFFB9F6CA)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: sc.withAlpha(40),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: sc.withAlpha(120)),
                  ),
                  child: Text(caseData['status'] as String,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: sc == kGovGreenMid ? Colors.white : sc)),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _profileSection('Case Information', Icons.badge_outlined, [
                    ['Supervision Start', caseData['startDate'] as String],
                    ['Supervision Expiry', caseData['expiryDate'] as String],
                    ['Next Appointment', caseData['nextAppointment'] as String],
                    ['Risk Level', caseData['risk'] as String],
                  ]),
                  _profileSection(
                      'Supervision Conditions', Icons.gavel_outlined, null,
                      bodyText: caseData['conditions'] as String),
                  _profileSection(
                      'Contact History', Icons.history_outlined, null,
                      bodyText: caseData['contacts'] as String),
                  _profileSection('Risk and Needs Assessment',
                      Icons.analytics_outlined, null,
                      bodyText: caseData['rnaScore'] as String),
                  _profileSection(
                      'Rehabilitation Plan', Icons.school_outlined, null,
                      bodyText: caseData['rehabPlan'] as String),
                  _profileSection('Next Required Action',
                      Icons.pending_actions_outlined, null,
                      bodyText: caseData['nextAction'] as String,
                      accentColor: kGovGreenMid),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileSection(String title, IconData icon, List<List<String>>? rows,
      {String? bodyText, Color? accentColor}) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: kGovGreenMid, size: 18),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: kTextDark)),
              ],
            ),
            const Divider(height: 16),
            if (rows != null)
              ...rows.map((r) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(r[0],
                              style: const TextStyle(
                                  fontSize: 12, color: kTextMuted)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(r[1],
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: kTextDark)),
                        ),
                      ],
                    ),
                  )),
            if (bodyText != null)
              Text(bodyText,
                  style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: accentColor ?? kTextDark,
                      fontWeight: accentColor != null
                          ? FontWeight.w600
                          : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
