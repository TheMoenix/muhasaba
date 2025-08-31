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

  @override
  String get appearance => 'Appearance';

  @override
  String get behavior => 'Behavior';

  @override
  String get reminders => 'Reminders';

  @override
  String get about => 'About';

  @override
  String get defaultIncrement => 'Default increment';

  @override
  String defaultIncrementDescription(int increment) {
    return 'Quick +/- buttons add $increment points';
  }

  @override
  String get showNotesInList => 'Show notes in list';

  @override
  String get showNotesInListDescription =>
      'Display entry notes instead of just scores';

  @override
  String get dailyReminder => 'Daily reminder';

  @override
  String remindMeAt(String time) {
    return 'Remind me at $time';
  }

  @override
  String get noReminderSet => 'No reminder set';

  @override
  String get appDescription =>
      'Daily good and bad actions tracker\nVersion 1.0.0';

  @override
  String get type => 'Type';

  @override
  String addAction(String type) {
    return 'Add a $type action...';
  }

  @override
  String get editEntry => 'Edit Entry';

  @override
  String get addEntryTitle => 'Add Entry';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get addNote2 => 'Add a note...';

  @override
  String get update => 'Update';

  @override
  String get deleteEntry => 'Delete Entry';

  @override
  String get entryDeleted => 'Entry deleted';

  @override
  String get undo => 'Undo';

  @override
  String get selectDate => 'Select date';

  @override
  String net(String score) {
    return 'Net: $score';
  }

  @override
  String noEntriesYet(String type) {
    return 'No $type entries yet';
  }

  @override
  String get tapToAdd => 'Tap + to add a quick entry';
}
