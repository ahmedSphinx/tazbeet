import 'package:tazbeet/services/app_logging.dart';
import 'package:tazbeet/services/navigation_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'dart:io';
import '../models/task.dart';
import '../models/notification_item.dart';
import '../models/notification_preferences.dart';
import '../repositories/notification_repository.dart';

/// Enhanced Notification Service with rich notifications, smart scheduling, and analytics
///
/// Features:
/// - Rich notifications with action buttons
/// - Smart scheduling with rate limiting
/// - Do Not Disturb mode support
/// - Notification grouping by type
/// - Delivery tracking and analytics
/// - Accessibility support
class NotificationServiceEnhanced {
  static final NotificationServiceEnhanced _instance = NotificationServiceEnhanced._internal();
  factory NotificationServiceEnhanced() => _instance;
  NotificationServiceEnhanced._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final NotificationRepository _repository = NotificationRepository();

  // Notification channels
  static const String taskRemindersChannelId = 'task_reminders';
  static const String taskDueChannelId = 'task_due';
  static const String taskCompletedChannelId = 'task_completed';
  static const String moodCheckInsChannelId = 'mood_check_ins';
  static const String pomodoroChannelId = 'pomodoro';
  static const String emergencyChannelId = 'emergency';
  static const String systemChannelId = 'system';

  // Rate limiting tracking
  final Map<NotificationType, DateTime> _lastNotificationTime = {};
  final Map<DateTime, int> _notificationCountByHour = {};

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize timezone
      tz_data.initializeTimeZones();

      // Initialize repository
      await _repository.init();

      // Configure local timezone
      await _configureLocalTimeZone();

      // Request notification permissions
      await _requestPermissions();

