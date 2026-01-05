import 'dart:async';
import 'dart:convert';
import 'package:tazbeet/services/app_logging_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';
import '../repositories/mood_repository.dart';

enum ThemeMode { system, light, dark }

enum NotificationFrequency { immediate, hourly, daily, weekly }

enum PomodoroPreset {
  classic, // 25/5/15
  short, // 15/3/10
  long, // 50/10/30
  custom,
}

class UserSettings {
  final ThemeMode themeMode;
  final bool enableNotifications;
  final NotificationFrequency notificationFrequency;
  final bool enableSound;
  final bool enableVibration;
  final PomodoroPreset pomodoroPreset;
  final int customWorkDuration;
  final int customShortBreakDuration;
  final int customLongBreakDuration;
  final int sessionsUntilLongBreak;
  final bool enableAutoBackup;
  final int backupFrequencyDays;
  final bool enableAnalytics;
  final bool enableCrashReporting;
  final String language;
  final String dateFormat;
  final String timeFormat;
  final bool enableHighContrast;
  final bool enableLargeText;
  final bool enableScreenReader;
  final bool enableMoodNotifications;
  final List<String> moodCheckInTimes; // Stored as HH:MM strings
  final bool voiceTaskEnabled;
  final bool hasSeenVoiceTaskTutorial;
  final bool autoStartRecording;
  final bool showTranscription;
  final bool keepAudioFiles;
  final bool instantMode;
  final Duration silenceTimeout;
  final double confidenceThreshold;

  const UserSettings({
    this.themeMode = ThemeMode.system,
    this.enableNotifications = true,
    this.notificationFrequency = NotificationFrequency.immediate,
    this.enableSound = true,
    this.enableVibration = true,
    this.pomodoroPreset = PomodoroPreset.classic,
    this.customWorkDuration = 25,
    this.customShortBreakDuration = 5,
    this.customLongBreakDuration = 15,
    this.sessionsUntilLongBreak = 4,
    this.enableAutoBackup = true,
    this.backupFrequencyDays = 7,
    this.enableAnalytics = false,
    this.enableCrashReporting = true,
    this.language = 'en',
    this.dateFormat = 'MM/dd/yyyy',
    this.timeFormat = '12h',
    this.enableHighContrast = false,
    this.enableLargeText = false,
    this.enableScreenReader = false,
    this.enableMoodNotifications = false,
    this.moodCheckInTimes = const ['09:00', '15:00', '21:00'], // Default times
    this.voiceTaskEnabled = true,
    this.hasSeenVoiceTaskTutorial = false,
    this.autoStartRecording = false,
    this.showTranscription = true,
    this.keepAudioFiles = true,
    this.instantMode = false,
    this.silenceTimeout = const Duration(seconds: 3),
    this.confidenceThreshold = 0.7,
  });

