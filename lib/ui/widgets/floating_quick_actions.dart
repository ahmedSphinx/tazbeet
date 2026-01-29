import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/ui/themes/design_system.dart';

/// Quick action item configuration
class QuickAction {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isEnabled;
  final String? tooltip;

  const QuickAction({required this.id, required this.label, required this.icon, required this.color, required this.onTap, this.isEnabled = true, this.tooltip});
}

/// Floating quick actions menu with smooth animations
class FloatingQuickActionsMenu extends StatefulWidget {
  final List<QuickAction> actions;
  final Widget child;
  final bool isVisible;
  final Duration animationDuration;
  final double spacing;
  final Alignment alignment;
  final bool useStandardFabPosition;

  const FloatingQuickActionsMenu({super.key, required this.actions, required this.child, this.isVisible = true, this.animationDuration = const Duration(milliseconds: 300), this.spacing = 16.0, this.alignment = Alignment.bottomRight, this.useStandardFabPosition = false});

  @override
  State<FloatingQuickActionsMenu> createState() => _FloatingQuickActionsMenuState();
}

class _FloatingQuickActionsMenuState extends State<FloatingQuickActionsMenu> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _staggerController;
  late Animation<double> _fabAnimation;
  late Animation<double> _backgroundAnimation;
  late List<Animation<double>> _actionAnimations;

  bool _isOpen = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.animationDuration, vsync: this);

    _staggerController = AnimationController(
      duration: Duration(milliseconds: widget.animationDuration.inMilliseconds + 200),
      vsync: this,
    );

    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Create staggered animations for each action
    _actionAnimations = List.generate(widget.actions.length, (index) {
      final delay = index * 0.1;
      final end = (delay + 0.6).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(delay.clamp(0.0, 1.0), end, curve: Curves.elasticOut),
        ),
      );
    });
  }

  @override
  void didUpdateWidget(FloatingQuickActionsMenu oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update animations if the number of actions changed
    if (oldWidget.actions.length != widget.actions.length) {
      _actionAnimations = List.generate(widget.actions.length, (index) {
        final delay = index * 0.1;
        final end = (delay + 0.6).clamp(0.0, 1.0);
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: Interval(delay.clamp(0.0, 1.0), end, curve: Curves.elasticOut),
          ),
        );
      });
    }
  }

  void _toggle() {
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    if (!_isOpen) {
      setState(() => _isOpen = true);
      HapticFeedback.lightImpact();
      _controller.forward();
      _staggerController.forward();
    }
  }

  void _close() {
    if (_isOpen) {
      setState(() => _isOpen = false);
      HapticFeedback.lightImpact();
      _staggerController.reverse();
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return widget.child;
    }

    return Scaffold(
      body: Material(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // Background overlay with proper blocking
              AnimatedBuilder(
                animation: _backgroundAnimation,
                builder: (context, child) {
                  return _backgroundAnimation.value > 0
                      ? GestureDetector(
                          onTap: _close,
                          behavior: HitTestBehavior.opaque, // Ensure it blocks touches
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.5 * _backgroundAnimation.value), // Increased opacity for better visibility
                            child: IgnorePointer(
                              ignoring: _isOpen, // Disable all interactions when menu is open
                              child: Opacity(
                                opacity: 1.0 - (_backgroundAnimation.value * 0.7), // Slightly dim the content
                                child: widget.child,
                              ),
                            ),
                          ),
                        )
                      : widget.child;
                },
              ),

              // Quick actions menu (only show when visible)
              if (widget.useStandardFabPosition)
                // Use standard endFloat positioning
                Positioned(right: 16.0, bottom: 16.0, child: _buildFabContent())
              else
                // Use custom alignment positioning
                Align(
                  alignment: widget.alignment,
                  child: Padding(padding: const EdgeInsets.all(16.0), child: _buildFabContent()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the actual FAB content with actions
  Widget _buildFabContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: widget.useStandardFabPosition || widget.alignment == Alignment.topLeft || widget.alignment == Alignment.bottomLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      verticalDirection: widget.useStandardFabPosition || widget.alignment == Alignment.topLeft || widget.alignment == Alignment.topRight ? VerticalDirection.down : VerticalDirection.up,
      children: [
        // Action buttons
        if (widget.actions.isNotEmpty)
          ...widget.actions.asMap().entries.map((entry) {
            final index = entry.key;
            final action = entry.value;
            return AnimatedBuilder(
              animation: _actionAnimations[index],
              builder: (context, child) {
                final animation = _actionAnimations[index];
                return Transform.scale(
                  scale: animation.value.clamp(0.0, 2.0),
                  child: Transform.translate(
                    offset: Offset(0, (1 - animation.value) * 20 * (widget.useStandardFabPosition || widget.alignment == Alignment.topLeft || widget.alignment == Alignment.topRight ? 1 : -1)),
                    child: Opacity(
                      opacity: animation.value.clamp(0.0, 1.0),
                      child: Container(
                        margin: EdgeInsets.only(bottom: widget.useStandardFabPosition || widget.alignment == Alignment.topLeft || widget.alignment == Alignment.topRight ? widget.spacing : 0, top: widget.alignment == Alignment.bottomLeft || widget.alignment == Alignment.bottomRight ? widget.spacing : 0),
                        child: _buildActionButton(action),
                      ),
                    ),
                  ),
                );
              },
            );
          }),

        // Main FAB
        AnimatedBuilder(
          animation: _fabAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _fabAnimation.value * 0.785398, // 45 degrees in radians
              child: FloatingActionButton(
                onPressed: _toggle,
                backgroundColor: _isOpen ? Colors.red : Theme.of(context).colorScheme.primary,
                child: Icon(_isOpen ? Icons.close_fullscreen : Icons.electric_bolt_outlined, color: Colors.white),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(QuickAction action) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Tooltip(
      message: action.tooltip ?? action.label,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        shadowColor: action.color.withValues(alpha: 0.4),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: action.isEnabled ? [action.color, action.color.withValues(red: (action.color.r * 0.8).clamp(0, 1), green: (action.color.g * 0.8).clamp(0, 1), blue: (action.color.b * 0.8).clamp(0, 1))] : [Colors.grey, Colors.grey.shade700],
              begin: isRTL ? Alignment.topRight : Alignment.topLeft,
              end: isRTL ? Alignment.bottomLeft : Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: action.color.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4), spreadRadius: 1)],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: action.isEnabled
                  ? () {
                      HapticFeedback.mediumImpact();
                      action.onTap();
                      _close();
                    }
                  : null,
              borderRadius: BorderRadius.circular(16),
              splashColor: Colors.white.withValues(alpha: 0.3),
              highlightColor: Colors.white.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    // Icon with subtle background
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                      child: Icon(action.icon, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    // Label with bold styling
                    Text(
                      action.label,
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Predefined quick actions for task management
class TaskQuickActions {
  /// Creates smart quick actions for a task based on its state with intelligent prioritization
  static List<QuickAction> forTask({
    required AppLocalizations l10n,
    required bool isCompleted,
    required bool canStartFocus,
    required VoidCallback onComplete,
    required VoidCallback onUncomplete,
    required VoidCallback onEdit,
    required VoidCallback onFocus,
    required VoidCallback onSetReminder,
    required VoidCallback onAddSubtask,
    required VoidCallback onDuplicate,
    required VoidCallback onDelete,
    bool hasReminder = false,
    bool hasSubtasks = false,
    bool isOverdue = false,
    bool isHighPriority = false,
    int maxActions = 7,
  }) {
    final actions = <QuickAction>[];

    // === PRIMARY ACTIONS (Always visible) ===

    // 1. Completion toggle - Most important action
    if (isCompleted) {
      actions.add(QuickAction(id: 'uncomplete', label: l10n.markAsIncomplete, icon: Icons.undo_rounded, color: Colors.orange, onTap: onUncomplete, tooltip: l10n.markAsIncomplete));
    } else {
      actions.add(QuickAction(id: 'complete', label: l10n.complete, icon: Icons.check_circle_rounded, color: Colors.green, onTap: onComplete, tooltip: l10n.markAsComplete));
    }

    // === CONTEXTUAL ACTIONS (Based on task state) ===

    if (!isCompleted) {
      // 2. Focus session - High priority for active tasks
      if (canStartFocus) {
        actions.add(QuickAction(id: 'focus', label: l10n.focus, icon: Icons.timer_rounded, color: isHighPriority ? Colors.deepPurple : Colors.purple, onTap: onFocus, tooltip: l10n.startFocusSession));
      }

      // 3. Edit - Essential for incomplete tasks
      actions.add(QuickAction(id: 'edit', label: l10n.edit, icon: Icons.edit_rounded, color: Colors.blue, onTap: onEdit, tooltip: l10n.editTask));

      // 4. Reminder - Important for task management
      actions.add(
        QuickAction(
          id: 'reminder',
          label: hasReminder ? l10n.edit : l10n.setReminderButton,
          icon: hasReminder ? Icons.notifications_active : Icons.notifications_outlined,
          color: hasReminder ? Colors.green : (isOverdue ? Colors.red : Colors.amber),
          onTap: onSetReminder,
          tooltip: hasReminder ? l10n.edit : l10n.setReminderButton,
        ),
      );

      // 5. Add subtask - Useful for task breakdown
      if (!hasSubtasks || actions.length < maxActions) {
        actions.add(QuickAction(id: 'subtask', label: l10n.addSubtask, icon: Icons.add_task_rounded, color: Colors.teal, onTap: onAddSubtask, tooltip: l10n.addSubtask));
      }
    } else {
      // For completed tasks, show reminder option
      if (hasReminder) {
        actions.add(QuickAction(id: 'reminder', label: l10n.clear, icon: Icons.notifications_off, color: Colors.grey, onTap: onSetReminder, tooltip: l10n.reminderCancelled));
      }
    }

    // === UTILITY ACTIONS ===

    // 6. Duplicate - Useful for recurring patterns
    if (actions.length < maxActions) {
      actions.add(QuickAction(id: 'duplicate', label: l10n.duplicateTask, icon: Icons.content_copy_rounded, color: Colors.indigo, onTap: onDuplicate, tooltip: l10n.duplicateTask));
    }

    // === DESTRUCTIVE ACTIONS (Always last) ===

    // 7. Delete - Always available but last
    actions.add(QuickAction(id: 'delete', label: l10n.delete, icon: Icons.delete_rounded, color: Colors.red, onTap: onDelete, tooltip: l10n.deleteTask));

    // Ensure we don't exceed max actions
    if (actions.length > maxActions) {
      return actions.sublist(0, maxActions);
    }

    return actions;
  }

  /// Creates quick actions for subtask management
  static List<QuickAction> forSubtasks({required VoidCallback onAddSubtask, required VoidCallback onAddFromTemplate, required VoidCallback onReorderSubtasks, required VoidCallback onBulkComplete}) {
    return [
      QuickAction(id: 'add_subtask', label: 'Add Subtask', icon: Icons.add, color: Colors.blue, onTap: onAddSubtask, tooltip: 'Add new subtask'),
      QuickAction(id: 'template', label: 'Template', icon: Icons.copy, color: Colors.green, onTap: onAddFromTemplate, tooltip: 'Add from template'),
      QuickAction(id: 'reorder', label: 'Reorder', icon: Icons.reorder, color: Colors.orange, onTap: onReorderSubtasks, tooltip: 'Reorder subtasks'),
      QuickAction(id: 'bulk_complete', label: 'Complete All', icon: Icons.done_all, color: Colors.purple, onTap: onBulkComplete, tooltip: 'Complete all subtasks'),
    ];
  }

  /// Creates quick actions for focus/productivity features
  static List<QuickAction> forFocus({required VoidCallback onStartPomodoro, required VoidCallback onStartDeepWork, required VoidCallback onSetBreak, required VoidCallback onViewStats}) {
    return [
      QuickAction(id: 'pomodoro', label: 'Pomodoro', icon: Icons.timer, color: Colors.red, onTap: onStartPomodoro, tooltip: 'Start 25-min Pomodoro'),
      QuickAction(id: 'deep_work', label: 'Deep Work', icon: Icons.psychology, color: Colors.purple, onTap: onStartDeepWork, tooltip: 'Start deep work session'),
      QuickAction(id: 'break', label: 'Break', icon: Icons.coffee, color: Colors.brown, onTap: onSetBreak, tooltip: 'Take a break'),
      QuickAction(id: 'stats', label: 'Stats', icon: Icons.analytics, color: Colors.blue, onTap: onViewStats, tooltip: 'View focus statistics'),
    ];
  }
}
