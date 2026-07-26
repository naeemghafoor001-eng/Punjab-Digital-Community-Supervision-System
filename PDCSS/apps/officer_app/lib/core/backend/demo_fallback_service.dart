import 'package:officer_app/core/backend/models.dart';

class DemoFallbackService {
  static final DemoFallbackService instance = DemoFallbackService._();
  DemoFallbackService._();

  final List<SuperviseeBrief> _cases =
      List.generate(4, (i) => SuperviseeBrief.fallback(i));
  final List<CheckInRecord> _checkins =
      List.generate(3, (i) => CheckInRecord.fallback(i));
  final List<AlertRecord> _alerts =
      List.generate(3, (i) => AlertRecord.fallback(i));

  Future<List<SuperviseeBrief>> getAssignedCases() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _cases;
  }

  Future<List<CheckInRecord>> getSubmittedCheckIns() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _checkins;
  }

  Future<List<AlertRecord>> getAlerts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _alerts;
  }

  Future<void> reviewCheckIn(String checkInId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _checkins.indexWhere((c) => c.id == checkInId);
    if (index != -1) {
      final old = _checkins[index];
      _checkins[index] = CheckInRecord(
        id: old.id,
        superviseeId: old.superviseeId,
        superviseeName: old.superviseeName,
        scheduledReportingDate: old.scheduledReportingDate,
        receiptNumber: old.receiptNumber,
        submittedAt: old.submittedAt,
        identityConfirmed: old.identityConfirmed,
        residingAtAddress: old.residingAtAddress,
        changedEmployment: old.changedEmployment,
        needAssistance: old.needAssistance,
        complyingConditions: old.complyingConditions,
        isReviewed: true,
      );
    }
  }

  Future<void> updateAlertStatus(String alertId, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _alerts.indexWhere((a) => a.id == alertId);
    if (index != -1) {
      final old = _alerts[index];
      _alerts[index] = AlertRecord(
        id: old.id,
        superviseeId: old.superviseeId,
        superviseeName: old.superviseeName,
        category: old.category,
        severity: old.severity,
        description: old.description,
        status: status,
        createdAt: old.createdAt,
      );
    }
  }
}
