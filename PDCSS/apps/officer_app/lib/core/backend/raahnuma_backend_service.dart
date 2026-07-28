import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:officer_app/core/backend/supabase_config.dart';
import 'package:officer_app/core/backend/demo_fallback_service.dart';
import 'package:officer_app/core/backend/models.dart';

class RaahnumaBackendService {
  static final RaahnumaBackendService instance = RaahnumaBackendService._();
  RaahnumaBackendService._();

  SupabaseClient get _supabase => Supabase.instance.client;
  final String _mockOfficerId =
      'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d'; // Tahir Mahmood Seed UUID

  Future<List<SuperviseeBrief>> getAssignedCases() async {
    if (!SupabaseConfig.hasBackend) {
      return DemoFallbackService.instance.getAssignedCases();
    }

    try {
      final response = await _supabase
          .from('supervisees')
          .select('*, profiles(*)')
          .order('created_at', ascending: false);

      if ((response as List).isEmpty) {
        return DemoFallbackService.instance.getAssignedCases();
      }

      return (response as List)
          .map((map) => SuperviseeBrief.fromMap(map))
          .toList();
    } catch (e) {
      return DemoFallbackService.instance.getAssignedCases();
    }
  }

  Future<List<CheckInRecord>> getSubmittedCheckIns() async {
    if (!SupabaseConfig.hasBackend) {
      return DemoFallbackService.instance.getSubmittedCheckIns();
    }

    try {
      // 1. Fetch check-ins
      final checkinsList = await _supabase
          .from('checkins')
          .select('*, supervisees(*, profiles(*))')
          .order('submitted_at', ascending: false);

      if ((checkinsList as List).isEmpty) {
        return DemoFallbackService.instance.getSubmittedCheckIns();
      }

      // 2. Fetch digital reviews (contacts of type 'Digital Check-In Review')
      final reviewsList = await _supabase
          .from('contacts')
          .select('supervisee_id, contact_date')
          .eq('contact_type', 'Digital Check-In Review');

      final Set<String> reviewedKeys = {};
      for (var r in (reviewsList as List)) {
        final sId = r['supervisee_id'];
        final date = r['contact_date'];
        reviewedKeys.add('${sId}_${date}');
      }

      return (checkinsList as List).map((map) {
        final sId = map['supervisee_id'];
        final date = map['scheduled_reporting_date'];
        final isReviewed = reviewedKeys.contains('${sId}_${date}');
        return CheckInRecord.fromMap(map, isReviewed: isReviewed);
      }).toList();
    } catch (e) {
      return DemoFallbackService.instance.getSubmittedCheckIns();
    }
  }

  Future<List<AlertRecord>> getAlerts() async {
    if (!SupabaseConfig.hasBackend) {
      return DemoFallbackService.instance.getAlerts();
    }

    try {
      final response = await _supabase
          .from('alerts')
          .select('*, supervisees(*, profiles(*))')
          .order('created_at', ascending: false);

      if ((response as List).isEmpty) {
        return DemoFallbackService.instance.getAlerts();
      }

      return (response as List).map((map) => AlertRecord.fromMap(map)).toList();
    } catch (e) {
      return DemoFallbackService.instance.getAlerts();
    }
  }

  Future<void> reviewCheckIn(String checkInId, String superviseeId,
      String scheduledReportingDate, String receiptNumber) async {
    if (!SupabaseConfig.hasBackend) {
      await DemoFallbackService.instance.reviewCheckIn(checkInId);
      return;
    }

    try {
      // Create contact record confirming review completion
      await _supabase.from('contacts').insert({
        'supervisee_id': superviseeId,
        'officer_id': _mockOfficerId,
        'contact_type': 'Digital Check-In Review',
        'contact_date': scheduledReportingDate,
        'outcome': 'Satisfactory',
        'notes': 'Officer approved digital check-in (Receipt: $receiptNumber).',
      });

      // Insert action audit activity logs
      await _supabase.from('activities').insert({
        'actor_id': _mockOfficerId,
        'event_type': 'OFFICER_REVIEW',
        'description':
            'Officer reviewed and approved digital check-in (Receipt: $receiptNumber).',
        'user_agent': 'Flutter Mobile App (Officer)',
      });
    } catch (e) {
      await DemoFallbackService.instance.reviewCheckIn(checkInId);
    }
  }

  Future<void> updateAlertStatus(String alertId, String status) async {
    if (!SupabaseConfig.hasBackend) {
      await DemoFallbackService.instance.updateAlertStatus(alertId, status);
      return;
    }

    try {
      final updates = {
        'status': status,
      };

      if (status == 'Resolved') {
        updates['resolved_at'] = DateTime.now().toIso8601String();
        updates['resolved_by'] = _mockOfficerId;
        updates['resolution_notes'] =
            'Resolved via Officer supervision dashboard.';
      }

      await _supabase.from('alerts').update(updates).eq('id', alertId);

      // Audit logs
      await _supabase.from('activities').insert({
        'actor_id': _mockOfficerId,
        'event_type': 'ALERT_RESOLUTION',
        'description':
            'Officer resolved alert ID: $alertId, setting status to: $status.',
        'user_agent': 'Flutter Mobile App (Officer)',
      });
    } catch (e) {
      await DemoFallbackService.instance.updateAlertStatus(alertId, status);
    }
  }

  Future<List<ActivityAttendanceReviewRecord>>
      getSubmittedActivityAttendance() async {
    if (!SupabaseConfig.hasBackend) {
      return DemoFallbackService.instance.getSubmittedActivityAttendance();
    }

    try {
      final response = await _supabase
          .from('activity_attendance')
          .select('*, assigned_activities(*), supervisees(*, profiles(*))')
          .order('submitted_at', ascending: false);

      if ((response as List).isEmpty) {
        return DemoFallbackService.instance.getSubmittedActivityAttendance();
      }

      return (response as List)
          .map((map) => ActivityAttendanceReviewRecord.fromMap(map))
          .toList();
    } catch (e) {
      return DemoFallbackService.instance.getSubmittedActivityAttendance();
    }
  }

  Future<void> reviewActivityAttendance(
      String attendanceId, String reviewStatus, String? remarks) async {
    if (!SupabaseConfig.hasBackend) {
      await DemoFallbackService.instance
          .reviewActivityAttendance(attendanceId, reviewStatus, remarks);
      return;
    }

    try {
      // 1. Update review_status in activity_attendance
      await _supabase.from('activity_attendance').update({
        'review_status': reviewStatus,
        'remarks': remarks,
        'reviewed_by': _mockOfficerId,
        'reviewed_at': DateTime.now().toIso8601String(),
      }).eq('id', attendanceId);

      // 2. Insert audit activity timeline entry
      try {
        await _supabase.from('activities').insert({
          'actor_id': _mockOfficerId,
          'event_type': 'OFFICER_ATTENDANCE_REVIEW',
          'description':
              'Officer Tahir Mahmood marked activity attendance (ID: $attendanceId) as $reviewStatus. Remarks: ${remarks ?? "None"}.',
          'user_agent': 'Flutter Mobile App (Officer)',
        });
      } catch (_) {
        // Suppress audit insert fail
      }
    } catch (e) {
      await DemoFallbackService.instance
          .reviewActivityAttendance(attendanceId, reviewStatus, remarks);
    }
  }
}
