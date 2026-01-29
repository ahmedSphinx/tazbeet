import '../services/recurring_task_service.dart';
import '../services/app_logging_service.dart';

class RecurringTasksController {
  static final RecurringTasksController _instance = RecurringTasksController._internal();
  factory RecurringTasksController() => _instance;
  RecurringTasksController._internal();

  final RecurringTaskService _service = RecurringTaskService();

  // Get current statistics
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      return await _service.getRecurringStats();
    } catch (e) {
      AppLogging.logError('Failed to get recurring tasks statistics: $e');
      rethrow;
    }
  }

  // Process recurring tasks manually
  Future<void> processRecurringTasks() async {
    try {
      await _service.processNow();
      AppLogging.logInfo('Recurring tasks processed successfully');
    } catch (e) {
      AppLogging.logError('Failed to process recurring tasks: $e');
      rethrow;
    }
  }

  // Start the background service
  void startBackgroundService() {
    _service.start();
  }

  // Stop the background service
  void stopBackgroundService() {
    _service.stop();
  }
}
