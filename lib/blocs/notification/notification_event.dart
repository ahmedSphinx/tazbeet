import 'package:equatable/equatable.dart';
import '../../models/notification_item.dart';
import '../../models/notification_preferences.dart';
import '../../models/task.dart';

/// Base class for all notification events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize the notification system
class InitializeNotifications extends NotificationEvent {
  const InitializeNotifications();
}

/// Load notification history
class LoadNotificationHistory extends NotificationEvent {
  final int? days; // Load last N days, null for all

  const LoadNotificationHistory({this.days});

  @override
  List<Object?> get props => [days];
}

/// Load notification preferences
class LoadNotificationPreferences extends NotificationEvent {
  const LoadNotificationPreferences();
}

/// Schedule a task reminder notification
class ScheduleTaskReminder extends NotificationEvent {
  final Task task;

  const ScheduleTaskReminder(this.task);

  @override
  List<Object?> get props => [task];
}

/// Cancel a task reminder notification
class CancelTaskReminder extends NotificationEvent {
  final String taskId;

  const CancelTaskReminder(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

/// Schedule mood check-in notifications
class ScheduleMoodCheckIns extends NotificationEvent {
  final List<String> times; // HH:MM format

  const ScheduleMoodCheckIns(this.times);

  @override
  List<Object?> get props => [times];
}

/// Cancel mood check-in notifications
class CancelMoodCheckIns extends NotificationEvent {
  const CancelMoodCheckIns();
}

/// Show immediate notification (for testing or urgent notifications)
class ShowImmediateNotification extends NotificationEvent {
  final NotificationItem notification;

  const ShowImmediateNotification(this.notification);

  @override
  List<Object?> get props => [notification];
}

/// Mark notification as delivered
class MarkNotificationDelivered extends NotificationEvent {
  final String notificationId;
  final DateTime deliveredAt;

  const MarkNotificationDelivered(this.notificationId, this.deliveredAt);

  @override
  List<Object?> get props => [notificationId, deliveredAt];
}

/// Mark notification as interacted with
class MarkNotificationInteracted extends NotificationEvent {
  final String notificationId;
  final NotificationAction action;
  final DateTime interactedAt;

  const MarkNotificationInteracted(this.notificationId, this.action, this.interactedAt);

  @override
  List<Object?> get props => [notificationId, action, interactedAt];
}

/// Mark notification as failed
class MarkNotificationFailed extends NotificationEvent {
  final String notificationId;
  final String reason;

  const MarkNotificationFailed(this.notificationId, this.reason);

  @override
  List<Object?> get props => [notificationId, reason];
}

/// Retry failed notification
class RetryFailedNotification extends NotificationEvent {
  final String notificationId;

  const RetryFailedNotification(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

/// Update notification preferences
class UpdateNotificationPreferences extends NotificationEvent {
  final NotificationPreferences preferences;

  const UpdateNotificationPreferences(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

/// Update type-specific preferences
class UpdateTypePreferences extends NotificationEvent {
  final NotificationTypePreferences typePreferences;

  const UpdateTypePreferences(this.typePreferences);

  @override
  List<Object?> get props => [typePreferences];
}

/// Toggle Do Not Disturb mode
class ToggleDoNotDisturb extends NotificationEvent {
  final bool enabled;
  final Duration? duration; // For temporary DND

  const ToggleDoNotDisturb(this.enabled, {this.duration});

  @override
  List<Object?> get props => [enabled, duration];
}

/// Update quiet hours settings
class UpdateQuietHours extends NotificationEvent {
  final QuietHours quietHours;

  const UpdateQuietHours(this.quietHours);

  @override
  List<Object?> get props => [quietHours];
}

/// Clear notification history
class ClearNotificationHistory extends NotificationEvent {
  final int? daysToKeep; // Keep last N days, null to clear all

  const ClearNotificationHistory({this.daysToKeep});

  @override
  List<Object?> get props => [daysToKeep];
}

/// Delete specific notification from history
class DeleteNotification extends NotificationEvent {
  final String notificationId;

  const DeleteNotification(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

/// Request notification permissions
class RequestNotificationPermissions extends NotificationEvent {
  const RequestNotificationPermissions();
}

/// Check notification permissions status
class CheckNotificationPermissions extends NotificationEvent {
  const CheckNotificationPermissions();
}

/// Get pending scheduled notifications
class GetPendingNotifications extends NotificationEvent {
  const GetPendingNotifications();
}

/// Cancel all notifications
class CancelAllNotifications extends NotificationEvent {
  const CancelAllNotifications();
}

/// Reschedule all task reminders (on app startup or sync)
class RescheduleAllReminders extends NotificationEvent {
  final List<Task> tasks;

  const RescheduleAllReminders(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

/// Load notification analytics
class LoadNotificationAnalytics extends NotificationEvent {
  final int days; // Load analytics for last N days

  const LoadNotificationAnalytics(this.days);

  @override
  List<Object?> get props => [days];
}

/// Test notification (for debugging/testing)
class SendTestNotification extends NotificationEvent {
  final NotificationType type;
  final bool immediate; // True for immediate, false for scheduled in 10 seconds

  const SendTestNotification(this.type, {this.immediate = true});

  @override
  List<Object?> get props => [type, immediate];
}

/// Open notification settings (system settings)
class OpenNotificationSettings extends NotificationEvent {
  const OpenNotificationSettings();
}

/// Filter notifications by type
class FilterNotificationsByType extends NotificationEvent {
  final NotificationType? type; // null means show all

  const FilterNotificationsByType(this.type);

  @override
  List<Object?> get props => [type];
}

/// Filter notifications by status
class FilterNotificationsByStatus extends NotificationEvent {
  final NotificationDeliveryStatus? status; // null means show all

  const FilterNotificationsByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

/// Search notifications
class SearchNotifications extends NotificationEvent {
  final String query;

  const SearchNotifications(this.query);

  @override
  List<Object?> get props => [query];
}

/// Verify scheduled reminders
class VerifyScheduledReminders extends NotificationEvent {
  const VerifyScheduledReminders();
}

/// Snooze a task reminder
class SnoozeTaskReminder extends NotificationEvent {
  final String taskId;
  final Duration duration;

  const SnoozeTaskReminder(this.taskId, this.duration);

  @override
  List<Object?> get props => [taskId, duration];
}
