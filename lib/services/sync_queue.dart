import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../models/category.dart';
import 'app_logging_service.dart';
import 'data_sync_service.dart';

enum SyncStatus { idle, syncing, failed, success }

enum OperationType { createTask, updateTask, deleteTask, createCategory, updateCategory, deleteCategory }

class PendingOperation {
  final String id;
  final OperationType type;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  int retryCount;
  SyncStatus status;

  PendingOperation({required this.id, required this.type, required this.data, required this.createdAt, this.retryCount = 0, this.status = SyncStatus.idle});

  Map<String, dynamic> toJson() => {'id': id, 'type': type.index, 'data': data, 'createdAt': createdAt.toIso8601String(), 'retryCount': retryCount, 'status': status.index};

  factory PendingOperation.fromJson(Map<String, dynamic> json) => PendingOperation(
    id: json['id'],
    type: OperationType.values[json['type']],
    data: Map<String, dynamic>.from(json['data']),
    createdAt: DateTime.parse(json['createdAt']),
    retryCount: json['retryCount'] ?? 0,
    status: SyncStatus.values[json['status'] ?? 0],
  );
}

class SyncQueue {
  static const String _queueKey = 'sync_queue';
  static const int maxRetries = 3;

  final List<PendingOperation> _queue = [];
  final StreamController<SyncStatus> _statusController = StreamController<SyncStatus>.broadcast();
  final StreamController<int> _pendingCountController = StreamController<int>.broadcast();
  final DataSyncService _dataSyncService = DataSyncService();

  Timer? _processingTimer;
  bool _isProcessing = false;

  Stream<SyncStatus> get statusStream => _statusController.stream;
  Stream<int> get pendingCountStream => _pendingCountController.stream;

  int get pendingCount => _queue.where((op) => op.status != SyncStatus.success).length;
  bool get hasPendingOperations => pendingCount > 0;
  bool get hasFailedOperations => _queue.any((op) => op.status == SyncStatus.failed);

  SyncStatus get currentStatus {
    if (_isProcessing) return SyncStatus.syncing;
    if (hasFailedOperations) return SyncStatus.failed;
    if (hasPendingOperations) return SyncStatus.idle;
    return SyncStatus.success;
  }

  Future<void> initialize() async {
    await _loadQueue();
    _startPeriodicProcessing();
    _updateStatus();
  }

  void enqueueTaskCreate(Task task) {
    _enqueue(PendingOperation(id: '${task.id}_create_${DateTime.now().millisecondsSinceEpoch}', type: OperationType.createTask, data: task.toJson(), createdAt: DateTime.now()));
  }

  void enqueueTaskUpdate(Task task) {
    _enqueue(PendingOperation(id: '${task.id}_update_${DateTime.now().millisecondsSinceEpoch}', type: OperationType.updateTask, data: task.toJson(), createdAt: DateTime.now()));
  }

  void enqueueTaskDelete(String taskId) {
    _enqueue(PendingOperation(id: '${taskId}_delete_${DateTime.now().millisecondsSinceEpoch}', type: OperationType.deleteTask, data: {'id': taskId}, createdAt: DateTime.now()));
  }

  void enqueueCategoryCreate(Category category) {
    _enqueue(PendingOperation(id: '${category.id}_create_${DateTime.now().millisecondsSinceEpoch}', type: OperationType.createCategory, data: category.toJson(), createdAt: DateTime.now()));
  }

  void enqueueCategoryUpdate(Category category) {
    _enqueue(PendingOperation(id: '${category.id}_update_${DateTime.now().millisecondsSinceEpoch}', type: OperationType.updateCategory, data: category.toJson(), createdAt: DateTime.now()));
  }

  void enqueueCategoryDelete(String categoryId) {
    _enqueue(PendingOperation(id: '${categoryId}_delete_${DateTime.now().millisecondsSinceEpoch}', type: OperationType.deleteCategory, data: {'id': categoryId}, createdAt: DateTime.now()));
  }

  void _enqueue(PendingOperation operation) {
    _queue.add(operation);
    _persistQueue();
    _updateStatus();
    _updatePendingCount();
    AppLogging.logInfo('Enqueued sync operation: ${operation.type} for ${operation.id}');
  }

