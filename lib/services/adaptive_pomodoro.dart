import '../models/task.dart';

class AdaptivePomodoro {
  static const int _minSessionDuration = 15;
  static const int _maxSessionDuration = 60;
  static const int _defaultSessionDuration = 25;

  final List<Map<String, dynamic>> _sessionHistory = [];
  final Map<String, List<int>> _taskDurationHistory = {};
  final Map<int, double> _hourlyProductivity = {};
  final Map<String, double> _taskTypeProductivity = {};

  /// Calculate optimal session duration based on task complexity
  int calculateOptimalDuration(Task task) {
    int baseDuration = _defaultSessionDuration;

    // Adjust based on task priority
    baseDuration = _adjustForPriority(baseDuration, task.priority);

    // Adjust based on task complexity
    baseDuration = _adjustForComplexity(baseDuration, task);

    // Adjust based on historical performance
    baseDuration = _adjustForHistory(baseDuration, task);

    // Adjust based on time of day
    baseDuration = _adjustForTimeOfDay(baseDuration);

    // Adjust based on task type
    baseDuration = _adjustForTaskType(baseDuration, task);

    return baseDuration.clamp(_minSessionDuration, _maxSessionDuration);
  }

  /// Learn from user patterns and adapt recommendations
  void learnFromSession(Task task, int actualDuration, bool wasProductive, String? feedback) {
    final sessionData = {
      'taskId': task.id,
      'taskTitle': task.title,
      'taskPriority': task.priority.name,
      'actualDuration': actualDuration,
      'wasProductive': wasProductive,
      'feedback': feedback,
      'timestamp': DateTime.now().toIso8601String(),
      'hourOfDay': DateTime.now().hour,
    };

    _sessionHistory.add(sessionData);

    // Update task duration history
    _taskDurationHistory.putIfAbsent(task.id, () => []).add(actualDuration);

    // Update hourly productivity
    final hour = DateTime.now().hour;
    _hourlyProductivity.putIfAbsent(hour, () => 0.0);
    _hourlyProductivity[hour] = _hourlyProductivity[hour]! * 0.9 + (wasProductive ? 1.0 : 0.0) * 0.1;

    // Update task type productivity
    final taskType = _classifyTaskType(task);
    _taskTypeProductivity.putIfAbsent(taskType, () => 0.0);
    _taskTypeProductivity[taskType] = _taskTypeProductivity[taskType]! * 0.9 + (wasProductive ? 1.0 : 0.0) * 0.1;

    // Keep history manageable
    if (_sessionHistory.length > 1000) {
      _sessionHistory.removeRange(0, 500);
    }
  }

  /// Suggest optimal session times based on user patterns
  List<int> getOptimalSessionTimes({int maxSuggestions = 3}) {
    final sortedHours = _hourlyProductivity.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return sortedHours.take(maxSuggestions).map((entry) => entry.key).toList();
  }

  /// Suggest break duration based on session intensity and user patterns
  int suggestBreakDuration(int workDuration, int consecutiveSessions) {
    double baseBreakMultiplier = 0.2; // 20% of work time

    // Adjust for session intensity
    if (workDuration >= 50) {
      baseBreakMultiplier = 0.3; // Longer sessions need longer breaks
    } else if (workDuration <= 20) {
      baseBreakMultiplier = 0.15; // Short sessions need shorter breaks
    }

    // Adjust for consecutive sessions
    if (consecutiveSessions >= 4) {
      baseBreakMultiplier *= 1.5; // Long break after many sessions
    }

    // Adjust based on user's break patterns
    final avgBreakRatio = _calculateAverageBreakRatio();
    if (avgBreakRatio > 0) {
      baseBreakMultiplier = (baseBreakMultiplier + avgBreakRatio) / 2;
    }

    final breakDuration = (workDuration * baseBreakMultiplier).round();
    return breakDuration.clamp(3, 30); // 3-30 minute breaks
  }

