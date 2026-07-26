import 'package:flutter/material.dart';
import 'package:officer_app/core/theme/officer_app_theme.dart';

class ContactRecordingScreen extends StatefulWidget {
  const ContactRecordingScreen({Key? key}) : super(key: key);

  @override
  State<ContactRecordingScreen> createState() => _ContactRecordingScreenState();
}

class _ContactRecordingScreenState extends State<ContactRecordingScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCase = 'LHR-2026-089 - Tariq Mehmood';
  String _selectedContactType = 'Office Visit';
  final _notesController = TextEditingController();
  bool _followUpRequired = false;

  final List<String> _cases = [
    'LHR-2026-089 - Tariq Mehmood',
    'LHR-2026-142 - Ahmed Hassan',
    'LHR-2026-031 - Umar Farooq',
    'LHR-2026-217 - Zubair Khan',
  ];

  final List<String> _contactTypes = [
    'Office Visit',
    'Telephone Contact',
    'Home Visit',
    'Workplace Visit',
    'Digital Check-In Review',
    'Family Contact',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _saveRecord() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Contact Record Saved: $_selectedContactType for $_selectedCase',
          ),
          backgroundColor: kGovGreenMid,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _notesController.clear();
      setState(() => _followUpRequired = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F0),
      body: Column(
        children: [
          const DepartmentalAppBar(screenTitle: 'Record Supervision Contact'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
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
                            const Text('Supervisee Case',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: kTextDark)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedCase,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                prefixIcon: const Icon(Icons.person_outline,
                                    color: kGovGreenMid, size: 20),
                              ),
                              items: _cases
                                  .map((c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c,
                                          style:
                                              const TextStyle(fontSize: 13))))
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedCase = val!),
                            ),
                            const SizedBox(height: 18),
                            const Text('Contact Type',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: kTextDark)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedContactType,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                prefixIcon: const Icon(
                                    Icons.connect_without_contact,
                                    color: kGovGreenMid,
                                    size: 20),
                              ),
                              items: _contactTypes
                                  .map((t) => DropdownMenuItem(
                                      value: t,
                                      child: Text(t,
                                          style:
                                              const TextStyle(fontSize: 13))))
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedContactType = val!),
                            ),
                            const SizedBox(height: 18),
                            const Text('Officer Observations & Notes',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: kTextDark)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _notesController,
                              maxLines: 5,
                              style: const TextStyle(fontSize: 13),
                              decoration: InputDecoration(
                                hintText:
                                    'Enter supervision contact notes, behavioral observations, and compliance details...',
                                hintStyle: const TextStyle(
                                    fontSize: 13, color: kTextMuted),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter contact notes before saving.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            Theme(
                              data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: kGovGreenMid),
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Follow-up Action Required',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: kTextDark)),
                                subtitle: const Text(
                                    'Flag this case for scheduled follow-up or supervisor review',
                                    style: TextStyle(
                                        fontSize: 11, color: kTextMuted)),
                                value: _followUpRequired,
                                activeColor: kGovGreenMid,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                onChanged: (val) => setState(
                                    () => _followUpRequired = val ?? false),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kGovGreen,
                                  foregroundColor: kGovWhite,
                                  elevation: 0,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                icon: const Icon(Icons.save_outlined, size: 18),
                                label: const Text('Save Contact Record',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700)),
                                onPressed: _saveRecord,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Sample interface with fictional records for review and presentation purposes.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                            fontStyle: FontStyle.italic),
                      ),
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
}
