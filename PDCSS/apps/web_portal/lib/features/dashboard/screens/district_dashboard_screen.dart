import 'package:flutter/material.dart';

class DistrictDashboardScreen extends StatelessWidget {
  const DistrictDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ڈسٹرکٹ ڈیش بورڈ / District Supervision Dashboard - Lahore"),
        backgroundColor: const Color(0xFF0F766E),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {},
            tooltip: "Language Toggle / زبان تبدیلی",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "پنجاب پروبیشن اینڈ پیرول سروس - ڈسٹرکٹ لاہور summary",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Summary Metrics Cards Grid
            Row(
              children: [
                _buildMetricCard("کل زیرِ نگہداشت کیسز\nTotal Supervisees", "3,140", Colors.teal, Icons.people),
                const SizedBox(width: 16),
                _buildMetricCard("آج کی حاضری کی شرح\nCheck-In Rate", "94.2%", Colors.green, Icons.check_circle_outline),
                const SizedBox(width: 16),
                _buildMetricCard("زیرِ التواء خلاف ورزیاں\nPending Violations", "8", Colors.red, Icons.warning_amber),
                const SizedBox(width: 16),
                _buildMetricCard("متحرک افسران\nActive Officers", "42", Colors.blue, Icons.badge),
              ],
            ),
            const SizedBox(height: 32),

            // Recent Activity Ledger Table
            const Text("حالیہ کیسیز اور حاضری کی صورتحال / Recent Case Ledger", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("رجسٹریشن / Reg #")),
                  DataColumn(label: Text("نام / Name")),
                  DataColumn(label: Text("شناختی کارڈ / CNIC (Masked)")),
                  DataColumn(label: Text("نوعیت / Type")),
                  DataColumn(label: Text("حاضری کی حالت / Check-In Status")),
                  DataColumn(label: Text("افسر / Officer")),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text("LHR-2026-089")),
                    DataCell(Text("محمد علی")),
                    DataCell(Text("35202-******-1")),
                    DataCell(Chip(label: Text("Probation"), backgroundColor: Colors.tealAccent)),
                    DataCell(Text("حاضر (Verified)", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                    DataCell(Text("طاہر محمود (PO)")),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("LHR-2026-142")),
                    DataCell(Text("احمد حسن")),
                    DataCell(Text("35201-******-5")),
                    DataCell(Chip(label: Text("Parole"), backgroundColor: Colors.orangeAccent)),
                    DataCell(Text("زیرِ التواء (Pending)", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))),
                    DataCell(Text("کامران اختر (Parole Officer)")),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 36),
              const SizedBox(height: 12),
              Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 13, color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }
}
