import '../models/task.dart';
import '../models/pomodoro_plan.dart';
import 'app_logging_service.dart';

/// Service for adaptive pomodoro session timing based on user performance
class AdaptiveSessionTimingService {
  static const int _minSessionDuration = 10; // Minimum session duration in minutes
  static const int _maxSessionDuration = 60; // Maximum session duration in minutes
  static const int _performanceHistorySize = 20; // Number of recent sessions to analyze
  static const double _performanceThreshold = 0.7; // Performance threshold for adjustments

  /// Adjust session duration based on task performance
  int adjustSessionDuration(Task task, int baseDuration, List<CompletedPomodoroSession> recentSessions, {bool isPerformingWell = true, double performanceMultiplier = 1.0}) {
    AppLogging.logInfo('Adjusting session duration for task: ${task.title}', name: 'AdaptiveSessionTimingService');

    int adjustedDuration = baseDuration;

    // Adjust based on recent performance
    if (recentSessions.isNotEmpty) {
      adjustedDuration = _adjustBasedOnPerformance(adjustedDuration, recentSessions, task);
    }

    // Adjust based on task characteristics
    adjustedDuration = _adjustBasedOnTaskCharacteristics(adjustedDuration, task);

    // Apply performance multiplier
    adjustedDuration = (adjustedDuration * performanceMultiplier).round();

    // Adjust based on energy level (if available)
    adjustedDuration = _adjustBasedOnEnergy(adjustedDuration, isPerformingWell);

    // Ensure within bounds
    adjustedDuration = adjustedDuration.clamp(_minSessionDuration, _maxSessionDuration);

    AppLogging.logInfo('Adjusted session duration from ${baseDuration}min to ${adjustedDuration}min', name: 'AdaptiveSessionTimingService');
    return adjustedDuration;
  }

  /// Get personalized session duration for specific task
  int getPersonalizedDuration(Task task, List<CompletedPomodoroSession> userHistory) {
    AppLogging.logInfo('Getting personalized duration for task: ${task.title}', name: 'AdaptiveSessionTimingService');

    // Start with task's estimated duration or default
    int baseDuration = task.estimatedDuration.inMinutes;
    if (baseDuration == 0) {
      baseDuration = _estimateBaseDuration(task);
    }

    // Filter relevant sessions (same task type or similar focus)
    final relevantSessions = _getRelevantSessions(task, userHistory);

    // Calculate performance score
    final performanceScore = _calculatePerformanceScore(relevantSessions);

    // Determine if user is performing well
    final isPerformingWell = performanceScore >= _performanceThreshold;

    // Calculate performance multiplier
    final performanceMultiplier = _calculatePerformanceMultiplier(performanceScore);

    return adjustSessionDuration(task, baseDuration, relevantSessions, isPerformingWell: isPerformingWell, performanceMultiplier: performanceMultiplier);
  }

  /// Analyze user's session patterns and provide recommendations
  SessionPatternAnalysis analyzeSessionPatterns(List<CompletedPomodoroSession> sessions) {
    AppLogging.logInfo('Analyzing session patterns from ${sessions.length} sessions', name: 'AdaptiveSessionTimingService');

    if (sessions.isEmpty) {
      return SessionPatternAnalysis(
        averageSessionDuration: 25,
        optimalDurationRange: DurationRange(min: 20, max: 30),
        performanceTrend: PerformanceTrend.stable,
        recommendedAdjustments: [],
        focusPattern: FocusPattern.inconsistent,
        energyPattern: EnergyPattern.inconsistent,
      );
    }

    // Calculate metrics
    final averageDuration = _calculateAverageDuration(sessions);
    final performanceTrend = _calculatePerformanceTrend(sessions);
    final focusPattern = _detectFocusPattern(sessions);
    final energyPattern = _detectEnergyPattern(sessions);
    final optimalRange = _calculateOptimalDurationRange(sessions, performanceTrend);

    // Generate recommendations
    final recommendations = _generateRecommendations(sessions, performanceTrend, optimalRange);

    return SessionPatternAnalysis(
      averageSessionDuration: averageDuration,
      optimalDurationRange: optimalRange,
      performanceTrend: performanceTrend,
      recommendedAdjustments: recommendations,
      focusPattern: focusPattern,
      energyPattern: energyPattern,
    );
  }