  UserSettings copyWith({
    ThemeMode? themeMode,
    bool? enableNotifications,
    NotificationFrequency? notificationFrequency,
    bool? enableSound,
    bool? enableVibration,
    PomodoroPreset? pomodoroPreset,
    int? customWorkDuration,
    int? customShortBreakDuration,
    int? customLongBreakDuration,
    int? sessionsUntilLongBreak,
    bool? enableAutoBackup,
    int? backupFrequencyDays,
    bool? enableAnalytics,
    bool? enableCrashReporting,
    String? language,
    String? dateFormat,
    String? timeFormat,
    bool? enableHighContrast,
    bool? enableLargeText,
    bool? enableScreenReader,
    bool? enableMoodNotifications,
    List<String>? moodCheckInTimes,
    bool? voiceTaskEnabled,
    bool? hasSeenVoiceTaskTutorial,
    bool? autoStartRecording,
    bool? showTranscription,
    bool? keepAudioFiles,
    bool? instantMode,
    Duration? silenceTimeout,
    double? confidenceThreshold,
  }) {
    return UserSettings(
      themeMode: themeMode ?? this.themeMode,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      notificationFrequency: notificationFrequency ?? this.notificationFrequency,
      enableSound: enableSound ?? this.enableSound,
      enableVibration: enableVibration ?? this.enableVibration,
      pomodoroPreset: pomodoroPreset ?? this.pomodoroPreset,
      customWorkDuration: customWorkDuration ?? this.customWorkDuration,
      customShortBreakDuration: customShortBreakDuration ?? this.customShortBreakDuration,
      customLongBreakDuration: customLongBreakDuration ?? this.customLongBreakDuration,
      sessionsUntilLongBreak: sessionsUntilLongBreak ?? this.sessionsUntilLongBreak,
      enableAutoBackup: enableAutoBackup ?? this.enableAutoBackup,
      backupFrequencyDays: backupFrequencyDays ?? this.backupFrequencyDays,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
      enableCrashReporting: enableCrashReporting ?? this.enableCrashReporting,
      language: language ?? this.language,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      enableHighContrast: enableHighContrast ?? this.enableHighContrast,
      enableLargeText: enableLargeText ?? this.enableLargeText,
      enableScreenReader: enableScreenReader ?? this.enableScreenReader,
      enableMoodNotifications: enableMoodNotifications ?? this.enableMoodNotifications,
      moodCheckInTimes: moodCheckInTimes ?? this.moodCheckInTimes,
      voiceTaskEnabled: voiceTaskEnabled ?? this.voiceTaskEnabled,
      hasSeenVoiceTaskTutorial: hasSeenVoiceTaskTutorial ?? this.hasSeenVoiceTaskTutorial,
      autoStartRecording: autoStartRecording ?? this.autoStartRecording,
      showTranscription: showTranscription ?? this.showTranscription,
      keepAudioFiles: keepAudioFiles ?? this.keepAudioFiles,
      instantMode: instantMode ?? this.instantMode,
      silenceTimeout: silenceTimeout ?? this.silenceTimeout,
      confidenceThreshold: confidenceThreshold ?? this.confidenceThreshold,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
      'enableNotifications': enableNotifications,
      'notificationFrequency': notificationFrequency.index,
      'enableSound': enableSound,
      'enableVibration': enableVibration,
      'pomodoroPreset': pomodoroPreset.index,
      'customWorkDuration': customWorkDuration,
      'customShortBreakDuration': customShortBreakDuration,
      'customLongBreakDuration': customLongBreakDuration,
      'sessionsUntilLongBreak': sessionsUntilLongBreak,
      'enableAutoBackup': enableAutoBackup,
      'backupFrequencyDays': backupFrequencyDays,
      'enableAnalytics': enableAnalytics,
      'enableCrashReporting': enableCrashReporting,
      'language': language,
      'dateFormat': dateFormat,
      'timeFormat': timeFormat,
      'enableHighContrast': enableHighContrast,
      'enableLargeText': enableLargeText,
      'enableScreenReader': enableScreenReader,
      'enableMoodNotifications': enableMoodNotifications,
      'moodCheckInTimes': moodCheckInTimes,
      'voiceTaskEnabled': voiceTaskEnabled,
      'hasSeenVoiceTaskTutorial': hasSeenVoiceTaskTutorial,
      'autoStartRecording': autoStartRecording,
      'showTranscription': showTranscription,
      'keepAudioFiles': keepAudioFiles,
      'instantMode': instantMode,
      'silenceTimeout': silenceTimeout.inMilliseconds,
      'confidenceThreshold': confidenceThreshold,
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      themeMode: ThemeMode.values[json['themeMode'] ?? 0],
      enableNotifications: json['enableNotifications'] ?? true,
      notificationFrequency: NotificationFrequency.values[json['notificationFrequency'] ?? 0],
      enableSound: json['enableSound'] ?? true,
      enableVibration: json['enableVibration'] ?? true,
      pomodoroPreset: PomodoroPreset.values[json['pomodoroPreset'] ?? 0],
      customWorkDuration: json['customWorkDuration'] ?? 25,
      customShortBreakDuration: json['customShortBreakDuration'] ?? 5,
      customLongBreakDuration: json['customLongBreakDuration'] ?? 15,
      sessionsUntilLongBreak: json['sessionsUntilLongBreak'] ?? 4,
      enableAutoBackup: json['enableAutoBackup'] ?? true,
      backupFrequencyDays: json['backupFrequencyDays'] ?? 7,
      enableAnalytics: json['enableAnalytics'] ?? false,
      enableCrashReporting: json['enableCrashReporting'] ?? true,
      language: json['language'] ?? 'en',
      dateFormat: json['dateFormat'] ?? 'MM/dd/yyyy',
      timeFormat: json['timeFormat'] ?? '12h',
      enableHighContrast: json['enableHighContrast'] ?? false,
      enableLargeText: json['enableLargeText'] ?? false,
      enableScreenReader: json['enableScreenReader'] ?? false,
      enableMoodNotifications: json['enableMoodNotifications'] ?? false,
      moodCheckInTimes: List<String>.from(json['moodCheckInTimes'] ?? ['09:00', '15:00', '21:00']),
      voiceTaskEnabled: json['voiceTaskEnabled'] ?? true,
      hasSeenVoiceTaskTutorial: json['hasSeenVoiceTaskTutorial'] ?? false,
      autoStartRecording: json['autoStartRecording'] ?? false,
      showTranscription: json['showTranscription'] ?? true,
      keepAudioFiles: json['keepAudioFiles'] ?? true,
      instantMode: json['instantMode'] ?? false,
      silenceTimeout: Duration(milliseconds: json['silenceTimeout'] ?? 3000),
      confidenceThreshold: (json['confidenceThreshold'] ?? 0.7).toDouble(),
    );
  }
}

