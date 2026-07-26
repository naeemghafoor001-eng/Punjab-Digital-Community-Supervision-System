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
      'caseRef': 'LHR-2026-089',
      'name': 'Tariq Mehmood',
      'type': 'Home Field Visit',
      'area': 'Johar Town, Sector F, Lahore',
      'purpose': 'Residence & Employment Verification',
      'time': '29 July 2026 at 11:30 AM',
      'safety': 'Standard daytime protocol. Co-officer assigned.',
      'outcome': 'Scheduled',
    },
    {
      'caseRef': 'LHR-2026-042',
      'name': 'Muhammad Usama',
      'type': 'Employer Contact',
      'area': 'Gulberg Industrial Area, Lahore',
      'purpose': 'Vocational Skills & Employment Check',
      'time': '30 July 2026 at 02:00 PM',
      'safety': 'Prior phone confirmation required.',
      'outcome': 'Confirmed',
    },
    {
      'caseRef': 'LHR-2026-118',
      'name': 'Ali Raza',
      'type': 'Office Contact Visit',
      'area': 'Lahore Central Office, Home Dept',
      'purpose': 'Monthly Supervision Reporting & Rehab Follow-up',
      'time': '02 August 2026 at 10:00 AM',
      'safety': 'Standard office reporting protocol.',
      'outcome': 'Scheduled',
    },
  ];

  void _showRecordContactModal() {
    final nameController =
        TextEditingController(text: 'Tariq Mehmood (LHR-2026-089)');
    final locationController =
        TextEditingController(text: 'Johar Town, Sector F, Lahore');
    final notesController = TextEditingController(
        text:
            'Supervisee present at residence. Verified employment status with employer.');
    String contactType = 'Home Field Visit';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.edit_note, color: kGovGreen),
              SizedBox(width: 8),
              Text('Record Field Visit / Contact',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Contact / Visit Type',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: contactType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  items: [
                    'Home Field Visit',
                    'Office Contact Visit',
                    'Telephone Contact',
                    'Employer Verification',
                  ]
                      .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t, style: const TextStyle(fontSize: 12))))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) contactType = val;
                  },
                ),
                const SizedBox(height: 12),
                const Text('Supervisee / Case Ref',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Location / District Address',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Officer Visit Notes & Outcome',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kGovGreen),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _visits.insert(0, {
                    'caseRef': 'LHR-2026-089',
                    'name': nameController.text.split(' ')[0],
                    'type': contactType,
                    'area': locationController.text,
                    'purpose': notesController.text,
                    'time': 'Today at ${TimeOfDay.now().format(context)}',
                    'safety': 'Standard protocol.',
                    'outcome': 'Completed & Recorded',
                  });
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Field visit/contact record saved successfully.'),
                    backgroundColor: kGovGreen,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Save Record',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          DepartmentalAppBar(
            screenTitle: 'Field Visit & Contact Planner',
            trailing: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: kGovGreen,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                minimumSize: Size.zero,
              ),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Record Visit',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              onPressed: _showRecordContactModal,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _visits.length + 1,
              itemBuilder: (context, index) {
                if (index == _visits.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
                  );
                }

                final visit = _visits[index];
                final isCompleted = visit['outcome']!.contains('Completed');

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: isCompleted
                          ? Colors.green.shade300
                          : Colors.grey.shade200,
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
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: kGovGreen.withAlpha(20),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.directions_walk,
                                      color: kGovGreen, size: 18),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  visit['type']!,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: kGovGreen,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? const Color(0xFFDCFCE7)
                                    : const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color:
                                      isCompleted ? Colors.green : Colors.blue,
                                ),
                              ),
                              child: Text(
                                visit['outcome']!,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isCompleted
                                      ? Colors.green.shade800
                                      : Colors.blue.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Text(
                          'Supervisee: ${visit['name']} (${visit['caseRef']})',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: kTextDark),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 14, color: kTextMuted),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                visit['area']!,
                                style: const TextStyle(
                                    fontSize: 11.5, color: kTextMuted),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.schedule,
                                size: 14, color: kTextMuted),
                            const SizedBox(width: 4),
                            Text(
                              visit['time']!,
                              style: const TextStyle(
                                  fontSize: 11.5,
                                  color: kTextDark,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Purpose & Notes: ${visit['purpose']}',
                          style: const TextStyle(
                              fontSize: 11.5, color: kTextDark, height: 1.3),
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
}
