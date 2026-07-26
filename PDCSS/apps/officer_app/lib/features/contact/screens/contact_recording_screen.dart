import 'package:flutter/material.dart';

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
            'Demonstration Contact Record Saved: $_selectedContactType for $_selectedCase',
          ),
          backgroundColor: const Color(0xFF0D9488),
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
      appBar: AppBar(
        title: const Text('Contact Recording',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D9488),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notice banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFF59E0B)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF92400E)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Demonstration Form: Records are stored temporarily in UI state only.',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF92400E),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text('Select Supervisee Case',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCase,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: Color(0xFF0D9488)),
                ),
                items: _cases
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCase = val!),
              ),
              const SizedBox(height: 16),

              const Text('Contact Type',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedContactType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.connect_without_contact,
                      color: Color(0xFF0D9488)),
                ),
                items: _contactTypes
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedContactType = val!),
              ),
              const SizedBox(height: 16),

              const Text('Officer Observations & Notes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText:
                      'Enter supervision contact notes, progress, and observations...',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter contact notes before saving.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Follow-up Action Required'),
                subtitle: const Text(
                    'Check if a scheduled follow-up or supervisor review is needed'),
                value: _followUpRequired,
                activeColor: const Color(0xFF0D9488),
                onChanged: (val) =>
                    setState(() => _followUpRequired = val ?? false),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text('Save Record (Demo)',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  onPressed: _saveRecord,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
