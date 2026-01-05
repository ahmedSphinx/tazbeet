import '../models/task.dart';
import '../models/pomodoro_strategy.dart';
import 'pomodoro_planner.dart';

class SessionChain {
  final Task _parentTask;
  final List<Task> _availableSubtasks;
  final PomodoroStrategy _strategy;
  int _currentSubtaskIndex = 0;
  int _completedSessions = 0;
  final List<String> _sessionHistory = [];

  SessionChain({required Task parentTask, required List<Task> availableSubtasks, PomodoroStrategy strategy = PomodoroStrategy.sequential})
    : _parentTask = parentTask,
      _availableSubtasks = availableSubtasks,
      _strategy = strategy;

  /// Get the next subtask to work on based on the strategy
  Task? getNextSubtask() {
    if (_availableSubtasks.isEmpty) return null;

    switch (_strategy) {
      case PomodoroStrategy.sequential:
        return _getNextSequentialSubtask();
      case PomodoroStrategy.priority:
        return _getNextPrioritySubtask();
      case PomodoroStrategy.timeBoxed:
        return _getNextTimeBoxedSubtask();
      case PomodoroStrategy.flexible:
        return _getNextFlexibleSubtask();
    }
  }

  /// Mark a subtask session as completed and return the next one
  Task? completeSubtaskSession(Task completedSubtask, String sessionNote) {
    _sessionHistory.add('${completedSubtask.title}: $sessionNote');
    _completedSessions++;

    // Check if the subtask is fully completed
    if (completedSubtask.isCompleted) {
      _sessionHistory.add('✅ ${completedSubtask.title} - COMPLETED');
    }

    // Get the next subtask
    return getNextSubtask();
  }

  /// Check if the chaining should continue
  bool shouldContinueChaining() {
    if (!_parentTask.autoStartNextSubtask) return false;

    // Continue if there are incomplete subtasks
    return _availableSubtasks.any((subtask) => !subtask.isCompleted);
  }

  /// Get a summary of the chaining session
  Map<String, dynamic> getSessionSummary() {
    return {
      'parentTask': _parentTask.title,
      'strategy': _strategy.displayName,
      'totalSessions': _completedSessions,
      'subtasksCompleted': _availableSubtasks.where((s) => s.isCompleted).length,
      'totalSubtasks': _availableSubtasks.length,
      'sessionHistory': _sessionHistory,
      'isComplete': _parentTask.isFullyCompleted(),
      'progress': _parentTask.getCompletionProgress(),
    };
  }

  /// Create a pomodoro session plan for the entire chain
  List<PomodoroSession> createChainSessionPlan() {
    final planner = PomodoroPlanner();
    final allSessions = <PomodoroSession>[];
    int sessionOrder = 0;

    // Create sessions based on strategy
    final orderedSubtasks = _getOrderedSubtasks();

    for (int i = 0; i < orderedSubtasks.length; i++) {
      final subtask = orderedSubtasks[i];
      final subtaskSessions = planner.createSessionPlan(subtask);

      // Add break between subtasks (except after the last one)
      for (final session in subtaskSessions) {
        if (session.type == 'work') {
          allSessions.add(session);
          sessionOrder++;

          // Add break after work session (except after last subtask)
          if (i < orderedSubtasks.length - 1 || subtaskSessions.indexOf(session) < subtaskSessions.length - 1) {
            final breakDuration = planner.getRecommendedBreakDuration(session.duration, sessionOrder);
            allSessions.add(
              PomodoroSession(
                taskId: _parentTask.id,
                duration: breakDuration,
                type: sessionOrder % 4 == 0 ? 'long_break' : 'short_break',
                title: sessionOrder % 4 == 0 ? 'Long Break' : 'Short Break',
                order: sessionOrder++,
              ),
            );
          }
        }
      }
    }

    return allSessions;
  }

  /// Estimate total time needed for the chain
  int estimateTotalChainTime() {
    final sessionPlan = createChainSessionPlan();
    return sessionPlan.fold<int>(0, (total, session) => total + session.duration);
  }

  /// Get recommendations for optimizing the chain
  List<String> getChainRecommendations() {
    final recommendations = <String>[];

    if (_availableSubtasks.length > 8) {
      recommendations.add('Consider breaking this into multiple chains for better focus');
    }

    final avgSessionsPerSubtask = _completedSessions / _availableSubtasks.length;
    if (avgSessionsPerSubtask > 3) {
      recommendations.add('Some subtasks are taking longer than expected. Consider breaking them down further');
    }

    final incompleteSubtasks = _availableSubtasks.where((s) => !s.isCompleted).length;
    if (incompleteSubtasks == 1) {
      recommendations.add('Only one subtask remaining! Consider a focused session to complete it');
    }

    if (_strategy == PomodoroStrategy.flexible && _completedSessions > 5) {
      recommendations.add('You\'ve completed several sessions. Consider switching to priority strategy to focus on remaining important items');
    }

    return recommendations;
  }

  // Private helper methods

