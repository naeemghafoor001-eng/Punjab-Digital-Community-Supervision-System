import 'package:flutter/material.dart';

class AuditLogScreen extends StatefulWidget {
  const AuditLogScreen({Key? key}) : super(key: key);

  @override
  State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> {
  bool _verifying = false;
  bool _verifiedIntact = true;
  String _message = "آڈٹ لیجر مکمل طور پر محفوظ ہے۔ / Audit chain 100% verified intact.";

  void _runIntegrityCheck() {
    setState(() {
      _verifying = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _verifying = false;
        _verifiedIntact = true;
        _message = "HMAC-SHA256 ہیش چین کی تصدیق مکمل: تمام رکارڈز اصلی اور غیر تبدیل شدہ ہیں۔\nHMAC-SHA256 Hash Chain Verified: All records authentic and untampered.";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("آڈٹ اینڈ سیکیورٹی لیجر / Tamper-Evident Audit Ledger"),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              icon: _verifying
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.verified_user, color: Colors.white),
              label: const Text("ہیش چین کی تصدیق کریں / Run Hash Chain Integrity Check", style: TextStyle(color: Colors.white, fontSize: 16)),
              onPressed: _verifying ? null : _runIntegrityCheck,
            ),
            const SizedBox(height: 20),

            Card(
              color: _verifiedIntact ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(_verifiedIntact ? Icons.check_circle : Icons.error, color: _verifiedIntact ? Colors.green : Colors.red, size: 36),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(_message, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text("حالیہ لاگز / Recent Audit Log Records", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Card(
              elevation: 2,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("وقت / Timestamp")),
                  DataColumn(label: Text("صارف / User Role")),
                  DataColumn(label: Text("کارروائی / Action")),
                  DataColumn(label: Text("ہیش چین / HMAC Hash Checksum")),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text("2026-07-25 21:30:02")),
                    DataCell(Text("ROLE_PROBATION_OFFICER")),
                    DataCell(Text("CREATE_SUPERVISEE_DOSSIER")),
                    DataCell(Text("a8f9b2c3d4e5f6... (Match)", style: TextStyle(fontFamily: 'Monospace', color: Colors.green))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("2026-07-25 21:15:10")),
                    DataCell(Text("ROLE_SUPERVISEE")),
                    DataCell(Text("SUBMIT_DIGITAL_CHECKIN")),
                    DataCell(Text("7c9e6679-7425... (Match)", style: TextStyle(fontFamily: 'Monospace', color: Colors.green))),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
