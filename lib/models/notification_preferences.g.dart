// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuietHoursAdapter extends TypeAdapter<QuietHours> {
  @override
  final int typeId = 11;

  @override
  QuietHours read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuietHours(
      enabled: fields[0] as bool,
      startHour: fields[1] as int,
      startMinute: fields[2] as int,
      endHour: fields[3] as int,
      endMinute: fields[4] as int,
      activeDays: (fields[5] as List).cast<int>(),
      allowUrgentNotifications: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, QuietHours obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.enabled)
      ..writeByte(1)
      ..write(obj.startHour)
      ..writeByte(2)
      ..write(obj.startMinute)
      ..writeByte(3)
      ..write(obj.endHour)
      ..writeByte(4)
      ..write(obj.endMinute)
      ..writeByte(5)
      ..write(obj.activeDays)
      ..writeByte(6)
      ..write(obj.allowUrgentNotifications);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuietHoursAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationTypePreferencesAdapter
    extends TypeAdapter<NotificationTypePreferences> {
  @override
  final int typeId = 12;

  @override
  NotificationTypePreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationTypePreferences(
      type: fields[0] as NotificationType,
      enabled: fields[1] as bool,
      priority: fields[2] as NotificationPriority,
      playSound: fields[3] as bool,
      customSoundPath: fields[4] as String?,
      vibrate: fields[5] as bool,
      showBadge: fields[6] as bool,
      showPreview: fields[7] as bool,
      enableActions: fields[8] as bool,
      volume: fields[9] as double,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationTypePreferences obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.enabled)
      ..writeByte(2)
      ..write(obj.priority)
      ..writeByte(3)
      ..write(obj.playSound)
      ..writeByte(4)
      ..write(obj.customSoundPath)
      ..writeByte(5)
      ..write(obj.vibrate)
      ..writeByte(6)
      ..write(obj.showBadge)
      ..writeByte(7)
      ..write(obj.showPreview)
      ..writeByte(8)
      ..write(obj.enableActions)
      ..writeByte(9)
      ..write(obj.volume);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationTypePreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationPreferencesAdapter
    extends TypeAdapter<NotificationPreferences> {
  @override
  final int typeId = 13;

  @override
  NotificationPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationPreferences(
      masterNotificationsEnabled: fields[0] as bool,
      quietHours: fields[1] as QuietHours,
      typePreferences: (fields[2] as List).cast<NotificationTypePreferences>(),
      enableSmartScheduling: fields[3] as bool,
      enableGrouping: fields[4] as bool,
      maxNotificationsPerHour: fields[5] as int,
      minMinutesBetweenSameType: fields[6] as int,
      respectSystemDND: fields[7] as bool,
      enableAdaptiveTiming: fields[8] as bool,
      enableDeliveryTracking: fields[9] as bool,
      enableAnalytics: fields[10] as bool,
      badgeOnlyMode: fields[11] as bool,
      userBehaviorData: (fields[12] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, NotificationPreferences obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.masterNotificationsEnabled)
      ..writeByte(1)
      ..write(obj.quietHours)
      ..writeByte(2)
      ..write(obj.typePreferences)
      ..writeByte(3)
      ..write(obj.enableSmartScheduling)
      ..writeByte(4)
      ..write(obj.enableGrouping)
      ..writeByte(5)
      ..write(obj.maxNotificationsPerHour)
      ..writeByte(6)
      ..write(obj.minMinutesBetweenSameType)
      ..writeByte(7)
      ..write(obj.respectSystemDND)
      ..writeByte(8)
      ..write(obj.enableAdaptiveTiming)
      ..writeByte(9)
      ..write(obj.enableDeliveryTracking)
      ..writeByte(10)
      ..write(obj.enableAnalytics)
      ..writeByte(11)
      ..write(obj.badgeOnlyMode)
      ..writeByte(12)
      ..write(obj.userBehaviorData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
