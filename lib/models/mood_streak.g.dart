// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_streak.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoodStreakAdapter extends TypeAdapter<MoodStreak> {
  @override
  final int typeId = 36;

  @override
  MoodStreak read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoodStreak(
      currentStreak: fields[0] as int,
      longestStreak: fields[1] as int,
      lastCheckInDate: fields[2] as DateTime,
      totalCheckIns: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MoodStreak obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.currentStreak)
      ..writeByte(1)
      ..write(obj.longestStreak)
      ..writeByte(2)
      ..write(obj.lastCheckInDate)
      ..writeByte(3)
      ..write(obj.totalCheckIns);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodStreakAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
