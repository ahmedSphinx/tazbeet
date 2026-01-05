import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'app_logging_service.dart';

/// Comprehensive logging and monitoring system
class LoggingMonitoringService {
  static final LoggingMonitoringService _instance = LoggingMonitoringService._internal();
  factory LoggingMonitoringService() => _instance;
  LoggingMonitoringService._internal();

  final List<LogEntry> _logs = [];
  final Map<String, PerformanceMetrics> _performanceMetrics = {};
  final Map<String, HealthMetrics> _healthMetrics = {};
  final List<SystemEvent> _systemEvents = [];

  Timer? _cleanupTimer;
  Timer? _metricsTimer;
  File? _logFile;

  // Configuration
  static const int maxLogEntries = 10000;
  static const Duration logRetentionPeriod = Duration(days: 7);
  static const Duration metricsCollectionInterval = Duration(seconds: 30);
  static const Duration cleanupInterval = Duration(hours: 1);
  static const int maxFileSizeBytes = 10 * 1024 * 1024; // 10MB

  // Log levels
  bool _enableDebugLogs = false;
  bool _enableInfoLogs = true;
  bool _enableWarningLogs = true;
  bool _enableErrorLogs = true;
  bool _enablePerformanceLogs = true;
  bool _enableSystemLogs = true;

  void initialize() async {
    await _initializeLogFile();
    _startMetricsCollection();
    _startCleanup();
    _collectSystemInfo();
    AppLogging.logInfo('Logging and monitoring service initialized');
  }

  /// Log a message with specified level
  void log(String message, {LogLevel level = LogLevel.info, String? category, Map<String, dynamic>? metadata, Object? error, StackTrace? stackTrace}) {
    if (!_shouldLog(level)) return;

    final entry = LogEntry(timestamp: DateTime.now(), level: level, message: message, category: category ?? 'General', metadata: metadata ?? {}, error: error?.toString(), stackTrace: stackTrace?.toString());

    _logs.add(entry);
    if (_logs.length > maxLogEntries) {
      _logs.removeAt(0);
    }

    _writeToFile(entry);
    _notifyLogListeners(entry);
  }

  /// Log debug message
  void debug(String message, {String? category, Map<String, dynamic>? metadata}) {
    log(message, level: LogLevel.debug, category: category, metadata: metadata);
  }

  /// Log info message
  void info(String message, {String? category, Map<String, dynamic>? metadata}) {
    log(message, level: LogLevel.info, category: category, metadata: metadata);
  }

  /// Log warning message
  void warning(String message, {String? category, Map<String, dynamic>? metadata, Object? error, StackTrace? stackTrace}) {
    log(message, level: LogLevel.warning, category: category, metadata: metadata, error: error, stackTrace: stackTrace);
  }

  /// Log error message
  void error(String message, {String? category, Map<String, dynamic>? metadata, Object? error, StackTrace? stackTrace}) {
    log(message, level: LogLevel.error, category: category, metadata: metadata, error: error, stackTrace: stackTrace);
  }

  /// Record performance metric
  void recordPerformanceMetric(String operation, Duration duration, {Map<String, dynamic>? metadata}) {
    if (!_enablePerformanceLogs) return;

    _performanceMetrics.putIfAbsent(operation, () => PerformanceMetrics(operation)).addMeasurement(duration, metadata);

    // Check for performance issues
    _checkPerformanceThresholds(operation, duration);
  }

  /// Record system health metric
  void recordHealthMetric(String component, double value, {String? unit, HealthStatus status = HealthStatus.unknown}) {
    _healthMetrics.putIfAbsent(component, () => HealthMetrics(component)).addMeasurement(value, unit: unit, status: status);

    // Check for health issues
    _checkHealthThresholds(component, value, status);
  }

  /// Record system event
  void recordSystemEvent(String eventType, {Map<String, dynamic>? data, String? description}) {
    final event = SystemEvent(timestamp: DateTime.now(), type: eventType, data: data ?? {}, description: description);

    _systemEvents.add(event);
    if (_systemEvents.length > 1000) {
      _systemEvents.removeAt(0);
    }

    if (_enableSystemLogs) {
      info('System event: $eventType', category: 'System', metadata: data);
    }
  }

