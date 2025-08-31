import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/settings_repository.dart';
import '../home/home_controller.dart';

// Providers for individual settings
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return settingsRepository.themeMode;
});

final defaultIncrementProvider = StateProvider<int>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return settingsRepository.defaultIncrement;
});

final showNotesInListProvider = StateProvider<bool>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return settingsRepository.showNotesInList;
});

final dailyReminderTimeProvider = StateProvider<String?>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return settingsRepository.dailyReminderTime;
});

final localeProvider = StateProvider<Locale>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return settingsRepository.locale;
});

// Controller
class SettingsController extends StateNotifier<AsyncValue<void>> {
  SettingsController(this._settingsRepository, this._ref)
    : super(const AsyncValue.data(null));

  final SettingsRepository _settingsRepository;
  final Ref _ref;

  Future<void> setThemeMode(ThemeMode mode) async {
    state = const AsyncValue.loading();
    try {
      await _settingsRepository.setThemeMode(mode);
      _ref.read(themeModeProvider.notifier).state = mode;
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> setDefaultIncrement(int value) async {
    state = const AsyncValue.loading();
    try {
      await _settingsRepository.setDefaultIncrement(value);
      _ref.read(defaultIncrementProvider.notifier).state = value;
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> setShowNotesInList(bool value) async {
    state = const AsyncValue.loading();
    try {
      await _settingsRepository.setShowNotesInList(value);
      _ref.read(showNotesInListProvider.notifier).state = value;
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> setDailyReminderTime(String? time) async {
    state = const AsyncValue.loading();
    try {
      await _settingsRepository.setDailyReminderTime(time);
      _ref.read(dailyReminderTimeProvider.notifier).state = time;
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = const AsyncValue.loading();
    try {
      await _settingsRepository.setLocale(locale);
      _ref.read(localeProvider.notifier).state = locale;
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AsyncValue<void>>((ref) {
      final settingsRepository = ref.watch(settingsRepositoryProvider);
      return SettingsController(settingsRepository, ref);
    });
