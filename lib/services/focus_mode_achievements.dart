import 'package:flutter/material.dart';
import '../../services/settings_service.dart';

class FocusModeAchievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int points;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress;
  final int currentCount;
  final int targetCount;

  FocusModeAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.points,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0.0,
    this.currentCount = 0,
    this.targetCount = 1,
  });

  FocusModeAchievement copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    Color? color,
    int? points,
    bool? isUnlocked,
    DateTime? unlockedAt,
    double? progress,
    int? currentCount,
    int? targetCount,
  }) {
    return FocusModeAchievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      points: points ?? this.points,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
      currentCount: currentCount ?? this.currentCount,
      targetCount: targetCount ?? this.targetCount,
    );
  }
}

class FocusModeAchievementSystem {
  static final List<FocusModeAchievement> _allAchievements = [
    // Basic Achievements
    FocusModeAchievement(id: 'focus_first_session', title: 'First Focus', description: 'Complete your first focus mode session', icon: Icons.center_focus_strong, color: Colors.green, points: 10),

    FocusModeAchievement(id: 'focus_5_sessions', title: 'Focus Beginner', description: 'Complete 5 focus mode sessions', icon: Icons.emoji_events, color: Colors.blue, points: 25, targetCount: 5),

    FocusModeAchievement(id: 'focus_10_sessions', title: 'Focus Enthusiast', description: 'Complete 10 focus mode sessions', icon: Icons.star, color: Colors.purple, points: 50, targetCount: 10),

    FocusModeAchievement(id: 'focus_25_sessions', title: 'Focus Expert', description: 'Complete 25 focus mode sessions', icon: Icons.military_tech, color: Colors.orange, points: 100, targetCount: 25),

    FocusModeAchievement(id: 'focus_50_sessions', title: 'Focus Master', description: 'Complete 50 focus mode sessions', icon: Icons.workspace_premium, color: Colors.red, points: 200, targetCount: 50),

    FocusModeAchievement(id: 'focus_100_sessions', title: 'Focus Legend', description: 'Complete 100 focus mode sessions', icon: Icons.diamond, color: Colors.amber, points: 500, targetCount: 100),

    // Streak Achievements
    FocusModeAchievement(id: 'focus_3_day_streak', title: 'Consistent Starter', description: 'Use focus mode for 3 days in a row', icon: Icons.local_fire_department, color: Colors.red, points: 30, targetCount: 3),

    FocusModeAchievement(id: 'focus_7_day_streak', title: 'Focus Warrior', description: 'Use focus mode for 7 days in a row', icon: Icons.local_fire_department, color: Colors.orange, points: 75, targetCount: 7),

    FocusModeAchievement(id: 'focus_30_day_streak', title: 'Focus Champion', description: 'Use focus mode for 30 days in a row', icon: Icons.local_fire_department, color: Colors.purple, points: 300, targetCount: 30),

    // Duration Achievements
    FocusModeAchievement(id: 'focus_1_hour_total', title: 'Hour of Focus', description: 'Accumulate 1 hour of focus time', icon: Icons.timer, color: Colors.blue, points: 20, targetCount: 60),

    FocusModeAchievement(id: 'focus_5_hours_total', title: 'Focus Marathon', description: 'Accumulate 5 hours of focus time', icon: Icons.timer, color: Colors.green, points: 50, targetCount: 300),

    FocusModeAchievement(id: 'focus_25_hours_total', title: 'Focus Ultra Marathon', description: 'Accumulate 25 hours of focus time', icon: Icons.timer, color: Colors.purple, points: 150, targetCount: 1500),

    FocusModeAchievement(id: 'focus_100_hours_total', title: 'Focus Century', description: 'Accumulate 100 hours of focus time', icon: Icons.timer, color: Colors.amber, points: 500, targetCount: 6000),

    // Session Length Achievements
    FocusModeAchievement(id: 'focus_30_min_session', title: 'Deep Focus', description: 'Complete a 30-minute focus session', icon: Icons.schedule, color: Colors.orange, points: 15, targetCount: 30),

    FocusModeAchievement(id: 'focus_60_min_session', title: 'Ultra Focus', description: 'Complete a 60-minute focus session', icon: Icons.schedule, color: Colors.red, points: 30, targetCount: 60),

    FocusModeAchievement(id: 'focus_120_min_session', title: 'Master Focus', description: 'Complete a 120-minute focus session', icon: Icons.schedule, color: Colors.purple, points: 50, targetCount: 120),

    // Special Achievements
    FocusModeAchievement(id: 'focus_early_bird', title: 'Early Bird', description: 'Complete a focus session before 9 AM', icon: Icons.wb_sunny, color: Colors.yellow, points: 25),

    FocusModeAchievement(id: 'focus_night_owl', title: 'Night Owl', description: 'Complete a focus session after 10 PM', icon: Icons.nights_stay, color: Colors.indigo, points: 25),

    FocusModeAchievement(id: 'focus_weekend_warrior', title: 'Weekend Warrior', description: 'Complete 5 focus sessions on weekends', icon: Icons.weekend, color: Colors.green, points: 40, targetCount: 5),

    FocusModeAchievement(id: 'focus_perfectionist', title: 'Perfectionist', description: 'Complete 10 focus sessions without interruption', icon: Icons.verified, color: Colors.blue, points: 75, targetCount: 10),

    FocusModeAchievement(id: 'focus_productivity_boost', title: 'Productivity Boost', description: 'Complete 3 focus sessions in one day', icon: Icons.trending_up, color: Colors.green, points: 35, targetCount: 3),
  ];

