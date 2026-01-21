import '../models/task.dart';
import '../models/pomodoro_plan.dart';
import '../services/pomodoro_recommendation_engine.dart';
import '../services/adaptive_session_timing_service.dart';
import 'app_logging_service.dart';
import 'notification_service.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/services/navigation_service.dart';

/// Enhanced notification service for pomodoro workflow
class PomodoroNotificationService {
  final NotificationService _notificationService;
  final PomodoroRecommendationEngine _recommendationEngine;

  PomodoroNotificationService({required NotificationService notificationService, required PomodoroRecommendationEngine recommendationEngine, AdaptiveSessionTimingService? timingService})
    : _notificationService = notificationService,
      _recommendationEngine = recommendationEngine;

  AppLocalizations? get _l10n {
    final context = NavigationService.navigatorKey.currentContext;
    return context != null ? AppLocalizations.of(context) : null;
  }

  /// Initialize pomodoro notification channel
  Future<void> initialize() async {
    AppLogging.logInfo('Initializing pomodoro notification service', name: 'PomodoroNotificationService');

    // Initialize notification channel (handled by NotificationService)
    await _notificationService.initialize();
  }

  /// Send pre-session task briefing notification
  Future<void> sendTaskBriefingNotification(Task task, PomodoroPlan plan) async {
    AppLogging.logInfo('Sending task briefing for: ${task.title}', name: 'PomodoroNotificationService');

    final l10n = _l10n;
    final title = l10n?.startingTask(task.title) ?? '🍅 Starting: ${task.title}';
    final body = _buildTaskBriefingBody(task, plan);
    final payload = _buildTaskPayload(task, 'briefing');

    await _notificationService.showImmediateNotification(title, body, payload: payload);
  }

  /// Send session completion notification with next task prep
  Future<void> sendSessionCompletionNotification({required Task? completedTask, required int sessionNumber, required int totalSessions, required int focusRating, required bool wasCompleted, Task? nextTask}) async {
    AppLogging.logInfo('Sending session completion notification', name: 'PomodoroNotificationService');

    final l10n = _l10n;
    final title = wasCompleted ? (l10n?.sessionComplete ?? '✅ Session Complete!') : (l10n?.sessionPaused ?? '⏸️ Session Paused');
    final body = _buildSessionCompletionBody(sessionNumber, totalSessions, focusRating, completedTask, nextTask);
    final payload = _buildSessionPayload(completedTask, sessionNumber, wasCompleted);

    await _notificationService.showImmediateNotification(title, body, payload: payload);
  }

  /// Send progress update notification for long task chains
  Future<void> sendProgressUpdateNotification({required Task currentTask, required int completedSessions, required int totalSessions, required double overallProgress}) async {
    AppLogging.logInfo('Sending progress update for: ${currentTask.title}', name: 'PomodoroNotificationService');

    final l10n = _l10n;
    final title = l10n?.progressUpdate ?? '📈 Progress Update';
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

    final l10n = _l10n;
    final title = l10n?.queueComplete ?? '🎉 Queue Complete!';
    final body = _buildQueueCompletionBody(completedTasks);
    final payload = _buildQueuePayload(completedTasks);

    await _notificationService.showImmediateNotification(title, body, payload: payload);
  }

  /// Send daily summary notification
  Future<void> sendDailySummaryNotification({required int totalSessions, required double avgFocus, required int completedTasks, required int currentStreak}) async {
    AppLogging.logInfo('Sending daily summary notification', name: 'PomodoroNotificationService');

    final l10n = _l10n;
    final title = l10n?.dailySummary ?? '📊 Daily Summary';
    final body = _buildDailySummaryBody(totalSessions, avgFocus, completedTasks, currentStreak);
    final payload = _buildDailySummaryPayload(totalSessions, avgFocus, completedTasks, currentStreak);

    await _notificationService.showImmediateNotification(title, body, payload: payload);
  }

  /// Send motivational notification for streak maintenance
  Future<void> sendStreakMotivationNotification({required int currentStreak, required int targetStreak}) async {
    AppLogging.logInfo('Sending streak motivation notification', name: 'PomodoroNotificationService');

    final l10n = _l10n;
    final title = l10n?.keepItGoing ?? '🔥 Keep it Going!';
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

    final l10n = _l10n;
    final title = l10n?.weeklyGoalProgress ?? '🎯 Weekly Goal Progress';
    final body = _buildWeeklyGoalBody(currentProgress, weeklyGoal, daysRemaining);
    final payload = _buildWeeklyGoalPayload(currentProgress, weeklyGoal, daysRemaining);

    await _notificationService.showImmediateNotification(title, body, payload: payload);
  }

