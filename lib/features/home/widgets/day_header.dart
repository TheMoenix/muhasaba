import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/date_utils.dart' as date_utils;
import '../home_controller.dart';

class DayHeader extends ConsumerWidget {
  const DayHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final totals = ref.watch(dayTotalsProvider(selectedDay));

    return Row(
      children: [
        IconButton(
          onPressed: () {
            final previousDay = date_utils.DateUtils.previousDay(selectedDay);
            ref.read(selectedDayProvider.notifier).state = previousDay;
          },
          icon: const Icon(Icons.chevron_left),
          tooltip: 'Previous day',
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => _showDatePicker(context, ref, selectedDay),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    date_utils.DateUtils.isToday(selectedDay)
                        ? 'Today'
                        : date_utils.DateUtils.formatDate(selectedDay),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  _buildSummaryChip(context, totals),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            final nextDay = date_utils.DateUtils.nextDay(selectedDay);
            // Don't allow going into the future
            if (!nextDay.isAfter(date_utils.DateUtils.today())) {
              ref.read(selectedDayProvider.notifier).state = nextDay;
            }
          },
          icon: const Icon(Icons.chevron_right),
          tooltip: 'Next day',
        ),
        if (!date_utils.DateUtils.isToday(selectedDay))
          TextButton(
            onPressed: () {
              ref.read(selectedDayProvider.notifier).state =
                  date_utils.DateUtils.today();
            },
            child: const Text('Today'),
          ),
      ],
    );
  }

  Widget _buildSummaryChip(
    BuildContext context,
    ({int good, int bad, int net}) totals,
  ) {
    final theme = Theme.of(context);
    final netColor = totals.net > 0
        ? theme.colorScheme.primary
        : totals.net < 0
        ? theme.colorScheme.error
        : theme.colorScheme.onSurfaceVariant;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Good ${totals.good}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(' | ', style: theme.textTheme.bodySmall),
        Text(
          'Bad ${totals.bad}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(' | ', style: theme.textTheme.bodySmall),
        Text(
          'Net ${totals.net >= 0 ? '+' : ''}${totals.net}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: netColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Future<void> _showDatePicker(
    BuildContext context,
    WidgetRef ref,
    DateTime selectedDay,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'Select date',
    );

    if (picked != null) {
      ref.read(selectedDayProvider.notifier).state =
          date_utils.DateUtils.normalizeDay(picked);
    }
  }
}
