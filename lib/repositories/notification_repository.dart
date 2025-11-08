import 'package:hive_flutter/hive_flutter.dart';
import 'package:tazbeet/services/app_logging.dart';
import '../models/notification_item.dart';
import '../models/notification_preferences.dart';

/// Repository for managing notification history and preferences with Hive
class NotificationRepository {
  static final NotificationRepository _instance = NotificationRepository._internal();
  factory NotificationRepository() => _instance;
  NotificationRepository._internal();

  static const String _notificationHistoryBox = 'notification_history';
  static const String _notificationPreferencesBox = 'notification_preferences';
  static const String _preferencesKey = 'preferences';

  Box<NotificationItem>? _historyBox;
  Box<NotificationPreferences>? _preferencesBox;

  /// Initialize the repository and open Hive boxes
  Future<void> init() async {
    try {
      _historyBox = await Hive.openBox<NotificationItem>(_notificationHistoryBox);
      _preferencesBox = await Hive.openBox<NotificationPreferences>(_notificationPreferencesBox);

      // Initialize with default preferences if none exist
      if (_preferencesBox!.isEmpty) {
        await savePreferences(NotificationPreferences.getDefaults());
      }

      AppLogging.logInfo('NotificationRepository initialized successfully', name: 'NotificationRepository');
    } catch (e) {
      AppLogging.logError('Failed to initialize NotificationRepository: $e', name: 'NotificationRepository');
      rethrow;
    }
  }

  /// Save a notification to history
  Future<void> saveNotification(NotificationItem notification) async {
    try {
      await _historyBox?.put(notification.id, notification);
      AppLogging.logInfo('Saved notification: ${notification.id}', name: 'NotificationRepository');
    } catch (e) {
      AppLogging.logError('Failed to save notification: $e', name: 'NotificationRepository');
    }
  }

  /// Update an existing notification
  Future<void> updateNotification(NotificationItem notification) async {
    try {
      await _historyBox?.put(notification.id, notification);
      AppLogging.logInfo('Updated notification: ${notification.id}', name: 'NotificationRepository');
    } catch (e) {
      AppLogging.logError('Failed to update notification: $e', name: 'NotificationRepository');
    }
  }

  /// Get a notification by ID
  NotificationItem? getNotification(String id) {
    try {
      return _historyBox?.get(id);
    } catch (e) {
      AppLogging.logError('Failed to get notification: $e', name: 'NotificationRepository');
      return null;
    }
  }

  /// Get all notifications
  List<NotificationItem> getAllNotifications() {
    try {
      return _historyBox?.values.toList() ?? [];
    } catch (e) {
      AppLogging.logError('Failed to get all notifications: $e', name: 'NotificationRepository');
      return [];
    }
  }

  /// Get notifications by type
  List<NotificationItem> getNotificationsByType(NotificationType type) {
    try {
      return _historyBox?.values.where((n) => n.type == type).toList() ?? [];
    } catch (e) {
      AppLogging.logError('Failed to get notifications by type: $e', name: 'NotificationRepository');
      return [];
    }
  }

  /// Get notifications by status
  List<NotificationItem> getNotificationsByStatus(NotificationDeliveryStatus status) {
    try {
      return _historyBox?.values.where((n) => n.status == status).toList() ?? [];
    } catch (e) {
      AppLogging.logError('Failed to get notifications by status: $e', name: 'NotificationRepository');
      return [];
    }
  }

  /// Get notifications within a date range
  List<NotificationItem> getNotificationsByDateRange(DateTime start, DateTime end) {
    try {
      return _historyBox?.values.where((n) {
            final date = n.deliveredAt ?? n.createdAt;
            return date.isAfter(start) && date.isBefore(end);
          }).toList() ??
          [];
    } catch (e) {
      AppLogging.logError('Failed to get notifications by date range: $e', name: 'NotificationRepository');
      return [];
    }
  }

