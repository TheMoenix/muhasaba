import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/date_utils.dart' as date_utils;
import '../../data/entry_model.dart';
import '../../data/entry_repository.dart';
import '../../data/settings_repository.dart';

// Providers
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepository(prefs);
});

final entryRepositoryProvider = Provider<EntryRepository>((ref) {
  return EntryRepository();
});

final selectedDayProvider = StateProvider<DateTime>((ref) {
  return date_utils.DateUtils.today();
});

final dayEntriesProvider = StreamProvider.family<List<DayEntry>, DateTime>((
  ref,
  date,
) {
  final repository = ref.watch(entryRepositoryProvider);
  return repository.watchEntriesForDate(date);
});

final dayTotalsProvider =
    Provider.family<({int good, int bad, int net}), DateTime>((ref, date) {
      final entriesAsync = ref.watch(dayEntriesProvider(date));

      return entriesAsync.when(
        data: (entries) {
          final good = entries
              .where((e) => e.type == EntryType.good)
              .fold(0, (sum, e) => sum + e.score);
          final bad = entries
              .where((e) => e.type == EntryType.bad)
              .fold(0, (sum, e) => sum + e.score);
          return (good: good, bad: bad, net: good - bad);
        },
        loading: () => (good: 0, bad: 0, net: 0),
        error: (_, __) => (good: 0, bad: 0, net: 0),
      );
    });

final goodEntriesProvider = Provider.family<List<DayEntry>, DateTime>((
  ref,
  date,
) {
  final entriesAsync = ref.watch(dayEntriesProvider(date));

  return entriesAsync.when(
    data: (entries) => entries.where((e) => e.type == EntryType.good).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

final badEntriesProvider = Provider.family<List<DayEntry>, DateTime>((
  ref,
  date,
) {
  final entriesAsync = ref.watch(dayEntriesProvider(date));

  return entriesAsync.when(
    data: (entries) => entries.where((e) => e.type == EntryType.bad).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Controllers
class HomeController extends StateNotifier<AsyncValue<void>> {
  HomeController(this._entryRepository, this._settingsRepository)
    : super(const AsyncValue.data(null));

  final EntryRepository _entryRepository;
  final SettingsRepository _settingsRepository;

  Future<void> addQuickEntry(EntryType type) async {
    state = const AsyncValue.loading();
    try {
      final increment = _settingsRepository.defaultIncrement;
      await _entryRepository.addQuick(type, increment);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> undoLastQuickEntry(EntryType type, DateTime date) async {
    try {
      return await _entryRepository.undoLastQuickAdd(type, date);
    } catch (error) {
      return false;
    }
  }

  Future<void> addEntry({
    required EntryType type,
    required int score,
    String? note,
    DateTime? date,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _entryRepository.addEntry(
        type: type,
        score: score,
        note: note,
        date: date,
      );
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateEntry(DayEntry entry) async {
    state = const AsyncValue.loading();
    try {
      await _entryRepository.updateEntry(entry);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteEntry(String id) async {
    state = const AsyncValue.loading();
    try {
      await _entryRepository.deleteEntry(id);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final homeControllerProvider =
    StateNotifierProvider<HomeController, AsyncValue<void>>((ref) {
      final entryRepository = ref.watch(entryRepositoryProvider);
      final settingsRepository = ref.watch(settingsRepositoryProvider);
      return HomeController(entryRepository, settingsRepository);
    });
