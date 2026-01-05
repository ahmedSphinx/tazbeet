import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'notification_item.dart';

part 'notification_preferences.g.dart';

/// Quiet hours configuration for Do Not Disturb mode
@HiveType(typeId: 11)
class QuietHours extends Equatable {
  @HiveField(0)
  final bool enabled;

  @HiveField(1)
  final int startHour; // 0-23

  @HiveField(2)
  final int startMinute; // 0-59

  @HiveField(3)
  final int endHour; // 0-23

  @HiveField(4)
  final int endMinute; // 0-59

  @HiveField(5)
  final List<int> activeDays; // 1=Monday, 7=Sunday

  @HiveField(6)
  final bool allowUrgentNotifications; // Allow urgent priority notifications

  const QuietHours({
    this.enabled = false,
    this.startHour = 22, // 10 PM
    this.startMinute = 0,
    this.endHour = 7, // 7 AM
    this.endMinute = 0,
    this.activeDays = const [1, 2, 3, 4, 5, 6, 7], // All days
    this.allowUrgentNotifications = true,
  });

  QuietHours copyWith({bool? enabled, int? startHour, int? startMinute, int? endHour, int? endMinute, List<int>? activeDays, bool? allowUrgentNotifications}) {
    return QuietHours(
      enabled: enabled ?? this.enabled,
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      endHour: endHour ?? this.endHour,
      endMinute: endMinute ?? this.endMinute,
      activeDays: activeDays ?? this.activeDays,
      allowUrgentNotifications: allowUrgentNotifications ?? this.allowUrgentNotifications,
    );
  }

  /// Check if current time is within quiet hours
  bool isQuietTimeNow() {
    if (!enabled) return false;

    final now = DateTime.now();
    final currentDay = now.weekday; // Monday = 1, Sunday = 7

    if (!activeDays.contains(currentDay)) return false;

    final currentMinutes = now.hour * 60 + now.minute;
    final startMinutes = startHour * 60 + startMinute;
    final endMinutes = endHour * 60 + endMinute;

    // Handle overnight quiet hours (e.g., 22:00 to 07:00)
    if (startMinutes > endMinutes) {
      return currentMinutes >= startMinutes || currentMinutes < endMinutes;
    } else {
      return currentMinutes >= startMinutes && currentMinutes < endMinutes;
    }
  }

  @override
  List<Object?> get props => [enabled, startHour, startMinute, endHour, endMinute, activeDays, allowUrgentNotifications];
}

/// Preferences for a specific notification type
@HiveType(typeId: 12)
class NotificationTypePreferences extends Equatable {
  @HiveField(0)
  final NotificationType type;

  @HiveField(1)
  final bool enabled;

  @HiveField(2)
  final NotificationPriority priority;

  @HiveField(3)
  final bool playSound;

  @HiveField(4)
  final String? customSoundPath;

  @HiveField(5)
  final bool vibrate;

  @HiveField(6)
  final bool showBadge;

  @HiveField(7)
  final bool showPreview; // Show notification content in preview

  @HiveField(8)
  final bool enableActions; // Show action buttons

  @HiveField(9)
  final double volume; // 0.0 to 1.0

  const NotificationTypePreferences({
    required this.type,
    this.enabled = true,
    this.priority = NotificationPriority.medium,
    this.playSound = true,
    this.customSoundPath,
    this.vibrate = true,
    this.showBadge = true,
    this.showPreview = true,
    this.enableActions = true,
    this.volume = 1.0,
  });

  NotificationTypePreferences copyWith({
    NotificationType? type,
    bool? enabled,
    NotificationPriority? priority,
    bool? playSound,
    String? customSoundPath,
    bool? vibrate,
    bool? showBadge,
    bool? showPreview,
    bool? enableActions,
    double? volume,
  }) {
    return NotificationTypePreferences(
      type: type ?? this.type,
      enabled: enabled ?? this.enabled,
      priority: priority ?? this.priority,
      playSound: playSound ?? this.playSound,
      customSoundPath: customSoundPath ?? this.customSoundPath,
      vibrate: vibrate ?? this.vibrate,
      showBadge: showBadge ?? this.showBadge,
      showPreview: showPreview ?? this.showPreview,
      enableActions: enableActions ?? this.enableActions,
      volume: volume ?? this.volume,
    );
  }

  @override
  List<Object?> get props => [type, enabled, priority, playSound, customSoundPath, vibrate, showBadge, showPreview, enableActions, volume];
}

/// Comprehensive notification preferences with smart features
@HiveType(typeId: 13)
class NotificationPreferences extends Equatable {
  @HiveField(0)
  final bool masterNotificationsEnabled;

  @HiveField(1)
  final QuietHours quietHours;

  @HiveField(2)
  final List<NotificationTypePreferences> typePreferences;

  @HiveField(3)
  final bool enableSmartScheduling; // Avoid spamming user

  @HiveField(4)
  final bool enableGrouping; // Group similar notifications

