import '../models/task.dart';
import '../models/pomodoro_plan.dart';
import '../services/pomodoro_recommendation_engine.dart';
import '../services/adaptive_session_timing_service.dart';
import 'app_logging_service.dart';
import 'notification_service.dart';

/// Enhanced notification service for pomodoro workflow
class PomodoroNotificationService {
  final NotificationService _notificationService;
  final PomodoroRecommendationEngine _recommendationEngine;

  PomodoroNotificationService({required NotificationService notificationService, required PomodoroRecommendationEngine recommendationEngine, AdaptiveSessionTimingService? timingService})
    : _notificationService = notificationService,
      _recommendationEngine = recommendationEngine;

  /// Initialize pomodoro notification channel
  Future<void> initialize() async {
    AppLogging.logInfo('Initializing pomodoro notification service', name: 'PomodoroNotificationService');

    // Initialize notification channel (handled by NotificationService)
    await _notificationService.initialize();
  }

  /// Send pre-session task briefing notification
  Future<void> sendTaskBriefingNotification(Task task, PomodoroPlan plan) async {
    AppLogging.logInfo('Sending task briefing for: ${task.title}', name: 'PomodoroNotificationService');

    final title = '🍅 Starting: ${task.title}';
    final body = _buildTaskBriefingBody(task, plan);
    final payload = _buildTaskPayload(task, 'briefing');

    await _notificationService.showImmediateNotification(title, body, payload: payload);
  }

  /// Send session completion notification with next task prep
  Future<void> sendSessionCompletionNotification({required Task? completedTask, required int sessionNumber, required int totalSessions, required int focusRating, required bool wasCompleted, Task? nextTask}) async {
    AppLogging.logInfo('Sending session completion notification', name: 'PomodoroNotificationService');

    final title = wasCompleted ? '✅ Session Complete!' : '⏸️ Session Paused';
    final body = _buildSessionCompletionBody(sessionNumber, totalSessions, focusRating, completedTask, nextTask);
    final payload = _buildSessionPayload(completedTask, sessionNumber, wasCompleted);

    await _notificationService.showImmediateNotification(title, body, payload: payload);
  }

  /// Send progress update notification for long task chains
  Future<void> sendProgressUpdateNotification({required Task currentTask, required int completedSessions, required int totalSessions, required double overallProgress}) async {
    AppLogging.logInfo('Sending progress update for: ${currentTask.title}', name: 'PomodoroNotificationService');

    final title = '📈 Progress Update';
    final body = _buildProgressUpdateBody(currentTask, completedSessions, totalSessions, overallProgress);
    final payload = _buildProgressPayload(currentTask, overallProgress);

    await _notificationService.showImmediateNotification(title, body, payload: payload);
  }

  /// Send break notification with activity suggestion
  Future<void> sendBreakNotification({required BreakType breakType, required int duration, Task? completedTask, int? focusRating}) async {
    AppLogging.logInfo('Sending break notification', name: 'PomodoroNotificationService');

    final activity = completedTask != null ? _recommendationEngine.suggestBreakActivity(completedTask, focusRating: focusRating) : _getDefaultBreakActivity(breakType);

    final title = _getBreakTitle(breakType);
    final body = _buildBreakBody(breakType, duration, activity);
    final payload = _buildBreakPayload(breakType, activity);

    await _notificationService.showImmediateNotification(title, body, payload: payload);
  }

  /// Send task queue completion notification
  Future<void> sendQueueCompletionNotification(List<Task> completedTasks) async {
    AppLogging.logInfo('Sending queue completion notification', name: 'PomodoroNotificationService');

    final title = '🎉 Queue Complete!';
    final body = _buildQueueCompletionBody(completedTasks);
    final payload = _buildQueuePayload(completedTasks);

    await _notificationService.showImmediateNotification(title, body, payload: payload);
  }

  /// Send daily summary notification
  Future<void> sendDailySummaryNotification({required int totalSessions, required double avgFocus, required int completedTasks, required int currentStreak}) async {
    AppLogging.logInfo('Sending daily summary notification', name: 'PomodoroNotificationService');

    final title = '📊 Daily Summary';
    final body = _buildDailySummaryBody(totalSessions, avgFocus, completedTasks, currentStreak);
    final payload = _buildDailySummaryPayload(totalSessions, avgFocus, completedTasks, currentStreak);

    await _notificationService.showImmediateNotification(title, body, payload: payload);
  }