  static Future<List<FocusModeAchievement>> getAchievements() async {
    final achievementData = await SettingsService.getFocusModeAchievements();
    final unlockedAchievements = achievementData['unlocked'] ?? <String, dynamic>{};
    final progressData = achievementData['progress'] ?? <String, dynamic>{};

    return _allAchievements.map((achievement) {
      final isUnlocked = unlockedAchievements.containsKey(achievement.id);
      final unlockedAt = isUnlocked ? DateTime.parse(unlockedAchievements[achievement.id]) : null;
      final progress = progressData[achievement.id] ?? <String, dynamic>{};

      return achievement.copyWith(isUnlocked: isUnlocked, unlockedAt: unlockedAt, progress: progress['progress'] ?? 0.0, currentCount: progress['currentCount'] ?? 0);
    }).toList();
  }

  static Future<void> updateAchievementProgress(String achievementId, {double? progress, int? currentCount, int? increment}) async {
    final achievements = await getAchievements();
    final achievement = achievements.firstWhere((a) => a.id == achievementId);

    if (achievement.isUnlocked) return; // Already unlocked

    final newCount = currentCount ?? (achievement.currentCount + (increment ?? 1));
    final newProgress = progress ?? (newCount / achievement.targetCount).clamp(0.0, 1.0);

    // Save progress
    final achievementData = await SettingsService.getFocusModeAchievements();
    final progressData = achievementData['progress'] ?? <String, dynamic>{};

    progressData[achievementId] = {'progress': newProgress, 'currentCount': newCount};

    achievementData['progress'] = progressData;
    await SettingsService.saveFocusModeAchievements(achievementData);

    // Check if achievement should be unlocked
    if (newCount >= achievement.targetCount) {
      await unlockAchievement(achievementId);
    }
  }

  static Future<void> unlockAchievement(String achievementId) async {
    final achievementData = await SettingsService.getFocusModeAchievements();
    final unlockedAchievements = achievementData['unlocked'] ?? <String, dynamic>{};

    if (!unlockedAchievements.containsKey(achievementId)) {
      unlockedAchievements[achievementId] = DateTime.now().toIso8601String();
      achievementData['unlocked'] = unlockedAchievements;

      await SettingsService.saveFocusModeAchievements(achievementData);

      // Show achievement notification
      _showAchievementNotification(achievementId);
    }
  }

