import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'app_logging_service.dart';

/// Handles audio feedback and haptic responses for Pomodoro timer
class PomodoroAudioManager {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _enableSound = true;
  bool _enableVibration = true;

  bool get enableSound => _enableSound;
  bool get enableVibration => _enableVibration;

  void setSoundEnabled(bool enabled) {
    _enableSound = enabled;
  }

  void setVibrationEnabled(bool enabled) {
    _enableVibration = enabled;
  }

  Future<void> playCompletionFeedback() async {
    if (_enableVibration) {
      try {
        HapticFeedback.heavyImpact();
      } catch (e) {
        AppLogging.logError('Haptic feedback error: $e');
      }
    }

    if (_enableSound) {
      try {
        await _audioPlayer.play(AssetSource('sounds/task_complete_1.mp3'));
      } catch (e) {
        AppLogging.logError('Could not play completion sound: $e');
      }
    }
  }

  Future<void> playStartFeedback() async {
    if (_enableVibration) {
      try {
        HapticFeedback.lightImpact();
      } catch (e) {
        AppLogging.logError('Haptic feedback error: $e');
      }
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
