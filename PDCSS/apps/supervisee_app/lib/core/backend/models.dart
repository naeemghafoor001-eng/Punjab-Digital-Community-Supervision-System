class SuperviseeProfile {
  final String id;
  final String fullName;
  final String email;
  final String cnicMasked;
  final String caseNumber;
  final String supervisionCategory;
  final String complianceStatus;
  final String nextReportingDate;
  final String supervisionStartDate;
  final String supervisionEndDate;
  final String officerName;
  final String officeAddress;
  final String district;

  SuperviseeProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.cnicMasked,
    required this.caseNumber,
    required this.supervisionCategory,
    required this.complianceStatus,
    required this.nextReportingDate,
    required this.supervisionStartDate,
    required this.supervisionEndDate,
    required this.officerName,
    required this.officeAddress,
    required this.district,
  });

  factory SuperviseeProfile.fromMap(Map<String, dynamic> map) {
    // Relational mapping: supervisees -> profiles, officers -> profiles
    final profile = map['profiles'] as Map<String, dynamic>? ?? {};
    final officer = map['officers'] as Map<String, dynamic>? ?? {};
    final officerProfile = officer['profiles'] as Map<String, dynamic>? ?? {};

    return SuperviseeProfile(
      id: map['id']?.toString() ?? '',
      fullName: profile['full_name']?.toString() ?? 'Tariq Mehmood',
      email: profile['email']?.toString() ?? '',
      cnicMasked: map['cnic_masked']?.toString() ?? '35201-XXXXXXX-9',
      caseNumber: map['case_number']?.toString() ?? 'LHR-2026-089',
      supervisionCategory:
          map['supervision_category']?.toString() ?? 'Probation Order',
      complianceStatus: map['compliance_status']?.toString() ?? 'Compliant',
      nextReportingDate: map['next_reporting_date']?.toString() ?? '2026-07-28',
      supervisionStartDate:
          map['supervision_start_date']?.toString() ?? '2026-06-15',
      supervisionEndDate:
          map['supervision_end_date']?.toString() ?? '2026-12-15',
      officerName:
          officerProfile['full_name']?.toString() ?? 'Officer Tahir Mahmood',
      officeAddress:
          officer['office_address']?.toString() ?? 'Lahore Central Office',
      district: officer['district']?.toString() ?? 'Lahore',
    );
  }

  factory SuperviseeProfile.fallback() {
    return SuperviseeProfile(
      id: 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f',
      fullName: 'Tariq Mehmood / طارق محمود',
      email: 'supervisee.tariq@example.com',
      cnicMasked: '35201-XXXXXXX-9',
      caseNumber: 'LHR-2026-089',
      supervisionCategory: 'Probation Order / پروبیشن حکم',
      complianceStatus: 'Compliant / تعمیل کنندہ',
      nextReportingDate: '28 July 2026 / 28 جولائی 2026',
      supervisionStartDate: '15 June 2026 / 15 جون 2026',
      supervisionEndDate: '15 December 2026 / 15 دسمبر 2026',
      officerName: 'Officer Tahir Mahmood / افسر طاہر محمود',
      officeAddress: 'Lahore Central Office / لاہور سینٹرل دفتر',
      district: 'Lahore / لاہور',
    );
  }
}

class AppointmentModel {
  final String id;
  final String title;
  final String scheduledTime;
  final String location;
  final String status;

  AppointmentModel({
    required this.id,
    required this.title,
    required this.scheduledTime,
    required this.location,
    required this.status,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      scheduledTime: map['scheduled_time']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
    );
  }

  factory AppointmentModel.fallback() {
    return AppointmentModel(
      id: 'appointment-1',
      title: 'Office Reporting / دفتری حاضری',
      scheduledTime: '2026-07-28 10:00:00+05',
      location: 'Lahore Central Office / لاہور سینٹرل دفتر',
      status: 'Upcoming',
    );
  }
}

class AssignedActivityModel {
  final String id;
  final String superviseeId;
  final String officerId;
  final String activityTitle;
  final String activityCategory;
  final String instructions;
  final String frequency;
  final String? dueTime;
  final String startDate;
  final String endDate;
  final String status;
  final String? expectedLocationName;
  final double? expectedLatitude;
  final double? expectedLongitude;
  final int allowedRadiusMeters;
  final bool requiresLocation;
  final bool requiresPhoto;
  final bool requiresLiveness;
  final String reviewStatus;

  AssignedActivityModel({
    required this.id,
    required this.superviseeId,
    required this.officerId,
    required this.activityTitle,
    required this.activityCategory,
    required this.instructions,
    required this.frequency,
    this.dueTime,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.expectedLocationName,
    this.expectedLatitude,
    this.expectedLongitude,
    this.allowedRadiusMeters = 300,
    this.requiresLocation = false,
    this.requiresPhoto = false,
    this.requiresLiveness = false,
    this.reviewStatus = 'Not Submitted',
  });

