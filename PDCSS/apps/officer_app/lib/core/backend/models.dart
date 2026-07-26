class SuperviseeBrief {
  final String id;
  final String fullName;
  final String cnicMasked;
  final String caseNumber;
  final String complianceStatus;
  final String supervisionCategory;
  final String nextReportingDate;

  SuperviseeBrief({
    required this.id,
    required this.fullName,
    required this.cnicMasked,
    required this.caseNumber,
    required this.complianceStatus,
    required this.supervisionCategory,
    required this.nextReportingDate,
  });

  factory SuperviseeBrief.fromMap(Map<String, dynamic> map) {
    final profile = map['profiles'] as Map<String, dynamic>? ?? {};
    return SuperviseeBrief(
      id: map['id']?.toString() ?? '',
      fullName: profile['full_name']?.toString() ?? 'Tariq Mehmood',
      cnicMasked: map['cnic_masked']?.toString() ?? '35201-XXXXXXX-9',
      caseNumber: map['case_number']?.toString() ?? 'LHR-2026-089',
      complianceStatus: map['compliance_status']?.toString() ?? 'Compliant',
      supervisionCategory:
          map['supervision_category']?.toString() ?? 'Probation Order',
      nextReportingDate: map['next_reporting_date']?.toString() ?? '2026-07-28',
    );
  }

  factory SuperviseeBrief.fallback(int index) {
    final names = [
      'Tariq Mehmood',
      'Sajid Ali',
      'Muhammad Yasir',
      'Zainab Bibi'
    ];
    final cases = [
      'LHR-2026-089',
      'LHR-2026-112',
      'LHR-2026-215',
      'LHR-2026-443'
    ];
    final statuses = [
      'Compliant',
      'Compliant',
      'Non-Compliant',
      'Under Review'
    ];
    final cats = [
      'Probation Order',
      'Parole Release',
      'Probation Order',
      'Probation Order'
    ];

    return SuperviseeBrief(
      id: 'supervisee-$index',
      fullName: names[index % names.length],
      cnicMasked: '35201-XXXXXXX-${index % 10}',
      caseNumber: cases[index % cases.length],
      complianceStatus: statuses[index % statuses.length],
      supervisionCategory: cats[index % cats.length],
      nextReportingDate: '2026-07-${20 + index}',
    );
  }
}

class CheckInRecord {
  final String id;
  final String superviseeId;
  final String superviseeName;
  final String scheduledReportingDate;
  final String receiptNumber;
  final String submittedAt;
  final bool identityConfirmed;
  final bool residingAtAddress;
  final bool changedEmployment;
  final bool needAssistance;
  final bool complyingConditions;
  final bool isReviewed;

  CheckInRecord({
    required this.id,
    required this.superviseeId,
    required this.superviseeName,
    required this.scheduledReportingDate,
    required this.receiptNumber,
    required this.submittedAt,
    required this.identityConfirmed,
    required this.residingAtAddress,
    required this.changedEmployment,
    required this.needAssistance,
    required this.complyingConditions,
    required this.isReviewed,
  });

  factory CheckInRecord.fromMap(Map<String, dynamic> map,
      {bool isReviewed = false}) {
    final supervisee = map['supervisees'] as Map<String, dynamic>? ?? {};
    final profile = supervisee['profiles'] as Map<String, dynamic>? ?? {};

    return CheckInRecord(
      id: map['id']?.toString() ?? '',
      superviseeId: map['supervisee_id']?.toString() ?? '',
      superviseeName: profile['full_name']?.toString() ?? 'Tariq Mehmood',
      scheduledReportingDate: map['scheduled_reporting_date']?.toString() ?? '',
      receiptNumber: map['receipt_number']?.toString() ?? '',
      submittedAt: map['submitted_at']?.toString() ?? '',
      identityConfirmed: map['identity_confirmed'] as bool? ?? true,
      residingAtAddress: map['residing_at_address'] as bool? ?? true,
      changedEmployment: map['changed_employment'] as bool? ?? false,
      needAssistance: map['need_assistance'] as bool? ?? false,
      complyingConditions: map['complying_conditions'] as bool? ?? true,
      isReviewed: isReviewed,
    );
  }

  factory CheckInRecord.fallback(int index) {
    return CheckInRecord(
      id: 'checkin-$index',
      superviseeId: 'supervisee-1',
      superviseeName: 'Tariq Mehmood',
      scheduledReportingDate: '2026-07-25',
      receiptNumber: 'PPPS-CI-2026-${8940 + index}',
      submittedAt: '2026-07-25 14:30:00',
      identityConfirmed: true,
      residingAtAddress: true,
      changedEmployment: false,
      needAssistance: false,
      complyingConditions: true,
      isReviewed: index == 0,
    );
  }
}

class AlertRecord {
  final String id;
  final String superviseeId;
  final String superviseeName;
  final String category;
  final String severity;
  final String description;
  final String status;
  final String createdAt;

  AlertRecord({
    required this.id,
    required this.superviseeId,
    required this.superviseeName,
    required this.category,
    required this.severity,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory AlertRecord.fromMap(Map<String, dynamic> map) {
    final supervisee = map['supervisees'] as Map<String, dynamic>? ?? {};
    final profile = supervisee['profiles'] as Map<String, dynamic>? ?? {};

    return AlertRecord(
      id: map['id']?.toString() ?? '',
      superviseeId: map['supervisee_id']?.toString() ?? '',
      superviseeName: profile['full_name']?.toString() ?? 'Tariq Mehmood',
      category: map['category']?.toString() ?? 'Missed Check-In',
      severity: map['severity']?.toString() ?? 'Overdue',
      description: map['description']?.toString() ?? '',
      status: map['status']?.toString() ?? 'Active',
      createdAt: map['created_at']?.toString() ?? '',
    );
  }

  factory AlertRecord.fallback(int index) {
    final categories = [
      'Missed Check-In',
      'Missed Appointment',
      'Address Deviation'
    ];
    final severities = ['Overdue', 'Violation', 'Info'];
    final statuses = ['Active', 'In Review', 'Resolved'];

    return AlertRecord(
      id: 'alert-$index',
      superviseeId: 'supervisee-1',
      superviseeName: 'Tariq Mehmood',
      category: categories[index % categories.length],
      severity: severities[index % severities.length],
      description:
          'Check-In report overdue for regional sector reporting date.',
      status: statuses[index % statuses.length],
      createdAt: '2026-07-24 09:15:00',
    );
  }
}
