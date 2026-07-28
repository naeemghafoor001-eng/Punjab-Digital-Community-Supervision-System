import 'package:flutter/material.dart';
import 'package:officer_app/core/backend/prna_models.dart';
import 'package:officer_app/core/backend/raahnuma_backend_service.dart';
import 'package:officer_app/core/theme/officer_app_theme.dart';
import 'package:officer_app/features/prna/screens/prna_stepper_wizard_screen.dart';

class PRNADashboardScreen extends StatefulWidget {
  const PRNADashboardScreen({Key? key}) : super(key: key);

  @override
  State<PRNADashboardScreen> createState() => _PRNADashboardScreenState();
}

class _PRNADashboardScreenState extends State<PRNADashboardScreen> {
  List<PRNAAssessmentModel> _assessments = [];
  bool _isLoading = true;
  String _filterStatus = 'All';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final list = await RaahnumaBackendService.instance.getPRNAAssessments();
    setState(() {
      _assessments = list;
      _isLoading = false;
    });
  }

  void _openWizard([PRNAAssessmentModel? existing]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PRNAStepperWizardScreen(existingAssessment: existing),
      ),
    );
    if (result == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    int newCount = _assessments.where((a) => a.status == 'Draft').length;
    int draftCount = newCount;
    int completedCount = _assessments
        .where((a) => a.status == 'Approved' || a.status == 'Completed')
        .length;
    int dueWithin30Count =
        _assessments.where((a) => a.status != 'Approved').length;
    int overdueCount =
        _assessments.where((a) => a.status == 'Returned for Correction').length;
    int reassessmentDueCount =
        _assessments.where((a) => a.status == 'Reassessment Due').length;
    int casePlansPendingCount = _assessments
        .where((a) => a.status == 'Supervisor Review Pending')
        .length;

    final filtered = _filterStatus == 'All'
        ? _assessments
        : _assessments.where((a) => a.status == _filterStatus).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          const DepartmentalAppBar(
              screenTitle: 'Risk & Needs Assessment (PRNA)'),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // New Assessment Action Card
                    _buildNewAssessmentHeaderCard(),
                    const SizedBox(height: 16),

                    // 7 Dashboard Metrics Cards Grid
                    _buildMetricsGrid(
                      newCount: newCount,
                      draftCount: draftCount,
                      completedCount: completedCount,
                      dueWithin30Count: dueWithin30Count,
                      overdueCount: overdueCount,
                      reassessmentDueCount: reassessmentDueCount,
                      casePlansPendingCount: casePlansPendingCount,
                    ),
                    const SizedBox(height: 20),

                    // Filter chips
                    Row(
                      children: [
                        const Text(
                          'Filter Status: ',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: kTextDark),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildFilterChip('All'),
                                _buildFilterChip('Approved'),
                                _buildFilterChip('Draft'),
                                _buildFilterChip('Supervisor Review Pending'),
                                _buildFilterChip('Reassessment Due'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Assessment List
                    if (_isLoading)
                      const Center(
                          child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(kGovGreen)),
                      ))
                    else if (filtered.isEmpty)
                      const Center(
                          child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text(
                            'No PRNA assessments match selected filter.',
                            style: TextStyle(color: kTextMuted)),
                      ))
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return _buildAssessmentCard(filtered[index]);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewAssessmentHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kGovGreen,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Conduct New PRNA Assessment',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  'Complete 9-Step Assessment & RNR Case Plan within 30 days of placement.',
                  style: TextStyle(fontSize: 11.5, color: Colors.white70),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: kGovGold,
              foregroundColor: kGovGreenDark,
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Start Wizard',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () => _openWizard(),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid({
    required int newCount,
    required int draftCount,
    required int completedCount,
    required int dueWithin30Count,
    required int overdueCount,
    required int reassessmentDueCount,
    required int casePlansPendingCount,
  }) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.4,
      children: [
        _buildMetricTile('New Assessments', newCount.toString(),
            Icons.assignment_late, kGovGreen),
        _buildMetricTile('Draft Assessments', draftCount.toString(),
            Icons.edit_note, Colors.orange.shade800),
        _buildMetricTile(
            'Completed', completedCount.toString(), Icons.task_alt, kGovGreen),
        _buildMetricTile('Due in 30 Days', dueWithin30Count.toString(),
            Icons.timer, Colors.blue.shade800),
        _buildMetricTile('PRNA Overdue', overdueCount.toString(),
            Icons.warning_amber, Colors.red.shade800),
        _buildMetricTile('Reassessment Due', reassessmentDueCount.toString(),
            Icons.sync_problem, Colors.purple.shade800),
        _buildMetricTile('Case Plans Pending', casePlansPendingCount.toString(),
            Icons.rule, Colors.amber.shade900),
      ],
    );
  }

  Widget _buildMetricTile(
      String label, String count, IconData icon, Color color) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: color.withAlpha(25),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(count,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color)),
                  Text(label,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: kTextDark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _filterStatus == label;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        selected: isSelected,
        label: Text(label, style: const TextStyle(fontSize: 11)),
        selectedColor: kGovGreenSurface,
        checkmarkColor: kGovGreen,
        onSelected: (val) {
          setState(() {
            _filterStatus = label;
          });
        },
      ),
    );
  }

  Widget _buildAssessmentCard(PRNAAssessmentModel record) {
    final bandColor = _getBandColor(record.riskBand);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
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
                      Text(record.superviseeName,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: kTextDark)),
                      Text(
                          'Case: ${record.caseNumber} | Type: ${record.assessmentType}',
                          style:
                              const TextStyle(fontSize: 11, color: kTextMuted)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: bandColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: bandColor),
                  ),
                  child: Text(
                    '${record.riskBand} (${record.totalScore} pts)',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: bandColor),
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Status: ${record.status}',
                    style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: kTextDark)),
                Text('Due: ${record.dueDate}',
                    style: const TextStyle(fontSize: 11, color: kTextMuted)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Supervision Level: ${record.supervisionIntensity}',
              style: const TextStyle(
                  fontSize: 11.5,
                  color: kGovGreen,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.edit, size: 14),
                  label: const Text('Edit Assessment / Case Plan',
                      style: TextStyle(fontSize: 11)),
                  onPressed: () => _openWizard(record),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getBandColor(String band) {
    switch (band) {
      case 'Low':
        return kGovGreen;
      case 'Moderate':
        return Colors.amber.shade900;
      case 'High':
        return Colors.orange.shade900;
      case 'Very High':
        return Colors.red.shade900;
      default:
        return kTextMuted;
    }
  }
}
