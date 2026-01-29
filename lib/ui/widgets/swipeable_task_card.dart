import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Swipe action configuration
class SwipeAction {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isDestructive;

  const SwipeAction({required this.label, required this.icon, required this.color, required this.onTap, this.isDestructive = false});
}

/// Enhanced swipeable widget for task cards with haptic feedback
class SwipeableTaskCard extends StatefulWidget {
  final Widget child;
  final List<SwipeAction> leftActions;
  final List<SwipeAction> rightActions;
  final double actionWidth;
  final Duration animationDuration;
  final bool enabled;

  const SwipeableTaskCard({super.key, required this.child, this.leftActions = const [], this.rightActions = const [], this.actionWidth = 80.0, this.animationDuration = const Duration(milliseconds: 200), this.enabled = true});

  @override
  State<SwipeableTaskCard> createState() => _SwipeableTaskCardState();
}

class _SwipeableTaskCardState extends State<SwipeableTaskCard> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _actionController;
  late Animation<double> _slideAnimation;
  late Animation<double> _actionAnimation;

  double _dragExtent = 0.0;
  bool _dragUnderway = false;
  bool _hasTriggeredHaptic = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(duration: widget.animationDuration, vsync: this);
    _actionController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _actionAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _actionController, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _slideController.dispose();
    _actionController.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    if (!widget.enabled) return;

    _dragUnderway = true;
    _hasTriggeredHaptic = false;
    _actionController.forward();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!widget.enabled || !_dragUnderway) return;

    final delta = details.primaryDelta ?? 0.0;
    final oldDragExtent = _dragExtent;

    _dragExtent += delta;

    // Limit drag extent based on available actions
    final maxLeftExtent = widget.leftActions.length * widget.actionWidth;
    final maxRightExtent = widget.rightActions.length * widget.actionWidth;

    if (_dragExtent > 0) {
      _dragExtent = _dragExtent.clamp(0.0, maxLeftExtent);
    } else {
      _dragExtent = _dragExtent.clamp(-maxRightExtent, 0.0);
    }

    // Trigger haptic feedback when crossing action threshold
    final actionThreshold = widget.actionWidth * 0.7;
    if (!_hasTriggeredHaptic && _dragExtent.abs() > actionThreshold) {
      HapticFeedback.selectionClick();
      _hasTriggeredHaptic = true;
    } else if (_hasTriggeredHaptic && _dragExtent.abs() < actionThreshold) {
      _hasTriggeredHaptic = false;
    }

    setState(() {
      _slideController.value = (_dragExtent.abs() / widget.actionWidth).clamp(0.0, 1.0);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!widget.enabled || !_dragUnderway) return;

    _dragUnderway = false;
    _actionController.reverse();

    final velocity = details.primaryVelocity ?? 0.0;
    final actionThreshold = widget.actionWidth * 0.7;

    // Determine if action should be triggered
    bool shouldTriggerAction = false;
    SwipeAction? triggeredAction;

    if (_dragExtent > actionThreshold || velocity > 300) {
      // Swipe right - reveals and triggers left side actions
      if (widget.leftActions.isNotEmpty) {
        shouldTriggerAction = true;
        triggeredAction = widget.leftActions.first;
      }
    } else if (_dragExtent < -actionThreshold || velocity < -300) {
      // Swipe left - reveals and triggers right side actions
      if (widget.rightActions.isNotEmpty) {
        shouldTriggerAction = true;
        triggeredAction = widget.rightActions.first;
      }
    }

    if (shouldTriggerAction && triggeredAction != null) {
      _triggerAction(triggeredAction);
    } else {
      _resetPosition();
    }
  }

  void _triggerAction(SwipeAction action) async {
    // Haptic feedback based on action type
    if (action.isDestructive) {
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.heavyImpact();
    } else {
      await HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 50));
      await HapticFeedback.mediumImpact();
    }

    // Animate to full extent, then trigger action
    await _slideController.animateTo(1.0);
    action.onTap();
    _resetPosition();
  }

  void _resetPosition() {
    setState(() {
      _dragExtent = 0.0;
    });
    _slideController.animateTo(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Stack(
        children: [
          // Background actions
          if (widget.leftActions.isNotEmpty || widget.rightActions.isNotEmpty) _buildActionBackground(),

          // Main card content
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Transform.translate(offset: Offset(_dragExtent, 0), child: widget.child);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionBackground() {
    return Positioned.fill(
      child: Row(
        children: [
          // Left actions (shown when swiping right)
          if (widget.leftActions.isNotEmpty)
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: AnimatedBuilder(
                  animation: _actionAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _dragExtent > 0 ? _actionAnimation.value : 0.0,
                      child: Row(mainAxisSize: MainAxisSize.min, children: widget.leftActions.map((action) => _buildActionButton(action)).toList()),
                    );
                  },
                ),
              ),
            ),

          // Right actions (shown when swiping left)
          if (widget.rightActions.isNotEmpty)
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: AnimatedBuilder(
                  animation: _actionAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _dragExtent < 0 ? _actionAnimation.value : 0.0,
                      child: Row(mainAxisSize: MainAxisSize.min, children: widget.rightActions.map((action) => _buildActionButton(action)).toList()),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(SwipeAction action) {
    return Container(
      width: widget.actionWidth,
      height: double.infinity,
      decoration: BoxDecoration(color: action.color, borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            action.onTap();
            _resetPosition();
          },
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action.icon, color: Colors.white, size: 24),
              const SizedBox(height: 4),
              Text(
                action.label,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Extension to easily wrap any widget with swipe functionality
extension SwipeableWidget on Widget {
  Widget swipeable({List<SwipeAction> leftActions = const [], List<SwipeAction> rightActions = const [], double actionWidth = 80.0, Duration animationDuration = const Duration(milliseconds: 200), bool enabled = true}) {
    return SwipeableTaskCard(leftActions: leftActions, rightActions: rightActions, actionWidth: actionWidth, animationDuration: animationDuration, enabled: enabled, child: this);
  }
}
