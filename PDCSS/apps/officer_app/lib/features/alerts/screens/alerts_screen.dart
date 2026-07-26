import 'package:flutter/material.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final List<Map<String, dynamic>> _alerts = [
    {
      'id': 'ALT-101',
      'category': 'Missed Appointment',
      'caseRef': 'LHR-2026-142',
      'name': 'Ahmed Hassan',
      'type': 'Parole',
      'severity': 'High',
      'date': '25 July 2026',
      'detail':
          'Supervisee missed scheduled office reporting appointment at 10:00 AM.',
      'resolved': false,
    },
    {
      'id': 'ALT-102',
      'category': 'Overdue Risk Assessment',
      'caseRef': 'LHR-2026-031',
      'name': 'Umar Farooq',
      'type': 'Probation',
      'severity': 'Medium',
      'date': '24 July 2026',
      'detail':
          '90-day periodic Risk and Needs Assessment (RNA) review is overdue.',
      'resolved': false,
    },
    {
      'id': 'ALT-103',
      'category': 'Address Verification Pending',
      'caseRef': 'LHR-2026-217',
      'name': 'Zubair Khan',
      'type': 'Probation',
      'severity': 'Medium',
      'date': '23 July 2026',
      'detail':
          'Residential change reported; workplace and home verification visit pending.',
      'resolved': false,
    },
    {
      'id': 'ALT-104',
      'category': 'Supervision Order Nearing Expiry',
      'caseRef': 'LHR-2026-089',
      'name': 'Tariq Mehmood',
      'type': 'Probation',
      'severity': 'Low',
      'date': '22 July 2026',
      'detail':
          'Supervision order period expires in 30 days. Final evaluation report required.',
      'resolved': false,
    },
    {
      'id': 'ALT-105',
      'category': 'Repeated Missed Digital Reporting',
      'caseRef': 'LHR-2026-305',
      'name': 'Usman Ghani',
      'type': 'Parole',
      'severity': 'High',
      'date': '21 July 2026',
      'detail':
          'Two consecutive scheduled check-ins missed without prior notification.',
      'resolved': false,
    },
  ];

  void _showAlertAction(String alertId, String actionName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Demo Action Executed: "$actionName" for Alert $alertId'),
        backgroundColor: const Color(0xFF0D9488),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleResolve(int index) {
    setState(() {
      _alerts[index]['resolved'] = !(_alerts[index]['resolved'] as bool);
    });
    _showAlertAction(_alerts[index]['id'] as String,
        _alerts[index]['resolved'] ? 'Marked as Resolved' : 'Reopened');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervision Alerts',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D9488),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _alerts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final alert = _alerts[index];
          final isResolved = alert['resolved'] as bool;

          Color badgeColor;
          switch (alert['severity']) {
            case 'High':
              badgeColor = Colors.red;
              break;
            case 'Medium':
              badgeColor = Colors.orange;
              break;
            default:
              badgeColor = Colors.blue;
          }

          return Card(
            elevation: isResolved ? 1 : 3,
            color: isResolved ? Colors.grey.shade100 : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          alert['category'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isResolved
                                ? Colors.grey
                                : const Color(0xFF0D9488),
                            decoration:
                                isResolved ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: badgeColor.withAlpha(38),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          alert['severity'],
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: badgeColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${alert['name']} (${alert['caseRef']}) · ${alert['type']} · ${alert['date']}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    alert['detail'],
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const Divider(height: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.remove_red_eye, size: 16),
                        label: const Text('Review',
                            style: TextStyle(fontSize: 12)),
                        onPressed: () => _showAlertAction(
                            alert['id'], 'Review Alert Details'),
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.edit_note, size: 16),
                        label: const Text('Record Action',
                            style: TextStyle(fontSize: 12)),
                        onPressed: () => _showAlertAction(
                            alert['id'], 'Record Officer Action'),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isResolved
                              ? Colors.grey
                              : const Color(0xFF0D9488),
                          foregroundColor: Colors.white,
                        ),
                        icon: Icon(
                            isResolved
                                ? Icons.undo
                                : Icons.check_circle_outline,
                            size: 16),
                        label: Text(isResolved ? 'Reopen' : 'Mark as Resolved',
                            style: const TextStyle(fontSize: 12)),
                        onPressed: () => _toggleResolve(index),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