  /// Predict optimal session duration for new task type
  int predictOptimalDuration(Task task, List<CompletedPomodoroSession> userHistory) {
    AppLogging.logInfo('Predicting optimal duration for task: ${task.title}', name: 'AdaptiveSessionTimingService');

    // Get similar tasks from history
    final similarTasks = _findSimilarTasks(task, userHistory);

    if (similarTasks.isEmpty) {
      // No similar tasks, use task characteristics
      return _estimateBaseDuration(task);
    }

    // Calculate optimal duration based on similar tasks
    final similarSessions = <CompletedPomodoroSession>[];
    // TODO: Implement similar session finding logic when task repository is available

    if (similarSessions.isEmpty) {
      return _estimateBaseDuration(task);
    }

    // Calculate weighted average duration
    final totalWeight = similarSessions.fold<int>(0, (sum, session) => sum + session.actualDuration);
    final avgDuration = totalWeight ~/ similarSessions.length;

    // Adjust based on performance
    final avgPerformance = similarSessions.map((s) => s.focusRating).reduce((a, b) => a + b) / similarSessions.length;

    final performanceAdjustment = avgPerformance >= 7
        ? 1.1
        : avgPerformance <= 4
        ? 0.9
        : 1.0;
    final adjustedDuration = (avgDuration * performanceAdjustment).round();

    return adjustedDuration.clamp(_minSessionDuration, _maxSessionDuration);
  }

  /// Get real-time session adjustment suggestion
  SessionAdjustmentSuggestion getRealTimeAdjustment(int currentDuration, int elapsedTime, int currentFocusRating, Task currentTask, List<CompletedPomodoroSession> recentSessions) {
    AppLogging.logInfo('Getting real-time adjustment suggestion', name: 'AdaptiveSessionTimingService');

    // Calculate current performance
    final currentPerformance = currentFocusRating / 10.0;
    final progressPercentage = elapsedTime / currentDuration;

    // Determine if adjustment is needed
    bool needsAdjustment = false;
    String adjustmentReason = '';
    int suggestedDuration = currentDuration;
    AdjustmentType adjustmentType = AdjustmentType.none;

    // Check if struggling (low focus, slow progress)
    if (currentPerformance < 0.4 && progressPercentage < 0.5) {
      needsAdjustment = true;
      adjustmentReason = 'Low focus and slow progress detected';
      suggestedDuration = (currentDuration * 0.7).round().clamp(_minSessionDuration, currentDuration - 5);
      adjustmentType = AdjustmentType.shorten;
    }
    // Check if doing exceptionally well
    else if (currentPerformance >= 0.9 && progressPercentage > 0.8) {
      needsAdjustment = true;
      adjustmentReason = 'High focus and rapid progress detected';
      suggestedDuration = (currentDuration * 1.2).round().clamp(currentDuration + 5, _maxSessionDuration);
      adjustmentType = AdjustmentType.extend;
    }
    // Check if session is too long for current energy
    else if (currentDuration > 45 && currentPerformance < 0.6) {
      needsAdjustment = true;
      adjustmentReason = 'Session too long for current energy level';
      suggestedDuration = (currentDuration * 0.8).round().clamp(_minSessionDuration, 35);
      adjustmentType = AdjustmentType.shorten;
    }

    return SessionAdjustmentSuggestion(
      needsAdjustment: needsAdjustment,
      adjustmentReason: adjustmentReason,
      suggestedDuration: suggestedDuration,
      adjustmentType: adjustmentType,
      currentPerformance: currentPerformance,
      progressPercentage: progressPercentage,
    );
  }

