import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/entry_model.dart';
import 'add_entry_sheet.dart';
import 'entry_tile.dart';
import 'quick_actions.dart';

class ColumnCard extends ConsumerWidget {
  final EntryType type;
  final String title;
  final List<DayEntry> entries;

  const ColumnCard({
    super.key,
    required this.type,
    required this.title,
    required this.entries,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cardColor = type == EntryType.good
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.errorContainer;
    final onCardColor = type == EntryType.good
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onErrorContainer;

    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with title and total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: onCardColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: onCardColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _calculateTotal().toString(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: onCardColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quick actions
            QuickActions(type: type),
            const SizedBox(height: 16),

            // Entries list
            if (entries.isEmpty)
              _buildEmptyState(context, onCardColor)
            else
              ...entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: EntryTile(entry: entry),
                ),
              ),

            const SizedBox(height: 16),

            // Add entry button
            OutlinedButton.icon(
              onPressed: () => _showAddEntrySheet(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Entry'),
              style: OutlinedButton.styleFrom(
                foregroundColor: onCardColor,
                side: BorderSide(color: onCardColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            type == EntryType.good ? Icons.mood : Icons.mood_bad,
            size: 48,
            color: color.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 8),
          Text(
            'No ${type.name} entries yet',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: color.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Tap + to add a quick entry',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  int _calculateTotal() {
    return entries.fold(0, (sum, entry) => sum + entry.score);
  }

  void _showAddEntrySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddEntrySheet(),
    );
  }
}
