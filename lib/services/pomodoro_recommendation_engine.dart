import '../models/task.dart';
import '../models/pomodoro_plan.dart';
import 'app_logging_service.dart';

/// Break activity types for pomodoro breaks
enum BreakActivity { meditation, stretching, hydration, eyeRest, walking, breathing, music, social }

/// Energy level assessment
enum EnergyLevel { veryLow, low, medium, high, veryHigh }

/// Focus pattern type
enum FocusPattern { morningPeak, afternoonSteady, eveningDecline, nightOwl, irregular }

/// AI-powered recommendation engine for pomodoro workflow optimization
class PomodoroRecommendationEngine {
  /// Suggest tasks based on current time, energy levels, and user patterns
  List<Task> suggestTasksForCurrentTime(List<Task> availableTasks, {EnergyLevel? currentEnergy, FocusPattern? focusPattern, List<CompletedPomodoroSession>? sessionHistory}) {
    AppLogging.logInfo('Generating task recommendations for current time', name: 'PomodoroRecommendationEngine');

    final now = DateTime.now();
    final hour = now.hour;

    // Determine optimal task characteristics based on time
    final TaskCharacteristics optimalChars = _getOptimalTaskCharacteristics(hour, currentEnergy ?? _estimateEnergyLevel(hour), focusPattern ?? _detectFocusPattern(sessionHistory));

    // Score and rank tasks based on optimal characteristics
    final scoredTasks = availableTasks.map((task) {
      final score = _calculateTaskScore(task, optimalChars, sessionHistory);
      return MapEntry(task, score);
    }).toList();

    // Sort by score (descending) and return top recommendations
    scoredTasks.sort((a, b) => b.value.compareTo(a.value));

    final recommendations = scoredTasks
        .take(5) // Top 5 recommendations
        .map((entry) => entry.key)
        .toList();

    AppLogging.logInfo('Generated ${recommendations.length} task recommendations', name: 'PomodoroRecommendationEngine');
    return recommendations;
  }

  /// Recommend task order for maximum productivity
  List<Task> optimizeTaskOrder(List<Task> tasks, {List<CompletedPomodoroSession>? sessionHistory, bool prioritizeHighEnergy = true}) {
    if (tasks.isEmpty) return [];

    AppLogging.logInfo('Optimizing task order for ${tasks.length} tasks', name: 'PomodoroRecommendationEngine');

    // Calculate productivity scores for each task
    final taskScores = <Task, double>{};

    for (final task in tasks) {
      final score = _calculateProductivityScore(task, sessionHistory);
      taskScores[task] = score;
    }

    // Sort tasks by productivity score
    final sortedTasks = List<Task>.from(tasks);
    sortedTasks.sort((a, b) => taskScores[b]!.compareTo(taskScores[a]!));

    // Apply energy-based ordering if requested
    if (prioritizeHighEnergy) {
      return _applyEnergyBasedOrdering(sortedTasks, sessionHistory);
    }

    return sortedTasks;
  }

  /// Suggest break activities based on task type and performance
  BreakActivity suggestBreakActivity(Task? completedTask, {int? sessionDuration, int? focusRating, bool wasProductive = true}) {
    AppLogging.logInfo('Suggesting break activity', name: 'PomodoroRecommendationEngine');

    // Analyze task characteristics and session performance
    final TaskType taskType = _classifyTaskType(completedTask);
    final SessionIntensity intensity = _assessSessionIntensity(sessionDuration ?? 25, focusRating ?? 5, completedTask?.focusScore ?? 5);

    // Select appropriate break activity
    return _selectBreakActivity(taskType, intensity, wasProductive);
  }

