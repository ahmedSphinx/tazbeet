import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'app_logging_service.dart';

/// Comprehensive error handling and resilience system
class ErrorHandlingService {
  static final ErrorHandlingService _instance = ErrorHandlingService._internal();
  factory ErrorHandlingService() => _instance;
  ErrorHandlingService._internal();

  final Map<String, int> _errorCounts = {};
  final Map<String, DateTime> _lastErrorTime = {};
  final Map<String, List<StackTrace>> _errorStackTraces = {};
  final List<ErrorReport> _recentErrors = [];
  Timer? _cleanupTimer;

  // Error thresholds
  static const int maxErrorCount = 10;
  static const Duration errorWindow = Duration(minutes: 5);
  static const Duration stackTraceRetention = Duration(hours: 24);
  static const int maxRecentErrors = 100;

  void initialize() {
    _cleanupTimer = Timer.periodic(const Duration(hours: 1), (_) => _cleanupOldData());
    AppLogging.logInfo('Error handling service initialized');
  }

  /// Handle an error with context and recovery options
  Future<ErrorHandlingResult> handleError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
    ErrorSeverity severity = ErrorSeverity.medium,
    Map<String, dynamic>? metadata,
    bool showDialog = false,
    BuildContext? buildContext,
    List<ErrorRecoveryAction>? recoveryActions,
  }) async {
    final errorKey = _generateErrorKey(error, context);
    final now = DateTime.now();

    // Track error count
    _errorCounts[errorKey] = (_errorCounts[errorKey] ?? 0) + 1;
    _lastErrorTime[errorKey] = now;

    // Store stack trace
    if (stackTrace != null) {
      _errorStackTraces.putIfAbsent(errorKey, () => []).add(stackTrace);
      if (_errorStackTraces[errorKey]!.length > 10) {
        _errorStackTraces[errorKey]!.removeAt(0);
      }
    }

    // Create error report
    final errorReport = ErrorReport(error: error, stackTrace: stackTrace, context: context, severity: severity, timestamp: now, metadata: metadata, errorCount: _errorCounts[errorKey]!);

    _recentErrors.add(errorReport);
    if (_recentErrors.length > maxRecentErrors) {
      _recentErrors.removeAt(0);
    }

    // Log error
    _logError(errorReport);

    // Check if error threshold exceeded
    if (_errorCounts[errorKey]! >= maxErrorCount) {
      await _handleErrorThresholdExceeded(errorKey, errorReport);
    }

    // Show dialog if requested
    if (showDialog && buildContext != null) {
      await _showErrorDialog(buildContext, errorReport, recoveryActions);
    }

    // Determine handling result
    return _determineHandlingResult(errorReport);
  }

  /// Execute operation with error handling and retry logic
  Future<T> executeWithErrorHandling<T>(
    Future<T> Function() operation, {
    String? context,
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 1),
    bool exponentialBackoff = true,
    List<ErrorType>? retryableErrors,
  }) async {
    int attempts = 0;
    dynamic lastError;
    StackTrace? lastStackTrace;

    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (error, stackTrace) {
        attempts++;
        lastError = error;
        lastStackTrace = stackTrace;

        final errorType = _classifyError(error);

        // Don't retry if error is not retryable
        if (retryableErrors != null && !retryableErrors.contains(errorType)) {
          await handleError(error, stackTrace, context: context, severity: ErrorSeverity.high, metadata: {'attempts': attempts, 'maxRetries': maxRetries});
          rethrow;
        }

        // Log retry attempt
        AppLogging.logWarning('Operation failed, retrying...', name: context ?? 'ErrorHandlingService', error: error, stackTrace: stackTrace);

        if (attempts >= maxRetries) {
          break;
        }

        // Calculate delay
        final delay = exponentialBackoff ? retryDelay * Duration(milliseconds: (1 << (attempts - 1) * 500)).inMilliseconds : retryDelay;

        await Future.delayed(delay);
      }
    }

    // All retries exhausted
    await handleError(lastError, lastStackTrace, context: context, severity: ErrorSeverity.critical, metadata: {'attempts': attempts, 'maxRetries': maxRetries});
    throw lastError;
  }

  /// Validate data and throw appropriate errors
  void validateData(dynamic data, List<ValidationRule> rules, {String? context}) {
    for (final rule in rules) {
      if (!rule.validate(data)) {
        throw ValidationError(rule.message ?? 'Validation failed', context: context, rule: rule, data: data);
      }
    }
  }

  /// Check system health and return status
  SystemHealthStatus checkSystemHealth() {
    final now = DateTime.now();
    final recentErrors = _recentErrors.where((e) => now.difference(e.timestamp) < const Duration(minutes: 30)).toList();

    final criticalErrors = recentErrors.where((e) => e.severity == ErrorSeverity.critical).length;
    final highErrors = recentErrors.where((e) => e.severity == ErrorSeverity.high).length;
    final mediumErrors = recentErrors.where((e) => e.severity == ErrorSeverity.medium).length;

    // Check for error storms
    final errorStorms = _detectErrorStorms(recentErrors);

    HealthLevel healthLevel;
    if (criticalErrors > 0 || errorStorms.isNotEmpty) {
      healthLevel = HealthLevel.critical;
    } else if (highErrors > 5 || mediumErrors > 10) {
      healthLevel = HealthLevel.warning;
    } else if (highErrors > 0 || mediumErrors > 3) {
      healthLevel = HealthLevel.caution;
    } else {
      healthLevel = HealthLevel.healthy;
    }

    return SystemHealthStatus(level: healthLevel, recentErrorCount: recentErrors.length, criticalErrors: criticalErrors, highErrors: highErrors, mediumErrors: mediumErrors, errorStorms: errorStorms, timestamp: now);
  }

  /// Get error statistics
  Map<String, dynamic> getErrorStatistics() {
    return {
      'totalErrors': _errorCounts.values.fold(0, (sum, count) => sum + count),
      'uniqueErrors': _errorCounts.length,
      'recentErrors': _recentErrors.length,
      'errorsByType': _groupErrorsByType(),
      'errorsByContext': _groupErrorsByContext(),
      'mostFrequentErrors': _getMostFrequentErrors(),
      'errorTrends': _getErrorTrends(),
    };
  }

  /// Clear error history
  void clearErrorHistory() {
    _errorCounts.clear();
    _lastErrorTime.clear();
    _errorStackTraces.clear();
    _recentErrors.clear();
    AppLogging.logInfo('Error history cleared');
  }

  void dispose() {
    _cleanupTimer?.cancel();
  }

  // Private methods

  String _generateErrorKey(dynamic error, String? context) {
    final errorType = error.runtimeType.toString();
    final contextStr = context ?? 'unknown';
    final errorMessage = error.toString().substring(0, 50);
    return '${errorType}_${contextStr}_${errorMessage.hashCode}';
  }

  void _logError(ErrorReport report) {
    final message = '[${report.severity.name.toUpperCase()}] ${report.context ?? 'Unknown'}: ${report.error}';

    switch (report.severity) {
      case ErrorSeverity.low:
        AppLogging.logInfo(message);
        break;
      case ErrorSeverity.medium:
        AppLogging.logWarning(message, error: report.error, stackTrace: report.stackTrace);
        break;
      case ErrorSeverity.high:
        AppLogging.logError(message, error: report.error, stackTrace: report.stackTrace);
        break;
      case ErrorSeverity.critical:
        AppLogging.logError('🚨 CRITICAL: $message', error: report.error, stackTrace: report.stackTrace);
        break;
    }
  }

  Future<void> _handleErrorThresholdExceeded(String errorKey, ErrorReport report) async {
    AppLogging.logError('Error threshold exceeded for $errorKey: ${_errorCounts[errorKey]} errors', error: report.error, stackTrace: report.stackTrace);

    // Implement circuit breaker pattern
    // Could disable certain features, switch to fallback mode, etc.
  }

  Future<void> _showErrorDialog(BuildContext context, ErrorReport errorReport, List<ErrorRecoveryAction>? recoveryActions) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ErrorDialog(errorReport: errorReport, recoveryActions: recoveryActions ?? _getDefaultRecoveryActions(errorReport)),
    );
  }

  ErrorHandlingResult _determineHandlingResult(ErrorReport report) {
    switch (report.severity) {
      case ErrorSeverity.low:
        return ErrorHandlingResult.handled;
      case ErrorSeverity.medium:
        return ErrorHandlingResult.handledWithWarning;
      case ErrorSeverity.high:
        return ErrorHandlingResult.requiresAttention;
      case ErrorSeverity.critical:
        return ErrorHandlingResult.requiresIntervention;
    }
  }

  ErrorType _classifyError(dynamic error) {
    if (error is SocketException) return ErrorType.network;
    if (error is TimeoutException) return ErrorType.timeout;
    if (error is FileSystemException) return ErrorType.fileSystem;
    if (error is FormatException) return ErrorType.parsing;
    if (error is ValidationError) return ErrorType.validation;
    if (error is StateError) return ErrorType.state;
    if (error is RangeError) return ErrorType.range;
    if (error is ArgumentError) return ErrorType.argument;
    return ErrorType.unknown;
  }

  void _cleanupOldData() {
    final now = DateTime.now();
    final cutoffTime = now.subtract(stackTraceRetention);

    // Clean up old error counts
    _errorCounts.removeWhere((key, value) {
      final lastTime = _lastErrorTime[key];
      return lastTime != null && lastTime.isBefore(cutoffTime);
    });

    // Clean up old stack traces
    _errorStackTraces.forEach((key, traces) {
      traces.removeWhere((trace) => false); // Stack traces don't have timestamps, keep recent ones
    });
  }

  List<ErrorStorm> _detectErrorStorms(List<ErrorReport> errors) {
    final storms = <ErrorStorm>[];

    // Group errors by minute
    final errorsByMinute = <DateTime, List<ErrorReport>>{};
    for (final error in errors) {
      final minute = DateTime(error.timestamp.year, error.timestamp.month, error.timestamp.day, error.timestamp.hour, error.timestamp.minute);
      errorsByMinute.putIfAbsent(minute, () => []).add(error);
    }

    // Detect storms (more than 5 errors in a minute)
    for (final entry in errorsByMinute.entries) {
      if (entry.value.length > 5) {
        storms.add(ErrorStorm(timestamp: entry.key, errorCount: entry.value.length, errors: entry.value));
      }
    }

    return storms;
  }

  Map<String, int> _groupErrorsByType() {
    final grouped = <String, int>{};
    for (final error in _recentErrors) {
      final type = error.error.runtimeType.toString();
      grouped[type] = (grouped[type] ?? 0) + 1;
    }
    return grouped;
  }

  Map<String, int> _groupErrorsByContext() {
    final grouped = <String, int>{};
    for (final error in _recentErrors) {
      final context = error.context ?? 'unknown';
      grouped[context] = (grouped[context] ?? 0) + 1;
    }
    return grouped;
  }

  List<Map<String, dynamic>> _getMostFrequentErrors() {
    final sorted = _errorCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(10).map((entry) => {'key': entry.key, 'count': entry.value, 'lastSeen': _lastErrorTime[entry.key]?.toIso8601String()}).toList();
  }

  Map<String, dynamic> _getErrorTrends() {
    final now = DateTime.now();
    final hourly = <int, int>{};

    for (int i = 0; i < 24; i++) {
      final hour = now.subtract(Duration(hours: i)).hour;
      hourly[hour] = 0;
    }

    for (final error in _recentErrors) {
      final hour = error.timestamp.hour;
      hourly[hour] = (hourly[hour] ?? 0) + 1;
    }

    return {'hourly': hourly};
  }

  List<ErrorRecoveryAction> _getDefaultRecoveryActions(ErrorReport report) {
    return [
      ErrorRecoveryAction(
        title: 'Retry',
        action: () {
          // Default retry logic
        },
      ),
      ErrorRecoveryAction(
        title: 'Report Issue',
        action: () {
          // Report to analytics
        },
      ),
      ErrorRecoveryAction(title: 'Ignore', action: () {}),
    ];
  }
}

