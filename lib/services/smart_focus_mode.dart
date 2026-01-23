import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../services/focus_mode.dart';

class SmartFocusMode {
  static Future<void> enableSmartFocusMode({required Task task, bool autoDetect = true, int? customDuration}) async {
    // Analyze task characteristics
    final focusScore = task.focusScore;
    final estimatedTime = task.estimatedDuration;
    final complexity = task.subtasks.length;
    final hasDeadline = task.dueDate != null;
    final isOverdue = hasDeadline && task.dueDate!.isBefore(DateTime.now());

    // Auto-configure settings based on task analysis
    final customSettings = <String, dynamic>{
      'blockNotifications': _shouldBlockNotifications(focusScore, isOverdue),
      'playFocusAudio': _shouldPlayAudio(estimatedTime),
      'enableEyeBreakReminders': _shouldEnableEyeBreaks(estimatedTime),
      'audioType': _getRecommendedAudioType(task),
      'audioVolume': _getRecommendedVolume(focusScore),
      'enableHapticFeedback': _shouldEnableHaptics(focusScore),
      'showMotivationalQuotes': _shouldShowQuotes(focusScore),
      'dimNonEssentialUI': _shouldDimUI(focusScore),
      'blockSocialMedia': _shouldBlockSocialMedia(focusScore, estimatedTime),
    };

    // Calculate optimal duration if not specified
    final duration = customDuration ?? _calculateOptimalDuration(task, complexity, estimatedTime);

    await FocusMode.enableFocusMode(task: task, durationMinutes: duration, customSettings: customSettings);
  }

  static bool _shouldBlockNotifications(int focusScore, bool isOverdue) {
    // Block notifications for high-focus tasks or overdue items
    return focusScore >= 7 || isOverdue;
  }

  static bool _shouldPlayAudio(Duration estimatedTime) {
    // Play audio for sessions 30 minutes or longer
    return estimatedTime.inMinutes >= 30;
  }

  static bool _shouldEnableEyeBreaks(Duration estimatedTime) {
    // Enable eye breaks for sessions 45 minutes or longer
    return estimatedTime.inMinutes >= 45;
  }

  static String _getRecommendedAudioType(Task task) {
    final focusScore = task.focusScore;
    final tags = task.tags.map((tag) => tag.toLowerCase()).toList();

    // High focus tasks need white noise
    if (focusScore >= 8) return 'white_noise';

    // Creative tasks benefit from ambient sounds
    if (tags.contains('creative') || tags.contains('design')) return 'ambient';

    // Analytical tasks work well with instrumental
    if (tags.contains('analytical') || tags.contains('coding') || tags.contains('study')) return 'instrumental';

    // Default to nature sounds for general tasks
    return 'nature';
  }

  static double _getRecommendedVolume(int focusScore) {
    // Higher focus score = lower volume to avoid distraction
    switch (focusScore) {
      case 1:
      case 2:
        return 0.5; // Low focus - can handle more stimulation
      case 3:
      case 4:
      case 5:
        return 0.4; // Medium focus - balanced
      case 6:
      case 7:
        return 0.3; // High focus - reduced stimulation
      case 8:
      case 9:
      case 10:
        return 0.2; // Very high focus - minimal stimulation
      default:
        return 0.3;
    }
  }

  static bool _shouldEnableHaptics(int focusScore) {
    // Enable haptics for medium to high focus tasks
    return focusScore >= 4;
  }

  static bool _shouldShowQuotes(int focusScore) {
    // Show quotes for medium to high focus tasks
    return focusScore >= 5;
  }

  static bool _shouldDimUI(int focusScore) {
    // Dim UI for high focus tasks
    return focusScore >= 7;
  }

  static bool _shouldBlockSocialMedia(int focusScore, Duration estimatedTime) {
    // Block social media for high focus tasks or long sessions
    return focusScore >= 8 || estimatedTime.inMinutes >= 60;
  }