  Task? _getNextSequentialSubtask() {
    // Find the first incomplete subtask
    for (int i = _currentSubtaskIndex; i < _availableSubtasks.length; i++) {
      if (!_availableSubtasks[i].isCompleted) {
        _currentSubtaskIndex = i;
        return _availableSubtasks[i];
      }
    }

    // If all current subtasks are complete, start from beginning
    _currentSubtaskIndex = 0;
    for (int i = 0; i < _availableSubtasks.length; i++) {
      if (!_availableSubtasks[i].isCompleted) {
        _currentSubtaskIndex = i;
        return _availableSubtasks[i];
      }
    }

    return null; // All subtasks completed
  }

  Task? _getNextPrioritySubtask() {
    // Sort by priority and return the first incomplete
    final sortedByPriority = List<Task>.from(_availableSubtasks);
    sortedByPriority.sort((a, b) => b.priority.index.compareTo(a.priority.index));

    for (final subtask in sortedByPriority) {
      if (!subtask.isCompleted) {
        return subtask;
      }
    }

    return null;
  }

  Task? _getNextTimeBoxedSubtask() {
    // Rotate through subtasks evenly
    final incompleteSubtasks = _availableSubtasks.where((s) => !s.isCompleted).toList();
    if (incompleteSubtasks.isEmpty) return null;

    final index = _completedSessions % incompleteSubtasks.length;
    return incompleteSubtasks[index];
  }

  Task? _getNextFlexibleSubtask() {
    // For flexible strategy, suggest based on multiple factors
    final incompleteSubtasks = _availableSubtasks.where((s) => !s.isCompleted).toList();
    if (incompleteSubtasks.isEmpty) return null;

    // Prioritize subtasks that are close to completion
    final nearlyComplete = incompleteSubtasks.where((s) => s.getCompletionProgress() > 0.7).toList();
    if (nearlyComplete.isNotEmpty) {
      return nearlyComplete.first;
    }

    // Otherwise, pick the one with highest priority
    if (incompleteSubtasks.isEmpty) return null;
    return incompleteSubtasks.reduce((a, b) => a.priority.index > b.priority.index ? a : b);
  }

  List<Task> _getOrderedSubtasks() {
    switch (_strategy) {
      case PomodoroStrategy.sequential:
        return List<Task>.from(_availableSubtasks);
      case PomodoroStrategy.priority:
        final sorted = List<Task>.from(_availableSubtasks);
        sorted.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        return sorted;
      case PomodoroStrategy.timeBoxed:
        return List<Task>.from(_availableSubtasks);
      case PomodoroStrategy.flexible:
        // For flexible, order by progress (nearly complete first)
        final sorted = List<Task>.from(_availableSubtasks);
        sorted.sort((a, b) => b.getCompletionProgress().compareTo(a.getCompletionProgress()));
        return sorted;
    }
  }

  /// Create a new session chain for a task
  static SessionChain? createForTask(Task task) {
    if (task.subtasks.isEmpty) return null;

    // Extract all leaf subtasks (those without their own subtasks)
    final leafSubtasks = <Task>[];
    void collectLeafSubtasks(Task t) {
      if (t.subtasks.isEmpty) {
        leafSubtasks.add(t);
      } else {
        for (final subtask in t.subtasks) {
          collectLeafSubtasks(subtask);
        }
      }
    }

    collectLeafSubtasks(task);

    if (leafSubtasks.isEmpty) return null;

    return SessionChain(parentTask: task, availableSubtasks: leafSubtasks, strategy: task.strategy);
  }

  /// Get chain statistics for analytics
  Map<String, dynamic> getChainAnalytics() {
    final completedSubtasks = _availableSubtasks.where((s) => s.isCompleted).length;
    final totalEstimatedSessions = _availableSubtasks.fold<int>(0, (total, subtask) => total + subtask.estimatedSessions);

    return {
      'efficiency': completedSubtasks > 0 ? _completedSessions / completedSubtasks : 0.0,
      'completionRate': completedSubtasks / _availableSubtasks.length,
      'estimatedAccuracy': totalEstimatedSessions > 0 ? _completedSessions / totalEstimatedSessions : 0.0,
      'averageSessionsPerSubtask': _availableSubtasks.isNotEmpty ? _completedSessions / _availableSubtasks.length : 0.0,
      'strategyEffectiveness': _calculateStrategyEffectiveness(),
    };
  }

  double _calculateStrategyEffectiveness() {
    if (_completedSessions == 0) return 0.0;

    final completedSubtasks = _availableSubtasks.where((s) => s.isCompleted).length;
    final effectiveness = completedSubtasks / _completedSessions;

    // Adjust based on strategy
    switch (_strategy) {
      case PomodoroStrategy.sequential:
        return effectiveness * 1.0; // Baseline
      case PomodoroStrategy.priority:
        return effectiveness * 1.1; // Slightly better for urgent tasks
      case PomodoroStrategy.timeBoxed:
        return effectiveness * 0.9; // Good for consistency, may be slower
      case PomodoroStrategy.flexible:
        return effectiveness * 1.05; // Good balance
    }
  }
}
