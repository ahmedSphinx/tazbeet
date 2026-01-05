import '../models/task.dart';
import 'enhanced_progress.dart';
import 'adaptive_pomodoro.dart';
import 'task_analytics.dart';

enum AchievementType {
  sessionCount, // Complete X sessions
  streak, // X days of consistent work
  taskCompletion, // Complete X tasks
  focusTime, // X hours of focus time
  productivity, // Maintain X% productivity
  consistency, // Work at same time regularly
  mastery, // Master a specific skill/task type
  special, // Special event achievements
}

enum AchievementDifficulty { bronze, silver, gold, platinum, diamond }

class Achievement {
  final String id;
  final String title;
  final String description;
  final AchievementType type;
  final AchievementDifficulty difficulty;
  final int targetValue;
  final String icon;
  final int points;
  final Map<String, dynamic>? metadata;
  final DateTime? unlockedAt;
  final bool isHidden;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.targetValue,
    required this.icon,
    required this.points,
    this.metadata,
    this.unlockedAt,
    this.isHidden = false,
  });

  Achievement copyWith({DateTime? unlockedAt}) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      type: type,
      difficulty: difficulty,
      targetValue: targetValue,
      icon: icon,
      points: points,
      metadata: metadata,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isHidden: isHidden,
    );
  }

  bool get isUnlocked => unlockedAt != null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'difficulty': difficulty.name,
      'targetValue': targetValue,
      'icon': icon,
      'points': points,
      'metadata': metadata,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'isHidden': isHidden,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: AchievementType.values.firstWhere((e) => e.name == json['type']),
      difficulty: AchievementDifficulty.values.firstWhere((e) => e.name == json['difficulty']),
      targetValue: json['targetValue'],
      icon: json['icon'],
      points: json['points'],
      metadata: json['metadata'],
      unlockedAt: json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt']) : null,
      isHidden: json['isHidden'] ?? false,
    );
  }
}

class AchievementSystem {
  final List<Achievement> _allAchievements;
  final List<Achievement> _unlockedAchievements;
  final Map<String, DateTime> _achievementHistory;
  int _totalPoints;

  AchievementSystem({List<Achievement>? unlockedAchievements, Map<String, DateTime>? achievementHistory})
    : _allAchievements = _createPredefinedAchievements(),
      _unlockedAchievements = unlockedAchievements ?? [],
      _achievementHistory = achievementHistory ?? {},
      _totalPoints = (unlockedAchievements ?? []).fold<int>(0, (sum, a) => sum + a.points);

  List<Achievement> get allAchievements => List.unmodifiable(_allAchievements);
  List<Achievement> get unlockedAchievements => List.unmodifiable(_unlockedAchievements);
  int get totalPoints => _totalPoints;
  Map<String, DateTime> get achievementHistory => Map.unmodifiable(_achievementHistory);

  /// Check and unlock achievements based on current data
  List<Achievement> checkAchievements({required List<Task> tasks, required ProgressTracker progressTracker, required AdaptivePomodoro adaptivePomodoro, required TaskAnalytics taskAnalytics}) {
    final newlyUnlocked = <Achievement>[];

    for (final achievement in _allAchievements) {
      if (achievement.isUnlocked) continue;

      bool shouldUnlock = false;

      switch (achievement.type) {
        case AchievementType.sessionCount:
          shouldUnlock = _checkSessionCountAchievement(achievement, tasks);
          break;
        case AchievementType.streak:
          shouldUnlock = _checkStreakAchievement(achievement, tasks);
          break;
        case AchievementType.taskCompletion:
          shouldUnlock = _checkTaskCompletionAchievement(achievement, tasks);
          break;
        case AchievementType.focusTime:
          shouldUnlock = _checkFocusTimeAchievement(achievement, tasks);
          break;
        case AchievementType.productivity:
          shouldUnlock = _checkProductivityAchievement(achievement, progressTracker);
          break;
        case AchievementType.consistency:
          shouldUnlock = _checkConsistencyAchievement(achievement, adaptivePomodoro);
          break;
        case AchievementType.mastery:
          shouldUnlock = _checkMasteryAchievement(achievement, tasks);
          break;
        case AchievementType.special:
          shouldUnlock = _checkSpecialAchievement(achievement, tasks, taskAnalytics);
          break;
      }

      if (shouldUnlock) {
        final unlockedAchievement = achievement.copyWith(unlockedAt: DateTime.now());
        _unlockedAchievements.add(unlockedAchievement);
        _achievementHistory[achievement.id] = DateTime.now();
        _totalPoints += achievement.points;
        newlyUnlocked.add(unlockedAchievement);
      }
    }

    return newlyUnlocked;
  }

