import 'package:flutter/material.dart';
import 'package:officer_app/core/theme/officer_app_theme.dart';

class FieldVisitPlannerScreen extends StatefulWidget {
  const FieldVisitPlannerScreen({Key? key}) : super(key: key);

  @override
  State<FieldVisitPlannerScreen> createState() =>
      _FieldVisitPlannerScreenState();
}

class _FieldVisitPlannerScreenState extends State<FieldVisitPlannerScreen> {
  final List<Map<String, String>> _visits = [
    {
      'caseRef': 'LHR-2026-217',
      'name': 'Zubair Khan',
      'area': 'Gulberg III, Lahore',
      'purpose': 'Residence & Employment Verification',
      'time': '29 July 2026, 11:30 AM',
      'safety': 'Standard daytime visit. Accompanied by paired officer.',
      'outcome': 'Pending Visit Completion',
    },
    {
      'caseRef': 'LHR-2026-142',
      'name': 'Ahmed Hassan',
      'area': 'Model Town, Lahore',
      'purpose': 'Parole Compliance & Family Interview',
      'time': '30 July 2026, 02:00 PM',
      'safety': 'Prior phone confirmation required. No security alerts.',
      'outcome': 'Pending Visit Completion',
    },
    {
      'caseRef': 'LHR-2026-089',
      'name': 'Tariq Mehmood',
      'area': 'Johar Town, Lahore',
      'purpose': 'Routine Home Visit & Supervision Review',
      'time': '02 August 2026, 10:00 AM',
      'safety': 'Standard daytime protocol.',
      'outcome': 'Scheduled',
    },
  ];

  void _showAddVisitModal() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Schedule new field visit action triggered.'),
        backgroundColor: kGovGreenMid,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F0),
      body: Column(
        children: [
          DepartmentalAppBar(
            screenTitle: 'Field Visit Planner',
            trailing: IconButton(
              icon: const Icon(Icons.add_circle_outline,
                  color: kGovWhite, size: 24),
              onPressed: _showAddVisitModal,
              tooltip: 'Schedule Field Visit',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _visits.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == _visits.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Center(
                      child: Text(
                        'Sample interface with fictional records for review and presentation purposes.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  );
                }

                final visit = _visits[index];
                final isPending = visit['outcome']!.contains('Pending');

                return Card(
                  elevation: 1,
                  color: kGovWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${visit['name']} (${visit['caseRef']})',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: kGovGreen),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isPending
                                    ? const Color(0xFFE65100).withAlpha(20)
                                    : kGovGreenMid.withAlpha(20),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isPending
                                      ? const Color(0xFFE65100).withAlpha(80)
                                      : kGovGreenMid.withAlpha(80),
                                ),
                              ),
                              child: Text(
                                visit['outcome']!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isPending
                                      ? const Color(0xFFE65100)
                                      : kGovGreenMid,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        _buildVisitRow(
                            Icons.location_on_outlined, 'Area', visit['area']!),
                        _buildVisitRow(Icons.assignment_outlined, 'Purpose',
                            visit['purpose']!),
                        _buildVisitRow(
                            Icons.access_time, 'Planned Time', visit['time']!),
                        _buildVisitRow(Icons.shield_outlined, 'Safety Note',
                            visit['safety']!),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              icon:
                                  const Icon(Icons.note_add_outlined, size: 16),
                              label: const Text('Record Outcome',
                                  style: TextStyle(fontSize: 12)),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: kGovGreenMid,
                                side: const BorderSide(color: kGovGreenMid),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Visit outcome recorded for ${visit['caseRef']}'),
                                    backgroundColor: kGovGreenMid,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildVisitRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: kTextMuted),
          const SizedBox(width: 8),
          Text('$label: ',
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: kTextMuted)),
          Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: kTextDark))),
        ],
      ),
    );
  }
}
