import 'package:flutter/material.dart';
import 'package:officer_app/core/theme/officer_app_theme.dart';
import 'package:officer_app/core/backend/raahnuma_backend_service.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<Map<String, dynamic>> _alerts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await RaahnumaBackendService.instance.getAlerts();
      final mapped = list
          .map((a) => {
                'id': a.id,
                'category': a.category,
                'caseRef': 'LHR-2026-089',
                'name': a.superviseeName,
                'type': 'Probation',
                'severity': a.severity,
                'date': a.createdAt.split('T')[0],
                'detail': a.description,
                'resolved': a.status == 'Resolved',
                'status': a.status,
              })
          .toList();

      setState(() {
        _alerts = mapped;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load alerts.';
        _isLoading = false;
      });
    }
  }

  Color _severityColor(String severity) {
    switch (severity) {
      case 'Critical':
      case 'High':
      case 'Overdue':
      case 'Violation':
        return const Color(0xFFDC2626);
      case 'Medium':
        return const Color(0xFFD97706);
      default:
        return const Color(0xFF0284C7);
    }
  }

  void _recordAction(String alertId, String actionLabel) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action recorded: "$actionLabel" — Alert $alertId'),
        backgroundColor: kGovGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleResolve(int index) async {
    final alert = _alerts[index];
    final isCurrentlyResolved = alert['resolved'] as bool;
    final newStatus = isCurrentlyResolved ? 'Active' : 'Resolved';

    setState(() {
      _isLoading = true;
    });

    try {
      await RaahnumaBackendService.instance
          .updateAlertStatus(alert['id'] as String, newStatus);
      await _loadAlerts();
      _recordAction(alert['id'] as String,
          newStatus == 'Resolved' ? 'Marked as Resolved' : 'Alert Reopened');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update alert status.')),
        );
      }
    }
  }

  void _updateAlertStatus(int index, String status) async {
    final alert = _alerts[index];
    setState(() {
      _isLoading = true;
    });

    try {
      await RaahnumaBackendService.instance
          .updateAlertStatus(alert['id'] as String, status);
      await _loadAlerts();
      _recordAction(alert['id'] as String, 'Alert status updated to $status');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update alert status.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final unresolved = _alerts.where((a) => !(a['resolved'] as bool)).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          DepartmentalAppBar(
            screenTitle: 'Supervision Alerts & Compliance Triggers',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: unresolved > 0 ? const Color(0xFFDC2626) : kGovGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$unresolved Open Alert${unresolved == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Explicit Legal/Administrative Notice
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFFEF3C7),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: Color(0xFFB45309), size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Alerts support officer review and do not constitute automatic violation findings.',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF92400E),
                    ),
                  ),
                ),
              ],
            ),
          ),

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
                    : _alerts.isEmpty
                        ? const Center(
                            child: Text(
                              'No supervision alerts registered.',
                              style: TextStyle(color: kTextMuted),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadAlerts,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _alerts.length,
                              itemBuilder: (context, i) {
                                final a = _alerts[i];
                                return _buildAlertCard(i, a);
                              },
                            ),
                          ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 4),
            child: Center(
              child: Text(
                'Public prototype using fictional records for review and presentation purposes.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10.5,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(int index, Map<String, dynamic> alert) {
    final isResolved = alert['resolved'] as bool;
    final sev = alert['severity'] as String;
    final sevColor = _severityColor(sev);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isResolved ? Colors.grey.shade300 : sevColor.withAlpha(100),
          width: isResolved ? 1 : 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: sevColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: sevColor),
                      ),
                      child: Text(
                        '$sev Severity',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: sevColor),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      alert['category'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: kTextDark,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isResolved
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    alert['status'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isResolved
                          ? Colors.green.shade800
                          : Colors.amber.shade900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Supervisee: ${alert['name']} (${alert['caseRef']})',
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold, color: kGovGreen),
            ),
            const SizedBox(height: 4),
            Text(
              alert['detail'] as String,
              style:
                  const TextStyle(fontSize: 12, color: kTextDark, height: 1.35),
            ),
            const SizedBox(height: 6),
            Text(
              'Date Triggered: ${alert['date']}',
              style: const TextStyle(fontSize: 10.5, color: kTextMuted),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.visibility_outlined, size: 15),
                  label: const Text('Mark In Review',
                      style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kGovGreen,
                    side: const BorderSide(color: kGovGreen),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    minimumSize: Size.zero,
                  ),
                  onPressed: () => _updateAlertStatus(index, 'In Review'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: Icon(
                    isResolved ? Icons.replay : Icons.check_circle,
                    size: 15,
                    color: Colors.white,
                  ),
                  label: Text(
                    isResolved ? 'Reopen Alert' : 'Resolve Alert',
                    style: const TextStyle(fontSize: 11),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isResolved ? Colors.grey.shade700 : kGovGreen,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    minimumSize: Size.zero,
                  ),
                  onPressed: () => _toggleResolve(index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
