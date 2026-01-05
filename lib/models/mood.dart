// ignore_for_file: constant_identifier_names

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
  @HiveField(10)
  final List<String>? _activities;
  @HiveField(11)
  final String? location;
  @HiveField(12)
  final List<String>? _people;
  @HiveField(13)
  final bool? _isQuickCheckIn;

  List<String> get activities => _activities ?? const [];
  List<String> get people => _people ?? const [];
  bool get isQuickCheckIn => _isQuickCheckIn ?? false;

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
    this.location,
    List<String>? activities,
    List<String>? people,
    bool? isQuickCheckIn,
  }) : _activities = activities ?? const [],
       _people = people ?? const [],
       _isQuickCheckIn = isQuickCheckIn ?? false;

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
    List<String>? activities,
    String? location,
    List<String>? people,
    bool? isQuickCheckIn,
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
      activities: activities ?? this.activities,
      location: location ?? this.location,
      people: people ?? this.people,
      isQuickCheckIn: isQuickCheckIn ?? this.isQuickCheckIn,
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
      'activities': activities,
      'location': location,
      'people': people,
      'isQuickCheckIn': isQuickCheckIn,
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
      activities: List<String>.from(json['activities'] ?? []),
      location: json['location'],
      people: List<String>.from(json['people'] ?? []),
      isQuickCheckIn: json['isQuickCheckIn'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, level, note, date, createdAt, updatedAt, tags, energyLevel, focusLevel, stressLevel, activities, location, people, isQuickCheckIn];
}
