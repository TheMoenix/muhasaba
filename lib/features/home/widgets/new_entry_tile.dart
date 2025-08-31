import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../../../data/entry_model.dart';
import 'add_entry_sheet.dart';

class NewEntryTile extends ConsumerWidget {
  final DayEntry entry;

  const NewEntryTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreColor = entry.type == EntryType.good
        ? AppTheme.goodColor
        : AppTheme.badColor;
    final scorePrefix = entry.type == EntryType.good ? '+' : '-';

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: InkWell(
        onTap: () => _editEntry(context, ref),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Entry text/note
              Expanded(
                child: Text(
                  entry.note?.isNotEmpty == true
                      ? entry.note!
                      : '${entry.type.name.substring(0, 1).toUpperCase()}${entry.type.name.substring(1)} action',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Score
              Text(
                '$scorePrefix${entry.score}',
                style: TextStyle(
                  color: scoreColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editEntry(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEntrySheet(entryToEdit: entry),
    );
  }
}