  // Private helper methods for building notification content

  String _buildTaskBriefingBody(Task task, PomodoroPlan plan) {
    if (_l10n == null) return '';
    final l10n = _l10n!;
    final buffer = StringBuffer();

    buffer.writeln(l10n.sessionsPlanned(plan.totalSessions));
    buffer.writeln(l10n.minutesPerSession(plan.workDuration));
    buffer.writeln(l10n.focusLevel(task.focusScore));

    if (task.description != null && task.description!.isNotEmpty) {
      buffer.writeln('📝 ${task.description!.substring(0, 50)}${task.description!.length > 50 ? '...' : ''}');
    }

    if (plan.sessions.isNotEmpty && plan.sessions.first.focusArea != null) {
      buffer.writeln(l10n.focusArea(plan.sessions.first.focusArea!));
    }

    return buffer.toString().trim();
  }

  String _buildSessionCompletionBody(int sessionNumber, int totalSessions, int focusRating, Task? completedTask, Task? nextTask) {
    if (_l10n == null) return '';
    final l10n = _l10n!;
    final buffer = StringBuffer();

    buffer.writeln(l10n.sessionNofM(sessionNumber, totalSessions));
    buffer.writeln(l10n.focusRating(focusRating));

    if (completedTask != null) {
      buffer.writeln(l10n.completedTaskNotification(completedTask.title));
    }

    if (nextTask != null) {
      buffer.writeln(l10n.nextTask(nextTask.title));
      buffer.writeln(l10n.priorityLabel(nextTask.priority.name));
    } else {
      buffer.writeln(l10n.allTasksCompleted);
    }

    return buffer.toString().trim();
  }

  String _buildProgressUpdateBody(Task currentTask, int completedSessions, int totalSessions, double overallProgress) {
    if (_l10n == null) return '';
    final l10n = _l10n!;
    final buffer = StringBuffer();

    buffer.writeln('${l10n.taskTitle}: ${currentTask.title}');
    buffer.writeln(l10n.progressPercent((overallProgress * 100).toInt()));
    buffer.writeln(l10n.sessionsProgress(completedSessions, totalSessions));

    if (overallProgress >= 0.75) {
      buffer.writeln(l10n.almostThere);
    } else if (overallProgress >= 0.5) {
      buffer.writeln(l10n.halfwayDone);
    } else {
      buffer.writeln(l10n.greatStart);
    }

    return buffer.toString().trim();
  }

  String _buildBreakBody(BreakType breakType, int duration, BreakActivity activity) {
    if (_l10n == null) return '';
    final l10n = _l10n!;
    final buffer = StringBuffer();

    buffer.writeln(l10n.minuteBreak(duration, _getBreakTitle(breakType)));
    buffer.writeln(l10n.suggestedActivity(_getActivityDescription(activity)));

    if (breakType == BreakType.longBreak) {
      buffer.writeln(l10n.timeToRecharge);
    } else {
      buffer.writeln(l10n.quickRefresh);
    }

    return buffer.toString().trim();
  }

  String _buildQueueCompletionBody(List<Task> completedTasks) {
    if (_l10n == null) return '';
    final l10n = _l10n!;
    final buffer = StringBuffer();

    buffer.writeln(l10n.allTasksCompletedCount(completedTasks.length));
    buffer.writeln(l10n.totalTime(_calculateTotalTime(completedTasks)));
    buffer.writeln(l10n.greatJobFocused);

    return buffer.toString().trim();
  }

  String _buildDailySummaryBody(int totalSessions, double avgFocus, int completedTasks, int currentStreak) {
    if (_l10n == null) return '';
    final l10n = _l10n!;
    final buffer = StringBuffer();

    buffer.writeln(l10n.todaysPerformance);
    buffer.writeln(l10n.sessionsCount(totalSessions));
    buffer.writeln(l10n.avgFocus(avgFocus.toStringAsFixed(1)));
    buffer.writeln(l10n.tasksCompletedCount(completedTasks));
    buffer.writeln(l10n.dayStreak(currentStreak));

    if (avgFocus >= 8) {
      buffer.writeln(l10n.excellentFocus);
    } else if (avgFocus >= 6) {
      buffer.writeln(l10n.goodFocus);
    } else {
      buffer.writeln(l10n.tomorrowsNewDay);
    }

    return buffer.toString().trim();
  }

