import 'package:flutter/material.dart';

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
        content: Text('Demonstration Mode: Add Field Visit action triggered.'),
        backgroundColor: Color(0xFF0D9488),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Visit Planner',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D9488),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _showAddVisitModal,
            tooltip: 'Add Field Visit',
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _visits.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final visit = _visits[index];

          return Card(
            elevation: 2,
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
                      Text(
                        '${visit['name']} (${visit['caseRef']})',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF0D9488)),
                      ),
                      Chip(
                        label: Text(visit['outcome']!,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white)),
                        backgroundColor: const Color(0xFF0D9488),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  _buildVisitRow(
                      Icons.location_on_outlined, 'Area', visit['area']!),
                  _buildVisitRow(
                      Icons.assignment_outlined, 'Purpose', visit['purpose']!),
                  _buildVisitRow(
                      Icons.access_time, 'Planned Time', visit['time']!),
                  _buildVisitRow(
                      Icons.shield_outlined, 'Safety Note', visit['safety']!),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.note_add_outlined, size: 16),
                        label: const Text('Record Outcome (Demo)',
                            style: TextStyle(fontSize: 12)),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Demo outcome recorded for ${visit['caseRef']}'),
                              backgroundColor: const Color(0xFF0D9488),
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
    );
  }

  Widget _buildVisitRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Text('$label: ',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
