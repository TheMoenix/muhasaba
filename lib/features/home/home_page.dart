import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/entry_model.dart';
import '../settings/settings_page.dart';
import 'home_controller.dart';
import 'widgets/column_card.dart';
import 'widgets/day_header.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final goodEntries = ref.watch(goodEntriesProvider(selectedDay));
    final badEntries = ref.watch(badEntriesProvider(selectedDay));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Muhasaba'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
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
                          child: ColumnCard(
                            type: EntryType.good,
                            title: 'Good',
                            entries: goodEntries,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ColumnCard(
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
                          ColumnCard(
                            type: EntryType.good,
                            title: 'Good',
                            entries: goodEntries,
                          ),
                          const SizedBox(height: 16),
                          ColumnCard(
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
