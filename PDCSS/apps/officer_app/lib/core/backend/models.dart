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
      'Probation Order',
      'Probation Order',
      'Probation Order'
    ];
    final dates = ['2026-07-28', '2026-07-25', '2026-07-22', '2026-07-30'];

    return SuperviseeBrief(
      id: 'supervisee-$index',
      fullName: names[index % names.length],
      cnicMasked: '35201-XXXXXXX-${index % 10}',
      caseNumber: cases[index % cases.length],
      complianceStatus: statuses[index % statuses.length],
      supervisionCategory: cats[index % cats.length],
      nextReportingDate: dates[index % dates.length],
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

class ActivityAttendanceReviewRecord {
  final String id;
  final String assignedActivityId;
  final String activityTitle;
  final String activityCategory;
  final String superviseeId;
  final String superviseeName;
  final String caseNumber;
  final String submittedAt;
  final String attendanceStatus;
  final double? latitude;
  final double? longitude;
  final double? accuracyMeters;
  final String locationPermissionStatus;
  final String locationMatchStatus;
  final double? distanceFromExpectedMeters;
  final int? allowedRadiusMeters;
  final String? photoUrl;
  final String photoStatus;
  final String livenessStatus;
  final String? remarks;
  final String reviewStatus;
  final String receiptNo;

  ActivityAttendanceReviewRecord({
    required this.id,
    required this.assignedActivityId,
    required this.activityTitle,
    required this.activityCategory,
    required this.superviseeId,
    required this.superviseeName,
    required this.caseNumber,
    required this.submittedAt,
    required this.attendanceStatus,
    this.latitude,
    this.longitude,
    this.accuracyMeters,
    required this.locationPermissionStatus,
    required this.locationMatchStatus,
    this.distanceFromExpectedMeters,
    this.allowedRadiusMeters,
    this.photoUrl,
    required this.photoStatus,
    required this.livenessStatus,
    this.remarks,
    required this.reviewStatus,
    required this.receiptNo,
  });

  factory ActivityAttendanceReviewRecord.fromMap(Map<String, dynamic> map) {
    final assigned = map['assigned_activities'] as Map<String, dynamic>? ?? {};
    final supervisee = map['supervisees'] as Map<String, dynamic>? ?? {};
    final profile = supervisee['profiles'] as Map<String, dynamic>? ?? {};

    return ActivityAttendanceReviewRecord(
      id: map['id']?.toString() ?? '',
      assignedActivityId: map['assigned_activity_id']?.toString() ?? '',
      activityTitle:
          assigned['activity_title']?.toString() ?? 'Assigned Activity',
      activityCategory: assigned['activity_category']?.toString() ?? 'General',
      superviseeId: map['supervisee_id']?.toString() ?? '',
      superviseeName: profile['full_name']?.toString() ?? 'Tariq Mehmood',
      caseNumber: supervisee['case_number']?.toString() ?? 'LHR-2026-089',
      submittedAt: map['submitted_at']?.toString() ?? '',
      attendanceStatus: map['attendance_status']?.toString() ?? 'Submitted',
      latitude:
          map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
      longitude: map['longitude'] != null
          ? (map['longitude'] as num).toDouble()
          : null,
      accuracyMeters: map['accuracy_meters'] != null
          ? (map['accuracy_meters'] as num).toDouble()
          : null,
      locationPermissionStatus:
          map['location_permission_status']?.toString() ?? 'Not Required',
      locationMatchStatus:
          map['location_match_status']?.toString() ?? 'Not Required',
      distanceFromExpectedMeters: map['distance_from_expected_meters'] != null
          ? (map['distance_from_expected_meters'] as num).toDouble()
          : null,
      allowedRadiusMeters: map['allowed_radius_meters'] != null
          ? (map['allowed_radius_meters'] as num).toInt()
          : null,
      photoUrl: map['photo_url']?.toString(),
      photoStatus: map['photo_status']?.toString() ?? 'Not Required',
      livenessStatus: map['liveness_status']?.toString() ?? 'Not Required',
      remarks: map['remarks']?.toString(),
      reviewStatus: map['review_status']?.toString() ?? 'Pending Review',
      receiptNo: map['receipt_no']?.toString() ?? '',
    );
  }

  factory ActivityAttendanceReviewRecord.fallback(int index) {
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

    return ActivityAttendanceReviewRecord(
      id: 'att-rev-$index',
      assignedActivityId: 'act-10$i',
      activityTitle: titles[i],
      activityCategory: categories[i],
      superviseeId: 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f',
      superviseeName: 'Tariq Mehmood',
      caseNumber: 'LHR-2026-089',
      submittedAt: '2026-07-28 09:30:00',
      attendanceStatus: 'Submitted',
      latitude: 31.5602,
      longitude: 74.3351,
      accuracyMeters: 10.0,
      locationPermissionStatus:
          gpsMatches[i] == 'GPS Unavailable' ? 'Denied' : 'Granted',
      locationMatchStatus: gpsMatches[i],
      distanceFromExpectedMeters: distances[i],
      allowedRadiusMeters: 300,
      photoUrl: photoStatuses[i] == 'Uploaded'
          ? 'https://whqmwzoqmopgamfacncg.supabase.co/storage/v1/object/public/attendance-photos/demo_photo_${i + 1}.jpg'
          : null,
      photoStatus: photoStatuses[i],
      livenessStatus: livenessStatuses[i],
      remarks: 'Supervisee submitted attendance report via mobile app.',
      reviewStatus: reviewStatuses[i],
      receiptNo: 'PPPS-VA-2026-${5020 + index}',
    );
  }
}
