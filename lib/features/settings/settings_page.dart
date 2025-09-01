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
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Appearance Section
          _buildSection(
            context,
            title: l10n.appearance,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Language Setting
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.language,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Row(
                          children: [
                            RadioGroup<Locale>(
                              groupValue: locale,
                              onChanged: (value) =>
                                  controller.setLocale(value!),
                              child: Row(
                                children: [
                                  _buildLanguageOption(
                                    context,
                                    const Locale('en'),
                                    l10n.english,
                                    locale,
                                    controller,
                                  ),
                                  const SizedBox(width: 16),
                                  _buildLanguageOption(
                                    context,
                                    const Locale('ar'),
                                    l10n.arabic,
                                    locale,
                                    controller,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Theme Setting
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Theme', style: TextStyle(fontSize: 16)),
                        Row(
                          children: [
                            RadioGroup<ThemeMode>(
                              groupValue: themeMode,
                              onChanged: (value) =>
                                  controller.setThemeMode(value!),
                              child: Row(
                                children: [
                                  _buildThemeOption(
                                    context,
                                    ThemeMode.system,
                                    'System',
                                    themeMode,
                                    controller,
                                  ),
                                  const SizedBox(width: 16),
                                  _buildThemeOption(
                                    context,
                                    ThemeMode.light,
                                    'Light',
                                    themeMode,
                                    controller,
                                  ),
                                  const SizedBox(width: 16),
                                  _buildThemeOption(
                                    context,
                                    ThemeMode.dark,
                                    'Dark',
                                    themeMode,
                                    controller,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // General Section
          _buildSection(
            context,
            title: 'General',
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Start Time of the Day',
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () =>
                          _showDayStartTimeSelector(context, ref, controller),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: Text(
                          _getDayStartTimeText(ref.watch(dayStartTimeProvider)),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Actions Section
          _buildSection(
            context,
            title: 'Actions',
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Default Increment',
                          style: TextStyle(fontSize: 16),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: defaultIncrement > 1
                                    ? () => controller.setDefaultIncrement(
                                        defaultIncrement - 1,
                                      )
                                    : null,
                                icon: const Icon(Icons.remove),
                                iconSize: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              defaultIncrement.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: defaultIncrement < 10
                                    ? () => controller.setDefaultIncrement(
                                        defaultIncrement + 1,
                                      )
                                    : null,
                                icon: const Icon(Icons.add),
                                iconSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Show Notes in Entries',
                          style: TextStyle(fontSize: 16),
                        ),
                        Switch(
                          value: showNotesInList,
                          onChanged: (value) =>
                              controller.setShowNotesInList(value),
                          activeThumbColor: const Color(0xFF38E07B),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Notifications Section
          _buildSection(
            context,
            title: 'Notifications',
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daily Reminder',
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () => _showTimeSelector(context, ref, controller),
                      child: Text(
                        dailyReminderTime ?? '10:00 AM',
                        style: const TextStyle(
                          color: Color(0xFF38E07B),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // About Section
          _buildSection(
            context,
            title: l10n.about,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: const Text('Muhasaba', style: TextStyle(fontSize: 16)),
                subtitle: Text(
                  l10n.appDescription,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                leading: const Icon(Icons.info_outline, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeMode mode,
    String label,
    ThemeMode currentMode,
    SettingsController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.setThemeMode(mode),
      child: Row(
        children: [
          Radio<ThemeMode>(
            value: mode,
            activeColor: Theme.of(context).primaryColor,
          ),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    Locale locale,
    String label,
    Locale currentLocale,
    SettingsController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.setLocale(locale),
      child: Row(
        children: [
          Radio<Locale>(
            value: locale,
            activeColor: Theme.of(context).primaryColor,
          ),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  String _getDayStartTimeText(String timeString) {
    // Convert 24-hour format to 12-hour format with AM/PM
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];

    if (hour == 0) {
      return '12:$minute AM';
    } else if (hour < 12) {
      return '$hour:$minute AM';
    } else if (hour == 12) {
      return '12:$minute PM';
    } else {
      return '${hour - 12}:$minute PM';
    }
  }

  void _showDayStartTimeSelector(
    BuildContext context,
    WidgetRef ref,
    SettingsController controller,
  ) async {
    final currentTime = ref.read(dayStartTimeProvider);
    final parts = currentTime.split(':');
    final currentHour = int.parse(parts[0]);
    final currentMinute = int.parse(parts[1]);

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: currentHour, minute: currentMinute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF38E07B),
              surface: Color(0xFF1E1E1E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      final timeString =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      controller.setDayStartTime(timeString);
    }
  }

  void _showTimeSelector(
    BuildContext context,
    WidgetRef ref,
    SettingsController controller,
  ) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF38E07B),
              surface: Color(0xFF1E1E1E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      final timeString =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      controller.setDailyReminderTime(timeString);
    }
  }
}
