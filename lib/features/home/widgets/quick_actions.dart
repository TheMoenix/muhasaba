import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/entry_model.dart';
import '../home_controller.dart';

class QuickActions extends ConsumerWidget {
  final EntryType type;

  const QuickActions({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(homeControllerProvider.notifier);
    final selectedDay = ref.watch(selectedDayProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () => controller.addQuickEntry(type),
            icon: const Icon(Icons.add),
            label: const Text('+'),
            style: FilledButton.styleFrom(
              backgroundColor: type == EntryType.good
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.error,
              foregroundColor: type == EntryType.good
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onError,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () =>
                _undoLastQuickEntry(context, ref, controller, selectedDay),
            icon: const Icon(Icons.remove),
            label: const Text('−'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _undoLastQuickEntry(
    BuildContext context,
    WidgetRef ref,
    HomeController controller,
    DateTime selectedDay,
  ) async {
    final success = await controller.undoLastQuickEntry(type, selectedDay);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Last ${type.name} entry removed'
                : 'No quick ${type.name} entry to undo',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
