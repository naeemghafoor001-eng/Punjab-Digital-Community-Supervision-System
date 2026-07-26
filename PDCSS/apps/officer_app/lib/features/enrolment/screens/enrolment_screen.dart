import 'package:flutter/material.dart';

class OfficerEnrolmentScreen extends StatefulWidget {
  const OfficerEnrolmentScreen({Key? key}) : super(key: key);

  @override
  State<OfficerEnrolmentScreen> createState() => _OfficerEnrolmentScreenState();
}

class _OfficerEnrolmentScreenState extends State<OfficerEnrolmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _cnicController = TextEditingController();
  String _supervisionType = "PROBATION";
  String _deviceMode = "SMARTPHONE_REGISTERED";
  bool _photoCaptured = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("افسر انرولمنٹ پینل / Supervisee Registration"),
        backgroundColor: const Color(0xFF0D9488),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "نئے پروبیشنر / پیرولی کا اندراج\nNew Supervisee Enrolment Dossier",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cnicController,
                decoration: const InputDecoration(
                  labelText: "شناختی کارڈ نمبر / CNIC Number",
                  hintText: "35202-1234567-1",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return "CNIC is required";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "مکمل نام / Full Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fatherNameController,
                decoration: const InputDecoration(
                  labelText: "ولدیت / Father's Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people_outline),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _supervisionType,
                decoration: const InputDecoration(
                  labelText: "نگہداشت کی قسم / Supervision Category",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                      value: "PROBATION",
                      child: Text("پروبیشن / Probation (Court Order)")),
                  DropdownMenuItem(
                      value: "PAROLE",
                      child: Text("پیرول / Parole (Executive Release)")),
                ],
                onChanged: (val) => setState(() => _supervisionType = val!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _deviceMode,
                decoration: const InputDecoration(
                  labelText: "ڈیوائس کا طریقہ کار / Device Pairing Mode",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "SMARTPHONE_REGISTERED",
                    child: Text("رجسٹرڈ اسمارٹ فون / Supervisee Smartphone"),
                  ),
                  DropdownMenuItem(
                    value: "OFFICER_ASSISTED",
                    child:
                        Text("افسر معاونت کیوسک / Officer-Assisted Fallback"),
                  ),
                ],
                onChanged: (val) => setState(() => _deviceMode = val!),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: Icon(
                  _photoCaptured ? Icons.check_circle : Icons.camera_alt,
                  color: _photoCaptured ? Colors.green : Colors.teal,
                ),
                label: Text(_photoCaptured
                    ? "بنیادی تصویر محفوظ کر لی گئی / Base Photo Captured"
                    : "بنیادی تصویر لیں / Capture Base Photo"),
                onPressed: () {
                  setState(() {
                    _photoCaptured = true;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Supervisee Enroled Successfully!")),
                    );
                  }
                },
                child: const Text("اندراج مکمل کریں / Register Supervisee",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
