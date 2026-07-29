import 'dart:math';
import 'package:supervisee_app/core/backend/models.dart';

class DemoFallbackService {
  static final DemoFallbackService instance = DemoFallbackService._();
  DemoFallbackService._();

  Future<SuperviseeProfile> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return SuperviseeProfile.fallback();
  }

  Future<AppointmentModel?> getNextAppointment() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return AppointmentModel.fallback();
  }

  Future<String> submitCheckIn({
    required String superviseeId,
    required String scheduledReportingDate,
    required bool residingAtAddress,
    required bool changedEmployment,
    required bool needAssistance,
    required bool complyingConditions,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final randomSuffix = Random().nextInt(9000) + 1000;
    return 'PPPS-CI-2026-$randomSuffix';
  }

  Future<List<AssignedActivityModel>> getAssignedActivities() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      AssignedActivityModel(
        id: 'act-101',
        superviseeId: 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f',
        officerId: 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
        activityTitle: 'Bi-weekly Probation Office Reporting / دفتری حاضری',
        activityCategory: 'Reporting',
        instructions:
            'Report to Lahore Central Office for bi-weekly progress review with Probation Officer. / لاہور سینٹرل دفتر میں افسر کے سامنے پیش ہوں۔',
        frequency: 'Bi-Weekly',
        dueTime: '10:00 AM',
        startDate: '2026-06-15',
        endDate: '2026-12-15',
        status: 'Active',
        expectedLocationName: 'Lahore Central Office, Home Dept',
        expectedLatitude: 31.5601,
        expectedLongitude: 74.3352,
        allowedRadiusMeters: 300,
        requiresLocation: true,
        requiresPhoto: true,
        requiresLiveness: true,
        reviewStatus: 'Pending Review',
        lastSubmittedDate: '28 July 2026',
      ),
      AssignedActivityModel(
        id: 'act-102',
        superviseeId: 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f',
        officerId: 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
        activityTitle: 'TEVTA Vocational Skills Training / فنی تربیت سیشن',
        activityCategory: 'Skills',
        instructions:
            'Attend vocational electrician training sessions at TEVTA designated center. / ٹیوٹا سیشن میں باقاعدگی سے شرکت کریں۔',
        frequency: 'Weekly',
        dueTime: '02:00 PM',
        startDate: '2026-07-01',
        endDate: '2026-09-30',
        status: 'Active',
        expectedLocationName: 'TEVTA Vocational Center Lahore',
        expectedLatitude: 31.5204,
        expectedLongitude: 74.3587,
        allowedRadiusMeters: 400,
        requiresLocation: true,
        requiresPhoto: true,
        requiresLiveness: false,
        reviewStatus: 'Accepted',
        lastSubmittedDate: '26 July 2026',
      ),
      AssignedActivityModel(
        id: 'act-103',
        superviseeId: 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f',
        officerId: 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
        activityTitle: 'Rehabilitation & Counselling Session / بحالی سیشن',
        activityCategory: 'Counselling',
        instructions:
            'Participate in social guidance and mental wellness counselling. / معاشرتی بحالی اور رہنمائی سیشن میں شرکت کریں۔',
        frequency: 'Monthly',
        dueTime: '11:00 AM',
        startDate: '2026-06-20',
        endDate: '2026-12-20',
        status: 'Active',
        expectedLocationName: 'District Guidance Center',
        expectedLatitude: 31.5601,
        expectedLongitude: 74.3352,
        allowedRadiusMeters: 300,
        requiresLocation: true,
        requiresPhoto: true,
        requiresLiveness: true,
        reviewStatus: 'Not Submitted',
        lastSubmittedDate: 'Not Yet Submitted',
      ),
      AssignedActivityModel(
        id: 'act-104',
        superviseeId: 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f',
        officerId: 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
        activityTitle: 'Community Service Duty / کمیونٹی سروس ڈیوٹی',
        activityCategory: 'Community Service',
        instructions:
            'Participate in approved civic cleanliness and green park drive. / منظور شدہ کمیونٹی کی بہتری کی سرگرمی میں حصہ لیں۔',
        frequency: 'Weekly',
        dueTime: '09:00 AM',
        startDate: '2026-07-05',
        endDate: '2026-08-30',
        status: 'Active',
        expectedLocationName: 'Model Town Community Park',
        expectedLatitude: 31.4822,
        expectedLongitude: 74.3211,
        allowedRadiusMeters: 500,
        requiresLocation: true,
        requiresPhoto: false,
        requiresLiveness: false,
        reviewStatus: 'Needs Follow-up',
        lastSubmittedDate: '22 July 2026',
      ),
      AssignedActivityModel(
        id: 'act-105',
        superviseeId: 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f',
        officerId: 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
        activityTitle:
            'Spiritual / Personal Discipline Activity / روحانی و ذاتی نظم و ضبط کی سرگرمی',
        activityCategory: 'Personal Discipline',
        instructions:
            'Voluntary personal discipline activity as part of an approved supervision or rehabilitation plan. Must be voluntary and lawful.',
        frequency: 'Daily',
        dueTime: '08:00 AM',
        startDate: '2026-07-01',
        endDate: '2026-12-31',
        status: 'Active',
        expectedLocationName: 'Local Designated Community Hub',
        expectedLatitude: null,
        expectedLongitude: null,
        allowedRadiusMeters: 500,
        requiresLocation: false,
        requiresPhoto: false,
        requiresLiveness: false,
        reviewStatus: 'Not Submitted',
        lastSubmittedDate: 'Not Yet Submitted',
      ),
    ];
  }

  Future<String> submitActivityAttendance({
    required String assignedActivityId,
    required String superviseeId,
    required String officerId,
    required double? latitude,
    required double? longitude,
    required double? accuracyMeters,
    required String locationPermissionStatus,
    required String locationMatchStatus,
    required double? distanceFromExpectedMeters,
    required String? photoUrl,
    required String photoStatus,
    required String livenessStatus,
    required String? remarks,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final randomSuffix = Random().nextInt(9000) + 1000;
    return 'PPPS-VA-2026-$randomSuffix';
  }
}
