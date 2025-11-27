import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tazbeet/services/app_logging_service.dart';
import '../../models/notification_item.dart';
import '../../models/task.dart';
import '../../repositories/notification_repository.dart';
import '../../services/notification_service.dart';
import 'notification_event.dart';
import 'notification_state.dart';

/// BLoC for managing notification state, preferences, and history
///
/// This BLoC centralizes all notification-related business logic including:
/// - Scheduling and canceling notifications
/// - Managing notification preferences and DND mode
/// - Tracking notification history and analytics
/// - Handling permission states
/// - Filtering and searching notification history
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;
  final NotificationService _notificationService;
  Timer? _dndTimer;
  Timer? _refreshTimer;

  NotificationBloc({NotificationRepository? repository, NotificationService? notificationService})
    : _repository = repository ?? NotificationRepository(),
      _notificationService = notificationService ?? NotificationService(),
      super(const NotificationInitial()) {
    // Register event handlers
    on<InitializeNotifications>(_onInitialize);
    on<LoadNotificationHistory>(_onLoadHistory);
    on<LoadNotificationPreferences>(_onLoadPreferences);
    on<ScheduleTaskReminder>(_onScheduleTaskReminder);
    on<CancelTaskReminder>(_onCancelTaskReminder);
    on<ScheduleMoodCheckIns>(_onScheduleMoodCheckIns);
    on<CancelMoodCheckIns>(_onCancelMoodCheckIns);
    on<ShowImmediateNotification>(_onShowImmediate);
    on<MarkNotificationDelivered>(_onMarkDelivered);
    on<MarkNotificationInteracted>(_onMarkInteracted);
    on<MarkNotificationFailed>(_onMarkFailed);
    on<RetryFailedNotification>(_onRetryFailed);
    on<UpdateNotificationPreferences>(_onUpdatePreferences);
    on<UpdateTypePreferences>(_onUpdateTypePreferences);
    on<ToggleDoNotDisturb>(_onToggleDND);
    on<UpdateQuietHours>(_onUpdateQuietHours);
    on<ClearNotificationHistory>(_onClearHistory);
    on<DeleteNotification>(_onDeleteNotification);
    on<RequestNotificationPermissions>(_onRequestPermissions);
    on<CheckNotificationPermissions>(_onCheckPermissions);
    on<GetPendingNotifications>(_onGetPending);
    on<CancelAllNotifications>(_onCancelAll);
    on<RescheduleAllReminders>(_onRescheduleAll);
    on<LoadNotificationAnalytics>(_onLoadAnalytics);
    on<SendTestNotification>(_onSendTest);
    on<OpenNotificationSettings>(_onOpenSettings);
    on<FilterNotificationsByType>(_onFilterByType);
    on<FilterNotificationsByStatus>(_onFilterByStatus);
    on<SearchNotifications>(_onSearchNotifications);

    // Start periodic refresh of pending notifications
    _startPeriodicRefresh();
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      add(const GetPendingNotifications());
    });
  }

  Future<void> _onInitialize(InitializeNotifications event, Emitter<NotificationState> emit) async {
    try {
      emit(const NotificationLoading());

      // Initialize repository
      await _repository.init();

      // Initialize notification service
      await _notificationService.initialize();

      // Load preferences
      final preferences = _repository.getPreferences();

      // Check permissions
      final permissionsGranted = await _notificationService.areNotificationsEnabled();

      // Load recent notification history
      final notifications = _repository.getRecentNotifications(days: 30);

      // Get pending notifications
      final pending = await _notificationService.getPendingNotifications();

      emit(NotificationLoaded(allNotifications: notifications, filteredNotifications: notifications, preferences: preferences, permissionsGranted: permissionsGranted, pendingNotifications: pending));

      AppLogging.logInfo('NotificationBloc initialized successfully', name: 'NotificationBloc');
    } catch (e, stackTrace) {
      AppLogging.logError('Failed to initialize NotificationBloc: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to initialize notifications: $e', stackTrace: stackTrace));
    }
  }

  Future<void> _onLoadHistory(LoadNotificationHistory event, Emitter<NotificationState> emit) async {
    try {
      final notifications = event.days != null ? _repository.getRecentNotifications(days: event.days!) : _repository.getAllNotifications();

      if (state is NotificationLoaded) {
        final currentState = state as NotificationLoaded;
        emit(currentState.copyWith(allNotifications: notifications, filteredNotifications: _applyFilters(notifications, currentState)));
      }
    } catch (e) {
      AppLogging.logError('Failed to load notification history: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to load history: $e', previousState: state));
    }
  }

  Future<void> _onLoadPreferences(LoadNotificationPreferences event, Emitter<NotificationState> emit) async {
    try {
      final preferences = _repository.getPreferences();
      if (state is NotificationLoaded) {
        emit((state as NotificationLoaded).copyWith(preferences: preferences));
      }
    } catch (e) {
      AppLogging.logError('Failed to load preferences: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to load preferences: $e', previousState: state));
    }
  }

  Future<void> _onScheduleTaskReminder(ScheduleTaskReminder event, Emitter<NotificationState> emit) async {
    try {
      emit(NotificationActionInProgress('scheduling', state));

      final task = event.task;

      // Create notification item for tracking
      final notificationItem = NotificationItem(
        id: 'task_${task.id}_${task.reminderDate?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch}',
        title: 'Task Reminder',
        body: 'Don\'t forget: ${task.title}',
        type: NotificationType.taskReminder,
        priority: _getTaskPriority(task.priority),
        createdAt: DateTime.now(),
        scheduledAt: task.reminderDate,
        relatedTaskId: task.id,
        actionButtons: ['Complete', 'Snooze', 'View'],
        groupKey: 'task_reminders',
      );

      // Save to history
      await _repository.saveNotification(notificationItem);

      // Schedule actual notification
      await _notificationService.scheduleTaskReminder(task);

      // Reload state
      add(const LoadNotificationHistory());
      add(const GetPendingNotifications());

      AppLogging.logInfo('Scheduled task reminder: ${task.id}', name: 'NotificationBloc');
    } catch (e) {
      AppLogging.logError('Failed to schedule task reminder: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to schedule reminder: $e', previousState: state));
    }
  }

  Future<void> _onCancelTaskReminder(CancelTaskReminder event, Emitter<NotificationState> emit) async {
    try {
      emit(NotificationActionInProgress('canceling', state));

      await _notificationService.cancelTaskReminder(event.taskId);

      // Update notification status in history
      final notifications = _repository.getAllNotifications();
      for (final notification in notifications) {
        if (notification.relatedTaskId == event.taskId && notification.status == NotificationDeliveryStatus.pending) {
          await _repository.updateNotification(notification.copyWith(status: NotificationDeliveryStatus.cancelled));
        }
      }

      // Reload state
      add(const LoadNotificationHistory());
      add(const GetPendingNotifications());

      AppLogging.logInfo('Cancelled task reminder: ${event.taskId}', name: 'NotificationBloc');
    } catch (e) {
      AppLogging.logError('Failed to cancel task reminder: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to cancel reminder: $e', previousState: state));
    }
  }

  Future<void> _onScheduleMoodCheckIns(ScheduleMoodCheckIns event, Emitter<NotificationState> emit) async {
    try {
      emit(NotificationActionInProgress('scheduling_mood', state));

      await _notificationService.scheduleMoodCheckInNotifications(event.times);

      // Create notification items for each scheduled time
      for (final timeString in event.times) {
        final notificationItem = NotificationItem(
          id: 'mood_${timeString.replaceAll(':', '')}',
          title: 'Mood Check-In',
          body: 'How are you feeling right now?',
          type: NotificationType.moodCheckIn,
          priority: NotificationPriority.medium,
          createdAt: DateTime.now(),
          actionButtons: ['Log Mood', 'Remind Later'],
          groupKey: 'mood_check_ins',
        );
        await _repository.saveNotification(notificationItem);
      }

      add(const LoadNotificationHistory());
      add(const GetPendingNotifications());

      AppLogging.logInfo('Scheduled ${event.times.length} mood check-in notifications', name: 'NotificationBloc');
    } catch (e) {
      AppLogging.logError('Failed to schedule mood check-ins: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to schedule mood notifications: $e', previousState: state));
    }
  }

  Future<void> _onCancelMoodCheckIns(CancelMoodCheckIns event, Emitter<NotificationState> emit) async {
    try {
      await _notificationService.cancelMoodCheckInNotifications();

      // Update status in history
      final moodNotifications = _repository.getNotificationsByType(NotificationType.moodCheckIn);
      for (final notification in moodNotifications) {
        if (notification.status == NotificationDeliveryStatus.pending) {
          await _repository.updateNotification(notification.copyWith(status: NotificationDeliveryStatus.cancelled));
        }
      }

      add(const LoadNotificationHistory());

      AppLogging.logInfo('Cancelled mood check-in notifications', name: 'NotificationBloc');
    } catch (e) {
      AppLogging.logError('Failed to cancel mood check-ins: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to cancel mood notifications: $e', previousState: state));
    }
  }

  Future<void> _onShowImmediate(ShowImmediateNotification event, Emitter<NotificationState> emit) async {
    try {
      await _repository.saveNotification(event.notification);
      // The actual notification showing is handled by enhanced NotificationService
      add(const LoadNotificationHistory());
    } catch (e) {
      AppLogging.logError('Failed to show immediate notification: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to show notification: $e', previousState: state));
    }
  }

  Future<void> _onMarkDelivered(MarkNotificationDelivered event, Emitter<NotificationState> emit) async {
    try {
      final notification = _repository.getNotification(event.notificationId);
      if (notification != null) {
        await _repository.updateNotification(notification.copyWith(status: NotificationDeliveryStatus.delivered, deliveredAt: event.deliveredAt));
        add(const LoadNotificationHistory());
      }
    } catch (e) {
      AppLogging.logError('Failed to mark notification delivered: $e', name: 'NotificationBloc');
    }
  }

  Future<void> _onMarkInteracted(MarkNotificationInteracted event, Emitter<NotificationState> emit) async {
    try {
      final notification = _repository.getNotification(event.notificationId);
      if (notification != null) {
        await _repository.updateNotification(notification.copyWith(action: event.action, interactedAt: event.interactedAt));
        add(const LoadNotificationHistory());
      }
    } catch (e) {
      AppLogging.logError('Failed to mark notification interacted: $e', name: 'NotificationBloc');
    }
  }

  Future<void> _onMarkFailed(MarkNotificationFailed event, Emitter<NotificationState> emit) async {
    try {
      final notification = _repository.getNotification(event.notificationId);
      if (notification != null) {
        await _repository.updateNotification(notification.copyWith(status: NotificationDeliveryStatus.failed, failureReason: event.reason, retryCount: notification.retryCount + 1, lastRetryAt: DateTime.now()));
        add(const LoadNotificationHistory());
      }
    } catch (e) {
      AppLogging.logError('Failed to mark notification failed: $e', name: 'NotificationBloc');
    }
  }

  Future<void> _onRetryFailed(RetryFailedNotification event, Emitter<NotificationState> emit) async {
    try {
      final notification = _repository.getNotification(event.notificationId);
      if (notification != null && notification.needsRetry) {
        // Retry logic would be implemented in enhanced NotificationService
        add(const LoadNotificationHistory());
      }
    } catch (e) {
      AppLogging.logError('Failed to retry notification: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to retry notification: $e', previousState: state));
    }
  }

  Future<void> _onUpdatePreferences(UpdateNotificationPreferences event, Emitter<NotificationState> emit) async {
    try {
      await _repository.savePreferences(event.preferences);

      if (state is NotificationLoaded) {
        emit((state as NotificationLoaded).copyWith(preferences: event.preferences));
      }

      AppLogging.logInfo('Updated notification preferences', name: 'NotificationBloc');
    } catch (e) {
      AppLogging.logError('Failed to update preferences: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to update preferences: $e', previousState: state));
    }
  }

  Future<void> _onUpdateTypePreferences(UpdateTypePreferences event, Emitter<NotificationState> emit) async {
    try {
      await _repository.updateTypePreferences(event.typePreferences);
      add(const LoadNotificationPreferences());

      AppLogging.logInfo('Updated type preferences for: ${event.typePreferences.type}', name: 'NotificationBloc');
    } catch (e) {
      AppLogging.logError('Failed to update type preferences: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to update type preferences: $e', previousState: state));
    }
  }

  Future<void> _onToggleDND(ToggleDoNotDisturb event, Emitter<NotificationState> emit) async {
    try {
      if (state is NotificationLoaded) {
        final currentState = state as NotificationLoaded;

        emit(currentState.copyWith(isDoNotDisturbActive: event.enabled));

        if (event.enabled && event.duration != null) {
          // Schedule automatic DND disable
          _dndTimer?.cancel();
          _dndTimer = Timer(event.duration!, () {
            add(const ToggleDoNotDisturb(false));
          });
        } else {
          _dndTimer?.cancel();
        }

        AppLogging.logInfo('DND ${event.enabled ? "enabled" : "disabled"}', name: 'NotificationBloc');
      }
    } catch (e) {
      AppLogging.logError('Failed to toggle DND: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to toggle DND: $e', previousState: state));
    }
  }

  Future<void> _onUpdateQuietHours(UpdateQuietHours event, Emitter<NotificationState> emit) async {
    try {
      if (state is NotificationLoaded) {
        final currentState = state as NotificationLoaded;
        final updatedPreferences = currentState.preferences.copyWith(quietHours: event.quietHours);

        await _repository.savePreferences(updatedPreferences);
        emit(currentState.copyWith(preferences: updatedPreferences));

        AppLogging.logInfo('Updated quiet hours', name: 'NotificationBloc');
      }
    } catch (e) {
      AppLogging.logError('Failed to update quiet hours: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to update quiet hours: $e', previousState: state));
    }
  }

  Future<void> _onClearHistory(ClearNotificationHistory event, Emitter<NotificationState> emit) async {
    try {
      if (event.daysToKeep != null) {
        await _repository.clearOldHistory(daysToKeep: event.daysToKeep!);
      } else {
        await _repository.clearAllHistory();
      }

      add(const LoadNotificationHistory());

      AppLogging.logInfo('Cleared notification history', name: 'NotificationBloc');
    } catch (e) {
      AppLogging.logError('Failed to clear history: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to clear history: $e', previousState: state));
    }
  }

  Future<void> _onDeleteNotification(DeleteNotification event, Emitter<NotificationState> emit) async {
    try {
      await _repository.deleteNotification(event.notificationId);
      add(const LoadNotificationHistory());
    } catch (e) {
      AppLogging.logError('Failed to delete notification: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to delete notification: $e', previousState: state));
    }
  }

  Future<void> _onRequestPermissions(RequestNotificationPermissions event, Emitter<NotificationState> emit) async {
    try {
      // Permission request logic would be in NotificationService
      final granted = await _notificationService.areNotificationsEnabled();

      if (state is NotificationLoaded) {
        emit((state as NotificationLoaded).copyWith(permissionsGranted: granted));
      }

      if (!granted) {
        emit(const NotificationPermissionDenied('Notification permissions are required'));
      }
    } catch (e) {
      AppLogging.logError('Failed to request permissions: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to request permissions: $e', previousState: state));
    }
  }

  Future<void> _onCheckPermissions(CheckNotificationPermissions event, Emitter<NotificationState> emit) async {
    try {
      final granted = await _notificationService.areNotificationsEnabled();

      if (state is NotificationLoaded) {
        emit((state as NotificationLoaded).copyWith(permissionsGranted: granted));
      }
    } catch (e) {
      AppLogging.logError('Failed to check permissions: $e', name: 'NotificationBloc');
    }
  }

  Future<void> _onGetPending(GetPendingNotifications event, Emitter<NotificationState> emit) async {
    try {
      final pending = await _notificationService.getPendingNotifications();

      if (state is NotificationLoaded) {
        emit((state as NotificationLoaded).copyWith(pendingNotifications: pending));
      }
    } catch (e) {
      AppLogging.logError('Failed to get pending notifications: $e', name: 'NotificationBloc');
    }
  }

  Future<void> _onCancelAll(CancelAllNotifications event, Emitter<NotificationState> emit) async {
    try {
      await _notificationService.cancelAllNotifications();

      // Update all pending notifications in history
      final notifications = _repository.getAllNotifications();
      for (final notification in notifications) {
        if (notification.status == NotificationDeliveryStatus.pending) {
          await _repository.updateNotification(notification.copyWith(status: NotificationDeliveryStatus.cancelled));
        }
      }

      add(const LoadNotificationHistory());
      add(const GetPendingNotifications());

      AppLogging.logInfo('Cancelled all notifications', name: 'NotificationBloc');
    } catch (e) {
      AppLogging.logError('Failed to cancel all notifications: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to cancel all: $e', previousState: state));
    }
  }

  Future<void> _onRescheduleAll(RescheduleAllReminders event, Emitter<NotificationState> emit) async {
    try {
      await _notificationService.rescheduleAllReminders(event.tasks);
      add(const GetPendingNotifications());

      AppLogging.logInfo('Rescheduled ${event.tasks.length} task reminders', name: 'NotificationBloc');
    } catch (e) {
      AppLogging.logError('Failed to reschedule reminders: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to reschedule: $e', previousState: state));
    }
  }

  Future<void> _onLoadAnalytics(LoadNotificationAnalytics event, Emitter<NotificationState> emit) async {
    try {
      final analytics = _repository.getStatistics(days: event.days);

      if (state is NotificationLoaded) {
        emit((state as NotificationLoaded).copyWith(analytics: analytics));
      }

      AppLogging.logInfo('Loaded notification analytics for ${event.days} days', name: 'NotificationBloc');
    } catch (e) {
      AppLogging.logError('Failed to load analytics: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to load analytics: $e', previousState: state));
    }
  }

  Future<void> _onSendTest(SendTestNotification event, Emitter<NotificationState> emit) async {
    try {
      if (event.immediate) {
        await _notificationService.showTestNotificationNow();
      } else {
        await _notificationService.scheduleTestReminder();
      }

      AppLogging.logInfo('Sent test notification of type: ${event.type}', name: 'NotificationBloc');
    } catch (e) {
      AppLogging.logError('Failed to send test notification: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to send test: $e', previousState: state));
    }
  }

  Future<void> _onOpenSettings(OpenNotificationSettings event, Emitter<NotificationState> emit) async {
    try {
      await _notificationService.openNotificationSettings();
    } catch (e) {
      AppLogging.logError('Failed to open settings: $e', name: 'NotificationBloc');
      emit(NotificationError('Failed to open settings: $e', previousState: state));
    }
  }

  Future<void> _onFilterByType(FilterNotificationsByType event, Emitter<NotificationState> emit) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      final filtered = _applyFilters(currentState.allNotifications, currentState, typeFilter: event.type);

      emit(currentState.copyWith(filteredNotifications: filtered, activeFilter: event.type, clearActiveFilter: event.type == null));
    }
  }

  Future<void> _onFilterByStatus(FilterNotificationsByStatus event, Emitter<NotificationState> emit) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      final filtered = _applyFilters(currentState.allNotifications, currentState, statusFilter: event.status);

      emit(currentState.copyWith(filteredNotifications: filtered, statusFilter: event.status, clearStatusFilter: event.status == null));
    }
  }

  Future<void> _onSearchNotifications(SearchNotifications event, Emitter<NotificationState> emit) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      final filtered = _applyFilters(currentState.allNotifications, currentState, searchQuery: event.query);

      emit(currentState.copyWith(filteredNotifications: filtered, searchQuery: event.query, clearSearchQuery: event.query.isEmpty));
    }
  }

  /// Apply filters to notification list
  List<NotificationItem> _applyFilters(List<NotificationItem> notifications, NotificationLoaded currentState, {NotificationType? typeFilter, NotificationDeliveryStatus? statusFilter, String? searchQuery}) {
    var filtered = notifications;

    // Apply type filter
    final activeTypeFilter = typeFilter ?? currentState.activeFilter;
    if (activeTypeFilter != null) {
      filtered = filtered.where((n) => n.type == activeTypeFilter).toList();
    }

    // Apply status filter
    final activeStatusFilter = statusFilter ?? currentState.statusFilter;
    if (activeStatusFilter != null) {
      filtered = filtered.where((n) => n.status == activeStatusFilter).toList();
    }

    // Apply search query
    final activeSearch = searchQuery ?? currentState.searchQuery;
    if (activeSearch != null && activeSearch.isNotEmpty) {
      filtered = filtered.where((n) {
        return n.title.toLowerCase().contains(activeSearch.toLowerCase()) || n.body.toLowerCase().contains(activeSearch.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  /// Get priority for a task based on task priority
  NotificationPriority _getTaskPriority(TaskPriority taskPriority) {
    switch (taskPriority) {
      case TaskPriority.high:
        return NotificationPriority.high;
      case TaskPriority.medium:
        return NotificationPriority.medium;
      case TaskPriority.low:
        return NotificationPriority.low;
    }
  }

  @override
  Future<void> close() {
    _dndTimer?.cancel();
    _refreshTimer?.cancel();
    return super.close();
  }
}
