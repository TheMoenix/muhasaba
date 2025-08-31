import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/entry_model.dart';
import '../../l10n/generated/app_localizations.dart';
import 'home_controller.dart';
import 'widgets/new_column_card.dart';
import 'widgets/day_header.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedDay = ref.watch(selectedDayProvider);
    final goodEntries = ref.watch(goodEntriesProvider(selectedDay));
    final badEntries = ref.watch(badEntriesProvider(selectedDay));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const DayHeader(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: NewColumnCard(
                    type: EntryType.good,
                    title: l10n.good,
                    entries: goodEntries,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: NewColumnCard(
                    type: EntryType.bad,
                    title: l10n.bad,
                    entries: badEntries,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