  /// Get achievement progress for a specific achievement
  double getAchievementProgress(String achievementId) {
    final achievement = _allAchievements.firstWhere((a) => a.id == achievementId);
    if (achievement.isUnlocked) return 1.0;

    // This would need actual data to calculate progress
    // For now, return 0.0 as placeholder
    return 0.0;
  }

  /// Get next achievements to unlock
  List<Achievement> getNextAchievements({int maxCount = 3}) {
    final locked = _allAchievements.where((a) => !a.isUnlocked).toList();

    // Sort by difficulty and points (easier achievements first)
    locked.sort((a, b) {
      final difficultyComparison = a.difficulty.index.compareTo(b.difficulty.index);
      if (difficultyComparison != 0) return difficultyComparison;
      return a.points.compareTo(b.points);
    });

    return locked.take(maxCount).toList();
  }

  /// Get achievement statistics
  Map<String, dynamic> getAchievementStats() {
    final totalByDifficulty = <AchievementDifficulty, int>{};
    final unlockedByDifficulty = <AchievementDifficulty, int>{};
    final totalByType = <AchievementType, int>{};
    final unlockedByType = <AchievementType, int>{};

    for (final achievement in _allAchievements) {
      totalByDifficulty[achievement.difficulty] = (totalByDifficulty[achievement.difficulty] ?? 0) + 1;
      totalByType[achievement.type] = (totalByType[achievement.type] ?? 0) + 1;

      if (achievement.isUnlocked) {
        unlockedByDifficulty[achievement.difficulty] = (unlockedByDifficulty[achievement.difficulty] ?? 0) + 1;
        unlockedByType[achievement.type] = (unlockedByType[achievement.type] ?? 0) + 1;
      }
    }

    return {
      'totalAchievements': _allAchievements.length,
      'unlockedAchievements': _unlockedAchievements.length,
      'completionPercentage': (_unlockedAchievements.length / _allAchievements.length * 100).toStringAsFixed(1),
      'totalPoints': _totalPoints,
      'byDifficulty': {'total': totalByDifficulty.map((k, v) => MapEntry(k.name, v)), 'unlocked': unlockedByDifficulty.map((k, v) => MapEntry(k.name, v))},
      'byType': {'total': totalByType.map((k, v) => MapEntry(k.name, v)), 'unlocked': unlockedByType.map((k, v) => MapEntry(k.name, v))},
      'recentUnlocks': _getRecentUnlocks(),
    };
  }

  /// Get user level based on points
  int getUserLevel() {
    // Level calculation: every 100 points = 1 level
    return (_totalPoints / 100).floor() + 1;
  }

  /// Get points needed for next level
  int getPointsToNextLevel() {
    final currentLevel = getUserLevel();
    final pointsForNextLevel = currentLevel * 100;
    return pointsForNextLevel - _totalPoints;
  }