class SettingsService extends ChangeNotifier {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  UserSettings _settings = const UserSettings();

  UserSettings get settings => _settings;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString('app_settings');
    if (settingsJson != null) {
      try {
        final decodedJson = jsonDecode(settingsJson);
        if (decodedJson is Map) {
          // Convert Map<dynamic, dynamic> to Map<String, dynamic> safely
          final Map<String, dynamic> convertedJson = {};
          decodedJson.forEach((key, value) {
            convertedJson[key.toString()] = value;
          });
          _settings = UserSettings.fromJson(convertedJson);
        }
      } catch (e) {
        AppLogging.logInfo('Error loading settings: $e');
        // Clear corrupted data and use default settings
        await prefs.remove('app_settings');
        _settings = const UserSettings();
      }
    }
    notifyListeners();
  }

  Future<void> updateSettings(UserSettings newSettings) async {
    _settings = newSettings;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> resetToDefaults() async {
    _settings = const UserSettings();
    await _saveSettings();
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_settings', jsonEncode(_settings.toJson()));
  }

  // Convenience methods for common settings
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await updateSettings(_settings.copyWith(themeMode: themeMode));
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await updateSettings(_settings.copyWith(enableNotifications: enabled));
  }

  Future<void> setNotificationFrequency(NotificationFrequency frequency) async {
    await updateSettings(_settings.copyWith(notificationFrequency: frequency));
  }

  Future<void> setPomodoroPreset(PomodoroPreset preset) async {
    await updateSettings(_settings.copyWith(pomodoroPreset: preset));
  }

  Future<void> setCustomPomodoroDurations({int? workDuration, int? shortBreakDuration, int? longBreakDuration, int? sessionsUntilLongBreak}) async {
    await updateSettings(_settings.copyWith(customWorkDuration: workDuration, customShortBreakDuration: shortBreakDuration, customLongBreakDuration: longBreakDuration, sessionsUntilLongBreak: sessionsUntilLongBreak));
  }

  Future<void> setMoodNotificationsEnabled(bool enabled) async {
    await updateSettings(_settings.copyWith(enableMoodNotifications: enabled));
    if (enabled) {
      await NotificationService().scheduleMoodCheckInNotifications(_settings.moodCheckInTimes);
    } else {
      await NotificationService().cancelMoodCheckInNotifications();
    }
  }

  // Voice Task Settings
  Future<void> setVoiceTaskEnabled(bool enabled) async {
    await updateSettings(_settings.copyWith(voiceTaskEnabled: enabled));
  }

  Future<void> setHasSeenVoiceTaskTutorial(bool seen) async {
    await updateSettings(_settings.copyWith(hasSeenVoiceTaskTutorial: seen));
  }

  Future<void> setAutoStartRecording(bool enabled) async {
    await updateSettings(_settings.copyWith(autoStartRecording: enabled));
  }

  Future<void> setShowTranscription(bool show) async {
    await updateSettings(_settings.copyWith(showTranscription: show));
  }

  Future<void> setKeepAudioFiles(bool keep) async {
    await updateSettings(_settings.copyWith(keepAudioFiles: keep));
  }

  Future<void> setInstantMode(bool enabled) async {
    await updateSettings(_settings.copyWith(instantMode: enabled));
  }

  Future<void> setSilenceTimeout(Duration timeout) async {
    await updateSettings(_settings.copyWith(silenceTimeout: timeout));
  }

  Future<void> setConfidenceThreshold(double threshold) async {
    await updateSettings(_settings.copyWith(confidenceThreshold: threshold));
  }

  // Voice Task Getters
  bool get voiceTaskEnabled => _settings.voiceTaskEnabled;
  bool get hasSeenVoiceTaskTutorial => _settings.hasSeenVoiceTaskTutorial;
  bool get autoStartRecording => _settings.autoStartRecording;
  bool get showTranscription => _settings.showTranscription;
  bool get keepAudioFiles => _settings.keepAudioFiles;
  bool get instantMode => _settings.instantMode;
  Duration get silenceTimeout => _settings.silenceTimeout;
  double get confidenceThreshold => _settings.confidenceThreshold;

  Future<void> setMoodCheckInTimes(List<String> times) async {
    // Validate times format (HH:MM)
    final validTimes = <String>[];
    for (final time in times) {
      final parts = time.split(':');
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null && hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
          validTimes.add(time);
        }
      }
    }

    if (validTimes.isEmpty) {
      // Fallback to defaults if all times are invalid
      validTimes.addAll(['09:00', '15:00', '21:00']);
    }

    await updateSettings(_settings.copyWith(moodCheckInTimes: validTimes));
    if (_settings.enableMoodNotifications) {
      await NotificationService().scheduleMoodCheckInNotifications(validTimes);
    }
  }

  Future<List<String>> getSuggestedMoodCheckInTimes() async {
    final moodRepository = MoodRepository();
    await moodRepository.init();
    return await moodRepository.getSuggestedCheckInTimes();
  }

  Future<void> addSuggestedMoodCheckInTimes() async {
    final suggestedTimes = await getSuggestedMoodCheckInTimes();
    final currentTimes = List<String>.from(_settings.moodCheckInTimes);

    // Add suggested times that are not already in the list
    for (final time in suggestedTimes) {
      if (!currentTimes.contains(time)) {
        currentTimes.add(time);
      }
    }

    await setMoodCheckInTimes(currentTimes);
  }

  // Get current Pomodoro durations based on preset
  int get currentWorkDuration {
    switch (_settings.pomodoroPreset) {
      case PomodoroPreset.classic:
        return 25;
      case PomodoroPreset.short:
        return 15;
      case PomodoroPreset.long:
        return 50;
      case PomodoroPreset.custom:
        return _settings.customWorkDuration;
    }
  }

  int get currentShortBreakDuration {
    switch (_settings.pomodoroPreset) {
      case PomodoroPreset.classic:
        return 5;
      case PomodoroPreset.short:
        return 3;
      case PomodoroPreset.long:
        return 10;
      case PomodoroPreset.custom:
        return _settings.customShortBreakDuration;
    }
  }

  int get currentLongBreakDuration {
    switch (_settings.pomodoroPreset) {
      case PomodoroPreset.classic:
        return 15;
      case PomodoroPreset.short:
        return 10;
      case PomodoroPreset.long:
        return 30;
      case PomodoroPreset.custom:
        return _settings.customLongBreakDuration;
    }
  }

  int get currentSessionsUntilLongBreak => _settings.sessionsUntilLongBreak;
}
