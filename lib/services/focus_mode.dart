import 'dart:async';
import 'dart:io';
import '../models/task.dart';

class FocusMode {
  static bool _isActive = false;
  static Timer? _focusTimer;
  static StreamController<FocusModeEvent>? _eventController;
  static final Map<String, dynamic> _settings = {
    'blockNotifications': true,
    'dimNonEssentialUI': true,
    'showOnlyTaskNotifications': true,
    'enableDoNotDisturb': false, // Platform dependent
    'blockSocialMedia': false, // Platform dependent
    'playFocusAudio': true,
    'audioType': 'ambient', // ambient, white_noise, nature, instrumental
    'volume': 0.3,
    'enableHapticFeedback': true,
    'showMotivationalQuotes': true,
    'enableEyeBreakReminders': true,
  };

  static Stream<FocusModeEvent> get events {
    _eventController ??= StreamController<FocusModeEvent>.broadcast();
    return _eventController!.stream;
  }

  static bool get isActive => _isActive;

  static Map<String, dynamic> get settings => Map.unmodifiable(_settings);

  /// Enable focus mode with optional task context
  static Future<void> enableFocusMode({Task? task, int? durationMinutes, Map<String, dynamic>? customSettings}) async {
    if (_isActive) return;

    // Apply custom settings if provided
    if (customSettings != null) {
      _settings.addAll(customSettings);
    }

    _isActive = true;

    // Emit focus mode started event
    _emitEvent(FocusModeEvent(type: FocusModeEventType.started, task: task, timestamp: DateTime.now(), data: {'settings': _settings}));

    try {
      // Enable focus features
      await _enableFocusFeatures(task);

      // Set timer if duration specified
      if (durationMinutes != null) {
        _focusTimer = Timer(Duration(minutes: durationMinutes), () {
          disableFocusMode(reason: 'Timer completed');
        });
      }
    } catch (e) {
      _isActive = false;
      _emitEvent(FocusModeEvent(type: FocusModeEventType.error, timestamp: DateTime.now(), data: {'error': e.toString()}));
    }
  }

  /// Disable focus mode
  static Future<void> disableFocusMode({String? reason}) async {
    if (!_isActive) return;

    _isActive = false;
    _focusTimer?.cancel();
    _focusTimer = null;

    // Emit focus mode ended event
    _emitEvent(FocusModeEvent(type: FocusModeEventType.ended, timestamp: DateTime.now(), data: {'reason': reason ?? 'Manual disable'}));

    try {
      // Disable focus features
      await _disableFocusFeatures();
    } catch (e) {
      _emitEvent(FocusModeEvent(type: FocusModeEventType.error, timestamp: DateTime.now(), data: {'error': e.toString()}));
    }
  }

  /// Update focus mode settings
  static void updateSettings(Map<String, dynamic> newSettings) {
    _settings.addAll(newSettings);

    if (_isActive) {
      // Reapply settings if focus mode is active
      _emitEvent(FocusModeEvent(type: FocusModeEventType.settingsUpdated, timestamp: DateTime.now(), data: {'settings': _settings}));
    }
  }

  /// Get motivational quote for focus
  static String getMotivationalQuote() {
    final quotes = [
      'Focus on being productive instead of busy.',
      'The secret of getting ahead is getting started.',
      'Don\'t watch the clock; do what it does. Keep going.',
      'Success is the sum of small efforts repeated day in and day out.',
      'The only way to do great work is to love what you do.',
      'Focus on progress, not perfection.',
      'Your limitation—it\'s only your imagination.',
      'Great things never come from comfort zones.',
      'Dream it. Wish it. Do it.',
      'Success doesn\'t just find you. You have to go out and get it.',
    ];

    return quotes[DateTime.now().millisecondsSinceEpoch % quotes.length];
  }

  /// Check if it's time for an eye break (every 20 minutes)
  static bool shouldTakeEyeBreak() {
    // This would typically track session start time
    // For now, return a simple pattern
    final minute = DateTime.now().minute;
    return minute % 20 == 0;
  }

  /// Get eye break reminder message
  static String getEyeBreakMessage() {
    final messages = [
      'Time for a 20-second eye break! Look at something 20 feet away.',
      'Rest your eyes. Blink slowly and look around the room.',
      'Eye break time! Focus on a distant object for 20 seconds.',
      'Give your eyes a break. Look out a window if you can.',
      'Time to rest your eyes. Close them for 20 seconds.',
    ];

    return messages[DateTime.now().millisecondsSinceEpoch % messages.length];
  }

