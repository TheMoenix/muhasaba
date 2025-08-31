import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/entry_model.dart';
import '../../settings/settings_controller.dart';
import '../home_controller.dart';
import 'add_entry_sheet.dart';

class EntryTile extends ConsumerWidget {
  final DayEntry entry;

  const EntryTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showNotes = ref.watch(showNotesInListProvider);
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: theme.colorScheme.errorContainer,
        child: Icon(Icons.delete, color: theme.colorScheme.onErrorContainer),
      ),
      confirmDismiss: (direction) => _confirmDelete(context),
      onDismissed: (direction) => _deleteEntry(context, ref),
      child: Card(
        child: ListTile(
          onTap: () => _editEntry(context, ref),
          leading: CircleAvatar(
            backgroundColor: entry.type == EntryType.good
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.errorContainer,
            foregroundColor: entry.type == EntryType.good
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onErrorContainer,
            child: Text(
              entry.score.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          title: showNotes && entry.note != null && entry.note!.isNotEmpty
              ? Text(entry.note!, maxLines: 2, overflow: TextOverflow.ellipsis)
              : null,
          subtitle: showNotes && entry.note != null && entry.note!.isNotEmpty
              ? Text(
                  '${entry.type == EntryType.good ? 'Good' : 'Bad'} • ${_formatTime(entry.date)}',
                  style: theme.textTheme.bodySmall,
                )
              : Text(
                  '${entry.type == EntryType.good ? 'Good' : 'Bad'} • ${_formatTime(entry.date)}',
                ),
          trailing: const Icon(Icons.edit),
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteEntry(BuildContext context, WidgetRef ref) {
    final controller = ref.read(homeControllerProvider.notifier);
    controller.deleteEntry(entry.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Entry deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Re-add the entry
            controller.addEntry(
              type: entry.type,
              score: entry.score,
              note: entry.note,
              date: entry.date,
            );
          },
        ),
      ),
    );
  }

  void _editEntry(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddEntrySheet(entryToEdit: entry),
    );
  }
}
