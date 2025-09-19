import 'dart:developer' show log;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';
import '../models/task.dart';
import 'background_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request notification permissions
    await _requestPermissions();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        log('Notification tapped: ${response.payload}');
      },
    );
  }

  Future<void> _requestPermissions() async {
    await Permission.notification.request();
  }

  Future<void> scheduleTaskReminder(Task task) async {
    if (task.reminderDate == null) return;

    // Use background service for battery-optimized scheduling on Android
    if (Platform.isAndroid) {
      await BackgroundService().scheduleTaskReminder(task);
    } else {
      // Fallback to local notifications for iOS
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'task_reminders',
        'Task Reminders',
        channelDescription: 'Reminders for upcoming tasks',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails();

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        task.id.hashCode,
        'Task Reminder',
        'Don\'t forget: ${task.title}',
        tz.TZDateTime.from(task.reminderDate!, tz.local),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelTaskReminder(String taskId) async {
    // Cancel background task if on Android
    if (Platform.isAndroid) {
      await BackgroundService().cancelTaskReminder(taskId);
    }
    // Also cancel local notification
    await _flutterLocalNotificationsPlugin.cancel(taskId.hashCode);
  }

  Future<void> showTaskDueNotification(Task task) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'task_due',
      'Task Due',
      channelDescription: 'Notifications for due tasks',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      task.id.hashCode + 1000, // Different ID for due notifications
      'Task Due Today',
      '${task.title} is due today!',
      platformChannelSpecifics,
      payload: task.id,
    );
  }

  Future<void> showTaskCompletedNotification(Task task) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'task_completed',
      'Task Completed',
      channelDescription: 'Celebration notifications for completed tasks',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      task.id.hashCode + 2000, // Different ID for completion notifications
      'Task Completed! 🎉',
      'Great job completing: ${task.title}',
      platformChannelSpecifics,
      payload: task.id,
    );
  }
}
