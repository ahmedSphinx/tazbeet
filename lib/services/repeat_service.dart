import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../models/repeat_rule.dart';
import '../repositories/task_repository.dart';

class RepeatService {
  static final RepeatService _instance = RepeatService._internal();
  factory RepeatService() => _instance;
  RepeatService._internal();

  final TaskRepository _taskRepository = TaskRepository();
  final Uuid _uuid = const Uuid();

  /// Generate next recurring instance of a task
  Future<Task?> generateNextRecurringTask(Task originalTask) async {
    if (originalTask.repeatRule == null || !originalTask.repeatRule!.isActive) {
      return null;
    }

    final nextDate = originalTask.repeatRule!.getNextOccurrence(originalTask.dueDate ?? DateTime.now());
    if (nextDate == null) {
      return null;
    }

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

    return newTask;
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

  /// Get all recurring tasks that need to generate new instances
  Future<List<Task>> getTasksNeedingRecurringInstances() async {
    final allTasks = await _taskRepository.getAllTasks();
    final recurringTasks = <Task>[];

    for (final task in allTasks) {
      if (task.repeatRule != null && task.repeatRule!.isActive) {
        final nextOccurrence = task.repeatRule!.getNextOccurrence(
          task.dueDate ?? DateTime.now(),
        );

        if (nextOccurrence != null) {
          // Check if we already have a future instance
          final existingInstances = await _taskRepository.getAllTasks();
          final hasFutureInstance = existingInstances.any((t) =>
            t.originalTaskId == task.id &&
            t.dueDate != null &&
            t.dueDate!.isAfter(DateTime.now())
          );

          if (!hasFutureInstance) {
            recurringTasks.add(task);
          }
        }
      }
    }

    return recurringTasks;
  }

  /// Generate recurring instances for a given time period
  Future<List<Task>> generateRecurringInstancesForPeriod(
    Task originalTask,
    DateTime startDate,
    DateTime endDate,
  ) async {
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
        reminderDate: originalTask.reminderDate != null
            ? nextDate.subtract(const Duration(hours: 1))
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

      instances.add(instance);
      currentDate = nextDate.add(const Duration(days: 1));
    }

    return instances;
  }

  /// Update repeat rule for a task and regenerate instances
  Future<void> updateRepeatRule(Task task, RepeatRule newRepeatRule) async {
    // Update the original task
    final updatedTask = task.copyWith(
      repeatRule: newRepeatRule,
      updatedAt: DateTime.now(),
    );

    await _taskRepository.updateTask(updatedTask);

    // Delete existing recurring instances
    final existingTasks = await _taskRepository.getAllTasks();
    final instancesToDelete = existingTasks.where(
      (t) => t.originalTaskId == task.id && t.isRecurringInstance,
    ).toList();

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

    return {
      'totalRecurringTasks': recurringTasks.length,
      'totalRecurringInstances': recurringInstances.length,
      'activeRecurringTasks': recurringTasks.where((task) =>
        task.repeatRule != null && task.repeatRule!.isActive
      ).length,
    };
  }
}
