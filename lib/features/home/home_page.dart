import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/date_utils.dart' as date_utils;
import '../../core/theme.dart';
import '../../data/entry_model.dart';
import '../../l10n/generated/app_localizations.dart';
import 'widgets/full_home_page_widget.dart';
import '../settings/settings_controller.dart';
import 'home_controller.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedDay = ref.watch(selectedDayProvider);
    final currentLogicalDay = ref.watch(currentLogicalDayProvider);
    final goodEntries = ref.watch(goodEntriesProvider(selectedDay));
    final badEntries = ref.watch(badEntriesProvider(selectedDay));
    final totals = ref.watch(dayTotalsProvider(selectedDay));
    final showNotesInEntries = ref.watch(showNotesInListProvider);

    // Listen for day start time changes and update selected day if it's "today"
    ref.listen(currentLogicalDayProvider, (previous, next) {
      if (previous != null && previous != next) {
        // If the current selected day was the previous "today", update it to the new "today"
        final currentSelected = ref.read(selectedDayProvider);
        if (date_utils.DateUtils.isSameDay(currentSelected, previous)) {
          ref.read(selectedDayProvider.notifier).state = next;
        }
      }
    });

    return FullHomePageWidget(
      selectedDay: selectedDay,
      currentLogicalDay: currentLogicalDay,
      goodEntries: goodEntries,
      badEntries: badEntries,
      totals: totals,
      showNotesInEntries: showNotesInEntries,
      textController: _textController,
      onPreviousDay: () {
        final previousDay = date_utils.DateUtils.previousDay(selectedDay);
        ref.read(selectedDayProvider.notifier).state = previousDay;
      },
      onNextDay: () {
        final nextDay = date_utils.DateUtils.nextDay(selectedDay);
        if (!nextDay.isAfter(currentLogicalDay)) {
          ref.read(selectedDayProvider.notifier).state = nextDay;
        }
      },
      onDateTap: () => _showDatePicker(context, ref, selectedDay, l10n),
      onSettingsTap: () => Navigator.pushNamed(context, '/settings'),
      onEntryTap: _showDeleteDialog,
      onGoodQuickAdd: () => _addQuickEntry(EntryType.good),
      onBadQuickAdd: () => _addQuickEntry(EntryType.bad),
      onGoodHoldComplete: (score) => _addHoldEntry(EntryType.good, score),
      onBadHoldComplete: (score) => _addHoldEntry(EntryType.bad, score),
      onTextSubmitted: _handleQuickAdd,
    );
  }

  void _handleQuickAdd(String text) {
    if (text.trim().isNotEmpty) {
      final controller = ref.read(homeControllerProvider.notifier);
      final selectedDay = ref.read(selectedDayProvider);
      final defaultIncrement = ref.read(defaultIncrementProvider);
      final dateWithCurrentTime =
          date_utils.DateUtils.combineDateWithCurrentTime(selectedDay);
      controller.addEntry(
        type: EntryType.good,
        score: defaultIncrement,
        note: text.trim(),
        date: dateWithCurrentTime,
      );
      _textController.clear();
    }
  }

  void _addHoldEntry(EntryType type, int score) {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(homeControllerProvider.notifier);
    final selectedDay = ref.read(selectedDayProvider);
    final dateWithCurrentTime = date_utils.DateUtils.combineDateWithCurrentTime(
      selectedDay,
    );
    final text = _textController.text.trim();
    final note = text.isNotEmpty
        ? text
        : (type == EntryType.good
              ? l10n.defaultGoodAction
              : l10n.defaultBadAction);

    controller.addEntry(
      type: type,
      score: score,
      note: note,
      date: dateWithCurrentTime,
    );

    // Clear the text field if it had content
    if (text.isNotEmpty) {
      _textController.clear();
    }
  }

  void _addQuickEntry(EntryType type) {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(homeControllerProvider.notifier);
    final selectedDay = ref.read(selectedDayProvider);
    final defaultIncrement = ref.read(defaultIncrementProvider);
    final dateWithCurrentTime = date_utils.DateUtils.combineDateWithCurrentTime(
      selectedDay,
    );
    final text = _textController.text.trim();
    final note = text.isNotEmpty
        ? text
        : (type == EntryType.good
              ? l10n.defaultGoodAction
              : l10n.defaultBadAction);

    controller.addEntry(
      type: type,
      score: defaultIncrement,
      note: note,
      date: dateWithCurrentTime,
    );

    // Clear the text field if it had content
    if (text.isNotEmpty) {
      _textController.clear();
    }
  }

  void _showDeleteDialog(DayEntry entry) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteEntry),
        content: Text(l10n.deleteEntryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              final controller = ref.read(homeControllerProvider.notifier);
              controller.deleteEntry(entry.id);
              Navigator.of(context).pop();
            },
            child: Text(
              l10n.delete,
              style: const TextStyle(color: AppTheme.badColor),
            ),
          ),
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
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.goodColor,
              onPrimary: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // When picking a date, we want to select the logical day that contains that calendar date
      // So we normalize it as a regular day (the calendar date the user picked)
      ref.read(selectedDayProvider.notifier).state =
          date_utils.DateUtils.normalizeDay(picked);
    }
  }
}
