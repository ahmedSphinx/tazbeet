import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'mood_streak.g.dart';

/// Represents mood check-in streak information
@HiveType(typeId: 36)
class MoodStreak extends Equatable {
  @HiveField(0)
  final int currentStreak;

  @HiveField(1)
  final int longestStreak;

  @HiveField(2)
  final DateTime lastCheckInDate;

  @HiveField(3)
  final int totalCheckIns;

  const MoodStreak({required this.currentStreak, required this.longestStreak, required this.lastCheckInDate, required this.totalCheckIns});

  MoodStreak copyWith({int? currentStreak, int? longestStreak, DateTime? lastCheckInDate, int? totalCheckIns}) {
    return MoodStreak(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCheckInDate: lastCheckInDate ?? this.lastCheckInDate,
      totalCheckIns: totalCheckIns ?? this.totalCheckIns,
    );
  }

  Map<String, dynamic> toJson() {
    return {'currentStreak': currentStreak, 'longestStreak': longestStreak, 'lastCheckInDate': lastCheckInDate.toIso8601String(), 'totalCheckIns': totalCheckIns};
  }

  factory MoodStreak.fromJson(Map<String, dynamic> json) {
    return MoodStreak(currentStreak: json['currentStreak'] ?? 0, longestStreak: json['longestStreak'] ?? 0, lastCheckInDate: DateTime.parse(json['lastCheckInDate']), totalCheckIns: json['totalCheckIns'] ?? 0);
  }

  factory MoodStreak.initial() {
    return MoodStreak(currentStreak: 0, longestStreak: 0, lastCheckInDate: DateTime.now(), totalCheckIns: 0);
  }

  /// Check if streak is still active (checked in today or yesterday)
  bool get isActive {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastCheckIn = DateTime(lastCheckInDate.year, lastCheckInDate.month, lastCheckInDate.day);
    final difference = today.difference(lastCheckIn).inDays;
    return difference <= 1;
  }

  /// Get streak status message
  String get statusMessage {
    if (currentStreak == 0) {
      return 'Start your streak today!';
    } else if (currentStreak == 1) {
      return '🔥 1 day streak!';
    } else if (currentStreak < 7) {
      return '🔥 $currentStreak day streak!';
    } else if (currentStreak < 30) {
      return '🔥 $currentStreak day streak! Amazing!';
    } else {
      return '🔥 $currentStreak day streak! Incredible!';
    }
  }

  /// Get days until next milestone
  int? get daysToNextMilestone {
    const milestones = [7, 14, 30, 60, 90, 180, 365];
    for (final milestone in milestones) {
      if (currentStreak < milestone) {
        return milestone - currentStreak;
      }
    }
    return null; // Already at max milestone
  }

  /// Get next milestone value
  int? get nextMilestone {
    const milestones = [7, 14, 30, 60, 90, 180, 365];
    for (final milestone in milestones) {
      if (currentStreak < milestone) {
        return milestone;
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [currentStreak, longestStreak, lastCheckInDate, totalCheckIns];
}
