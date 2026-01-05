// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_achievement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoodAchievementAdapter extends TypeAdapter<MoodAchievement> {
  @override
  final int typeId = 121;

  @override
  MoodAchievement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoodAchievement(
      id: fields[0] as String,
      type: fields[1] as MoodAchievementType,
      unlockedAt: fields[2] as DateTime,
      title: fields[3] as String,
      description: fields[4] as String,
      emoji: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MoodAchievement obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.unlockedAt)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.emoji);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodAchievementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MoodAchievementTypeAdapter extends TypeAdapter<MoodAchievementType> {
  @override
  final int typeId = 120;

  @override
  MoodAchievementType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MoodAchievementType.firstCheckIn;
      case 1:
        return MoodAchievementType.weekStreak;
      case 2:
        return MoodAchievementType.monthStreak;
      case 3:
        return MoodAchievementType.checkIn30;
      case 4:
        return MoodAchievementType.checkIn100;
      case 5:
        return MoodAchievementType.checkIn365;
      case 6:
        return MoodAchievementType.consistencyChampion;
      case 7:
        return MoodAchievementType.selfAware;
      case 8:
        return MoodAchievementType.insightSeeker;
      default:
        return MoodAchievementType.firstCheckIn;
    }
  }

  @override
  void write(BinaryWriter writer, MoodAchievementType obj) {
    switch (obj) {
      case MoodAchievementType.firstCheckIn:
        writer.writeByte(0);
        break;
      case MoodAchievementType.weekStreak:
        writer.writeByte(1);
        break;
      case MoodAchievementType.monthStreak:
        writer.writeByte(2);
        break;
      case MoodAchievementType.checkIn30:
        writer.writeByte(3);
        break;
      case MoodAchievementType.checkIn100:
        writer.writeByte(4);
        break;
      case MoodAchievementType.checkIn365:
        writer.writeByte(5);
        break;
      case MoodAchievementType.consistencyChampion:
        writer.writeByte(6);
        break;
      case MoodAchievementType.selfAware:
        writer.writeByte(7);
        break;
      case MoodAchievementType.insightSeeker:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodAchievementTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
