import '../models/task.dart';

class EnhancedProgress {
  final double completionProgress; // Traditional completion percentage
  final double timeProgress; // Actual vs estimated time
  final double sessionProgress; // Completed vs estimated sessions
  final double focusScore; // Based on session completion rates
  final double consistencyScore; // Regular work patterns
  final double qualityScore; // Quality of work (based on revisions, etc.)
  final double efficiencyScore; // Time efficiency
  final DateTime lastUpdated;
  final Map<String, dynamic> metadata;

  const EnhancedProgress({
    required this.completionProgress,
    required this.timeProgress,
    required this.sessionProgress,
    required this.focusScore,
    required this.consistencyScore,
    required this.qualityScore,
    required this.efficiencyScore,
    required this.lastUpdated,
    this.metadata = const {},
  });

  /// Calculate overall progress score (weighted average)
  double get overallScore {
    return (completionProgress * 0.3 + timeProgress * 0.2 + sessionProgress * 0.2 + focusScore * 0.1 + consistencyScore * 0.1 + qualityScore * 0.05 + efficiencyScore * 0.05);
  }

  /// Get progress level description
  String get progressLevel {
    if (overallScore >= 0.9) return 'Excellent';
    if (overallScore >= 0.75) return 'Good';
    if (overallScore >= 0.6) return 'Satisfactory';
    if (overallScore >= 0.4) return 'Needs Improvement';
    return 'Poor';
  }

  /// Get color for progress visualization
  String get progressColor {
    if (overallScore >= 0.8) return '#4CAF50'; // Green
    if (overallScore >= 0.6) return '#FF9800'; // Orange
    if (overallScore >= 0.4) return '#FFC107'; // Amber
    return '#F44336'; // Red
  }

