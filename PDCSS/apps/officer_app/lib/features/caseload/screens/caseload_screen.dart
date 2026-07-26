import 'package:flutter/material.dart';

class CaseloadScreen extends StatelessWidget {
  const CaseloadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D9488),
        title: const Text('میرے کیسز / My Caseload', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'تلاش کریں / Search by name or reg #',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _dummyCases.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final c = _dummyCases[index];
                return _CaseCard(caseData: c);
              },
            ),
          ),
        ],
      ),
    );
  }

  static final List<Map<String, String>> _dummyCases = [
    {'name': 'محمد علی / Muhammad Ali', 'reg': 'LHR-2026-089', 'cnic': '35202-******-1', 'type': 'PROBATION', 'status': 'COMPLIANT'},
    {'name': 'احمد حسن / Ahmed Hassan', 'reg': 'LHR-2026-142', 'cnic': '35201-******-5', 'type': 'PAROLE', 'status': 'OVERDUE'},
    {'name': 'عمر فاروق / Umar Farooq', 'reg': 'LHR-2026-031', 'cnic': '35204-******-3', 'type': 'PROBATION', 'status': 'COMPLIANT'},
    {'name': 'زبیر خان / Zubair Khan', 'reg': 'LHR-2026-217', 'cnic': '35206-******-9', 'type': 'PROBATION', 'status': 'VIOLATION'},
  ];
}

class _CaseCard extends StatelessWidget {
  final Map<String, String> caseData;
  const _CaseCard({required this.caseData});

  Color get _statusColor {
    switch (caseData['status']) {
      case 'COMPLIANT': return Colors.green;
      case 'OVERDUE': return Colors.orange;
      case 'VIOLATION': return Colors.red;
      default: return Colors.grey;
    }
  }

  String get _statusLabel {
    switch (caseData['status']) {
      case 'COMPLIANT': return 'تعمیل کنندہ / Compliant';
      case 'OVERDUE': return 'زائد المیعاد / Overdue';
      case 'VIOLATION': return 'خلاف ورزی / Violation';
      default: return caseData['status'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE0F2F1),
          child: Text(
            caseData['name']!.substring(0, 1),
            style: const TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(caseData['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${caseData['reg']} · ${caseData['cnic']}', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(caseData['type']!, style: const TextStyle(fontSize: 10, color: Colors.white)),
                  backgroundColor: const Color(0xFF0D9488),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(_statusLabel, style: const TextStyle(fontSize: 10, color: Colors.white)),
                  backgroundColor: _statusColor,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
