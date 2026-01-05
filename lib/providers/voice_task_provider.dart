import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tazbeet/services/settings_service.dart';

/// Voice Task Provider for state management
class VoiceTaskProvider extends ChangeNotifier {
  final SettingsService _settingsService = SettingsService();

  bool _isEnabled = false;
  bool _hasPermissions = false;
  bool _hasSeenTutorial = false;
  int _totalTasksCreated = 0;
  double _successRate = 0.0;

  // Getters
  bool get isEnabled => _isEnabled;
  bool get hasPermissions => _hasPermissions;
  bool get hasSeenTutorial => _hasSeenTutorial;
  int get totalTasksCreated => _totalTasksCreated;
  double get successRate => _successRate;

  VoiceTaskProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _isEnabled = _settingsService.voiceTaskEnabled;
    _hasSeenTutorial = _settingsService.hasSeenVoiceTaskTutorial;
    _hasPermissions = await _checkPermissions();
    _loadStatistics();
    notifyListeners();
  }

  Future<bool> _checkPermissions() async {
    try {
      // Check microphone permission
      final status = await Permission.microphone.status;
      _hasPermissions = status == PermissionStatus.granted;
      return _hasPermissions;
    } catch (e) {
      return false;
    }
  }

  Future<void> _loadStatistics() async {
    // TODO: Load actual statistics from database
    _totalTasksCreated = 0;
    _successRate = 0.0;
  }

  Future<void> enableVoiceTasks() async {
    await _settingsService.setVoiceTaskEnabled(true);
    _isEnabled = true;
    notifyListeners();
  }

  Future<void> disableVoiceTasks() async {
    await _settingsService.setVoiceTaskEnabled(false);
    _isEnabled = false;
    notifyListeners();
  }

  Future<void> markTutorialSeen() async {
    await _settingsService.setHasSeenVoiceTaskTutorial(true);
    _hasSeenTutorial = true;
    notifyListeners();
  }

  Future<void> updateStatistics({int? totalTasks, double? successRate}) async {
    if (totalTasks != null) {
      _totalTasksCreated = totalTasks;
    }
    if (successRate != null) {
      _successRate = successRate;
    }
    notifyListeners();
  }

  Future<void> refreshPermissions() async {
    _hasPermissions = await _checkPermissions();
    notifyListeners();
  }
}

/// Voice Task Settings Provider
class VoiceTaskSettingsProvider extends ChangeNotifier {
  final SettingsService _settingsService = SettingsService();

  bool _voiceTaskEnabled = false;
  bool _autoStartRecording = false;
  bool _showTranscription = true;
  bool _keepAudioFiles = true;
  bool _instantMode = false;
  Duration _silenceTimeout = const Duration(seconds: 3);
  double _confidenceThreshold = 0.7;

  // Getters
  bool get voiceTaskEnabled => _voiceTaskEnabled;
  bool get autoStartRecording => _autoStartRecording;
  bool get showTranscription => _showTranscription;
  bool get keepAudioFiles => _keepAudioFiles;
  bool get instantMode => _instantMode;
  Duration get silenceTimeout => _silenceTimeout;
  double get confidenceThreshold => _confidenceThreshold;

  VoiceTaskSettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _voiceTaskEnabled = _settingsService.voiceTaskEnabled;
    _autoStartRecording = _settingsService.autoStartRecording;
    _showTranscription = _settingsService.showTranscription;
    _keepAudioFiles = _settingsService.keepAudioFiles;
    _instantMode = _settingsService.instantMode;
    _silenceTimeout = _settingsService.silenceTimeout;
    _confidenceThreshold = _settingsService.confidenceThreshold;
    notifyListeners();
  }

  Future<void> setVoiceTaskEnabled(bool value) async {
    await _settingsService.setVoiceTaskEnabled(value);
    _voiceTaskEnabled = value;
    notifyListeners();
  }

  Future<void> setAutoStartRecording(bool value) async {
    await _settingsService.setAutoStartRecording(value);
    _autoStartRecording = value;
    notifyListeners();
  }

  Future<void> setShowTranscription(bool value) async {
    await _settingsService.setShowTranscription(value);
    _showTranscription = value;
    notifyListeners();
  }

  Future<void> setKeepAudioFiles(bool value) async {
    await _settingsService.setKeepAudioFiles(value);
    _keepAudioFiles = value;
    notifyListeners();
  }

  Future<void> setInstantMode(bool value) async {
    await _settingsService.setInstantMode(value);
    _instantMode = value;
    notifyListeners();
  }

  Future<void> setSilenceTimeout(Duration value) async {
    await _settingsService.setSilenceTimeout(value);
    _silenceTimeout = value;
    notifyListeners();
  }

  Future<void> setConfidenceThreshold(double value) async {
    await _settingsService.setConfidenceThreshold(value);
    _confidenceThreshold = value;
    notifyListeners();
  }
}

