import 'package:flutter/material.dart';
import 'package:web_portal/core/backend/models.dart';
import 'package:web_portal/core/backend/raahnuma_portal_service.dart';

class PRNAMonitoringWidget extends StatefulWidget {
  const PRNAMonitoringWidget({Key? key}) : super(key: key);

  @override
  State<PRNAMonitoringWidget> createState() => _PRNAMonitoringWidgetState();
}

class _PRNAMonitoringWidgetState extends State<PRNAMonitoringWidget> {
  late Future<PortalPRNASummary> _summaryFuture;
  late Future<List<PortalDistrictPRNARow>> _districtFuture;
  late Future<List<PortalOfficerPRNARow>> _officerFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _summaryFuture = RaahnumaPortalService.instance.getPRNASummary();
    _districtFuture = RaahnumaPortalService.instance.getDistrictPRNARows();
    _officerFuture = RaahnumaPortalService.instance.getOfficerPRNARows();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PortalPRNASummary>(
      future: _summaryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F5A47)),
            ),
          );
        }

        final summary = snapshot.data ?? PortalPRNASummary.fallback();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'PRNA & Case Planning Executive Dashboard',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Punjab Risk & Needs Assessment (PRNA) adult offender intake & rehabilitation monitoring',
                        style:
                            TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _loadData()),
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Refresh PRNA Metrics'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Policy Safeguard Notice
              _buildSafeguardNoticeCard(),
              const SizedBox(height: 20),

              // Summary Metrics Grid (6 cards)
              _buildSummaryMetricsGrid(summary),
              const SizedBox(height: 24),

              // Risk Band & Criminogenic Needs Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildRiskBandDistributionCard(summary)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTopNeedsCard(summary)),
                ],
              ),
              const SizedBox(height: 24),

              // District-wise Completion Rate Table
              const Text(
                'District-Wise PRNA Completion Rates (30-Day Limit)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              _buildDistrictTable(),
              const SizedBox(height: 24),

              // Officer-wise Pending Assessments Table
              const Text(
                'Officer Workload & Pending Assessment Monitoring',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              _buildOfficerTable(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSafeguardNoticeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF93C5FD)),
      ),
      child: Row(
        children: const [
          Icon(Icons.shield_outlined, color: Color(0xFF1D4ED8), size: 24),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Institutional Policy Note: PRNA risk scores and provisional risk bands serve strictly for officer supervision intensity allocation and RNR case planning. All risk classifications are provisional, subject to empirical validation, and must NOT create automatic legal consequences or automatic violation findings.',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E40AF),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryMetricsGrid(PortalPRNASummary summary) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = constraints.maxWidth > 900 ? 3 : 2;
        return GridView.count(
          crossAxisCount: count,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 2.4,
          children: [
            _buildMetricCard(
              'Total PRNA Completed',
              summary.totalPrnaCompleted.toString(),
              'Intake Evaluations Done',
              Icons.task_alt,
              const Color(0xFF0F5A47),
            ),
            _buildMetricCard(
              'PRNA Pending Intake',
              summary.prnaPending.toString(),
              'Within 30-Day Window',
              Icons.pending_actions,
              const Color(0xFFD97706),
            ),
            _buildMetricCard(
              'PRNA Overdue (>30 Days)',
              summary.prnaOverdueBeyond30Days.toString(),
              'Requires District Alert',
              Icons.warning_amber,
              const Color(0xFFDC2626),
            ),
            _buildMetricCard(
              'Reassessments Due',
              summary.reassessmentsDue.toString(),
              '90-Day / 6-Month Cycle',
              Icons.sync_problem,
              const Color(0xFF7C3AED),
            ),
            _buildMetricCard(
              'Case Plans Active',
              summary.casePlansCompleted.toString(),
              'RNR Plans Executing',
              Icons.stars,
              const Color(0xFF0284C7),
            ),
            _buildMetricCard(
              'Plans Pending Review',
              summary.casePlansPendingReview.toString(),
              'Awaiting Supervisor',
              Icons.rule,
              const Color(0xFFB45309),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard(
      String title, String value, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withAlpha(25),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskBandDistributionCard(PortalPRNASummary summary) {
    final dist = summary.riskBandDistribution;
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Provisional Risk Band Distribution',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Provisional classifications subject to Punjab validation',
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            _buildRiskBandProgress('Low Risk (Score <= 16)', dist['Low'] ?? 815,
                2400, const Color(0xFF0F5A47)),
            _buildRiskBandProgress('Moderate Risk (Score 17 - 26)',
                dist['Moderate'] ?? 1140, 2400, Colors.amber.shade900),
            _buildRiskBandProgress('High Risk (Score 27 - 34)',
                dist['High'] ?? 350, 2400, Colors.orange.shade900),
            _buildRiskBandProgress('Very High Risk (Score >= 35)',
                dist['Very High'] ?? 107, 2400, Colors.red.shade900),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskBandProgress(
      String label, int count, int total, Color color) {
    final pct = count / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
              Text('$count (${(pct * 100).toStringAsFixed(1)}%)',
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: pct,
            backgroundColor: color.withAlpha(25),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildTopNeedsCard(PortalPRNASummary summary) {
    final needs = summary.topCriminogenicNeeds;
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Criminogenic Needs Frequency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Dynamic needs targets identified across active case plans',
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            ...needs.entries.map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 8, color: Color(0xFF0F5A47)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(e.key,
                            style: const TextStyle(fontSize: 12.5))),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F7F4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${e.value} cases',
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F5A47)),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDistrictTable() {
    return FutureBuilder<List<PortalDistrictPRNARow>>(
      future: _districtFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final rows = snapshot.data ?? [];
        return Card(
          elevation: 1.5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F5F9)),
              columns: const [
                DataColumn(
                    label: Text('District',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Total Supervisees',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('PRNA Completed',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Pending Intake',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Overdue (>30 Days)',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Completion Rate',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: rows.map((r) {
                return DataRow(cells: [
                  DataCell(Text(r.district,
                      style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(r.totalSupervisees.toString())),
                  DataCell(Text(r.prnaCompleted.toString(),
                      style: const TextStyle(
                          color: Color(0xFF0F5A47),
                          fontWeight: FontWeight.bold))),
                  DataCell(Text(r.prnaPending.toString())),
                  DataCell(Text(r.prnaOverdue.toString(),
                      style: TextStyle(
                          color: r.prnaOverdue > 5
                              ? Colors.red.shade800
                              : Colors.black))),
                  DataCell(Chip(
                    label: Text(
                        '${r.completionRatePercent.toStringAsFixed(1)}%',
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                    backgroundColor: const Color(0xFFF0F7F4),
                    visualDensity: VisualDensity.compact,
                  )),
                ]);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOfficerTable() {
    return FutureBuilder<List<PortalOfficerPRNARow>>(
      future: _officerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final rows = snapshot.data ?? [];
        return Card(
          elevation: 1.5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F5F9)),
              columns: const [
                DataColumn(
                    label: Text('Probation Officer',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('District',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Assigned Cases',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('PRNA Completed',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Pending Assessments',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Overdue (>30 Days)',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: rows.map((r) {
                return DataRow(cells: [
                  DataCell(Text(r.officerName,
                      style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(r.district)),
                  DataCell(Text(r.assignedCases.toString())),
                  DataCell(Text(r.prnaCompleted.toString(),
                      style: const TextStyle(
                          color: Color(0xFF0F5A47),
                          fontWeight: FontWeight.bold))),
                  DataCell(Text(r.pendingAssessments.toString())),
                  DataCell(Text(r.overdue30Days.toString(),
                      style: TextStyle(
                          color: r.overdue30Days > 0
                              ? Colors.red.shade800
                              : Colors.black))),
                ]);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
