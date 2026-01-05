import '../models/task.dart';
import 'enhanced_progress.dart';
import 'adaptive_pomodoro.dart';

class TaskAnalytics {
  final List<Task> _allTasks;
  final ProgressTracker _progressTracker;
  final AdaptivePomodoro _adaptivePomodoro;

  TaskAnalytics({required List<Task> allTasks, required ProgressTracker progressTracker, required AdaptivePomodoro adaptivePomodoro})
    : _allTasks = allTasks,
      _progressTracker = progressTracker,
      _adaptivePomodoro = adaptivePomodoro;

  /// Predict completion date based on current pace
  DateTime? predictCompletionDate(Task task) {
    if (task.isCompleted) return task.updatedAt;

    final progress = _progressTracker.calculateProgress(task);
    final currentPace = _calculateCurrentPace(task);

    if (currentPace <= 0) return null;

    final remainingWork = 1.0 - progress.completionProgress;
    final estimatedDays = remainingWork / currentPace;

    return DateTime.now().add(Duration(days: estimatedDays.ceil()));
  }

  /// Suggest optimal work schedule
  List<PomodoroSlot> suggestSchedule(List<Task> tasks, {int daysAhead = 7}) {
    final schedule = <PomodoroSlot>[];
    final now = DateTime.now();

    // Sort tasks by priority and predicted completion
    final sortedTasks = List<Task>.from(tasks);
    sortedTasks.sort((a, b) {
      final priorityComparison = b.priority.index.compareTo(a.priority.index);
      if (priorityComparison != 0) return priorityComparison;

      final aPrediction = predictCompletionDate(a);
      final bPrediction = predictCompletionDate(b);

      if (aPrediction == null && bPrediction == null) return 0;
      if (aPrediction == null) return 1;
      if (bPrediction == null) return -1;

      return aPrediction.compareTo(bPrediction);
    });

    // Generate optimal work times
    final optimalHours = _adaptivePomodoro.getOptimalSessionTimes();

    for (int day = 0; day < daysAhead; day++) {
      final currentDate = now.add(Duration(days: day));

      for (final hour in optimalHours) {
        final slotTime = DateTime(currentDate.year, currentDate.month, currentDate.day, hour);

        if (tasks.isNotEmpty) {
          final task = _selectBestTaskForSlot(sortedTasks, slotTime);
          if (task != null) {
            schedule.add(PomodoroSlot(startTime: slotTime, task: task, duration: _adaptivePomodoro.calculateOptimalDuration(task), priority: task.priority));

            sortedTasks.remove(task); // Remove to avoid double scheduling
          }
        }
      }
    }

    return schedule;
  }

  /// Identify tasks that are blocking others
  List<Task> findBlockingTasks() {
    final blockingTasks = <Task>[];

    for (final task in _allTasks) {
      if (task.isCompleted) continue;

      // Check if this task has subtasks that are blocking other tasks
      final hasBlockingSubtasks = task.subtasks.any((subtask) {
        return _allTasks.any((otherTask) => otherTask.parentId == subtask.id && !otherTask.isCompleted);
      });

      if (hasBlockingSubtasks) {
        blockingTasks.add(task);
      }
    }

    return blockingTasks;
  }

  /// Get productivity insights
  Map<String, dynamic> getProductivityInsights() {
    final insights = <String, dynamic>{};

    // Overall completion rate
    final completedTasks = _allTasks.where((t) => t.isCompleted).length;
    insights['overallCompletionRate'] = completedTasks / _allTasks.length;

    // Average time per task
    final tasksWithTime = _allTasks.where((t) => t.timeSpent.inMinutes > 0).toList();
    if (tasksWithTime.isNotEmpty) {
      final avgTime = tasksWithTime.map((t) => t.timeSpent.inMinutes).reduce((a, b) => a + b) / tasksWithTime.length;
      insights['averageTimePerTask'] = avgTime.round();
    }

    // Task distribution by priority
    final priorityDistribution = <String, int>{};
    for (final task in _allTasks) {
      final priority = task.priority.name;
      priorityDistribution[priority] = (priorityDistribution[priority] ?? 0) + 1;
    }
    insights['priorityDistribution'] = priorityDistribution;

    // Most productive hours (from adaptive pomodoro)
    insights['mostProductiveHours'] = _adaptivePomodoro.getOptimalSessionTimes();

    // Task type performance
    insights['taskTypePerformance'] = _analyzeTaskTypePerformance();

    return insights;
  }