// Supporting classes

enum ErrorSeverity { low, medium, high, critical }

enum ErrorType { network, timeout, fileSystem, parsing, validation, state, range, argument, unknown }

enum HealthLevel { healthy, caution, warning, critical }

enum ErrorHandlingResult { handled, handledWithWarning, requiresAttention, requiresIntervention }

class ErrorReport {
  final dynamic error;
  final StackTrace? stackTrace;
  final String? context;
  final ErrorSeverity severity;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  final int errorCount;

  ErrorReport({required this.error, this.stackTrace, this.context, required this.severity, required this.timestamp, this.metadata, required this.errorCount});

  Map<String, dynamic> toJson() {
    return {'error': error.toString(), 'stackTrace': stackTrace?.toString(), 'context': context, 'severity': severity.name, 'timestamp': timestamp.toIso8601String(), 'metadata': metadata, 'errorCount': errorCount};
  }
}

class ValidationError extends Error {
  final String? context;
  final ValidationRule? rule;
  final dynamic data;

  ValidationError(String message, {this.context, this.rule, this.data});
}

class ValidationRule {
  final String? message;
  final bool Function(dynamic) validate;

  ValidationRule(this.validate, {this.message});
}

class ErrorRecoveryAction {
  final String title;
  final VoidCallback action;

