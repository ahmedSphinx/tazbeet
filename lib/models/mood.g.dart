// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoodAdapter extends TypeAdapter<Mood> {
  @override
  final int typeId = 32;

  @override
  Mood read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Mood(
      id: fields[0] as String,
      level: fields[1] as MoodLevel,
      note: fields[2] as String?,
      date: fields[3] as DateTime,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      tags: (fields[6] as List).cast<String>(),
      energyLevel: fields[7] as int,
      focusLevel: fields[8] as int,
      stressLevel: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Mood obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.note)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.energyLevel)
      ..writeByte(8)
      ..write(obj.focusLevel)
      ..writeByte(9)
      ..write(obj.stressLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MoodLevelAdapter extends TypeAdapter<MoodLevel> {
  @override
  final int typeId = 33;

  @override
  MoodLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MoodLevel.very_bad;
      case 1:
        return MoodLevel.bad;
      case 2:
        return MoodLevel.neutral;
      case 3:
        return MoodLevel.good;
      case 4:
        return MoodLevel.very_good;
      default:
        return MoodLevel.very_bad;
    }
  }

  @override
  void write(BinaryWriter writer, MoodLevel obj) {
    switch (obj) {
      case MoodLevel.very_bad:
        writer.writeByte(0);
        break;
      case MoodLevel.bad:
        writer.writeByte(1);
        break;
      case MoodLevel.neutral:
        writer.writeByte(2);
        break;
      case MoodLevel.good:
        writer.writeByte(3);
        break;
      case MoodLevel.very_good:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