  String _buildStreakMotivationBody(int currentStreak, int targetStreak) {
    if (_l10n == null) return '';
    final l10n = _l10n!;
    final buffer = StringBuffer();

    buffer.writeln(l10n.currentStreakDays(currentStreak));

    if (currentStreak >= targetStreak) {
      buffer.writeln(l10n.goalAchievedNewTarget(targetStreak + 7));
    } else {
      buffer.writeln(l10n.targetDays(targetStreak));
      buffer.writeln(l10n.daysToGo(targetStreak - currentStreak));
    }

    if (currentStreak >= 7) {
      buffer.writeln(l10n.youreOnFire);
    } else if (currentStreak >= 3) {
      buffer.writeln(l10n.buildingMomentum);
    } else {
      buffer.writeln(l10n.keepItGoingBody);
    }

    return buffer.toString().trim();
  }

  String _buildAdaptiveTimingBody(Task task, int suggestedDuration, String reason) {
    if (_l10n == null) return '';
    final l10n = _l10n!;
    final buffer = StringBuffer();

    buffer.writeln('${l10n.taskTitle}: ${task.title}');
    buffer.writeln(l10n.suggestedDuration(suggestedDuration));
    buffer.writeln(l10n.reason(reason));

    return buffer.toString().trim();
  }

  String _buildEnergyLevelBody(EnergyLevel currentEnergy, List<Task> recommendedTasks) {
    if (_l10n == null) return '';
    final l10n = _l10n!;
    final buffer = StringBuffer();

    buffer.writeln(l10n.currentEnergyLevel(currentEnergy.name));

    if (recommendedTasks.isNotEmpty) {
      buffer.writeln(l10n.recommendedTasks);
      for (int i = 0; i < recommendedTasks.length && i < 3; i++) {
        buffer.writeln('• ${recommendedTasks[i].title}');
      }
    } else {
      buffer.writeln(l10n.considerLighterTasks);
    }

    return buffer.toString().trim();
  }

  String _buildWeeklyGoalBody(int currentProgress, int weeklyGoal, int daysRemaining) {
    if (_l10n == null) return '';
    final l10n = _l10n!;
    final buffer = StringBuffer();

    buffer.writeln(l10n.weeklyGoalSessions(weeklyGoal));
    buffer.writeln(l10n.weeklyProgressStatus(currentProgress, weeklyGoal));
    buffer.writeln(l10n.daysRemaining(daysRemaining));

    final progress = currentProgress / weeklyGoal;
    if (progress >= 1.0) {
      buffer.writeln(l10n.goalAchieved);
    } else if (progress >= 0.8) {
      buffer.writeln(l10n.almostThereKeepItUp);
    } else if (progress >= 0.5) {
      buffer.writeln(l10n.halfwayThere);
    } else {
      buffer.writeln(l10n.pickUpPace);
    }

    return buffer.toString().trim();
  }

  // Private helper methods for titles and payloads

  String _getBreakTitle(BreakType breakType) {
    if (_l10n == null) return '';
    final l10n = _l10n!;
    switch (breakType) {
      case BreakType.shortBreak:
        return l10n.breakTitleShort;
      case BreakType.longBreak:
        return l10n.breakTitleLong;
    }
  }

  String _getAdaptiveTimingTitle(AdjustmentType adjustmentType) {
    if (_l10n == null) return '';
    final l10n = _l10n!;
    switch (adjustmentType) {
      case AdjustmentType.extend:
        return l10n.extendSession;
      case AdjustmentType.shorten:
        return l10n.shortenSession;
      case AdjustmentType.none:
        return l10n.sessionOptimization;
    }
  }

  String _getEnergyLevelTitle(EnergyLevel energyLevel) {
    if (_l10n == null) return '';
    final l10n = _l10n!;
    switch (energyLevel) {
      case EnergyLevel.veryHigh:
        return l10n.energyLevelHigh;
      case EnergyLevel.high:
        return l10n.energyLevelGood;
      case EnergyLevel.medium:
        return l10n.energyLevelModerate;
      case EnergyLevel.low:
        return l10n.energyLevelLow;
      case EnergyLevel.veryLow:
        return l10n.energyLevelVeryLow;
    }
  }

  String _getActivityDescription(BreakActivity activity) {
    if (_l10n == null) return '';
    final l10n = _l10n!;
    switch (activity) {
      case BreakActivity.meditation:
        return l10n.activityMeditation;
      case BreakActivity.stretching:
        return l10n.activityStretching;
      case BreakActivity.hydration:
        return l10n.activityHydration;
      case BreakActivity.eyeRest:
        return l10n.activityEyeRest;
      case BreakActivity.walking:
        return l10n.activityWalking;
      case BreakActivity.breathing:
        return l10n.activityBreathing;
      case BreakActivity.music:
        return l10n.activityMusic;
      case BreakActivity.social:
        return l10n.activitySocial;
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