  /// Export achievement data
  Map<String, dynamic> exportData() {
    return {
      'unlockedAchievements': _unlockedAchievements.map((a) => a.toJson()).toList(),
      'achievementHistory': _achievementHistory.map((k, v) => MapEntry(k, v.toIso8601String())),
      'totalPoints': _totalPoints,
      'exportTimestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Import achievement data
  void importData(Map<String, dynamic> data) {
    if (data['unlockedAchievements'] != null) {
      _unlockedAchievements.clear();
      _unlockedAchievements.addAll((data['unlockedAchievements'] as List).map((a) => Achievement.fromJson(a as Map<String, dynamic>)));
    }

    if (data['achievementHistory'] != null) {
      _achievementHistory.clear();
      (data['achievementHistory'] as Map<String, dynamic>).forEach((k, v) {
        _achievementHistory[k] = DateTime.parse(v as String);
      });
    }

    _totalPoints = data['totalPoints'] ?? 0;
  }

  // Private helper methods

  static List<Achievement> _createPredefinedAchievements() {
    return [
      // Session Count Achievements
      Achievement(
        id: 'first_session',
        title: 'First Steps',
        description: 'Complete your first pomodoro session',
        type: AchievementType.sessionCount,
        difficulty: AchievementDifficulty.bronze,
        targetValue: 1,
        icon: '🍅',
        points: 10,
      ),
      Achievement(
        id: 'session_novice',
        title: 'Pomodoro Novice',
        description: 'Complete 25 pomodoro sessions',
        type: AchievementType.sessionCount,
        difficulty: AchievementDifficulty.bronze,
        targetValue: 25,
        icon: '🌱',
        points: 25,
      ),
      Achievement(
        id: 'session_expert',
        title: 'Pomodoro Expert',
        description: 'Complete 100 pomodoro sessions',
        type: AchievementType.sessionCount,
        difficulty: AchievementDifficulty.silver,
        targetValue: 100,
        icon: '⭐',
        points: 100,
      ),
      Achievement(
        id: 'session_master',
        title: 'Pomodoro Master',
        description: 'Complete 500 pomodoro sessions',
        type: AchievementType.sessionCount,
        difficulty: AchievementDifficulty.gold,
        targetValue: 500,
        icon: '👑',
        points: 500,
      ),

      // Streak Achievements
      Achievement(id: 'streak_3', title: 'Three Day Streak', description: 'Work consistently for 3 days', type: AchievementType.streak, difficulty: AchievementDifficulty.bronze, targetValue: 3, icon: '🔥', points: 30),
      Achievement(id: 'streak_7', title: 'Week Warrior', description: 'Work consistently for 7 days', type: AchievementType.streak, difficulty: AchievementDifficulty.silver, targetValue: 7, icon: '💪', points: 70),
      Achievement(id: 'streak_30', title: 'Monthly Champion', description: 'Work consistently for 30 days', type: AchievementType.streak, difficulty: AchievementDifficulty.gold, targetValue: 30, icon: '🏆', points: 300),

      // Task Completion Achievements
      Achievement(id: 'first_task', title: 'Task Starter', description: 'Complete your first task', type: AchievementType.taskCompletion, difficulty: AchievementDifficulty.bronze, targetValue: 1, icon: '✅', points: 15),
      Achievement(id: 'task_10', title: 'Task Achiever', description: 'Complete 10 tasks', type: AchievementType.taskCompletion, difficulty: AchievementDifficulty.bronze, targetValue: 10, icon: '📋', points: 50),
      Achievement(id: 'task_100', title: 'Task Master', description: 'Complete 100 tasks', type: AchievementType.taskCompletion, difficulty: AchievementDifficulty.gold, targetValue: 100, icon: '🎯', points: 400),

      // Focus Time Achievements
      Achievement(
        id: 'focus_1h',
        title: 'Focused Hour',
        description: 'Accumulate 1 hour of focus time',
        type: AchievementType.focusTime,
        difficulty: AchievementDifficulty.bronze,
        targetValue: 60, // minutes
        icon: '⏰',
        points: 20,
      ),
      Achievement(
        id: 'focus_10h',
        title: 'Focus Marathon',
        description: 'Accumulate 10 hours of focus time',
        type: AchievementType.focusTime,
        difficulty: AchievementDifficulty.silver,
        targetValue: 600, // minutes
        icon: '⏳',
        points: 150,
      ),
      Achievement(
        id: 'focus_100h',
        title: 'Focus Legend',
        description: 'Accumulate 100 hours of focus time',
        type: AchievementType.focusTime,
        difficulty: AchievementDifficulty.platinum,
        targetValue: 6000, // minutes
        icon: '🌟',
        points: 1000,
      ),

      // Productivity Achievements
      Achievement(
        id: 'productivity_80',
        title: 'Productivity Pro',
        description: 'Maintain 80% productivity for a week',
        type: AchievementType.productivity,
        difficulty: AchievementDifficulty.silver,
        targetValue: 80,
        icon: '📈',
        points: 120,
      ),
      Achievement(
        id: 'productivity_90',
        title: 'Peak Productivity',
        description: 'Maintain 90% productivity for a week',
        type: AchievementType.productivity,
        difficulty: AchievementDifficulty.gold,
        targetValue: 90,
        icon: '🚀',
        points: 250,
      ),

      // Consistency Achievements
      Achievement(
        id: 'consistency_morning',
        title: 'Early Bird',
        description: 'Work at the same time for 7 consecutive days',
        type: AchievementType.consistency,
        difficulty: AchievementDifficulty.silver,
        targetValue: 7,
        icon: '🌅',
        points: 80,
      ),
      Achievement(
        id: 'consistency_evening',
        title: 'Night Owl',
        description: 'Work in the evening for 7 consecutive days',
        type: AchievementType.consistency,
        difficulty: AchievementDifficulty.silver,
        targetValue: 7,
        icon: '🌙',
        points: 80,
      ),

      // Mastery Achievements
      Achievement(
        id: 'mastery_coding',
        title: 'Code Master',
        description: 'Complete 50 coding tasks',
        type: AchievementType.mastery,
        difficulty: AchievementDifficulty.gold,
        targetValue: 50,
        icon: '💻',
        points: 350,
        metadata: {'taskType': 'coding'},
      ),
      Achievement(
        id: 'mastery_writing',
        title: 'Writing Wizard',
        description: 'Complete 30 writing tasks',
        type: AchievementType.mastery,
        difficulty: AchievementDifficulty.gold,
        targetValue: 30,
        icon: '✍️',
        points: 300,
        metadata: {'taskType': 'writing'},
      ),

      // Special Achievements
      Achievement(
        id: 'special_perfect_day',
        title: 'Perfect Day',
        description: 'Complete all planned tasks in a single day',
        type: AchievementType.special,
        difficulty: AchievementDifficulty.gold,
        targetValue: 1,
        icon: '🌟',
        points: 200,
        isHidden: true,
      ),
      Achievement(
        id: 'special_speed_demon',
        title: 'Speed Demon',
        description: 'Complete a task 50% faster than estimated',
        type: AchievementType.special,
        difficulty: AchievementDifficulty.silver,
        targetValue: 1,
        icon: '⚡',
        points: 150,
        isHidden: true,
      ),
    ];
  }

  bool _checkSessionCountAchievement(Achievement achievement, List<Task> tasks) {
    final totalSessions = tasks.fold<int>(0, (sum, task) => sum + task.pomodoroCount);
    return totalSessions >= achievement.targetValue;
  }

  bool _checkStreakAchievement(Achievement achievement, List<Task> tasks) {
    // Calculate current streak based on recent work days
    final workDays = <DateTime>{};
    for (final task in tasks) {
      if (task.lastPomodoroDate != null) {
        workDays.add(DateTime(task.lastPomodoroDate!.year, task.lastPomodoroDate!.month, task.lastPomodoroDate!.day));
      }
    }

    if (workDays.isEmpty) return false;

    final sortedDays = workDays.toList()..sort();
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);

    // Check if today is a work day, or if yesterday was the most recent work day
    int streak = 0;
    DateTime currentDate = todayKey;

    for (int i = 0; i < 30; i++) {
      // Check up to 30 days back
      if (sortedDays.contains(currentDate)) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak >= achievement.targetValue;
  }

  bool _checkTaskCompletionAchievement(Achievement achievement, List<Task> tasks) {
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    return completedTasks >= achievement.targetValue;
  }

  bool _checkFocusTimeAchievement(Achievement achievement, List<Task> tasks) {
    final totalMinutes = tasks.fold<int>(0, (sum, task) => sum + task.timeSpent.inMinutes);
    return totalMinutes >= achievement.targetValue;
  }

  bool _checkProductivityAchievement(Achievement achievement, ProgressTracker progressTracker) {
    // This would need actual productivity data
    // For now, return false as placeholder
    return false;
  }

  bool _checkConsistencyAchievement(Achievement achievement, AdaptivePomodoro adaptivePomodoro) {
    // This would need actual consistency data
    // For now, return false as placeholder
    return false;
  }

  bool _checkMasteryAchievement(Achievement achievement, List<Task> tasks) {
    final taskType = achievement.metadata?['taskType'] as String?;
    if (taskType == null) return false;

    int typeCount = 0;
    for (final task in tasks) {
      if (task.isCompleted && _isTaskOfType(task, taskType)) {
        typeCount++;
      }
    }

    return typeCount >= achievement.targetValue;
  }

  bool _checkSpecialAchievement(Achievement achievement, List<Task> tasks, TaskAnalytics taskAnalytics) {
    // Special achievements would have custom logic
    // For now, return false as placeholder
    return false;
  }

  bool _isTaskOfType(Task task, String type) {
    final title = task.title.toLowerCase();

    switch (type) {
      case 'coding':
        return title.contains('code') || title.contains('program') || title.contains('develop');
      case 'writing':
        return title.contains('write') || title.contains('article') || title.contains('report');
      default:
        return false;
    }
  }

  List<Map<String, dynamic>> _getRecentUnlocks() {
    final recent = _achievementHistory.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return recent.take(5).map((entry) {
      final achievement = _allAchievements.firstWhere((a) => a.id == entry.key);
      return {'achievement': achievement.toJson(), 'unlockedAt': entry.value.toIso8601String()};
    }).toList();
  }
}

class AchievementNotification {
  final Achievement achievement;
  final DateTime timestamp;
  final String message;

  AchievementNotification({required this.achievement, required this.timestamp, required this.message});

  Map<String, dynamic> toJson() {
    return {'achievement': achievement.toJson(), 'timestamp': timestamp.toIso8601String(), 'message': message};
  }
}