  /// Get burnout risk assessment
  BurnoutRisk assessBurnoutRisk() {
    double riskScore = 0.0;
    final factors = <String>[];

    // Check workload intensity
    final recentSessions = _getRecentSessionCount(days: 7);
    if (recentSessions > 35) {
      // More than 5 sessions per day
      riskScore += 0.3;
      factors.add('High workload intensity');
    }

    // Check work-life balance
    final weekendSessions = _getWeekendSessionCount();
    final totalSessions = _getRecentSessionCount(days: 14);
    if (totalSessions > 0 && weekendSessions / totalSessions > 0.3) {
      riskScore += 0.2;
      factors.add('High weekend work frequency');
    }

    // Check session length patterns
    final avgSessionLength = _getAverageSessionLength();
    if (avgSessionLength > 45) {
      riskScore += 0.2;
      factors.add('Long work sessions');
    }

    // Check break patterns
    final breakRatio = _getBreakRatio();
    if (breakRatio < 0.15) {
      // Less than 15% break time
      riskScore += 0.3;
      factors.add('Insufficient breaks');
    }

    BurnoutRiskLevel level;
    if (riskScore >= 0.7) {
      level = BurnoutRiskLevel.high;
    } else if (riskScore >= 0.4) {
      level = BurnoutRiskLevel.medium;
    } else {
      level = BurnoutRiskLevel.low;
    }

    return BurnoutRisk(score: riskScore, level: level, factors: factors, recommendations: _generateBurnoutRecommendations(level, factors));
  }

  /// Get task completion predictions
  Map<String, dynamic> getCompletionPredictions() {
    final predictions = <String, dynamic>{};

    // Predict completion for all incomplete tasks
    final incompleteTasks = _allTasks.where((t) => !t.isCompleted).toList();
    final taskPredictions = <String, DateTime?>{};

    for (final task in incompleteTasks) {
      taskPredictions[task.id] = predictCompletionDate(task);
    }

    predictions['taskPredictions'] = taskPredictions;

    // Overall workload forecast
    final weeklyForecast = _calculateWeeklyForecast(incompleteTasks);
    predictions['weeklyForecast'] = weeklyForecast;

    // Risk analysis
    final overdueTasks = incompleteTasks.where((t) => t.dueDate != null && t.dueDate!.isBefore(DateTime.now())).toList();

    final atRiskTasks = incompleteTasks.where((t) {
      final prediction = predictCompletionDate(t);
      return prediction != null && t.dueDate != null && prediction.isAfter(t.dueDate!);
    }).toList();

    predictions['riskAnalysis'] = {'overdueCount': overdueTasks.length, 'atRiskCount': atRiskTasks.length, 'overdueTasks': overdueTasks.map((t) => t.id).toList(), 'atRiskTasks': atRiskTasks.map((t) => t.id).toList()};

    return predictions;
  }

  /// Get efficiency recommendations
  List<String> getEfficiencyRecommendations() {
    final recommendations = <String>[];

    // Analyze task completion patterns
    final longRunningTasks = _allTasks
        .where(
          (t) =>
              !t.isCompleted &&
              t.timeSpent.inMinutes > 120 && // More than 2 hours
              t.getCompletionProgress() < 0.5,
        )
        .toList();

    if (longRunningTasks.isNotEmpty) {
      recommendations.add('Consider breaking down tasks that are taking longer than expected');
    }

    // Analyze session patterns
    final avgSessionsPerTask = _allTasks.isEmpty ? 0.0 : _allTasks.map((t) => t.pomodoroCount).reduce((a, b) => a + b) / _allTasks.length;

    if (avgSessionsPerTask > 8) {
      recommendations.add('Tasks are requiring many sessions. Consider improving task estimation');
    }

    // Analyze priority handling
    final highPriorityTasks = _allTasks.where((t) => t.priority == TaskPriority.high).toList();
    final incompleteHighPriority = highPriorityTasks.where((t) => !t.isCompleted).length;

    if (incompleteHighPriority > 3) {
      recommendations.add('Focus on completing high-priority tasks to reduce workload');
    }

    // Analyze work patterns
    final workPatternInsights = _adaptivePomodoro.getWorkPatternInsights();
    if (workPatternInsights['sessionConsistency'] == 'Low') {
      recommendations.add('Work on maintaining consistent session lengths for better focus');
    }

    return recommendations;
  }

