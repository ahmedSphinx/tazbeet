// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationItemAdapter extends TypeAdapter<NotificationItem> {
  @override
  final int typeId = 10;

  @override
  NotificationItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationItem(
      id: fields[0] as String,
      title: fields[1] as String,
      body: fields[2] as String,
      type: fields[3] as NotificationType,
      priority: fields[4] as NotificationPriority,
      createdAt: fields[5] as DateTime,
      scheduledAt: fields[6] as DateTime?,
      deliveredAt: fields[7] as DateTime?,
      interactedAt: fields[8] as DateTime?,
      action: fields[9] as NotificationAction,
      status: fields[10] as NotificationDeliveryStatus,
      payload: fields[11] as String?,
      relatedTaskId: fields[12] as String?,
      relatedMoodId: fields[13] as String?,
      imageUrl: fields[14] as String?,
      soundPath: fields[15] as String?,
      enableVibration: fields[16] as bool,
      actionButtons: (fields[17] as List).cast<String>(),
      groupKey: fields[18] as String?,
      badgeCount: fields[19] as int?,
      metadata: (fields[20] as Map?)?.cast<String, dynamic>(),
      retryCount: fields[21] as int,
      lastRetryAt: fields[22] as DateTime?,
      failureReason: fields[23] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationItem obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.scheduledAt)
      ..writeByte(7)
      ..write(obj.deliveredAt)
      ..writeByte(8)
      ..write(obj.interactedAt)
      ..writeByte(9)
      ..write(obj.action)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.payload)
      ..writeByte(12)
      ..write(obj.relatedTaskId)
      ..writeByte(13)
      ..write(obj.relatedMoodId)
      ..writeByte(14)
      ..write(obj.imageUrl)
      ..writeByte(15)
      ..write(obj.soundPath)
      ..writeByte(16)
      ..write(obj.enableVibration)
      ..writeByte(17)
      ..write(obj.actionButtons)
      ..writeByte(18)
      ..write(obj.groupKey)
      ..writeByte(19)
      ..write(obj.badgeCount)
      ..writeByte(20)
      ..write(obj.metadata)
      ..writeByte(21)
      ..write(obj.retryCount)
      ..writeByte(22)
      ..write(obj.lastRetryAt)
      ..writeByte(23)
      ..write(obj.failureReason);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationTypeAdapter extends TypeAdapter<NotificationType> {
  @override
  final int typeId = 14;

  @override
  NotificationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationType.taskReminder;
      case 1:
        return NotificationType.taskDue;
      case 2:
        return NotificationType.taskCompleted;
      case 3:
        return NotificationType.moodCheckIn;
      case 4:
        return NotificationType.pomodoroWork;
      case 5:
        return NotificationType.pomodoroBreak;
      case 6:
        return NotificationType.pomodoroComplete;
      case 7:
        return NotificationType.emergency;
      case 8:
        return NotificationType.system;
      case 9:
        return NotificationType.userSignup;
      default:
        return NotificationType.taskReminder;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationType obj) {
    switch (obj) {
      case NotificationType.taskReminder:
        writer.writeByte(0);
        break;
      case NotificationType.taskDue:
        writer.writeByte(1);
        break;
      case NotificationType.taskCompleted:
        writer.writeByte(2);
        break;
      case NotificationType.moodCheckIn:
        writer.writeByte(3);
        break;
      case NotificationType.pomodoroWork:
        writer.writeByte(4);
        break;
      case NotificationType.pomodoroBreak:
        writer.writeByte(5);
        break;
      case NotificationType.pomodoroComplete:
        writer.writeByte(6);
        break;
      case NotificationType.emergency:
        writer.writeByte(7);
        break;
      case NotificationType.system:
        writer.writeByte(8);
        break;
      case NotificationType.userSignup:
        writer.writeByte(9);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationPriorityAdapter extends TypeAdapter<NotificationPriority> {
  @override
  final int typeId = 15;

  @override
  NotificationPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationPriority.low;
      case 1:
        return NotificationPriority.medium;
      case 2:
        return NotificationPriority.high;
      case 3:
        return NotificationPriority.urgent;
      default:
        return NotificationPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationPriority obj) {
    switch (obj) {
      case NotificationPriority.low:
        writer.writeByte(0);
        break;
      case NotificationPriority.medium:
        writer.writeByte(1);
        break;
      case NotificationPriority.high:
        writer.writeByte(2);
        break;
      case NotificationPriority.urgent:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationActionAdapter extends TypeAdapter<NotificationAction> {
  @override
  final int typeId = 16;

  @override
  NotificationAction read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationAction.none;
      case 1:
        return NotificationAction.opened;
      case 2:
        return NotificationAction.dismissed;
      case 3:
        return NotificationAction.snoozed;
      case 4:
        return NotificationAction.completed;
      case 5:
        return NotificationAction.clicked;
      default:
        return NotificationAction.none;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationAction obj) {
    switch (obj) {
      case NotificationAction.none:
        writer.writeByte(0);
        break;
      case NotificationAction.opened:
        writer.writeByte(1);
        break;
      case NotificationAction.dismissed:
        writer.writeByte(2);
        break;
      case NotificationAction.snoozed:
        writer.writeByte(3);
        break;
      case NotificationAction.completed:
        writer.writeByte(4);
        break;
      case NotificationAction.clicked:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationDeliveryStatusAdapter
    extends TypeAdapter<NotificationDeliveryStatus> {
  @override
  final int typeId = 17;

  @override
  NotificationDeliveryStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationDeliveryStatus.pending;
      case 1:
        return NotificationDeliveryStatus.delivered;
      case 2:
        return NotificationDeliveryStatus.failed;
      case 3:
        return NotificationDeliveryStatus.cancelled;
      case 4:
        return NotificationDeliveryStatus.expired;
      default:
        return NotificationDeliveryStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationDeliveryStatus obj) {
    switch (obj) {
      case NotificationDeliveryStatus.pending:
        writer.writeByte(0);
        break;
      case NotificationDeliveryStatus.delivered:
        writer.writeByte(1);
        break;
      case NotificationDeliveryStatus.failed:
        writer.writeByte(2);
        break;
      case NotificationDeliveryStatus.cancelled:
        writer.writeByte(3);
        break;
      case NotificationDeliveryStatus.expired:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationDeliveryStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
