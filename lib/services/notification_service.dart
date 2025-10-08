import 'package:tazbeet/services/app_logging.dart';
import 'package:tazbeet/services/navigation_service.dart';
import 'package:tazbeet/services/settings_service.dart';
import 'package:tazbeet/l10n/app_localizations.dart';

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

  Future<void> _requestPermissions() async {
    await Permission.notification.request();
    if (await Permission.notification.isGranted) {
      AppLogging.logInfo('Notification permission granted', name: 'NotificationService');
    } else {
      AppLogging.logWarning('Notification permission not granted', name: 'NotificationService');
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

  Future<void> scheduleTaskReminder(Task task) async {
    if (task.reminderDate == null) return;

    final now = tz.TZDateTime.now(tz.local);
    final offset = DateTime.now().timeZoneOffset;

    // Convert task reminder date (assumed local) to UTC for scheduling
    DateTime utcScheduled = task.reminderDate!.subtract(offset);
    final scheduledTime = tz.TZDateTime.from(utcScheduled, tz.local);

    if (scheduledTime.isBefore(now)) {
      AppLogging.logWarning('Cannot schedule reminder for past date: ${task.reminderDate}', name: 'NotificationService-${task.title}');
      return;
    }

    AppLogging.logInfo('Scheduling task reminder for task: ${task.id} - ${task.title} at ${task.reminderDate}', name: 'NotificationService');

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'task_reminders',
      'Task Reminders',
      channelDescription: 'Reminders for upcoming tasks',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      task.id.hashCode.abs(),
      'Task Reminder',
      'Don\'t forget: ${task.title}',
      scheduledTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
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

        const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
          moodNotificationChannelId,
          moodNotificationChannelName,
          channelDescription: 'Notifications for mood check-ins',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          enableVibration: true,
        );

        const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);

        const NotificationDetails platformDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

        try {
          await _flutterLocalNotificationsPlugin.zonedSchedule(
            notificationId,
            l10n?.moodCheckInNotificationTitle ?? 'Mood Check-In',
            l10n?.moodCheckInNotificationBody ?? 'How are you feeling right now? Tap to record your mood.',
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
    await _flutterLocalNotificationsPlugin.cancel(taskId.hashCode);
  }

  Future<void> showTaskDueNotification(Task task) async {
    AppLogging.logInfo('Showing task due notification for task: ${task.id} - ${task.title}', name: 'NotificationService');

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'task_due',
      'Task Due',
      channelDescription: 'Notifications for due tasks',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      task.id.hashCode + 1000, // Different ID for due notifications
      'Task Due Today',
      '${task.title} is due today!',
      platformChannelSpecifics,
      payload: task.id,
    );
  }

  Future<void> showTaskCompletedNotification(Task task) async {
    AppLogging.logInfo('Showing task completed notification for task: ${task.id} - ${task.title}', name: 'NotificationService');

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'task_completed',
      'Task Completed',
      channelDescription: 'Celebration notifications for completed tasks',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      task.id.hashCode + 2000, // Different ID for completion notifications
      'Task Completed! 🎉',
      'Great job completing: ${task.title}',
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

      // Schedule the notification
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        'Test Reminder',
        'This is a test notification to verify reminder functionality',
        testTime,
        const NotificationDetails(
          android: AndroidNotificationDetails('task_reminders', 'Task Reminders', channelDescription: 'Reminders for tasks', importance: Importance.max, priority: Priority.high, playSound: true, enableVibration: true),
          iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
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

      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        'Immediate Test Notification',
        'This is an immediate notification to test if notifications work',
        const NotificationDetails(
          android: AndroidNotificationDetails('task_reminders', 'Task Reminders', channelDescription: 'Reminders for tasks', importance: Importance.max, priority: Priority.high, playSound: true, enableVibration: true),
          iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
        ),
      );

      AppLogging.logInfo('Showed immediate test notification', name: 'NotificationService');
    } catch (e) {
      AppLogging.logError('Failed to show immediate test notification: $e', name: 'NotificationService');
      rethrow;
    }
  }

  Future<void> showTestMoodNotificationNow({AppLocalizations? l10n}) async {
    try {
      const notificationId = 2000; // Fixed ID for mood test

      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        l10n?.testMoodNotificationTitle ?? 'Test Mood Check-In',
        l10n?.testMoodNotificationBody ?? 'This is a test mood check-in notification.',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            moodNotificationChannelId,
            moodNotificationChannelName,
            channelDescription: 'Notifications for mood check-ins',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
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

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        l10n?.testMoodNotificationTitle ?? 'Test Mood Check-In',
        l10n?.testMoodNotificationBody ?? 'This is a scheduled test mood check-in notification.',
        testTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            moodNotificationChannelId,
            moodNotificationChannelName,
            channelDescription: 'Notifications for mood check-ins',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
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
    for (var task in tasks) {
      if (task.reminderDate != null && !task.isCompleted) {
        await scheduleTaskReminder(task);
      }
    }
    AppLogging.logInfo('Rescheduled all reminders for ${tasks.where((t) => t.reminderDate != null && !t.isCompleted).length} tasks', name: 'NotificationService');
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
}