  /// Get logs with filtering
  List<LogEntry> getLogs({LogLevel? minLevel, String? category, DateTime? startTime, DateTime? endTime, int? limit}) {
    var filteredLogs = _logs.where((entry) {
      if (minLevel != null && entry.level.index < minLevel.index) return false;
      if (category != null && entry.category != category) return false;
      if (startTime != null && entry.timestamp.isBefore(startTime)) return false;
      if (endTime != null && entry.timestamp.isAfter(endTime)) return false;
      return true;
    }).toList();

    filteredLogs.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (limit != null && filteredLogs.length > limit) {
      filteredLogs = filteredLogs.take(limit).toList();
    }

    return filteredLogs;
  }

  /// Get performance metrics
  Map<String, PerformanceMetrics> getPerformanceMetrics({String? operation}) {
    if (operation != null) {
      final metrics = _performanceMetrics[operation];
      return metrics != null ? {operation: metrics} : {};
    }
    return Map.from(_performanceMetrics);
  }

  /// Get health metrics
  Map<String, HealthMetrics> getHealthMetrics({String? component}) {
    if (component != null) {
      final metrics = _healthMetrics[component];
      return metrics != null ? {component: metrics} : {};
    }
    return Map.from(_healthMetrics);
  }

  /// Get system events
  List<SystemEvent> getSystemEvents({String? eventType, DateTime? since}) {
    var events = _systemEvents.where((event) {
      if (eventType != null && event.type != eventType) return false;
      if (since != null && event.timestamp.isBefore(since)) return false;
      return true;
    }).toList();

    events.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return events;
  }

