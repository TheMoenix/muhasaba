/// Utility functions for date normalization and formatting
class DateUtils {
  /// Normalizes a DateTime to the start of the day (00:00:00.000)
  static DateTime normalizeDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Combines a selected date with the current time
  /// For example: if selectedDate is 2025-08-30 00:00:00.000 and current time is 2025-09-01 08:53:00.000
  /// Returns: 2025-08-30 08:53:00.000
  static DateTime combineDateWithCurrentTime(DateTime selectedDate) {
    final now = DateTime.now();
    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      now.hour,
      now.minute,
      now.second,
      now.millisecond,
      now.microsecond,
    );
  }

  /// Normalizes a DateTime to the logical start of day based on day start time
  /// For example, if dayStartTime is "06:00" and current time is 2:00 AM,
  /// it should belong to the previous logical day
  static DateTime normalizeLogicalDay(DateTime date, String dayStartTime) {
    final parts = dayStartTime.split(':');
    final startHour = int.parse(parts[0]);
    final startMinute = int.parse(parts[1]);

    final dayStart = DateTime(
      date.year,
      date.month,
      date.day,
      startHour,
      startMinute,
    );

    // If the current time is before the day start time, it belongs to the previous logical day
    if (date.isBefore(dayStart)) {
      return normalizeDay(date.subtract(const Duration(days: 1)));
    }

    return normalizeDay(date);
  }

  /// Gets the date range for a logical day based on day start time
  /// Returns a tuple of (start, end) DateTime for the logical day
  /// For example: if logicalDay is Sept 1st and dayStartTime is "06:00"
  /// Returns: (Sept 1st 06:00:00, Sept 2nd 05:59:59.999)
  static (DateTime start, DateTime end) getLogicalDayRange(
    DateTime logicalDay,
    String dayStartTime,
  ) {
    final parts = dayStartTime.split(':');
    final startHour = int.parse(parts[0]);
    final startMinute = int.parse(parts[1]);

    // Start of the logical day: logicalDay at dayStartTime
    final start = DateTime(
      logicalDay.year,
      logicalDay.month,
      logicalDay.day,
      startHour,
      startMinute,
      0, // seconds
      0, // milliseconds
      0, // microseconds
    );

    // End of the logical day: next day at dayStartTime minus 1 millisecond
    final end = DateTime(
      logicalDay.year,
      logicalDay.month,
      logicalDay.day + 1,
      startHour,
      startMinute,
      0, // seconds
      0, // milliseconds
      0, // microseconds
    ).subtract(const Duration(milliseconds: 1));

    return (start, end);
  }

  /// Checks if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return normalizeDay(date1) == normalizeDay(date2);
  }

  /// Gets today's date normalized
  static DateTime today() {
    return normalizeDay(DateTime.now());
  }

  /// Gets today's logical day based on day start time
  static DateTime todayLogical(String dayStartTime) {
    return normalizeLogicalDay(DateTime.now(), dayStartTime);
  }

  /// Test helper: formats a DateTime range for debugging
  static String formatRange(DateTime start, DateTime end) {
    return 'From: ${start.toString()} To: ${end.toString()}';
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
