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
}