  // Private helper methods

  int _adjustBasedOnPerformance(int duration, List<CompletedPomodoroSession> sessions, Task task) {
    if (sessions.isEmpty) return duration;

    // Get recent sessions for this task or similar tasks
    final taskSessions = sessions.where((s) => s.taskId == task.id).toList();
    final similarSessions = _findSimilarSessions(task, sessions).expand((t) => sessions.where((s) => s.taskId == t.id)).toList();

    final relevantSessions = taskSessions.isNotEmpty ? taskSessions : similarSessions.take(5);

    if (relevantSessions.isEmpty) return duration;

    // Calculate average focus rating
    final avgFocus = relevantSessions.map((s) => s.focusRating).reduce((a, b) => a + b) / relevantSessions.length;

    // Calculate completion rate
    final completionRate = relevantSessions.where((s) => s.completed).length / relevantSessions.length;

    // Adjust duration based on performance
    double adjustment = 1.0;
    if (avgFocus >= 8 && completionRate >= 0.8) {
      adjustment = 1.2; // Extend for good performance
    } else if (avgFocus <= 4 || completionRate <= 0.5) {
      adjustment = 0.8; // Shorten for poor performance
    }

    return (duration * adjustment).round();
  }

  int _adjustBasedOnTaskCharacteristics(int duration, Task task) {
    double adjustment = 1.0;

    // Adjust based on focus score
    if (task.focusScore >= 8) {
      adjustment *= 1.2; // Longer sessions for high focus tasks
    } else if (task.focusScore <= 3) {
      adjustment *= 0.8; // Shorter sessions for low focus tasks
    }

    // Adjust based on priority
    switch (task.priority) {
      case TaskPriority.high:
        adjustment *= 1.1; // Slightly longer for important tasks
        break;
      case TaskPriority.low:
        adjustment *= 0.9; // Slightly shorter for routine tasks
        break;
      case TaskPriority.medium:
        break; // No adjustment
    }

    // Adjust based on complexity (description length)
    if (task.description != null) {
      final complexity = (task.description!.length / 100.0).clamp(0.0, 2.0);
      if (complexity > 1.0) {
        adjustment *= 1.1; // Longer for complex tasks
      }
    }

    return (duration * adjustment).round();
  }

  int _adjustBasedOnEnergy(int duration, bool isPerformingWell) {
    return isPerformingWell ? (duration * 1.1).round() : (duration * 0.9).round();
  }

  int _estimateBaseDuration(Task task) {
    // Base estimation on task characteristics
    int baseDuration = 25;

    // Adjust based on focus score
    if (task.focusScore >= 8) {
      baseDuration = 35;
    } else if (task.focusScore <= 3) {
      baseDuration = 15;
    }

    // Adjust based on priority
    switch (task.priority) {
      case TaskPriority.high:
        baseDuration = 30;
        break;
      case TaskPriority.low:
        baseDuration = 20;
        break;
      case TaskPriority.medium:
        baseDuration = 25;
        break;
    }

    // Adjust based on complexity
    if (task.description != null && task.description!.length > 100) {
      baseDuration += 10;
    }

    if (task.subtasks.isNotEmpty) {
      baseDuration += (task.subtasks.length * 5);
    }

    return baseDuration.clamp(_minSessionDuration, _maxSessionDuration);
  }

  List<CompletedPomodoroSession> _getRelevantSessions(Task task, List<CompletedPomodoroSession> sessions) {
    // Get sessions for the same task
    final taskSessions = sessions.where((s) => s.taskId == task.id).toList();

    if (taskSessions.isNotEmpty) {
      return taskSessions.take(_performanceHistorySize).toList();
    }

    // Get sessions for similar tasks (same priority and focus range)
    final similarSessions = sessions.where((s) {
      // This would need access to task repository to get task details
      // For now, return empty list
      return false;
    }).toList();

    return similarSessions.take(_performanceHistorySize).toList();
  }

