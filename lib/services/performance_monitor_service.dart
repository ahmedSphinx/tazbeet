import 'package:tazbeet/services/app_logging_service.dart';
import 'dart:async';

/// Service to monitor app performance metrics
class PerformanceMonitorService {
  static final PerformanceMonitorService _instance = PerformanceMonitorService._internal();
  factory PerformanceMonitorService() => _instance;
  PerformanceMonitorService._internal();

  final Map<String, DateTime> _operationStartTimes = {};
  final Map<String, List<Duration>> _operationDurations = {};
  final Map<String, int> _operationCounts = {};

  /// Start timing an operation
  void startOperation(String operationName) {
    _operationStartTimes[operationName] = DateTime.now();
  }

  /// End timing an operation and record duration
  void endOperation(String operationName) {
    final startTime = _operationStartTimes[operationName];
    if (startTime == null) {
      AppLogging.logWarning('Operation "$operationName" was never started', name: 'PerformanceMonitor');
      return;
    }

    final duration = DateTime.now().difference(startTime);
    _operationDurations.putIfAbsent(operationName, () => []).add(duration);
    _operationCounts[operationName] = (_operationCounts[operationName] ?? 0) + 1;
    _operationStartTimes.remove(operationName);

    // Log slow operations (>1 second)
    if (duration.inMilliseconds > 1000) {
      AppLogging.logWarning('Slow operation detected: $operationName took ${duration.inMilliseconds}ms', name: 'PerformanceMonitor');
    }
  }

  /// Time an async operation
  Future<T> timeOperation<T>(String operationName, Future<T> Function() operation) async {
    startOperation(operationName);
    try {
      return await operation();
    } finally {
      endOperation(operationName);
    }
  }

  /// Time a sync operation
  T timeOperationSync<T>(String operationName, T Function() operation) {
    startOperation(operationName);
    try {
      return operation();
    } finally {
      endOperation(operationName);
    }
  }

  /// Get average duration for an operation
  Duration? getAverageDuration(String operationName) {
    final durations = _operationDurations[operationName];
    if (durations == null || durations.isEmpty) return null;

    final totalMs = durations.fold<int>(0, (sum, d) => sum + d.inMilliseconds);
    return Duration(milliseconds: totalMs ~/ durations.length);
  }

  /// Get operation statistics
  Map<String, dynamic> getOperationStats(String operationName) {
    final durations = _operationDurations[operationName] ?? [];
    if (durations.isEmpty) {
      return {'count': 0, 'average': null, 'min': null, 'max': null};
    }

    final durationMs = durations.map((d) => d.inMilliseconds).toList()..sort();
    return {
      'count': _operationCounts[operationName] ?? 0,
      'average': Duration(milliseconds: durationMs.reduce((a, b) => a + b) ~/ durationMs.length),
      'min': Duration(milliseconds: durationMs.first),
      'max': Duration(milliseconds: durationMs.last),
      'p50': Duration(milliseconds: durationMs[durationMs.length ~/ 2]),
      'p95': Duration(milliseconds: durationMs[(durationMs.length * 0.95).toInt()]),
    };
  }

  /// Get all performance metrics
  Map<String, Map<String, dynamic>> getAllMetrics() {
    final metrics = <String, Map<String, dynamic>>{};
    for (final operationName in _operationDurations.keys) {
      metrics[operationName] = getOperationStats(operationName);
    }
    return metrics;
  }

  /// Log performance report
  void logPerformanceReport() {
    if (_operationDurations.isEmpty) {
      AppLogging.logInfo('No performance data collected yet', name: 'PerformanceMonitor');
      return;
    }

    final buffer = StringBuffer('Performance Report:\n');
    final metrics = getAllMetrics();

    for (final entry in metrics.entries) {
      final stats = entry.value;
      buffer.writeln('  ${entry.key}:');
      buffer.writeln('    Count: ${stats['count']}');
      buffer.writeln('    Average: ${stats['average']}');
      buffer.writeln('    Min: ${stats['min']}');
      buffer.writeln('    Max: ${stats['max']}');
      buffer.writeln('    P50: ${stats['p50']}');
      buffer.writeln('    P95: ${stats['p95']}');
    }

    AppLogging.logInfo(buffer.toString(), name: 'PerformanceMonitor');
  }

  /// Clear all metrics
  void clearMetrics() {
    _operationStartTimes.clear();
    _operationDurations.clear();
    _operationCounts.clear();
  }

  /// Get slow operations (>500ms average)
  List<String> getSlowOperations() {
    final slowOps = <String>[];
    for (final operationName in _operationDurations.keys) {
      final avg = getAverageDuration(operationName);
      if (avg != null && avg.inMilliseconds > 500) {
        slowOps.add(operationName);
      }
    }
    return slowOps;
  }
}

/// Mixin to add performance monitoring to any class
mixin PerformanceMonitored {
  final PerformanceMonitorService _perfMonitor = PerformanceMonitorService();

  Future<T> monitorAsync<T>(String operationName, Future<T> Function() operation) {
    return _perfMonitor.timeOperation(operationName, operation);
  }

  T monitorSync<T>(String operationName, T Function() operation) {
    return _perfMonitor.timeOperationSync(operationName, operation);
  }
}
