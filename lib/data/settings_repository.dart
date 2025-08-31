import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const String _themeModeKey = 'themeMode';
  static const String _defaultIncrementKey = 'defaultIncrement';
  static const String _showNotesInListKey = 'showNotesInList';
  static const String _dailyReminderTimeKey = 'dailyReminderTime';
  static const String _languageKey = 'language';

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
    final languageCode =
        _prefs.getString(_languageKey) ?? 'ar'; // Default to Arabic
    return Locale(languageCode);
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(_languageKey, locale.languageCode);
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
      await setLocale(const Locale('ar')); // Default to Arabic
    }
  }
}
