import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_logging_service.dart';

/// Advanced performance optimization and monitoring system
class PerformanceOptimizationService {
  static final PerformanceOptimizationService _instance = PerformanceOptimizationService._internal();
  factory PerformanceOptimizationService() => _instance;
  PerformanceOptimizationService._internal();

  final Map<String, PerformanceMetrics> _metrics = {};
  final Map<String, List<double>> _performanceHistory = {};
  final List<PerformanceAlert> _alerts = [];
  Timer? _monitoringTimer;
  Timer? _cleanupTimer;

  // Performance thresholds
  static const Duration frameTimeThreshold = Duration(milliseconds: 16); // 60 FPS
  static const Duration memoryWarningThreshold = Duration(milliseconds: 100);
  static const int maxMemoryUsageMB = 200;
  static const int maxHistorySize = 1000;

  // Optimization settings
  bool _adaptiveQualityEnabled = true;
  bool _memoryManagementEnabled = true;
  bool _animationOptimizationEnabled = true;
  double _currentQualityLevel = 1.0;

  void initialize() {
    _loadSettings();
    _startMonitoring();
    _startCleanup();
    AppLogging.logInfo('Performance optimization service initialized');
  }

  /// Monitor widget performance
  Widget monitorWidget(String name, Widget Function() builder) {
    final stopwatch = Stopwatch()..start();

    try {
      final widget = builder();
      stopwatch.stop();

      _recordMetrics(name, stopwatch.elapsedMicroseconds.toDouble());
      _checkPerformanceThresholds(name, stopwatch.elapsed);

      return widget;
    } catch (e, stackTrace) {
      stopwatch.stop();
      AppLogging.logError('Widget monitoring failed for $name', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Execute operation with performance monitoring
  Future<T> executeWithMonitoring<T>(String operationName, Future<T> Function() operation, {Duration? timeout, bool enableCaching = false, String? cacheKey}) async {
    final stopwatch = Stopwatch()..start();

    try {
      // Check cache first if enabled
      if (enableCaching && cacheKey != null) {
        final cached = _getCachedResult<T>(cacheKey);
        if (cached != null) {
          stopwatch.stop();
          _recordMetrics('${operationName}_cache_hit', stopwatch.elapsedMicroseconds.toDouble());
          return cached;
        }
      }

      // Execute with timeout if specified
      T result;
      if (timeout != null) {
        result = await operation().timeout(timeout);
      } else {
        result = await operation();
      }

      stopwatch.stop();

      // Cache result if enabled
      if (enableCaching && cacheKey != null) {
        _cacheResult(cacheKey, result);
      }

      _recordMetrics(operationName, stopwatch.elapsedMicroseconds.toDouble());
      _checkPerformanceThresholds(operationName, stopwatch.elapsed);

      return result;
    } catch (e, stackTrace) {
      stopwatch.stop();
      _recordMetrics('${operationName}_error', stopwatch.elapsedMicroseconds.toDouble());

      if (e is TimeoutException) {
        _addAlert(PerformanceAlert(type: AlertType.timeout, message: 'Operation $operationName timed out', severity: AlertSeverity.high, operation: operationName, duration: stopwatch.elapsed));
      }

      AppLogging.logError('Operation monitoring failed for $operationName', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Optimize memory usage
  void optimizeMemory({bool aggressive = false}) {
    if (!_memoryManagementEnabled) return;

    final stopwatch = Stopwatch()..start();

    try {
      // Force garbage collection
      if (!aggressive) {
        // Light cleanup
        _cleanupOldMetrics();
        _clearImageCache();
      } else {
        // Aggressive cleanup
        // System.gc() // Not available in Dart, would need platform-specific implementation
        _cleanupOldMetrics();
        _clearImageCache();
        _clearCaches();
        _trimPerformanceHistory();
      }

      stopwatch.stop();
      _recordMetrics('memory_optimization', stopwatch.elapsedMicroseconds.toDouble());

      AppLogging.logInfo('Memory optimization completed in ${stopwatch.elapsedMilliseconds}ms');
    } catch (e, stackTrace) {
      AppLogging.logError('Memory optimization failed', error: e, stackTrace: stackTrace);
    }
  }

  /// Adjust quality based on performance
  void adjustQualityBasedOnPerformance() {
    if (!_adaptiveQualityEnabled) return;

    final avgFrameTime = _getAverageFrameTime();
    final memoryUsage = _getCurrentMemoryUsage();

    double newQualityLevel = _currentQualityLevel;

    // Reduce quality if performance is poor
    if (avgFrameTime > frameTimeThreshold.inMicroseconds) {
      newQualityLevel = (newQualityLevel * 0.9).clamp(0.3, 1.0);
    }

    // Reduce quality if memory usage is high
    if (memoryUsage > maxMemoryUsageMB) {
      newQualityLevel = (newQualityLevel * 0.8).clamp(0.3, 1.0);
    }

    // Increase quality if performance is good
    if (avgFrameTime < frameTimeThreshold.inMicroseconds * 0.7 && memoryUsage < maxMemoryUsageMB * 0.7) {
      newQualityLevel = (newQualityLevel * 1.05).clamp(0.3, 1.0);
    }

    if (newQualityLevel != _currentQualityLevel) {
      _currentQualityLevel = newQualityLevel;
      _applyQualitySettings();
      AppLogging.logInfo('Quality level adjusted to ${(_currentQualityLevel * 100).toStringAsFixed(0)}%');
    }
  }

  /// Get performance recommendations
  List<PerformanceRecommendation> getRecommendations() {
    final recommendations = <PerformanceRecommendation>[];

    final avgFrameTime = _getAverageFrameTime();
    final memoryUsage = _getCurrentMemoryUsage();
    final metrics = _getPerformanceSummary();

    // Frame rate recommendations
    if (avgFrameTime > frameTimeThreshold.inMicroseconds) {
      recommendations.add(
        PerformanceRecommendation(
          type: RecommendationType.performance,
          title: 'Reduce Animation Complexity',
          description: 'Average frame time is ${avgFrameTime ~/ 1000}ms (target: ${frameTimeThreshold.inMilliseconds}ms)',
          priority: RecommendationPriority.high,
          action: () => _reduceAnimationComplexity(),
        ),
      );
    }

    // Memory recommendations
    if (memoryUsage > maxMemoryUsageMB) {
      recommendations.add(
        PerformanceRecommendation(
          type: RecommendationType.memory,
          title: 'Optimize Memory Usage',
          description: 'Memory usage is ${memoryUsage}MB (recommended: <${maxMemoryUsageMB}MB)',
          priority: RecommendationPriority.high,
          action: () => optimizeMemory(aggressive: true),
        ),
      );
    }

    // Cache recommendations
    if (metrics['cache_hit_rate'] < 0.5) {
      recommendations.add(
        PerformanceRecommendation(
          type: RecommendationType.caching,
          title: 'Improve Cache Strategy',
          description: 'Cache hit rate is ${(metrics['cache_hit_rate'] * 100).toStringAsFixed(1)}%',
          priority: RecommendationPriority.medium,
          action: () => _optimizeCacheStrategy(),
        ),
      );
    }

    return recommendations;
  }

  /// Get performance dashboard data
  Map<String, dynamic> getPerformanceDashboard() {
    return {
      'current_quality_level': _currentQualityLevel,
      'adaptive_quality_enabled': _adaptiveQualityEnabled,
      'memory_management_enabled': _memoryManagementEnabled,
      'animation_optimization_enabled': _animationOptimizationEnabled,
      'current_memory_usage': _getCurrentMemoryUsage(),
      'average_frame_time': _getAverageFrameTime(),
      'performance_summary': _getPerformanceSummary(),
      'recent_alerts': _alerts.take(10).toList(),
      'recommendations': getRecommendations(),
      'metrics_history': _getMetricsHistory(),
    };
  }

  /// Update optimization settings
  void updateSettings({bool? adaptiveQualityEnabled, bool? memoryManagementEnabled, bool? animationOptimizationEnabled, double? qualityLevel}) {
    if (adaptiveQualityEnabled != null) {
      _adaptiveQualityEnabled = adaptiveQualityEnabled;
    }
    if (memoryManagementEnabled != null) {
      _memoryManagementEnabled = memoryManagementEnabled;
    }
    if (animationOptimizationEnabled != null) {
      _animationOptimizationEnabled = animationOptimizationEnabled;
    }
    if (qualityLevel != null) {
      _currentQualityLevel = qualityLevel.clamp(0.3, 1.0);
      _applyQualitySettings();
    }

    _saveSettings();
  }

  void dispose() {
    _monitoringTimer?.cancel();
    _cleanupTimer?.cancel();
  }

  // Private methods

  void _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _adaptiveQualityEnabled = prefs.getBool('adaptive_quality_enabled') ?? true;
      _memoryManagementEnabled = prefs.getBool('memory_management_enabled') ?? true;
      _animationOptimizationEnabled = prefs.getBool('animation_optimization_enabled') ?? true;
      _currentQualityLevel = prefs.getDouble('quality_level') ?? 1.0;
    } catch (e) {
      AppLogging.logError('Failed to load performance settings', error: e);
    }
  }

  void _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('adaptive_quality_enabled', _adaptiveQualityEnabled);
      await prefs.setBool('memory_management_enabled', _memoryManagementEnabled);
      await prefs.setBool('animation_optimization_enabled', _animationOptimizationEnabled);
      await prefs.setDouble('quality_level', _currentQualityLevel);
    } catch (e) {
      AppLogging.logError('Failed to save performance settings', error: e);
    }
  }

  void _startMonitoring() {
    _monitoringTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _monitorSystemPerformance();
      adjustQualityBasedOnPerformance();
    });
  }

