import 'package:web_portal/core/backend/models.dart';

/// Provides fictional demonstration records when no Supabase backend
/// is configured (i.e. SUPABASE_URL / SUPABASE_ANON_KEY are absent).
class DemoFallbackService {
  static final DemoFallbackService instance = DemoFallbackService._();
  DemoFallbackService._();

  final List<PortalSuperviseeRow> _supervisees =
      List.generate(6, (i) => PortalSuperviseeRow.fallback(i));
  final List<PortalOfficerRow> _officers =
      List.generate(3, (i) => PortalOfficerRow.fallback(i));
  final List<PortalCheckInRow> _checkins =
      List.generate(3, (i) => PortalCheckInRow.fallback(i));
  final List<PortalAlertRow> _alerts =
      List.generate(3, (i) => PortalAlertRow.fallback(i));
  final List<PortalActivityRow> _activities =
      List.generate(4, (i) => PortalActivityRow.fallback(i));

  Future<List<PortalSuperviseeRow>> getSupervisees() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _supervisees;
  }

  Future<List<PortalOfficerRow>> getOfficers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _officers;
  }

  Future<List<PortalCheckInRow>> getCheckIns() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _checkins;
  }

  Future<List<PortalAlertRow>> getAlerts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _alerts;
  }

  Future<List<PortalActivityRow>> getActivities() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _activities;
  }

  Future<Map<String, int>> getProvincialSummary() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      'totalSupervisees': 2847,
      'activeProbation': 1932,
      'activeParole': 915,
      'compliant': 2204,
      'nonCompliant': 387,
      'underReview': 256,
      'totalOfficers': 187,
      'totalDistricts': 36,
      'checkInsThisMonth': 1893,
      'activeAlerts': 142,
    };
  }
}