  /// Analyze user's focus patterns and provide insights
  FocusPattern analyzeFocusPatterns(List<CompletedPomodoroSession> sessions) {
    if (sessions.isEmpty) {
      return FocusPattern.irregular;
    }

    AppLogging.logInfo('Analyzing focus patterns from ${sessions.length} sessions', name: 'PomodoroRecommendationEngine');

    // Group sessions by hour of day
    final hourlyPerformance = <int, List<int>>{};
    for (final session in sessions) {
      final hour = session.startTime.hour;
      hourlyPerformance.putIfAbsent(hour, () => []).add(session.focusRating);
    }

    // Calculate average performance by hour
    final hourlyAverages = <int, double>{};
    for (final entry in hourlyPerformance.entries) {
      final average = entry.value.reduce((a, b) => a + b) / entry.value.length;
      hourlyAverages[entry.key] = average;
    }

    // Detect pattern
    return _detectFocusPatternFromHourlyData(hourlyAverages);
  }

  /// Get personalized session duration recommendations
  int recommendSessionDuration(Task task, {List<CompletedPomodoroSession>? recentSessions, EnergyLevel? currentEnergy}) {
    AppLogging.logInfo('Recommending session duration for task: ${task.title}', name: 'PomodoroRecommendationEngine');

    int baseDuration = 25; // Default pomodoro duration

    // Adjust based on task characteristics
    baseDuration = _adjustDurationForTask(baseDuration, task);

    // Adjust based on recent performance
    if (recentSessions != null && recentSessions.isNotEmpty) {
      baseDuration = _adjustDurationForPerformance(baseDuration, recentSessions);
    }

    // Adjust based on current energy level
    if (currentEnergy != null) {
      baseDuration = _adjustDurationForEnergy(baseDuration, currentEnergy);
    }

    return baseDuration.clamp(15, 50); // Keep within reasonable bounds
  }

  /// Predict optimal work time for specific task types
  DateTime? suggestOptimalWorkTime(Task task, {List<CompletedPomodoroSession>? sessionHistory}) {
    AppLogging.logInfo('Suggesting optimal work time for task: ${task.title}', name: 'PomodoroRecommendationEngine');

    final taskType = _classifyTaskType(task);
    final focusPattern = sessionHistory != null ? analyzeFocusPatterns(sessionHistory) : FocusPattern.irregular;

    return _calculateOptimalWorkTime(taskType, focusPattern);
  }

  // Private helper methods

  TaskCharacteristics _getOptimalTaskCharacteristics(int hour, EnergyLevel energy, FocusPattern pattern) {
    return TaskCharacteristics(
      preferredPriority: _getPreferredPriority(hour, energy),
      preferredFocusScore: _getPreferredFocusScore(hour, energy),
      maxComplexity: _getMaxComplexity(hour, energy),
      preferredDuration: _getPreferredDuration(hour, energy),
    );
  }

  double _calculateTaskScore(Task task, TaskCharacteristics optimal, List<CompletedPomodoroSession>? history) {
    double score = 0.0;

    // Priority matching
    final priorityScore = _matchPriority(task.priority, optimal.preferredPriority);
    score += priorityScore * 0.3;

    // Focus score matching
    final focusScore = _matchFocusScore(task.focusScore, optimal.preferredFocusScore);
    score += focusScore * 0.25;

    // Complexity assessment
    final complexityScore = _assessComplexity(task, optimal.maxComplexity, history);
    score += complexityScore * 0.2;

    // Due date urgency
    final urgencyScore = _calculateUrgencyScore(task);
    score += urgencyScore * 0.15;

    // Historical performance bonus
    final performanceBonus = _calculatePerformanceBonus(task, history);
    score += performanceBonus * 0.1;

    return score;
  }

  double _calculateProductivityScore(Task task, List<CompletedPomodoroSession>? history) {
    double score = 0.0;

    // Base score from priority
    score += task.priority.index * 2.0;

    // Focus difficulty factor
    score += (11 - task.focusScore) * 0.5;

    // Historical performance
    if (history != null) {
      final taskHistory = history.where((s) => s.taskId == task.id).toList();
      if (taskHistory.isNotEmpty) {
        final avgFocus = taskHistory.map((s) => s.focusRating).reduce((a, b) => a + b) / taskHistory.length;
        final completionRate = taskHistory.where((s) => s.completed).length / taskHistory.length;
        score += avgFocus * 0.3;
        score += completionRate * 20.0;
      }
    }

    return score;
  }

