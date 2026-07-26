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
