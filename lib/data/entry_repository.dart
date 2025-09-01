import 'package:hive/hive.dart';
import '../core/date_utils.dart' as date_utils;
import 'entry_model.dart';
import 'hive_init.dart';

class EntryRepository {
  Box<DayEntry> get _box => Hive.box<DayEntry>(HiveInit.entriesBoxName);

  // Get all entries for a specific logical date based on day start time
  List<DayEntry> getEntriesForLogicalDate(
    DateTime logicalDate,
    String dayStartTime,
  ) {
    final (start, end) = date_utils.DateUtils.getLogicalDayRange(
      logicalDate,
      dayStartTime,
    );

    return _box.values
        .where(
          (entry) =>
              entry.date.isAtSameMomentAs(start) ||
              entry.date.isAtSameMomentAs(end) ||
              (entry.date.isAfter(start) && entry.date.isBefore(end)),
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Most recent first
  }

  // Get all entries for a specific date (legacy method, keeps midnight-to-midnight logic)
  List<DayEntry> getEntriesForDate(DateTime date) {
    final normalizedDate = date_utils.DateUtils.normalizeDay(date);
    return _box.values
        .where(
          (entry) =>
              date_utils.DateUtils.normalizeDay(entry.date) == normalizedDate,
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Most recent first
  }

  // Stream of entries for a specific logical date
  Stream<List<DayEntry>> watchEntriesForLogicalDate(
    DateTime logicalDate,
    String dayStartTime,
  ) async* {
    yield getEntriesForLogicalDate(logicalDate, dayStartTime);

    await for (final _ in _box.watch()) {
      yield getEntriesForLogicalDate(logicalDate, dayStartTime);
    }
  }

  // Stream of entries for a specific date (legacy method)
  Stream<List<DayEntry>> watchEntriesForDate(DateTime date) async* {
    yield getEntriesForDate(date);

    await for (final _ in _box.watch()) {
      yield getEntriesForDate(date);
    }
  }

  // Add a quick entry (no note)
  Future<void> addQuick(EntryType type, int score) async {
    final entry = DayEntry(type: type, score: score, date: DateTime.now());
    await _box.add(entry);
  }

  // Add a full entry
  Future<void> addEntry({
    required EntryType type,
    required int score,
    String? note,
    DateTime? date,
  }) async {
    final entry = DayEntry(
      type: type,
      score: score,
      note: note,
      date: date ?? DateTime.now(),
    );
    await _box.add(entry);
  }

  // Update an existing entry
  Future<void> updateEntry(DayEntry entry) async {
    await entry.save();
  }

  // Delete an entry
  Future<void> deleteEntry(String id) async {
    final index = _box.values.toList().indexWhere((entry) => entry.id == id);
    if (index != -1) {
      await _box.deleteAt(index);
    }
  }

  // Get entry by ID
  DayEntry? getEntryById(String id) {
    return _box.values.firstWhere(
      (entry) => entry.id == id,
      orElse: () => DayEntry.empty(),
    );
  }

  // Get sum for a specific logical day and type
  int sumForLogical(DateTime logicalDate, String dayStartTime, EntryType type) {
    return getEntriesForLogicalDate(logicalDate, dayStartTime)
        .where((entry) => entry.type == type)
        .fold(0, (sum, entry) => sum + entry.score);
  }

  // Get net score for a specific logical day (Good - Bad)
  int netScoreForLogical(DateTime logicalDate, String dayStartTime) {
    return sumForLogical(logicalDate, dayStartTime, EntryType.good) -
        sumForLogical(logicalDate, dayStartTime, EntryType.bad);
  }

  // Undo last quick add for a specific type and logical date
  Future<bool> undoLastQuickAddLogical(
    EntryType type,
    DateTime logicalDate,
    String dayStartTime,
  ) async {
    final entries = getEntriesForLogicalDate(
      logicalDate,
      dayStartTime,
    ).where((entry) => entry.type == type && entry.note == null).toList();

    if (entries.isEmpty) return false;

    // Remove the most recent quick add (first in the sorted list)
    await entries.first.delete();
    return true;
  }

  // Undo last quick add for a specific type and date (legacy method)
  Future<bool> undoLastQuickAdd(EntryType type, DateTime date) async {
    final entries = getEntriesForDate(
      date,
    ).where((entry) => entry.type == type && entry.note == null).toList();

    if (entries.isEmpty) return false;

    // Remove the most recent quick add (first in the sorted list)
    await entries.first.delete();
    return true;
  }

  // Get all entries (for debugging/testing)
  List<DayEntry> getAllEntries() {
    return _box.values.toList();
  }

  // Clear all entries (for debugging/testing)
  Future<void> clearAll() async {
    await _box.clear();
  }
}
