import '../models/task.dart';
import '../models/pomodoro_strategy.dart';

class PomodoroSession {
  final String taskId;
  final String? subtaskId;
  final int duration; // in minutes
  final String type; // 'work', 'short_break', 'long_break'
  final String title;
  final String description;
  final int order;

  PomodoroSession({required this.taskId, this.subtaskId, required this.duration, required this.type, required this.title, this.description = '', required this.order});

  Map<String, dynamic> toJson() {
    return {'taskId': taskId, 'subtaskId': subtaskId, 'duration': duration, 'type': type, 'title': title, 'description': description, 'order': order};
  }

  factory PomodoroSession.fromJson(Map<String, dynamic> json) {
    return PomodoroSession(taskId: json['taskId'], subtaskId: json['subtaskId'], duration: json['duration'], type: json['type'], title: json['title'], description: json['description'] ?? '', order: json['order']);
  }
}

class PomodoroPlanner {
  static const int defaultWorkDuration = 25;
  static const int defaultShortBreak = 5;
  static const int defaultLongBreak = 15;
  static const int sessionsPerLongBreak = 4;

  /// Estimate how many pomodoro sessions are needed for a task
  int estimateSessionsNeeded(Task task) {
    if (task.subtasks.isEmpty) {
      // Simple task without subtasks
      return _estimateSimpleTaskSessions(task);
    } else {
      // Complex task with subtasks
      return _estimateComplexTaskSessions(task);
    }
  }

  /// Create a detailed session plan for a task
  List<PomodoroSession> createSessionPlan(Task task) {
    final sessions = <PomodoroSession>[];
    int sessionOrder = 0;

    switch (task.strategy) {
      case PomodoroStrategy.sequential:
        sessions.addAll(_createSequentialPlan(task, sessionOrder));
        break;
      case PomodoroStrategy.priority:
        sessions.addAll(_createPriorityPlan(task, sessionOrder));
        break;
      case PomodoroStrategy.timeBoxed:
        sessions.addAll(_createTimeBoxedPlan(task, sessionOrder));
        break;
      case PomodoroStrategy.flexible:
        sessions.addAll(_createFlexiblePlan(task, sessionOrder));
        break;
    }

    return sessions;
  }

  /// Calculate optimal work duration for a task
  int calculateOptimalDuration(Task task) {
    // Base duration on task complexity and priority
    int baseDuration = defaultWorkDuration;

    // Adjust for priority
    switch (task.priority) {
      case TaskPriority.high:
        baseDuration = 50; // Deep work sessions
        break;
      case TaskPriority.medium:
        baseDuration = 35; // Standard focus
        break;
      case TaskPriority.low:
        baseDuration = 25; // Quick sessions
        break;
    }

    // Adjust for complexity (number of subtasks)
    final subtaskCount = _countAllSubtasks(task);
    if (subtaskCount > 10) {
      baseDuration += 10; // More time for complex tasks
    } else if (subtaskCount > 5) {
      baseDuration += 5;
    }

    // Adjust for estimated sessions
    if (task.estimatedSessions > 8) {
      baseDuration += 15; // Long projects need longer sessions
    } else if (task.estimatedSessions > 4) {
      baseDuration += 5;
    }

    // Cap at reasonable limits
    return baseDuration.clamp(15, 60);
  }

  /// Get recommended break duration based on work session
  int getRecommendedBreakDuration(int workDuration, int consecutiveSessions) {
    // Longer work sessions deserve longer breaks
    if (workDuration >= 50) {
      return consecutiveSessions >= sessionsPerLongBreak ? 20 : 10;
    } else if (workDuration >= 35) {
      return consecutiveSessions >= sessionsPerLongBreak ? 15 : 7;
    } else {
      return consecutiveSessions >= sessionsPerLongBreak ? defaultLongBreak : defaultShortBreak;
    }
  }

  /// Create a daily schedule based on available tasks
  List<PomodoroSession> createDailySchedule(List<Task> tasks, int availableHours, {int startHour = 9, bool includeBreaks = true}) {
    final sessions = <PomodoroSession>[];
    final totalMinutes = availableHours * 60;
    int usedMinutes = 0;
    int sessionOrder = 0;

    // Sort tasks by priority and due date
    final sortedTasks = List<Task>.from(tasks);
    sortedTasks.sort((a, b) {
      // First by priority
      final priorityComparison = b.priority.index.compareTo(a.priority.index);
      if (priorityComparison != 0) return priorityComparison;

      // Then by due date
      if (a.dueDate != null && b.dueDate != null) {
        return a.dueDate!.compareTo(b.dueDate!);
      } else if (a.dueDate != null) {
        return -1;
      } else if (b.dueDate != null) {
        return 1;
      }

      // Finally by estimated sessions (shorter tasks first)
      return a.estimatedSessions.compareTo(b.estimatedSessions);
    });

    for (final task in sortedTasks) {
      if (usedMinutes >= totalMinutes) break;

      final taskSessions = createSessionPlan(task);
      for (final session in taskSessions) {
        if (session.type != 'work') continue; // Skip breaks for now

        if (usedMinutes + session.duration > totalMinutes) break;

        sessions.add(session);
        usedMinutes += session.duration;

        // Add break if requested and there's time
        if (includeBreaks && usedMinutes < totalMinutes) {
          final breakDuration = getRecommendedBreakDuration(session.duration, sessions.length);
          if (usedMinutes + breakDuration <= totalMinutes) {
            sessions.add(
              PomodoroSession(
                taskId: session.taskId,
                duration: breakDuration,
                type: sessions.length % sessionsPerLongBreak == 0 ? 'long_break' : 'short_break',
                title: sessions.length % sessionsPerLongBreak == 0 ? 'Long Break' : 'Short Break',
                order: sessionOrder++,
              ),
            );
            usedMinutes += breakDuration;
          }
        }
      }
    }

    return sessions;
  }

