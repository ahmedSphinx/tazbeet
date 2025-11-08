import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'notification_item.g.dart';

/// Notification types categorizing different notification purposes
@HiveType(typeId: 14)
enum NotificationType {
  @HiveField(0)
  taskReminder,
  @HiveField(1)
  taskDue,
  @HiveField(2)
  taskCompleted,
  @HiveField(3)
  moodCheckIn,
  @HiveField(4)
  pomodoroWork,
  @HiveField(5)
  pomodoroBreak,
  @HiveField(6)
  pomodoroComplete,
  @HiveField(7)
  emergency,
  @HiveField(8)
  system,
}

/// Notification priority levels affecting how prominently notifications are displayed
@HiveType(typeId: 15)
enum NotificationPriority {
  @HiveField(0)
  low, // Badge only, no sound
  @HiveField(1)
  medium, // Standard notification
  @HiveField(2)
  high, // Prominent with sound
  @HiveField(3)
  urgent, // Full-screen with sound and vibration
}

/// Actions taken by user on a notification
@HiveType(typeId: 16)
enum NotificationAction {
  @HiveField(0)
  none, // Not interacted with
  @HiveField(1)
  opened, // Notification was opened
  @HiveField(2)
  dismissed, // Swiped away
  @HiveField(3)
  snoozed, // Snoozed for later
  @HiveField(4)
  completed, // Action completed from notification
  @HiveField(5)
  clicked, // Clicked on action button
}

/// Notification delivery status
@HiveType(typeId: 17)
enum NotificationDeliveryStatus {
  @HiveField(0)
  pending, // Scheduled but not sent
  @HiveField(1)
  delivered, // Successfully delivered
  @HiveField(2)
  failed, // Failed to deliver
  @HiveField(3)
  cancelled, // Cancelled before delivery
  @HiveField(4)
  expired, // Delivery time passed
}