  /// Send motivational notification for streak maintenance
  Future<void> sendStreakMotivationNotification({required int currentStreak, required int targetStreak}) async {
    AppLogging.logInfo('Sending streak motivation notification', name: 'PomodoroNotificationService');

    final title = '🔥 Keep it Going!';
    final body = _buildStreakMotivationBody(currentStreak, targetStreak);
    final payload = _buildStreakPayload(currentStreak, targetStreak);

    await _notificationService.showImmediateNotification(title, body, payload: payload);
  }

  /// Send adaptive timing suggestion notification
  Future<void> sendAdaptiveTimingNotification({required Task task, required int suggestedDuration, required String reason, required AdjustmentType adjustmentType}) async {
    AppLogging.logInfo('Sending adaptive timing notification', name: 'PomodoroNotificationService');

    final title = _getAdaptiveTimingTitle(adjustmentType);
    final body = _buildAdaptiveTimingBody(task, suggestedDuration, reason);
    final payload = _buildAdaptiveTimingPayload(task, suggestedDuration, adjustmentType);

    await _notificationService.showImmediateNotification(title, body, payload: payload);
  }

  /// Send energy level reminder notification
  Future<void> sendEnergyLevelReminder({required EnergyLevel currentEnergy, required List<Task> recommendedTasks}) async {
    AppLogging.logInfo('Sending energy level reminder', name: 'PomodoroNotificationService');

    final title = _getEnergyLevelTitle(currentEnergy);
    final body = _buildEnergyLevelBody(currentEnergy, recommendedTasks);
    final payload = _buildEnergyLevelPayload(currentEnergy, recommendedTasks);

    await _notificationService.showImmediateNotification(title, body, payload: payload);
  }

  /// Send weekly goal reminder notification
  Future<void> sendWeeklyGoalReminder({required int currentProgress, required int weeklyGoal, required int daysRemaining}) async {
    AppLogging.logInfo('Sending weekly goal reminder', name: 'PomodoroNotificationService');

    final title = '🎯 Weekly Goal Progress';
    final body = _buildWeeklyGoalBody(currentProgress, weeklyGoal, daysRemaining);
    final payload = _buildWeeklyGoalPayload(currentProgress, weeklyGoal, daysRemaining);

    await _notificationService.showImmediateNotification(title, body, payload: payload);
  }

  // Private helper methods for building notification content

  String _buildTaskBriefingBody(Task task, PomodoroPlan plan) {
    final buffer = StringBuffer();

    buffer.writeln('📋 ${plan.totalSessions} sessions planned');
    buffer.writeln('⏱️ ${plan.workDuration} min per session');
    buffer.writeln('🎯 Focus level: ${task.focusScore}/10');

    if (task.description != null && task.description!.isNotEmpty) {
      buffer.writeln('📝 ${task.description!.substring(0, 50)}${task.description!.length > 50 ? '...' : ''}');
    }

    if (plan.sessions.isNotEmpty && plan.sessions.first.focusArea != null) {
      buffer.writeln('🎯 Focus: ${plan.sessions.first.focusArea}');
    }

    return buffer.toString().trim();
  }

  String _buildSessionCompletionBody(int sessionNumber, int totalSessions, int focusRating, Task? completedTask, Task? nextTask) {
    final buffer = StringBuffer();

    buffer.writeln('Session $sessionNumber of $totalSessions');
    buffer.writeln('Focus rating: $focusRating/10');

    if (completedTask != null) {
      buffer.writeln('Completed: ${completedTask.title}');
    }

    if (nextTask != null) {
      buffer.writeln('Next: ${nextTask.title}');
      buffer.writeln('Priority: ${nextTask.priority.name}');
    } else {
      buffer.writeln('🎉 All tasks completed!');
    }

    return buffer.toString().trim();
  }

  String _buildProgressUpdateBody(Task currentTask, int completedSessions, int totalSessions, double overallProgress) {
    final buffer = StringBuffer();

    buffer.writeln('Task: ${currentTask.title}');
    buffer.writeln('Progress: ${(overallProgress * 100).toInt()}%');
    buffer.writeln('Sessions: $completedSessions/$totalSessions');

    if (overallProgress >= 0.75) {
      buffer.writeln('🔥 Almost there! Keep going!');
    } else if (overallProgress >= 0.5) {
      buffer.writeln('💪 Halfway done!');
    } else {
      buffer.writeln('🚀 Great start!');
    }

    return buffer.toString().trim();
  }