  double _calculatePerformanceScore(List<CompletedPomodoroSession> sessions) {
    if (sessions.isEmpty) return 0.5; // Neutral score

    final totalScore = sessions.map((s) => s.focusRating.toDouble() / 10.0).reduce((a, b) => a + b);

    return totalScore / sessions.length;
  }

  double _calculatePerformanceMultiplier(double performanceScore) {
    if (performanceScore >= 0.8) return 1.2;
    if (performanceScore >= 0.6) return 1.0;
    if (performanceScore >= 0.4) return 0.9;
    return 0.8;
  }

  int _calculateAverageDuration(List<CompletedPomodoroSession> sessions) {
    final totalDuration = sessions.map((s) => s.actualDuration).reduce((a, b) => a + b);
    return totalDuration ~/ sessions.length;
  }

  PerformanceTrend _calculatePerformanceTrend(List<CompletedPomodoroSession> sessions) {
    if (sessions.length < 3) return PerformanceTrend.stable;

    // Compare recent performance with older performance
    final recentSessions = sessions.take(3).toList();
    final olderSessions = sessions.skip(3).take(3).toList();

    if (olderSessions.isEmpty) return PerformanceTrend.stable;

    final recentAvg = recentSessions.map((s) => s.focusRating).reduce((a, b) => a + b) / recentSessions.length;

    final olderAvg = olderSessions.map((s) => s.focusRating).reduce((a, b) => a + b) / olderSessions.length;

    final difference = recentAvg - olderAvg;

    if (difference > 1.0) return PerformanceTrend.improving;
    if (difference < -1.0) return PerformanceTrend.declining;
    return PerformanceTrend.stable;
  }

  FocusPattern _detectFocusPattern(List<CompletedPomodoroSession> sessions) {
    if (sessions.length < 5) return FocusPattern.inconsistent;

    // Analyze focus consistency
    final focusRatings = sessions.map((s) => s.focusRating.toDouble()).toList();
    final variance = _calculateVariance(focusRatings);

    if (variance < 1.0) {
      return FocusPattern.consistent;
    } else if (variance < 2.0) {
      return FocusPattern.moderate;
    } else {
      return FocusPattern.inconsistent;
    }
  }

  EnergyPattern _detectEnergyPattern(List<CompletedPomodoroSession> sessions) {
    if (sessions.length < 5) return EnergyPattern.inconsistent;

    // Group sessions by hour of day
    final hourlyPerformance = <int, List<double>>{};
    for (final session in sessions) {
      final hour = session.startTime.hour;
      hourlyPerformance.putIfAbsent(hour, () => []).add(session.focusRating.toDouble() / 10.0);
    }

    // Calculate variance in hourly performance
    final hourlyAverages = hourlyPerformance.values.map((ratings) => ratings.reduce((a, b) => a + b) / ratings.length).toList();

    if (hourlyAverages.length < 3) return EnergyPattern.inconsistent;

    final variance = _calculateVariance(hourlyAverages);

    if (variance < 0.1) {
      return EnergyPattern.stable;
    } else if (variance < 0.2) {
      return EnergyPattern.moderate;
    } else {
      return EnergyPattern.inconsistent;
    }
  }

  DurationRange _calculateOptimalDurationRange(List<CompletedPomodoroSession> sessions, PerformanceTrend trend) {
    final durations = sessions.map((s) => s.actualDuration).toList();
    durations.sort();

    final minDuration = durations.first;
    final maxDuration = durations.last;

    // Adjust range based on trend
    int adjustedMin = minDuration;
    int adjustedMax = maxDuration;

    switch (trend) {
      case PerformanceTrend.improving:
        adjustedMin = (minDuration * 0.9).round();
        adjustedMax = (maxDuration * 1.2).round();
        break;
      case PerformanceTrend.declining:
        adjustedMin = (minDuration * 1.1).round();
        adjustedMax = (maxDuration * 0.9).round();
        break;
      case PerformanceTrend.stable:
        break; // No adjustment
    }

    return DurationRange(min: adjustedMin, max: adjustedMax);
  }

