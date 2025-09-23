import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/task.dart';

class LocalizationService {
  static AppLocalizations? _localizations;

  static void initialize(BuildContext context) {
    try {
      _localizations = AppLocalizations.of(context);
    } catch (e) {
      // If localization fails, we'll use fallback values
      _localizations = null;
    }
  }

  static AppLocalizations get instance {
    if (_localizations == null) {
      throw Exception('LocalizationService not initialized. Call LocalizationService.initialize(context) first.');
    }
    return _localizations!;
  }

  // Pomodoro state labels with fallbacks
  static String get work => _localizations?.work ?? 'Work';
  static String get shortBreak => _localizations?.shortBreak ?? 'Short Break';
  static String get longBreak => _localizations?.longBreak ?? 'Long Break';
  static String get paused => _localizations?.paused ?? 'Paused';
  static String get idle => _localizations?.idle ?? 'Idle';
  static String get pomodoroSessionCompleted => _localizations?.pomodoroSessionCompleted ?? 'Pomodoro Session Completed';

  // Task priority labels with fallbacks
  static String getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return _localizations?.highPriorityLabel ?? 'Higsh';
      case TaskPriority.medium:
        return _localizations?.mediumPriorityLabel ?? 'Medium';
      case TaskPriority.low:
        return _localizations?.lowPriorityLabel ?? 'Low';
    }
  }
}
