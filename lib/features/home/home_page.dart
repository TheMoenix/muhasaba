import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/entry_model.dart';
import 'home_controller.dart';
import 'widgets/new_column_card.dart';
import 'widgets/day_header.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final goodEntries = ref.watch(goodEntriesProvider(selectedDay));
    final badEntries = ref.watch(badEntriesProvider(selectedDay));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          // Day header with navigation and summary
          Padding(padding: const EdgeInsets.all(16), child: const DayHeader()),

          // Main content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Use row layout for wider screens, column for narrow
                  if (constraints.maxWidth > 600) {
                    return Row(
                      children: [
                        Expanded(
                          child: NewColumnCard(
                            type: EntryType.good,
                            title: 'Good',
                            entries: goodEntries,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: NewColumnCard(
                            type: EntryType.bad,
                            title: 'Bad',
                            entries: badEntries,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          NewColumnCard(
                            type: EntryType.good,
                            title: 'Good',
                            entries: goodEntries,
                          ),
                          const SizedBox(height: 16),
                          NewColumnCard(
                            type: EntryType.bad,
                            title: 'Bad',
                            entries: badEntries,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
