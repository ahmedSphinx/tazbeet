import 'package:tazbeet/services/app_logging_service.dart';

/// Service to monitor code quality metrics
class CodeQualityMonitorService {
  static final CodeQualityMonitorService _instance = CodeQualityMonitorService._internal();
  factory CodeQualityMonitorService() => _instance;
  CodeQualityMonitorService._internal();

  final Map<String, int> _errorCounts = {};
  final Map<String, int> _warningCounts = {};
  final List<String> _recentErrors = [];
  final List<String> _recentWarnings = [];
  static const int _maxRecentItems = 100;

  /// Record an error
  void recordError(String error, {String? source}) {
    final key = source ?? 'unknown';
    _errorCounts[key] = (_errorCounts[key] ?? 0) + 1;

    _recentErrors.add('[$key] $error');
    if (_recentErrors.length > _maxRecentItems) {
      _recentErrors.removeAt(0);
    }
  }

  /// Record a warning
  void recordWarning(String warning, {String? source}) {
    final key = source ?? 'unknown';
    _warningCounts[key] = (_warningCounts[key] ?? 0) + 1;

    _recentWarnings.add('[$key] $warning');
    if (_recentWarnings.length > _maxRecentItems) {
      _recentWarnings.removeAt(0);
    }
  }

  /// Get error count by source
  int getErrorCount([String? source]) {
    if (source == null) {
      return _errorCounts.values.fold(0, (sum, count) => sum + count);
    }
    return _errorCounts[source] ?? 0;
  }

  /// Get warning count by source
  int getWarningCount([String? source]) {
    if (source == null) {
      return _warningCounts.values.fold(0, (sum, count) => sum + count);
    }
    return _warningCounts[source] ?? 0;
  }

  /// Get top error sources
  List<MapEntry<String, int>> getTopErrorSources({int limit = 10}) {
    final entries = _errorCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return entries.take(limit).toList();
  }

  /// Get top warning sources
  List<MapEntry<String, int>> getTopWarningSources({int limit = 10}) {
    final entries = _warningCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return entries.take(limit).toList();
  }

  /// Get quality score (0-100)
  double getQualityScore() {
    final totalErrors = getErrorCount();
    final totalWarnings = getWarningCount();

    // Simple scoring: start at 100, subtract points for errors/warnings
    double score = 100.0;
    score -= totalErrors * 5.0; // 5 points per error
    score -= totalWarnings * 1.0; // 1 point per warning

    return score.clamp(0.0, 100.0);
  }

  /// Get quality metrics
  Map<String, dynamic> getQualityMetrics() {
    return {
      'totalErrors': getErrorCount(),
      'totalWarnings': getWarningCount(),
      'qualityScore': getQualityScore(),
      'topErrorSources': getTopErrorSources(limit: 5),
      'topWarningSources': getTopWarningSources(limit: 5),
      'recentErrorsCount': _recentErrors.length,
      'recentWarningsCount': _recentWarnings.length,
    };
  }

  /// Log quality report
  void logQualityReport() {
    final metrics = getQualityMetrics();
    final buffer = StringBuffer('Code Quality Report:\n');

    buffer.writeln('  Quality Score: ${metrics['qualityScore']?.toStringAsFixed(1)}/100');
    buffer.writeln('  Total Errors: ${metrics['totalErrors']}');
    buffer.writeln('  Total Warnings: ${metrics['totalWarnings']}');

    buffer.writeln('\n  Top Error Sources:');
    for (final entry in metrics['topErrorSources'] as List<MapEntry<String, int>>) {
      buffer.writeln('    ${entry.key}: ${entry.value}');
    }

    buffer.writeln('\n  Top Warning Sources:');
    for (final entry in metrics['topWarningSources'] as List<MapEntry<String, int>>) {
      buffer.writeln('    ${entry.key}: ${entry.value}');
    }

    AppLogging.logInfo(buffer.toString(), name: 'CodeQualityMonitor');
  }

  /// Get recent errors
  List<String> getRecentErrors({int limit = 10}) {
    return _recentErrors.reversed.take(limit).toList();
  }

  /// Get recent warnings
  List<String> getRecentWarnings({int limit = 10}) {
    return _recentWarnings.reversed.take(limit).toList();
  }

  /// Clear all metrics
  void clearMetrics() {
    _errorCounts.clear();
    _warningCounts.clear();
    _recentErrors.clear();
    _recentWarnings.clear();
  }

  /// Check if quality is acceptable
  bool get isQualityAcceptable => getQualityScore() >= 70.0;

  /// Get health status
  String get healthStatus {
    final score = getQualityScore();
    if (score >= 90) return 'Excellent';
    if (score >= 70) return 'Good';
    if (score >= 50) return 'Fair';
    if (score >= 30) return 'Poor';
    return 'Critical';
  }
}
