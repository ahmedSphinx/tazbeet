import '../models/mood.dart';
import '../models/mood_insight.dart';
import '../models/mood_tag.dart';

/// Service for generating insights from mood data
class MoodInsightsService {
  /// Generate insights from mood history
  List<MoodInsight> generateInsights(List<Mood> moods) {
    if (moods.isEmpty) return [];

    final insights = <MoodInsight>[];
    final now = DateTime.now();

    // Pattern insights
    insights.addAll(_generatePatternInsights(moods, now));

    // Correlation insights
    insights.addAll(_generateCorrelationInsights(moods, now));

    // Trend insights
    insights.addAll(_generateTrendInsights(moods, now));

    // Recommendation insights
    insights.addAll(_generateRecommendations(moods, now));

    return insights;
  }

  /// Generate weekly mood summary
  WeeklyMoodSummary generateWeeklySummary(List<Mood> moods) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final weekMoods = moods.where((m) => m.date.isAfter(weekAgo)).toList();

    if (weekMoods.isEmpty) {
      return const WeeklyMoodSummary(goodDays: 0, neutralDays: 0, badDays: 0, averageEnergy: 5.0, averageFocus: 5.0, averageStress: 5.0, dominantMood: 'neutral', topTags: []);
    }

    int goodDays = 0;
    int neutralDays = 0;
    int badDays = 0;
    double totalEnergy = 0;
    double totalFocus = 0;
    double totalStress = 0;
    final tagCounts = <String, int>{};

    for (final mood in weekMoods) {
      if (mood.level == MoodLevel.good || mood.level == MoodLevel.very_good) {
        goodDays++;
      } else if (mood.level == MoodLevel.neutral) {
        neutralDays++;
      } else {
        badDays++;
      }

      totalEnergy += mood.energyLevel;
      totalFocus += mood.focusLevel;
      totalStress += mood.stressLevel;

      for (final tag in mood.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }

    final count = weekMoods.length;
    final topTags = tagCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    String dominantMood;
    if (goodDays > neutralDays && goodDays > badDays) {
      dominantMood = 'good';
    } else if (badDays > goodDays && badDays > neutralDays) {
      dominantMood = 'bad';
    } else {
      dominantMood = 'neutral';
    }

    return WeeklyMoodSummary(
      goodDays: goodDays,
      neutralDays: neutralDays,
      badDays: badDays,
      averageEnergy: totalEnergy / count,
      averageFocus: totalFocus / count,
      averageStress: totalStress / count,
      dominantMood: dominantMood,
      topTags: topTags.take(5).map((e) => e.key).toList(),
    );
  }

  List<MoodInsight> _generatePatternInsights(List<Mood> moods, DateTime now) {
    final insights = <MoodInsight>[];

    // Day of week patterns
    final dayOfWeekMoods = <int, List<Mood>>{};
    for (final mood in moods) {
      final day = mood.date.weekday;
      dayOfWeekMoods.putIfAbsent(day, () => []).add(mood);
    }

    // Find challenging days
    for (final entry in dayOfWeekMoods.entries) {
      final badMoodCount = entry.value.where((m) => m.level == MoodLevel.bad || m.level == MoodLevel.very_bad).length;

      if (badMoodCount / entry.value.length > 0.6 && entry.value.length >= 3) {
        final dayName = _getDayName(entry.key);
        insights.add(
          MoodInsight(
            id: 'pattern_${entry.key}',
            type: MoodInsightType.pattern,
            title: '$dayName Challenge',
            description: '$dayName tends to be tough for you. Consider planning something positive.',
            emoji: '📅',
            generatedAt: now,
            data: {'day': entry.key, 'percentage': badMoodCount / entry.value.length},
          ),
        );
      }
    }

    // Time of day patterns
    final morningMoods = moods.where((m) => m.date.hour < 12).toList();
    final eveningMoods = moods.where((m) => m.date.hour >= 18).toList();

    if (morningMoods.length >= 5) {
      final goodMornings = morningMoods.where((m) => m.level == MoodLevel.good || m.level == MoodLevel.very_good).length;

      if (goodMornings / morningMoods.length > 0.7) {
        insights.add(
          MoodInsight(
            id: 'pattern_morning',
            type: MoodInsightType.pattern,
            title: 'Morning Person',
            description: 'You tend to feel better in the mornings. Schedule important tasks early!',
            emoji: '🌅',
            generatedAt: now,
          ),
        );
      }
    }

    if (eveningMoods.length >= 5) {
      final badEvenings = eveningMoods.where((m) => m.level == MoodLevel.bad || m.level == MoodLevel.very_bad).length;

      if (badEvenings / eveningMoods.length > 0.6) {
        insights.add(
          MoodInsight(id: 'pattern_evening', type: MoodInsightType.pattern, title: 'Evening Dip', description: 'Your mood tends to dip in the evenings. Consider a relaxing routine.', emoji: '🌆', generatedAt: now),
        );
      }
    }

    return insights;
  }

