import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/date_utils.dart' as date_utils;
import '../../../core/theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../home_controller.dart';

class DayHeader extends ConsumerWidget {
  const DayHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedDay = ref.watch(selectedDayProvider);
    final totals = ref.watch(dayTotalsProvider(selectedDay));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Settings button
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            icon: const Icon(Icons.settings),
            iconSize: 24,
          ),

          // Date navigation and summary
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        final previousDay = date_utils.DateUtils.previousDay(
                          selectedDay,
                        );
                        ref.read(selectedDayProvider.notifier).state =
                            previousDay;
                      },
                      icon: const Icon(Icons.chevron_left),
                      iconSize: 24,
                    ),

                    // Today button with dropdown arrow
                    GestureDetector(
                      onTap: () =>
                          _showDatePicker(context, ref, selectedDay, l10n),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              date_utils.DateUtils.isToday(selectedDay)
                                  ? l10n.today
                                  : date_utils.DateUtils.formatDate(
                                      selectedDay,
                                    ),
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.expand_more,
                              color: AppTheme.textPrimary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        final nextDay = date_utils.DateUtils.nextDay(
                          selectedDay,
                        );
                        // Don't allow going into the future
                        if (!nextDay.isAfter(date_utils.DateUtils.today())) {
                          ref.read(selectedDayProvider.notifier).state =
                              nextDay;
                        }
                      },
                      icon: Icon(
                        Icons.chevron_right,
                        color:
                            date_utils.DateUtils.nextDay(
                              selectedDay,
                            ).isAfter(date_utils.DateUtils.today())
                            ? AppTheme.textSecondary
                            : AppTheme.textPrimary,
                      ),
                      iconSize: 24,
                    ),
                  ],
                ),

                // Net score
                Text(
                  l10n.net('${totals.net >= 0 ? '' : ''}${totals.net}'),
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Spacer to balance the settings button
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Future<void> _showDatePicker(
    BuildContext context,
    WidgetRef ref,
    DateTime selectedDay,
    AppLocalizations l10n,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: l10n.selectDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.goodColor,
              onPrimary: Colors.black,
              surface: AppTheme.cardBackground,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(selectedDayProvider.notifier).state =
          date_utils.DateUtils.normalizeDay(picked);
    }
  }
}
