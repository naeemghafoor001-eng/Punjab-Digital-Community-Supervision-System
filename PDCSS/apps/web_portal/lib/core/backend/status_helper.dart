import 'package:intl/intl.dart';

class SupervisionStatusHelper {
  /// Computes the dynamic supervision status according to approved rules:
  /// - Draft: Missing Probation Start Date or Probation End Date.
  /// - Active: Start Date <= reference date and End Date > reference date.
  /// - Completed: End Date <= reference date.
  /// - Future: Start Date > reference date.
  static String calculateStatus({
    required String? startDateStr,
    required String? endDateStr,
    DateTime? referenceDate,
  }) {
    if (startDateStr == null ||
        startDateStr.isEmpty ||
        endDateStr == null ||
        endDateStr.isEmpty) {
      return 'Draft';
    }

    final ref = referenceDate ?? DateTime.now();
    final refDateOnly = DateTime(ref.year, ref.month, ref.day);

    DateTime? startDate = _parseDate(startDateStr);
    DateTime? endDate = _parseDate(endDateStr);

    if (startDate == null || endDate == null) {
      return 'Draft';
    }

    final startOnly = DateTime(startDate.year, startDate.month, startDate.day);
    final endOnly = DateTime(endDate.year, endDate.month, endDate.day);

    if (startOnly.isAfter(refDateOnly)) {
      return 'Future';
    } else if (endOnly.isBefore(refDateOnly) ||
        endOnly.isAtSameMomentAs(refDateOnly)) {
      return 'Completed';
    } else if ((startOnly.isBefore(refDateOnly) ||
            startOnly.isAtSameMomentAs(refDateOnly)) &&
        endOnly.isAfter(refDateOnly)) {
      return 'Active';
    }

    return 'Active';
  }

  static DateTime? _parseDate(String dateStr) {
    try {
      final clean = dateStr.split('/').first.trim();
      return DateTime.parse(clean);
    } catch (_) {
      try {
        final DateFormat formatter = DateFormat('dd MMMM yyyy');
        return formatter.parse(dateStr.split('/').first.trim());
      } catch (_) {
        return null;
      }
    }
  }
}