  String _buildBreakBody(BreakType breakType, int duration, BreakActivity activity) {
    final buffer = StringBuffer();

    buffer.writeln('⏰ $duration minute ${breakType.name}');
    buffer.writeln('💡 Suggested activity: ${_getActivityDescription(activity)}');

    if (breakType == BreakType.longBreak) {
      buffer.writeln('🌿 Time to recharge!');
    } else {
      buffer.writeln('🧘 Quick refresh');
    }

    return buffer.toString().trim();
  }

  String _buildQueueCompletionBody(List<Task> completedTasks) {
    final buffer = StringBuffer();

    buffer.writeln('🎉 All ${completedTasks.length} tasks completed!');
    buffer.writeln('⏱️ Total time: ${_calculateTotalTime(completedTasks)}');
    buffer.writeln('🔥 Great job staying focused!');

    return buffer.toString().trim();
  }

  String _buildDailySummaryBody(int totalSessions, double avgFocus, int completedTasks, int currentStreak) {
    final buffer = StringBuffer();

    buffer.writeln('📊 Today\'s Performance:');
    buffer.writeln('⏱️ $totalSessions sessions');
    buffer.writeln('🎯 Avg focus: ${avgFocus.toStringAsFixed(1)}/10');
    buffer.writeln('✅ $completedTasks tasks completed');
    buffer.writeln('🔥 $currentStreak day streak');

    if (avgFocus >= 8) {
      buffer.writeln('🌟 Excellent focus today!');
    } else if (avgFocus >= 6) {
      buffer.writeln('👍 Good focus maintained!');
    } else {
      buffer.writeln('💪 Tomorrow\'s a new day!');
    }

    return buffer.toString().trim();
  }

  String _buildStreakMotivationBody(int currentStreak, int targetStreak) {
    final buffer = StringBuffer();

    buffer.writeln('🔥 Current streak: $currentStreak days');

    if (currentStreak >= targetStreak) {
      buffer.writeln('🏆 Goal achieved! New target: ${targetStreak + 7} days');
    } else {
      buffer.writeln('🎯 Target: $targetStreak days');
      buffer.writeln('📈 ${targetStreak - currentStreak} days to go!');
    }

    if (currentStreak >= 7) {
      buffer.writeln('💪 You\'re on fire!');
    } else if (currentStreak >= 3) {
      buffer.writeln('🌟 Building momentum!');
    } else {
      buffer.writeln('🚀 Keep it going!');
    }

    return buffer.toString().trim();
  }

  String _buildAdaptiveTimingBody(Task task, int suggestedDuration, String reason) {
    final buffer = StringBuffer();

    buffer.writeln('Task: ${task.title}');
    buffer.writeln('⏱️ Suggested: $suggestedDuration min');
    buffer.writeln('💭 Reason: $reason');

    return buffer.toString().trim();
  }

  String _buildEnergyLevelBody(EnergyLevel currentEnergy, List<Task> recommendedTasks) {
    final buffer = StringBuffer();

    buffer.writeln('⚡ Current energy: ${currentEnergy.name}');

    if (recommendedTasks.isNotEmpty) {
      buffer.writeln('📋 Recommended tasks:');
      for (int i = 0; i < recommendedTasks.length && i < 3; i++) {
        buffer.writeln('• ${recommendedTasks[i].title}');
      }
    } else {
      buffer.writeln('🌿 Consider lighter tasks or take a break');
    }

    return buffer.toString().trim();
  }

  String _buildWeeklyGoalBody(int currentProgress, int weeklyGoal, int daysRemaining) {
    final buffer = StringBuffer();

    buffer.writeln('🎯 Weekly Goal: $weeklyGoal sessions');
    buffer.writeln('✅ Progress: $currentProgress/$weeklyGoal');
    buffer.writeln('📅 Days remaining: $daysRemaining');

    final progress = currentProgress / weeklyGoal;
    if (progress >= 1.0) {
      buffer.writeln('🏆 Goal achieved! Amazing work!');
    } else if (progress >= 0.8) {
      buffer.writeln('🌟 Almost there! Keep it up!');
    } else if (progress >= 0.5) {
      buffer.writeln('💪 Halfway there!');
    } else {
      buffer.writeln('🚀 Let\'s pick up the pace!');
    }

    return buffer.toString().trim();
  }

  // Private helper methods for titles and payloads

  String _getBreakTitle(BreakType breakType) {
    switch (breakType) {
      case BreakType.shortBreak:
        return '☕ Short Break';
      case BreakType.longBreak:
        return '🌿 Long Break';
    }
  }

