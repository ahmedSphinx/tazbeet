import '../models/task.dart';

class SmartTaskSelector {
  final List<Task> _allTasks;
  final DateTime _currentTime;

  SmartTaskSelector({required List<Task> allTasks, DateTime? currentTime}) : _allTasks = allTasks, _currentTime = currentTime ?? DateTime.now();

  /// Auto-suggest tasks based on multiple factors
  Task? suggestNextTask({int maxSuggestions = 5}) {
    final eligibleTasks = _getEligibleTasks();

    if (eligibleTasks.isEmpty) return null;

    // Score each task based on multiple factors
    final scoredTasks = eligibleTasks.map((task) {
      final score = _calculateTaskScore(task);
      return MapEntry(task, score);
    }).toList();

    // Sort by score (highest first)
    scoredTasks.sort((a, b) => b.value.compareTo(a.value));

    return scoredTasks.first.key;
  }

  /// Get top N task suggestions with scores
  List<MapEntry<Task, double>> getTopSuggestions({int maxSuggestions = 5}) {
    final eligibleTasks = _getEligibleTasks();

    if (eligibleTasks.isEmpty) return [];

    final scoredTasks = eligibleTasks.map((task) {
      final score = _calculateTaskScore(task);
      return MapEntry(task, score);
    }).toList();

    scoredTasks.sort((a, b) => b.value.compareTo(a.value));

    return scoredTasks.take(maxSuggestions).toList();
  }

  /// Break down large tasks into pomodoro-sized subtasks
  List<Task> createPomodoroSubtasks(Task largeTask) {
    if (largeTask.subtasks.isNotEmpty) {
      // Task already has subtasks, return them
      return largeTask.subtasks;
    }

    final subtasks = <Task>[];
    final title = largeTask.title;

    // Analyze task title and description to determine breakdown strategy
    if (title.toLowerCase().contains('research') || (largeTask.description?.toLowerCase().contains('research') ?? false)) {
      subtasks.addAll(_createResearchSubtasks(largeTask));
    } else if (title.toLowerCase().contains('write') || title.toLowerCase().contains('report') || (largeTask.description?.toLowerCase().contains('write') ?? false)) {
      subtasks.addAll(_createWritingSubtasks(largeTask));
    } else if (title.toLowerCase().contains('review') || title.toLowerCase().contains('check') || (largeTask.description?.toLowerCase().contains('review') ?? false)) {
      subtasks.addAll(_createReviewSubtasks(largeTask));
    } else {
      // Generic breakdown
      subtasks.addAll(_createGenericSubtasks(largeTask));
    }

    return subtasks;
  }

  /// Get tasks that need work based on due date proximity
  List<Task> getUrgentTasks({int daysAhead = 3}) {
    final cutoffDate = _currentTime.add(Duration(days: daysAhead));

    return _allTasks.where((task) {
      if (task.isCompleted || task.dueDate == null) return false;
      return task.dueDate!.isBefore(cutoffDate);
    }).toList();
  }

  /// Get tasks that are overdue
  List<Task> getOverdueTasks() {
    return _allTasks.where((task) {
      if (task.isCompleted || task.dueDate == null) return false;
      return task.dueDate!.isBefore(_currentTime);
    }).toList();
  }

  /// Get tasks that haven't been worked on recently
  List<Task> getStaleTasks({int daysSinceLastWork = 7}) {
    final cutoffDate = _currentTime.subtract(Duration(days: daysSinceLastWork));

    return _allTasks.where((task) {
      if (task.isCompleted) return false;
      if (task.lastPomodoroDate == null) return true; // Never worked on
      return task.lastPomodoroDate!.isBefore(cutoffDate);
    }).toList();
  }

  /// Get tasks that are behind on their daily session goals
  List<Task> getTasksBehindDailyGoal() {
    return _allTasks.where((task) {
      if (task.isCompleted) return false;

      // Check if task has daily goal and is behind
      if (task.targetSessionsPerDay > 0) {
        final today = DateTime(_currentTime.year, _currentTime.month, _currentTime.day);
        final sessionsToday = task.pomodoroSessions.where((session) {
          final sessionDate = DateTime.fromMillisecondsSinceEpoch(session['startTime'] ?? 0);
          return sessionDate.isAfter(today);
        }).length;

        return sessionsToday < task.targetSessionsPerDay;
      }

      return false;
    }).toList();
  }

  // Private helper methods

  List<Task> _getEligibleTasks() {
    return _allTasks.where((task) {
      // Must not be completed
      if (task.isCompleted) return false;

      // Must not be a subtask (we work on parent tasks)
      if (task.parentId != null) return false;

      // Must have due date in the future or no due date
      if (task.dueDate != null && task.dueDate!.isBefore(_currentTime)) {
        return false; // Overdue tasks get special handling elsewhere
      }

      return true;
    }).toList();
  }