  List<Task> _applyEnergyBasedOrdering(List<Task> tasks, List<CompletedPomodoroSession>? history) {
    final now = DateTime.now();
    final currentEnergy = _estimateEnergyLevel(now.hour);

    // Separate tasks by energy requirements
    final highEnergyTasks = <Task>[];
    final mediumEnergyTasks = <Task>[];
    final lowEnergyTasks = <Task>[];

    for (final task in tasks) {
      if (task.focusScore >= 8) {
        highEnergyTasks.add(task);
      } else if (task.focusScore >= 5) {
        mediumEnergyTasks.add(task);
      } else {
        lowEnergyTasks.add(task);
      }
    }

    // Order based on current energy level
    switch (currentEnergy) {
      case EnergyLevel.veryHigh:
      case EnergyLevel.high:
        return [...highEnergyTasks, ...mediumEnergyTasks, ...lowEnergyTasks];
      case EnergyLevel.medium:
        return [...mediumEnergyTasks, ...highEnergyTasks, ...lowEnergyTasks];
      case EnergyLevel.low:
      case EnergyLevel.veryLow:
        return [...lowEnergyTasks, ...mediumEnergyTasks, ...highEnergyTasks];
    }
  }

  TaskType _classifyTaskType(Task? task) {
    if (task == null) return TaskType.general;

    // Classify based on task characteristics
    if (task.focusScore >= 8) {
      return TaskType.deepWork;
    } else if (task.priority == TaskPriority.high) {
      return TaskType.urgent;
    } else if (task.description != null && task.description!.length > 100) {
      return TaskType.complex;
    } else if (task.subtasks.isNotEmpty) {
      return TaskType.multiStep;
    } else {
      return TaskType.general;
    }
  }

  SessionIntensity _assessSessionIntensity(int duration, int focusRating, int taskFocusScore) {
    final avgRating = (focusRating + taskFocusScore) / 2;

    if (duration >= 45 && avgRating >= 8) {
      return SessionIntensity.veryHigh;
    } else if (duration >= 30 && avgRating >= 6) {
      return SessionIntensity.high;
    } else if (duration <= 20 && avgRating <= 4) {
      return SessionIntensity.low;
    } else {
      return SessionIntensity.medium;
    }
  }

  BreakActivity _selectBreakActivity(TaskType taskType, SessionIntensity intensity, bool wasProductive) {
    // Activity selection matrix
    switch (taskType) {
      case TaskType.deepWork:
        return intensity == SessionIntensity.veryHigh ? BreakActivity.meditation : BreakActivity.eyeRest;

      case TaskType.urgent:
        return wasProductive ? BreakActivity.hydration : BreakActivity.breathing;

      case TaskType.complex:
        return BreakActivity.stretching;

      case TaskType.multiStep:
        return BreakActivity.walking;

      case TaskType.general:
        return _selectGeneralBreakActivity(intensity, wasProductive);
    }
  }

  BreakActivity _selectGeneralBreakActivity(SessionIntensity intensity, bool wasProductive) {
    if (intensity == SessionIntensity.veryHigh) {
      return BreakActivity.meditation;
    } else if (intensity == SessionIntensity.high) {
      return wasProductive ? BreakActivity.music : BreakActivity.eyeRest;
    } else if (intensity == SessionIntensity.low) {
      return BreakActivity.walking;
    } else {
      return BreakActivity.hydration;
    }
  }

  // Additional helper methods for energy, pattern detection, etc.
  EnergyLevel _estimateEnergyLevel(int hour) {
    if (hour >= 9 && hour <= 11) return EnergyLevel.high;
    if (hour >= 14 && hour <= 16) return EnergyLevel.medium;
    if (hour >= 20 || hour <= 6) return EnergyLevel.low;
    return EnergyLevel.medium;
  }

