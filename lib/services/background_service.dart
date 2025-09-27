import 'dart:async';
import 'dart:developer' show log;
import 'dart:io';
import 'package:workmanager/workmanager.dart' as wm;
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../models/mood.dart';
import '../repositories/task_repository.dart';
import 'notification_service.dart';

class BackgroundService {
  static const String taskReminderTask = 'taskReminderTask';
  static const String pomodoroTimerTask = 'pomodoroTimerTask';

  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;
  BackgroundService._internal();

  final NotificationService _notificationService = NotificationService();

  Future<void> initialize() async {
    if (Platform.isAndroid) {
      await wm.Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
      await _registerAndroidTasks();
    }
    // iOS background functionality removed for simplicity
  }

  Future<void> _registerAndroidTasks() async {
    // Register task reminder task
    await wm.Workmanager().registerPeriodicTask(
      taskReminderTask,
      taskReminderTask,
      frequency: const Duration(minutes: 15),
      constraints: wm.Constraints(
        requiresBatteryNotLow: true,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: true,
      ),
    );

    // Register pomodoro timer task
    await wm.Workmanager().registerPeriodicTask(
      pomodoroTimerTask,
      pomodoroTimerTask,
      frequency: const Duration(minutes: 1),
      constraints: wm.Constraints(
        requiresBatteryNotLow: true,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: true,
      ),
    );
  }

  Future<void> scheduleTaskReminder(Task task) async {
    if (Platform.isAndroid) {
      await wm.Workmanager().registerOneOffTask(
        'task_${task.id}',
        taskReminderTask,
        inputData: {'taskId': task.id},
        initialDelay: task.reminderDate!.difference(DateTime.now()),
        constraints: wm.Constraints(
          requiresBatteryNotLow: true,
        ),
      );
    }
  }

  Future<void> cancelTaskReminder(String taskId) async {
    if (Platform.isAndroid) {
      await wm.Workmanager().cancelByUniqueName('task_$taskId');
    }
  }


}

@pragma('vm:entry-point')
void callbackDispatcher() {
  wm.Workmanager().executeTask((task, inputData) async {
    log('Native called background task: $task',name: 'BackgroundService');

    // Initialize Hive for background isolate
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(MoodAdapter());
    Hive.registerAdapter(MoodLevelAdapter());

    final backgroundService = BackgroundService();

    switch (task) {
      case BackgroundService.taskReminderTask:
        await backgroundService._checkDueTasks();
        break;
      case BackgroundService.pomodoroTimerTask:
        await backgroundService._managePomodoroTimers();
        break;
      default:
        if (task.startsWith('task_')) {
          final taskId = inputData?['taskId'] as String?;
          if (taskId != null) {
            await backgroundService._sendTaskReminder(taskId);
          }
        }
        break;
    }

    return Future.value(true);
  });
}

extension BackgroundServicePrivate on BackgroundService {
  Future<void> _checkDueTasks() async {
    try {
      await Hive.initFlutter();
      final box = await Hive.openBox<Task>('tasks');

      final now = DateTime.now();
      final tasks = box.values.where((task) {
        if (task.dueDate == null) return false;
        final timeDiff = task.dueDate!.difference(now).inHours;
        return timeDiff <= 24 && timeDiff >= 0 && !task.isCompleted;
      }).toList();

      for (final task in tasks) {
        await _notificationService.showTaskDueNotification(task);
      }
    } catch (e) {
      log('Error checking due tasks: $e', name: 'BackgroundService');
    }
  }

  Future<void> _managePomodoroTimers() async {
    // This would manage persistent Pomodoro timers
    // For now, just a placeholder for background timer management
    log('Managing Pomodoro timers in background');
  }

  Future<void> _sendTaskReminder(String taskId) async {
    try {
      await Hive.initFlutter();
      final box = await Hive.openBox<Task>('tasks');
      final task = box.get(taskId);

      if (task != null && !task.isCompleted) {
        await _notificationService.scheduleTaskReminder(task);
      }
    } catch (e) {
      log('Error sending task reminder: $e');
    }
  }
}
