import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'mood_achievement.g.dart';

/// Types of mood achievements
@HiveType(typeId: 120)
enum MoodAchievementType {
  @HiveField(0)
  firstCheckIn,
  @HiveField(1)
  weekStreak,
  @HiveField(2)
  monthStreak,
  @HiveField(3)
  checkIn30,
  @HiveField(4)
  checkIn100,
  @HiveField(5)
  checkIn365,
  @HiveField(6)
  consistencyChampion,
  @HiveField(7)
  selfAware,
  @HiveField(8)
  insightSeeker,
}

/// Represents an achievement in mood tracking
@HiveType(typeId: 121)
class MoodAchievement extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final MoodAchievementType type;

  @HiveField(2)
  final DateTime unlockedAt;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final String emoji;

  const MoodAchievement({required this.id, required this.type, required this.unlockedAt, required this.title, required this.description, required this.emoji});

  MoodAchievement copyWith({String? id, MoodAchievementType? type, DateTime? unlockedAt, String? title, String? description, String? emoji}) {
    return MoodAchievement(id: id ?? this.id, type: type ?? this.type, unlockedAt: unlockedAt ?? this.unlockedAt, title: title ?? this.title, description: description ?? this.description, emoji: emoji ?? this.emoji);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type.name, 'unlockedAt': unlockedAt.toIso8601String(), 'title': title, 'description': description, 'emoji': emoji};
  }

  factory MoodAchievement.fromJson(Map<String, dynamic> json) {
    return MoodAchievement(
      id: json['id'],
      type: MoodAchievementType.values.firstWhere((e) => e.name == json['type'], orElse: () => MoodAchievementType.firstCheckIn),
      unlockedAt: DateTime.parse(json['unlockedAt']),
      title: json['title'],
      description: json['description'],
      emoji: json['emoji'],
    );
  }

  @override
  List<Object?> get props => [id, type, unlockedAt, title, description, emoji];
}

/// Predefined achievements
class MoodAchievements {
  static MoodAchievement firstCheckIn(DateTime unlockedAt) =>
      MoodAchievement(id: 'first_check_in', type: MoodAchievementType.firstCheckIn, unlockedAt: unlockedAt, title: 'First Step', description: 'Completed your first mood check-in', emoji: '🌱');

  static MoodAchievement weekStreak(DateTime unlockedAt) =>
      MoodAchievement(id: 'week_streak', type: MoodAchievementType.weekStreak, unlockedAt: unlockedAt, title: 'Week Warrior', description: '7-day check-in streak', emoji: '🔥');

  static MoodAchievement monthStreak(DateTime unlockedAt) =>
      MoodAchievement(id: 'month_streak', type: MoodAchievementType.monthStreak, unlockedAt: unlockedAt, title: '30-Day Champion', description: '30-day check-in streak', emoji: '💪');

  static MoodAchievement checkIn30(DateTime unlockedAt) =>
      MoodAchievement(id: 'check_in_30', type: MoodAchievementType.checkIn30, unlockedAt: unlockedAt, title: 'Getting Started', description: 'Completed 30 mood check-ins', emoji: '🌟');

  static MoodAchievement checkIn100(DateTime unlockedAt) =>
      MoodAchievement(id: 'check_in_100', type: MoodAchievementType.checkIn100, unlockedAt: unlockedAt, title: 'Self-Aware', description: 'Completed 100 mood check-ins', emoji: '🎯');

  static MoodAchievement checkIn365(DateTime unlockedAt) =>
      MoodAchievement(id: 'check_in_365', type: MoodAchievementType.checkIn365, unlockedAt: unlockedAt, title: 'Year of Growth', description: 'Completed 365 mood check-ins', emoji: '🏆');

  static MoodAchievement consistencyChampion(DateTime unlockedAt) =>
      MoodAchievement(id: 'consistency_champion', type: MoodAchievementType.consistencyChampion, unlockedAt: unlockedAt, title: 'Consistency Champion', description: '90-day check-in streak', emoji: '👑');

  static MoodAchievement selfAware(DateTime unlockedAt) =>
      MoodAchievement(id: 'self_aware', type: MoodAchievementType.selfAware, unlockedAt: unlockedAt, title: 'Deeply Self-Aware', description: 'Added detailed notes to 50 check-ins', emoji: '🧠');

  static MoodAchievement insightSeeker(DateTime unlockedAt) =>
      MoodAchievement(id: 'insight_seeker', type: MoodAchievementType.insightSeeker, unlockedAt: unlockedAt, title: 'Insight Seeker', description: 'Viewed insights 20 times', emoji: '💡');
}
