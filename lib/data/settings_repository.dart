import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class SettingsRepository {
  static const String _themeModeKey = 'themeMode';
  static const String _defaultIncrementKey = 'defaultIncrement';
  static const String _showNotesInListKey = 'showNotesInList';
  static const String _dailyReminderTimeKey = 'dailyReminderTime';
  static const String _languageKey = 'language';
  static const String _dayStartTimeKey = 'dayStartTime';

  final SharedPreferences _prefs;

  SettingsRepository(this._prefs);

  // Theme Mode
  ThemeMode get themeMode {
    final mode = _prefs.getString(_themeModeKey) ?? 'system';
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    String modeString;
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      default:
        modeString = 'system';
    }
    await _prefs.setString(_themeModeKey, modeString);
  }

  // Default Increment
  int get defaultIncrement {
    return _prefs.getInt(_defaultIncrementKey) ?? 1;
  }

  Future<void> setDefaultIncrement(int value) async {
    await _prefs.setInt(_defaultIncrementKey, value.clamp(1, 10));
  }

  // Show Notes in List
  bool get showNotesInList {
    return _prefs.getBool(_showNotesInListKey) ?? true;
  }

  Future<void> setShowNotesInList(bool value) async {
    await _prefs.setBool(_showNotesInListKey, value);
  }

  // Daily Reminder Time
  String? get dailyReminderTime {
    return _prefs.getString(_dailyReminderTimeKey);
  }

  Future<void> setDailyReminderTime(String? time) async {
    if (time == null) {
      await _prefs.remove(_dailyReminderTimeKey);
    } else {
      await _prefs.setString(_dailyReminderTimeKey, time);
    }
  }

  // Language
  Locale get locale {
    final languageCode = _prefs.getString(_languageKey);
    if (languageCode != null) {
      return Locale(languageCode);
    }

    // Default to device language if supported, otherwise fallback to Arabic
    final deviceLocale = ui.PlatformDispatcher.instance.locale;
    final supportedLanguages = ['en', 'ar'];

    if (supportedLanguages.contains(deviceLocale.languageCode)) {
      return deviceLocale;
    }

    return const Locale('ar'); // Fallback to Arabic
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(_languageKey, locale.languageCode);
  }

  // Day Start Time
  String get dayStartTime {
    return _prefs.getString(_dayStartTimeKey) ?? '06:00'; // Default to 6:00 AM
  }

  Future<void> setDayStartTime(String time) async {
    await _prefs.setString(_dayStartTimeKey, time);
  }

  // Initialize with defaults if first run
  Future<void> initializeDefaults() async {
    if (!_prefs.containsKey(_themeModeKey)) {
      await setThemeMode(ThemeMode.system);
    }
    if (!_prefs.containsKey(_defaultIncrementKey)) {
      await setDefaultIncrement(1);
    }
    if (!_prefs.containsKey(_showNotesInListKey)) {
      await setShowNotesInList(true);
    }
    if (!_prefs.containsKey(_languageKey)) {
      // Set to device language if supported, otherwise fallback to Arabic
      final deviceLocale = ui.PlatformDispatcher.instance.locale;
      final supportedLanguages = ['en', 'ar'];

      if (supportedLanguages.contains(deviceLocale.languageCode)) {
        await setLocale(deviceLocale);
      } else {
        await setLocale(const Locale('ar')); // Fallback to Arabic
      }
    }
    if (!_prefs.containsKey(_dayStartTimeKey)) {
      await setDayStartTime('06:00'); // Default to 6:00 AM
    }
  }
}
