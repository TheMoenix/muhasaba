import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../../../data/entry_model.dart';
import '../home_controller.dart';
import 'add_entry_sheet.dart';
import 'new_entry_tile.dart';

class NewColumnCard extends ConsumerStatefulWidget {
  final EntryType type;
  final String title;
  final List<DayEntry> entries;

  const NewColumnCard({
    super.key,
    required this.type,
    required this.title,
    required this.entries,
  });

  @override
  ConsumerState<NewColumnCard> createState() => _NewColumnCardState();
}

class _NewColumnCardState extends ConsumerState<NewColumnCard> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = widget.type == EntryType.good
        ? AppTheme.goodColor
        : AppTheme.badColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and total
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: cardColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _calculateTotal().toString(),
                  style: TextStyle(
                    color: cardColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Entries list
          if (widget.entries.isNotEmpty)
            ...widget.entries.map((entry) => NewEntryTile(entry: entry)),

          // Add entry input
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.borderColor, width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _textController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Add a ${widget.type.name} action...',
                  hintStyle: const TextStyle(color: AppTheme.textSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => _handleAddEntry(),
                    icon: Icon(Icons.add_circle, color: cardColor, size: 24),
                  ),
                ),
                onSubmitted: (value) => _handleAddEntry(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateTotal() {
    return widget.entries.fold(0, (sum, entry) => sum + entry.score);
  }

  void _handleAddEntry() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      // Add quick entry with note
      final controller = ref.read(homeControllerProvider.notifier);
      controller.addEntry(
        type: widget.type,
        score: 1, // Default score for quick entry
        note: text,
      );
      _textController.clear();
    } else {
      // Show detailed entry sheet
      _showAddEntrySheet(context);
    }
  }

  void _showAddEntrySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddEntrySheet(),
    );
  }
}
