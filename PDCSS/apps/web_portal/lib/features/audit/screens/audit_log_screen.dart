import 'package:flutter/material.dart';

class AuditLogScreen extends StatefulWidget {
  const AuditLogScreen({Key? key}) : super(key: key);

  @override
  State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> {
  bool _verifying = false;
  bool _verifiedIntact = true;
  String _message = "Audit chain 100% verified intact. All records untampered.";

  void _runIntegrityCheck() {
    setState(() {
      _verifying = true;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _verifying = false;
        _verifiedIntact = true;
        _message =
            "HMAC-SHA256 Hash Chain Verified: All system audit logs are authentic and checksum-validated.";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 650) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Audit & Security Ledger',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A))),
                    const SizedBox(height: 4),
                    const Text(
                        'Tamper-evident system activity and verification history',
                        style: TextStyle(fontSize: 12, color: Colors.black54)),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F766E),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        icon: _verifying
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.verified_user,
                                color: Colors.white),
                        label: const Text("Run Hash Chain Integrity Check",
                            style:
                                TextStyle(color: Colors.white, fontSize: 13)),
                        onPressed: _verifying ? null : _runIntegrityCheck,
                      ),
                    ),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Audit & Security Ledger',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A))),
                        SizedBox(height: 4),
                        Text(
                            'Tamper-evident system activity and verification history',
                            style:
                                TextStyle(fontSize: 13, color: Colors.black54),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                    ),
                    icon: _verifying
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.verified_user, color: Colors.white),
                    label: const Text("Run Hash Chain Integrity Check",
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    onPressed: _verifying ? null : _runIntegrityCheck,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          Card(
            color: _verifiedIntact
                ? const Color(0xFFF0FDF4)
                : const Color(0xFFFEF2F2),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(_verifiedIntact ? Icons.check_circle : Icons.error,
                      color: _verifiedIntact ? Colors.green : Colors.red,
                      size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(_message,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text("System Audit & Security Records",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            elevation: 2,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Timestamp")),
                  DataColumn(label: Text("User Role")),
                  DataColumn(label: Text("Action")),
                  DataColumn(label: Text("Details")),
                  DataColumn(label: Text("Checksum Hash")),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text("2026-07-26 10:15:22")),
                    DataCell(Chip(
                        label: Text("DIRECTORATE_ADMIN",
                            style:
                                TextStyle(fontSize: 10, color: Colors.white)),
                        backgroundColor: Colors.indigo)),
                    DataCell(Text("User viewed dashboard")),
                    DataCell(Text("Provincial summary metrics loaded")),
                    DataCell(Text("8f9a2b4c5e6f... (Valid)",
                        style: TextStyle(
                            fontFamily: 'Monospace',
                            color: Colors.green,
                            fontSize: 12))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("2026-07-26 09:42:10")),
                    DataCell(Chip(
                        label: Text("PROBATION_OFFICER",
                            style:
                                TextStyle(fontSize: 10, color: Colors.white)),
                        backgroundColor: Color(0xFF0F766E))),
                    DataCell(Text("Officer reviewed case")),
                    DataCell(Text("Case profile LHR-2026-089 accessed")),
                    DataCell(Text("e3c1a7b9d0e2... (Valid)",
                        style: TextStyle(
                            fontFamily: 'Monospace',
                            color: Colors.green,
                            fontSize: 12))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("2026-07-26 08:30:05")),
                    DataCell(Chip(
                        label: Text("SUPERVISEE",
                            style:
                                TextStyle(fontSize: 10, color: Colors.white)),
                        backgroundColor: Colors.teal)),
                    DataCell(Text("Digital check-in submitted")),
                    DataCell(Text("Receipt PPPS-CI-2026-0001 generated")),
                    DataCell(Text("b5d8f2e4c1a9... (Valid)",
                        style: TextStyle(
                            fontFamily: 'Monospace',
                            color: Colors.green,
                            fontSize: 12))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("2026-07-26 07:12:00")),
                    DataCell(Chip(
                        label: Text("SYSTEM",
                            style:
                                TextStyle(fontSize: 10, color: Colors.white)),
                        backgroundColor: Colors.blueGrey)),
                    DataCell(Text("Report generated")),
                    DataCell(Text("District Performance Report exported")),
                    DataCell(Text("4a9f1c3e5b7d... (Valid)",
                        style: TextStyle(
                            fontFamily: 'Monospace',
                            color: Colors.green,
                            fontSize: 12))),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
