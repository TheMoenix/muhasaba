import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/generated/app_localizations.dart';
import 'settings_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final defaultIncrement = ref.watch(defaultIncrementProvider);
    final showNotesInList = ref.watch(showNotesInListProvider);
    final dailyReminderTime = ref.watch(dailyReminderTimeProvider);
    final locale = ref.watch(localeProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Setting
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(l10n.language),
                    subtitle: Text(_getLanguageText(locale, l10n)),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () =>
                        _showLanguageSelector(context, ref, controller, l10n),
                  ),
                  ListTile(
                    title: Text(l10n.theme),
                    subtitle: Text(_getThemeModeText(themeMode, l10n)),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () =>
                        _showThemeSelector(context, ref, controller, l10n),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Behavior Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Behavior',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Default increment'),
                    subtitle: Text(
                      'Quick +/- buttons add $defaultIncrement points',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: defaultIncrement > 1
                              ? () => controller.setDefaultIncrement(
                                  defaultIncrement - 1,
                                )
                              : null,
                          icon: const Icon(Icons.remove),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            defaultIncrement.toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        IconButton(
                          onPressed: defaultIncrement < 10
                              ? () => controller.setDefaultIncrement(
                                  defaultIncrement + 1,
                                )
                              : null,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Show notes in list'),
                    subtitle: const Text(
                      'Display entry notes instead of just scores',
                    ),
                    value: showNotesInList,
                    onChanged: (value) => controller.setShowNotesInList(value),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Reminders Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reminders',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Daily reminder'),
                    subtitle: Text(
                      dailyReminderTime != null
                          ? 'Remind me at $dailyReminderTime'
                          : 'No reminder set',
                    ),
                    trailing: dailyReminderTime != null
                        ? IconButton(
                            onPressed: () =>
                                controller.setDailyReminderTime(null),
                            icon: const Icon(Icons.clear),
                          )
                        : const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showTimeSelector(context, ref, controller),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // App Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  const ListTile(
                    title: Text('Muhasaba'),
                    subtitle: Text(
                      'Daily good and bad actions tracker\nVersion 1.0.0',
                    ),
                    leading: Icon(Icons.info_outline),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeModeText(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.themeLight;
      case ThemeMode.dark:
        return l10n.themeDark;
      case ThemeMode.system:
        return l10n.themeSystem;
    }
  }

  String _getLanguageText(Locale locale, AppLocalizations l10n) {
    switch (locale.languageCode) {
      case 'ar':
        return l10n.arabic;
      case 'en':
        return l10n.english;
      default:
        return l10n.english;
    }
  }

  void _showThemeSelector(
    BuildContext context,
    WidgetRef ref,
    SettingsController controller,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.themeLight),
              leading: Radio<ThemeMode>(
                value: ThemeMode.light,
                groupValue: ref.read(themeModeProvider),
                onChanged: (value) {
                  if (value != null) {
                    controller.setThemeMode(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
              onTap: () {
                controller.setThemeMode(ThemeMode.light);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text(l10n.themeDark),
              leading: Radio<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: ref.read(themeModeProvider),
                onChanged: (value) {
                  if (value != null) {
                    controller.setThemeMode(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
              onTap: () {
                controller.setThemeMode(ThemeMode.dark);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text(l10n.themeSystem),
              leading: Radio<ThemeMode>(
                value: ThemeMode.system,
                groupValue: ref.read(themeModeProvider),
                onChanged: (value) {
                  if (value != null) {
                    controller.setThemeMode(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
              onTap: () {
                controller.setThemeMode(ThemeMode.system);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(
    BuildContext context,
    WidgetRef ref,
    SettingsController controller,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.arabic),
              leading: Radio<String>(
                value: 'ar',
                groupValue: ref.read(localeProvider).languageCode,
                onChanged: (value) {
                  if (value != null) {
                    controller.setLocale(Locale(value));
                    Navigator.of(context).pop();
                  }
                },
              ),
              onTap: () {
                controller.setLocale(const Locale('ar'));
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text(l10n.english),
              leading: Radio<String>(
                value: 'en',
                groupValue: ref.read(localeProvider).languageCode,
                onChanged: (value) {
                  if (value != null) {
                    controller.setLocale(Locale(value));
                    Navigator.of(context).pop();
                  }
                },
              ),
              onTap: () {
                controller.setLocale(const Locale('en'));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTimeSelector(
    BuildContext context,
    WidgetRef ref,
    SettingsController controller,
  ) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      final timeString =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      controller.setDailyReminderTime(timeString);
    }
  }
}
