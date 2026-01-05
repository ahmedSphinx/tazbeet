import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tazbeet/services/app_logging_service.dart';
import 'package:tazbeet/models/task.dart';
import 'dart:async';

/// Service to verify notification scheduling and delivery
class NotificationVerificationService {
  static final NotificationVerificationService _instance = NotificationVerificationService._internal();
  factory NotificationVerificationService() => _instance;
  NotificationVerificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  /// Verify if a notification is scheduled
  Future<bool> isNotificationScheduled(int notificationId) async {
    try {
      final pendingNotifications = await _plugin.pendingNotificationRequests();
      return pendingNotifications.any((notification) => notification.id == notificationId);
    } catch (e) {
      AppLogging.logError('Failed to check scheduled notifications: $e', name: 'NotificationVerification');
      return false;
    }
  }

  /// Get all pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _plugin.pendingNotificationRequests();
    } catch (e) {
      AppLogging.logError('Failed to get pending notifications: $e', name: 'NotificationVerification');
      return [];
    }
  }

  /// Verify task reminder is scheduled
  Future<bool> verifyTaskReminder(Task task) async {
    if (task.reminderDate == null) return true; // No reminder needed

    final notificationId = task.id.hashCode;
    final isScheduled = await isNotificationScheduled(notificationId);

    if (!isScheduled && task.reminderDate!.isAfter(DateTime.now())) {
      AppLogging.logWarning('Task reminder not scheduled: ${task.title} (ID: ${task.id})', name: 'NotificationVerification');
    }

    return isScheduled;
  }

  /// Get count of pending notifications
  Future<int> getPendingNotificationCount() async {
    final pending = await getPendingNotifications();
    return pending.length;
  }

  /// Verify all task reminders
  Future<Map<String, dynamic>> verifyAllTaskReminders(List<Task> tasks) async {
    int totalWithReminders = 0;
    int scheduled = 0;
    int missing = 0;
    List<String> missingTasks = [];

    for (final task in tasks) {
      if (task.reminderDate != null && !task.isCompleted) {
        totalWithReminders++;
        final isScheduled = await verifyTaskReminder(task);
        if (isScheduled) {
          scheduled++;
        } else {
          missing++;
          missingTasks.add(task.title);
        }
      }
    }

    return {'totalWithReminders': totalWithReminders, 'scheduled': scheduled, 'missing': missing, 'missingTasks': missingTasks};
  }

  /// Log notification verification report
  Future<void> logVerificationReport(List<Task> tasks) async {
    final report = await verifyAllTaskReminders(tasks);
    final pendingCount = await getPendingNotificationCount();

    AppLogging.logInfo(
      'Notification Verification Report:\n'
      '  Total pending notifications: $pendingCount\n'
      '  Tasks with reminders: ${report['totalWithReminders']}\n'
      '  Scheduled: ${report['scheduled']}\n'
      '  Missing: ${report['missing']}\n'
      '  Missing tasks: ${report['missingTasks']}',
      name: 'NotificationVerification',
    );
  }
}
