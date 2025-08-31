import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/date_utils.dart' as date_utils;
import '../../core/theme.dart';
import '../../data/entry_model.dart';
import '../../l10n/generated/app_localizations.dart';
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
    final goodEntries = ref.watch(goodEntriesProvider(selectedDay));
    final badEntries = ref.watch(badEntriesProvider(selectedDay));
    final totals = ref.watch(dayTotalsProvider(selectedDay));

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Column(
        children: [
          // Header
          Container(
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
                      onPressed: () =>
                          Navigator.pushNamed(context, '/settings'),
                      icon: const Icon(Icons.settings, color: Colors.white),
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
                          onPressed: () {
                            final previousDay =
                                date_utils.DateUtils.previousDay(selectedDay);
                            ref.read(selectedDayProvider.notifier).state =
                                previousDay;
                          },
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            _showDatePicker(context, ref, selectedDay, l10n),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Text(
                            date_utils.DateUtils.isToday(selectedDay)
                                ? l10n.today
                                : date_utils.DateUtils.formatDate(selectedDay),
                            style: const TextStyle(
                              color: Colors.white,
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
                            final nextDay = date_utils.DateUtils.nextDay(
                              selectedDay,
                            );
                            if (!nextDay.isAfter(
                              date_utils.DateUtils.today(),
                            )) {
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
                                ? Colors.white.withOpacity(0.3)
                                : Colors.white,
                          ),
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
          ),

          // Summary bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${l10n.good}: ${totals.good}',
                  style: const TextStyle(
                    color: AppTheme.goodColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  ' | ',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
                Text(
                  l10n.net(totals.net.toString()),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  ' | ',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${l10n.bad}: ${totals.bad}',
                  style: const TextStyle(
                    color: AppTheme.badColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First column (good in LTR, bad in RTL)
                  Expanded(
                    child: _buildEntriesColumn(
                      entries: goodEntries,
                      type: EntryType.good,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Second column (bad in LTR, good in RTL)
                  Expanded(
                    child: _buildEntriesColumn(
                      entries: badEntries,
                      type: EntryType.bad,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom input footer
          Container(
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              top: false,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    // Add button
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => _addQuickEntry(EntryType.good),
                        icon: const Icon(
                          Icons.add_circle,
                          color: AppTheme.goodColor,
                          size: 28,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    // Input field
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: 'Add action...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        onSubmitted: (value) => _handleQuickAdd(value),
                      ),
                    ),
                    // Remove button
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => _addQuickEntry(EntryType.bad),
                        icon: const Icon(
                          Icons.remove_circle,
                          color: AppTheme.badColor,
                          size: 28,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesColumn({
    required List<DayEntry> entries,
    required EntryType type,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          if (entries.isNotEmpty)
            ...entries.asMap().entries.map((entry) {
              final index = entry.key;
              final dayEntry = entry.value;
              final isLast = index == entries.length - 1;

              return GestureDetector(
                onTap: () => _showDeleteDialog(dayEntry),
                child: Container(
                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : const Border(
                            bottom: BorderSide(
                              color: Color(0xFF2A2A2E),
                              width: 1,
                            ),
                          ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            dayEntry.note ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          type == EntryType.good
                              ? '+${dayEntry.score}'
                              : '-${dayEntry.score}',
                          style: TextStyle(
                            color: type == EntryType.good
                                ? AppTheme.goodColor
                                : AppTheme.badColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })
          else
            Container(
              padding: const EdgeInsets.all(32),
              child: Text(
                type == EntryType.good
                    ? 'No good actions today'
                    : 'No bad actions today',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  void _handleQuickAdd(String text) {
    if (text.trim().isNotEmpty) {
      final controller = ref.read(homeControllerProvider.notifier);
      controller.addEntry(type: EntryType.good, score: 1, note: text.trim());
      _textController.clear();
    }
  }

  void _addQuickEntry(EntryType type) {
    final controller = ref.read(homeControllerProvider.notifier);
    final text = _textController.text.trim();
    final note = text.isNotEmpty
        ? text
        : (type == EntryType.good ? 'Good action' : 'Bad action');

    controller.addEntry(type: type, score: 1, note: note);

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
        backgroundColor: AppTheme.cardBackground,
        title: Text(
          l10n.deleteEntry,
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          l10n.deleteEntryConfirm,
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
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
