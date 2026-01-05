import 'package:flutter/material.dart';
import '../../../models/mood_streak.dart';

/// Widget to display mood check-in streak information
class StreakWidget extends StatelessWidget {
  final MoodStreak streak;
  final bool compact;

  const StreakWidget({super.key, required this.streak, this.compact = false});

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactView(context);
    }
    return _buildFullView(context);
  }

  Widget _buildCompactView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.orange.shade400, Colors.orange.shade600], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${streak.currentStreak} Day Streak',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (streak.nextMilestone != null) Text('${streak.daysToNextMilestone} days to ${streak.nextMilestone}', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFullView(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.orange.shade400, Colors.orange.shade600]),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('🔥', style: TextStyle(fontSize: 32)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current Streak', style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey.shade600)),
                      Text(
                        '${streak.currentStreak} Days',
                        style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.orange.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Stats
            Row(
              children: [
                Expanded(child: _buildStatItem(context, 'Longest', '${streak.longestStreak}', Icons.emoji_events, Colors.amber)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatItem(context, 'Total', '${streak.totalCheckIns}', Icons.check_circle, Colors.green)),
              ],
            ),

            // Next milestone
            if (streak.nextMilestone != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Icon(Icons.flag, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Next Milestone',
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.blue.shade700, fontWeight: FontWeight.w600),
                          ),
                          Text('${streak.daysToNextMilestone} days to ${streak.nextMilestone}', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.blue.shade900)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Motivation message
            const SizedBox(height: 16),
            Text(
              _getMotivationMessage(),
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon, Color color) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: color),
          ),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  String _getMotivationMessage() {
    if (streak.currentStreak == 0) {
      return 'Start your journey today! 🌱';
    } else if (streak.currentStreak == 1) {
      return 'Great start! Keep it going tomorrow! 💪';
    } else if (streak.currentStreak < 7) {
      return 'You\'re building a habit! Keep going! 🚀';
    } else if (streak.currentStreak < 30) {
      return 'Impressive consistency! You\'re doing amazing! ⭐';
    } else if (streak.currentStreak < 90) {
      return 'You\'re a mood tracking champion! 🏆';
    } else {
      return 'Legendary dedication! You\'re an inspiration! 👑';
    }
  }
}
