import 'package:flutter/material.dart';

class RNAScreen extends StatefulWidget {
  const RNAScreen({Key? key}) : super(key: key);

  @override
  State<RNAScreen> createState() => _RNAScreenState();
}

class _RNAScreenState extends State<RNAScreen> {
  double _score = 35;
  String _riskCategory = "MEDIUM";

  void _updateCategory(double val) {
    setState(() {
      _score = val;
      if (_score < 30) {
        _riskCategory = "LOW";
      } else if (_score < 70) {
        _riskCategory = "MEDIUM";
      } else {
        _riskCategory = "HIGH";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("رسک اور ضروریات کی تشخیص / RNA Assessment"),
        backgroundColor: const Color(0xFF0D9488),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "رسک اسکور اور درجہ بندی\nRisk & Needs Score Assessment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("تشخیص کا کل اسکور / Score: ${_score.round()}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Slider(
                      value: _score,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      activeColor: _riskCategory == "HIGH"
                          ? Colors.red
                          : (_riskCategory == "MEDIUM"
                              ? Colors.orange
                              : Colors.green),
                      onChanged: _updateCategory,
                    ),
                    Chip(
                      label: Text("درجہ بندی: $_riskCategory RISK",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      backgroundColor: _riskCategory == "HIGH"
                          ? Colors.red
                          : (_riskCategory == "MEDIUM"
                              ? Colors.orange
                              : Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "اصلاحی سفارشات / Rehabilitation Recommendations",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("RNA Assessment Recorded")),
                );
              },
              child: const Text("تشخیص محفوظ کریں / Save Assessment",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