  static Future<void> checkSessionAchievements({required int sessionMinutes, required DateTime sessionTime, required bool wasCompleted}) async {
    // Update session count achievements
    await updateAchievementProgress('focus_first_session', increment: 1);
    await updateAchievementProgress('focus_5_sessions', increment: 1);
    await updateAchievementProgress('focus_10_sessions', increment: 1);
    await updateAchievementProgress('focus_25_sessions', increment: 1);
    await updateAchievementProgress('focus_50_sessions', increment: 1);
    await updateAchievementProgress('focus_100_sessions', increment: 1);

    // Update total time achievements
    await updateAchievementProgress('focus_1_hour_total', increment: sessionMinutes);
    await updateAchievementProgress('focus_5_hours_total', increment: sessionMinutes);
    await updateAchievementProgress('focus_25_hours_total', increment: sessionMinutes);
    await updateAchievementProgress('focus_100_hours_total', increment: sessionMinutes);

    // Update session length achievements
    if (sessionMinutes >= 30) {
      await unlockAchievement('focus_30_min_session');
    }
    if (sessionMinutes >= 60) {
      await unlockAchievement('focus_60_min_session');
    }
    if (sessionMinutes >= 120) {
      await unlockAchievement('focus_120_min_session');
    }

    // Update time-based achievements
    if (sessionTime.hour < 9) {
      await unlockAchievement('focus_early_bird');
    }
    if (sessionTime.hour >= 22) {
      await unlockAchievement('focus_night_owl');
    }
    if (sessionTime.weekday >= 6) {
      // Weekend
      await updateAchievementProgress('focus_weekend_warrior', increment: 1);
    }

    // Update completion-based achievements
    if (wasCompleted) {
      await updateAchievementProgress('focus_perfectionist', increment: 1);
    }

    // Update daily productivity
    await _checkDailyProductivity();

    // Update streak achievements
    await _updateStreakAchievements();
  }

  static Future<void> _checkDailyProductivity() async {
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month}-${today.day}';

    final achievementData = await SettingsService.getFocusModeAchievements();
    final dailyData = achievementData['daily'] ?? <String, dynamic>{};
    final todayData = dailyData[todayKey] ?? <String, dynamic>{};

    final sessionCount = (todayData['sessionCount'] ?? 0) + 1;
    todayData['sessionCount'] = sessionCount;

    dailyData[todayKey] = todayData;
    achievementData['daily'] = dailyData;

    await SettingsService.saveFocusModeAchievements(achievementData);