  /// Get focus audio recommendation based on task type
  static String getFocusAudioRecommendation(Task? task) {
    if (task == null) return 'ambient';

    final title = task.title.toLowerCase();

    if (title.contains('code') || title.contains('program')) {
      return 'instrumental'; // Lo-fi, classical, or electronic without lyrics
    } else if (title.contains('write') || title.contains('creative')) {
      return 'ambient'; // Gentle background sounds
    } else if (title.contains('study') || title.contains('read')) {
      return 'white_noise'; // Consistent background noise
    } else if (title.contains('design') || title.contains('art')) {
      return 'nature'; // Nature sounds for creativity
    }

    return 'ambient';
  }

  /// Get focus level based on session performance
  static double calculateFocusLevel({required int sessionsCompleted, required int totalSessions, required double averageSessionDuration, required double targetDuration}) {
    if (totalSessions == 0) return 0.0;

    // Session completion factor
    final completionFactor = sessionsCompleted / totalSessions;

    // Duration consistency factor
    final durationFactor = (averageSessionDuration / targetDuration).clamp(0.5, 1.5);

    // Combine factors
    final focusLevel = (completionFactor * 0.7 + durationFactor * 0.3) * 100;

    return focusLevel.clamp(0.0, 100.0);
  }

  /// Get focus recommendations based on current patterns
  static List<String> getFocusRecommendations({required double currentFocusLevel, required List<bool> recentSessionProductivity, required int averageSessionLength}) {
    final recommendations = <String>[];

    if (currentFocusLevel < 50) {
      recommendations.add('Your focus level is low. Consider shorter sessions or changing your environment.');
    }

    if (recentSessionProductivity.length >= 5) {
      final recentProductivityRate = recentSessionProductivity.where((p) => p).length / recentSessionProductivity.length;

      if (recentProductivityRate < 0.6) {
        recommendations.add('Recent productivity has been low. Try enabling focus audio or reducing distractions.');
      }
    }

    if (averageSessionLength < 20) {
      recommendations.add('Your sessions are quite short. Consider building up to 25-minute sessions.');
    } else if (averageSessionLength > 45) {
      recommendations.add('Your sessions are quite long. Consider taking more frequent breaks.');
    }

    if (_settings['blockNotifications'] != true) {
      recommendations.add('Consider blocking notifications during focus sessions for better concentration.');
    }

    return recommendations;
  }

  // Private helper methods

  static Future<void> _enableFocusFeatures(Task? task) async {
    // Enable Do Not Disturb (platform dependent)
    if (_settings['enableDoNotDisturb'] == true) {
      await _enableDoNotDisturb();
    }

    // Block distracting apps (platform dependent)
    if (_settings['blockSocialMedia'] == true) {
      await _blockDistractingApps();
    }

    // Start focus audio
    if (_settings['playFocusAudio'] == true) {
      await _startFocusAudio(task);
    }

    // Enable haptic feedback
    if (_settings['enableHapticFeedback'] == true) {
      await _enableHapticFeedback();
    }

    // Show motivational quote
    if (_settings['showMotivationalQuotes'] == true) {
      _emitEvent(FocusModeEvent(type: FocusModeEventType.motivationalQuote, timestamp: DateTime.now(), data: {'quote': getMotivationalQuote()}));
    }
  }

  static Future<void> _disableFocusFeatures() async {
    // Disable Do Not Disturb
    if (_settings['enableDoNotDisturb'] == true) {
      await _disableDoNotDisturb();
    }

    // Unblock distracting apps
    if (_settings['blockSocialMedia'] == true) {
      await _unblockDistractingApps();
    }

    // Stop focus audio
    if (_settings['playFocusAudio'] == true) {
      await _stopFocusAudio();
    }

    // Disable haptic feedback
    if (_settings['enableHapticFeedback'] == true) {
      await _disableHapticFeedback();
    }
  }

  static Future<void> _enableDoNotDisturb() async {
    // Platform-specific implementation
    if (Platform.isAndroid) {
      // Android implementation would go here
      // This would require permissions and possibly accessibility services
    } else if (Platform.isIOS) {
      // iOS implementation would go here
      // This would require special permissions
    }
  }

