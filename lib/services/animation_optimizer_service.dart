import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tazbeet/services/app_logging_service.dart';

/// Service to optimize animations based on device performance
class AnimationOptimizerService {
  static final AnimationOptimizerService _instance = AnimationOptimizerService._internal();
  factory AnimationOptimizerService() => _instance;
  AnimationOptimizerService._internal();

  bool _isLowEndDevice = false;
  bool _reduceAnimations = false;
  final List<Duration> _frameTimes = [];
  static const int _frameTimesSampleSize = 60; // 1 second at 60fps

  /// Initialize animation optimizer
  void initialize() {
    _detectDevicePerformance();
    _startFrameMonitoring();
    AppLogging.logInfo('Animation optimizer initialized', name: 'AnimationOptimizer');
  }

  /// Detect if device is low-end
  void _detectDevicePerformance() {
    // Simple heuristic: if we're in release mode and not on web
    _isLowEndDevice = kReleaseMode && !kIsWeb;
    AppLogging.logInfo('Device performance: ${_isLowEndDevice ? "Low-end" : "High-end"}', name: 'AnimationOptimizer');
  }

  /// Start monitoring frame times
  void _startFrameMonitoring() {
    SchedulerBinding.instance.addTimingsCallback((timings) {
      for (final timing in timings) {
        final frameDuration = timing.totalSpan;
        _frameTimes.add(frameDuration);

        // Keep only recent samples
        if (_frameTimes.length > _frameTimesSampleSize) {
          _frameTimes.removeAt(0);
        }
      }

      // Check if we should reduce animations
      _checkFramePerformance();
    });
  }

  /// Check frame performance and adjust settings
  void _checkFramePerformance() {
    if (_frameTimes.length < _frameTimesSampleSize) return;

    final avgFrameTime = _frameTimes.fold<Duration>(Duration.zero, (sum, duration) => sum + duration) ~/ _frameTimes.length;

    // If average frame time > 16.67ms (60fps), reduce animations
    final shouldReduce = avgFrameTime.inMicroseconds > 16670;

    if (shouldReduce != _reduceAnimations) {
      _reduceAnimations = shouldReduce;
      AppLogging.logInfo('Animation settings changed: ${_reduceAnimations ? "Reduced" : "Normal"}', name: 'AnimationOptimizer');
    }
  }

  /// Get recommended animation duration
  Duration getAnimationDuration(Duration defaultDuration) {
    if (_reduceAnimations) {
      return defaultDuration ~/ 2; // Half speed
    }
    return defaultDuration;
  }

  /// Should use simple animations
  bool get shouldUseSimpleAnimations => _reduceAnimations || _isLowEndDevice;

  /// Should skip animations
  bool get shouldSkipAnimations => _reduceAnimations && _isLowEndDevice;

  /// Get animation curve based on performance
  Curve get recommendedCurve {
    if (shouldSkipAnimations) {
      return Curves.linear;
    }
    if (shouldUseSimpleAnimations) {
      return Curves.easeInOut;
    }
    return Curves.easeInOutCubic;
  }

  /// Get current FPS
  double get currentFPS {
    if (_frameTimes.isEmpty) return 60.0;

    final avgFrameTime = _frameTimes.fold<Duration>(Duration.zero, (sum, duration) => sum + duration) ~/ _frameTimes.length;

    return 1000000.0 / avgFrameTime.inMicroseconds;
  }

  /// Get performance stats
  Map<String, dynamic> getPerformanceStats() {
    return {'isLowEndDevice': _isLowEndDevice, 'reduceAnimations': _reduceAnimations, 'currentFPS': currentFPS, 'shouldUseSimpleAnimations': shouldUseSimpleAnimations, 'shouldSkipAnimations': shouldSkipAnimations};
  }

  /// Log performance stats
  void logPerformanceStats() {
    final stats = getPerformanceStats();
    AppLogging.logInfo(
      'Animation Performance:\n'
      '  Low-end device: ${stats['isLowEndDevice']}\n'
      '  Reduce animations: ${stats['reduceAnimations']}\n'
      '  Current FPS: ${stats['currentFPS']?.toStringAsFixed(1)}\n'
      '  Simple animations: ${stats['shouldUseSimpleAnimations']}\n'
      '  Skip animations: ${stats['shouldSkipAnimations']}',
      name: 'AnimationOptimizer',
    );
  }
}
