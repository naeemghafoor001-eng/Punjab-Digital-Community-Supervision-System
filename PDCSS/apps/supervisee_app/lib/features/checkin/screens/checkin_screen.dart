import 'package:flutter/material.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({Key? key}) : super(key: key);

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  bool _consentGiven = false;
  bool _submitted = false;
  String _receiptCode = "";

  void _showConsentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.privacy_tip_outlined, color: Color(0xFF0F766E), size: 28),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "رازداری اور قانونی اطلاع\nPrivacy Notice",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: const Text(
            "لوکیشن اور کیمرے کا استعمال صرف اس وقت آپ کی حاضری کی تصدیق کے لیے کیا جا رہا ہے جیسا کہ آپ کے قانونی حکم میں درج ہے۔ آپ کی مستقل لوکیشن ٹریکنگ ہرگز نہیں کی جاتی۔\n\nLocation and camera access are used ONLY at this moment to verify your check-in submission as required by your supervision order. Continuous tracking is NEVER performed.",
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                setState(() {
                  _consentGiven = true;
                });
                Navigator.of(context).pop();
                _executeCheckInSubmission();
              },
              child: const Text("میں سمجھ گیا اور متفق ہوں / I Agree", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _executeCheckInSubmission() {
    // Simulate check-in execution and receipt generation
    setState(() {
      _submitted = true;
      _receiptCode = "REC-PDCSS-20260725-88392";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("پنجاب ڈیجیٹل کمیونٹی سپرویژن / PDCSS"),
        backgroundColor: const Color(0xFF0F766E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              color: Color(0xFFF0FDF4),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.security, color: Color(0xFF0F766E), size: 48),
                    SizedBox(height: 12),
                    Text(
                      "ڈیجیٹل حاضری کا اندراج / Digital Check-In",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "حاضری درج کرنے کے لیے نیچے دیے گئے بٹن پر کلک کریں۔\nTap below to submit your scheduled check-in.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            if (!_submitted) ...[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  minimumSize: const Size(double.infinity, 56), // Large touch target
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
                label: const Text(
                  "حاضری درج کریں / Submit Check-In",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (!_consentGiven) {
                    _showConsentDialog();
                  } else {
                    _executeCheckInSubmission();
                  }
                },
              ),
            ] else ...[
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 64),
                      const SizedBox(height: 16),
                      const Text(
                        "سرکاری حاضری کی رسپٹ\nOfficial Digital Receipt",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("رسپٹ کوڈ / Receipt:", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(_receiptCode, style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("حالت / Status:", style: TextStyle(fontWeight: FontWeight.bold)),
                          Chip(
                            label: Text("تصدیق شدہ / Verified", style: TextStyle(color: Colors.white, fontSize: 12)),
                            backgroundColor: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