  @HiveField(5)
  final int maxNotificationsPerHour;

  @HiveField(6)
  final int minMinutesBetweenSameType;

  @HiveField(7)
  final bool respectSystemDND; // Check device's native DND

  @HiveField(8)
  final bool enableAdaptiveTiming; // Learn from user behavior

  @HiveField(9)
  final bool enableDeliveryTracking;

  @HiveField(10)
  final bool enableAnalytics;

  @HiveField(11)
  final bool badgeOnlyMode; // Silent notifications, badge only

  @HiveField(12)
  final Map<String, dynamic>? userBehaviorData; // Learned behavior patterns

  const NotificationPreferences({
    this.masterNotificationsEnabled = true,
    this.quietHours = const QuietHours(),
    this.typePreferences = const [],
    this.enableSmartScheduling = true,
    this.enableGrouping = true,
    this.maxNotificationsPerHour = 10,
    this.minMinutesBetweenSameType = 15,
    this.respectSystemDND = true,
    this.enableAdaptiveTiming = false,
    this.enableDeliveryTracking = true,
    this.enableAnalytics = true,
    this.badgeOnlyMode = false,
    this.userBehaviorData,
  });

  NotificationPreferences copyWith({
    bool? masterNotificationsEnabled,
    QuietHours? quietHours,
    List<NotificationTypePreferences>? typePreferences,
    bool? enableSmartScheduling,
    bool? enableGrouping,
    int? maxNotificationsPerHour,
    int? minMinutesBetweenSameType,
    bool? respectSystemDND,
    bool? enableAdaptiveTiming,
    bool? enableDeliveryTracking,
    bool? enableAnalytics,
    bool? badgeOnlyMode,
    Map<String, dynamic>? userBehaviorData,
  }) {
    return NotificationPreferences(
      masterNotificationsEnabled: masterNotificationsEnabled ?? this.masterNotificationsEnabled,
      quietHours: quietHours ?? this.quietHours,
      typePreferences: typePreferences ?? this.typePreferences,
      enableSmartScheduling: enableSmartScheduling ?? this.enableSmartScheduling,
      enableGrouping: enableGrouping ?? this.enableGrouping,
      maxNotificationsPerHour: maxNotificationsPerHour ?? this.maxNotificationsPerHour,
      minMinutesBetweenSameType: minMinutesBetweenSameType ?? this.minMinutesBetweenSameType,
      respectSystemDND: respectSystemDND ?? this.respectSystemDND,
      enableAdaptiveTiming: enableAdaptiveTiming ?? this.enableAdaptiveTiming,
      enableDeliveryTracking: enableDeliveryTracking ?? this.enableDeliveryTracking,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
      badgeOnlyMode: badgeOnlyMode ?? this.badgeOnlyMode,
      userBehaviorData: userBehaviorData ?? this.userBehaviorData,
    );
  }

  /// Get preferences for a specific notification type
  NotificationTypePreferences? getPreferencesForType(NotificationType type) {
    try {
      return typePreferences.firstWhere((pref) => pref.type == type);
    } catch (e) {
      return null;
    }
  }

  /// Check if notifications are allowed right now
  bool areNotificationsAllowedNow({NotificationPriority priority = NotificationPriority.medium}) {
    if (!masterNotificationsEnabled) return false;

    if (quietHours.isQuietTimeNow()) {
      // Allow urgent notifications even during quiet hours if configured
      if (priority == NotificationPriority.urgent && quietHours.allowUrgentNotifications) {
        return true;
      }
      return false;
    }

    return true;
  }

  /// Get default preferences for all notification types
  static NotificationPreferences getDefaults() {
    return NotificationPreferences(
      typePreferences: NotificationType.values.map((type) {
        return NotificationTypePreferences(type: type, enabled: true, priority: _getDefaultPriority(type), playSound: type != NotificationType.system, vibrate: type != NotificationType.system);
      }).toList(),
    );
  }

  static NotificationPriority _getDefaultPriority(NotificationType type) {
    switch (type) {
      case NotificationType.emergency:
        return NotificationPriority.urgent;
      case NotificationType.taskDue:
      case NotificationType.pomodoroWork:
      case NotificationType.userSignup:
        return NotificationPriority.high;
      case NotificationType.taskReminder:
      case NotificationType.moodCheckIn:
      case NotificationType.pomodoroBreak:
        return NotificationPriority.medium;
      case NotificationType.taskCompleted:
      case NotificationType.pomodoroComplete:
      case NotificationType.system:
        return NotificationPriority.low;
    }
  }

  @override
  List<Object?> get props => [
    masterNotificationsEnabled,
    quietHours,
    typePreferences,
    enableSmartScheduling,
    enableGrouping,
    maxNotificationsPerHour,
    minMinutesBetweenSameType,
    respectSystemDND,
    enableAdaptiveTiming,
    enableDeliveryTracking,
    enableAnalytics,
    badgeOnlyMode,
    userBehaviorData,
  ];
}