  /// Analyze task completion patterns and suggest improvements
  Map<String, dynamic> analyzeTaskPatterns(Task task) {
    final sessions = task.pomodoroSessions;
    if (sessions.isEmpty) {
      return {'status': 'no_data', 'message': 'No session data available for analysis'};
    }

    // Calculate actual vs estimated sessions
    final actualSessions = sessions.length;
    final estimatedSessions = task.estimatedSessions;
    final sessionAccuracy = estimatedSessions > 0 ? (actualSessions / estimatedSessions) * 100 : 100.0;

    // Calculate average session duration
    final totalDuration = sessions.fold<int>(0, (sum, session) {
      return sum + (session['duration'] as int? ?? 25);
    });
    final avgDuration = totalDuration / actualSessions;

    // Calculate completion rate
    final isCompleted = task.isCompleted;
    final completionRate = isCompleted ? 100.0 : 0.0;

    // Analyze work patterns
    final workDays = <String>[];
    for (final session in sessions) {
      final date = DateTime.fromMillisecondsSinceEpoch(session['startTime'] ?? 0);
      final dayKey = '${date.year}-${date.month}-${date.day}';
      if (!workDays.contains(dayKey)) {
        workDays.add(dayKey);
      }
    }

    return {
      'status': 'analyzed',
      'actualSessions': actualSessions,
      'estimatedSessions': estimatedSessions,
      'sessionAccuracy': sessionAccuracy,
      'averageDuration': avgDuration,
      'completionRate': completionRate,
      'workDays': workDays.length,
      'sessionsPerDay': actualSessions / workDays.length,
      'recommendations': _generateRecommendations(task, sessionAccuracy, avgDuration),
    };
  }

  // Private helper methods

  int _estimateSimpleTaskSessions(Task task) {
    // Use task's own estimate if available
    if (task.estimatedSessions > 0) {
      return task.estimatedSessions;
    }

    // Estimate based on priority and complexity
    int baseSessions = 1;

    switch (task.priority) {
      case TaskPriority.high:
        baseSessions = 3;
        break;
      case TaskPriority.medium:
        baseSessions = 2;
        break;
      case TaskPriority.low:
        baseSessions = 1;
        break;
    }

    // Adjust for description length (complexity indicator)
    if (task.description != null && task.description!.length > 200) {
      baseSessions += 1;
    }

    return baseSessions;
  }

  int _estimateComplexTaskSessions(Task task) {
    int totalSessions = 0;

    // Count sessions for each subtask
    void countSubtaskSessions(Task t) {
      if (t.subtasks.isEmpty) {
        totalSessions += _estimateSimpleTaskSessions(t);
      } else {
        for (final subtask in t.subtasks) {
          countSubtaskSessions(subtask);
        }
      }
    }

    for (final subtask in task.subtasks) {
      countSubtaskSessions(subtask);
    }

    // Add buffer for coordination and overhead
    totalSessions = (totalSessions * 1.2).ceil();

    return totalSessions.clamp(2, 20); // Reasonable limits
  }

  List<PomodoroSession> _createSequentialPlan(Task task, int startOrder) {
    final sessionsList = <PomodoroSession>[];
    int order = startOrder;

    if (task.subtasks.isEmpty) {
      // Simple sequential plan
      final duration = calculateOptimalDuration(task);
      for (int i = 0; i < task.estimatedSessions; i++) {
        sessionsList.add(PomodoroSession(taskId: task.id, duration: duration, type: 'work', title: '${task.title} - Session ${i + 1}', order: order++));
      }
    } else {
      // Sequential plan through subtasks
      void addSubtaskSessions(Task t, String prefix) {
        if (t.subtasks.isEmpty) {
          final duration = calculateOptimalDuration(t);
          final sessions = t.estimatedSessions.clamp(1, 5);
          for (int i = 0; i < sessions; i++) {
            sessionsList.add(PomodoroSession(taskId: task.id, subtaskId: t.id, duration: duration, type: 'work', title: '$prefix - ${t.title}', order: order++));
          }
        } else {
          for (final subtask in t.subtasks) {
            addSubtaskSessions(subtask, '$prefix > ${subtask.title}');
          }
        }
      }

      for (final subtask in task.subtasks) {
        addSubtaskSessions(subtask, subtask.title);
      }
    }

    return sessionsList;
  }