  /// Get monitoring dashboard data
  Map<String, dynamic> getMonitoringDashboard() {
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));

    final recentLogs = _logs.where((log) => log.timestamp.isAfter(last24Hours)).toList();
    final recentErrors = recentLogs.where((log) => log.level == LogLevel.error).length;
    final recentWarnings = recentLogs.where((log) => log.level == LogLevel.warning).length;

    final performanceIssues = _getPerformanceIssues();
    final healthIssues = _getHealthIssues();

    return {
      'system_health': {'status': _calculateOverallHealthStatus(), 'errors_24h': recentErrors, 'warnings_24h': recentWarnings, 'performance_issues': performanceIssues.length, 'health_issues': healthIssues.length},
      'performance_summary': {
        'total_operations': _performanceMetrics.length,
        'average_response_time': _getAverageResponseTime(),
        'slowest_operations': _getSlowestOperations(),
        'performance_trends': _getPerformanceTrends(),
      },
      'health_summary': {
        'monitored_components': _healthMetrics.length,
        'healthy_components': _healthMetrics.values.where((m) => m.getCurrentStatus() == HealthStatus.healthy).length,
        'critical_components': _healthMetrics.values.where((m) => m.getCurrentStatus() == HealthStatus.critical).length,
        'health_trends': _getHealthTrends(),
      },
      'log_statistics': {'total_logs': _logs.length, 'logs_by_level': _getLogsByLevel(), 'logs_by_category': _getLogsByCategory(), 'recent_activity': _getRecentActivity()},
      'system_info': _getSystemInfo(),
    };
  }

  /// Export logs and metrics
  Future<Map<String, dynamic>> exportData({DateTime? startTime, DateTime? endTime}) async {
    final filteredLogs = startTime != null || endTime != null ? getLogs(startTime: startTime, endTime: endTime) : _logs;

    return {
      'export_timestamp': DateTime.now().toIso8601String(),
      'logs': filteredLogs.map((log) => log.toJson()).toList(),
      'performance_metrics': _performanceMetrics.map((k, v) => MapEntry(k, v.toJson())),
      'health_metrics': _healthMetrics.map((k, v) => MapEntry(k, v.toJson())),
      'system_events': _systemEvents.map((event) => event.toJson()).toList(),
      'system_info': _getSystemInfo(),
    };
  }

  /// Clear logs and metrics
  Future<void> clearData({bool clearLogs = true, bool clearMetrics = true, bool clearHealth = true, bool clearEvents = true}) async {
    if (clearLogs) {
      _logs.clear();
      await _clearLogFile();
    }
    if (clearMetrics) _performanceMetrics.clear();
    if (clearHealth) _healthMetrics.clear();
    if (clearEvents) _systemEvents.clear();

    AppLogging.logInfo('Monitoring data cleared');
  }

  /// Update logging configuration
  void updateConfiguration({bool? enableDebugLogs, bool? enableInfoLogs, bool? enableWarningLogs, bool? enableErrorLogs, bool? enablePerformanceLogs, bool? enableSystemLogs}) {
    if (enableDebugLogs != null) _enableDebugLogs = enableDebugLogs;
    if (enableInfoLogs != null) _enableInfoLogs = enableInfoLogs;
    if (enableWarningLogs != null) _enableWarningLogs = enableWarningLogs;
    if (enableErrorLogs != null) _enableErrorLogs = enableErrorLogs;
    if (enablePerformanceLogs != null) _enablePerformanceLogs = enablePerformanceLogs;
    if (enableSystemLogs != null) _enableSystemLogs = enableSystemLogs;
  }

  void dispose() {
    _cleanupTimer?.cancel();
    _metricsTimer?.cancel();
  }

  // Private methods

  Future<void> _initializeLogFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      _logFile = File('${directory.path}/app_logs.txt');

      if (!await _logFile!.exists()) {
        await _logFile!.create(recursive: true);
      }

      // Check file size and rotate if needed
      if (await _logFile!.length() > maxFileSizeBytes) {
        await _rotateLogFile();
      }
    } catch (e, stackTrace) {
      AppLogging.logError('Failed to initialize log file', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> _writeToFile(LogEntry entry) async {
    if (_logFile == null) return;

    try {
      final logLine = '${entry.toJson()}\n';
      await _logFile!.writeAsString(logLine, mode: FileMode.append);
    } catch (e, stackTrace) {
      AppLogging.logError('Failed to write to log file', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> _rotateLogFile() async {
    if (_logFile == null) return;

    try {
      final directory = _logFile!.parent;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final oldFile = File('${directory.path}/app_logs_$timestamp.txt');

      await _logFile!.rename(oldFile.path);
      await _logFile!.create();
    } catch (e, stackTrace) {
      AppLogging.logError('Failed to rotate log file', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> _clearLogFile() async {
    if (_logFile == null) return;

    try {
      await _logFile!.writeAsString('');
    } catch (e, stackTrace) {
      AppLogging.logError('Failed to clear log file', error: e, stackTrace: stackTrace);
    }
  }

  bool _shouldLog(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return _enableDebugLogs;
      case LogLevel.info:
        return _enableInfoLogs;
      case LogLevel.warning:
        return _enableWarningLogs;
      case LogLevel.error:
        return _enableErrorLogs;
    }
  }

  void _notifyLogListeners(LogEntry entry) {
    // Notify any listeners about new log entry
    // This could be used for real-time log monitoring
  }

  void _startMetricsCollection() {
    _metricsTimer = Timer.periodic(metricsCollectionInterval, (_) {
      _collectMetrics();
    });
  }

  void _startCleanup() {
    _cleanupTimer = Timer.periodic(cleanupInterval, (_) {
      _cleanupOldData();
    });
  }

  void _collectMetrics() {
    // Collect system performance metrics
    _collectSystemMetrics();

    // Collect application metrics
    _collectApplicationMetrics();
  }

  void _collectSystemInfo() async {
    try {
      // Simplified system info collection without device_info_plus
      recordSystemEvent('device_info', data: {'platform': Platform.operatingSystem, 'version': Platform.operatingSystemVersion});
    } catch (e, stackTrace) {
      AppLogging.logError('Failed to collect system info', error: e, stackTrace: stackTrace);
    }
  }

  void _collectSystemMetrics() {
    // Collect CPU, memory, and other system metrics
    // This would typically use platform-specific APIs
  }

  void _collectApplicationMetrics() {
    // Collect application-specific metrics
    recordHealthMetric('memory_usage', _getCurrentMemoryUsage().toDouble(), unit: 'MB');
    recordHealthMetric('active_connections', _getActiveConnections().toDouble(), unit: 'count');
  }

  double _getCurrentMemoryUsage() {
    // Simplified memory calculation
    return 50.0; // Placeholder
  }

  int _getActiveConnections() {
    // Simplified connection count
    return 1; // Placeholder
  }

  void _checkPerformanceThresholds(String operation, Duration duration) {
    final threshold = _getPerformanceThreshold(operation);
    if (duration > threshold) {
      recordSystemEvent('performance_warning', data: {'operation': operation, 'duration': duration.inMilliseconds, 'threshold': threshold.inMilliseconds}, description: 'Operation exceeded performance threshold');
    }
  }

  void _checkHealthThresholds(String component, double value, HealthStatus status) {
    if (status == HealthStatus.critical) {
      recordSystemEvent('health_critical', data: {'component': component, 'value': value, 'status': status.name}, description: 'Component health is critical');
    }
  }

  Duration _getPerformanceThreshold(String operation) {
    // Define performance thresholds for different operations
    switch (operation) {
      case 'database_query':
        return const Duration(milliseconds: 100);
      case 'network_request':
        return const Duration(seconds: 5);
      case 'ui_render':
        return const Duration(milliseconds: 16);
      default:
        return const Duration(milliseconds: 50);
    }
  }

  void _cleanupOldData() {
    final cutoff = DateTime.now().subtract(logRetentionPeriod);

    // Clean up old logs
    _logs.removeWhere((log) => log.timestamp.isBefore(cutoff));

    // Clean up old system events
    _systemEvents.removeWhere((event) => event.timestamp.isBefore(cutoff));

    // Clean up old metrics
    _performanceMetrics.forEach((key, metrics) {
      metrics.cleanupOldData();
    });

    _healthMetrics.forEach((key, metrics) {
      metrics.cleanupOldData();
    });
  }

  // Helper methods for dashboard data

  String _calculateOverallHealthStatus() {
    final errorCount = _logs.where((log) => log.level == LogLevel.error).length;
    final criticalHealthCount = _healthMetrics.values.where((m) => m.getCurrentStatus() == HealthStatus.critical).length;

    if (errorCount > 10 || criticalHealthCount > 0) return 'critical';
    if (errorCount > 5 || criticalHealthCount > 2) return 'warning';
    if (errorCount > 0) return 'caution';
    return 'healthy';
  }

  List<Map<String, dynamic>> _getPerformanceIssues() {
    final issues = <Map<String, dynamic>>[];

    for (final entry in _performanceMetrics.entries) {
      final metrics = entry.value;
      if (metrics.averageDuration > _getPerformanceThreshold(entry.key)) {
        issues.add({'operation': entry.key, 'average_duration': metrics.averageDuration.inMilliseconds, 'threshold': _getPerformanceThreshold(entry.key).inMilliseconds, 'issue_count': metrics.measurements.length});
      }
    }

    return issues;
  }

  List<Map<String, dynamic>> _getHealthIssues() {
    final issues = <Map<String, dynamic>>[];

    for (final entry in _healthMetrics.entries) {
      final metrics = entry.value;
      final status = metrics.getCurrentStatus();
      if (status == HealthStatus.critical || status == HealthStatus.warning) {
        issues.add({'component': entry.key, 'status': status.name, 'current_value': metrics.getCurrentValue(), 'unit': metrics.unit});
      }
    }

    return issues;
  }

  Duration _getAverageResponseTime() {
    if (_performanceMetrics.isEmpty) return Duration.zero;

    final totalDuration = _performanceMetrics.values.fold<Duration>(Duration.zero, (sum, metrics) => sum + metrics.averageDuration);

    return Duration(microseconds: totalDuration.inMicroseconds ~/ _performanceMetrics.length);
  }

  List<Map<String, dynamic>> _getSlowestOperations() {
    final operations = _performanceMetrics.entries
        .map(
          (entry) => {'operation': entry.key, 'average_duration': entry.value.averageDuration.inMilliseconds, 'max_duration': entry.value.maxDuration.inMilliseconds, 'measurement_count': entry.value.measurements.length},
        )
        .toList();

    operations.sort((a, b) => (b['average_duration'] as int).compareTo(a['average_duration'] as int));
    return operations.take(10).toList();
  }

  Map<String, dynamic> _getPerformanceTrends() {
    // Calculate performance trends over time
    return {'trend': 'stable'}; // Simplified
  }

  Map<String, dynamic> _getHealthTrends() {
    // Calculate health trends over time
    return {'trend': 'stable'}; // Simplified
  }

  Map<String, int> _getLogsByLevel() {
    final counts = <LogLevel, int>{};
    for (final log in _logs) {
      counts[log.level] = (counts[log.level] ?? 0) + 1;
    }
    return counts.map((k, v) => MapEntry(k.name, v));
  }

  Map<String, int> _getLogsByCategory() {
    final counts = <String, int>{};
    for (final log in _logs) {
      counts[log.category] = (counts[log.category] ?? 0) + 1;
    }
    return counts;
  }

  List<Map<String, dynamic>> _getRecentActivity() {
    final recent = _logs.take(20).map((log) => {'timestamp': log.timestamp.toIso8601String(), 'level': log.level.name, 'category': log.category, 'message': log.message.substring(0, 100)}).toList();

    return recent;
  }

  Map<String, dynamic> _getSystemInfo() {
    return {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'app_version': '1.0.0', // Would get from package info
      'start_time': DateTime.now().toIso8601String(),
    };
  }
}

// Supporting classes

enum LogLevel { debug, info, warning, error }

enum HealthStatus { healthy, warning, critical, unknown }

class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String category;
  final Map<String, dynamic> metadata;
  final String? error;
  final String? stackTrace;

  LogEntry({required this.timestamp, required this.level, required this.message, required this.category, required this.metadata, this.error, this.stackTrace});

  Map<String, dynamic> toJson() {
    return {'timestamp': timestamp.toIso8601String(), 'level': level.name, 'message': message, 'category': category, 'metadata': metadata, 'error': error, 'stackTrace': stackTrace};
  }
}

class PerformanceMetrics {
  final String operation;
  final List<PerformanceMeasurement> measurements = [];

  PerformanceMetrics(this.operation);

  Duration get averageDuration {
    if (measurements.isEmpty) return Duration.zero;
    final totalMicroseconds = measurements.fold<int>(0, (sum, m) => sum + m.duration.inMicroseconds);
    return Duration(microseconds: totalMicroseconds ~/ measurements.length);
  }

  Duration get maxDuration {
    if (measurements.isEmpty) return Duration.zero;
    return measurements.map((m) => m.duration).reduce((a, b) => a > b ? a : b);
  }

  Duration get minDuration {
    if (measurements.isEmpty) return Duration.zero;
    return measurements.map((m) => m.duration).reduce((a, b) => a < b ? a : b);
  }

  void addMeasurement(Duration duration, Map<String, dynamic>? metadata) {
    measurements.add(PerformanceMeasurement(timestamp: DateTime.now(), duration: duration, metadata: metadata ?? {}));

    // Keep only last 100 measurements
    if (measurements.length > 100) {
      measurements.removeAt(0);
    }
  }

  void cleanupOldData() {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    measurements.removeWhere((m) => m.timestamp.isBefore(cutoff));
  }

  Map<String, dynamic> toJson() {
    return {
      'operation': operation,
      'average_duration': averageDuration.inMilliseconds,
      'max_duration': maxDuration.inMilliseconds,
      'min_duration': minDuration.inMilliseconds,
      'measurement_count': measurements.length,
      'measurements': measurements.map((m) => m.toJson()).toList(),
    };
  }
}

class PerformanceMeasurement {
  final DateTime timestamp;
  final Duration duration;
  final Map<String, dynamic> metadata;

  PerformanceMeasurement({required this.timestamp, required this.duration, required this.metadata});

  Map<String, dynamic> toJson() {
    return {'timestamp': timestamp.toIso8601String(), 'duration': duration.inMilliseconds, 'metadata': metadata};
  }
}

class HealthMetrics {
  final String component;
  final List<HealthMeasurement> measurements = [];
  String? unit;

  HealthMetrics(this.component);

  double getCurrentValue() {
    if (measurements.isEmpty) return 0.0;
    return measurements.last.value;
  }

  HealthStatus getCurrentStatus() {
    if (measurements.isEmpty) return HealthStatus.unknown;
    return measurements.last.status;
  }

  void addMeasurement(double value, {String? unit, HealthStatus status = HealthStatus.unknown}) {
    this.unit = unit;
    measurements.add(HealthMeasurement(timestamp: DateTime.now(), value: value, status: status));

    // Keep only last 100 measurements
    if (measurements.length > 100) {
      measurements.removeAt(0);
    }
  }

  void cleanupOldData() {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    measurements.removeWhere((m) => m.timestamp.isBefore(cutoff));
  }

  Map<String, dynamic> toJson() {
    return {
      'component': component,
      'unit': unit,
      'current_value': getCurrentValue(),
      'current_status': getCurrentStatus().name,
      'measurement_count': measurements.length,
      'measurements': measurements.map((m) => m.toJson()).toList(),
    };
  }
}

class HealthMeasurement {
  final DateTime timestamp;
  final double value;
  final HealthStatus status;

  HealthMeasurement({required this.timestamp, required this.value, required this.status});

  Map<String, dynamic> toJson() {
    return {'timestamp': timestamp.toIso8601String(), 'value': value, 'status': status.name};
  }
}

class SystemEvent {
  final DateTime timestamp;
  final String type;
  final Map<String, dynamic> data;
  final String? description;

  SystemEvent({required this.timestamp, required this.type, required this.data, this.description});

  Map<String, dynamic> toJson() {
    return {'timestamp': timestamp.toIso8601String(), 'type': type, 'data': data, 'description': description};
  }
}
