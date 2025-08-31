// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Muhasaba - Daily Action Tracker';

  @override
  String get appTitleShort => 'Muhasaba';

  @override
  String get good => 'Good';

  @override
  String get bad => 'Bad';

  @override
  String get settings => 'Settings';

  @override
  String get addEntry => 'Add Entry';

  @override
  String get addNote => 'Add a note (optional)';

  @override
  String get score => 'Score';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get netScore => 'Net Score';

  @override
  String get today => 'Today';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get deleteEntryConfirm =>
      'Are you sure you want to delete this entry?';

  @override
  String get emptyState =>
      'No entries for this day. Start tracking your actions!';

  @override
  String scoreValue(int score) {
    return '$score';
  }

  @override
  String get dateFormat => 'EEEE, MMMM d, y';
}
