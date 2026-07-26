import 'package:flutter/material.dart';
import 'package:officer_app/core/theme/officer_app_theme.dart';
import 'package:officer_app/core/backend/raahnuma_backend_service.dart';

class CaseloadScreen extends StatefulWidget {
  const CaseloadScreen({Key? key}) : super(key: key);

  @override
  State<CaseloadScreen> createState() => _CaseloadScreenState();
}

class _CaseloadScreenState extends State<CaseloadScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  List<Map<String, dynamic>> _cases = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCases();
  }

  Future<void> _loadCases() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await RaahnumaBackendService.instance.getAssignedCases();
      final mapped = list
          .map((c) => {
                'name': c.fullName,
                'reg': c.caseNumber,
                'district': 'Lahore Central Office',
                'officer': 'Officer Tahir Mahmood',
                'type': c.supervisionCategory.contains('Parole')
                    ? 'Parole'
                    : 'Probation',
                'risk': c.complianceStatus == 'Non-Compliant' ? 'High' : 'Low',
                'status': c.complianceStatus,
                'nextAppointment': c.nextReportingDate,
                'startDate': '15 May 2026',
                'expiryDate': '15 December 2026',
                'conditions':
                    '• Monthly office reporting & digital check-in\n• Retain approved residence & employment\n• 40 hours mandatory community rehabilitation',
                'contacts': '• 22 July 2026: Office Reporting (Completed)',
                'rnaScore': c.complianceStatus == 'Non-Compliant'
                    ? 'High Risk — RNA Score: 68 / 100'
                    : 'Low Risk — RNA Score: 14 / 100',
                'rehabPlan': 'TEVTA Vocational Skills Course (Enrolled)',
                'nextAction': 'Review digital check-in submission',
              })
          .toList();

      setState(() {
        _cases = mapped;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load caseload records.';
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredCases {
    return _cases.where((c) {
      final q = _searchQuery.toLowerCase();
      final matchesSearch = (c['name'] as String).toLowerCase().contains(q) ||
          (c['reg'] as String).toLowerCase().contains(q);
      if (!matchesSearch) return false;

      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Probation') return c['type'] == 'Probation';
      if (_selectedFilter == 'Parole') return c['type'] == 'Parole';
      if (_selectedFilter == 'Low Risk') return c['risk'] == 'Low';
      if (_selectedFilter == 'Medium Risk') return c['risk'] == 'Medium';
      if (_selectedFilter == 'High Risk') return c['risk'] == 'High';
      if (_selectedFilter == 'Overdue') return c['status'] == 'Overdue';
      if (_selectedFilter == 'Pending Review') return c['status'] == 'Pending';

      return (c['status'] as String).toLowerCase() ==
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
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          const DepartmentalAppBar(screenTitle: 'Assigned Caseload Monitoring'),

          // Search & Filter Panel
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search by supervisee name or case reference…',
                    hintStyle: const TextStyle(fontSize: 12.5),
                    prefixIcon:
                        const Icon(Icons.search, color: kGovGreen, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
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
                      'Low Risk',
                      'High Risk',
                      'Compliant',
                      'Overdue',
                    ].map((f) {
                      final sel = _selectedFilter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(f,
                              style: TextStyle(
                                  fontSize: 11.5,
                                  color: sel ? Colors.white : kTextDark,
                                  fontWeight: FontWeight.bold)),
                          selected: sel,
                          selectedColor: kGovGreen,
                          backgroundColor: const Color(0xFFF1F5F9),
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
          const Divider(height: 1),

          // Caseload List View
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kGovGreen),
                    ),
                  )
                : _errorMessage != null
                    ? Center(
                        child: Text(_errorMessage!,
                            style: const TextStyle(color: Colors.red)),
                      )
                    : _filteredCases.isEmpty
                        ? const Center(
                            child: Text(
                              'No matching cases found.',
                              style: TextStyle(color: kTextMuted),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadCases,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _filteredCases.length,
                              itemBuilder: (context, i) {
                                final c = _filteredCases[i];
                                return _buildCaseCard(c);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaseCard(Map<String, dynamic> c) {
    final risk = c['risk'] as String;
    final rColor = riskColor(risk);
    final sColor = statusColor(c['status'] as String);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c['name'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kTextDark,
                        ),
                      ),
                      Text(
                        'Case Ref: ${c['reg']} · Type: ${c['type']}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: kGovGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: rColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: rColor),
                      ),
                      child: Text(
                        '$risk Risk',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: rColor),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: sColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: sColor),
                      ),
                      child: Text(
                        c['status'] as String,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: sColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                const Icon(Icons.business_outlined,
                    size: 15, color: kTextMuted),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Office: ${c['district']} · Officer: ${c['officer']}',
                    style: const TextStyle(fontSize: 11.5, color: kTextMuted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 15, color: kGovGreen),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Next Reporting: ${c['nextAppointment']}',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: kTextDark),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _openCaseProfile(c),
                  icon: const Icon(Icons.folder_open, size: 16),
                  label: const Text('View Full Case Profile',
                      style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    minimumSize: Size.zero,
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

// ─────────────────────────────────────────────────────────────────────────────
// COMPREHENSIVE CASE PROFILE SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class CaseProfileScreen extends StatelessWidget {
  final Map<String, dynamic> caseData;
  const CaseProfileScreen({required this.caseData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: DepartmentalAppBar(
        screenTitle: 'Supervisee Case Profile — ${caseData['reg']}',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Supervisee Header Card
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: kGovGreen, width: 1.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: kGovGreen,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            caseData['name'] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kTextDark,
                            ),
                          ),
                          Text(
                            'Case Ref: ${caseData['reg']} · Type: ${caseData['type']}',
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: kGovGreen,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Status: ${caseData['status']} · Risk: ${caseData['risk']} Risk',
                            style: const TextStyle(
                                fontSize: 11.5, color: kTextMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Section 1: Case Overview
            const SectionHeading(
                title: 'Case Overview & Registration',
                icon: Icons.badge_outlined),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildRow('Masked CNIC', '35201-xxxxxxx-x'),
                    const Divider(),
                    _buildRow(
                        'Supervision Category', caseData['type'] as String),
                    const Divider(),
                    _buildRow('Assigned Probation Officer',
                        caseData['officer'] as String),
                    const Divider(),
                    _buildRow(
                        'District Office', caseData['district'] as String),
                    const Divider(),
                    _buildRow('Supervision Start Date',
                        caseData['startDate'] as String),
                    const Divider(),
                    _buildRow('Supervision Expiry Date',
                        caseData['expiryDate'] as String),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Section 2: Supervision Conditions
            const SectionHeading(
                title: 'Court / Parole Supervision Conditions',
                icon: Icons.gavel_outlined),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  caseData['conditions'] as String,
                  style: const TextStyle(
                      fontSize: 12.5, height: 1.5, color: kTextDark),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Section 3: Risk & Needs Assessment
            const SectionHeading(
                title: 'Risk & Needs Assessment (RNA)',
                icon: Icons.analytics_outlined),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  caseData['rnaScore'] as String,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: kGovGreen),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Section 4: Rehabilitation Plan
            const SectionHeading(
                title: 'Rehabilitation & Reintegration Plan',
                icon: Icons.volunteer_activism_outlined),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  caseData['rehabPlan'] as String,
                  style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: kTextDark),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Section 5: Recent Contact Notes
            const SectionHeading(
                title: 'Officer Contact & Field Visit History',
                icon: Icons.edit_note_outlined),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  caseData['contacts'] as String,
                  style: const TextStyle(
                      fontSize: 12, height: 1.4, color: kTextDark),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Center(
              child: Text(
                'Public prototype using fictional records for review and presentation purposes.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 11.5, color: kTextMuted)),
          Text(value,
              style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: kTextDark)),
        ],
      ),
    );
  }
}
