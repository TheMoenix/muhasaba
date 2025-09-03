import 'dart:async';
import 'package:flutter/material.dart';
import '../../../data/entry_model.dart';

/// A button that supports both quick tap and press-and-hold interactions
class PressAndHoldButton extends StatefulWidget {
  final EntryType type;
  final IconData icon;
  final Color color;
  final VoidCallback onQuickAdd;
  final ValueChanged<int> onHoldComplete;

  const PressAndHoldButton({
    super.key,
    required this.type,
    required this.icon,
    required this.color,
    required this.onQuickAdd,
    required this.onHoldComplete,
  });

  @override
  State<PressAndHoldButton> createState() => _PressAndHoldButtonState();
}

class _PressAndHoldButtonState extends State<PressAndHoldButton>
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
