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
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        title: Text(
          l10n.settings,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Appearance Section
          _buildSection(
            title: l10n.appearance,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            _buildLanguageOption(
                              const Locale('en'),
                              l10n.english,
                              locale,
                              controller,
                            ),
                            const SizedBox(width: 16),
                            _buildLanguageOption(
                              const Locale('ar'),
                              l10n.arabic,
                              locale,
                              controller,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Color(0xFF424242), height: 1),
                  // Theme Setting
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Theme',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Row(
                          children: [
                            _buildThemeOption(
                              ThemeMode.system,
                              'System',
                              themeMode,
                              controller,
                            ),
                            const SizedBox(width: 16),
                            _buildThemeOption(
                              ThemeMode.light,
                              'Light',
                              themeMode,
                              controller,
                            ),
                            const SizedBox(width: 16),
                            _buildThemeOption(
                              ThemeMode.dark,
                              'Dark',
                              themeMode,
                              controller,
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
            title: 'General',
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Start Time of the Day',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
                          color: const Color(0xFF2C2C2C),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF424242)),
                        ),
                        child: Text(
                          _getDayStartTimeText(ref.watch(dayStartTimeProvider)),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
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
            title: 'Actions',
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
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
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF2C2C2C),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: defaultIncrement > 1
                                    ? () => controller.setDefaultIncrement(
                                        defaultIncrement - 1,
                                      )
                                    : null,
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                                iconSize: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              defaultIncrement.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF2C2C2C),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: defaultIncrement < 10
                                    ? () => controller.setDefaultIncrement(
                                        defaultIncrement + 1,
                                      )
                                    : null,
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                iconSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Color(0xFF424242), height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Show Notes in Entries',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Switch(
                          value: showNotesInList,
                          onChanged: (value) =>
                              controller.setShowNotesInList(value),
                          activeColor: const Color(0xFF38E07B),
                          inactiveTrackColor: const Color(0xFF2C2C2C),
                          inactiveThumbColor: Colors.white,
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
            title: 'Notifications',
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daily Reminder',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
            title: l10n.about,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: const Text(
                  'Muhasaba',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
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

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF9E9E9E),
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
            groupValue: currentMode,
            onChanged: (value) => controller.setThemeMode(value!),
            activeColor: const Color(0xFF38E07B),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
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
            groupValue: currentLocale,
            onChanged: (value) => controller.setLocale(value!),
            activeColor: const Color(0xFF38E07B),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
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
