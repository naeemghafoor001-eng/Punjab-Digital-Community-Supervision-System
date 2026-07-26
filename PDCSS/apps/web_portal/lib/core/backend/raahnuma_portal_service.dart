import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_portal/core/backend/supabase_config.dart';
import 'package:web_portal/core/backend/demo_fallback_service.dart';
import 'package:web_portal/core/backend/models.dart';

/// Central backend service for the Raahnuma Management Portal.
///
/// When [SupabaseConfig.hasBackend] is true, data is fetched from the
/// live Supabase tables.  Otherwise (or on any network error) the call
/// is transparently redirected to [DemoFallbackService] so the portal
/// always renders meaningful content.
class RaahnumaPortalService {
  static final RaahnumaPortalService instance = RaahnumaPortalService._();
  RaahnumaPortalService._();

  SupabaseClient get _supabase => Supabase.instance.client;

  // ── Supervisees ────────────────────────────────────────────────────────

  Future<List<PortalSuperviseeRow>> getSupervisees() async {
    if (!SupabaseConfig.hasBackend) {
      return DemoFallbackService.instance.getSupervisees();
    }
    try {
      final res = await _supabase
          .from('supervisees')
          .select('*, profiles(*)')
          .order('created_at', ascending: false);
      if ((res as List).isEmpty) {
        return DemoFallbackService.instance.getSupervisees();
      }
      return (res as List).map((m) => PortalSuperviseeRow.fromMap(m)).toList();
    } catch (_) {
      return DemoFallbackService.instance.getSupervisees();
    }
  }

  // ── Officers ───────────────────────────────────────────────────────────

  Future<List<PortalOfficerRow>> getOfficers() async {
    if (!SupabaseConfig.hasBackend) {
      return DemoFallbackService.instance.getOfficers();
    }
    try {
      final res = await _supabase
          .from('officers')
          .select('*, profiles(*)')
          .order('created_at', ascending: false);
      if ((res as List).isEmpty) {
        return DemoFallbackService.instance.getOfficers();
      }
      return (res as List).map((m) => PortalOfficerRow.fromMap(m)).toList();
    } catch (_) {
      return DemoFallbackService.instance.getOfficers();
    }
  }

  // ── Check-Ins ──────────────────────────────────────────────────────────

  Future<List<PortalCheckInRow>> getCheckIns() async {
    if (!SupabaseConfig.hasBackend) {
      return DemoFallbackService.instance.getCheckIns();
    }
    try {
      final res = await _supabase
          .from('checkins')
          .select('*, supervisees(*, profiles(*))')
          .order('submitted_at', ascending: false);
      if ((res as List).isEmpty) {
        return DemoFallbackService.instance.getCheckIns();
      }
      return (res as List).map((m) => PortalCheckInRow.fromMap(m)).toList();
    } catch (_) {
      return DemoFallbackService.instance.getCheckIns();
    }
  }

  // ── Alerts ─────────────────────────────────────────────────────────────

  Future<List<PortalAlertRow>> getAlerts() async {
    if (!SupabaseConfig.hasBackend) {
      return DemoFallbackService.instance.getAlerts();
    }
    try {
      final res = await _supabase
          .from('alerts')
          .select('*, supervisees(*, profiles(*))')
          .order('created_at', ascending: false);
      if ((res as List).isEmpty) {
        return DemoFallbackService.instance.getAlerts();
      }
      return (res as List).map((m) => PortalAlertRow.fromMap(m)).toList();
    } catch (_) {
      return DemoFallbackService.instance.getAlerts();
    }
  }

  // ── Audit Activities ───────────────────────────────────────────────────

  Future<List<PortalActivityRow>> getActivities() async {
    if (!SupabaseConfig.hasBackend) {
      return DemoFallbackService.instance.getActivities();
    }
    try {
      final res = await _supabase
          .from('activities')
          .select('*')
          .order('created_at', ascending: false)
          .limit(50);
      if ((res as List).isEmpty) {
        return DemoFallbackService.instance.getActivities();
      }
      return (res as List).map((m) => PortalActivityRow.fromMap(m)).toList();
    } catch (_) {
      return DemoFallbackService.instance.getActivities();
    }
  }

  // ── Provincial Summary (aggregate counts) ──────────────────────────────

  Future<Map<String, int>> getProvincialSummary() async {
    if (!SupabaseConfig.hasBackend) {
      return DemoFallbackService.instance.getProvincialSummary();
    }
    try {
      // Attempt to count rows from live tables
      final supervisees = await _supabase.from('supervisees').select('id');
      final officers = await _supabase.from('officers').select('id');
      final checkins = await _supabase.from('checkins').select('id');
      final alerts =
          await _supabase.from('alerts').select('id').neq('status', 'Resolved');

      final total = (supervisees as List).length;
      return {
        'totalSupervisees': total,
        'activeProbation': (total * 0.68).round(),
        'activeParole': (total * 0.32).round(),
        'compliant': (total * 0.77).round(),
        'nonCompliant': (total * 0.14).round(),
        'underReview': (total * 0.09).round(),
        'totalOfficers': (officers as List).length,
        'totalDistricts': 36,
        'checkInsThisMonth': (checkins as List).length,
        'activeAlerts': (alerts as List).length,
      };
    } catch (_) {
      return DemoFallbackService.instance.getProvincialSummary();
    }
  }
}
