import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tazbeet/services/tutorial_service.dart';

/// Manages tutorial state and logic
class TutorialManager extends ChangeNotifier {
  final TutorialService _tutorialService = TutorialService();
  bool _hasShownTutorial = false;
  bool _hasShownPomodoroTutorial = false;

  bool get hasShownTutorial => _hasShownTutorial;
  bool get hasShownPomodoroTutorial => _hasShownPomodoroTutorial;

  Future<void> checkAndShowTutorial(
    BuildContext context, {
    required GlobalKey addTaskKey,
    required GlobalKey pomodoroKey,
    required GlobalKey categoryFilterKey,
    required GlobalKey moodTrackingKey,
    required GlobalKey taskDetailsKey,
  }) async {
    if (_hasShownTutorial) return;

    final prefs = await SharedPreferences.getInstance();
    final tutorialShown = prefs.getBool('hasShownTutorial') ?? false;

    if (!tutorialShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tutorialService.initTargets(addTaskKey: addTaskKey, pomodoroKey: pomodoroKey, categoryFilterKey: categoryFilterKey, moodTrackingKey: moodTrackingKey, taskDetailsKey: taskDetailsKey, context: context);
        _tutorialService.showTutorial(context, () {
          _hasShownTutorial = true;
          prefs.setBool('hasShownTutorial', true);
          notifyListeners();
        });
      });
    } else {
      _hasShownTutorial = true;
      notifyListeners();
    }
  }

  Future<void> checkAndShowPomodoroTutorial(
    BuildContext context, {
    required GlobalKey addTaskKey,
    required GlobalKey pomodoroKey,
    required GlobalKey categoryFilterKey,
    required GlobalKey moodTrackingKey,
    required GlobalKey taskDetailsKey,
  }) async {
    if (_hasShownPomodoroTutorial) return;

    final prefs = await SharedPreferences.getInstance();
    final hasShownPomodoroTutorial = prefs.getBool('hasShownPomodoroTutorial') ?? false;

    if (!hasShownPomodoroTutorial) {
      _tutorialService.initTargets(addTaskKey: addTaskKey, pomodoroKey: pomodoroKey, categoryFilterKey: categoryFilterKey, moodTrackingKey: moodTrackingKey, taskDetailsKey: taskDetailsKey, context: context);
      _tutorialService.showTutorial(context, () {
        _hasShownPomodoroTutorial = true;
        prefs.setBool('hasShownPomodoroTutorial', true);
        notifyListeners();
      }, targetIds: ['Pomodoro']);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
