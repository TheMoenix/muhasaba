import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/entry_model.dart';
import '../home_controller.dart';

class AddEntrySheet extends ConsumerStatefulWidget {
  final DayEntry? entryToEdit;

  const AddEntrySheet({super.key, this.entryToEdit});

  @override
  ConsumerState<AddEntrySheet> createState() => _AddEntrySheetState();
}

class _AddEntrySheetState extends ConsumerState<AddEntrySheet> {
  late EntryType _selectedType;
  late int _score;
  late TextEditingController _noteController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedType = widget.entryToEdit?.type ?? EntryType.good;
    _score = widget.entryToEdit?.score ?? 1;
    _noteController = TextEditingController(
      text: widget.entryToEdit?.note ?? '',
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.entryToEdit != null ? 'Edit Entry' : 'Add Entry',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Type selector
              Text('Type', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              SegmentedButton<EntryType>(
                segments: const [
                  ButtonSegment(
                    value: EntryType.good,
                    label: Text('Good'),
                    icon: Icon(Icons.thumb_up),
                  ),
                  ButtonSegment(
                    value: EntryType.bad,
                    label: Text('Bad'),
                    icon: Icon(Icons.thumb_down),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (Set<EntryType> selection) {
                  setState(() {
                    _selectedType = selection.first;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Score selector
              Text('Score', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: _score > 1
                        ? () => setState(() => _score--)
                        : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.outline),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _score.toString(),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _score < 100
                        ? () => setState(() => _score++)
                        : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Note field
              Text('Note (optional)', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  hintText: 'Add a note...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                maxLength: 200,
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: _saveEntry,
                      child: Text(
                        widget.entryToEdit != null ? 'Update' : 'Save',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveEntry() {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(homeControllerProvider.notifier);
    final selectedDay = ref.read(selectedDayProvider);

    final note = _noteController.text.trim();

    if (widget.entryToEdit != null) {
      // Update existing entry
      final updatedEntry = widget.entryToEdit!
        ..type = _selectedType
        ..score = _score
        ..note = note.isEmpty ? null : note;
      controller.updateEntry(updatedEntry);
    } else {
      // Add new entry
      controller.addEntry(
        type: _selectedType,
        score: _score,
        note: note.isEmpty ? null : note,
        date: selectedDay,
      );
    }

    Navigator.of(context).pop();
  }
}