  String _getAdaptiveTimingTitle(AdjustmentType adjustmentType) {
    switch (adjustmentType) {
      case AdjustmentType.extend:
        return '⏱️ Extend Session';
      case AdjustmentType.shorten:
        return '⏰ Shorten Session';
      case AdjustmentType.none:
        return '⚙️ Session Optimization';
    }
  }

  String _getEnergyLevelTitle(EnergyLevel energyLevel) {
    switch (energyLevel) {
      case EnergyLevel.veryHigh:
        return '⚡ High Energy!';
      case EnergyLevel.high:
        return '🔥 Good Energy';
      case EnergyLevel.medium:
        return '⚖️ Moderate Energy';
      case EnergyLevel.low:
        return '🔋 Low Energy';
      case EnergyLevel.veryLow:
        return '😴 Very Low Energy';
    }
  }

  String _getActivityDescription(BreakActivity activity) {
    switch (activity) {
      case BreakActivity.meditation:
        return 'Mindful breathing (2-5 min)';
      case BreakActivity.stretching:
        return 'Desk stretches (2-3 min)';
      case BreakActivity.hydration:
        return 'Drink water & walk around';
      case BreakActivity.eyeRest:
        return '20-20-20 eye exercises';
      case BreakActivity.walking:
        return 'Short walk (3-5 min)';
      case BreakActivity.breathing:
        return 'Deep breathing exercises';
      case BreakActivity.music:
        return 'Listen to calming music';
      case BreakActivity.social:
        return 'Quick chat with colleague';
    }
  }

  BreakActivity _getDefaultBreakActivity(BreakType breakType) {
    switch (breakType) {
      case BreakType.shortBreak:
        return BreakActivity.hydration;
      case BreakType.longBreak:
        return BreakActivity.walking;
    }
  }

  String _calculateTotalTime(List<Task> tasks) {
    // This would calculate actual time spent on tasks
    // For now, return a mock value
    final totalMinutes = tasks.length * 25; // Assume 25 min per task
    if (totalMinutes < 60) {
      return '${totalMinutes}min';
    } else {
      final hours = totalMinutes ~/ 60;
      final minutes = totalMinutes % 60;
      return '${hours}h ${minutes}min';
    }
  }

  // Payload building methods

  String _buildTaskPayload(Task task, String type) {
    return 'pomodoro://task/${task.id}?type=$type&title=${Uri.encodeComponent(task.title)}';
  }

  String _buildSessionPayload(Task? task, int sessionNumber, bool completed) {
    final taskId = task?.id ?? 'unknown';
    final status = completed ? 'completed' : 'paused';
    return 'pomodoro://session/$sessionNumber?taskId=$taskId&status=$status';
  }

  String _buildProgressPayload(Task task, double progress) {
    return 'pomodoro://progress/${task.id}?progress=${(progress * 100).toInt()}';
  }

  String _buildBreakPayload(BreakType breakType, BreakActivity activity) {
    return 'pomodoro://break/${breakType.name}?activity=${activity.name}';
  }

  String _buildQueuePayload(List<Task> tasks) {
    final taskIds = tasks.map((t) => t.id).join(',');
    return 'pomodoro://queue/complete?tasks=$taskIds';
  }

  String _buildDailySummaryPayload(int sessions, double focus, int tasks, int streak) {
    return 'pomodoro://daily/summary?sessions=$sessions&focus=$focus&tasks=$tasks&streak=$streak';
  }

  String _buildStreakPayload(int currentStreak, int targetStreak) {
    return 'pomodoro://streak/motivation?current=$currentStreak&target=$targetStreak';
  }

  String _buildAdaptiveTimingPayload(Task task, int duration, AdjustmentType type) {
    return 'pomodoro://timing/adaptive?taskId=${task.id}&duration=$duration&type=${type.name}';
  }

  String _buildEnergyLevelPayload(EnergyLevel energy, List<Task> tasks) {
    final taskIds = tasks.map((t) => t.id).join(',');
    return 'pomodoro://energy/${energy.name}?tasks=$taskIds';
  }

  String _buildWeeklyGoalPayload(int progress, int goal, int days) {
    return 'pomodoro://weekly/goal?progress=$progress&goal=$goal&days=$days';
  }
}

// Supporting enums
enum BreakType { shortBreak, longBreak }

enum AdjustmentType { none, extend, shorten }
