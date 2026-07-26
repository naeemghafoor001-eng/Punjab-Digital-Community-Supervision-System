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
      case 'High':
      case 'Overdue':
      case 'Violation':
        return const Color(0xFFC62828);
      case 'Medium':
        return const Color(0xFFE65100);
      default:
        return const Color(0xFF1565C0);
    }
  }

  void _recordAction(String alertId, String actionLabel) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action recorded: "$actionLabel" — Alert $alertId'),
        backgroundColor: kGovGreenMid,
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update alert status.')),
      );
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
      _recordAction(alert['id'] as String, 'Alert set to $status');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update alert status.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final unresolved = _alerts.where((a) => !(a['resolved'] as bool)).length;
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F0),
      body: Column(
        children: [
          DepartmentalAppBar(
            screenTitle: 'Supervision Alerts ($unresolved Active)',
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kGovGreenMid),
                    ),
                  )
                : _errorMessage != null
                    ? Center(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      )
                    : _alerts.isEmpty
                        ? const Center(
                            child: Text(
                              'No active alerts.',
                              style: TextStyle(color: kTextMuted),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: _alerts.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (ctx, i) {
                              final alert = _alerts[i];
                              final resolved = alert['resolved'] as bool;
                              final sColor =
                                  _severityColor(alert['severity'] as String);

                              return AnimatedOpacity(
                                opacity: resolved ? 0.55 : 1.0,
                                duration: const Duration(milliseconds: 300),
                                child: Card(
                                  elevation: resolved ? 0 : 1,
                                  color: resolved
                                      ? Colors.grey.shade100
                                      : kGovWhite,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        color: resolved
                                            ? Colors.grey.shade200
                                            : sColor.withAlpha(60)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Header row
                                        Row(
                                          children: [
                                            Container(
                                              width: 4,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: resolved
                                                    ? Colors.grey.shade400
                                                    : sColor,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          alert['category']
                                                              as String,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: resolved
                                                                ? Colors.grey
                                                                : kTextDark,
                                                            decoration: resolved
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : null,
                                                          ),
                                                        ),
                                                      ),
                                                      _SeverityBadge(
                                                        label: alert['severity']
                                                            as String,
                                                        color: sColor,
                                                        resolved: resolved,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 3),
                                                  Text(
                                                    '${alert['name']}  ·  ${alert['caseRef']}  ·  ${alert['type']}  ·  ${alert['date']}',
                                                    style: const TextStyle(
                                                        fontSize: 11,
                                                        color: kTextMuted,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          alert['detail'] as String,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: kTextDark,
                                              height: 1.4),
                                        ),
                                        const SizedBox(height: 12),
                                        const Divider(height: 1),
                                        const SizedBox(height: 10),
                                        // Action buttons
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 6,
                                          children: [
                                            OutlinedButton.icon(
                                              icon: const Icon(
                                                  Icons.visibility_outlined,
                                                  size: 15),
                                              label: const Text('Review',
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: kGovGreenMid,
                                                side: const BorderSide(
                                                    color: kGovGreenMid),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                minimumSize: Size.zero,
                                              ),
                                              onPressed: () =>
                                                  _updateAlertStatus(
                                                      i, 'In Review'),
                                            ),
                                            OutlinedButton.icon(
                                              icon: const Icon(
                                                  Icons.edit_note_outlined,
                                                  size: 15),
                                              label: const Text('Record Action',
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor:
                                                    const Color(0xFF1565C0),
                                                side: const BorderSide(
                                                    color: Color(0xFF1565C0)),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                minimumSize: Size.zero,
                                              ),
                                              onPressed: () => _recordAction(
                                                  alert['id'] as String,
                                                  'Action Noted'),
                                            ),
                                            ElevatedButton.icon(
                                              icon: Icon(
                                                  resolved
                                                      ? Icons.undo_outlined
                                                      : Icons
                                                          .check_circle_outline,
                                                  size: 15),
                                              label: Text(
                                                  resolved
                                                      ? 'Reopen'
                                                      : 'Mark as Resolved',
                                                  style: const TextStyle(
                                                      fontSize: 12)),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: resolved
                                                    ? Colors.grey
                                                    : kGovGreenMid,
                                                foregroundColor: kGovWhite,
                                                elevation: 0,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                minimumSize: Size.zero,
                                              ),
                                              onPressed: () =>
                                                  _toggleResolve(i),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

class _SeverityBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool resolved;
  const _SeverityBadge(
      {required this.label, required this.color, required this.resolved});

  @override
  Widget build(BuildContext context) {
    final c = resolved ? Colors.grey : color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withAlpha(80)),
      ),
      child: Text(label,
          style:
              TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: c)),
    );
  }
}