  static int _calculateOptimalDuration(Task task, int complexity, Duration estimatedTime) {
    final focusScore = task.focusScore;
    final baseMinutes = estimatedTime.inMinutes;

    // Adjust duration based on focus score
    double durationMultiplier = 1.0;

    if (focusScore >= 8) {
      // High focus tasks may need shorter sessions to maintain concentration
      durationMultiplier = 0.8;
    } else if (focusScore <= 3) {
      // Low focus tasks may benefit from longer sessions
      durationMultiplier = 1.2;
    }

    // Adjust for task complexity
    if (complexity > 5) {
      durationMultiplier *= 0.9; // Complex tasks need breaks
    } else if (complexity <= 2) {
      durationMultiplier *= 1.1; // Simple tasks can go longer
    }

    // Calculate final duration
    final calculatedMinutes = (baseMinutes * durationMultiplier).round();

    // Ensure minimum and maximum bounds
    return calculatedMinutes.clamp(15, 120);
  }

  static Map<String, dynamic> getFocusModeRecommendations(Task task) {
    final focusScore = task.focusScore;
    final estimatedTime = task.estimatedDuration;
    final complexity = task.subtasks.length;

    return {
      'recommendedDuration': _calculateOptimalDuration(task, complexity, estimatedTime),
      'recommendedBreakFrequency': _getBreakFrequency(focusScore, estimatedTime),
      'productivityTips': _getProductivityTips(task),
      'focusLevel': _getFocusLevelDescription(focusScore),
      'optimalWorkEnvironment': _getOptimalEnvironment(task),
    };
  }

  static String _getBreakFrequency(int focusScore, Duration estimatedTime) {
    if (focusScore >= 8) {
      return 'Every 20 minutes';
    } else if (focusScore >= 6) {
      return 'Every 25 minutes';
    } else if (estimatedTime.inMinutes >= 60) {
      return 'Every 30 minutes';
    } else {
      return 'Every 45 minutes';
    }
  }

  static List<String> _getProductivityTips(Task task) {
    final tips = <String>[];
    final focusScore = task.focusScore;
    final tags = task.tags;

    if (focusScore >= 7) {
      tips.add('Consider using noise-canceling headphones');
      tips.add('Keep your workspace clean and organized');
      tips.add('Use the Pomodoro technique for structured breaks');
    }

    if (tags.contains('creative')) {
      tips.add('Have a notebook nearby for ideas');
      tips.add('Change your environment periodically');
      tips.add('Take short walks to refresh creativity');
    }

    if (tags.contains('analytical') || tags.contains('coding')) {
      tips.add('Keep reference materials organized');
      tips.add('Use a second monitor if available');
      tips.add('Take regular screen breaks');
    }

    if (task.estimatedSessions > 1) {
      tips.add('This task may take multiple focus sessions');
      tips.add('Track your progress after each session');
    }

    return tips;
  }

  static String _getFocusLevelDescription(int focusScore) {
    switch (focusScore) {
      case 1:
      case 2:
        return 'Light Focus - Suitable for routine tasks';
      case 3:
      case 4:
        return 'Moderate Focus - Balanced approach';
      case 5:
      case 6:
        return 'Good Focus - Recommended for most tasks';
      case 7:
      case 8:
        return 'High Focus - Requires minimal distractions';
      case 9:
        return 'Very High Focus - Deep work environment';
      case 10:
        return 'Maximum Focus - Complete isolation';
      default:
        return 'Unknown Focus Level';
    }
  }

  static Map<String, String> _getOptimalEnvironment(Task task) {
    final focusScore = task.focusScore;
    final tags = task.tags.map((tag) => tag.toLowerCase()).toList();

    final environment = <String, String>{};

    // Lighting
    if (focusScore >= 7) {
      environment['lighting'] = 'Dim, warm lighting';
    } else if (tags.contains('creative')) {
      environment['lighting'] = 'Bright, natural light';
    } else {
      environment['lighting'] = 'Moderate, adjustable lighting';
    }

    // Noise level
    if (focusScore >= 8) {
      environment['noise'] = 'Quiet or white noise';
    } else if (focusScore <= 3) {
      environment['noise'] = 'Background music acceptable';
    } else {
      environment['noise'] = 'Minimal noise preferred';
    }

    // Temperature
    environment['temperature'] = 'Comfortable room temperature';

    // Workspace
    if (tags.contains('coding') || tags.contains('study')) {
      environment['workspace'] = 'Ergonomic setup recommended';
    } else {
      environment['workspace'] = 'Clean, organized space';
    }

    return environment;
  }
}