  Map<String, dynamic> toJson() {
    return {
      'completionProgress': completionProgress,
      'timeProgress': timeProgress,
      'sessionProgress': sessionProgress,
      'focusScore': focusScore,
      'consistencyScore': consistencyScore,
      'qualityScore': qualityScore,
      'efficiencyScore': efficiencyScore,
      'lastUpdated': lastUpdated.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory EnhancedProgress.fromJson(Map<String, dynamic> json) {
    return EnhancedProgress(
      completionProgress: (json['completionProgress'] as num?)?.toDouble() ?? 0.0,
      timeProgress: (json['timeProgress'] as num?)?.toDouble() ?? 0.0,
      sessionProgress: (json['sessionProgress'] as num?)?.toDouble() ?? 0.0,
      focusScore: (json['focusScore'] as num?)?.toDouble() ?? 0.0,
      consistencyScore: (json['consistencyScore'] as num?)?.toDouble() ?? 0.0,
      qualityScore: (json['qualityScore'] as num?)?.toDouble() ?? 0.0,
      efficiencyScore: (json['efficiencyScore'] as num?)?.toDouble() ?? 0.0,
      lastUpdated: DateTime.parse(json['lastUpdated'] ?? DateTime.now().toIso8601String()),
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }
}

class ProgressTracker {
  final Map<String, EnhancedProgress> _taskProgress = {};
  final Map<String, List<ProgressSnapshot>> _progressHistory = {};
  final Map<String, List<double>> _dailyProgressTrends = {};

  /// Calculate enhanced progress for a task
  EnhancedProgress calculateProgress(Task task) {
    final completionProgress = task.getCompletionProgress();
    final timeProgress = _calculateTimeProgress(task);
    final sessionProgress = _calculateSessionProgress(task);
    final focusScore = _calculateFocusScore(task);
    final consistencyScore = _calculateConsistencyScore(task);
    final qualityScore = _calculateQualityScore(task);
    final efficiencyScore = _calculateEfficiencyScore(task);

    final progress = EnhancedProgress(
      completionProgress: completionProgress,
      timeProgress: timeProgress,
      sessionProgress: sessionProgress,
      focusScore: focusScore,
      consistencyScore: consistencyScore,
      qualityScore: qualityScore,
      efficiencyScore: efficiencyScore,
      lastUpdated: DateTime.now(),
      metadata: {
        'taskId': task.id,
        'estimatedSessions': task.estimatedSessions,
        'actualSessions': task.pomodoroSessions.length,
        'timeSpent': task.timeSpent.inMinutes,
        'subtaskCount': task.subtasks.length,
        'completedSubtasks': task.subtasks.where((s) => s.isCompleted).length,
      },
    );

    // Store progress
    _taskProgress[task.id] = progress;
    _addProgressSnapshot(task.id, progress);

    return progress;
  }

  /// Get progress history for a task
  List<ProgressSnapshot> getProgressHistory(String taskId) {
    return _progressHistory[taskId] ?? [];
  }

  /// Get daily progress trends
  Map<String, double> getDailyProgressTrends(String taskId, {int days = 7}) {
    final trends = <String, double>{};
    final now = DateTime.now();

    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final dailyProgress = _dailyProgressTrends[taskId] ?? [];
      if (dailyProgress.isNotEmpty) {
        trends[dateKey] = dailyProgress[dailyProgress.length - 1 - i];
      }
    }

    return trends;
  }

  /// Get progress comparison between tasks
  Map<String, EnhancedProgress> compareTasks(List<String> taskIds) {
    final comparison = <String, EnhancedProgress>{};

    for (final taskId in taskIds) {
      final progress = _taskProgress[taskId];
      if (progress != null) {
        comparison[taskId] = progress;
      }
    }

    return comparison;
  }

  /// Get progress insights and recommendations
  List<String> getProgressInsights(String taskId) {
    final insights = <String>[];
    final progress = _taskProgress[taskId];

    if (progress == null) {
      insights.add('No progress data available for this task.');
      return insights;
    }

    // Completion insights
    if (progress.completionProgress < 0.3) {
      insights.add('Task is less than 30% complete. Consider breaking it down into smaller subtasks.');
    } else if (progress.completionProgress > 0.8) {
      insights.add('Task is nearly complete! Focus on finishing the remaining items.');
    }

    // Time insights
    if (progress.timeProgress < 0.5) {
      insights.add('You\'re using less time than estimated. Consider if the task complexity was underestimated.');
    } else if (progress.timeProgress > 1.5) {
      insights.add('Task is taking longer than expected. Consider revising estimates or breaking down further.');
    }

    // Focus insights
    if (progress.focusScore < 0.6) {
      insights.add('Focus score is low. Consider enabling focus mode or reducing distractions.');
    }

    // Consistency insights
    if (progress.consistencyScore < 0.5) {
      insights.add('Work consistency is low. Try to establish a regular work schedule for this task.');
    }

    // Quality insights
    if (progress.qualityScore < 0.6) {
      insights.add('Quality score suggests room for improvement. Consider reviewing work more carefully.');
    }

    // Efficiency insights
    if (progress.efficiencyScore < 0.6) {
      insights.add('Efficiency could be improved. Consider optimizing your workflow or tools.');
    }

    return insights;
  }

  /// Get progress predictions
  Map<String, dynamic> predictProgress(String taskId) {
    final progress = _taskProgress[taskId];
    if (progress == null) {
      return {'status': 'no_data', 'message': 'No progress data available'};
    }

    final history = _progressHistory[taskId] ?? [];
    if (history.length < 3) {
      return {'status': 'insufficient_data', 'message': 'Need more progress history for predictions'};
    }

    // Calculate trends
    final recentProgress = history.length >= 5 ? history.sublist(history.length - 5) : history;
    final avgCompletionRate = _calculateAverageCompletionRate(recentProgress);

    // Predict completion
    final remainingCompletion = 1.0 - progress.completionProgress;
    final estimatedDaysToComplete = remainingCompletion / avgCompletionRate;

    // Predict time needed
    final currentTimeRatio = progress.timeProgress;
    final estimatedAdditionalTime = remainingCompletion * (currentTimeRatio / progress.completionProgress);

    return {
      'status': 'predicted',
      'estimatedDaysToComplete': estimatedDaysToComplete,
      'estimatedAdditionalMinutes': estimatedAdditionalTime.round(),
      'completionProbability': _calculateCompletionProbability(progress, recentProgress),
      'recommendations': _generateProgressRecommendations(progress, recentProgress),
    };
  }

  // Private helper methods

  double _calculateTimeProgress(Task task) {
    if (task.estimatedSessions == 0) return 1.0;

    // Estimate total time based on sessions and average session duration
    final estimatedTotalMinutes = task.estimatedSessions * 25; // 25 minutes per session
    final actualMinutes = task.timeSpent.inMinutes;

    return actualMinutes / estimatedTotalMinutes;
  }

  double _calculateSessionProgress(Task task) {
    if (task.estimatedSessions == 0) return 1.0;

    return task.pomodoroCount / task.estimatedSessions;
  }

  double _calculateFocusScore(Task task) {
    if (task.pomodoroSessions.isEmpty) return 0.5;

    // Calculate focus based on session completion rates
    int completedSessions = 0;
    for (final session in task.pomodoroSessions) {
      if (session['completed'] == true) {
        completedSessions++;
      }
    }

    return completedSessions / task.pomodoroSessions.length;
  }

  double _calculateConsistencyScore(Task task) {
    if (task.pomodoroSessions.length < 2) return 0.5;

    // Calculate consistency based on regular session patterns
    final sessionDates = task.pomodoroSessions.map((session) {
      final date = DateTime.fromMillisecondsSinceEpoch(session['startTime'] ?? 0);
      return DateTime(date.year, date.month, date.day);
    }).toSet();

    // More consistent work across different days gets higher score
    final consistencyRatio = sessionDates.length / task.pomodoroSessions.length;
    return consistencyRatio.clamp(0.0, 1.0);
  }

  double _calculateQualityScore(Task task) {
    // Quality score based on revisions and rework
    // This is a simplified calculation - in practice, you'd track actual quality metrics
    final hasRevisions = task.sessionNotes.any((note) => note.toLowerCase().contains('revision') || note.toLowerCase().contains('redo') || note.toLowerCase().contains('fix'));

    return hasRevisions ? 0.6 : 0.8;
  }

  double _calculateEfficiencyScore(Task task) {
    if (task.estimatedSessions == 0) return 0.5;

    // Efficiency based on sessions vs completion progress
    final sessionEfficiency = task.getCompletionProgress() / (task.pomodoroCount / task.estimatedSessions);
    return sessionEfficiency.clamp(0.0, 1.0);
  }

  void _addProgressSnapshot(String taskId, EnhancedProgress progress) {
    final snapshot = ProgressSnapshot(timestamp: DateTime.now(), progress: progress);

    _progressHistory.putIfAbsent(taskId, () => []).add(snapshot);

    // Add to daily trends
    _dailyProgressTrends.putIfAbsent(taskId, () => []).add(progress.overallScore);

    // Keep history manageable
    if (_progressHistory[taskId]!.length > 100) {
      _progressHistory[taskId]!.removeRange(0, 50);
    }
  }

  double _calculateAverageCompletionRate(List<ProgressSnapshot> snapshots) {
    if (snapshots.length < 2) return 0.1;

    double totalRate = 0.0;
    for (int i = 1; i < snapshots.length; i++) {
      final prev = snapshots[i - 1];
      final curr = snapshots[i];
      final rate = curr.progress.completionProgress - prev.progress.completionProgress;
      totalRate += rate;
    }

    return totalRate / (snapshots.length - 1);
  }

  double _calculateCompletionProbability(EnhancedProgress currentProgress, List<ProgressSnapshot> recentHistory) {
    // Simple probability calculation based on recent trends
    if (recentHistory.isEmpty) return 0.5;

    final avgProgress = recentHistory.isEmpty ? currentProgress.overallScore : recentHistory.map((s) => s.progress.overallScore).reduce((a, b) => a + b) / recentHistory.length;
    final trend = avgProgress > currentProgress.overallScore ? 1.1 : 0.9;

    return (currentProgress.overallScore * trend).clamp(0.0, 1.0);
  }

  List<String> _generateProgressRecommendations(EnhancedProgress currentProgress, List<ProgressSnapshot> recentHistory) {
    final recommendations = <String>[];

    if (currentProgress.completionProgress < 0.5) {
      recommendations.add('Focus on completing subtasks to boost overall progress');
    }

    if (currentProgress.timeProgress > 1.2) {
      recommendations.add('Consider breaking down remaining work into smaller sessions');
    }

    if (currentProgress.focusScore < 0.7) {
      recommendations.add('Try enabling focus mode to improve concentration');
    }

    if (currentProgress.consistencyScore < 0.6) {
      recommendations.add('Establish a regular work schedule for better consistency');
    }

    return recommendations;
  }

  /// Clear progress data for a task
  void clearTaskProgress(String taskId) {
    _taskProgress.remove(taskId);
    _progressHistory.remove(taskId);
    _dailyProgressTrends.remove(taskId);
  }

  /// Export progress data
  Map<String, dynamic> exportProgressData() {
    return {
      'taskProgress': _taskProgress.map((key, value) => MapEntry(key, value.toJson())),
      'progressHistory': _progressHistory.map((key, value) => MapEntry(key, value.map((s) => s.toJson()).toList())),
      'dailyProgressTrends': _dailyProgressTrends,
      'exportTimestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Import progress data
  void importProgressData(Map<String, dynamic> data) {
    // Import task progress
    final taskProgressData = data['taskProgress'] as Map<String, dynamic>?;
    if (taskProgressData != null) {
      taskProgressData.forEach((key, value) {
        _taskProgress[key] = EnhancedProgress.fromJson(value as Map<String, dynamic>);
      });
    }

    // Import progress history
    final historyData = data['progressHistory'] as Map<String, dynamic>?;
    if (historyData != null) {
      historyData.forEach((key, value) {
        final snapshotsList = (value as List).cast<Map<String, dynamic>>();
        _progressHistory[key] = snapshotsList.map((s) => ProgressSnapshot.fromJson(s)).toList();
      });
    }

    // Import daily trends
    final trendsData = data['dailyProgressTrends'] as Map<String, dynamic>?;
    if (trendsData != null) {
      trendsData.forEach((key, value) {
        _dailyProgressTrends[key] = (value as List).cast<double>();
      });
    }
  }
}

class ProgressSnapshot {
  final DateTime timestamp;
  final EnhancedProgress progress;

  ProgressSnapshot({required this.timestamp, required this.progress});

  Map<String, dynamic> toJson() {
    return {'timestamp': timestamp.toIso8601String(), 'progress': progress.toJson()};
  }

  factory ProgressSnapshot.fromJson(Map<String, dynamic> json) {
    return ProgressSnapshot(timestamp: DateTime.parse(json['timestamp']), progress: EnhancedProgress.fromJson(json['progress']));
  }
}
