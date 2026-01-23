import 'dart:convert';
import 'package:tazbeet/services/app_logging_service.dart';
import 'package:tazbeet/services/navigation_service.dart';
import 'package:tazbeet/services/settings_service.dart';
import 'package:tazbeet/services/error_notification_service.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/notification/notification_bloc.dart';
import '../blocs/notification/notification_event.dart';

import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'dart:io';
import '../models/task.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const String moodNotificationChannelId = 'mood_check_ins';
  static const String moodNotificationChannelName = 'Mood Check-Ins';

  /// Flag to suppress error messages during bulk operations
  bool _suppressErrors = false;

  Future<void> initialize() async {
    // Initialize timezone
    tz_data.initializeTimeZones();

    // Configure local timezone
    await _configureLocalTimeZone();

    // Request notification permissions
    await _requestPermissions();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true);

    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        AppLogging.logInfo('Notification received/tapped: ${response.payload}', name: 'NotificationService');

        if (response.payload == 'mood_check_in') {
          NavigationService.navigatorKey.currentState?.pushNamed('/mood_input');
          return;
        }

        // Handle task reminder actions
        try {
          final payload = jsonDecode(response.payload!);
          if (payload['type'] == 'task_reminder') {
            final taskId = payload['taskId'];
            final action = response.actionId;

            if (action == 'complete') {
              // Navigate to task details for completion
              NavigationService.navigatorKey.currentState?.pushNamed('/task_details', arguments: taskId);
            } else if (action == 'snooze') {
              // Dispatch snooze event to NotificationBloc
              final context = NavigationService.navigatorKey.currentContext;
              if (context != null) {
                context.read<NotificationBloc>().add(SnoozeTaskReminder(taskId, const Duration(minutes: 15)));
              }
            } else {
              // Default: navigate to task details
              NavigationService.navigatorKey.currentState?.pushNamed('/task_details', arguments: taskId);
            }
          }
        } catch (e) {
          AppLogging.logError('Failed to handle notification response: $e', name: 'NotificationService');
        }
      },
    );

    // Create notification channels
    const AndroidNotificationChannel taskChannel = AndroidNotificationChannel('task_reminders', 'Task Reminders', description: 'Reminders for tasks', importance: Importance.max, playSound: true);

    final androidPlugin = _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(taskChannel);

    // Create notification channel for mood check-ins

    const AndroidNotificationChannel moodChannel = AndroidNotificationChannel(moodNotificationChannelId, moodNotificationChannelName, description: 'Mood check-in reminders', importance: Importance.max, playSound: true);

    await androidPlugin?.createNotificationChannel(moodChannel);

    final bool? exactPermissionGranted = await androidPlugin?.requestExactAlarmsPermission();
    AppLogging.logInfo('Exact alarms permission granted: $exactPermissionGranted', name: 'NotificationService');
  }

  Future<void> _configureLocalTimeZone() async {
    // Use device's local timezone for scheduling
    // tz.local is already set to the device's timezone by default
    AppLogging.logInfo('Using device local timezone for notifications: ${tz.local}', name: 'NotificationService');
  }

  Future<void> _requestPermissions({BuildContext? buildContext}) async {
    await Permission.notification.request();
    if (await Permission.notification.isGranted) {
      AppLogging.logInfo('Notification permission granted', name: 'NotificationService');
    } else {
      AppLogging.logWarning('Notification permission not granted', name: 'NotificationService');
      final context = buildContext ?? NavigationService.navigatorKey.currentContext;
      if (context == null) {
        AppLogging.logError('No context available for localization', name: 'NotificationService');
        return;
      }
      final l10n = AppLocalizations.of(context)!;
      ErrorNotificationService().showError(context, l10n.notificationPermissionDenied, isWarning: true);
    }

    // Request to ignore battery optimizations for reliable notifications
    if (Platform.isAndroid) {
      final batteryStatus = await Permission.ignoreBatteryOptimizations.status;
      AppLogging.logInfo('Battery optimization status: $batteryStatus', name: 'NotificationService');
      if (!batteryStatus.isGranted) {
        final requested = await Permission.ignoreBatteryOptimizations.request();
        AppLogging.logInfo('Battery optimization permission requested: $requested', name: 'NotificationService');
      }
    }
  }

  /// Check if notification permission is granted
  Future<bool> hasNotificationPermission() async {
    return await Permission.notification.isGranted;
  }

  /// Request notification permission
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Generate unique notification ID for task
  int _generateTaskNotificationId(String taskId, {String suffix = ''}) {
    final hash = taskId.hashCode.abs();
    // Use modulo to ensure ID fits within 32-bit signed integer range
    // Max positive 32-bit int is 2147483647
    final baseId = (hash % 1000000) + 1000000; // Keep ID in reasonable range
    return int.parse('$baseId$suffix');
  }

  /// Verify that a reminder was scheduled successfully
  Future<void> _verifyReminderScheduled(String taskId, String taskTitle) async {
    try {
      // Wait a moment for the notification to be registered
      await Future.delayed(const Duration(milliseconds: 100));

      final pendingNotifications = await getPendingNotifications();
      final notificationId = _generateTaskNotificationId(taskId);
      final isScheduled = pendingNotifications.any((notification) => notification.id == notificationId);

      if (isScheduled) {
        AppLogging.logInfo('✅ Reminder verified as scheduled: $taskTitle (ID: $notificationId)', name: 'NotificationService');
      } else {
        AppLogging.logWarning('⚠️ Reminder may not be scheduled: $taskTitle (ID: $notificationId)', name: 'NotificationService');
      }
    } catch (e) {
      AppLogging.logError('Failed to verify reminder scheduling for $taskTitle: $e', name: 'NotificationService');
    }
  }

  Future<void> scheduleTaskReminder(Task task) async {
    if (task.reminderDate == null) return;

    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime.from(task.reminderDate!, tz.local);

    if (scheduledTime.isBefore(now)) {
      AppLogging.logWarning('Cannot schedule reminder for past date: ${task.reminderDate}', name: 'NotificationService-${task.title}');
      // Only show error if not in bulk operation mode
      if (!_suppressErrors) {
        final context = NavigationService.navigatorKey.currentContext;
        if (context == null) {
          AppLogging.logError('No context available for localization', name: 'NotificationService');
          return;
        }
        final l10n = AppLocalizations.of(context)!;
        ErrorNotificationService().showError(context, '${l10n.cannotSetReminderForPastDate}: ${task.title}', isWarning: true);
      }
      return;
    }

    final context = NavigationService.navigatorKey.currentContext; // Move context fetch up
    if (context == null) {
      AppLogging.logError('No context available for localization', name: 'NotificationService');
      return;
    }
    final l10n = AppLocalizations.of(context)!;

    AppLogging.logInfo('Scheduling task reminder for task: ${task.id} - ${task.title} at ${task.reminderDate}', name: 'NotificationService');

    // Check for duplicate notifications before scheduling
    final isDuplicate = await _isDuplicateNotification(task.id);
    if (isDuplicate) {
      AppLogging.logInfo('Found existing reminder for task ${task.id}, updating instead of creating duplicate', name: 'NotificationService');

      // Cancel existing reminder before scheduling new one
      await cancelTaskReminder(task.id);

      // Continue with scheduling the new reminder
    }

    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'task_reminders',
      l10n.taskRemindersChannelName, // Use localized name
      channelDescription: l10n.taskRemindersChannelDesc,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      _generateTaskNotificationId(task.id),
      l10n.taskReminder,
      '${l10n.dontForget}: ${task.title}',
      scheduledTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: jsonEncode({
        'type': 'task_reminder',
        'taskId': task.id,
        'actions': ['complete', 'snooze', 'view'],
        'snoozeOptions': [5, 15, 60],
      }),
    );

    // Verify the reminder was scheduled successfully
    await _verifyReminderScheduled(task.id, task.title);
  }
  /* 
  Future<void> scheduleMoodCheckInNotifications(List<String> times) async {
    try {
      AppLogging.logInfo('Starting to schedule mood check-in notifications for ${times.length} times: $times', name: 'NotificationService');

      // Check if notifications are enabled
      final notificationsEnabled = await areNotificationsEnabled();
      AppLogging.logInfo('Notifications enabled: $notificationsEnabled', name: 'NotificationService');
      if (!notificationsEnabled) {
        AppLogging.logWarning('Notifications not enabled, cannot schedule mood check-ins', name: 'NotificationService');
        return;
      }

      final now = tz.TZDateTime.now(tz.local);

      // Cancel existing mood notifications before scheduling new ones
      await cancelMoodCheckInNotifications();

      int notificationIdBase = 100000; // Base ID for mood notifications to avoid conflicts

      for (int i = 0; i < times.length; i++) {
        final timeString = times[i];
        AppLogging.logInfo('Processing time $i: $timeString', name: 'NotificationService');
        final timeParts = timeString.split(':');
        if (timeParts.length != 2) {
          AppLogging.logWarning('Invalid time format: $timeString, skipping', name: 'NotificationService');
          continue;
        }

        final int hour = int.tryParse(timeParts[0]) ?? 0;
        final int minute = int.tryParse(timeParts[1]) ?? 0;

        if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
          AppLogging.logWarning('Invalid time values: $hour:$minute, skipping', name: 'NotificationService');
          continue;
        }

        AppLogging.logInfo('Parsed time $i: $hour:$minute', name: 'NotificationService');

        tz.TZDateTime firstScheduledTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

        // If scheduled time is before now, schedule for next day
        if (firstScheduledTime.isBefore(now)) {
          firstScheduledTime = firstScheduledTime.add(const Duration(days: 1));
        }

        AppLogging.logInfo('First scheduled time for $timeString: $firstScheduledTime', name: 'NotificationService');

        for (int day = 0; day < 7; day++) {
          tz.TZDateTime scheduledTime = firstScheduledTime.add(Duration(days: day));
          int notificationId = notificationIdBase + i * 7 + day;

          AppLogging.logInfo('Scheduling mood check-in notification ID $notificationId at $scheduledTime (time $i, day $day)', name: 'NotificationService');

          const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
            moodNotificationChannelId,
            moodNotificationChannelName,
            channelDescription: 'Notifications for mood check-ins',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
          );

          const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);

          const NotificationDetails platformDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

          try {
            await _flutterLocalNotificationsPlugin.zonedSchedule(
              notificationId,
              'Mood Check-In',
              'How are you feeling right now? Tap to record your mood.',
              scheduledTime,
              platformDetails,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              payload: 'mood_check_in',
            );
            AppLogging.logInfo('Successfully scheduled mood check-in notification ID $notificationId', name: 'NotificationService');
          } catch (e) {
            AppLogging.logError('Failed to schedule mood check-in notification ID $notificationId: $e', name: 'NotificationService');
          }
        }
      }
      AppLogging.logInfo('Completed scheduling mood check-in reminders for ${times.length} times (${times.length * 7} total notifications)', name: 'NotificationService');
    } catch (e) {
      AppLogging.logError('Error in scheduleMoodCheckInNotifications: $e', name: 'NotificationService');
    }
  }

 */

  Future<void> scheduleMoodCheckInNotifications(List<String> times, {AppLocalizations? l10n}) async {
    final context = NavigationService.navigatorKey.currentContext;
    if (context == null) {
      AppLogging.logError('No context available for localization', name: 'NotificationService');
      return;
    }
    final localizations = l10n ?? AppLocalizations.of(context)!;
    try {
      AppLogging.logInfo('Preparing to schedule mood check-in notifications for ${times.length} times...', name: 'NotificationService');

      // Check notification permissions
      final notificationsEnabled = await areNotificationsEnabled();
      if (!notificationsEnabled) {
        AppLogging.logWarning('Notifications are disabled. Aborting mood check-in scheduling.', name: 'NotificationService');
        return;
      }

      // Cancel existing mood check-in notifications
      await cancelMoodCheckInNotifications();

      final now = tz.TZDateTime.now(tz.local);
      final offset = DateTime.now().timeZoneOffset;
      int notificationIdBase = 100000;

      for (int i = 0; i < times.length; i++) {
        final timeString = times[i];

        // Validate time format
        final timeParts = timeString.split(':');
        if (timeParts.length != 2) {
          AppLogging.logWarning('Invalid time format: $timeString. Expected HH:MM. Skipping.', name: 'NotificationService');
          continue;
        }

        final int hour = int.tryParse(timeParts[0]) ?? -1;
        final int minute = int.tryParse(timeParts[1]) ?? -1;

        if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
          AppLogging.logWarning('Invalid time values: $hour:$minute. Must be 00:00-23:59. Skipping.', name: 'NotificationService');
          continue;
        }

        // Calculate local scheduled time (today or tomorrow)
        DateTime localScheduled = DateTime(now.year, now.month, now.day, hour, minute);
        if (localScheduled.isBefore(DateTime.now())) {
          localScheduled = localScheduled.add(const Duration(days: 1));
        }

        // Convert to UTC for scheduling
        DateTime utcScheduled = localScheduled.subtract(offset);
        tz.TZDateTime scheduledTime = tz.TZDateTime.from(utcScheduled, tz.local);

        final int notificationId = notificationIdBase + i;

        AppLogging.logInfo('Scheduling mood check-in notification ID $notificationId at $scheduledTime (repeats daily)', name: 'NotificationService');

        final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
          moodNotificationChannelId,
          localizations.moodCheckInsChannelName,
          channelDescription: localizations.moodCheckInsChannelDesc,
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          enableVibration: true,
        );

        const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);

        final NotificationDetails platformDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

        // Get time-based message
        final messages = _getTimeBasedMoodMessages(hour, localizations);
        final messageIndex = i % messages.length; // Rotate messages
        final message = messages[messageIndex];

        try {
          await _flutterLocalNotificationsPlugin.zonedSchedule(
            notificationId,
            message['title']!,
            message['body']!,
            scheduledTime,
            platformDetails,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.time, // Repeat daily at the same time
            payload: 'mood_check_in',
          );

          //   AppLogging.logInfo('✅ Successfully scheduled mood check-in notification ID $notificationId', name: 'NotificationService');
        } catch (e) {
          AppLogging.logError('❌ Failed to schedule mood notification ID $notificationId: $e', name: 'NotificationService');
        }
      }

      AppLogging.logInfo('🎉 Finished scheduling ${times.length}[${times.join(', ')}] mood check-in notifications.', name: 'NotificationService');
    } catch (e) {
      AppLogging.logError('Unhandled error in scheduleMoodCheckInNotifications: $e', name: 'NotificationService');
    }
  }

  Future<void> cancelMoodCheckInNotifications() async {
    int notificationIdBase = 100000;
    // Cancel up to 100 mood notifications to handle legacy scheduling
    for (int i = 0; i < 100; i++) {
      await _flutterLocalNotificationsPlugin.cancel(notificationIdBase + i);
    }
    AppLogging.logInfo('Cancelled all mood check-in notifications', name: 'NotificationService');
  }

  Future<void> cancelTaskReminder(String taskId) async {
    // Cancel with multiple possible ID patterns to ensure cleanup
    await _flutterLocalNotificationsPlugin.cancel(taskId.hashCode);
    await _flutterLocalNotificationsPlugin.cancel(_generateTaskNotificationId(taskId));
    // Also cancel task due and completion notifications
    await _flutterLocalNotificationsPlugin.cancel(taskId.hashCode + 1000);
    await _flutterLocalNotificationsPlugin.cancel(taskId.hashCode + 2000);
  }

  Future<void> showTaskDueNotification(Task task) async {
    AppLogging.logInfo('Showing task due notification for task: ${task.id} - ${task.title}', name: 'NotificationService');

    final context = NavigationService.navigatorKey.currentContext;
    if (context == null) {
      AppLogging.logError('No context available for localization', name: 'NotificationService');
      return;
    }
    final l10n = AppLocalizations.of(context)!;

    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'task_due',
      l10n.taskDueChannelName,
      channelDescription: l10n.taskDueChannelDesc,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      task.id.hashCode + 1000, // Different ID for due notifications
      l10n.taskDueToday,
      '${task.title} ${l10n.isDueToday}!',
      platformChannelSpecifics,
      payload: task.id,
    );
  }

  Future<void> showTaskCompletedNotification(Task task) async {
    AppLogging.logInfo('Showing task completed notification for task: ${task.id} - ${task.title}', name: 'NotificationService');

    final context = NavigationService.navigatorKey.currentContext;
    if (context == null) {
      AppLogging.logError('No context available for localization', name: 'NotificationService');
      return;
    }
    final l10n = AppLocalizations.of(context)!;

    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'task_completed',
      l10n.taskCompletedChannelName,
      channelDescription: l10n.taskCompletedChannelDesc,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      task.id.hashCode + 2000, // Different ID for completion notifications
      l10n.taskCompletedSuccessfully,
      '${l10n.greatJobCompleting} ${task.title}',
      platformChannelSpecifics,
      payload: task.id,
    );
  }

  Future<void> scheduleTestReminder() async {
    try {
      // Generate unique ID to avoid conflicts
      final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Calculate test time in local timezone
      final offset = DateTime.now().timeZoneOffset;
      // final now = tz.TZDateTime.now(tz.local);
      var localTestTime = DateTime.now().add(const Duration(seconds: 10));
      var testTime = tz.TZDateTime.from(localTestTime.subtract(offset), tz.local);

      // Ensure test time is in the future
      if (testTime.isBefore(tz.TZDateTime.now(tz.local))) {
        AppLogging.logWarning('Test reminder time is in the past, adjusting to 10 seconds from now', name: 'NotificationService');
        testTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
      }

      // Check if notifications are enabled
      final androidPlugin = _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final iosPlugin = _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

      bool canSchedule = true;
      if (Platform.isAndroid) {
        final granted = await androidPlugin?.requestExactAlarmsPermission() ?? false;
        if (!granted) {
          AppLogging.logWarning('Exact alarms permission not granted, cannot schedule test reminder', name: 'NotificationService');
          canSchedule = false;
        }
      }

      if (Platform.isIOS) {
        final granted = await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true) ?? false;
        if (!granted) {
          AppLogging.logWarning('iOS notification permissions not granted, cannot schedule test reminder', name: 'NotificationService');
          canSchedule = false;
        }
      }

      if (!canSchedule) {
        throw Exception('Notification permissions not granted');
      }

      final context = NavigationService.navigatorKey.currentContext;
      if (context == null) {
        AppLogging.logError('No context available for localization', name: 'NotificationService');
        return;
      }
      final l10n = AppLocalizations.of(context)!;
      // Schedule the notification
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        l10n.testReminder,
        l10n.testNotificationDescription,
        testTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'task_reminders',
            l10n.taskRemindersChannelName,
            channelDescription: l10n.taskRemindersChannelDesc,
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          ),
          iOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      AppLogging.logInfo('Successfully scheduled test reminder ID $notificationId for $testTime', name: 'NotificationService');
    } catch (e) {
      AppLogging.logError('Failed to schedule test reminder: $e', name: 'NotificationService');
      rethrow;
    }
  }

  Future<void> showTestNotificationNow() async {
    try {
      const notificationId = 1000; // Fixed ID for immediate test

      final context = NavigationService.navigatorKey.currentContext;
      if (context == null) {
        AppLogging.logError('No context available for localization', name: 'NotificationService');
        return;
      }
      final l10n = AppLocalizations.of(context)!;
      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        l10n.immediateTestNotification,
        l10n.immediateTestNotificationDescription,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'task_reminders',
            l10n.taskRemindersChannelName,
            channelDescription: l10n.taskRemindersChannelDesc,
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          ),
          iOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
        ),
      );

      AppLogging.logInfo('Showed immediate test notification', name: 'NotificationService');
    } catch (e) {
      AppLogging.logError('Failed to show immediate test notification: $e', name: 'NotificationService');
      rethrow;
    }
  }

  Future<void> showImmediateNotification(String title, String body, {String? payload}) async {
    try {
      const notificationId = 9999; // Fixed ID for admin notifications

      final context = NavigationService.navigatorKey.currentContext;
      if (context == null) {
        AppLogging.logError('No context available for localization', name: 'NotificationService');
        return;
      }
      final l10n = AppLocalizations.of(context)!;

      final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'admin_notifications',
        l10n.adminNotificationsChannelName,
        channelDescription: l10n.adminNotificationsChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        styleInformation: const BigTextStyleInformation('', htmlFormatBigText: true, contentTitle: '', htmlFormatContentTitle: true, summaryText: '', htmlFormatSummaryText: true),
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true, sound: 'default');

      final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

      await _flutterLocalNotificationsPlugin.show(notificationId, title, body, platformChannelSpecifics, payload: payload);

      AppLogging.logInfo('Showed immediate notification: $title', name: 'NotificationService');
    } catch (e) {
      AppLogging.logError('Failed to show immediate notification: $e', name: 'NotificationService');
      rethrow;
    }
  }

  Future<void> showTestMoodNotificationNow({AppLocalizations? l10n}) async {
    try {
      const notificationId = 2000; // Fixed ID for mood test

      // Ensure l10n is available (it's optional param but we might need to fetch it if null, though current caller logic suggests we usually pass it or can fetch it)
      // Actually showTestMoodNotificationNow takes optional l10n. Use fallback or fetch.
      final localizations = l10n ?? AppLocalizations.of(NavigationService.navigatorKey.currentContext!)!; // Force fetch if null

      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        localizations.testMoodNotificationTitle, // Use key
        localizations.testMoodNotificationBody, // Use key
        NotificationDetails(
          android: AndroidNotificationDetails(
            moodNotificationChannelId,
            localizations.moodCheckInsChannelName,
            channelDescription: localizations.moodCheckInsChannelDesc,
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            enableVibration: true,
          ),
          iOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
        ),
        payload: 'mood_check_in',
      );

      AppLogging.logInfo('Showed immediate test mood notification', name: 'NotificationService');
    } catch (e) {
      AppLogging.logError('Failed to show immediate test mood notification: $e', name: 'NotificationService');
      rethrow;
    }
  }

  Future<void> scheduleTestMoodNotification({AppLocalizations? l10n}) async {
    try {
      const notificationId = 2000; // Fixed ID for scheduled mood test

      final testTime = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1));

      final localizations = l10n ?? AppLocalizations.of(NavigationService.navigatorKey.currentContext!)!;

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        localizations.testMoodNotificationTitle,
        localizations.scheduledTestMoodNotificationBody,
        testTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            moodNotificationChannelId,
            localizations.moodCheckInsChannelName,
            channelDescription: localizations.moodCheckInsChannelDesc,
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            enableVibration: true,
          ),
          iOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'mood_check_in',
      );

      AppLogging.logInfo('Scheduled test mood notification for $testTime', name: 'NotificationService');
    } catch (e) {
      AppLogging.logError('Failed to schedule test mood notification: $e', name: 'NotificationService');
      rethrow;
    }
  }

  Future<void> rescheduleAllReminders(List<Task> tasks) async {
    // Suppress error messages during bulk operation but log them
    _suppressErrors = true;
    int successCount = 0;
    int errorCount = 0;
    List<String> failedTasks = [];

    try {
      for (var task in tasks) {
        if (task.reminderDate != null && !task.isCompleted) {
          try {
            await scheduleTaskReminder(task);
            successCount++;
          } catch (e) {
            errorCount++;
            failedTasks.add('${task.title} (${task.id}): $e');
            AppLogging.logError('Failed to reschedule reminder for task ${task.id}: $e', name: 'NotificationService');
          }
        }
      }

      AppLogging.logInfo('Reschedule Summary: $successCount successful, $errorCount failed out of ${tasks.length} tasks', name: 'NotificationService');

      if (errorCount > 0) {
        AppLogging.logWarning('Failed to reschedule reminders for: ${failedTasks.join("; ")}', name: 'NotificationService');
      }
    } finally {
      _suppressErrors = false;
    }
  }

  Future<void> openNotificationSettings() async {
    try {
      await openAppSettings();
      AppLogging.logInfo('Opened app settings for notifications', name: 'NotificationService');
    } catch (e) {
      AppLogging.logError('Failed to open app settings: $e', name: 'NotificationService');
    }
  }

  Future<bool> areNotificationsEnabled() async {
    try {
      final androidPlugin = _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final iosPlugin = _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

      if (Platform.isAndroid) {
        final granted = await androidPlugin?.areNotificationsEnabled() ?? false;
        AppLogging.logInfo('Android notifications enabled: $granted', name: 'NotificationService');

        // Check exact alarms permission
        final exactAlarmsGranted = await androidPlugin?.requestExactAlarmsPermission() ?? false;
        AppLogging.logInfo('Android exact alarms permission granted: $exactAlarmsGranted', name: 'NotificationService');

        return granted;
      } else if (Platform.isIOS) {
        final granted = await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true) ?? false;
        AppLogging.logInfo('iOS notification permissions granted: $granted', name: 'NotificationService');
        return granted;
      }
      AppLogging.logInfo('Unknown platform, assuming notifications not enabled', name: 'NotificationService');
      return false;
    } catch (e) {
      AppLogging.logError('Failed to check notification status: $e', name: 'NotificationService');
      return false;
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      final pending = await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
      AppLogging.logInfo('Found ${pending.length} pending notifications', name: 'NotificationService');
      for (final notification in pending) {
        AppLogging.logInfo('Pending notification: ID=${notification.id}, Title=${notification.title}', name: 'NotificationService');
      }
      return pending;
    } catch (e) {
      AppLogging.logError('Failed to get pending notifications: $e', name: 'NotificationService');
      return [];
    }
  }

  Future<List<PendingNotificationRequest>> getPendingMoodNotifications() async {
    try {
      final allPending = await getPendingNotifications();
      final moodNotifications = allPending
          .where(
            (notification) => notification.id >= 100000 && notification.id < 100010, // Mood notification IDs range
          )
          .toList();
      AppLogging.logInfo('Found ${moodNotifications.length} pending mood notifications', name: 'NotificationService');
      return moodNotifications;
    } catch (e) {
      AppLogging.logError('Failed to get pending mood notifications: $e', name: 'NotificationService');
      return [];
    }
  }

  Future<void> rescheduleMoodNotifications({AppLocalizations? l10n}) async {
    try {
      final settingsService = SettingsService();
      await settingsService.initialize();
      if (settingsService.settings.enableMoodNotifications) {
        await scheduleMoodCheckInNotifications(settingsService.settings.moodCheckInTimes, l10n: l10n);
        AppLogging.logInfo('Rescheduled mood check-in notifications', name: 'NotificationService');
      }
    } catch (e) {
      AppLogging.logError('Failed to reschedule mood notifications: $e', name: 'NotificationService');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      AppLogging.logInfo('Cancelled all notifications', name: 'NotificationService');
    } catch (e) {
      AppLogging.logError('Failed to cancel all notifications: $e', name: 'NotificationService');
    }
  }

  /// Heal failed reminder with single retry

  /// Check for duplicate notifications before scheduling
  Future<bool> _isDuplicateNotification(String taskId) async {
    try {
      final pending = await getPendingNotifications();
      AppLogging.logInfo('Checking for duplicate notifications for task $taskId. Pending notifications: ${pending.length}', name: 'NotificationService');

      // Method 1: Check payload-based detection
      for (final notification in pending) {
        final payload = notification.payload;
        if (payload != null) {
          try {
            final data = Map<String, dynamic>.from(json.decode(payload));
            if (data['taskId'] == taskId) {
              AppLogging.logInfo('Found duplicate notification with payload for task $taskId', name: 'NotificationService');
              return true;
            }
          } catch (e) {
            AppLogging.logWarning('Failed to parse notification payload: $e', name: 'NotificationService');
          }
        }
      }

      // Method 2: Fallback - check notification ID pattern
      final notificationId = _generateTaskNotificationId(taskId);
      final idMatch = pending.any((notification) => notification.id == notificationId);
      if (idMatch) {
        AppLogging.logInfo('Found duplicate notification with ID for task $taskId', name: 'NotificationService');
        return true;
      }

      // Method 3: Fallback - check task ID in notification title
      final titleMatch = pending.any((notification) => notification.title != null && notification.title!.contains(taskId));
      if (titleMatch) {
        AppLogging.logInfo('Found duplicate notification with title containing task ID for task $taskId', name: 'NotificationService');
        return true;
      }

      AppLogging.logInfo('No duplicate notification found for task $taskId', name: 'NotificationService');
      return false;
    } catch (e) {
      AppLogging.logError('Failed to check for duplicates: $e', name: 'NotificationService');
      return false;
    }
  }

  /// Get time-based mood check-in messages
  List<Map<String, String>> _getTimeBasedMoodMessages(int hour, AppLocalizations l10n) {
    if (hour >= 5 && hour < 12) {
      // Morning (5am - 12pm)
      return [
        {'title': l10n.goodMorning, 'body': l10n.howAreYouStartingYourDay},
        {'title': l10n.riseAndShine, 'body': l10n.whatsYourEnergyLikeThisMorning},
        {'title': l10n.newDayNewVibes, 'body': l10n.howAreYouFeelingToday},
        {'title': l10n.morningCheckIn, 'body': l10n.takeAMomentToCheckInWithYourself},
      ];
    } else if (hour >= 12 && hour < 17) {
      // Afternoon (12pm - 5pm)
      return [
        {'title': l10n.checkingIn, 'body': l10n.howsYourAfternoonGoing},
        {'title': l10n.middayPause, 'body': l10n.howsYourFocusRightNow},
        {'title': l10n.quickCheck, 'body': l10n.howAreYouHoldingUp},
        {'title': l10n.afternoonVibes, 'body': l10n.whatsYourMoodLikeRightNow},
      ];
    } else if (hour >= 17 && hour < 21) {
      // Evening (5pm - 9pm)
      return [
        {'title': l10n.windingDown, 'body': l10n.howWasYourDay},
        {'title': l10n.eveningCheckIn, 'body': l10n.howAreYouFeelingTonight},
        {'title': l10n.endOfDayVibes, 'body': l10n.howDidTodayGoForYou},
        {'title': l10n.eveningReflection, 'body': l10n.takeAMomentToCheckIn},
      ];
    } else {
      // Night (9pm - 5am)
      return [
        {'title': l10n.beforeBed, 'body': l10n.howAreYouFeelingTonight},
        {'title': l10n.daysDone, 'body': l10n.howDidItGo},
        {'title': l10n.goodnightCheckIn, 'body': l10n.howAreYouEndingYourDay},
        {'title': l10n.nightReflection, 'body': l10n.takeAMomentForYourself},
      ];
    }
  }
}