  List<PomodoroSession> _createPriorityPlan(Task task, int startOrder) {
    final sessionsList = <PomodoroSession>[];
    int order = startOrder;

    // Get all subtasks and sort by priority
    final allSubtasks = <Task>[];
    void collectSubtasks(Task t) {
      if (t.subtasks.isEmpty) {
        allSubtasks.add(t);
      } else {
        for (final subtask in t.subtasks) {
          collectSubtasks(subtask);
        }
      }
    }

    if (task.subtasks.isNotEmpty) {
      collectSubtasks(task);
      allSubtasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));

      for (final subtask in allSubtasks) {
        final duration = calculateOptimalDuration(subtask);
        final sessions = subtask.estimatedSessions.clamp(1, 3);
        for (int i = 0; i < sessions; i++) {
          sessionsList.add(PomodoroSession(taskId: task.id, subtaskId: subtask.id, duration: duration, type: 'work', title: '${subtask.title} (Priority: ${subtask.priority.name})', order: order++));
        }
      }
    } else {
      // Single task, just create standard sessions
      final duration = calculateOptimalDuration(task);
      for (int i = 0; i < task.estimatedSessions; i++) {
        sessionsList.add(PomodoroSession(taskId: task.id, duration: duration, type: 'work', title: '${task.title} - Priority Session ${i + 1}', order: order++));
      }
    }

    return sessionsList;
  }

  List<PomodoroSession> _createTimeBoxedPlan(Task task, int startOrder) {
    final sessionsList = <PomodoroSession>[];
    int order = startOrder;

    // Fixed time per session approach
    final fixedDuration = 25; // Standard pomodoro
    final totalSessionsNeeded = estimateSessionsNeeded(task);

    if (task.subtasks.isEmpty) {
      for (int i = 0; i < totalSessionsNeeded; i++) {
        sessionsList.add(PomodoroSession(taskId: task.id, duration: fixedDuration, type: 'work', title: '${task.title} - Time Box ${i + 1}', order: order++));
      }
    } else {
      // Distribute time evenly among subtasks
      final subtasks = <Task>[];
      void collectSubtasks(Task t) {
        if (t.subtasks.isEmpty) {
          subtasks.add(t);
        } else {
          for (final subtask in t.subtasks) {
            collectSubtasks(subtask);
          }
        }
      }

      collectSubtasks(task);

      final sessionsPerSubtask = (totalSessionsNeeded / subtasks.length).ceil();
      for (final subtask in subtasks) {
        for (int i = 0; i < sessionsPerSubtask; i++) {
          sessionsList.add(PomodoroSession(taskId: task.id, subtaskId: subtask.id, duration: fixedDuration, type: 'work', title: '${subtask.title} - Time Box ${i + 1}', order: order++));
        }
      }
    }

    return sessionsList;
  }

  List<PomodoroSession> _createFlexiblePlan(Task task, int startOrder) {
    final sessionsList = <PomodoroSession>[];
    int order = startOrder;

    // Create a flexible plan with options
    final duration = calculateOptimalDuration(task);

    // Create a few focused session options
    sessionsList.add(PomodoroSession(taskId: task.id, duration: duration, type: 'work', title: '${task.title} - Focus Session', description: 'Deep work on the most important aspect', order: order++));

    if (task.estimatedSessions > 1) {
      sessionsList.add(PomodoroSession(taskId: task.id, duration: (duration * 0.75).round(), type: 'work', title: '${task.title} - Quick Progress', description: 'Make progress on any part of the task', order: order++));
    }

    if (task.subtasks.isNotEmpty) {
      sessionsList.add(PomodoroSession(taskId: task.id, duration: (duration * 0.5).round(), type: 'work', title: '${task.title} - Subtask Review', description: 'Review and organize subtasks', order: order++));
    }

    return sessionsList;
  }

  int _countAllSubtasks(Task task) {
    int subtaskCount = 0;
    void countSubtasks(Task t) {
      subtaskCount += t.subtasks.length;
      for (var subtask in t.subtasks) {
        countSubtasks(subtask);
      }
    }

    countSubtasks(task);
    return subtaskCount;
  }

  List<String> _generateRecommendations(Task task, double sessionAccuracy, double avgDuration) {
    final recommendations = <String>[];

    if (sessionAccuracy < 80) {
      if (sessionAccuracy < 50) {
        recommendations.add('Task took significantly more sessions than estimated. Consider breaking down large tasks more.');
      } else {
        recommendations.add('Task took more sessions than estimated. Refine estimation for similar tasks.');
      }
    } else if (sessionAccuracy > 120) {
      recommendations.add('Task was completed faster than estimated. Consider reducing estimates for similar tasks.');
    }

    if (avgDuration < 20) {
      recommendations.add('Sessions were shorter than usual. Consider if tasks were interrupted or if estimates need adjustment.');
    } else if (avgDuration > 35) {
      recommendations.add('Sessions were longer than typical. Consider if task complexity was underestimated.');
    }

    if (task.subtasks.isNotEmpty && task.subtasks.length > 5) {
      recommendations.add('Task has many subtasks. Consider using priority strategy to focus on important items first.');
    }

    return recommendations;
  }
}