  FocusPattern _detectFocusPattern(List<CompletedPomodoroSession>? sessions) {
    if (sessions == null || sessions.isEmpty) return FocusPattern.irregular;

    // Simple pattern detection based on session times
    final morningSessions = sessions.where((s) => s.startTime.hour >= 6 && s.startTime.hour < 12).toList();
    final afternoonSessions = sessions.where((s) => s.startTime.hour >= 12 && s.startTime.hour < 18).toList();
    final eveningSessions = sessions.where((s) => s.startTime.hour >= 18 && s.startTime.hour < 22).toList();

    if (morningSessions.isNotEmpty && morningSessions.every((s) => s.focusRating >= 7)) {
      return FocusPattern.morningPeak;
    } else if (afternoonSessions.isNotEmpty && afternoonSessions.every((s) => s.focusRating >= 6)) {
      return FocusPattern.afternoonSteady;
    } else if (eveningSessions.isNotEmpty && eveningSessions.every((s) => s.focusRating <= 5)) {
      return FocusPattern.eveningDecline;
    } else {
      return FocusPattern.irregular;
    }
  }

  FocusPattern _detectFocusPatternFromHourlyData(Map<int, double> hourlyAverages) {
    if (hourlyAverages.isEmpty) return FocusPattern.irregular;

    // Find peak performance hours
    final sortedHours = hourlyAverages.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    final peakHour = sortedHours.first.key;

    if (peakHour >= 6 && peakHour < 12) {
      return FocusPattern.morningPeak;
    } else if (peakHour >= 12 && peakHour < 18) {
      return FocusPattern.afternoonSteady;
    } else if (peakHour >= 18 && peakHour < 22) {
      return FocusPattern.eveningDecline;
    } else {
      return FocusPattern.nightOwl;
    }
  }

  // Additional helper methods for priority matching, focus scoring, etc.
  double _matchPriority(TaskPriority taskPriority, TaskPriority preferredPriority) {
    if (taskPriority == preferredPriority) return 1.0;
    if ((taskPriority.index - preferredPriority.index).abs() == 1) return 0.7;
    return 0.3;
  }

  double _matchFocusScore(int taskFocus, int preferredFocus) {
    final difference = (taskFocus - preferredFocus).abs();
    return 1.0 - (difference / 10.0);
  }

  double _assessComplexity(Task task, int maxComplexity, List<CompletedPomodoroSession>? history) {
    double complexity = 0.0;

    // Description length complexity
    if (task.description != null) {
      complexity += (task.description!.length / 100.0).clamp(0.0, 1.0);
    }

    // Subtask complexity
    if (task.subtasks.isNotEmpty) {
      complexity += (task.subtasks.length / 5.0).clamp(0.0, 1.0);
    }

    // Priority complexity
    complexity += task.priority.index / 2.0;

    return 1.0 - (complexity / maxComplexity).clamp(0.0, 1.0);
  }

  double _calculateUrgencyScore(Task task) {
    if (task.dueDate == null) return 0.0;

    final now = DateTime.now();
    final hoursUntilDue = task.dueDate!.difference(now).inHours;

    if (hoursUntilDue <= 0) return 1.0;
    if (hoursUntilDue <= 24) return 0.8;
    if (hoursUntilDue <= 72) return 0.6;
    if (hoursUntilDue <= 168) return 0.4;
    return 0.2;
  }

  double _calculatePerformanceBonus(Task task, List<CompletedPomodoroSession>? history) {
    if (history == null || history.isEmpty) return 0.0;

    final taskHistory = history.where((s) => s.taskId == task.id).toList();
    if (taskHistory.isEmpty) return 0.0;

    final avgFocus = taskHistory.map((s) => s.focusRating).reduce((a, b) => a + b) / taskHistory.length;
    final completionRate = taskHistory.where((s) => s.completed).length / taskHistory.length;

    return (avgFocus / 10.0) * 0.5 + completionRate * 0.5;
  }