  factory AssignedActivityModel.fromMap(Map<String, dynamic> map,
      {String? reviewStatus}) {
    return AssignedActivityModel(
      id: map['id']?.toString() ?? '',
      superviseeId: map['supervisee_id']?.toString() ?? '',
      officerId: map['officer_id']?.toString() ?? '',
      activityTitle: map['activity_title']?.toString() ?? '',
      activityCategory: map['activity_category']?.toString() ?? 'General',
      instructions: map['instructions']?.toString() ?? '',
      frequency: map['frequency']?.toString() ?? 'Weekly',
      dueTime: map['due_time']?.toString(),
      startDate: map['start_date']?.toString() ?? '',
      endDate: map['end_date']?.toString() ?? '',
      status: map['status']?.toString() ?? 'Active',
      expectedLocationName: map['expected_location_name']?.toString(),
      expectedLatitude: map['expected_latitude'] != null
          ? (map['expected_latitude'] as num).toDouble()
          : null,
      expectedLongitude: map['expected_longitude'] != null
          ? (map['expected_longitude'] as num).toDouble()
          : null,
      allowedRadiusMeters: map['allowed_radius_meters'] != null
          ? (map['allowed_radius_meters'] as num).toInt()
          : 300,
      requiresLocation: map['requires_location'] == true,
      requiresPhoto: map['requires_photo'] == true,
      requiresLiveness: map['requires_liveness'] == true,
      reviewStatus: reviewStatus ?? 'Not Submitted',
    );
  }
}

class ActivityAttendanceModel {
  final String id;
  final String assignedActivityId;
  final String superviseeId;
  final String? officerId;
  final String submittedAt;
  final String attendanceStatus;
  final double? latitude;
  final double? longitude;
  final double? accuracyMeters;
  final String locationPermissionStatus;
  final double? expectedLatitude;
  final double? expectedLongitude;
  final double? distanceFromExpectedMeters;
  final int? allowedRadiusMeters;
  final String locationMatchStatus;
  final String? photoUrl;
  final String photoStatus;
  final String livenessStatus;
  final String? remarks;
  final String reviewStatus;
  final String receiptNo;
  final String? reviewedBy;
  final String? reviewedAt;

  ActivityAttendanceModel({
    required this.id,
    required this.assignedActivityId,
    required this.superviseeId,
    this.officerId,
    required this.submittedAt,
    required this.attendanceStatus,
    this.latitude,
    this.longitude,
    this.accuracyMeters,
    required this.locationPermissionStatus,
    this.expectedLatitude,
    this.expectedLongitude,
    this.distanceFromExpectedMeters,
    this.allowedRadiusMeters,
    required this.locationMatchStatus,
    this.photoUrl,
    required this.photoStatus,
    required this.livenessStatus,
    this.remarks,
    required this.reviewStatus,
    required this.receiptNo,
    this.reviewedBy,
    this.reviewedAt,
  });

  factory ActivityAttendanceModel.fromMap(Map<String, dynamic> map) {
    return ActivityAttendanceModel(
      id: map['id']?.toString() ?? '',
      assignedActivityId: map['assigned_activity_id']?.toString() ?? '',
      superviseeId: map['supervisee_id']?.toString() ?? '',
      officerId: map['officer_id']?.toString(),
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
      expectedLatitude: map['expected_latitude'] != null
          ? (map['expected_latitude'] as num).toDouble()
          : null,
      expectedLongitude: map['expected_longitude'] != null
          ? (map['expected_longitude'] as num).toDouble()
          : null,
      distanceFromExpectedMeters: map['distance_from_expected_meters'] != null
          ? (map['distance_from_expected_meters'] as num).toDouble()
          : null,
      allowedRadiusMeters: map['allowed_radius_meters'] != null
          ? (map['allowed_radius_meters'] as num).toInt()
          : null,
      locationMatchStatus:
          map['location_match_status']?.toString() ?? 'Not Required',
      photoUrl: map['photo_url']?.toString(),
      photoStatus: map['photo_status']?.toString() ?? 'Not Required',
      livenessStatus: map['liveness_status']?.toString() ?? 'Not Required',
      remarks: map['remarks']?.toString(),
      reviewStatus: map['review_status']?.toString() ?? 'Pending Review',
      receiptNo: map['receipt_no']?.toString() ?? '',
      reviewedBy: map['reviewed_by']?.toString(),
      reviewedAt: map['reviewed_at']?.toString(),
    );
  }
}
