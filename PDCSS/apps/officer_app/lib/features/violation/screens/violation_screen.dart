import 'package:flutter/material.dart';

class ViolationScreen extends StatefulWidget {
  const ViolationScreen({Key? key}) : super(key: key);

  @override
  State<ViolationScreen> createState() => _ViolationScreenState();
}

class _ViolationScreenState extends State<ViolationScreen> {
  final _descController = TextEditingController();
  String _violationType = "UNEXCUSED_MISSED_CHECKIN";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("خلاف ورزی کا اندراج / Violation Incident Report"),
        backgroundColor: const Color(0xFFB91C1C),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              color: Color(0xFFFEF2F2),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Color(0xFFB91C1C), size: 32),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "نوٹ: تمام رپورٹ کردہ خلاف ورزیاں ڈسٹرکٹ سپروائزری افسر کی منظوری کی منتظر رہیں گی۔ خودکار کارروائی پر پابندی ہے۔\nHuman Review Required: All violation reports require District Supervisory approval.",
                        style: TextStyle(fontSize: 13, color: Color(0xFF991B1B)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _violationType,
              decoration: const InputDecoration(
                labelText: "خلاف ورزی کی قسم / Incident Type",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "UNEXCUSED_MISSED_CHECKIN", child: Text("غیر حاضر حاضری / Unexcused Missed Check-In")),
                DropdownMenuItem(value: "TRAVEL_RESTRICTION_BREACH", child: Text("نقل و حرکت کی حد کی خلاف ورزی / Travel Breach")),
                DropdownMenuItem(value: "REHAB_NON_ATTENDANCE", child: Text("اصلاحی پروگرام میں عدم حاضری / Rehab Program Breach")),
              ],
              onChanged: (val) => setState(() => _violationType = val!),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "تفصیل اور ثبوت / Incident Description & Evidence Notes",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB91C1C),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Violation Submitted for Supervisory Review")),
                );
              },
              child: const Text("منظوری کے لیے بھیجیں / Submit for Review", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