  List<MoodInsight> _generateCorrelationInsights(List<Mood> moods, DateTime now) {
    final insights = <MoodInsight>[];

    // Tag correlations
    final tagMoodScores = <String, List<double>>{};

    for (final mood in moods) {
      final score = _moodToScore(mood.level);
      for (final tag in mood.tags) {
        tagMoodScores.putIfAbsent(tag, () => []).add(score);
      }
    }

    // Find positive correlations
    for (final entry in tagMoodScores.entries) {
      if (entry.value.length < 3) continue;

      final avgScore = entry.value.reduce((a, b) => a + b) / entry.value.length;

      if (avgScore >= 4.0) {
        final tagLabel = _getTagLabel(entry.key);
        insights.add(
          MoodInsight(
            id: 'correlation_${entry.key}',
            type: MoodInsightType.correlation,
            title: '$tagLabel Boost',
            description: 'You feel better when $tagLabel. Try to do it more often!',
            emoji: '💡',
            generatedAt: now,
            data: {'tag': entry.key, 'score': avgScore},
          ),
        );
      } else if (avgScore <= 2.5) {
        final tagLabel = _getTagLabel(entry.key);
        insights.add(
          MoodInsight(
            id: 'correlation_neg_${entry.key}',
            type: MoodInsightType.correlation,
            title: '$tagLabel Impact',
            description: '$tagLabel seems to affect your mood negatively. Consider alternatives.',
            emoji: '⚠️',
            generatedAt: now,
            data: {'tag': entry.key, 'score': avgScore},
          ),
        );
      }
    }

    return insights;
  }

  List<MoodInsight> _generateTrendInsights(List<Mood> moods, DateTime now) {
    final insights = <MoodInsight>[];

    if (moods.length < 7) return insights;

    final recentMoods = moods.take(7).toList();
    final olderMoods = moods.skip(7).take(7).toList();

    if (olderMoods.isEmpty) return insights;

    final recentAvg = recentMoods.map((m) => _moodToScore(m.level)).reduce((a, b) => a + b) / recentMoods.length;
    final olderAvg = olderMoods.map((m) => _moodToScore(m.level)).reduce((a, b) => a + b) / olderMoods.length;

    final difference = recentAvg - olderAvg;

    if (difference > 0.5) {
      insights.add(MoodInsight(id: 'trend_improving', type: MoodInsightType.trend, title: 'Upward Trend', description: 'Your mood has been improving lately! Keep up the good work! 📈', emoji: '📈', generatedAt: now));
    } else if (difference < -0.5) {
      insights.add(
        MoodInsight(id: 'trend_declining', type: MoodInsightType.trend, title: 'Need Support?', description: 'Your mood has been lower recently. Consider reaching out to someone.', emoji: '💙', generatedAt: now),
      );
    }

    // Energy trend
    final recentEnergy = recentMoods.map((m) => m.energyLevel).reduce((a, b) => a + b) / recentMoods.length;
    final olderEnergy = olderMoods.map((m) => m.energyLevel).reduce((a, b) => a + b) / olderMoods.length;

    if (recentEnergy - olderEnergy > 2) {
      insights.add(MoodInsight(id: 'trend_energy', type: MoodInsightType.trend, title: 'Energy Boost', description: 'Your energy levels are up! Great time to tackle challenging tasks.', emoji: '⚡', generatedAt: now));
    }

    return insights;
  }

  List<MoodInsight> _generateRecommendations(List<Mood> moods, DateTime now) {
    final insights = <MoodInsight>[];

    if (moods.isEmpty) return insights;

    final recentMood = moods.first;

    // Recommendations based on current mood
    if (recentMood.level == MoodLevel.bad || recentMood.level == MoodLevel.very_bad) {
      insights.add(
        MoodInsight(id: 'rec_low_mood', type: MoodInsightType.recommendation, title: 'Try This', description: 'Take a 5-minute walk, call a friend, or do a breathing exercise.', emoji: '💙', generatedAt: now),
      );
    }

    if (recentMood.stressLevel > 7) {
      insights.add(
        MoodInsight(id: 'rec_stress', type: MoodInsightType.recommendation, title: 'Stress Relief', description: 'High stress detected. Try deep breathing, meditation, or a short break.', emoji: '🧘', generatedAt: now),
      );
    }

    if (recentMood.energyLevel < 4) {
      insights.add(
        MoodInsight(id: 'rec_energy', type: MoodInsightType.recommendation, title: 'Energy Boost', description: 'Feeling drained? Try a healthy snack, quick walk, or power nap.', emoji: '🔋', generatedAt: now),
      );
    }

    return insights;
  }

  double _moodToScore(MoodLevel level) {
    switch (level) {
      case MoodLevel.very_bad:
        return 1.0;
      case MoodLevel.bad:
        return 2.0;
      case MoodLevel.neutral:
        return 3.0;
      case MoodLevel.good:
        return 4.0;
      case MoodLevel.very_good:
        return 5.0;
    }
  }

  String _getDayName(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }

  String _getTagLabel(String tagId) {
    final tag = MoodTags.allTags.where((t) => t.id == tagId).firstOrNull;
    if (tag != null) {
      return tag.label.toLowerCase();
    }
    return tagId.replaceAll('_', ' ');
  }
}
