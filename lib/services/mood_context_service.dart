import 'dart:math';
import '../../models/mood.dart';
import '../../l10n/app_localizations.dart';

/// Service for providing contextual mood suggestions and insights
class MoodContextService {
  static const Map<int, String> _timeOfDayEmojis = {
    5: '🌅', // Early morning
    8: '☀️', // Morning
    12: '🌞', // Noon
    15: '🌤️', // Afternoon
    18: '🌇', // Evening
    21: '🌙', // Night
  };

  static const Map<String, List<String>> _weatherMoodSuggestions = {
    'sunny': ['Great weather for outdoor activities!', 'Perfect day for a walk or exercise.', 'Sunny days often boost our mood.'],
    'cloudy': ['Cozy weather for reflection time.', 'Good day for indoor activities.', 'Cloudy days can be calming.'],
    'rainy': ['Perfect weather for reading or meditation.', 'Rain can be very peaceful.', 'Great time for self-care activities.'],
    'stormy': ['Stay safe and comfortable indoors.', 'Stormy weather can be intense.', 'Good time for deep reflection.'],
  };

  static const Map<String, List<String>> _activityMoodSuggestions = {
    'exercise': ['Exercise is great for boosting mood!', 'Physical activity releases endorphins.', 'Keep up the healthy habit!'],
    'work': ['Take regular breaks during work.', 'Remember to stay hydrated.', 'Work-life balance is important.'],
    'social': ['Social connections are vital for wellbeing.', 'Great that you\'re connecting with others!', 'Quality time with friends is precious.'],
    'relaxation': ['Relaxation is essential for mental health.', 'Taking time to rest is productive.', 'Self-care is not selfish!'],
  };

  /// Get contextual greeting based on time of day
  static String getTimeBasedGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  /// Get time-based mood suggestions
  static List<String> getTimeBasedSuggestions(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    final suggestions = <String>[];

    if (hour >= 5 && hour < 9) {
      // Morning suggestions
      suggestions.addAll(['Start your day with intention setting.', 'Morning meditation can set a positive tone.', 'Consider what you\'re grateful for today.']);
    } else if (hour >= 9 && hour < 12) {
      // Late morning
      suggestions.addAll(['How\'s your energy level this morning?', 'Take a moment to check in with yourself.', 'Consider your priorities for today.']);
    } else if (hour >= 12 && hour < 14) {
      // Noon
      suggestions.addAll(['Midday is perfect for a mental reset.', 'How are you handling today\'s challenges?', 'Remember to take a lunch break.']);
    } else if (hour >= 14 && hour < 17) {
      // Afternoon
      suggestions.addAll(['Afternoon slump? Try a short walk.', 'How\'s your focus holding up?', 'Consider a healthy snack boost.']);
    } else if (hour >= 17 && hour < 20) {
      // Evening
      suggestions.addAll(['Time to wind down from the day.', 'Reflect on today\'s accomplishments.', 'Consider what tomorrow might bring.']);
    } else {
      // Night
      suggestions.addAll(['Evening is for rest and recovery.', 'How was your emotional journey today?', 'Prepare for restful sleep.']);
    }

    return suggestions;
  }

  /// Get weather-based mood suggestions
  static List<String> getWeatherBasedSuggestions(String weatherCondition) {
    final condition = weatherCondition.toLowerCase();

    for (final key in _weatherMoodSuggestions.keys) {
      if (condition.contains(key)) {
        return _weatherMoodSuggestions[key] ?? [];
      }
    }

    return ['Whatever the weather, your mood matters.', 'Every day brings new opportunities.', 'How does the weather affect you today?'];
  }

  /// Get activity-based mood suggestions
  static List<String> getActivityBasedSuggestions(List<String> activities) {
    final suggestions = <String>[];

    for (final activity in activities) {
      final activityLower = activity.toLowerCase();

      for (final key in _activityMoodSuggestions.keys) {
        if (activityLower.contains(key)) {
          suggestions.addAll(_activityMoodSuggestions[key] ?? []);
        }
      }
    }

    if (suggestions.isEmpty) {
      suggestions.add('Interesting activities today!');
      suggestions.add('Your choices shape your experiences.');
    }

    return suggestions;
  }