    // Check productivity boost achievement
    if (sessionCount >= 3) {
      await unlockAchievement('focus_productivity_boost');
    }
  }

  static Future<void> _updateStreakAchievements() async {
    final achievementData = await SettingsService.getFocusModeAchievements();
    final dailyData = achievementData['daily'] ?? <String, dynamic>{};

    // Calculate current streak
    int currentStreak = 0;
    DateTime currentDate = DateTime.now();

    for (int i = 0; i < 365; i++) {
      // Check up to a year
      final dateKey = '${currentDate.year}-${currentDate.month}-${currentDate.day}';

      if (dailyData.containsKey(dateKey) && (dailyData[dateKey]['sessionCount'] ?? 0) > 0) {
        currentStreak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    // Update streak achievements
    if (currentStreak >= 3) {
      await unlockAchievement('focus_3_day_streak');
    }
    if (currentStreak >= 7) {
      await unlockAchievement('focus_7_day_streak');
    }
    if (currentStreak >= 30) {
      await unlockAchievement('focus_30_day_streak');
    }
  }

  static Future<int> getTotalPoints() async {
    final achievements = await getAchievements();
    return achievements.where((a) => a.isUnlocked).fold<int>(0, (sum, a) => sum + a.points);
  }

  static Future<Map<String, dynamic>> getAchievementStats() async {
    final achievements = await getAchievements();
    final unlockedCount = achievements.where((a) => a.isUnlocked).length;
    final totalCount = achievements.length;
    final totalPoints = await getTotalPoints();

    return {'unlockedCount': unlockedCount, 'totalCount': totalCount, 'completionRate': unlockedCount / totalCount, 'totalPoints': totalPoints, 'nextAchievement': _getNextAchievement(achievements)};
  }

  static FocusModeAchievement? _getNextAchievement(List<FocusModeAchievement> achievements) {
    final lockedAchievements = achievements.where((a) => !a.isUnlocked).toList();

    if (lockedAchievements.isEmpty) return null;

    // Sort by progress (highest first)
    lockedAchievements.sort((a, b) => b.progress.compareTo(a.progress));

    return lockedAchievements.first;
  }

  static void _showAchievementNotification(String achievementId) {
    final achievement = _allAchievements.firstWhere((a) => a.id == achievementId);

    // This would integrate with your notification system
    // For now, we'll just log it
    print('Achievement Unlocked: ${achievement.title}');

    // You could show a dialog or banner here
    // Example:
    // NotificationService.showAchievementNotification(achievement);
  }
}

class FocusModeAchievementWidget extends StatelessWidget {
  final FocusModeAchievement achievement;
  final VoidCallback? onTap;

  const FocusModeAchievementWidget({super.key, required this.achievement, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: achievement.isUnlocked ? achievement.color.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: achievement.isUnlocked ? achievement.color.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.2), width: achievement.isUnlocked ? 2 : 1),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: achievement.isUnlocked ? achievement.color.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(achievement.icon, color: achievement.isUnlocked ? achievement.color : Colors.grey, size: 24),
        ),
        title: Text(
          achievement.title,
          style: TextStyle(fontWeight: FontWeight.w600, color: achievement.isUnlocked ? Theme.of(context).colorScheme.onSurface : Colors.grey),
        ),
        subtitle: Text(achievement.description, style: TextStyle(color: achievement.isUnlocked ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7) : Colors.grey)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!achievement.isUnlocked && achievement.targetCount > 1)
              Text(
                '${achievement.currentCount}/${achievement.targetCount}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
              ),
            if (achievement.isUnlocked) Icon(Icons.verified, color: achievement.color, size: 20),
            const SizedBox(height: 4),
            Text(
              '${achievement.points} pts',
              style: TextStyle(fontSize: 12, color: achievement.isUnlocked ? achievement.color : Colors.grey, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class FocusModeAchievementScreen extends StatefulWidget {
  const FocusModeAchievementScreen({super.key});

  @override
  State<FocusModeAchievementScreen> createState() => _FocusModeAchievementScreenState();
}

class _FocusModeAchievementScreenState extends State<FocusModeAchievementScreen> {
  List<FocusModeAchievement> _achievements = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    setState(() => _isLoading = true);

    try {
      _achievements = await FocusModeAchievementSystem.getAchievements();
      _stats = await FocusModeAchievementSystem.getAchievementStats();
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error loading achievements: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Focus Achievements'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: _loadAchievements)],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildStatsHeader(),
                Expanded(
                  child: ListView.builder(
                    itemCount: _achievements.length,
                    itemBuilder: (context, index) {
                      return FocusModeAchievementWidget(achievement: _achievements[index], onTap: () => _showAchievementDetails(_achievements[index]));
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatsHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary.withValues(alpha: 0.8), Theme.of(context).colorScheme.primary.withValues(alpha: 0.6)])),
      child: Column(
        children: [
          Text(
            'Achievement Stats',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Unlocked', '${_stats['unlockedCount']}/${_stats['totalCount']}', Icons.emoji_events),
              _buildStatItem('Completion', '${(_stats['completionRate'] * 100).toStringAsFixed(1)}%', Icons.trending_up),
              _buildStatItem('Points', '${_stats['totalPoints']}', Icons.star),
            ],
          ),
          if (_stats['nextAchievement'] != null) ...[
            const SizedBox(height: 16),
            Text('Next: ${_stats['nextAchievement'].title}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9))),
            const SizedBox(height: 4),
            LinearProgressIndicator(value: _stats['nextAchievement'].progress, backgroundColor: Colors.white.withValues(alpha: 0.3), valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.8))),
      ],
    );
  }

  void _showAchievementDetails(FocusModeAchievement achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(achievement.icon, color: achievement.color),
            const SizedBox(width: 12),
            Text(achievement.title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(achievement.description),
            const SizedBox(height: 16),
            if (achievement.targetCount > 1) ...[
              Text('Progress: ${achievement.currentCount}/${achievement.targetCount}'),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: achievement.progress, backgroundColor: Colors.grey.withValues(alpha: 0.3), valueColor: AlwaysStoppedAnimation<Color>(achievement.color)),
              const SizedBox(height: 16),
            ],
            Text('Points: ${achievement.points}'),
            if (achievement.isUnlocked) ...[const SizedBox(height: 8), Text('Unlocked: ${_formatDate(achievement.unlockedAt!)}', style: TextStyle(color: achievement.color))],
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Close'))],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
