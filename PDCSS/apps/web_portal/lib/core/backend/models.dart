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
      'Sajid Ali',
      'Muhammad Yasir',
      'Zainab Bibi',
      'Ahmed Hassan',
      'Umar Farooq',
    ];
    final cases = [
      'LHR-2026-089',
      'LHR-2026-112',
      'LHR-2026-215',
      'LHR-2026-443',
      'LHR-2026-142',
      'RWP-2026-031',
    ];
    final statuses = [
      'Compliant',
      'Compliant',
      'Non-Compliant',
      'Under Review',
      'Non-Compliant',
      'Compliant',
    ];
    final cats = [
      'Probation Order',
      'Probation Order',
      'Probation Order',
      'Probation Order',
      'Parole Release',
      'Parole Release',
    ];
    final officers = [
      'Tahir Mahmood',
      'Tahir Mahmood',
      'Tahir Mahmood',
      'Tahir Mahmood',
      'Asad Iqbal',
      'Kashif Raza',
    ];
    final districts = [
      'Lahore',
      'Lahore',
      'Lahore',
      'Lahore',
      'Lahore',
      'Rawalpindi',
    ];
    final dates = [
      '2026-07-28',
      '2026-07-25',
      '2026-07-22',
      '2026-07-30',
      '2026-07-24',
      '2026-07-26',
    ];

    return PortalSuperviseeRow(
      id: 'supervisee-$index',
      fullName: names[index % names.length],
      caseNumber: cases[index % cases.length],
      complianceStatus: statuses[index % statuses.length],
      supervisionCategory: cats[index % cats.length],
      nextReportingDate: dates[index % dates.length],
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

class PortalVerifiedAttendanceSummary {
  final int activeAssignedActivities;
  final int attendanceSubmittedToday;
  final int pendingAttendanceReviews;
  final int gpsWithinRadius;
  final int gpsOutsideRadius;
  final int gpsUnavailable;
  final int photoVerifiedSubmissions;
  final int livenessPromptCompleted;
  final Map<String, int> activitiesByCategory;

  PortalVerifiedAttendanceSummary({
    required this.activeAssignedActivities,
    required this.attendanceSubmittedToday,
    required this.pendingAttendanceReviews,
    required this.gpsWithinRadius,
    required this.gpsOutsideRadius,
    required this.gpsUnavailable,
    required this.photoVerifiedSubmissions,
    required this.livenessPromptCompleted,
    required this.activitiesByCategory,
  });

  factory PortalVerifiedAttendanceSummary.fallback() {
    return PortalVerifiedAttendanceSummary(
      activeAssignedActivities: 148,
      attendanceSubmittedToday: 42,
      pendingAttendanceReviews: 9,
      gpsWithinRadius: 35,
      gpsOutsideRadius: 4,
      gpsUnavailable: 3,
      photoVerifiedSubmissions: 38,
      livenessPromptCompleted: 29,
      activitiesByCategory: {
        'Reporting': 45,
        'Skills': 32,
        'Counselling': 26,
        'Community Service': 20,
        'Health': 15,
        'Personal Discipline': 10,
      },
    );
  }
}

class PortalActivityAttendanceRow {
  final String id;
  final String superviseeName;
  final String caseNumber;
  final String activityTitle;
  final String activityCategory;
  final String submittedAt;
  final String locationMatchStatus;
  final double? distanceFromExpectedMeters;
  final String photoStatus;
  final String livenessStatus;
  final String reviewStatus;
  final String receiptNo;

  PortalActivityAttendanceRow({
    required this.id,
    required this.superviseeName,
    required this.caseNumber,
    required this.activityTitle,
    required this.activityCategory,
    required this.submittedAt,
    required this.locationMatchStatus,
    this.distanceFromExpectedMeters,
    required this.photoStatus,
    required this.livenessStatus,
    required this.reviewStatus,
    required this.receiptNo,
  });

  factory PortalActivityAttendanceRow.fromMap(Map<String, dynamic> map) {
    final assigned = map['assigned_activities'] as Map<String, dynamic>? ?? {};
    final supervisee = map['supervisees'] as Map<String, dynamic>? ?? {};
    final profile = supervisee['profiles'] as Map<String, dynamic>? ?? {};

    return PortalActivityAttendanceRow(
      id: map['id']?.toString() ?? '',
      superviseeName: profile['full_name']?.toString() ?? 'Tariq Mehmood',
      caseNumber: supervisee['case_number']?.toString() ?? 'LHR-2026-089',
      activityTitle:
          assigned['activity_title']?.toString() ?? 'Assigned Activity',
      activityCategory: assigned['activity_category']?.toString() ?? 'General',
      submittedAt: map['submitted_at']?.toString() ?? '',
      locationMatchStatus:
          map['location_match_status']?.toString() ?? 'Not Required',
      distanceFromExpectedMeters: map['distance_from_expected_meters'] != null
          ? (map['distance_from_expected_meters'] as num).toDouble()
          : null,
      photoStatus: map['photo_status']?.toString() ?? 'Not Required',
      livenessStatus: map['liveness_status']?.toString() ?? 'Not Required',
      reviewStatus: map['review_status']?.toString() ?? 'Pending Review',
      receiptNo: map['receipt_no']?.toString() ?? '',
    );
  }

  factory PortalActivityAttendanceRow.fallback(int index) {
    final names = [
      'Tariq Mehmood',
      'Ahmed Hassan',
      'Sajid Ali',
      'Muhammad Usama',
      'Usman Ahmed'
    ];
    final cases = [
      'LHR-2026-089',
      'LHR-2026-142',
      'LHR-2026-112',
      'LHR-2026-042',
      'LHR-2026-014'
    ];
    final titles = [
      'Bi-weekly Probation Office Reporting',
      'TEVTA Vocational Skills Training',
      'Community Welfare Cleanliness Drive',
      'Rehabilitation & Wellness Counselling',
      'Spiritual / Personal Discipline Activity',
    ];
    final categories = [
      'Reporting',
      'Skills',
      'Community Service',
      'Counselling',
      'Personal Discipline'
    ];
    final gpsMatches = [
      'Within Radius',
      'Within Radius',
      'Outside Radius',
      'GPS Unavailable',
      'Not Required'
    ];
    final photoStatuses = [
      'Uploaded',
      'Uploaded',
      'Camera Unavailable',
      'Uploaded',
      'Not Required'
    ];
    final livenessStatuses = [
      'Prompt Completed',
      'Not Required',
      'Not Required',
      'Prompt Completed',
      'Not Required'
    ];
    final reviewStatuses = [
      'Pending Review',
      'Accepted',
      'Needs Follow-up',
      'Pending Review',
      'Accepted'
    ];
    final distances = [18.2, 65.4, 1050.8, null, null];

    final i = index % titles.length;

    return PortalActivityAttendanceRow(
      id: 'portal-att-$index',
      superviseeName: names[i],
      caseNumber: cases[i],
      activityTitle: titles[i],
      activityCategory: categories[i],
      submittedAt: '2026-07-28 09:${20 + index}:00',
      locationMatchStatus: gpsMatches[i],
      distanceFromExpectedMeters: distances[i],
      photoStatus: photoStatuses[i],
      livenessStatus: livenessStatuses[i],
      reviewStatus: reviewStatuses[i],
      receiptNo: 'PPPS-VA-2026-${7010 + index}',
    );
  }
}

class PortalPRNASummary {
  final int totalPrnaCompleted;
  final int prnaPending;
  final int prnaOverdueBeyond30Days;
  final int reassessmentsDue;
  final int casePlansCompleted;
  final int casePlansPendingReview;
  final Map<String, int> riskBandDistribution; // Low, Moderate, High, Very High
  final Map<String, int> topCriminogenicNeeds;

  PortalPRNASummary({
    required this.totalPrnaCompleted,
    required this.prnaPending,
    required this.prnaOverdueBeyond30Days,
    required this.reassessmentsDue,
    required this.casePlansCompleted,
    required this.casePlansPendingReview,
    required this.riskBandDistribution,
    required this.topCriminogenicNeeds,
  });

  factory PortalPRNASummary.fallback() {
    return PortalPRNASummary(
      totalPrnaCompleted: 2412,
      prnaPending: 184,
      prnaOverdueBeyond30Days: 28,
      reassessmentsDue: 142,
      casePlansCompleted: 2180,
      casePlansPendingReview: 96,
      riskBandDistribution: {
        'Low': 815,
        'Moderate': 1140,
        'High': 350,
        'Very High': 107,
      },
      topCriminogenicNeeds: {
        'Education & Employment': 1240,
        'Companions / Peers': 890,
        'Substance Use History': 620,
        'Family / Marital': 510,
        'Attitudes & Cognition': 430,
        'Leisure & Recreation': 290,
      },
    );
  }
}

class PortalDistrictPRNARow {
  final String district;
  final int totalSupervisees;
  final int prnaCompleted;
  final int prnaPending;
  final int prnaOverdue;
  final double completionRatePercent;

  PortalDistrictPRNARow({
    required this.district,
    required this.totalSupervisees,
    required this.prnaCompleted,
    required this.prnaPending,
    required this.prnaOverdue,
    required this.completionRatePercent,
  });

  factory PortalDistrictPRNARow.fallback(int index) {
    final districts = [
      'Lahore',
      'Rawalpindi',
      'Faisalabad',
      'Multan',
      'Gujranwala',
      'Sargodha'
    ];
    final totals = [640, 480, 520, 390, 310, 240];
    final completed = [590, 435, 470, 355, 280, 215];
    final pending = [42, 38, 41, 29, 24, 20];
    final overdue = [8, 7, 9, 6, 6, 5];

    final i = index % districts.length;
    final rate = (completed[i] / totals[i]) * 100;

    return PortalDistrictPRNARow(
      district: districts[i],
      totalSupervisees: totals[i],
      prnaCompleted: completed[i],
      prnaPending: pending[i],
      prnaOverdue: overdue[i],
      completionRatePercent: rate,
    );
  }
}

class PortalOfficerPRNARow {
  final String officerName;
  final String district;
  final int assignedCases;
  final int prnaCompleted;
  final int pendingAssessments;
  final int overdue30Days;

  PortalOfficerPRNARow({
    required this.officerName,
    required this.district,
    required this.assignedCases,
    required this.prnaCompleted,
    required this.pendingAssessments,
    required this.overdue30Days,
  });

  factory PortalOfficerPRNARow.fallback(int index) {
    final officers = [
      'Tahir Mahmood',
      'Asad Iqbal',
      'Kashif Raza',
      'Zahid Hussain'
    ];
    final districts = ['Lahore', 'Lahore', 'Rawalpindi', 'Faisalabad'];
    final cases = [42, 38, 44, 36];
    final done = [38, 32, 40, 31];
    final pending = [4, 6, 4, 5];
    final overdue = [1, 2, 1, 1];

    final i = index % officers.length;

    return PortalOfficerPRNARow(
      officerName: officers[i],
      district: districts[i],
      assignedCases: cases[i],
      prnaCompleted: done[i],
      pendingAssessments: pending[i],
      overdue30Days: overdue[i],
    );
  }
}