  // Private helper methods

  double _calculateCurrentPace(Task task) {
    if (task.pomodoroSessions.isEmpty) return 0.0;

    // Calculate pace based on recent sessions
    final recentSessions = task.pomodoroSessions.where((session) {
      final sessionTime = DateTime.fromMillisecondsSinceEpoch(session['startTime'] ?? 0);
      return DateTime.now().difference(sessionTime).inDays <= 7;
    }).toList();

    if (recentSessions.isEmpty) return 0.0;

    // Calculate progress per day
    final progressPerSession = task.getCompletionProgress() / task.pomodoroSessions.length;
    final sessionsPerDay = recentSessions.length / 7.0;

    return progressPerSession * sessionsPerDay;
  }

  Task? _selectBestTaskForSlot(List<Task> tasks, DateTime slotTime) {
    // Score tasks based on multiple factors
    Task? bestTask;
    double bestScore = 0.0;

    for (final task in tasks) {
      double score = 0.0;

      // Priority factor
      score += task.priority.index * 10;

      // Due date factor
      if (task.dueDate != null) {
        final daysUntilDue = task.dueDate!.difference(slotTime).inDays;
        if (daysUntilDue <= 0) {
          score += 50; // Overdue or due today
        } else if (daysUntilDue <= 3) {
          score += 30;
        } else if (daysUntilDue <= 7) {
          score += 15;
        }
      }

      // Energy level factor (time of day)
      final hour = slotTime.hour;
      if (hour >= 9 && hour <= 11) {
        score += 10; // Morning productivity
      } else if (hour >= 14 && hour <= 16) {
        score += 5; // Afternoon productivity
      }

      // Task complexity factor
      if (task.estimatedSessions <= 2) {
        score += 5; // Quick tasks for any slot
      }

      if (score > bestScore) {
        bestScore = score;
        bestTask = task;
      }
    }

    return bestTask;
  }

  Map<String, double> _analyzeTaskTypePerformance() {
    final performance = <String, double>{};
    final typeGroups = <String, List<Task>>{};

    // Group tasks by type
    for (final task in _allTasks) {
      final type = _classifyTaskType(task);
      typeGroups.putIfAbsent(type, () => []).add(task);
    }

    // Calculate performance for each type
    typeGroups.forEach((type, tasks) {
      if (tasks.isEmpty) return;

      final completedTasks = tasks.where((t) => t.isCompleted).length;
      final avgTime = tasks.where((t) => t.timeSpent.inMinutes > 0).map((t) => t.timeSpent.inMinutes).fold<double>(0, (sum, time) => sum + time) / tasks.where((t) => t.timeSpent.inMinutes > 0).length;

      // Performance score based on completion rate and efficiency
      final completionRate = completedTasks / tasks.length;
      final efficiencyScore = avgTime > 0 ? (60 / avgTime).clamp(0.0, 2.0) : 1.0;

      performance[type] = completionRate * efficiencyScore;
    });

    return performance;
  }

  String _classifyTaskType(Task task) {
    final title = task.title.toLowerCase();

    if (title.contains('code') || title.contains('program')) {
      return 'development';
    } else if (title.contains('write') || title.contains('document')) {
      return 'writing';
    } else if (title.contains('study') || title.contains('learn')) {
      return 'learning';
    } else if (title.contains('meeting') || title.contains('call')) {
      return 'communication';
    } else if (title.contains('design') || title.contains('create')) {
      return 'creative';
    } else if (title.contains('review') || title.contains('test')) {
      return 'review';
    } else {
      return 'general';
    }
  }

  int _getRecentSessionCount({int days = 7}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    int count = 0;

    for (final task in _allTasks) {
      for (final session in task.pomodoroSessions) {
        final sessionTime = DateTime.fromMillisecondsSinceEpoch(session['startTime'] ?? 0);
        if (sessionTime.isAfter(cutoff)) {
          count++;
        }
      }
    }

    return count;
  }

