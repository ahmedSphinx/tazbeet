import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'mood.g.dart';

@HiveType(typeId: 33)
enum MoodLevel {
  @HiveField(0)
  very_bad,
  @HiveField(1)
  bad,
  @HiveField(2)
  neutral,
  @HiveField(3)
  good,
  @HiveField(4)
  very_good,
}

@HiveType(typeId: 32)
class Mood extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final MoodLevel level;
  @HiveField(2)
  final String? note;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final DateTime updatedAt;
  @HiveField(6)
  final List<String> tags;
  @HiveField(7)
  final int energyLevel; // 1-10
  @HiveField(8)
  final int focusLevel; // 1-10
  @HiveField(9)
  final int stressLevel; // 1-10

  const Mood({
    required this.id,
    required this.level,
    this.note,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.energyLevel = 5,
    this.focusLevel = 5,
    this.stressLevel = 5,
  });

  Mood copyWith({
    String? id,
    MoodLevel? level,
    String? note,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    int? energyLevel,
    int? focusLevel,
    int? stressLevel,
  }) {
    return Mood(
      id: id ?? this.id,
      level: level ?? this.level,
      note: note ?? this.note,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      energyLevel: energyLevel ?? this.energyLevel,
      focusLevel: focusLevel ?? this.focusLevel,
      stressLevel: stressLevel ?? this.stressLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level.index,
      'note': note,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'tags': tags,
      'energyLevel': energyLevel,
      'focusLevel': focusLevel,
      'stressLevel': stressLevel,
    };
  }

  factory Mood.fromJson(Map<String, dynamic> json) {
    return Mood(
      id: json['id'],
      level: MoodLevel.values[json['level'] ?? 2],
      note: json['note'],
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      tags: List<String>.from(json['tags'] ?? []),
      energyLevel: json['energyLevel'] ?? 5,
      focusLevel: json['focusLevel'] ?? 5,
      stressLevel: json['stressLevel'] ?? 5,
    );
  }

  @override
  List<Object?> get props => [
        id,
        level,
        note,
        date,
        createdAt,
        updatedAt,
        tags,
        energyLevel,
        focusLevel,
        stressLevel,
      ];
}