  List<String> _generateRecommendations(List<CompletedPomodoroSession> sessions, PerformanceTrend trend, DurationRange optimalRange) {
    final recommendations = <String>[];

    // Performance-based recommendations
    switch (trend) {
      case PerformanceTrend.improving:
        recommendations.add('Consider extending sessions by 5-10 minutes');
        recommendations.add('Your focus is improving - great job!');
        break;
      case PerformanceTrend.declining:
        recommendations.add('Consider shortening sessions by 5-10 minutes');
        recommendations.add('Take more frequent breaks to maintain focus');
        break;
      case PerformanceTrend.stable:
        recommendations.add('Current session duration is optimal');
        recommendations.add('Maintain your current routine');
        break;
    }

    // Duration-based recommendations
    if (optimalRange.min < 20) {
      recommendations.add('Consider increasing session duration for better deep work');
    } else if (optimalRange.max > 40) {
      recommendations.add('Consider shorter sessions for better focus');
    }

    // Focus pattern recommendations
    final focusPattern = _detectFocusPattern(sessions);
    switch (focusPattern) {
      case FocusPattern.inconsistent:
        recommendations.add('Try to maintain consistent session times');
        recommendations.add('Consider using a timer to track focus');
        break;
      case FocusPattern.consistent:
        recommendations.add('Excellent focus consistency!');
        break;
      case FocusPattern.moderate:
        recommendations.add('Good focus with room for improvement');
        break;
    }

    return recommendations;
  }

  List<Task> _findSimilarTasks(Task task, List<CompletedPomodoroSession> userHistory) {
    // This would need access to task repository
    // For now, return empty list
    // In a real implementation, this would find tasks with similar characteristics
    return [];
  }

  List<CompletedPomodoroSession> _findSimilarSessions(Task task, List<CompletedPomodoroSession> sessions) {
    // This would need access to task repository to find similar tasks
    // For now, return empty list
    return [];
  }

  double _calculateVariance(List<double> values) {
    if (values.isEmpty) return 0.0;

    final mean = values.reduce((a, b) => a + b) / values.length;
    final variance = values.map((x) => (x - mean) * (x - mean)).reduce((a, b) => a + b) / values.length;
    return variance;
  }
}

// Supporting classes and enums
class SessionPatternAnalysis {
  final int averageSessionDuration;
  final DurationRange optimalDurationRange;
  final PerformanceTrend performanceTrend;
  final List<String> recommendedAdjustments;
  final FocusPattern focusPattern;
  final EnergyPattern energyPattern;

  SessionPatternAnalysis({
    required this.averageSessionDuration,
    required this.optimalDurationRange,
    required this.performanceTrend,
    required this.recommendedAdjustments,
    required this.focusPattern,
    required this.energyPattern,
  });
}

class DurationRange {
  final int min;
  final int max;

  DurationRange({required this.min, required this.max});
}

enum PerformanceTrend { improving, stable, declining }

enum FocusPattern { consistent, moderate, inconsistent }

enum EnergyPattern { stable, moderate, inconsistent }

enum AdjustmentType { none, extend, shorten }

class SessionAdjustmentSuggestion {
  final bool needsAdjustment;
  final String adjustmentReason;
  final int suggestedDuration;
  final AdjustmentType adjustmentType;
  final double currentPerformance;
  final double progressPercentage;

  SessionAdjustmentSuggestion({
    required this.needsAdjustment,
    required this.adjustmentReason,
    required this.suggestedDuration,
    required this.adjustmentType,
    required this.currentPerformance,
    required this.progressPercentage,
  });
}