  static Future<void> _disableDoNotDisturb() async {
    // Platform-specific implementation
    if (Platform.isAndroid) {
      // Android implementation
    } else if (Platform.isIOS) {
      // iOS implementation
    }
  }

  static Future<void> _blockDistractingApps() async {
    // Platform-specific implementation
    // This would require accessibility permissions on Android
    // or Screen Time API on iOS
  }

  static Future<void> _unblockDistractingApps() async {
    // Platform-specific implementation
  }

  static Future<void> _startFocusAudio(Task? task) async {
    final audioType = task != null ? getFocusAudioRecommendation(task) : _settings['audioType'] as String;

    // Implementation would depend on audio library used
    // This is a placeholder for the actual audio implementation

    _emitEvent(FocusModeEvent(type: FocusModeEventType.audioStarted, timestamp: DateTime.now(), data: {'audioType': audioType, 'volume': _settings['volume']}));
  }

  static Future<void> _stopFocusAudio() async {
    // Stop the currently playing focus audio

    _emitEvent(FocusModeEvent(type: FocusModeEventType.audioStopped, timestamp: DateTime.now(), data: {}));
  }

  static Future<void> _enableHapticFeedback() async {
    // Enable haptic feedback for focus mode events
    // Implementation would depend on the haptics library used
  }

  static Future<void> _disableHapticFeedback() async {
    // Disable haptic feedback
  }

  static void _emitEvent(FocusModeEvent event) {
    _eventController?.add(event);
  }

  /// Cleanup resources
  static void dispose() {
    _focusTimer?.cancel();
    _eventController?.close();
    _eventController = null;
  }
}

class FocusModeEvent {
  final FocusModeEventType type;
  final Task? task;
  final DateTime timestamp;
  final Map<String, dynamic> data;

  FocusModeEvent({required this.type, this.task, required this.timestamp, required this.data});
}

enum FocusModeEventType { started, ended, settingsUpdated, motivationalQuote, audioStarted, audioStopped, eyeBreakReminder, error }

class FocusModeSettings {
  final bool blockNotifications;
  final bool dimNonEssentialUI;
  final bool showOnlyTaskNotifications;
  final bool enableDoNotDisturb;
  final bool blockSocialMedia;
  final bool playFocusAudio;
  final String audioType;
  final double volume;
  final bool enableHapticFeedback;
  final bool showMotivationalQuotes;
  final bool enableEyeBreakReminders;

  const FocusModeSettings({
    this.blockNotifications = true,
    this.dimNonEssentialUI = true,
    this.showOnlyTaskNotifications = true,
    this.enableDoNotDisturb = false,
    this.blockSocialMedia = false,
    this.playFocusAudio = true,
    this.audioType = 'ambient',
    this.volume = 0.3,
    this.enableHapticFeedback = true,
    this.showMotivationalQuotes = true,
    this.enableEyeBreakReminders = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'blockNotifications': blockNotifications,
      'dimNonEssentialUI': dimNonEssentialUI,
      'showOnlyTaskNotifications': showOnlyTaskNotifications,
      'enableDoNotDisturb': enableDoNotDisturb,
      'blockSocialMedia': blockSocialMedia,
      'playFocusAudio': playFocusAudio,
      'audioType': audioType,
      'volume': volume,
      'enableHapticFeedback': enableHapticFeedback,
      'showMotivationalQuotes': showMotivationalQuotes,
      'enableEyeBreakReminders': enableEyeBreakReminders,
    };
  }

  factory FocusModeSettings.fromJson(Map<String, dynamic> json) {
    return FocusModeSettings(
      blockNotifications: json['blockNotifications'] ?? true,
      dimNonEssentialUI: json['dimNonEssentialUI'] ?? true,
      showOnlyTaskNotifications: json['showOnlyTaskNotifications'] ?? true,
      enableDoNotDisturb: json['enableDoNotDisturb'] ?? false,
      blockSocialMedia: json['blockSocialMedia'] ?? false,
      playFocusAudio: json['playFocusAudio'] ?? true,
      audioType: json['audioType'] ?? 'ambient',
      volume: (json['volume'] as num?)?.toDouble() ?? 0.3,
      enableHapticFeedback: json['enableHapticFeedback'] ?? true,
      showMotivationalQuotes: json['showMotivationalQuotes'] ?? true,
      enableEyeBreakReminders: json['enableEyeBreakReminders'] ?? true,
    );
  }
}