  ErrorRecoveryAction({required this.title, required this.action});
}

class ErrorDialog extends StatelessWidget {
  final ErrorReport errorReport;
  final List<ErrorRecoveryAction> recoveryActions;

  const ErrorDialog({super.key, required this.errorReport, required this.recoveryActions});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error: ${errorReport.context ?? 'Unknown'}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Severity: ${errorReport.severity.name}'),
          const SizedBox(height: 8),
          Text(errorReport.error.toString()),
          if (errorReport.errorCount > 1) ...[const SizedBox(height: 8), Text('This error has occurred ${errorReport.errorCount} times')],
        ],
      ),
      actions: recoveryActions
          .map(
            (action) => TextButton(
              onPressed: () {
                action.action();
                Navigator.of(context).pop();
              },
              child: Text(action.title),
            ),
          )
          .toList(),
    );
  }
}

class SystemHealthStatus {
  final HealthLevel level;
  final int recentErrorCount;
  final int criticalErrors;
  final int highErrors;
  final int mediumErrors;
  final List<ErrorStorm> errorStorms;
  final DateTime timestamp;

  SystemHealthStatus({required this.level, required this.recentErrorCount, required this.criticalErrors, required this.highErrors, required this.mediumErrors, required this.errorStorms, required this.timestamp});
}

class ErrorStorm {
  final DateTime timestamp;
  final int errorCount;
  final List<ErrorReport> errors;

  ErrorStorm({required this.timestamp, required this.errorCount, required this.errors});
}