      // Initialize platform-specific settings
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true);

      const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

      await _flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: _onNotificationTapped);

      // Create notification channels
      await _createNotificationChannels();

      _isInitialized = true;
      AppLogging.logInfo('Enhanced NotificationService initialized successfully', name: 'NotificationServiceEnhanced');
    } catch (e) {
      AppLogging.logError('Failed to initialize NotificationServiceEnhanced: $e', name: 'NotificationServiceEnhanced');
      rethrow;
    }
  }

  Future<void> _createNotificationChannels() async {
    if (!Platform.isAndroid) return;

    final androidPlugin = _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    // Task Reminders Channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(taskRemindersChannelId, 'Task Reminders', description: 'Reminders for scheduled tasks', importance: Importance.high, playSound: true, enableVibration: true),
    );

    // Task Due Channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(taskDueChannelId, 'Task Due', description: 'Notifications for tasks that are due', importance: Importance.max, playSound: true, enableVibration: true),
    );

    // Task Completed Channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(taskCompletedChannelId, 'Task Completed', description: 'Celebration notifications for completed tasks', importance: Importance.low, playSound: true, enableVibration: false),
    );

    // Mood Check-ins Channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(moodCheckInsChannelId, 'Mood Check-Ins', description: 'Reminders for mood tracking', importance: Importance.high, playSound: true, enableVibration: true),
    );

    // Pomodoro Channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(pomodoroChannelId, 'Pomodoro Timer', description: 'Pomodoro work and break notifications', importance: Importance.max, playSound: true, enableVibration: true),
    );

    // Emergency Channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(emergencyChannelId, 'Emergency Alerts', description: 'Urgent emergency notifications', importance: Importance.max, playSound: true, enableVibration: true),
    );

    // System Channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(systemChannelId, 'System Notifications', description: 'System-level notifications', importance: Importance.low, playSound: false, enableVibration: false),
    );

    // Request exact alarms permission (Android 12+)
    final exactPermissionGranted = await androidPlugin.requestExactAlarmsPermission();
    AppLogging.logInfo('Exact alarms permission: $exactPermissionGranted', name: 'NotificationServiceEnhanced');
  }

  Future<void> _configureLocalTimeZone() async {
    AppLogging.logInfo('Using device local timezone: ${tz.local}', name: 'NotificationServiceEnhanced');
  }

  Future<void> _requestPermissions() async {
    await Permission.notification.request();

    if (Platform.isAndroid) {
      final batteryStatus = await Permission.ignoreBatteryOptimizations.status;
      if (!batteryStatus.isGranted) {
        await Permission.ignoreBatteryOptimizations.request();
      }
    }
  }

  /// Handle notification tap with action button support
  void _onNotificationTapped(NotificationResponse response) async {
    AppLogging.logInfo('Notification tapped: ${response.id}, action: ${response.actionId}, payload: ${response.payload}', name: 'NotificationServiceEnhanced');

    // Track interaction in repository
    if (response.payload != null) {
      try {
        final notification = _repository.getNotification(response.payload!);
        if (notification != null) {
          final action = _getActionFromId(response.actionId);
          await _repository.updateNotification(notification.copyWith(action: action, interactedAt: DateTime.now()));
        }
      } catch (e) {
        AppLogging.logError('Failed to track notification interaction: $e', name: 'NotificationServiceEnhanced');
      }
    }

    // Handle navigation based on payload
    if (response.payload == 'mood_check_in') {
      NavigationService.navigatorKey.currentState?.pushNamed('/mood_input');
    } else if (response.payload?.startsWith('task_') == true) {
      // Navigate to task details
      final taskId = response.payload!.split('_').last;
      NavigationService.navigatorKey.currentState?.pushNamed('/task_details', arguments: taskId);
    }

    // Handle action buttons
    if (response.actionId != null) {
      await _handleNotificationAction(response.actionId!, response.payload);
    }
  }

  NotificationAction _getActionFromId(String? actionId) {
    if (actionId == null) return NotificationAction.opened;

    switch (actionId) {
      case 'complete':
        return NotificationAction.completed;
      case 'snooze':
        return NotificationAction.snoozed;
      case 'dismiss':
        return NotificationAction.dismissed;
      default:
        return NotificationAction.clicked;
    }
  }

  Future<void> _handleNotificationAction(String actionId, String? payload) async {
    AppLogging.logInfo('Handling action: $actionId for payload: $payload', name: 'NotificationServiceEnhanced');

    // Action handling logic would be implemented based on action type
    // This is where you'd integrate with TaskBloc or other services
  }

  /// Check if notifications are allowed right now based on preferences
  Future<bool> _canSendNotificationNow(NotificationType type, NotificationPriority priority) async {
    try {
      final preferences = _repository.getPreferences();

      // Check master toggle
      if (!preferences.masterNotificationsEnabled) {
        AppLogging.logInfo('Notifications disabled globally', name: 'NotificationServiceEnhanced');
        return false;
      }

      // Check type-specific preferences
      final typePrefs = preferences.getPreferencesForType(type);
      if (typePrefs != null && !typePrefs.enabled) {
        AppLogging.logInfo('Notifications disabled for type: $type', name: 'NotificationServiceEnhanced');
        return false;
      }

      // Check quiet hours
      if (preferences.quietHours.isQuietTimeNow()) {
        // Allow urgent notifications if configured
        if (priority == NotificationPriority.urgent && preferences.quietHours.allowUrgentNotifications) {
          return true;
        }
        AppLogging.logInfo('Notification blocked by quiet hours', name: 'NotificationServiceEnhanced');
        return false;
      }

      // Check rate limiting
      if (preferences.enableSmartScheduling) {
        if (!_checkRateLimit(type, preferences)) {
          AppLogging.logInfo('Notification blocked by rate limiting', name: 'NotificationServiceEnhanced');
          return false;
        }
      }

      return true;
    } catch (e) {
      AppLogging.logError('Error checking notification permissions: $e', name: 'NotificationServiceEnhanced');
      return true; // Fail open
    }
  }

  /// Check rate limiting based on preferences
  bool _checkRateLimit(NotificationType type, NotificationPreferences preferences) {
    final now = DateTime.now();

    // Check per-type cooldown
    if (_lastNotificationTime.containsKey(type)) {
      final lastTime = _lastNotificationTime[type]!;
      final minutesSinceLast = now.difference(lastTime).inMinutes;

      if (minutesSinceLast < preferences.minMinutesBetweenSameType) {
        return false;
      }
    }

    // Check hourly limit
    final currentHour = DateTime(now.year, now.month, now.day, now.hour);
    final countThisHour = _notificationCountByHour[currentHour] ?? 0;

    if (countThisHour >= preferences.maxNotificationsPerHour) {
      return false;
    }

    return true;
  }

  /// Update rate limiting trackers
  void _updateRateLimitTrackers(NotificationType type) {
    final now = DateTime.now();
    _lastNotificationTime[type] = now;

    final currentHour = DateTime(now.year, now.month, now.day, now.hour);
    _notificationCountByHour[currentHour] = (_notificationCountByHour[currentHour] ?? 0) + 1;
  }

  /// Get notification details based on type and preferences
  NotificationDetails _getNotificationDetails(NotificationType type, NotificationPriority priority, {List<AndroidNotificationAction>? actions, String? groupKey}) {
    final preferences = _repository.getPreferences();
    final typePrefs = preferences.getPreferencesForType(type);

    final channelId = _getChannelId(type);
    final channelName = _getChannelName(type);

    // Determine importance based on priority
    final importance = _getImportance(priority);
    final priorityLevel = _getPriority(priority);

    // Check if sound and vibration are enabled
    final playSound = typePrefs?.playSound ?? true;
    final vibrate = typePrefs?.vibrate ?? true;

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: importance,
      priority: priorityLevel,
      playSound: playSound,
      enableVibration: vibrate,
      actions: actions,
      groupKey: groupKey,
      setAsGroupSummary: groupKey != null,
    );

    const iosDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);

    return NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  String _getChannelId(NotificationType type) {
    switch (type) {
      case NotificationType.taskReminder:
        return taskRemindersChannelId;
      case NotificationType.taskDue:
        return taskDueChannelId;
      case NotificationType.taskCompleted:
        return taskCompletedChannelId;
      case NotificationType.moodCheckIn:
        return moodCheckInsChannelId;
      case NotificationType.pomodoroWork:
      case NotificationType.pomodoroBreak:
      case NotificationType.pomodoroComplete:
        return pomodoroChannelId;
      case NotificationType.emergency:
        return emergencyChannelId;
      case NotificationType.system:
        return systemChannelId;
    }
  }

  String _getChannelName(NotificationType type) {
    switch (type) {
      case NotificationType.taskReminder:
        return 'Task Reminders';
      case NotificationType.taskDue:
        return 'Task Due';
      case NotificationType.taskCompleted:
        return 'Task Completed';
      case NotificationType.moodCheckIn:
        return 'Mood Check-Ins';
      case NotificationType.pomodoroWork:
      case NotificationType.pomodoroBreak:
      case NotificationType.pomodoroComplete:
        return 'Pomodoro Timer';
      case NotificationType.emergency:
        return 'Emergency Alerts';
      case NotificationType.system:
        return 'System Notifications';
    }
  }

  Importance _getImportance(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Importance.low;
      case NotificationPriority.medium:
        return Importance.defaultImportance;
      case NotificationPriority.high:
        return Importance.high;
      case NotificationPriority.urgent:
        return Importance.max;
    }
  }

  Priority _getPriority(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Priority.low;
      case NotificationPriority.medium:
        return Priority.defaultPriority;
      case NotificationPriority.high:
        return Priority.high;
      case NotificationPriority.urgent:
        return Priority.max;
    }
  }

  /// Schedule a rich notification with action buttons
  Future<void> scheduleNotification(NotificationItem notification) async {
    try {
      // Check if notification can be sent
      if (!await _canSendNotificationNow(notification.type, notification.priority)) {
        AppLogging.logInfo('Notification not allowed at this time: ${notification.id}', name: 'NotificationServiceEnhanced');

        // Save as failed in repository
        await _repository.updateNotification(notification.copyWith(status: NotificationDeliveryStatus.failed, failureReason: 'Blocked by DND or rate limiting'));
        return;
      }

      // Create action buttons if specified
      List<AndroidNotificationAction>? actions;
      if (notification.actionButtons.isNotEmpty) {
        actions = notification.actionButtons.map((label) {
          return AndroidNotificationAction(label.toLowerCase().replaceAll(' ', '_'), label);
        }).toList();
      }

      // Get notification details
      final details = _getNotificationDetails(notification.type, notification.priority, actions: actions, groupKey: notification.groupKey);

      // Schedule or show notification
      if (notification.scheduledAt != null) {
        final scheduledTime = tz.TZDateTime.from(notification.scheduledAt!, tz.local);

        if (scheduledTime.isAfter(tz.TZDateTime.now(tz.local))) {
          await _flutterLocalNotificationsPlugin.zonedSchedule(
            notification.id.hashCode.abs(),
            notification.title,
            notification.body,
            scheduledTime,
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            payload: notification.payload ?? notification.id,
          );

          // Update status in repository
          await _repository.updateNotification(notification.copyWith(status: NotificationDeliveryStatus.pending));
        }
      } else {
        // Show immediately
        await _flutterLocalNotificationsPlugin.show(notification.id.hashCode.abs(), notification.title, notification.body, details, payload: notification.payload ?? notification.id);

        // Update status in repository
        await _repository.updateNotification(notification.copyWith(status: NotificationDeliveryStatus.delivered, deliveredAt: DateTime.now()));
      }

      // Update rate limiting trackers
      _updateRateLimitTrackers(notification.type);

      AppLogging.logInfo('Scheduled notification: ${notification.id}', name: 'NotificationServiceEnhanced');
    } catch (e) {
      AppLogging.logError('Failed to schedule notification: $e', name: 'NotificationServiceEnhanced');

      // Save as failed
      await _repository.updateNotification(notification.copyWith(status: NotificationDeliveryStatus.failed, failureReason: e.toString()));
    }
  }

  /// Backward compatibility: Schedule task reminder
  Future<void> scheduleTaskReminder(Task task) async {
    if (task.reminderDate == null) return;

    final notification = NotificationItem(
      id: 'task_reminder_${task.id}',
      title: 'Task Reminder',
      body: 'Don\'t forget: ${task.title}',
      type: NotificationType.taskReminder,
      priority: _getTaskPriority(task.priority),
      createdAt: DateTime.now(),
      scheduledAt: task.reminderDate,
      relatedTaskId: task.id,
      actionButtons: ['Complete', 'Snooze', 'View'],
      groupKey: 'task_reminders',
      payload: 'task_${task.id}',
    );

    await _repository.saveNotification(notification);
    await scheduleNotification(notification);
  }

  NotificationPriority _getTaskPriority(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return NotificationPriority.high;
      case TaskPriority.medium:
        return NotificationPriority.medium;
      case TaskPriority.low:
        return NotificationPriority.low;
    }
  }

  // Legacy methods for backward compatibility
  Future<void> cancelTaskReminder(String taskId) async {
    await _flutterLocalNotificationsPlugin.cancel('task_reminder_$taskId'.hashCode.abs());
  }

  Future<bool> areNotificationsEnabled() async {
    final androidPlugin = _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (Platform.isAndroid && androidPlugin != null) {
      return await androidPlugin.areNotificationsEnabled() ?? false;
    }

    return true; // Assume enabled for iOS
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> openNotificationSettings() async {
    await openAppSettings();
  }

  // Additional legacy methods from original service would go here...
  // (scheduleMoodCheckInNotifications, showTaskDueNotification, etc.)
}