  Future<void> processQueue() async {
    if (_isProcessing) return;

    _isProcessing = true;
    _updateStatus();

    AppLogging.logInfo('Processing sync queue with ${_queue.length} operations');

    final pendingOps = _queue.where((op) => op.status != SyncStatus.success).toList();

    for (final operation in pendingOps) {
      try {
        operation.status = SyncStatus.syncing;
        _updateStatus();

        await _executeOperation(operation);

        operation.status = SyncStatus.success;
        AppLogging.logInfo('Successfully synced operation: ${operation.id}');
      } catch (e) {
        operation.retryCount++;

        if (operation.retryCount >= maxRetries) {
          operation.status = SyncStatus.failed;
          AppLogging.logError('Operation failed permanently after $maxRetries retries: ${operation.id} - $e');
        } else {
          operation.status = SyncStatus.idle;
          AppLogging.logWarning('Operation failed, will retry (${operation.retryCount}/$maxRetries): ${operation.id} - $e');
        }
      }
    }

    // Remove successful operations older than 1 hour
    final oneHourAgo = DateTime.now().subtract(const Duration(hours: 1));
    _queue.removeWhere((op) => op.status == SyncStatus.success && op.createdAt.isBefore(oneHourAgo));

    _isProcessing = false;
    _persistQueue();
    _updateStatus();
    _updatePendingCount();

    AppLogging.logInfo('Sync queue processing completed. Pending: $pendingCount, Failed: ${_queue.where((op) => op.status == SyncStatus.failed).length}');
  }

  Future<void> _executeOperation(PendingOperation operation) async {
    switch (operation.type) {
      case OperationType.createTask:
      case OperationType.updateTask:
        final task = Task.fromJson(operation.data);
        // Use DataSyncService to sync individual task
        await _dataSyncService.syncTaskToFirestore(task);
        break;

      case OperationType.deleteTask:
        final taskId = operation.data['id'] as String;
        await _dataSyncService.deleteTaskFromFirestore(taskId);
        break;

      case OperationType.createCategory:
      case OperationType.updateCategory:
        final category = Category.fromJson(operation.data);
        await _dataSyncService.syncCategoryToFirestore(category);
        break;

      case OperationType.deleteCategory:
        final categoryId = operation.data['id'] as String;
        await _dataSyncService.deleteCategoryFromFirestore(categoryId);
        break;
    }
  }

  void _startPeriodicProcessing() {
    _processingTimer?.cancel();
    _processingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (hasPendingOperations) {
        processQueue();
      }
    });
  }

  Future<void> _loadQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getString(_queueKey);

      if (queueJson != null) {
        final List<dynamic> queueList = jsonDecode(queueJson);
        _queue.clear();
        _queue.addAll(queueList.map((json) => PendingOperation.fromJson(json)));
        AppLogging.logInfo('Loaded ${_queue.length} operations from sync queue');
      }
    } catch (e) {
      AppLogging.logError('Failed to load sync queue: $e');
    }
  }

  Future<void> _persistQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = jsonEncode(_queue.map((op) => op.toJson()).toList());
      await prefs.setString(_queueKey, queueJson);
    } catch (e) {
      AppLogging.logError('Failed to persist sync queue: $e');
    }
  }

  void _updateStatus() {
    _statusController.add(currentStatus);
  }

  void _updatePendingCount() {
    _pendingCountController.add(pendingCount);
  }

  Future<void> retryFailedOperations() async {
    for (final operation in _queue) {
      if (operation.status == SyncStatus.failed) {
        operation.status = SyncStatus.idle;
        operation.retryCount = 0;
      }
    }
    _persistQueue();
    _updateStatus();
    _updatePendingCount();
    await processQueue();
  }

  void clearFailedOperations() {
    _queue.removeWhere((op) => op.status == SyncStatus.failed);
    _persistQueue();
    _updateStatus();
    _updatePendingCount();
  }

  void dispose() {
    _processingTimer?.cancel();
    _statusController.close();
    _pendingCountController.close();
  }
}

// Global instance
final syncQueue = SyncQueue();
