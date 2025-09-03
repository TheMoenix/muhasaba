import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Widget that displays Good, Net, and Bad scores in a horizontal row
class ScoreTotalsWidget extends StatelessWidget {
  final int goodScore;
  final int badScore;
  final int netScore;

  const ScoreTotalsWidget({
    super.key,
    required this.goodScore,
    required this.badScore,
    required this.netScore,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${l10n.good}: $goodScore',
            style: const TextStyle(
              color: AppTheme.goodColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Text(' | ', style: TextStyle(fontSize: 14)),
          Text(
            l10n.net(netScore.toString()),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const Text(' | ', style: TextStyle(fontSize: 14)),
          Text(
            '${l10n.bad}: $badScore',
            style: const TextStyle(
              color: AppTheme.badColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
