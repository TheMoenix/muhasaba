import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/entry_model.dart';
import 'actions_list_widget.dart';
import 'add_action_widget.dart';
import 'date_and_scores_widget.dart';
import 'score_totals_widget.dart';

/// Complete home page widget that combines all home screen components
class FullHomePageWidget extends ConsumerWidget {
  final DateTime selectedDay;
  final DateTime currentLogicalDay;
  final List<DayEntry> goodEntries;
  final List<DayEntry> badEntries;
  final ({int good, int bad, int net}) totals;
  final bool showNotesInEntries;
  final TextEditingController textController;

  // Navigation callbacks
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final VoidCallback onDateTap;
  final VoidCallback onSettingsTap;

  // Entry management callbacks
  final void Function(DayEntry) onEntryTap;
  final VoidCallback onGoodQuickAdd;
  final VoidCallback onBadQuickAdd;
  final ValueChanged<int> onGoodHoldComplete;
  final ValueChanged<int> onBadHoldComplete;
  final ValueChanged<String> onTextSubmitted;

  const FullHomePageWidget({
    super.key,
    required this.selectedDay,
    required this.currentLogicalDay,
    required this.goodEntries,
    required this.badEntries,
    required this.totals,
    required this.showNotesInEntries,
    required this.textController,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onDateTap,
    required this.onSettingsTap,
    required this.onEntryTap,
    required this.onGoodQuickAdd,
    required this.onBadQuickAdd,
    required this.onGoodHoldComplete,
    required this.onBadHoldComplete,
    required this.onTextSubmitted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          // Header with date navigation
          DateAndScoresWidget(
            selectedDay: selectedDay,
            currentLogicalDay: currentLogicalDay,
            onPreviousDay: onPreviousDay,
            onNextDay: onNextDay,
            onDateTap: onDateTap,
            onSettingsTap: onSettingsTap,
          ),

          // Summary bar with scores
          ScoreTotalsWidget(
            goodScore: totals.good,
            badScore: totals.bad,
            netScore: totals.net,
          ),

          // Main content with actions lists
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Good actions column
                  ActionsListWidget(
                    entries: goodEntries,
                    type: EntryType.good,
                    showNotesInEntries: showNotesInEntries,
                    onEntryTap: onEntryTap,
                  ),
                  const SizedBox(width: 16),
                  // Bad actions column
                  ActionsListWidget(
                    entries: badEntries,
                    type: EntryType.bad,
                    showNotesInEntries: showNotesInEntries,
                    onEntryTap: onEntryTap,
                  ),
                ],
              ),
            ),
          ),

          // Bottom input area
          AddActionWidget(
            textController: textController,
            onGoodQuickAdd: onGoodQuickAdd,
            onBadQuickAdd: onBadQuickAdd,
            onGoodHoldComplete: onGoodHoldComplete,
            onBadHoldComplete: onBadHoldComplete,
            onTextSubmitted: onTextSubmitted,
          ),
        ],
      ),
    );
  }
}
