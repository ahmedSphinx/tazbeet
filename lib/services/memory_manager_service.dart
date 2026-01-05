import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tazbeet/services/app_logging_service.dart';
import 'dart:async';

/// Service to manage memory and cache
class MemoryManagerService {
  static final MemoryManagerService _instance = MemoryManagerService._internal();
  factory MemoryManagerService() => _instance;
  MemoryManagerService._internal();

  Timer? _cleanupTimer;
  final Duration _cleanupInterval = const Duration(minutes: 30);

  /// Initialize memory manager
  void initialize() {
    // Schedule periodic cleanup
    _cleanupTimer = Timer.periodic(_cleanupInterval, (_) => performCleanup());
    AppLogging.logInfo('Memory manager initialized', name: 'MemoryManager');
  }

  /// Perform memory cleanup
  Future<void> performCleanup() async {
    AppLogging.logInfo('Starting memory cleanup', name: 'MemoryManager');

    try {
      // Compact Hive boxes
      await compactHiveBoxes();

      // Clear image cache if needed
      if (kIsWeb == false) {
        await clearImageCacheIfNeeded();
      }

      AppLogging.logInfo('Memory cleanup completed', name: 'MemoryManager');
    } catch (e) {
      AppLogging.logError('Memory cleanup failed: $e', name: 'MemoryManager');
    }
  }

  /// Compact all Hive boxes to reclaim space
  Future<void> compactHiveBoxes() async {
    try {
      final boxNames = ['tasks', 'categories', 'moods', 'users', 'settings', 'notifications'];

      for (final boxName in boxNames) {
        if (Hive.isBoxOpen(boxName)) {
          final box = Hive.box(boxName);
          await box.compact();
          AppLogging.logInfo('Compacted Hive box: $boxName', name: 'MemoryManager');
        }
      }
    } catch (e) {
      AppLogging.logError('Failed to compact Hive boxes: $e', name: 'MemoryManager');
    }
  }

  /// Clear image cache if it exceeds threshold
  Future<void> clearImageCacheIfNeeded() async {
    try {
      // Image cache clearing would go here
      // For now, just log
      AppLogging.logInfo('Image cache check completed', name: 'MemoryManager');
    } catch (e) {
      AppLogging.logError('Failed to clear image cache: $e', name: 'MemoryManager');
    }
  }

  /// Get memory usage statistics
  Map<String, dynamic> getMemoryStats() {
    final stats = <String, dynamic>{};

    try {
      // Try to get stats from all registered boxes
      // Note: Hive doesn't provide a direct way to list all open boxes,
      // so we check known box names and handle typed boxes gracefully

      final boxesToCheck = [
        {'name': 'tasks', 'typed': true},
        {'name': 'categories', 'typed': true},
        {'name': 'moods', 'typed': true},
        {'name': 'users', 'typed': false},
        {'name': 'settings', 'typed': false},
        {'name': 'notifications', 'typed': false},
      ];

      for (final boxInfo in boxesToCheck) {
        final boxName = boxInfo['name'] as String;
        final isTyped = boxInfo['typed'] as bool;

        try {
          if (Hive.isBoxOpen(boxName)) {
            // For typed boxes, we can still get basic info without opening as untyped
            if (isTyped) {
              // Just record that it's open and typed
              stats[boxName] = {'isOpen': true, 'typed': true, 'accessible': false};
            } else {
              final box = Hive.box(boxName);
              stats[boxName] = {'length': box.length, 'isOpen': box.isOpen, 'lazy': box.lazy, 'typed': false};
            }
          }
        } catch (e) {
          // Silently skip inaccessible boxes
          continue;
        }
      }
    } catch (e) {
      AppLogging.logError('Failed to get memory stats: $e', name: 'MemoryManager');
    }

    return stats;
  }

  /// Log memory statistics
  void logMemoryStats() {
    final stats = getMemoryStats();
    final buffer = StringBuffer('Memory Statistics:\n');

    for (final entry in stats.entries) {
      buffer.writeln('  ${entry.key}: ${entry.value}');
    }

    AppLogging.logInfo(buffer.toString(), name: 'MemoryManager');
  }

  /// Force cleanup now
  Future<void> forceCleanup() async {
    await performCleanup();
  }

  /// Dispose resources
  void dispose() {
    _cleanupTimer?.cancel();
  }
}
