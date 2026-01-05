import 'package:hive/hive.dart';
import '../models/mood.dart';
import '../models/mood_achievement.dart';
import '../models/mood_streak.dart';
import 'app_logging_service.dart';

/// Service for managing mood achievements and streaks
class MoodAchievementService {
  static const String _streakBoxName = 'mood_streak';
  static const String _achievementsBoxName = 'mood_achievements';

  Box<MoodStreak>? _streakBox;
  Box<MoodAchievement>? _achievementsBox;

  /// Initialize the service
  Future<void> init() async {
    try {
      if (!Hive.isBoxOpen(_streakBoxName)) {
        _streakBox = await Hive.openBox<MoodStreak>(_streakBoxName);
      } else {
        _streakBox = Hive.box<MoodStreak>(_streakBoxName);
      }

      if (!Hive.isBoxOpen(_achievementsBoxName)) {
        _achievementsBox = await Hive.openBox<MoodAchievement>(_achievementsBoxName);
      } else {
        _achievementsBox = Hive.box<MoodAchievement>(_achievementsBoxName);
      }
    } catch (e) {
      AppLogging.logError('Failed to initialize MoodAchievementService: $e');
    }
  }

  /// Get current streak
  MoodStreak getCurrentStreak() {
    if (_streakBox == null || _streakBox!.isEmpty) {
      return MoodStreak.initial();
    }
    return _streakBox!.get('current', defaultValue: MoodStreak.initial())!;
  }

  /// Update streak after a mood check-in
  Future<MoodStreak> updateStreak(DateTime checkInDate) async {
    final currentStreak = getCurrentStreak();
    final lastCheckIn = DateTime(currentStreak.lastCheckInDate.year, currentStreak.lastCheckInDate.month, currentStreak.lastCheckInDate.day);
    final checkInDay = DateTime(checkInDate.year, checkInDate.month, checkInDate.day);

    final daysSinceLastCheckIn = checkInDay.difference(lastCheckIn).inDays;

    int newStreak;
    if (daysSinceLastCheckIn == 0) {
      // Same day, no change
      newStreak = currentStreak.currentStreak;
    } else if (daysSinceLastCheckIn == 1) {
      // Consecutive day, increment
      newStreak = currentStreak.currentStreak + 1;
    } else {
      // Streak broken, start over
      newStreak = 1;
    }

    final newLongestStreak = newStreak > currentStreak.longestStreak ? newStreak : currentStreak.longestStreak;

    final updatedStreak = MoodStreak(currentStreak: newStreak, longestStreak: newLongestStreak, lastCheckInDate: checkInDate, totalCheckIns: currentStreak.totalCheckIns + 1);

    await _streakBox?.put('current', updatedStreak);

    // Check for achievements
    await _checkAchievements(updatedStreak);

    return updatedStreak;
  }

  /// Check and unlock achievements
  Future<List<MoodAchievement>> _checkAchievements(MoodStreak streak) async {
    final newAchievements = <MoodAchievement>[];
    final now = DateTime.now();

    // First check-in
    if (streak.totalCheckIns == 1 && !_hasAchievement('first_check_in')) {
      final achievement = MoodAchievements.firstCheckIn(now);
      await _unlockAchievement(achievement);
      newAchievements.add(achievement);
    }

    // 7-day streak
    if (streak.currentStreak == 7 && !_hasAchievement('week_streak')) {
      final achievement = MoodAchievements.weekStreak(now);
      await _unlockAchievement(achievement);
      newAchievements.add(achievement);
    }

    // 30-day streak
    if (streak.currentStreak == 30 && !_hasAchievement('month_streak')) {
      final achievement = MoodAchievements.monthStreak(now);
      await _unlockAchievement(achievement);
      newAchievements.add(achievement);
    }

    // 90-day streak
    if (streak.currentStreak == 90 && !_hasAchievement('consistency_champion')) {
      final achievement = MoodAchievements.consistencyChampion(now);
      await _unlockAchievement(achievement);
      newAchievements.add(achievement);
    }

    // Total check-ins milestones
    if (streak.totalCheckIns == 30 && !_hasAchievement('check_in_30')) {
      final achievement = MoodAchievements.checkIn30(now);
      await _unlockAchievement(achievement);
      newAchievements.add(achievement);
    }

    if (streak.totalCheckIns == 100 && !_hasAchievement('check_in_100')) {
      final achievement = MoodAchievements.checkIn100(now);
      await _unlockAchievement(achievement);
      newAchievements.add(achievement);
    }

    if (streak.totalCheckIns == 365 && !_hasAchievement('check_in_365')) {
      final achievement = MoodAchievements.checkIn365(now);
      await _unlockAchievement(achievement);
      newAchievements.add(achievement);
    }

    return newAchievements;
  }

  /// Check if achievement is already unlocked
  bool _hasAchievement(String achievementId) {
    return _achievementsBox?.containsKey(achievementId) ?? false;
  }

  /// Unlock an achievement
  Future<void> _unlockAchievement(MoodAchievement achievement) async {
    await _achievementsBox?.put(achievement.id, achievement);
    AppLogging.logInfo('Achievement unlocked: ${achievement.title}');
  }

  /// Get all unlocked achievements
  List<MoodAchievement> getUnlockedAchievements() {
    return _achievementsBox?.values.toList() ?? [];
  }

  /// Get achievement progress
  Map<String, dynamic> getAchievementProgress(MoodStreak streak) {
    return {
      'firstCheckIn': streak.totalCheckIns >= 1,
      'weekStreak': streak.currentStreak >= 7,
      'monthStreak': streak.currentStreak >= 30,
      'consistencyChampion': streak.currentStreak >= 90,
      'checkIn30': streak.totalCheckIns >= 30,
      'checkIn100': streak.totalCheckIns >= 100,
      'checkIn365': streak.totalCheckIns >= 365,
      'nextMilestone': _getNextMilestone(streak),
    };
  }

  String _getNextMilestone(MoodStreak streak) {
    if (streak.currentStreak < 7) return '7-day streak';
    if (streak.currentStreak < 30) return '30-day streak';
    if (streak.currentStreak < 90) return '90-day streak';
    if (streak.totalCheckIns < 30) return '30 total check-ins';
    if (streak.totalCheckIns < 100) return '100 total check-ins';
    if (streak.totalCheckIns < 365) return '365 total check-ins';
    return 'All milestones achieved!';
  }

  /// Check for detailed notes achievement
  Future<void> checkDetailedNotesAchievement(List<Mood> moods) async {
    final moodsWithNotes = moods.where((m) => m.note != null && m.note!.length > 20).length;

    if (moodsWithNotes >= 50 && !_hasAchievement('self_aware')) {
      final achievement = MoodAchievements.selfAware(DateTime.now());
      await _unlockAchievement(achievement);
    }
  }
}
