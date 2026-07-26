/// Data models for the Raahnuma Management Portal.
/// These models map to the Supabase schema defined in
/// docs/backend/supabase_schema.sql.

class PortalSuperviseeRow {
  final String id;
  final String fullName;
  final String caseNumber;
  final String complianceStatus;
  final String supervisionCategory;
  final String nextReportingDate;
  final String assignedOfficer;
  final String district;

  PortalSuperviseeRow({
    required this.id,
    required this.fullName,
    required this.caseNumber,
    required this.complianceStatus,
    required this.supervisionCategory,
    required this.nextReportingDate,
    required this.assignedOfficer,
    required this.district,
  });

  factory PortalSuperviseeRow.fromMap(Map<String, dynamic> map) {
    final profile = map['profiles'] as Map<String, dynamic>? ?? {};
    return PortalSuperviseeRow(
      id: map['id']?.toString() ?? '',
      fullName: profile['full_name']?.toString() ?? '',
      caseNumber: map['case_number']?.toString() ?? '',
      complianceStatus: map['compliance_status']?.toString() ?? 'Under Review',
      supervisionCategory:
          map['supervision_category']?.toString() ?? 'Probation Order',
      nextReportingDate: map['next_reporting_date']?.toString() ?? '',
      assignedOfficer: '',
      district: profile['district']?.toString() ?? 'Lahore',
    );
  }

  factory PortalSuperviseeRow.fallback(int index) {
    final names = [
      'Tariq Mehmood',
      'Ahmed Hassan',
      'Umar Farooq',
      'Zubair Khan',
      'Sajid Ali',
      'Muhammad Yasir',
    ];
    final cases = [
      'LHR-2026-089',
      'LHR-2026-142',
      'LHR-2026-031',
      'LHR-2026-217',
      'RWP-2026-112',
      'FSD-2026-215',
    ];
    final statuses = [
      'Compliant',
      'Non-Compliant',
      'Compliant',
      'Violation',
      'Compliant',
      'Under Review',
    ];
    final cats = [
      'Probation Order',
      'Parole Release',
      'Probation Order',
      'Probation Order',
      'Parole Release',
      'Probation Order',
    ];
    final officers = [
      'Tahir Mahmood',
      'Asad Iqbal',
      'Tahir Mahmood',
      'Asad Iqbal',
      'Kashif Raza',
      'Tahir Mahmood',
    ];
    final districts = [
      'Lahore',
      'Lahore',
      'Lahore',
      'Lahore',
      'Rawalpindi',
      'Faisalabad',
    ];

    return PortalSuperviseeRow(
      id: 'supervisee-$index',
      fullName: names[index % names.length],
      caseNumber: cases[index % cases.length],
      complianceStatus: statuses[index % statuses.length],
      supervisionCategory: cats[index % cats.length],
      nextReportingDate: '2026-07-${20 + index}',
      assignedOfficer: officers[index % officers.length],
      district: districts[index % districts.length],
    );
  }
}

class PortalOfficerRow {
  final String id;
  final String fullName;
  final String designation;
  final String district;
  final int caseCount;

  PortalOfficerRow({
    required this.id,
    required this.fullName,
    required this.designation,
    required this.district,
    required this.caseCount,
  });

  factory PortalOfficerRow.fromMap(Map<String, dynamic> map) {
    final profile = map['profiles'] as Map<String, dynamic>? ?? {};
    return PortalOfficerRow(
      id: map['id']?.toString() ?? '',
      fullName: profile['full_name']?.toString() ?? '',
      designation: map['designation']?.toString() ?? 'Probation Officer',
      district: profile['district']?.toString() ?? 'Lahore',
      caseCount: map['case_count'] as int? ?? 0,
    );
  }

  factory PortalOfficerRow.fallback(int index) {
    final names = ['Tahir Mahmood', 'Asad Iqbal', 'Kashif Raza'];
    final designations = [
      'Probation Officer',
      'Probation Officer',
      'Senior Probation Officer',
    ];
    final districts = ['Lahore', 'Lahore', 'Rawalpindi'];
    final counts = [42, 38, 44];

    return PortalOfficerRow(
      id: 'officer-$index',
      fullName: names[index % names.length],
      designation: designations[index % designations.length],
      district: districts[index % districts.length],
      caseCount: counts[index % counts.length],
    );
  }
}

class PortalCheckInRow {
  final String id;
  final String superviseeId;
  final String superviseeName;
  final String scheduledReportingDate;
  final String receiptNumber;
  final String submittedAt;
  final bool residingAtAddress;
  final bool changedEmployment;
  final bool needAssistance;
  final bool complyingConditions;
  final bool isReviewed;

