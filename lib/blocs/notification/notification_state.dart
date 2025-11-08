import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../models/notification_item.dart';
import '../../models/notification_preferences.dart';

/// Base class for all notification states
abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

/// Initial state before initialization
class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

/// Notification system is loading/initializing
class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

/// Notification system initialized successfully
class NotificationInitialized extends NotificationState {
  final bool permissionsGranted;
  final NotificationPreferences preferences;

  const NotificationInitialized({required this.permissionsGranted, required this.preferences});

  @override
  List<Object?> get props => [permissionsGranted, preferences];
}

/// Notification data loaded state (main state with all data)
class NotificationLoaded extends NotificationState {
  final List<NotificationItem> allNotifications;
  final List<NotificationItem> filteredNotifications;
  final NotificationPreferences preferences;
  final bool permissionsGranted;
  final List<PendingNotificationRequest> pendingNotifications;
  final bool isDoNotDisturbActive;
  final NotificationType? activeFilter;
  final NotificationDeliveryStatus? statusFilter;
  final String? searchQuery;
  final Map<String, dynamic>? analytics;

  const NotificationLoaded({
    required this.allNotifications,
    required this.filteredNotifications,
    required this.preferences,
    required this.permissionsGranted,
    this.pendingNotifications = const [],
    this.isDoNotDisturbActive = false,
    this.activeFilter,
    this.statusFilter,
    this.searchQuery,
    this.analytics,
  });

  NotificationLoaded copyWith({
    List<NotificationItem>? allNotifications,
    List<NotificationItem>? filteredNotifications,
    NotificationPreferences? preferences,
    bool? permissionsGranted,
    List<PendingNotificationRequest>? pendingNotifications,
    bool? isDoNotDisturbActive,
    NotificationType? activeFilter,
    bool clearActiveFilter = false,
    NotificationDeliveryStatus? statusFilter,
    bool clearStatusFilter = false,
    String? searchQuery,
    bool clearSearchQuery = false,
    Map<String, dynamic>? analytics,
  }) {
    return NotificationLoaded(
      allNotifications: allNotifications ?? this.allNotifications,
      filteredNotifications: filteredNotifications ?? this.filteredNotifications,
      preferences: preferences ?? this.preferences,
      permissionsGranted: permissionsGranted ?? this.permissionsGranted,
      pendingNotifications: pendingNotifications ?? this.pendingNotifications,
      isDoNotDisturbActive: isDoNotDisturbActive ?? this.isDoNotDisturbActive,
      activeFilter: clearActiveFilter ? null : (activeFilter ?? this.activeFilter),
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      analytics: analytics ?? this.analytics,
    );
  }

  /// Get statistics about notifications
  Map<String, int> get notificationCounts {
    return {
      'total': allNotifications.length,
      'delivered': allNotifications.where((n) => n.status == NotificationDeliveryStatus.delivered).length,
      'pending': allNotifications.where((n) => n.status == NotificationDeliveryStatus.pending).length,
      'failed': allNotifications.where((n) => n.status == NotificationDeliveryStatus.failed).length,
      'opened': allNotifications.where((n) => n.action == NotificationAction.opened).length,
      'dismissed': allNotifications.where((n) => n.action == NotificationAction.dismissed).length,
    };
  }

  /// Get counts by type
  Map<NotificationType, int> get countsByType {
    final counts = <NotificationType, int>{};
    for (final type in NotificationType.values) {
      counts[type] = allNotifications.where((n) => n.type == type).length;
    }
    return counts;
  }

  /// Check if quiet hours are active
  bool get isQuietHoursActive {
    return preferences.quietHours.isQuietTimeNow();
  }

  @override
  List<Object?> get props => [allNotifications, filteredNotifications, preferences, permissionsGranted, pendingNotifications, isDoNotDisturbActive, activeFilter, statusFilter, searchQuery, analytics];
}

/// Notification permission denied state
class NotificationPermissionDenied extends NotificationState {
  final String message;

  const NotificationPermissionDenied(this.message);

  @override
  List<Object?> get props => [message];
}

/// Notification action in progress
class NotificationActionInProgress extends NotificationState {
  final String actionType; // e.g., "scheduling", "canceling", "updating"
  final NotificationState previousState; // Retain previous state

  const NotificationActionInProgress(this.actionType, this.previousState);

  @override
  List<Object?> get props => [actionType, previousState];
}

/// Notification action completed successfully
class NotificationActionSuccess extends NotificationState {
  final String message;
  final NotificationState previousState;

  const NotificationActionSuccess(this.message, this.previousState);

  @override
  List<Object?> get props => [message, previousState];
}

/// Error state for notification operations
class NotificationError extends NotificationState {
  final String error;
  final NotificationState? previousState;
  final StackTrace? stackTrace;

  const NotificationError(this.error, {this.previousState, this.stackTrace});

  @override
  List<Object?> get props => [error, previousState, stackTrace];
}

/// Notification scheduled successfully
class NotificationScheduled extends NotificationState {
  final NotificationItem notification;
  final NotificationState previousState;

  const NotificationScheduled(this.notification, this.previousState);

  @override
  List<Object?> get props => [notification, previousState];
}

/// Notification cancelled successfully
class NotificationCancelled extends NotificationState {
  final String notificationId;
  final NotificationState previousState;

  const NotificationCancelled(this.notificationId, this.previousState);

  @override
  List<Object?> get props => [notificationId, previousState];
}

/// Preferences updated successfully
class PreferencesUpdated extends NotificationState {
  final NotificationPreferences preferences;
  final NotificationState previousState;

  const PreferencesUpdated(this.preferences, this.previousState);

  @override
  List<Object?> get props => [preferences, previousState];
}

/// Do Not Disturb mode changed
class DoNotDisturbChanged extends NotificationState {
  final bool enabled;
  final Duration? duration;
  final NotificationState previousState;

  const DoNotDisturbChanged(this.enabled, this.previousState, {this.duration});

  @override
  List<Object?> get props => [enabled, duration, previousState];
}

/// Analytics loaded
class AnalyticsLoaded extends NotificationState {
  final Map<String, dynamic> analytics;
  final NotificationState previousState;

  const AnalyticsLoaded(this.analytics, this.previousState);

  @override
  List<Object?> get props => [analytics, previousState];
}
