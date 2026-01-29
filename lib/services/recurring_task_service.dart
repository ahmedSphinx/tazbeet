import 'dart:async';
import '../services/app_logging_service.dart';
import '../services/repeat_service.dart';
import '../repositories/task_repository.dart';

/// Background service for processing recurring tasks
class RecurringTaskService {
  static final RecurringTaskService _instance = RecurringTaskService._internal();
  factory RecurringTaskService() => _instance;
  RecurringTaskService._internal();

  final RepeatService _repeatService = RepeatService();
  final TaskRepository _taskRepository = TaskRepository();
  Timer? _processingTimer;
  bool _isProcessing = false;

  /// Start the background processing service
  void start() {
    _processingTimer?.cancel();
    _processingTimer = Timer.periodic(const Duration(hours: 1), (timer) {
      _processRecurringTasks();
    });
    AppLogging.logInfo('RecurringTaskService started - will process every hour');
  }

  /// Stop the background processing service
  void stop() {
    _processingTimer?.cancel();
    _processingTimer = null;
    AppLogging.logInfo('RecurringTaskService stopped');
  }

  /// Process all recurring tasks that need new instances
  Future<void> _processRecurringTasks() async {
    if (_isProcessing) return;

    final stopwatch = Stopwatch()..start();
    _isProcessing = true;

    try {
      AppLogging.logInfo('Processing recurring tasks...');

      final tasksNeedingInstances = await _repeatService.getTasksNeedingRecurringInstances();
      int successCount = 0;
      int failureCount = 0;
      List<String> failedTasks = [];

      for (final task in tasksNeedingInstances) {
        final taskStopwatch = Stopwatch()..start();
        bool taskProcessed = false;
        int attempts = 0;
        const maxAttempts = 3;

        while (!taskProcessed && attempts < maxAttempts) {
          attempts++;
          try {
            final nextInstance = await _repeatService.generateNextRecurringTask(task);
            if (nextInstance != null) {
              await _taskRepository.addTask(nextInstance);

              // Update original task with lastGeneratedAt timestamp
              final updatedTask = task.copyWith(lastGeneratedAt: DateTime.now(), updatedAt: DateTime.now());
              await _taskRepository.updateTask(updatedTask);

              successCount++;
              taskProcessed = true;
              AppLogging.logInfo('Generated recurring instance for task: ${task.title} (attempt $attempts, ${taskStopwatch.elapsedMilliseconds}ms)');
            } else {
              // No instance needed, count as success
              successCount++;
              taskProcessed = true;
              AppLogging.logInfo('No instance needed for task: ${task.title} (${taskStopwatch.elapsedMilliseconds}ms)');
            }
          } catch (e) {
            AppLogging.logError('Failed to generate recurring instance for task ${task.title} (attempt $attempts): $e');

            if (attempts < maxAttempts) {
              // Exponential backoff: wait 1s, 2s, 4s
              final waitTime = Duration(milliseconds: 1000 * (1 << (attempts - 1)));
              AppLogging.logInfo('Retrying task ${task.title} after ${waitTime.inMilliseconds}ms');
              await Future.delayed(waitTime);
            } else {
              failureCount++;
              failedTasks.add(task.title);
              AppLogging.logError('Failed to process task ${task.title} after $maxAttempts attempts (${taskStopwatch.elapsedMilliseconds}ms total)');
            }
          }
        }
        taskStopwatch.stop();
      }

      stopwatch.stop();
      final totalTime = stopwatch.elapsedMilliseconds;

      AppLogging.logInfo('Recurring task processing completed: $successCount success, $failureCount failures in ${totalTime}ms');
      if (failedTasks.isNotEmpty) {
        AppLogging.logError('Failed tasks: ${failedTasks.join(', ')}');
      }

      // Performance warning if processing takes too long
      if (totalTime > 5000) {
        // 5 seconds
        AppLogging.logWarning('Recurring task processing took ${totalTime}ms - consider optimization');
      }
    } catch (e) {
      AppLogging.logError('Critical error in recurring task processing: $e');
    } finally {
      _isProcessing = false;
      stopwatch.stop();
    }
  }

  /// Manual trigger for processing recurring tasks (for testing or immediate updates)
  Future<void> processNow() async {
    await _processRecurringTasks();
  }

  /// Get statistics about recurring tasks
  Future<Map<String, dynamic>> getRecurringStats() async {
    final stats = await _repeatService.getRecurringTaskStats();
    final tasksNeedingInstances = await _repeatService.getTasksNeedingRecurringInstances();

    return {...stats, 'tasksNeedingInstances': tasksNeedingInstances.length, 'isProcessing': _isProcessing, 'isTimerActive': _processingTimer?.isActive ?? false};
  }

  void dispose() {
    stop();
  }
}