  PortalCheckInRow({
    required this.id,
    required this.superviseeId,
    required this.superviseeName,
    required this.scheduledReportingDate,
    required this.receiptNumber,
    required this.submittedAt,
    required this.residingAtAddress,
    required this.changedEmployment,
    required this.needAssistance,
    required this.complyingConditions,
    required this.isReviewed,
  });

  factory PortalCheckInRow.fromMap(Map<String, dynamic> map,
      {bool isReviewed = false}) {
    final supervisee = map['supervisees'] as Map<String, dynamic>? ?? {};
    final profile = supervisee['profiles'] as Map<String, dynamic>? ?? {};

    return PortalCheckInRow(
      id: map['id']?.toString() ?? '',
      superviseeId: map['supervisee_id']?.toString() ?? '',
      superviseeName: profile['full_name']?.toString() ?? '',
      scheduledReportingDate: map['scheduled_reporting_date']?.toString() ?? '',
      receiptNumber: map['receipt_number']?.toString() ?? '',
      submittedAt: map['submitted_at']?.toString() ?? '',
      residingAtAddress: map['residing_at_address'] as bool? ?? true,
      changedEmployment: map['changed_employment'] as bool? ?? false,
      needAssistance: map['need_assistance'] as bool? ?? false,
      complyingConditions: map['complying_conditions'] as bool? ?? true,
      isReviewed: isReviewed,
    );
  }

  factory PortalCheckInRow.fallback(int index) {
    final names = ['Tariq Mehmood', 'Ahmed Hassan', 'Sajid Ali'];
    return PortalCheckInRow(
      id: 'checkin-$index',
      superviseeId: 'supervisee-$index',
      superviseeName: names[index % names.length],
      scheduledReportingDate: '2026-07-${20 + index}',
      receiptNumber: 'PPPS-CI-2026-${8940 + index}',
      submittedAt: '2026-07-${20 + index} 14:30:00',
      residingAtAddress: true,
      changedEmployment: false,
      needAssistance: index == 1,
      complyingConditions: true,
      isReviewed: index == 0,
    );
  }
}

class PortalAlertRow {
  final String id;
  final String superviseeId;
  final String superviseeName;
  final String category;
  final String severity;
  final String description;
  final String status;
  final String createdAt;

  PortalAlertRow({
    required this.id,
    required this.superviseeId,
    required this.superviseeName,
    required this.category,
    required this.severity,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory PortalAlertRow.fromMap(Map<String, dynamic> map) {
    final supervisee = map['supervisees'] as Map<String, dynamic>? ?? {};
    final profile = supervisee['profiles'] as Map<String, dynamic>? ?? {};

    return PortalAlertRow(
      id: map['id']?.toString() ?? '',
      superviseeId: map['supervisee_id']?.toString() ?? '',
      superviseeName: profile['full_name']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      severity: map['severity']?.toString() ?? 'Info',
      description: map['description']?.toString() ?? '',
      status: map['status']?.toString() ?? 'Active',
      createdAt: map['created_at']?.toString() ?? '',
    );
  }

  factory PortalAlertRow.fallback(int index) {
    final categories = [
      'Missed Check-In',
      'Missed Appointment',
      'Address Deviation',
    ];
    final severities = ['Overdue', 'Violation', 'Info'];
    final statuses = ['Active', 'In Review', 'Resolved'];

    return PortalAlertRow(
      id: 'alert-$index',
      superviseeId: 'supervisee-$index',
      superviseeName: 'Tariq Mehmood',
      category: categories[index % categories.length],
      severity: severities[index % severities.length],
      description: 'System-generated alert for reporting compliance.',
      status: statuses[index % statuses.length],
      createdAt: '2026-07-24 09:15:00',
    );
  }
}

class PortalActivityRow {
  final String id;
  final String actorId;
  final String eventType;
  final String description;
  final String createdAt;

  PortalActivityRow({
    required this.id,
    required this.actorId,
    required this.eventType,
    required this.description,
    required this.createdAt,
  });

  factory PortalActivityRow.fromMap(Map<String, dynamic> map) {
    return PortalActivityRow(
      id: map['id']?.toString() ?? '',
      actorId: map['actor_id']?.toString() ?? '',
      eventType: map['event_type']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      createdAt: map['created_at']?.toString() ?? '',
    );
  }

  factory PortalActivityRow.fallback(int index) {
    final events = [
      'CHECKIN_SUBMITTED',
      'OFFICER_REVIEW',
      'ALERT_RESOLUTION',
      'LOGIN',
    ];
    final descs = [
      'Supervisee submitted digital check-in report.',
      'Officer reviewed and approved digital check-in.',
      'Alert resolved via officer dashboard.',
      'Officer logged in from desktop browser.',
    ];

    return PortalActivityRow(
      id: 'activity-$index',
      actorId: 'actor-$index',
      eventType: events[index % events.length],
      description: descs[index % descs.length],
      createdAt: '2026-07-25 10:${10 + index}:00',
    );
  }
}
