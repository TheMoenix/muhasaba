import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../../../data/entry_model.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Widget that displays a list of actions (entries) for a specific type
class ActionsListWidget extends ConsumerWidget {
  final List<DayEntry> entries;
  final EntryType type;
  final bool showNotesInEntries;
  final void Function(DayEntry) onEntryTap;

  const ActionsListWidget({
    super.key,
    required this.entries,
    required this.type,
    required this.showNotesInEntries,
    required this.onEntryTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (entries.isNotEmpty) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: entries.asMap().entries.map((entry) {
                        final index = entry.key;
                        final dayEntry = entry.value;
                        final isLast = index == entries.length - 1;

                        return GestureDetector(
                          onTap: () => onEntryTap(dayEntry),
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
                                    child: showNotesInEntries
                                        ? Text(
                                            dayEntry.note ?? '',
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          )
                                        : Text(
                                            _maskText(dayEntry.note ?? ''),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
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
                      }).toList(),
                    ),
                  ),
                ),
              );
            } else {
              return SizedBox(
                height: constraints.maxHeight,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      type == EntryType.good
                          ? l10n.noGoodActionsToday
                          : l10n.noBadActionsToday,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  String _maskText(String text) {
    if (text.isEmpty) return text;
    // Replace each non-whitespace character with a bullet point
    return text.replaceAll(RegExp(r'\S'), '•');
  }
}
