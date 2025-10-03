import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:tazbeet/services/app_logging.dart';

class TaskSoundService extends ChangeNotifier {
  static final TaskSoundService _instance = TaskSoundService._internal();
  factory TaskSoundService() => _instance;
  TaskSoundService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundEnabled = true;
  double _volume = 0.7;
  String _selectedSound = 'task_complete_1.mp3';

  // Available sound options
  static const Map<String, String> _availableSounds = {
    'task_complete_1.mp3': 'Task Complete 1',
    'task_complete_2.mp3': 'Task Complete 2',
    /*     'rain.mp3': 'Rain','ocean.mp3': 'Ocean','forest.mp3': 'Forest','white_noise.mp3': 'White Noise', */
  };

  // Getters
  bool get soundEnabled => _soundEnabled;
  double get volume => _volume;
  String get selectedSound => _selectedSound;
  Map<String, String> get availableSounds => _availableSounds;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('task_completion_sound_enabled') ?? true;
    _volume = prefs.getDouble('task_completion_sound_volume') ?? 0.7;
    _selectedSound = prefs.getString('task_completion_selected_sound') ?? 'task_complete_1.mp3';

    _audioPlayer.setVolume(_volume);
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> playTaskCompletionSound() async {
    if (!_soundEnabled) {
      AppLogging.logInfo('Task completion sound is disabled', name: 'TaskSoundService');
      return;
    }

    try {
      // Use the selected sound file
      await _audioPlayer.setSource(AssetSource('sounds/$_selectedSound'));
      await _audioPlayer.resume();

      AppLogging.logInfo('Task completion sound played successfully: $_selectedSound', name: 'TaskSoundService');
    } catch (e) {
      AppLogging.logError('Error playing task completion sound: $_selectedSound', name: 'TaskSoundService', error: e);
      // Fallback: try to use the first available sound
      try {
        await _audioPlayer.setSource(AssetSource('sounds/task_complete_1.mp3'));
        await _audioPlayer.resume();
      } catch (fallbackError) {
        AppLogging.logError('Fallback sound also failed', name: 'TaskSoundService', error: fallbackError);
      }
    }
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('task_completion_sound_enabled', enabled);
    notifyListeners();

    AppLogging.logInfo('Task completion sound enabled: $enabled', name: 'TaskSoundService');
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _audioPlayer.setVolume(_volume);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('task_completion_sound_volume', _volume);
    notifyListeners();

    AppLogging.logInfo('Task completion sound volume set to: $_volume', name: 'TaskSoundService');
  }

  Future<void> setSelectedSound(String soundFileName) async {
    _selectedSound = soundFileName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('task_completion_selected_sound', soundFileName);
    notifyListeners();

    AppLogging.logInfo('Task completion sound changed to: $_selectedSound', name: 'TaskSoundService');
  }

  @override
  Future<void> dispose() async {
    await _audioPlayer.dispose();
    super.dispose();
  }
}
