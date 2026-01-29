import 'package:uuid/uuid.dart';
import 'dart:async';
import '../models/task.dart';
import '../models/repeat_rule.dart';
import '../repositories/task_repository.dart';
import '../services/app_logging_service.dart';

class RepeatService {
  static final RepeatService _instance = RepeatService._internal();
  factory RepeatService() => _instance;
  RepeatService._internal();

  final TaskRepository _taskRepository = TaskRepository();
  final Uuid _uuid = const Uuid();

  /// Generate next recurring instance of a task with retry logic
  Future<Task?> generateNextRecurringTaskWithRetry(Task originalTask, {int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        final result = await generateNextRecurringTask(originalTask);
        return result;
      } catch (e) {
        if (i == maxRetries - 1) {
          // Log error for debugging - could use logging service here
          rethrow;
        }
        // Exponential backoff for retries
        await Future.delayed(Duration(milliseconds: 100 * (i + 1)));
      }
    }
    return null;
  }

  /// Generate next recurring instance of a task
  Future<Task?> generateNextRecurringTask(Task originalTask) async {
    AppLogging.logInfo('Generating recurring instance for task: ${originalTask.title} (ID: ${originalTask.id})');

    if (originalTask.repeatRule == null || !originalTask.repeatRule!.isActive) {
      AppLogging.logInfo('Task ${originalTask.title} has no active repeat rule, skipping');
      return null;
    }

    // Check if we've reached the repeat count limit
    if (originalTask.repeatRule!.repeatType == RepeatType.count) {
      final currentCount = await _getCurrentInstanceCount(originalTask.id);
      final maxCount = originalTask.repeatRule!.repeatCount ?? 0;
      AppLogging.logInfo('Task ${originalTask.title} repeat count: $currentCount/$maxCount');

      if (currentCount >= maxCount) {
        AppLogging.logInfo('Task ${originalTask.title} has reached repeat count limit, skipping');
        return null; // Already generated the required number of instances
      }
    }

    final nextDate = originalTask.repeatRule!.getNextOccurrence(originalTask.dueDate ?? DateTime.now());
    if (nextDate == null) {
      AppLogging.logInfo('No next occurrence calculated for task: ${originalTask.title}');
      return null;
    }

    AppLogging.logInfo('Next occurrence for task ${originalTask.title}: ${nextDate.toIso8601String()}');

    // Create new recurring instance
    final newTask = Task(
      id: _uuid.v4(),
      title: originalTask.title,
      description: originalTask.description,
      priority: originalTask.priority,
      dueDate: nextDate,
      reminderDate: originalTask.reminderDate != null
          ? nextDate.subtract(const Duration(hours: 1)) // 1 hour before due date
          : null,
      isCompleted: false,
      categoryId: originalTask.categoryId,
      repeatRule: originalTask.repeatRule,
      isRecurringInstance: true,
      originalTaskId: originalTask.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      progress: 0,
      tags: originalTask.tags,
      attachments: originalTask.attachments,
      voiceNotes: originalTask.voiceNotes,
    );

    AppLogging.logInfo('Successfully created recurring instance: ${newTask.id} for task: ${originalTask.title}');
    return newTask;
  }

  /// Get the current number of generated instances for a task
  Future<int> _getCurrentInstanceCount(String originalTaskId) async {
    final allTasks = await _taskRepository.getAllTasks();
    return allTasks.where((task) => task.originalTaskId == originalTaskId && task.isRecurringInstance).length;
  }

  /// Process completed recurring tasks and generate next instances
  Future<void> processCompletedRecurringTask(Task completedTask) async {
    if (!completedTask.isRecurringInstance || completedTask.repeatRule == null) {
      return;
    }

    final nextTask = await generateNextRecurringTask(completedTask);
    if (nextTask != null) {
      await _taskRepository.addTask(nextTask);
    }
  }

  /// Generate multiple recurring instances for bulk operations
  Future<List<Task>> generateMultipleRecurringInstances(List<Task> tasks) async {
    final instances = <Task>[];
    final errors = <String>[];

    for (final task in tasks) {
      try {
        final instance = await generateNextRecurringTask(task);
        if (instance != null) {
          instances.add(instance);
        }
      } catch (e) {
        errors.add('Failed to generate instance for "${task.title}": $e');
      }
    }

    if (errors.isNotEmpty) {
      // Could use logging service here instead of print
      // print('Recurring task generation errors: ${errors.join(', ')}');
    }

    return instances;
  }

  /// Get all recurring tasks that need to generate new instances
  Future<List<Task>> getTasksNeedingRecurringInstances() async {
    final allTasks = await _taskRepository.getAllTasks();
    final recurringTasks = <Task>[];

    // Pre-build a map of originalTaskId -> has future instance (O(n) instead of O(n²))
    final futureInstanceMap = <String, bool>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final task in allTasks) {
      if (task.originalTaskId != null && task.dueDate != null && task.dueDate!.isAfter(now)) {
        futureInstanceMap[task.originalTaskId!] = true;
      }
    }

    for (final task in allTasks) {
      if (task.repeatRule != null && task.repeatRule!.isActive && !task.isRecurringInstance) {
        // Check if already generated today to prevent duplicates
        if (task.lastGeneratedAt != null) {
          final lastGenDate = DateTime(task.lastGeneratedAt!.year, task.lastGeneratedAt!.month, task.lastGeneratedAt!.day);
          if (lastGenDate.isAtSameMomentAs(today)) {
            continue; // Already generated today, skip
          }
        }

        final nextOccurrence = task.repeatRule!.getNextOccurrence(task.dueDate ?? DateTime.now());

        if (nextOccurrence != null) {
          // Check if we already have a future instance using pre-built map
          final hasFutureInstance = futureInstanceMap[task.id] ?? false;

          if (!hasFutureInstance) {
            recurringTasks.add(task);
          }
        }
      }
    }

    return recurringTasks;
  }

  /// Generate recurring instances for a given time period
  Future<List<Task>> generateRecurringInstancesForPeriod(Task originalTask, DateTime startDate, DateTime endDate) async {
    if (originalTask.repeatRule == null) {
      return [];
    }

    final instances = <Task>[];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate)) {
      final nextDate = originalTask.repeatRule!.getNextOccurrence(currentDate);
      if (nextDate == null || nextDate.isAfter(endDate)) {
        break;
      }

      final instance = Task(
        id: _uuid.v4(),
        title: originalTask.title,
        description: originalTask.description,
        priority: originalTask.priority,
        dueDate: nextDate,
        reminderDate: originalTask.reminderDate != null ? nextDate.subtract(const Duration(hours: 1)) : null,
        isCompleted: false,
        categoryId: originalTask.categoryId,
        repeatRule: originalTask.repeatRule,
        isRecurringInstance: true,
        originalTaskId: originalTask.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        progress: 0,
        tags: originalTask.tags,
        attachments: originalTask.attachments,
        voiceNotes: originalTask.voiceNotes,
      );

      instances.add(instance);
      currentDate = nextDate.add(const Duration(days: 1));
    }

    return instances;
  }

  /// Update repeat rule for a task and regenerate instances
  Future<void> updateRepeatRule(Task task, RepeatRule newRepeatRule) async {
    // Update the original task
    final updatedTask = task.copyWith(repeatRule: newRepeatRule, updatedAt: DateTime.now());

    await _taskRepository.updateTask(updatedTask);

    // Delete existing recurring instances
    final existingTasks = await _taskRepository.getAllTasks();
    final instancesToDelete = existingTasks.where((t) => t.originalTaskId == task.id && t.isRecurringInstance).toList();

    for (final instance in instancesToDelete) {
      await _taskRepository.deleteTask(instance.id);
    }

    // Generate new instances if needed
    final tasksNeedingInstances = await getTasksNeedingRecurringInstances();
    if (tasksNeedingInstances.any((t) => t.id == task.id)) {
      final nextInstance = await generateNextRecurringTask(updatedTask);
      if (nextInstance != null) {
        await _taskRepository.addTask(nextInstance);
      }
    }
  }

  /// Get recurring task statistics
  Future<Map<String, int>> getRecurringTaskStats() async {
    final allTasks = await _taskRepository.getAllTasks();
    final recurringTasks = allTasks.where((task) => task.repeatRule != null).toList();
    final recurringInstances = allTasks.where((task) => task.isRecurringInstance).toList();

    return {'totalRecurringTasks': recurringTasks.length, 'totalRecurringInstances': recurringInstances.length, 'activeRecurringTasks': recurringTasks.where((task) => task.repeatRule != null && task.repeatRule!.isActive).length};
  }
}