  int _getWeekendSessionCount() {
    int count = 0;

    for (final task in _allTasks) {
      for (final session in task.pomodoroSessions) {
        final sessionTime = DateTime.fromMillisecondsSinceEpoch(session['startTime'] ?? 0);
        if (sessionTime.weekday == DateTime.saturday || sessionTime.weekday == DateTime.sunday) {
          count++;
        }
      }
    }

    return count;
  }

  double _getAverageSessionLength() {
    final allSessions = <int>[];

    for (final task in _allTasks) {
      for (final session in task.pomodoroSessions) {
        final duration = session['duration'] as int?;
        if (duration != null) {
          allSessions.add(duration);
        }
      }
    }

    if (allSessions.isEmpty) return 25.0;

    return allSessions.reduce((a, b) => a + b) / allSessions.length;
  }

  double _getBreakRatio() {
    // This is a simplified calculation
    // In practice, you'd track actual break times
    final totalSessions = _getRecentSessionCount(days: 14);
    if (totalSessions == 0) return 0.25;

    // Assume breaks are taken every 4 sessions
    final estimatedBreaks = (totalSessions / 4).floor();
    return estimatedBreaks / totalSessions;
  }

  List<String> _generateBurnoutRecommendations(BurnoutRiskLevel level, List<String> factors) {
    final recommendations = <String>[];

    if (level == BurnoutRiskLevel.high) {
      recommendations.add('Take at least one full day off this week');
      recommendations.add('Limit work to maximum 4 pomodoro sessions per day');
      recommendations.add('Schedule at least 15-minute breaks between sessions');
    } else if (level == BurnoutRiskLevel.medium) {
      recommendations.add('Consider taking a half-day break');
      recommendations.add('Focus on completing only high-priority tasks');
      recommendations.add('Ensure you\'re taking regular breaks');
    }

    if (factors.contains('High workload intensity')) {
      recommendations.add('Reduce daily session count to prevent overload');
    }

    if (factors.contains('Insufficient breaks')) {
      recommendations.add('Increase break time between sessions');
    }

    if (factors.contains('Long work sessions')) {
      recommendations.add('Try shorter 25-minute sessions for better focus');
    }

    return recommendations;
  }

  Map<String, dynamic> _calculateWeeklyForecast(List<Task> incompleteTasks) {
    final forecast = <String, dynamic>{};
    final now = DateTime.now();

    for (int i = 0; i < 4; i++) {
      // Next 4 weeks
      final weekStart = now.add(Duration(days: i * 7));
      final weekEnd = weekStart.add(Duration(days: 6));

      int tasksCompleting = 0;
      int totalEstimatedSessions = 0;

      for (final task in incompleteTasks) {
        final prediction = predictCompletionDate(task);
        if (prediction != null && prediction.isAfter(weekStart) && prediction.isBefore(weekEnd)) {
          tasksCompleting++;
          totalEstimatedSessions += task.estimatedSessions;
        }
      }

      final weekKey = 'week_${i + 1}';
      forecast[weekKey] = {'tasksCompleting': tasksCompleting, 'estimatedSessions': totalEstimatedSessions, 'startDate': weekStart.toIso8601String(), 'endDate': weekEnd.toIso8601String()};
    }

    return forecast;
  }
}

class PomodoroSlot {
  final DateTime startTime;
  final Task task;
  final int duration;
  final TaskPriority priority;

  PomodoroSlot({required this.startTime, required this.task, required this.duration, required this.priority});

  Map<String, dynamic> toJson() {
    return {'startTime': startTime.toIso8601String(), 'taskId': task.id, 'taskTitle': task.title, 'duration': duration, 'priority': priority.name};
  }
}

class BurnoutRisk {
  final double score;
  final BurnoutRiskLevel level;
  final List<String> factors;
  final List<String> recommendations;

  BurnoutRisk({required this.score, required this.level, required this.factors, required this.recommendations});

  Map<String, dynamic> toJson() {
    return {'score': score, 'level': level.name, 'factors': factors, 'recommendations': recommendations, 'timestamp': DateTime.now().toIso8601String()};
  }
}

enum BurnoutRiskLevel { low, medium, high }
