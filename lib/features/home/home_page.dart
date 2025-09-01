import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/date_utils.dart' as date_utils;
import '../../core/theme.dart';
import '../../data/entry_model.dart';
import '../../l10n/generated/app_localizations.dart';
import '../settings/settings_controller.dart';
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
    final currentLogicalDay = ref.watch(currentLogicalDayProvider);
    final goodEntries = ref.watch(goodEntriesProvider(selectedDay));
    final badEntries = ref.watch(badEntriesProvider(selectedDay));
    final totals = ref.watch(dayTotalsProvider(selectedDay));

    // Listen for day start time changes and update selected day if it's "today"
    ref.listen(currentLogicalDayProvider, (previous, next) {
      if (previous != null && previous != next) {
        // If the current selected day was the previous "today", update it to the new "today"
        final currentSelected = ref.read(selectedDayProvider);
        if (date_utils.DateUtils.isSameDay(currentSelected, previous)) {
          ref.read(selectedDayProvider.notifier).state = next;
        }
      }
    });

    return Scaffold(
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
                      icon: const Icon(Icons.settings),
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
                          icon: const Icon(Icons.chevron_left),
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
                            date_utils.DateUtils.isSameDay(
                                  selectedDay,
                                  currentLogicalDay,
                                )
                                ? l10n.today
                                : DateFormat(
                                    l10n.dateFormatShort,
                                    l10n.localeName,
                                  ).format(selectedDay),
                            style: const TextStyle(
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
                            if (!nextDay.isAfter(currentLogicalDay)) {
                              ref.read(selectedDayProvider.notifier).state =
                                  nextDay;
                            }
                          },
                          icon: Icon(Icons.chevron_right),
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
                Text(' | ', style: TextStyle(fontSize: 14)),
                Text(
                  l10n.net(totals.net.toString()),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(' | ', style: TextStyle(fontSize: 14)),
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
                      l10n: l10n,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Second column (bad in LTR, good in RTL)
                  Expanded(
                    child: _buildEntriesColumn(
                      entries: badEntries,
                      type: EntryType.bad,
                      l10n: l10n,
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
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    // Add button
                    _PressAndHoldButton(
                      type: EntryType.good,
                      icon: Icons.add_circle,
                      color: AppTheme.goodColor,
                      onQuickAdd: () => _addQuickEntry(EntryType.good),
                      onHoldComplete: (score) =>
                          _addHoldEntry(EntryType.good, score),
                    ),
                    // Input field
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: l10n.addActionPlaceholder,
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                        onSubmitted: (value) => _handleQuickAdd(value),
                      ),
                    ),
                    // Remove button
                    _PressAndHoldButton(
                      type: EntryType.bad,
                      icon: Icons.remove_circle,
                      color: AppTheme.badColor,
                      onQuickAdd: () => _addQuickEntry(EntryType.bad),
                      onHoldComplete: (score) =>
                          _addHoldEntry(EntryType.bad, score),
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
    required AppLocalizations l10n,
  }) {
    final showNotesInEntries = ref.watch(showNotesInListProvider);

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
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: entries.asMap().entries.map((entry) {
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
                                    child: showNotesInEntries
                                        ? Text(
                                            dayEntry.note ?? '',
                                            style: const TextStyle(fontSize: 16),
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
                      style: TextStyle(fontSize: 14),
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

  void _handleQuickAdd(String text) {
    if (text.trim().isNotEmpty) {
      final controller = ref.read(homeControllerProvider.notifier);
      final selectedDay = ref.read(selectedDayProvider);
      final defaultIncrement = ref.read(defaultIncrementProvider);
      final dateWithCurrentTime =
          date_utils.DateUtils.combineDateWithCurrentTime(selectedDay);
      controller.addEntry(
        type: EntryType.good,
        score: defaultIncrement,
        note: text.trim(),
        date: dateWithCurrentTime,
      );
      _textController.clear();
    }
  }

  void _addHoldEntry(EntryType type, int score) {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(homeControllerProvider.notifier);
    final selectedDay = ref.read(selectedDayProvider);
    final dateWithCurrentTime = date_utils.DateUtils.combineDateWithCurrentTime(
      selectedDay,
    );
    final note = type == EntryType.good
        ? l10n.defaultGoodAction
        : l10n.defaultBadAction;

    controller.addEntry(
      type: type,
      score: score,
      note: note,
      date: dateWithCurrentTime,
    );
  }

  void _addQuickEntry(EntryType type) {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(homeControllerProvider.notifier);
    final selectedDay = ref.read(selectedDayProvider);
    final defaultIncrement = ref.read(defaultIncrementProvider);
    final dateWithCurrentTime = date_utils.DateUtils.combineDateWithCurrentTime(
      selectedDay,
    );
    final text = _textController.text.trim();
    final note = text.isNotEmpty
        ? text
        : (type == EntryType.good
              ? l10n.defaultGoodAction
              : l10n.defaultBadAction);

    controller.addEntry(
      type: type,
      score: defaultIncrement,
      note: note,
      date: dateWithCurrentTime,
    );

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
        title: Text(l10n.deleteEntry),
        content: Text(l10n.deleteEntryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
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
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.goodColor,
              onPrimary: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // When picking a date, we want to select the logical day that contains that calendar date
      // So we normalize it as a regular day (the calendar date the user picked)
      ref.read(selectedDayProvider.notifier).state =
          date_utils.DateUtils.normalizeDay(picked);
    }
  }
}

class _PressAndHoldButton extends StatefulWidget {
  final EntryType type;
  final IconData icon;
  final Color color;
  final VoidCallback onQuickAdd;
  final ValueChanged<int> onHoldComplete;

  const _PressAndHoldButton({
    required this.type,
    required this.icon,
    required this.color,
    required this.onQuickAdd,
    required this.onHoldComplete,
  });

  @override
  State<_PressAndHoldButton> createState() => _PressAndHoldButtonState();
}

class _PressAndHoldButtonState extends State<_PressAndHoldButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  Timer? _holdTimer;
  int _currentScore = 1;
  bool _isHolding = false;
  bool _isDraggingOff = false;
  int _incrementCount = 0;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    _holdTimer?.cancel();
    super.dispose();
  }

  void _startHold() {
    setState(() {
      _isHolding = true;
      _currentScore = 1;
      _isDraggingOff = false;
      _incrementCount = 0;
    });

    _scaleController.forward();
    _updatePulseSpeed();

    // Start the accelerating increment system
    _scheduleNextIncrement();
  }

  void _updatePulseSpeed() {
    if (!_isHolding) return;

    // Calculate pulse duration based on increment count (matching increment delays)
    int pulseDuration;
    if (_incrementCount < 1) {
      pulseDuration = 1000; // First second: slow pulse
    } else if (_incrementCount < 3) {
      pulseDuration = 500; // Second second: medium pulse
    } else if (_incrementCount < 7) {
      pulseDuration = 250; // Third second: faster pulse
    } else {
      pulseDuration =
          300; // Fourth second and beyond: fast pulse (capped for visual comfort)
    }

    _pulseController.stop();
    _pulseController.duration = Duration(milliseconds: pulseDuration);
    _pulseController.repeat(reverse: true);
  }

  void _scheduleNextIncrement() {
    if (!_isHolding || _isDraggingOff) return;

    // Calculate delay based on increment count
    int delay;
    if (_incrementCount < 1) {
      delay = 1000; // First second: 1000ms
    } else if (_incrementCount < 3) {
      delay = 500; // Second second: 500ms
    } else if (_incrementCount < 7) {
      delay = 250; // Third second: 250ms
    } else {
      delay = 120; // Fourth second and beyond: 120ms
    }

    _holdTimer = Timer(Duration(milliseconds: delay), () {
      if (_isHolding && !_isDraggingOff) {
        setState(() {
          _currentScore++;
          _incrementCount++;
        });
        // Update pulse speed for next phase
        _updatePulseSpeed();
        // Schedule the next increment
        _scheduleNextIncrement();
      }
    });
  }

  void _endHold() {
    _holdTimer?.cancel();
    _scaleController.reverse();
    _pulseController.stop();
    _pulseController.reset();

    if (_isHolding && !_isDraggingOff) {
      // Submit the entry with the final score
      widget.onHoldComplete(_currentScore);
    }

    setState(() {
      _isHolding = false;
      _isDraggingOff = false;
      _currentScore = 1;
      _incrementCount = 0;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_isHolding) {
      // Check if finger has moved outside the button bounds
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final localPosition = renderBox.globalToLocal(details.globalPosition);
      final size = renderBox.size;

      final isOutside =
          localPosition.dx < 0 ||
          localPosition.dx > size.width ||
          localPosition.dy < 0 ||
          localPosition.dy > size.height;

      setState(() {
        _isDraggingOff = isOutside;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isHolding ? null : widget.onQuickAdd,
      onLongPressStart: (_) => _startHold(),
      onLongPressEnd: (_) => _endHold(),
      onPanUpdate: _handlePanUpdate,
      onPanEnd: (_) => _endHold(),
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
        builder: (context, child) {
          double scale = _scaleAnimation.value;
          if (_isHolding && _pulseController.isAnimating) {
            scale *= _pulseAnimation.value;
          }

          return Transform.scale(
            scale: scale,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _isDraggingOff
                    ? Colors.grey.withValues(alpha: 0.3)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: _isHolding && !_isDraggingOff
                    ? Border.all(color: widget.color, width: 2)
                    : null,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(
                    widget.icon,
                    color: _isDraggingOff ? Colors.grey : widget.color,
                    size: 28,
                  ),
                  if (_isHolding && !_isDraggingOff)
                    Positioned(
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: widget.color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.type == EntryType.good
                              ? '+$_currentScore'
                              : '-$_currentScore',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