  /// Get recent notifications (last N days)
  List<NotificationItem> getRecentNotifications({int days = 7}) {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: days));
      return getNotificationsByDateRange(cutoffDate, DateTime.now());
    } catch (e) {
      AppLogging.logError('Failed to get recent notifications: $e', name: 'NotificationRepository');
      return [];
    }
  }

  /// Get notifications that need retry
  List<NotificationItem> getNotificationsNeedingRetry() {
    try {
      return _historyBox?.values.where((n) => n.needsRetry).toList() ?? [];
    } catch (e) {
      AppLogging.logError('Failed to get notifications needing retry: $e', name: 'NotificationRepository');
      return [];
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(String id) async {
    try {
      await _historyBox?.delete(id);
      AppLogging.logInfo('Deleted notification: $id', name: 'NotificationRepository');
    } catch (e) {
      AppLogging.logError('Failed to delete notification: $e', name: 'NotificationRepository');
    }
  }

  /// Clear all notification history
  Future<void> clearAllHistory() async {
    try {
      await _historyBox?.clear();
      AppLogging.logInfo('Cleared all notification history', name: 'NotificationRepository');
    } catch (e) {
      AppLogging.logError('Failed to clear notification history: $e', name: 'NotificationRepository');
    }
  }

  /// Clear old notifications (older than N days)
  Future<void> clearOldHistory({int daysToKeep = 30}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
      final notifications = getAllNotifications();
      int deletedCount = 0;

      for (final notification in notifications) {
        final date = notification.deliveredAt ?? notification.createdAt;
        if (date.isBefore(cutoffDate)) {
          await deleteNotification(notification.id);
          deletedCount++;
        }
      }

      AppLogging.logInfo('Cleared $deletedCount old notifications (older than $daysToKeep days)', name: 'NotificationRepository');
    } catch (e) {
      AppLogging.logError('Failed to clear old notifications: $e', name: 'NotificationRepository');
    }
  }

  /// Get notification preferences
  NotificationPreferences getPreferences() {
    try {
      return _preferencesBox?.get(_preferencesKey) ?? NotificationPreferences.getDefaults();
    } catch (e) {
      AppLogging.logError('Failed to get preferences: $e', name: 'NotificationRepository');
      return NotificationPreferences.getDefaults();
    }
  }

  /// Save notification preferences
  Future<void> savePreferences(NotificationPreferences preferences) async {
    try {
      await _preferencesBox?.put(_preferencesKey, preferences);
      AppLogging.logInfo('Saved notification preferences', name: 'NotificationRepository');
    } catch (e) {
      AppLogging.logError('Failed to save preferences: $e', name: 'NotificationRepository');
    }
  }

  /// Update type-specific preferences
  Future<void> updateTypePreferences(NotificationTypePreferences typePreferences) async {
    try {
      final currentPrefs = getPreferences();
      final updatedTypePrefs = List<NotificationTypePreferences>.from(currentPrefs.typePreferences);

      // Find and update the type preferences, or add if not exists
      final index = updatedTypePrefs.indexWhere((p) => p.type == typePreferences.type);
      if (index >= 0) {
        updatedTypePrefs[index] = typePreferences;
      } else {
        updatedTypePrefs.add(typePreferences);
      }

      await savePreferences(currentPrefs.copyWith(typePreferences: updatedTypePrefs));
      AppLogging.logInfo('Updated preferences for type: ${typePreferences.type}', name: 'NotificationRepository');
    } catch (e) {
      AppLogging.logError('Failed to update type preferences: $e', name: 'NotificationRepository');
    }
  }

  // Analytics methods

  /// Get notification statistics
  Map<String, dynamic> getStatistics({int days = 7}) {
    try {
      final notifications = getRecentNotifications(days: days);

      if (notifications.isEmpty) {
        return {
          'totalSent': 0,
          'totalDelivered': 0,
          'totalOpened': 0,
          'totalDismissed': 0,
          'totalSnoozed': 0,
          'totalCompleted': 0,
          'totalFailed': 0,
          'deliveryRate': 0.0,
          'openRate': 0.0,
          'actionRate': 0.0,
          'averageResponseTime': Duration.zero,
          'byType': {},
        };
      }

      final totalSent = notifications.length;
      final totalDelivered = notifications.where((n) => n.status == NotificationDeliveryStatus.delivered).length;
      final totalOpened = notifications.where((n) => n.action == NotificationAction.opened).length;
      final totalDismissed = notifications.where((n) => n.action == NotificationAction.dismissed).length;
      final totalSnoozed = notifications.where((n) => n.action == NotificationAction.snoozed).length;
      final totalCompleted = notifications.where((n) => n.action == NotificationAction.completed).length;
      final totalFailed = notifications.where((n) => n.status == NotificationDeliveryStatus.failed).length;

      final deliveryRate = totalSent > 0 ? totalDelivered / totalSent : 0.0;
      final openRate = totalDelivered > 0 ? totalOpened / totalDelivered : 0.0;
      final actionRate = totalDelivered > 0 ? (totalCompleted + totalSnoozed) / totalDelivered : 0.0;

      // Calculate average response time
      final responseTimes = notifications.where((n) => n.responseTime != null).map((n) => n.responseTime!.inSeconds).toList();
      final avgResponseTime = responseTimes.isNotEmpty ? Duration(seconds: responseTimes.reduce((a, b) => a + b) ~/ responseTimes.length) : Duration.zero;

      // Statistics by type
      final byType = <String, Map<String, dynamic>>{};
      for (final type in NotificationType.values) {
        final typeNotifications = notifications.where((n) => n.type == type).toList();
        if (typeNotifications.isNotEmpty) {
          final typeDelivered = typeNotifications.where((n) => n.status == NotificationDeliveryStatus.delivered).length;
          final typeOpened = typeNotifications.where((n) => n.action == NotificationAction.opened).length;

          byType[type.toString()] = {
            'sent': typeNotifications.length,
            'delivered': typeDelivered,
            'opened': typeOpened,
            'deliveryRate': typeNotifications.isNotEmpty ? typeDelivered / typeNotifications.length : 0.0,
            'openRate': typeDelivered > 0 ? typeOpened / typeDelivered : 0.0,
          };
        }
      }

      return {
        'totalSent': totalSent,
        'totalDelivered': totalDelivered,
        'totalOpened': totalOpened,
        'totalDismissed': totalDismissed,
        'totalSnoozed': totalSnoozed,
        'totalCompleted': totalCompleted,
        'totalFailed': totalFailed,
        'deliveryRate': deliveryRate,
        'openRate': openRate,
        'actionRate': actionRate,
        'averageResponseTime': avgResponseTime,
        'byType': byType,
      };
    } catch (e) {
      AppLogging.logError('Failed to get statistics: $e', name: 'NotificationRepository');
      return {};
    }
  }

  /// Get best times for notifications based on user interaction history
  List<int> getBestNotificationHours({int days = 30}) {
    try {
      final notifications = getRecentNotifications(days: days);
      final hourlyEngagement = <int, int>{};

      // Count successful interactions by hour
      for (final notification in notifications) {
        if (notification.wasSuccessful && notification.interactedAt != null) {
          final hour = notification.interactedAt!.hour;
          hourlyEngagement[hour] = (hourlyEngagement[hour] ?? 0) + 1;
        }
      }

      if (hourlyEngagement.isEmpty) {
        return [9, 15, 21]; // Default to morning, afternoon, evening
      }

      // Sort hours by engagement and return top 3
      final sortedHours = hourlyEngagement.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

      return sortedHours.take(3).map((e) => e.key).toList();
    } catch (e) {
      AppLogging.logError('Failed to get best notification hours: $e', name: 'NotificationRepository');
      return [9, 15, 21];
    }
  }

  /// Close the repository and dispose resources
  Future<void> dispose() async {
    await _historyBox?.close();
    await _preferencesBox?.close();
    AppLogging.logInfo('NotificationRepository disposed', name: 'NotificationRepository');
  }
}
