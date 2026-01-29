import 'package:flutter/material.dart';

/// Optimistic UI state for tracking pending operations
class OptimisticState {
  final String operationId;
  final String type;
  final Map<String, dynamic> pendingData;
  final DateTime timestamp;
  final bool isReverted;

  const OptimisticState({required this.operationId, required this.type, required this.pendingData, required this.timestamp, this.isReverted = false});

  OptimisticState copyWith({String? operationId, String? type, Map<String, dynamic>? pendingData, DateTime? timestamp, bool? isReverted}) {
    return OptimisticState(operationId: operationId ?? this.operationId, type: type ?? this.type, pendingData: pendingData ?? this.pendingData, timestamp: timestamp ?? this.timestamp, isReverted: isReverted ?? this.isReverted);
  }
}

/// Optimistic UI manager for handling instant feedback
class OptimisticUIManager extends ChangeNotifier {
  final Map<String, OptimisticState> _pendingOperations = {};
  final Duration _timeout = const Duration(seconds: 10);

  Map<String, OptimisticState> get pendingOperations => Map.unmodifiable(_pendingOperations);

  /// Adds a pending operation with optimistic UI
  void addPendingOperation(OptimisticState operation) {
    _pendingOperations[operation.operationId] = operation;
    notifyListeners();

    // Auto-revert if operation takes too long
    Future.delayed(_timeout, () {
      if (_pendingOperations.containsKey(operation.operationId)) {
        revertOperation(operation.operationId);
      }
    });
  }

  /// Confirms a successful operation
  void confirmOperation(String operationId) {
    _pendingOperations.remove(operationId);
    notifyListeners();
  }

  /// Reverts a failed operation
  void revertOperation(String operationId) {
    final operation = _pendingOperations[operationId];
    if (operation != null) {
      _pendingOperations[operationId] = operation.copyWith(isReverted: true);
      notifyListeners();

      // Remove after showing revert animation
      Future.delayed(const Duration(milliseconds: 500), () {
        _pendingOperations.remove(operationId);
        notifyListeners();
      });
    }
  }

  /// Checks if an operation is pending
  bool isOperationPending(String operationId) {
    return _pendingOperations.containsKey(operationId);
  }

  /// Gets pending operation by ID
  OptimisticState? getPendingOperation(String operationId) {
    return _pendingOperations[operationId];
  }

  /// Clears all pending operations
  void clearAll() {
    _pendingOperations.clear();
    notifyListeners();
  }
}

/// Widget wrapper for optimistic UI updates
class OptimisticUIWrapper extends StatefulWidget {
  final Widget child;
  final OptimisticUIManager manager;
  final String? operationId;
  final Widget Function(BuildContext, Widget, OptimisticState?)? optimisticBuilder;

  const OptimisticUIWrapper({super.key, required this.child, required this.manager, this.operationId, this.optimisticBuilder});

  @override
  State<OptimisticUIWrapper> createState() => _OptimisticUIWrapperState();
}

class _OptimisticUIWrapperState extends State<OptimisticUIWrapper> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    widget.manager.addListener(_onOptimisticStateChanged);
  }

  @override
  void dispose() {
    widget.manager.removeListener(_onOptimisticStateChanged);
    _animationController.dispose();
    super.dispose();
  }

  void _onOptimisticStateChanged() {
    if (widget.operationId != null) {
      final operation = widget.manager.getPendingOperation(widget.operationId!);
      if (operation != null && !operation.isReverted) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.manager,
      builder: (context, child) {
        final operation = widget.operationId != null ? widget.manager.getPendingOperation(widget.operationId!) : null;

        Widget content = widget.child;

        // Apply optimistic builder if provided
        if (widget.optimisticBuilder != null) {
          content = widget.optimisticBuilder!(context, content, operation);
        }

        // Apply pending operation visual feedback
        if (operation != null && !operation.isReverted) {
          content = AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Stack(
                    children: [
                      content,
                      // Pending indicator
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.orange.withValues(alpha: 0.3), blurRadius: 4, spreadRadius: 2)],
                          ),
                          child: const SizedBox(width: 8, height: 8, child: CircularProgressIndicator(strokeWidth: 1.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        // Apply revert animation if operation failed
        if (operation != null && operation.isReverted) {
          content = TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(10 * (1 - value), 0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red.withValues(alpha: value), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: content,
                ),
              );
            },
          );
        }

        return content;
      },
    );
  }
}

/// Mixin for adding optimistic UI capabilities to widgets
mixin OptimisticUIMixin<T extends StatefulWidget> on State<T> {
  late final OptimisticUIManager _optimisticManager;

  OptimisticUIManager get optimisticManager => _optimisticManager;

  @override
  void initState() {
    super.initState();
    _optimisticManager = OptimisticUIManager();
  }

  @override
  void dispose() {
    _optimisticManager.dispose();
    super.dispose();
  }

  /// Executes an operation with optimistic UI
  Future<void> executeOptimistically({required String operationId, required String operationType, required Map<String, dynamic> optimisticData, required Future<void> Function() operation, VoidCallback? onSuccess, VoidCallback? onError}) async {
    // Add optimistic state
    _optimisticManager.addPendingOperation(OptimisticState(operationId: operationId, type: operationType, pendingData: optimisticData, timestamp: DateTime.now()));

    try {
      // Execute actual operation
      await operation();

      // Confirm success
      _optimisticManager.confirmOperation(operationId);
      onSuccess?.call();
    } catch (error) {
      // Revert on failure
      _optimisticManager.revertOperation(operationId);
      onError?.call();

      // Show error feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Operation failed: ${error.toString()}'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
      }
    }
  }
}

/// Predefined optimistic UI operations for common task actions
class TaskOptimisticOperations {
  static const String completeTask = 'complete_task';
  static const String uncompleteTask = 'uncomplete_task';
  static const String updateTask = 'update_task';
  static const String deleteTask = 'delete_task';
  static const String addSubtask = 'add_subtask';
  static const String toggleSubtask = 'toggle_subtask';
  static const String setReminder = 'set_reminder';
  static const String startPomodoro = 'start_pomodoro';

  /// Creates optimistic data for task completion
  static Map<String, dynamic> completeTaskData(String taskId) => {'taskId': taskId, 'isCompleted': true, 'completedAt': DateTime.now().toIso8601String()};

  /// Creates optimistic data for task uncompletion
  static Map<String, dynamic> uncompleteTaskData(String taskId) => {'taskId': taskId, 'isCompleted': false, 'completedAt': null};

  /// Creates optimistic data for subtask toggle
  static Map<String, dynamic> toggleSubtaskData(String subtaskId, bool isCompleted) => {'subtaskId': subtaskId, 'isCompleted': !isCompleted, 'toggledAt': DateTime.now().toIso8601String()};

  /// Creates optimistic data for reminder setting
  static Map<String, dynamic> setReminderData(String taskId, DateTime reminderTime) => {'taskId': taskId, 'reminderDate': reminderTime.toIso8601String(), 'setAt': DateTime.now().toIso8601String()};
}