  void _startCleanup() {
    _cleanupTimer = Timer.periodic(const Duration(minutes: 10), (_) {
      optimizeMemory();
    });
  }

  void _monitorSystemPerformance() {
    final memoryUsage = _getCurrentMemoryUsage();

    if (memoryUsage > maxMemoryUsageMB) {
      _addAlert(PerformanceAlert(type: AlertType.memory, message: 'High memory usage: ${memoryUsage}MB', severity: AlertSeverity.medium, value: memoryUsage.toDouble()));
    }
  }

  void _recordMetrics(String operation, double durationMicroseconds) {
    _metrics.putIfAbsent(operation, () => PerformanceMetrics()).addMeasurement(durationMicroseconds);

    _performanceHistory.putIfAbsent(operation, () => []).add(durationMicroseconds);
    if (_performanceHistory[operation]!.length > maxHistorySize) {
      _performanceHistory[operation]!.removeAt(0);
    }
  }

  void _checkPerformanceThresholds(String operation, Duration duration) {
    if (duration > frameTimeThreshold) {
      _addAlert(PerformanceAlert(type: AlertType.performance, message: 'Slow operation: $operation took ${duration.inMilliseconds}ms', severity: AlertSeverity.low, operation: operation, duration: duration));
    }
  }

  void _addAlert(PerformanceAlert alert) {
    _alerts.add(alert);
    if (_alerts.length > 100) {
      _alerts.removeAt(0);
    }
  }

