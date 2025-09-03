import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../data/entry_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'press_and_hold_button.dart';

/// Widget that contains the text input field and add/remove buttons
class AddActionWidget extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onGoodQuickAdd;
  final VoidCallback onBadQuickAdd;
  final ValueChanged<int> onGoodHoldComplete;
  final ValueChanged<int> onBadHoldComplete;
  final ValueChanged<String> onTextSubmitted;

  const AddActionWidget({
    super.key,
    required this.textController,
    required this.onGoodQuickAdd,
    required this.onBadQuickAdd,
    required this.onGoodHoldComplete,
    required this.onBadHoldComplete,
    required this.onTextSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              // Add button
              PressAndHoldButton(
                type: EntryType.good,
                icon: Icons.add_circle,
                color: AppTheme.goodColor,
                onQuickAdd: onGoodQuickAdd,
                onHoldComplete: onGoodHoldComplete,
              ),
              // Input field
              Expanded(
                child: TextField(
                  controller: textController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: l10n.addActionPlaceholder,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onSubmitted: onTextSubmitted,
                ),
              ),
              // Remove button
              PressAndHoldButton(
                type: EntryType.bad,
                icon: Icons.remove_circle,
                color: AppTheme.badColor,
                onQuickAdd: onBadQuickAdd,
                onHoldComplete: onBadHoldComplete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