  double _calculateTaskScore(Task task) {
    double score = 0.0;

    // Due date proximity (0-30 points)
    if (task.dueDate != null) {
      final daysUntilDue = task.dueDate!.difference(_currentTime).inDays;
      if (daysUntilDue <= 0) {
        score += 30; // Overdue or due today
      } else if (daysUntilDue <= 1) {
        score += 25;
      } else if (daysUntilDue <= 3) {
        score += 20;
      } else if (daysUntilDue <= 7) {
        score += 15;
      } else if (daysUntilDue <= 14) {
        score += 10;
      } else {
        score += 5;
      }
    }

    // Priority level (0-20 points)
    switch (task.priority) {
      case TaskPriority.high:
        score += 20;
        break;
      case TaskPriority.medium:
        score += 10;
        break;
      case TaskPriority.low:
        score += 5;
        break;
    }

    // Estimated effort vs available time (0-25 points)
    final estimatedSessions = task.estimatedSessions;
    if (estimatedSessions <= 1) {
      score += 25; // Quick tasks get priority for immediate work
    } else if (estimatedSessions <= 3) {
      score += 20;
    } else if (estimatedSessions <= 5) {
      score += 15;
    } else {
      score += 10;
    }

    // Recent work patterns (0-15 points)
    if (task.lastPomodoroDate == null) {
      score += 15; // Never worked on, prioritize starting
    } else {
      final daysSinceLastWork = _currentTime.difference(task.lastPomodoroDate!).inDays;
      if (daysSinceLastWork >= 7) {
        score += 10; // Stale task
      } else if (daysSinceLastWork >= 3) {
        score += 5;
      }
    }

    // Subtask dependencies (0-10 points)
    if (task.subtasks.isEmpty) {
      score += 10; // Simple tasks get priority
    } else {
      // Check if subtasks are blocking other tasks
      final hasBlockingSubtasks = task.subtasks.any((subtask) => _allTasks.any((otherTask) => otherTask.parentId == subtask.id && !otherTask.isCompleted));
      if (hasBlockingSubtasks) {
        score += 10;
      }
    }

    return score;
  }

  List<Task> _createResearchSubtasks(Task parentTask) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return [
      Task(id: '${parentTask.id}_research_1_$timestamp', title: 'Initial Research & Information Gathering', parentId: parentTask.id, createdAt: DateTime.now(), updatedAt: DateTime.now(), estimatedSessions: 1),
      Task(id: '${parentTask.id}_research_2_$timestamp', title: 'Deep Dive Analysis', parentId: parentTask.id, createdAt: DateTime.now(), updatedAt: DateTime.now(), estimatedSessions: 2),
      Task(id: '${parentTask.id}_research_3_$timestamp', title: 'Synthesize Findings', parentId: parentTask.id, createdAt: DateTime.now(), updatedAt: DateTime.now(), estimatedSessions: 1),
    ];
  }

  List<Task> _createWritingSubtasks(Task parentTask) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return [
      Task(id: '${parentTask.id}_writing_1_$timestamp', title: 'Outline & Structure', parentId: parentTask.id, createdAt: DateTime.now(), updatedAt: DateTime.now(), estimatedSessions: 1),
      Task(id: '${parentTask.id}_writing_2_$timestamp', title: 'First Draft', parentId: parentTask.id, createdAt: DateTime.now(), updatedAt: DateTime.now(), estimatedSessions: 2),
      Task(id: '${parentTask.id}_writing_3_$timestamp', title: 'Review & Edit', parentId: parentTask.id, createdAt: DateTime.now(), updatedAt: DateTime.now(), estimatedSessions: 1),
    ];
  }

  List<Task> _createReviewSubtasks(Task parentTask) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return [
      Task(id: '${parentTask.id}_review_1_$timestamp', title: 'Initial Review Pass', parentId: parentTask.id, createdAt: DateTime.now(), updatedAt: DateTime.now(), estimatedSessions: 1),
      Task(id: '${parentTask.id}_review_2_$timestamp', title: 'Detailed Analysis', parentId: parentTask.id, createdAt: DateTime.now(), updatedAt: DateTime.now(), estimatedSessions: 2),
      Task(id: '${parentTask.id}_review_3_$timestamp', title: 'Final Check & Recommendations', parentId: parentTask.id, createdAt: DateTime.now(), updatedAt: DateTime.now(), estimatedSessions: 1),
    ];
  }

  List<Task> _createGenericSubtasks(Task parentTask) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final estimatedSessions = parentTask.estimatedSessions;

    if (estimatedSessions <= 2) {
      // Small task, just break into planning and execution
      return [
        Task(id: '${parentTask.id}_generic_1_$timestamp', title: 'Planning & Preparation', parentId: parentTask.id, createdAt: DateTime.now(), updatedAt: DateTime.now(), estimatedSessions: 1),
        Task(id: '${parentTask.id}_generic_2_$timestamp', title: 'Execution', parentId: parentTask.id, createdAt: DateTime.now(), updatedAt: DateTime.now(), estimatedSessions: estimatedSessions - 1),
      ];
    } else {
      // Larger task, break into phases
      final sessionsPerPhase = (estimatedSessions / 3).ceil();
      return [
        Task(id: '${parentTask.id}_generic_1_$timestamp', title: 'Phase 1: Foundation', parentId: parentTask.id, createdAt: DateTime.now(), updatedAt: DateTime.now(), estimatedSessions: sessionsPerPhase),
        Task(id: '${parentTask.id}_generic_2_$timestamp', title: 'Phase 2: Development', parentId: parentTask.id, createdAt: DateTime.now(), updatedAt: DateTime.now(), estimatedSessions: sessionsPerPhase),
        Task(
          id: '${parentTask.id}_generic_3_$timestamp',
          title: 'Phase 3: Completion',
          parentId: parentTask.id,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          estimatedSessions: estimatedSessions - (sessionsPerPhase * 2),
        ),
      ];
    }
  }
}