  double _getAverageFrameTime() {
    final frameTimes = _performanceHistory['frame_render'] ?? [];
    if (frameTimes.isEmpty) return frameTimeThreshold.inMicroseconds.toDouble();

    return frameTimes.reduce((a, b) => a + b) / frameTimes.length;
  }

  int _getCurrentMemoryUsage() {
    // Simplified memory calculation
    // In a real implementation, you'd use platform-specific APIs
    return 50; // Placeholder
  }

  Map<String, dynamic> _getPerformanceSummary() {
    final summary = <String, dynamic>{};

    for (final entry in _metrics.entries) {
      summary[entry.key] = {'average': entry.value.average, 'min': entry.value.min, 'max': entry.value.max, 'count': entry.value.count, 'recent_trend': entry.value.getRecentTrend()};
    }

    return summary;
  }

  Map<String, List<double>> _getMetricsHistory() {
    final history = <String, List<double>>{};

    for (final entry in _performanceHistory.entries) {
      history[entry.key] = entry.value.take(50).toList(); // Return last 50 measurements
    }

    return history;
  }

  void _applyQualitySettings() {
    // Apply quality settings to the application
    // This would involve adjusting animation durations, image quality, etc.
  }

  void _reduceAnimationComplexity() {
    if (_animationOptimizationEnabled) {
      // Reduce animation complexity
      _currentQualityLevel = (_currentQualityLevel * 0.8).clamp(0.3, 1.0);
      _applyQualitySettings();
    }
  }

