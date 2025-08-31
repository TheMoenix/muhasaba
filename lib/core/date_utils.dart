/// Utility functions for date normalization and formatting
class DateUtils {
  /// Normalizes a DateTime to the start of the day (00:00:00.000)
  static DateTime normalizeDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Checks if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return normalizeDay(date1) == normalizeDay(date2);
  }

  /// Gets today's date normalized
  static DateTime today() {
    return normalizeDay(DateTime.now());
  }

  /// Formats a date for display (e.g., "Jan 15, 2024")
  static String formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Formats a date as key for storage (yyyy-MM-dd)
  static String formatDateKey(DateTime date) {
    final normalized = normalizeDay(date);
    return '${normalized.year.toString().padLeft(4, '0')}-'
        '${normalized.month.toString().padLeft(2, '0')}-'
        '${normalized.day.toString().padLeft(2, '0')}';
  }

  /// Parses a date key back to DateTime
  static DateTime parseDateKey(String key) {
    final parts = key.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  /// Gets the next day
  static DateTime nextDay(DateTime date) {
    return normalizeDay(date.add(const Duration(days: 1)));
  }

  /// Gets the previous day
  static DateTime previousDay(DateTime date) {
    return normalizeDay(date.subtract(const Duration(days: 1)));
  }

  /// Checks if a date is today
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }
}
