import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/date_utils.dart' as date_utils;
import '../../../l10n/generated/app_localizations.dart';

/// Widget that displays date navigation and settings button
class DateAndScoresWidget extends ConsumerWidget {
  final DateTime selectedDay;
  final DateTime currentLogicalDay;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final VoidCallback onDateTap;
  final VoidCallback onSettingsTap;

  const DateAndScoresWidget({
    super.key,
    required this.selectedDay,
    required this.currentLogicalDay,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onDateTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Settings button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                onPressed: onSettingsTap,
                icon: const Icon(Icons.settings),
                iconSize: 20,
                padding: EdgeInsets.zero,
              ),
            ),

            // Navigation and Today button
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: onPreviousDay,
                    icon: const Icon(Icons.chevron_left),
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                  ),
                ),
                GestureDetector(
                  onTap: onDateTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Text(
                      date_utils.DateUtils.isSameDay(
                            selectedDay,
                            currentLogicalDay,
                          )
                          ? l10n.today
                          : DateFormat(
                              l10n.dateFormatShort,
                              l10n.localeName,
                            ).format(selectedDay),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: () {
                      final nextDay = date_utils.DateUtils.nextDay(selectedDay);
                      if (!nextDay.isAfter(currentLogicalDay)) {
                        onNextDay();
                      }
                    },
                    icon: const Icon(Icons.chevron_right),
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),

            // Spacer for balance
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }
}