  void _optimizeCacheStrategy() {
    // Optimize caching strategy
    _clearOldCacheEntries();
  }

  void _cleanupOldMetrics() {
    final cutoff = DateTime.now().subtract(const Duration(hours: 1));
    _metrics.removeWhere((key, metrics) => metrics.lastUpdate.isBefore(cutoff));
  }

  void _clearImageCache() {
    // Clear Flutter's image cache
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  void _clearCaches() {
    _performanceHistory.clear();
    _alerts.clear();
  }

  void _trimPerformanceHistory() {
    for (final list in _performanceHistory.values) {
      if (list.length > 100) {
        list.removeRange(0, list.length - 100);
      }
    }
  }

  void _clearOldCacheEntries() {
    // Clear old cache entries
    _cache.clear();
  }

  // Simple cache implementation
  final Map<String, CacheEntry> _cache = {};

  T? _getCachedResult<T>(String key) {
    final entry = _cache[key];
    if (entry == null || entry.isExpired) {
      _cache.remove(key);
      return null;
    }
    return entry.value as T?;
  }

  void _cacheResult<T>(String key, T value) {
    _cache[key] = CacheEntry(value: value, timestamp: DateTime.now());
  }
}

// Supporting classes

class PerformanceMetrics {
  final List<double> measurements = [];
  DateTime lastUpdate = DateTime.now();

  void addMeasurement(double measurement) {
    measurements.add(measurement);
    lastUpdate = DateTime.now();

    // Keep only last 100 measurements
    if (measurements.length > 100) {
      measurements.removeAt(0);
    }
  }

  double get average {
    if (measurements.isEmpty) return 0.0;
    return measurements.reduce((a, b) => a + b) / measurements.length;
  }

  double get min {
    if (measurements.isEmpty) return 0.0;
    return measurements.reduce((a, b) => a < b ? a : b);
  }

  double get max {
    if (measurements.isEmpty) return 0.0;
    return measurements.reduce((a, b) => a > b ? a : b);
  }

  int get count => measurements.length;

  double getRecentTrend() {
    if (measurements.length < 10) return 0.0;

    final recent = measurements.take(10).toList();
    final older = measurements.skip(10).take(10).toList();

    if (older.isEmpty) return 0.0;

    final recentAvg = recent.reduce((a, b) => a + b) / recent.length;
    final olderAvg = older.reduce((a, b) => a + b) / older.length;

    return (recentAvg - olderAvg) / olderAvg;
  }
}

class PerformanceAlert {
  final AlertType type;
  final String message;
  final AlertSeverity severity;
  final DateTime timestamp;
  final String? operation;
  final Duration? duration;
  final double? value;

  PerformanceAlert({required this.type, required this.message, required this.severity, this.operation, this.duration, this.value}) : timestamp = DateTime.now();
}

enum AlertType { performance, memory, timeout, error }

enum AlertSeverity { low, medium, high, critical }

class PerformanceRecommendation {
  final RecommendationType type;
  final String title;
  final String description;
  final RecommendationPriority priority;
  final VoidCallback action;

  PerformanceRecommendation({required this.type, required this.title, required this.description, required this.priority, required this.action});
}

enum RecommendationType { performance, memory, caching, network }

enum RecommendationPriority { low, medium, high }

class CacheEntry {
  final dynamic value;
  final DateTime timestamp;
  static const Duration maxAge = Duration(minutes: 5);

  CacheEntry({required this.value, required this.timestamp});

  bool get isExpired => DateTime.now().difference(timestamp) > maxAge;
}