  /// Get personalized recommendations for task management
  List<String> getPersonalizedRecommendations() {
    final recommendations = <String>[];

    // Analyze session patterns
    if (_sessionHistory.length >= 10) {
      final recentSessions = _sessionHistory.take(20).toList();
      final productivityRate = recentSessions.where((s) => s['wasProductive'] as bool).length / recentSessions.length;

      if (productivityRate < 0.6) {
        recommendations.add('Your recent productivity has been below 60%. Consider taking longer breaks or shorter sessions.');
      }

      // Analyze session duration patterns
      final avgDuration = recentSessions.map((s) => s['actualDuration'] as int).reduce((a, b) => a + b) / recentSessions.length;
      if (avgDuration > 40) {
        recommendations.add('Your sessions tend to be quite long. Consider trying shorter 25-minute sessions for better focus.');
      } else if (avgDuration < 20) {
        recommendations.add('Your sessions are quite short. Consider extending them to 25-30 minutes for deeper work.');
      }
    }

    // Analyze time-of-day patterns
    if (_hourlyProductivity.isNotEmpty) {
      final mostProductiveHour = _hourlyProductivity.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      final leastProductiveHour = _hourlyProductivity.entries.reduce((a, b) => a.value < b.value ? a : b).key;

      recommendations.add('You\'re most productive around $mostProductiveHour:00. Schedule important tasks then.');
      recommendations.add('You\'re least productive around $leastProductiveHour:00. Use this time for easier tasks or breaks.');
    }

    // Analyze task type preferences
    if (_taskTypeProductivity.isNotEmpty) {
      final bestTaskType = _taskTypeProductivity.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      recommendations.add('You work best on $bestTaskType tasks. Consider batching similar tasks together.');
    }

    return recommendations;
  }

  /// Predict completion time for a task based on historical data
  DateTime? predictCompletionTime(Task task) {
    final taskHistory = _taskDurationHistory[task.id];
    if (taskHistory == null || taskHistory.isEmpty) return null;

    final avgSessionDuration = taskHistory.reduce((a, b) => a + b) / taskHistory.length;
    final estimatedMinutes = avgSessionDuration * task.estimatedSessions;

    // Adjust for current productivity patterns
    final currentHour = DateTime.now().hour;
    final currentProductivity = _hourlyProductivity[currentHour] ?? 0.5;
    final adjustedMinutes = estimatedMinutes / (currentProductivity.clamp(0.1, 1.0));

    return DateTime.now().add(Duration(minutes: adjustedMinutes.round()));
  }

  /// Get insights about user's work patterns
  Map<String, dynamic> getWorkPatternInsights() {
    if (_sessionHistory.isEmpty) {
      return {'status': 'insufficient_data', 'message': 'Need more session data to analyze patterns'};
    }

    final insights = <String, dynamic>{};

    // Productivity by hour
    insights['peakProductivityHours'] = _hourlyProductivity.entries.where((e) => e.value > 0.7).map((e) => e.key).toList()..sort();

    // Average session duration
    final avgDuration = _sessionHistory.map((s) => s['actualDuration'] as int).reduce((a, b) => a + b) / _sessionHistory.length;
    insights['averageSessionDuration'] = avgDuration.round();

    // Productivity rate
    final productivityRate = _sessionHistory.where((s) => s['wasProductive'] as bool).length / _sessionHistory.length;
    insights['overallProductivityRate'] = '${(productivityRate * 100).toStringAsFixed(1)}%';

    // Most productive task types
    if (_taskTypeProductivity.isNotEmpty) {
      final sortedTypes = _taskTypeProductivity.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
      insights['mostProductiveTaskTypes'] = sortedTypes.take(3).map((e) => e.key).toList();
    }

    // Session consistency
    final durations = _sessionHistory.map((s) => s['actualDuration'] as int).toList();
    final variance = _calculateVariance(durations);
    insights['sessionConsistency'] = variance < 100
        ? 'High'
        : variance < 400
        ? 'Medium'
        : 'Low';

    return insights;
  }

  // Private helper methods