  // Additional helper methods for duration adjustment, optimal time calculation
  int _adjustDurationForTask(int baseDuration, Task task) {
    if (task.focusScore >= 8) {
      return (baseDuration * 1.2).round();
    } else if (task.focusScore <= 3) {
      return (baseDuration * 0.8).round();
    }
    return baseDuration;
  }

  int _adjustDurationForPerformance(int baseDuration, List<CompletedPomodoroSession> sessions) {
    if (sessions.length < 3) return baseDuration;

    final recentSessions = sessions.take(3).toList();
    final avgFocus = recentSessions.map((s) => s.focusRating).reduce((a, b) => a + b) / recentSessions.length;

    if (avgFocus >= 8) {
      return (baseDuration * 1.1).round();
    } else if (avgFocus <= 4) {
      return (baseDuration * 0.9).round();
    }
    return baseDuration;
  }

  int _adjustDurationForEnergy(int baseDuration, EnergyLevel energy) {
    switch (energy) {
      case EnergyLevel.veryHigh:
        return (baseDuration * 1.3).round();
      case EnergyLevel.high:
        return (baseDuration * 1.1).round();
      case EnergyLevel.medium:
        return baseDuration;
      case EnergyLevel.low:
        return (baseDuration * 0.8).round();
      case EnergyLevel.veryLow:
        return (baseDuration * 0.6).round();
    }
  }

  DateTime? _calculateOptimalWorkTime(TaskType taskType, FocusPattern pattern) {
    final now = DateTime.now();

    switch (pattern) {
      case FocusPattern.morningPeak:
        return DateTime(now.year, now.month, now.day, 9, 0);
      case FocusPattern.afternoonSteady:
        return DateTime(now.year, now.month, now.day, 14, 0);
      case FocusPattern.eveningDecline:
        return DateTime(now.year, now.month, now.day, 16, 0);
      case FocusPattern.nightOwl:
        return DateTime(now.year, now.month, now.day, 20, 0);
      case FocusPattern.irregular:
        return DateTime(now.year, now.month, now.day, 10, 0); // Default
    }
  }

  // Additional helper methods for task characteristics
  TaskPriority _getPreferredPriority(int hour, EnergyLevel energy) {
    switch (energy) {
      case EnergyLevel.veryHigh:
      case EnergyLevel.high:
        return TaskPriority.high;
      case EnergyLevel.medium:
        return hour >= 14 && hour <= 16 ? TaskPriority.medium : TaskPriority.high;
      case EnergyLevel.low:
      case EnergyLevel.veryLow:
        return TaskPriority.low;
    }
  }

  int _getPreferredFocusScore(int hour, EnergyLevel energy) {
    switch (energy) {
      case EnergyLevel.veryHigh:
        return 9;
      case EnergyLevel.high:
        return 7;
      case EnergyLevel.medium:
        return 5;
      case EnergyLevel.low:
        return 3;
      case EnergyLevel.veryLow:
        return 1;
    }
  }

  int _getMaxComplexity(int hour, EnergyLevel energy) {
    switch (energy) {
      case EnergyLevel.veryHigh:
        return 10;
      case EnergyLevel.high:
        return 8;
      case EnergyLevel.medium:
        return 6;
      case EnergyLevel.low:
        return 4;
      case EnergyLevel.veryLow:
        return 2;
    }
  }

  int _getPreferredDuration(int hour, EnergyLevel energy) {
    switch (energy) {
      case EnergyLevel.veryHigh:
        return 45;
      case EnergyLevel.high:
        return 35;
      case EnergyLevel.medium:
        return 25;
      case EnergyLevel.low:
        return 20;
      case EnergyLevel.veryLow:
        return 15;
    }
  }
}

// Supporting classes and enums
class TaskCharacteristics {
  final TaskPriority preferredPriority;
  final int preferredFocusScore;
  final int maxComplexity;
  final int preferredDuration;

  TaskCharacteristics({required this.preferredPriority, required this.preferredFocusScore, required this.maxComplexity, required this.preferredDuration});
}

enum TaskType { deepWork, urgent, complex, multiStep, general }

enum SessionIntensity { low, medium, high, veryHigh }
