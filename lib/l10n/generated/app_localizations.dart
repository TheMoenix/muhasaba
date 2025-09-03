import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Muhasaba'**
  String get appTitle;

  /// The short title of the application
  ///
  /// In en, this message translates to:
  /// **'Muhasaba'**
  String get appTitleShort;

  /// Label for good actions
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// Label for bad actions
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get bad;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Button text to add a new entry
  ///
  /// In en, this message translates to:
  /// **'Add Entry'**
  String get addEntry;

  /// Placeholder text for note input
  ///
  /// In en, this message translates to:
  /// **'Add a note (optional)'**
  String get addNote;

  /// Label for score input
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Label for net score display
  ///
  /// In en, this message translates to:
  /// **'Net Score'**
  String get netScore;

  /// Today button text
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Arabic language name
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Confirmation message for deleting an entry
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this entry?'**
  String get deleteEntryConfirm;

  /// Message shown when there are no entries for the day
  ///
  /// In en, this message translates to:
  /// **'No entries for this day. Start tracking your actions!'**
  String get emptyState;

  /// Score value display
  ///
  /// In en, this message translates to:
  /// **'{score}'**
  String scoreValue(int score);

  /// Full date format with day of week
  ///
  /// In en, this message translates to:
  /// **'EEEE, MMMM d, y'**
  String get dateFormat;

  /// Short date format for headers
  ///
  /// In en, this message translates to:
  /// **'MMM d, y'**
  String get dateFormatShort;

  /// Appearance section title
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Behavior section title
  ///
  /// In en, this message translates to:
  /// **'Behavior'**
  String get behavior;

  /// Reminders section title
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Default increment setting label
  ///
  /// In en, this message translates to:
  /// **'Default increment'**
  String get defaultIncrement;

  /// Default increment setting description
  ///
  /// In en, this message translates to:
  /// **'Quick +/- buttons add {increment} points'**
  String defaultIncrementDescription(int increment);

  /// Show notes in list setting label
  ///
  /// In en, this message translates to:
  /// **'Show notes in list'**
  String get showNotesInList;

  /// Show notes in list setting description
  ///
  /// In en, this message translates to:
  /// **'Display entry notes instead of just scores'**
  String get showNotesInListDescription;

  /// Daily reminder setting label
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get dailyReminder;

  /// Daily reminder time description
  ///
  /// In en, this message translates to:
  /// **'Remind me at {time}'**
  String remindMeAt(String time);

  /// No reminder set description
  ///
  /// In en, this message translates to:
  /// **'No reminder set'**
  String get noReminderSet;

  /// App description text
  ///
  /// In en, this message translates to:
  /// **'Daily good and bad actions tracker\nVersion 1.0.0'**
  String get appDescription;

  /// Type label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Add action placeholder text
  ///
  /// In en, this message translates to:
  /// **'Add a {type} action...'**
  String addAction(String type);

  /// Edit entry title
  ///
  /// In en, this message translates to:
  /// **'Edit Entry'**
  String get editEntry;

  /// Add entry title
  ///
  /// In en, this message translates to:
  /// **'Add Entry'**
  String get addEntryTitle;

  /// Note optional label
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

  /// Add note placeholder
  ///
  /// In en, this message translates to:
  /// **'Add a note...'**
  String get addNote2;

  /// Update button text
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Delete entry dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Entry'**
  String get deleteEntry;

  /// Entry deleted message
  ///
  /// In en, this message translates to:
  /// **'Entry deleted'**
  String get entryDeleted;

  /// Undo action label
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// Select date help text
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// Net score display
  ///
  /// In en, this message translates to:
  /// **'Net: {score}'**
  String net(String score);

  /// No entries message
  ///
  /// In en, this message translates to:
  /// **'No {type} entries yet'**
  String noEntriesYet(String type);

  /// Tap to add instruction
  ///
  /// In en, this message translates to:
  /// **'Tap + to add a quick entry'**
  String get tapToAdd;

  /// Placeholder text for action input field
  ///
  /// In en, this message translates to:
  /// **'Add action...'**
  String get addActionPlaceholder;

  /// Default note for quick good actions
  ///
  /// In en, this message translates to:
  /// **'Good action'**
  String get defaultGoodAction;

  /// Default note for quick bad actions
  ///
  /// In en, this message translates to:
  /// **'Bad action'**
  String get defaultBadAction;

  /// Empty state message for good actions
  ///
  /// In en, this message translates to:
  /// **'No good actions today'**
  String get noGoodActionsToday;

  /// Empty state message for bad actions
  ///
  /// In en, this message translates to:
  /// **'No bad actions today'**
  String get noBadActionsToday;

  /// General section title
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// Actions section title
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// Notifications section title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Start time of day setting label
  ///
  /// In en, this message translates to:
  /// **'Start Time of the Day'**
  String get startTimeOfDay;

  /// Default increment setting short label
  ///
  /// In en, this message translates to:
  /// **'Default Increment'**
  String get defaultIncrementShort;

  /// Show notes in entries setting label
  ///
  /// In en, this message translates to:
  /// **'Show Notes in Entries'**
  String get showNotesInEntries;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