  int _adjustForPriority(int baseDuration, TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return (baseDuration * 1.4).round(); // 40% longer for deep work
      case TaskPriority.medium:
        return baseDuration;
      case TaskPriority.low:
        return (baseDuration * 0.8).round(); // 20% shorter for quick tasks
    }
  }

  int _adjustForComplexity(int baseDuration, Task task) {
    int complexity = 0;

    // Factor in subtasks
    complexity += (task.subtasks.length / 3).ceil();

    // Factor in description length
    if (task.description != null) {
      complexity += (task.description!.length / 200).ceil();
    }

    // Factor in tags and attachments (indicates complexity)
    complexity += (task.tags.length / 5).ceil();
    complexity += (task.attachments.length / 3).ceil();

    // Factor in estimated sessions
    if (task.estimatedSessions > 5) {
      complexity += 2;
    } else if (task.estimatedSessions > 2) {
      complexity += 1;
    }

    return baseDuration + (complexity * 5);
  }

  int _adjustForHistory(int baseDuration, Task task) {
    final taskHistory = _taskDurationHistory[task.id];
    if (taskHistory == null || taskHistory.length < 2) return baseDuration;

    final avgDuration = taskHistory.reduce((a, b) => a + b) / taskHistory.length;
    final recentAvgDuration = taskHistory.length >= 3 ? taskHistory.sublist(taskHistory.length - 3).reduce((a, b) => a + b) / 3 : avgDuration;

    // If recent sessions are consistently longer, increase duration
    if (recentAvgDuration > avgDuration * 1.2) {
      return (baseDuration * 1.1).round();
    }
    // If recent sessions are consistently shorter, decrease duration
    else if (recentAvgDuration < avgDuration * 0.8) {
      return (baseDuration * 0.9).round();
    }

    return baseDuration;
  }

  int _adjustForTimeOfDay(int baseDuration) {
    final hour = DateTime.now().hour;
    final productivity = _hourlyProductivity[hour] ?? 0.5;

    if (productivity > 0.8) {
      return (baseDuration * 1.2).round(); // Longer sessions during peak productivity
    } else if (productivity < 0.3) {
      return (baseDuration * 0.8).round(); // Shorter sessions during low productivity
    }

    return baseDuration;
  }

  int _adjustForTaskType(int baseDuration, Task task) {
    final taskType = _classifyTaskType(task);
    final productivity = _taskTypeProductivity[taskType] ?? 0.5;

    if (productivity > 0.7) {
      return (baseDuration * 1.1).round(); // Can handle longer sessions for this type
    } else if (productivity < 0.4) {
      return (baseDuration * 0.9).round(); // Shorter sessions for difficult types
    }

    return baseDuration;
  }

  String _classifyTaskType(Task task) {
    final title = task.title.toLowerCase();

    if (title.contains('code') || title.contains('program') || title.contains('develop')) {
      return 'coding';
    } else if (title.contains('write') || title.contains('article') || title.contains('report')) {
      return 'writing';
    } else if (title.contains('study') || title.contains('learn') || title.contains('research')) {
      return 'learning';
    } else if (title.contains('meeting') || title.contains('call') || title.contains('discuss')) {
      return 'communication';
    } else if (title.contains('design') || title.contains('create') || title.contains('art')) {
      return 'creative';
    } else if (title.contains('review') || title.contains('check') || title.contains('test')) {
      return 'review';
    } else {
      return 'general';
    }
  }

  double _calculateAverageBreakRatio() {
    if (_sessionHistory.length < 10) return 0.0;

    // This is a simplified calculation - in practice, you'd track actual break times
    final productiveSessions = _sessionHistory.where((s) => s['wasProductive'] as bool).length;
    final totalSessions = _sessionHistory.length;

    return productiveSessions / totalSessions * 0.25; // Assume 25% break ratio for productive sessions
  }

  double _calculateVariance(List<int> values) {
    if (values.isEmpty) return 0.0;

    final mean = values.reduce((a, b) => a + b) / values.length;
    final squaredDiffs = values.map((v) => (v - mean) * (v - mean)).toList();
    final variance = squaredDiffs.reduce((a, b) => a + b) / values.length;

    return variance;
  }

  /// Reset learning data (for privacy or starting fresh)
  void resetLearningData() {
    _sessionHistory.clear();
    _taskDurationHistory.clear();
    _hourlyProductivity.clear();
    _taskTypeProductivity.clear();
  }

  /// Export learning data for backup or analysis
  Map<String, dynamic> exportLearningData() {
    return {
      'sessionHistory': _sessionHistory,
      'taskDurationHistory': _taskDurationHistory,
      'hourlyProductivity': _hourlyProductivity,
      'taskTypeProductivity': _taskTypeProductivity,
      'exportTimestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Import learning data from backup
  void importLearningData(Map<String, dynamic> data) {
    _sessionHistory.clear();
    _sessionHistory.addAll((data['sessionHistory'] as List?)?.cast<Map<String, dynamic>>() ?? []);

    _taskDurationHistory.clear();
    (data['taskDurationHistory'] as Map<String, dynamic>?)?.forEach((key, value) {
      _taskDurationHistory[key] = (value as List).cast<int>();
    });

    _hourlyProductivity.clear();
    (data['hourlyProductivity'] as Map<String, dynamic>?)?.forEach((key, value) {
      _hourlyProductivity[int.parse(key)] = (value as num).toDouble();
    });

    _taskTypeProductivity.clear();
    (data['taskTypeProductivity'] as Map<String, dynamic>?)?.forEach((key, value) {
      _taskTypeProductivity[key] = (value as num).toDouble();
    });
  }
}