/// Model representing a single notification item with full tracking and analytics
@HiveType(typeId: 10)
class NotificationItem extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final NotificationType type;

  @HiveField(4)
  final NotificationPriority priority;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime? scheduledAt;

  @HiveField(7)
  final DateTime? deliveredAt;

  @HiveField(8)
  final DateTime? interactedAt;

  @HiveField(9)
  final NotificationAction action;

  @HiveField(10)
  final NotificationDeliveryStatus status;

  @HiveField(11)
  final String? payload; // JSON data for handling notification taps

  @HiveField(12)
  final String? relatedTaskId;

  @HiveField(13)
  final String? relatedMoodId;

  @HiveField(14)
  final String? imageUrl;

  @HiveField(15)
  final String? soundPath;

  @HiveField(16)
  final bool enableVibration;

  @HiveField(17)
  final List<String> actionButtons; // Action button labels

  @HiveField(18)
  final String? groupKey; // For grouping notifications

  @HiveField(19)
  final int? badgeCount;

  @HiveField(20)
  final Map<String, dynamic>? metadata; // Additional data

  @HiveField(21)
  final int retryCount; // Number of delivery retry attempts

  @HiveField(22)
  final DateTime? lastRetryAt;

  @HiveField(23)
  final String? failureReason;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.priority = NotificationPriority.medium,
    required this.createdAt,
    this.scheduledAt,
    this.deliveredAt,
    this.interactedAt,
    this.action = NotificationAction.none,
    this.status = NotificationDeliveryStatus.pending,
    this.payload,
    this.relatedTaskId,
    this.relatedMoodId,
    this.imageUrl,
    this.soundPath,
    this.enableVibration = true,
    this.actionButtons = const [],
    this.groupKey,
    this.badgeCount,
    this.metadata,
    this.retryCount = 0,
    this.lastRetryAt,
    this.failureReason,
  });

  /// Copy with method for creating modified instances
  NotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    NotificationPriority? priority,
    DateTime? createdAt,
    DateTime? scheduledAt,
    DateTime? deliveredAt,
    DateTime? interactedAt,
    NotificationAction? action,
    NotificationDeliveryStatus? status,
    String? payload,
    String? relatedTaskId,
    String? relatedMoodId,
    String? imageUrl,
    String? soundPath,
    bool? enableVibration,
    List<String>? actionButtons,
    String? groupKey,
    int? badgeCount,
    Map<String, dynamic>? metadata,
    int? retryCount,
    DateTime? lastRetryAt,
    String? failureReason,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      interactedAt: interactedAt ?? this.interactedAt,
      action: action ?? this.action,
      status: status ?? this.status,
      payload: payload ?? this.payload,
      relatedTaskId: relatedTaskId ?? this.relatedTaskId,
      relatedMoodId: relatedMoodId ?? this.relatedMoodId,
      imageUrl: imageUrl ?? this.imageUrl,
      soundPath: soundPath ?? this.soundPath,
      enableVibration: enableVibration ?? this.enableVibration,
      actionButtons: actionButtons ?? this.actionButtons,
      groupKey: groupKey ?? this.groupKey,
      badgeCount: badgeCount ?? this.badgeCount,
      metadata: metadata ?? this.metadata,
      retryCount: retryCount ?? this.retryCount,
      lastRetryAt: lastRetryAt ?? this.lastRetryAt,
      failureReason: failureReason ?? this.failureReason,
    );
  }

  /// Convert to JSON for storage/transmission
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.index,
      'priority': priority.index,
      'createdAt': createdAt.toIso8601String(),
      'scheduledAt': scheduledAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'interactedAt': interactedAt?.toIso8601String(),
      'action': action.index,
      'status': status.index,
      'payload': payload,
      'relatedTaskId': relatedTaskId,
      'relatedMoodId': relatedMoodId,
      'imageUrl': imageUrl,
      'soundPath': soundPath,
      'enableVibration': enableVibration,
      'actionButtons': actionButtons,
      'groupKey': groupKey,
      'badgeCount': badgeCount,
      'metadata': metadata,
      'retryCount': retryCount,
      'lastRetryAt': lastRetryAt?.toIso8601String(),
      'failureReason': failureReason,
    };
  }

  /// Create from JSON
  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationType.values[json['type'] as int],
      priority: NotificationPriority.values[json['priority'] as int? ?? 1],
      createdAt: DateTime.parse(json['createdAt'] as String),
      scheduledAt: json['scheduledAt'] != null ? DateTime.parse(json['scheduledAt'] as String) : null,
      deliveredAt: json['deliveredAt'] != null ? DateTime.parse(json['deliveredAt'] as String) : null,
      interactedAt: json['interactedAt'] != null ? DateTime.parse(json['interactedAt'] as String) : null,
      action: NotificationAction.values[json['action'] as int? ?? 0],
      status: NotificationDeliveryStatus.values[json['status'] as int? ?? 0],
      payload: json['payload'] as String?,
      relatedTaskId: json['relatedTaskId'] as String?,
      relatedMoodId: json['relatedMoodId'] as String?,
      imageUrl: json['imageUrl'] as String?,
      soundPath: json['soundPath'] as String?,
      enableVibration: json['enableVibration'] as bool? ?? true,
      actionButtons: (json['actionButtons'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      groupKey: json['groupKey'] as String?,
      badgeCount: json['badgeCount'] as int?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      retryCount: json['retryCount'] as int? ?? 0,
      lastRetryAt: json['lastRetryAt'] != null ? DateTime.parse(json['lastRetryAt'] as String) : null,
      failureReason: json['failureReason'] as String?,
    );
  }

  /// Check if notification was successfully delivered and interacted with
  bool get wasSuccessful => status == NotificationDeliveryStatus.delivered && action != NotificationAction.none && action != NotificationAction.dismissed;

  /// Check if notification needs retry
  bool get needsRetry => status == NotificationDeliveryStatus.failed && retryCount < 3;

  /// Get response time (time between delivery and interaction)
  Duration? get responseTime {
    if (deliveredAt != null && interactedAt != null) {
      return interactedAt!.difference(deliveredAt!);
    }
    return null;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    body,
    type,
    priority,
    createdAt,
    scheduledAt,
    deliveredAt,
    interactedAt,
    action,
    status,
    payload,
    relatedTaskId,
    relatedMoodId,
    imageUrl,
    soundPath,
    enableVibration,
    actionButtons,
    groupKey,
    badgeCount,
    metadata,
    retryCount,
    lastRetryAt,
    failureReason,
  ];
}
