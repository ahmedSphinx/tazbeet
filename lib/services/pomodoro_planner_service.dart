import '../models/task.dart';
import '../models/pomodoro_plan.dart';
import 'app_logging_service.dart';

/// Service for creating intelligent pomodoro plans for tasks
class PomodoroPlannerService {
  static const int defaultWorkDuration = 25;
  static const int defaultBreakDuration = 5;
  static const int defaultLongBreakDuration = 15;
  static const int defaultSessionsBeforeLongBreak = 4;

  /// Analyze task complexity and suggest optimal pomodoro breakdown
  PomodoroPlan createOptimalPlan(Task task) {
    AppLogging.logInfo('Creating optimal pomodoro plan for task: ${task.title}', name: 'PomodoroPlannerService');

    final estimatedSessions = _estimateRequiredSessions(task);
    final workDuration = _adjustWorkDuration(task);
    final breakDuration = _adjustBreakDuration(task);
    final longBreakDuration = _adjustLongBreakDuration(task);
    final sessionsBeforeLongBreak = _adjustSessionsBeforeLongBreak(task);

    final sessions = _generateSessionPlans(task, estimatedSessions, workDuration, breakDuration, longBreakDuration, sessionsBeforeLongBreak);

    return PomodoroPlan(
      taskId: task.id,
      totalSessions: estimatedSessions,
      workDuration: workDuration,
      breakDuration: breakDuration,
      longBreakDuration: longBreakDuration,
      sessionsBeforeLongBreak: sessionsBeforeLongBreak,
      sessions: sessions,
      createdAt: DateTime.now(),
      metadata: {'taskTitle': task.title, 'taskPriority': task.priority.name, 'estimatedDuration': _estimateTaskDuration(task).inMinutes, 'focusScore': task.focusScore, 'strategy': task.strategy.name},
    );
  }

  /// Estimate how many pomodoro sessions are needed for a task
  int _estimateRequiredSessions(Task task) {
    // Base estimation on task priority and focus score
    int baseSessions = switch (task.priority) {
      TaskPriority.low => 1,
      TaskPriority.medium => 2,
      TaskPriority.high => 3,
    };

    // Adjust based on focus score (1-10)
    final focusMultiplier = (11 - task.focusScore) / 10.0;
    baseSessions = (baseSessions * focusMultiplier).ceil();

    // Adjust based on description length (complexity indicator)
    if (task.description != null && task.description!.length > 100) {
      baseSessions += 1;
    }

    // Adjust based on subtasks
    if (task.subtasks.isNotEmpty) {
      baseSessions += (task.subtasks.length / 2).ceil();
    }

    // Ensure at least 1 session
    return baseSessions.clamp(1, 10);
  }

  /// Adjust work duration based on task characteristics
  int _adjustWorkDuration(Task task) {
    int duration = defaultWorkDuration;

    // Shorter sessions for low-focus tasks
    if (task.focusScore <= 3) {
      duration = 15;
    }
    // Longer sessions for high-focus tasks
    else if (task.focusScore >= 8) {
      duration = 30;
    }

    // Adjust based on priority
    switch (task.priority) {
      case TaskPriority.low:
        duration = (duration * 0.8).round();
        break;
      case TaskPriority.high:
        duration = (duration * 1.2).round();
        break;
      case TaskPriority.medium:
        break; // Keep default
    }

    return duration.clamp(15, 45);
  }

  /// Adjust break duration based on task intensity
  int _adjustBreakDuration(Task task) {
    int duration = defaultBreakDuration;

    // Longer breaks for high-focus tasks
    if (task.focusScore >= 7) {
      duration = 10;
    }
    // Shorter breaks for low-focus tasks
    else if (task.focusScore <= 3) {
      duration = 3;
    }

    return duration.clamp(3, 15);
  }

  /// Adjust long break duration based on overall task load
  int _adjustLongBreakDuration(Task task) {
    int duration = defaultLongBreakDuration;

    // Longer breaks for high-priority, high-focus tasks
    if (task.priority == TaskPriority.high && task.focusScore >= 7) {
      duration = 20;
    }
    // Shorter breaks for simple tasks
    else if (task.priority == TaskPriority.low && task.focusScore <= 4) {
      duration = 10;
    }

    return duration.clamp(10, 30);
  }

  /// Adjust sessions before long break based on task complexity
  int _adjustSessionsBeforeLongBreak(Task task) {
    int sessions = defaultSessionsBeforeLongBreak;

    // More frequent breaks for high-focus tasks
    if (task.focusScore >= 8) {
      sessions = 3;
    }
    // Less frequent breaks for low-focus tasks
    else if (task.focusScore <= 3) {
      sessions = 5;
    }

    return sessions.clamp(2, 6);
  }

  /// Generate detailed session plans
  List<PomodoroSessionPlan> _generateSessionPlans(Task task, int totalSessions, int workDuration, int breakDuration, int longBreakDuration, int sessionsBeforeLongBreak) {
    final sessions = <PomodoroSessionPlan>[];
    int sessionNumber = 1;

    while (sessionNumber <= totalSessions) {
      // Add work session
      sessions.add(
        PomodoroSessionPlan(
          sessionNumber: sessionNumber,
          type: SessionType.work,
          duration: workDuration,
          focusArea: _determineFocusArea(task, sessionNumber),
          subtasks: _getSubtasksForSession(task, sessionNumber),
          metadata: {'taskTitle': task.title, 'sessionType': 'work', 'estimatedProgress': ((sessionNumber / totalSessions) * 100).round()},
        ),
      );

      // Add break session if not the last work session
      if (sessionNumber < totalSessions) {
        final isLongBreak = sessionNumber % sessionsBeforeLongBreak == 0;
        sessions.add(
          PomodoroSessionPlan(
            sessionNumber: sessionNumber + 1,
            type: isLongBreak ? SessionType.longBreak : SessionType.shortBreak,
            duration: isLongBreak ? longBreakDuration : breakDuration,
            metadata: {'taskTitle': task.title, 'sessionType': isLongBreak ? 'longBreak' : 'shortBreak', 'previousWorkSession': sessionNumber},
          ),
        );
        sessionNumber++; // Count the break session
      }

      sessionNumber++;
    }

    return sessions;
  }