/// Voice Task Analytics Provider
class VoiceTaskAnalyticsProvider extends ChangeNotifier {
  Map<String, int> _categoryCount = {};
  Map<String, int> _priorityCount = {};
  Map<String, int> _timeOfDayCount = {};
  List<VoiceTaskSession> _recentSessions = [];
  int _totalSessions = 0;
  int _successfulSessions = 0;
  double _averageConfidence = 0.0;

  // Getters
  Map<String, int> get categoryCount => _categoryCount;
  Map<String, int> get priorityCount => _priorityCount;
  Map<String, int> get timeOfDayCount => _timeOfDayCount;
  List<VoiceTaskSession> get recentSessions => _recentSessions;
  int get totalSessions => _totalSessions;
  int get successfulSessions => _successfulSessions;
  double get averageConfidence => _averageConfidence;
  double get successRate => _totalSessions > 0 ? _successfulSessions / _totalSessions : 0.0;

  VoiceTaskAnalyticsProvider() {
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    // TODO: Load actual analytics from database
    _categoryCount = {};
    _priorityCount = {};
    _timeOfDayCount = {};
    _recentSessions = [];
    _totalSessions = 0;
    _successfulSessions = 0;
    _averageConfidence = 0.0;
    notifyListeners();
  }

  void recordSession(VoiceTaskSession session) {
    _recentSessions.insert(0, session);
    if (_recentSessions.length > 50) {
      _recentSessions.removeLast();
    }

    _totalSessions++;
    if (session.success) {
      _successfulSessions++;
    }

    // Update confidence average
    if (_totalSessions > 0) {
      final totalConfidence = _recentSessions.fold<double>(0.0, (sum, session) => sum + session.confidence);
      _averageConfidence = totalConfidence / _recentSessions.length;
    }

    // Update category counts (simplified for now)
    _categoryCount['General'] = (_categoryCount['General'] ?? 0) + session.tasks.length;
    _priorityCount['Medium'] = (_priorityCount['Medium'] ?? 0) + session.tasks.length;

    // Update time of day counts
    final hour = session.createdAt.hour;
    String timeSlot;
    if (hour < 12) {
      timeSlot = 'Morning';
    } else if (hour < 17) {
      timeSlot = 'Afternoon';
    } else {
      timeSlot = 'Evening';
    }
    _timeOfDayCount[timeSlot] = (_timeOfDayCount[timeSlot] ?? 0) + 1;

    notifyListeners();
  }

  Future<void> clearAnalytics() async {
    _categoryCount.clear();
    _priorityCount.clear();
    _timeOfDayCount.clear();
    _recentSessions.clear();
    _totalSessions = 0;
    _successfulSessions = 0;
    _averageConfidence = 0.0;
    notifyListeners();
  }
}

/// Voice Task Session Model
class VoiceTaskSession {
  final String id;
  final DateTime createdAt;
  final List<String> tasks;
  final double confidence;
  final bool success;
  final Duration duration;
  final String? transcription;

  VoiceTaskSession({required this.id, required this.createdAt, required this.tasks, required this.confidence, required this.success, required this.duration, this.transcription});
}

/// Voice Task Widget Provider
class VoiceTaskWidgetProvider extends ChangeNotifier {
  bool _isRecording = false;
  bool _isProcessing = false;
  String _currentTranscription = '';
  double _currentAmplitude = 0.0;
  bool _showTutorial = false;

  // Getters
  bool get isRecording => _isRecording;
  bool get isProcessing => _isProcessing;
  String get currentTranscription => _currentTranscription;
  double get currentAmplitude => _currentAmplitude;
  bool get showTutorial => _showTutorial;

  void setRecording(bool value) {
    _isRecording = value;
    notifyListeners();
  }

  void setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  void setTranscription(String value) {
    _currentTranscription = value;
    notifyListeners();
  }

  void setAmplitude(double value) {
    _currentAmplitude = value;
    notifyListeners();
  }

  void setShowTutorial(bool value) {
    _showTutorial = value;
    notifyListeners();
  }

  void reset() {
    _isRecording = false;
    _isProcessing = false;
    _currentTranscription = '';
    _currentAmplitude = 0.0;
    notifyListeners();
  }
}