  /// Get personalized mood insights based on recent patterns
  static List<String> getPatternBasedInsights(List<Mood> recentMoods, AppLocalizations l10n) {
    if (recentMoods.isEmpty) {
      return ['Start tracking to discover your patterns!'];
    }

    final insights = <String>[];

    // Analyze mood trends
    final recentMoodLevels = recentMoods.map((m) => m.level.index + 1).toList();
    final avgMood = recentMoodLevels.reduce((a, b) => a + b) / recentMoodLevels.length;

    if (avgMood >= 4) {
      insights.add('You\'ve been feeling great lately! Keep it up!');
    } else if (avgMood <= 2) {
      insights.add('You\'ve been going through a tough time. Be gentle with yourself.');
    } else {
      insights.add('Your moods have been balanced lately.');
    }

    // Analyze energy patterns
    final energyLevels = recentMoods.map((m) => m.energyLevel).toList();
    final avgEnergy = energyLevels.reduce((a, b) => a + b) / energyLevels.length;

    if (avgEnergy >= 7) {
      insights.add('High energy levels! Great time for new projects.');
    } else if (avgEnergy <= 4) {
      insights.add('Lower energy lately. Consider more rest.');
    }

    // Analyze stress patterns
    final stressLevels = recentMoods.map((m) => m.stressLevel).toList();
    final avgStress = stressLevels.reduce((a, b) => a + b) / stressLevels.length;

    if (avgStress >= 7) {
      insights.add('Stress levels seem high. Consider stress management techniques.');
    } else if (avgStress <= 4) {
      insights.add('You seem to be managing stress well!');
    }

    // Check for consistency
    if (recentMoods.length >= 7) {
      final lastWeekMoods = recentMoods.take(7).toList();
      final hasConsistentTracking = lastWeekMoods.every((mood) {
        final daysDiff = DateTime.now().difference(mood.date).inDays;
        return daysDiff < 7;
      });

      if (hasConsistentTracking) {
        insights.add('Great job tracking consistently! Your data is valuable.');
      }
    }

    return insights;
  }

  /// Get contextual emoji for current time
  static String getTimeBasedEmoji() {
    final hour = DateTime.now().hour;

    for (final entry in _timeOfDayEmojis.entries) {
      if (hour >= entry.key) {
        return entry.value;
      }
    }

    return '🌙'; // Default to night
  }

  /// Get motivational quote based on mood level
  static String getMotivationalQuote(MoodLevel mood, AppLocalizations l10n) {
    switch (mood) {
      case MoodLevel.very_bad:
        return 'This too shall pass. You\'re stronger than you think.';
      case MoodLevel.bad:
        return 'Tough days build stronger character. Keep going.';
      case MoodLevel.neutral:
        return 'Balance is a beautiful state. Embrace it.';
      case MoodLevel.good:
        return 'Your positive energy is contagious!';
      case MoodLevel.very_good:
        return 'You\'re radiating joy! Share it with the world.';
    }
  }

  /// Get personalized activity suggestions based on current mood
  static List<String> getActivitySuggestions(MoodLevel mood, AppLocalizations l10n) {
    switch (mood) {
      case MoodLevel.very_bad:
        return ['Gentle stretching or yoga', 'Listen to calming music', 'Journal your thoughts', 'Take a warm bath', 'Talk to a friend'];
      case MoodLevel.bad:
        return ['Go for a short walk', 'Watch a comforting movie', 'Practice deep breathing', 'Organize something small', 'Call a loved one'];
      case MoodLevel.neutral:
        return ['Try something new', 'Learn a small skill', 'Explore a new place', 'Read something interesting', 'Plan a future goal'];
      case MoodLevel.good:
        return ['Share your positivity', 'Tackle a creative project', 'Help someone else', 'Exercise or play sports', 'Socialize with friends'];
      case MoodLevel.very_good:
        return ['Celebrate your joy!', 'Start a new adventure', 'Teach someone something', 'Take on a challenge', 'Create something beautiful'];
    }
  }

  /// Get contextual notification message
  static String getContextualNotificationMessage(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    final random = Random();

    if (hour >= 8 && hour < 10) {
      final messages = ['Good morning! Time for your mood check-in.', 'How are you feeling this beautiful morning?', 'Start your day with mindfulness!'];
      return messages[random.nextInt(messages.length)];
    } else if (hour >= 18 && hour < 20) {
      final messages = ['Evening reflection time! How was your day?', 'Time to wind down and check in.', 'How did your emotional journey go today?'];
      return messages[random.nextInt(messages.length)];
    } else {
      final messages = ['Quick mood check-in moment!', 'How are you feeling right now?', 'Take a moment for yourself.'];
      return messages[random.nextInt(messages.length)];
    }
  }

  /// Analyze mood patterns and provide insights
  static Map<String, dynamic> analyzeMoodPatterns(List<Mood> moods) {
    if (moods.isEmpty) {
      return {'hasData': false, 'message': 'No mood data available for analysis.'};
    }

    final analysis = <String, dynamic>{};

    // Basic statistics
    final moodLevels = moods.map((m) => m.level.index + 1).toList();
    analysis['averageMood'] = moodLevels.reduce((a, b) => a + b) / moodLevels.length;
    analysis['totalEntries'] = moods.length;

    // Mood distribution
    final moodCounts = <MoodLevel, int>{};
    for (final mood in moods) {
      moodCounts[mood.level] = (moodCounts[mood.level] ?? 0) + 1;
    }
    analysis['moodDistribution'] = moodCounts;

    // Most common mood
    final mostCommonMood = moodCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    analysis['mostCommonMood'] = mostCommonMood;

    // Energy analysis
    final energyLevels = moods.map((m) => m.energyLevel).toList();
    analysis['averageEnergy'] = energyLevels.reduce((a, b) => a + b) / energyLevels.length;

    // Stress analysis
    final stressLevels = moods.map((m) => m.stressLevel).toList();
    analysis['averageStress'] = stressLevels.reduce((a, b) => a + b) / stressLevels.length;

    analysis['hasData'] = true;

    return analysis;
  }
}