  /// Determine what to focus on in a specific session
  String? _determineFocusArea(Task task, int sessionNumber) {
    if (task.subtasks.isEmpty) {
      return null;
    }

    final subtaskIndex = (sessionNumber - 1) % task.subtasks.length;
    return task.subtasks[subtaskIndex].title;
  }

  /// Get subtasks for a specific session
  List<String> _getSubtasksForSession(Task task, int sessionNumber) {
    if (task.subtasks.isEmpty) {
      return [];
    }

    // Distribute subtasks across sessions
    final subtasksPerSession = (task.subtasks.length / _estimateRequiredSessions(task)).ceil();
    final startIndex = (sessionNumber - 1) * subtasksPerSession;
    final endIndex = (startIndex + subtasksPerSession).clamp(0, task.subtasks.length);

    return task.subtasks.skip(startIndex).take(endIndex - startIndex).map((subtask) => subtask.title).toList();
  }

  /// Estimate total task duration in minutes
  Duration _estimateTaskDuration(Task task) {
    final sessions = _estimateRequiredSessions(task);
    final workDuration = _adjustWorkDuration(task);
    final breakDuration = _adjustBreakDuration(task);
    final longBreakDuration = _adjustLongBreakDuration(task);
    final sessionsBeforeLongBreak = _adjustSessionsBeforeLongBreak(task);

    final totalWorkTime = sessions * workDuration;
    final totalBreakTime = _calculateTotalBreakTime(sessions, breakDuration, longBreakDuration, sessionsBeforeLongBreak);

    return Duration(minutes: totalWorkTime + totalBreakTime);
  }

  /// Calculate total break time for all sessions
  int _calculateTotalBreakTime(int totalSessions, int breakDuration, int longBreakDuration, int sessionsBeforeLongBreak) {
    final longBreaks = (totalSessions - 1) ~/ sessionsBeforeLongBreak;
    final shortBreaks = (totalSessions - 1) - longBreaks;
    return (longBreaks * longBreakDuration) + (shortBreaks * breakDuration);
  }

  /// Suggest best time of day for task based on user patterns
  DateTime? suggestOptimalStartTime(Task task) {
    final now = DateTime.now();

    // High-focus tasks: morning (9 AM - 12 PM)
    if (task.focusScore >= 7) {
      return DateTime(now.year, now.month, now.day, 9, 0);
    }
    // Medium-focus tasks: afternoon (1 PM - 5 PM)
    else if (task.focusScore >= 4) {
      return DateTime(now.year, now.month, now.day, 13, 0);
    }
    // Low-focus tasks: late afternoon (3 PM - 6 PM)
    else {
      return DateTime(now.year, now.month, now.day, 15, 0);
    }
  }

  /// Create a chain of related tasks for continuous workflow
  List<Task> createTaskChain(List<Task> availableTasks) {
    // Sort by priority and focus score
    final sortedTasks = List<Task>.from(availableTasks)
      ..sort((a, b) {
        final priorityComparison = b.priority.index.compareTo(a.priority.index);
        if (priorityComparison != 0) return priorityComparison;
        return b.focusScore.compareTo(a.focusScore);
      });

    // Group similar tasks together
    final taskChain = <Task>[];
    Task? lastTask;

    for (final task in sortedTasks) {
      if (lastTask == null || _areTasksCompatible(lastTask, task)) {
        taskChain.add(task);
        lastTask = task;
      }
    }

    return taskChain.take(5).toList(); // Limit to 5 tasks for optimal focus
  }

  /// Check if two tasks are compatible for chaining
  bool _areTasksCompatible(Task task1, Task task2) {
    // Same category or priority
    if (task1.categoryId == task2.categoryId) return true;
    if (task1.priority == task2.priority) return true;

    // Similar focus score (within 2 points)
    if ((task1.focusScore - task2.focusScore).abs() <= 2) return true;

    return false;
  }

  /// Adjust session timing based on task performance
  int adjustSessionTiming(Task task, int baseDuration, {bool isPerformingWell = true}) {
    if (isPerformingWell) {
      // Extend sessions if performing well
      return (baseDuration * 1.2).round().clamp(15, 45);
    } else {
      // Shorten sessions if struggling
      return (baseDuration * 0.8).round().clamp(10, 30);
    }
  }

  /// Validate and optimize an existing pomodoro plan
  PomodoroPlan optimizePlan(PomodoroPlan plan, Task task) {
    final optimizedSessions = <PomodoroSessionPlan>[];

    for (final session in plan.sessions) {
      if (session.type == SessionType.work) {
        // Optimize work sessions based on task performance
        final optimizedDuration = adjustSessionTiming(task, session.duration, isPerformingWell: task.focusScore >= 6);

        optimizedSessions.add(session.copyWith(duration: optimizedDuration, focusArea: _determineFocusArea(task, session.sessionNumber)));
      } else {
        optimizedSessions.add(session);
      }
    }

    return plan.copyWith(sessions: optimizedSessions, metadata: {...plan.metadata, 'optimizedAt': DateTime.now().toIso8601String(), 'optimizationReason': 'performance_based_adjustment'});
  }
}
