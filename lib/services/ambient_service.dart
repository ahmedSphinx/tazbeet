import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AmbientSound {
  rain,
  ocean,
  forest,
  whiteNoise,
  cafe,
  fire,
  wind,
  thunderstorm,
}

class AmbientService extends ChangeNotifier {
  static final AmbientService _instance = AmbientService._internal();
  factory AmbientService() => _instance;
  AmbientService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  AmbientSound? _currentSound;
  bool _isPlaying = false;
  double _volume = 0.5;
  Timer? _fadeTimer;
  bool _isFading = false;

  // Getters
  AmbientSound? get currentSound => _currentSound;
  bool get isPlaying => _isPlaying;
  double get volume => _volume;
  bool get isFading => _isFading;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _volume = prefs.getDouble('ambient_volume') ?? 0.5;
    final savedSound = prefs.getString('ambient_sound');
    if (savedSound != null) {
      _currentSound = AmbientSound.values.firstWhere(
        (sound) => sound.name == savedSound,
        orElse: () => AmbientSound.rain,
      );
    }

    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying = false;
      notifyListeners();
    });
  }

  Future<void> playSound(AmbientSound sound) async {
    if (_currentSound == sound && _isPlaying) {
      await pause();
      return;
    }

    _currentSound = sound;
    await _savePreferences();

    final assetPath = _getAssetPath(sound);
    try {
      await _audioPlayer.setSource(AssetSource(assetPath));
      await _audioPlayer.setVolume(_volume);
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.resume();
    } catch (e) {
      debugPrint('Error playing ambient sound: $e');
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentSound = null;
    await _savePreferences();
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _audioPlayer.setVolume(_volume);
    await _savePreferences();
    notifyListeners();
  }

  Future<void> fadeIn({Duration duration = const Duration(seconds: 3)}) async {
    if (_isFading) return;

    _isFading = true;
    notifyListeners();

    const steps = 20;
    final stepDuration = duration.inMilliseconds ~/ steps;
    final volumeStep = _volume / steps;

    double currentVolume = 0.0;
    for (int i = 0; i < steps; i++) {
      currentVolume += volumeStep;
      await _audioPlayer.setVolume(currentVolume);
      await Future.delayed(Duration(milliseconds: stepDuration));
    }

    _isFading = false;
    notifyListeners();
  }

  Future<void> fadeOut({Duration duration = const Duration(seconds: 3)}) async {
    if (_isFading) return;

    _isFading = true;
    notifyListeners();

    const steps = 20;
    final stepDuration = duration.inMilliseconds ~/ steps;
    final volumeStep = _volume / steps;

    double currentVolume = _volume;
    for (int i = 0; i < steps; i++) {
      currentVolume -= volumeStep;
      if (currentVolume < 0) currentVolume = 0;
      await _audioPlayer.setVolume(currentVolume);
      await Future.delayed(Duration(milliseconds: stepDuration));
    }

    await _audioPlayer.pause();
    _isFading = false;
    notifyListeners();
  }

  String _getAssetPath(AmbientSound sound) {
    switch (sound) {
      case AmbientSound.rain:
        return 'sounds/rain.mp3';
      case AmbientSound.ocean:
        return 'sounds/ocean.mp3';
      case AmbientSound.forest:
        return 'sounds/forest.mp3';
      case AmbientSound.whiteNoise:
        return 'sounds/white_noise.mp3';
      case AmbientSound.cafe:
        return 'sounds/cafe.mp3';
      case AmbientSound.fire:
        return 'sounds/fire.mp3';
      case AmbientSound.wind:
        return 'sounds/wind.mp3';
      case AmbientSound.thunderstorm:
        return 'sounds/thunderstorm.mp3';
    }
  }

  String getSoundName(AmbientSound sound) {
    switch (sound) {
      case AmbientSound.rain:
        return 'Rain';
      case AmbientSound.ocean:
        return 'Ocean Waves';
      case AmbientSound.forest:
        return 'Forest';
      case AmbientSound.whiteNoise:
        return 'White Noise';
      case AmbientSound.cafe:
        return 'Coffee Shop';
      case AmbientSound.fire:
        return 'Fireplace';
      case AmbientSound.wind:
        return 'Wind';
      case AmbientSound.thunderstorm:
        return 'Thunderstorm';
    }
  }

  IconData getSoundIcon(AmbientSound sound) {
    switch (sound) {
      case AmbientSound.rain:
        return Icons.grain;
      case AmbientSound.ocean:
        return Icons.waves;
      case AmbientSound.forest:
        return Icons.forest;
      case AmbientSound.whiteNoise:
        return Icons.blur_on;
      case AmbientSound.cafe:
        return Icons.local_cafe;
      case AmbientSound.fire:
        return Icons.local_fire_department;
      case AmbientSound.wind:
        return Icons.air;
      case AmbientSound.thunderstorm:
        return Icons.thunderstorm;
    }
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('ambient_volume', _volume);
    if (_currentSound != null) {
      await prefs.setString('ambient_sound', _currentSound!.name);
    } else {
      await prefs.remove('ambient_sound');
    }
  }

  @override
  Future<void> dispose() async {
    _fadeTimer?.cancel();
    await _audioPlayer.dispose();
    super.dispose();
  }
}
