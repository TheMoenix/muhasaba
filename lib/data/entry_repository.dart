import 'package:hive/hive.dart';
import '../core/date_utils.dart' as date_utils;
import 'entry_model.dart';
import 'hive_init.dart';

class EntryRepository {
  Box<DayEntry> get _box => Hive.box<DayEntry>(HiveInit.entriesBoxName);

  // Get all entries for a specific date
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

  // Stream of entries for a specific date
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

  // Get sum for a specific day and type
  int sumFor(DateTime date, EntryType type) {
    return getEntriesForDate(date)
        .where((entry) => entry.type == type)
        .fold(0, (sum, entry) => sum + entry.score);
  }

  // Get net score for a specific day (Good - Bad)
  int netScoreFor(DateTime date) {
    return sumFor(date, EntryType.good) - sumFor(date, EntryType.bad);
  }

  // Undo last quick add for a specific type and date
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
