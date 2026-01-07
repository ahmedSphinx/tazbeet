import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tazbeet/services/app_logging_service.dart';
import 'dart:io';
import '../models/task.dart';
import 'notification_service.dart';
import 'localization_service.dart';
import '../repositories/task_repository.dart';
import 'settings_service.dart';
import 'adaptive_pomodoro.dart';
import 'session_chain.dart';
import 'enhanced_progress.dart';
import 'focus_mode.dart';

enum PomodoroState { idle, work, shortBreak, longBreak, paused }

class PomodoroSession {
  final int workDuration; // in minutes
  final int shortBreakDuration; // in minutes
  final int longBreakDuration; // in minutes
  final int sessionsUntilLongBreak;

  const PomodoroSession({this.workDuration = 25, this.shortBreakDuration = 5, this.longBreakDuration = 15, this.sessionsUntilLongBreak = 4});
}

class PomodoroTimer extends ChangeNotifier {
  PomodoroSession session;
  final TaskRepository? taskRepository;
  final AdaptivePomodoro adaptivePomodoro;
  final ProgressTracker progressTracker;

  // Callback for state changes (for UI to play sounds, show animations)
  void Function(PomodoroState oldState, PomodoroState newState)? onStateChange;

  // Audio player for session completion sounds
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _enableSound = true;
  bool _enableVibration = true;

  // Enhanced features
  SessionChain? _currentChain;
  bool _adaptiveTimingEnabled = true;
  bool _focusModeEnabled = false;
  final List<Map<String, dynamic>> _sessionHistory = [];

  PomodoroTimer({PomodoroSession? session, this.taskRepository, AdaptivePomodoro? adaptivePomodoro, ProgressTracker? progressTracker})
    : session = session ?? const PomodoroSession(),
      adaptivePomodoro = adaptivePomodoro ?? AdaptivePomodoro(),
      progressTracker = progressTracker ?? ProgressTracker();

  void updateSession(PomodoroSession newSession) {
    session = newSession;
    notifyListeners();
  }

  Task? _selectedTask;
  PomodoroState _state = PomodoroState.idle;
  PomodoroState _previousState = PomodoroState.idle; // Track previous state for paused
  int _currentSession = 0;
  int _completedSessions = 0;
  int _remainingSeconds = 0;
  Timer? _timer;
  DateTime? _startTime;
  DateTime? _pauseTime;
  DateTime? _workStartTime;

  Task? get selectedTask => _selectedTask;

  void setSelectedTask(Task? task) {
    _selectedTask = task;

    // Initialize session chain if task has subtasks and auto-start is enabled
    if (task != null && task.autoStartNextSubtask) {
      _currentChain = SessionChain.createForTask(task);
    } else {
      _currentChain = null;
    }

    // Update session duration based on task if adaptive timing is enabled
    if (_adaptiveTimingEnabled && task != null) {
      final optimalDuration = adaptivePomodoro.calculateOptimalDuration(task);
      session = PomodoroSession(workDuration: optimalDuration, shortBreakDuration: session.shortBreakDuration, longBreakDuration: session.longBreakDuration, sessionsUntilLongBreak: session.sessionsUntilLongBreak);
    }

    notifyListeners();
  }

  static const String _pomodoroDataKey = 'pomodoro_data';

  // Getters
  PomodoroState get state => _state;
  PomodoroState get effectiveState => _state == PomodoroState.paused ? _previousState : _state;
  int get currentSession => _currentSession;
  int get completedSessions => _completedSessions;
  int get remainingSeconds => _remainingSeconds;
  int get remainingMinutes => _remainingSeconds ~/ 60;
  int get remainingSecondsInMinute => _remainingSeconds % 60;
  bool get isRunning => _timer?.isActive ?? false;
  bool get isPaused => _state == PomodoroState.paused;
  double get progress {
    if (_state == PomodoroState.idle) return 0.0;

    int totalSeconds = _getTotalSecondsForCurrentState();
    if (totalSeconds == 0) return 0.0;

    return 1.0 - (_remainingSeconds / totalSeconds);
  }

  String get currentStateLabel {
    switch (_state) {
      case PomodoroState.work:
        return LocalizationService.work;
      case PomodoroState.shortBreak:
        return LocalizationService.shortBreak;
      case PomodoroState.longBreak:
        return LocalizationService.longBreak;
      case PomodoroState.paused:
        return LocalizationService.paused;
      case PomodoroState.idle:
        return LocalizationService.idle;
    }
  }

  String get nextStateLabel {
    switch (_state) {
      case PomodoroState.work:
        return _shouldTakeLongBreak() ? LocalizationService.longBreak : LocalizationService.shortBreak;
      case PomodoroState.shortBreak:
      case PomodoroState.longBreak:
        return LocalizationService.work;
      case PomodoroState.paused:
        return currentStateLabel;
      case PomodoroState.idle:
        return LocalizationService.shortBreak;
    }
  }

  Future<void> initialize() async {
    await _loadState();
    // Load sound/vibration settings
    final settings = SettingsService().settings;
    _enableSound = settings.enableSound;
    _enableVibration = settings.enableVibration;
  }

  void updateSoundSettings({bool? enableSound, bool? enableVibration}) {
    if (enableSound != null) _enableSound = enableSound;
    if (enableVibration != null) _enableVibration = enableVibration;
  }

  void start() {
    if (_state == PomodoroState.idle) {
      _startWorkSession();
    } else if (_state == PomodoroState.paused) {
      _resume();
    }
    _saveState();
    notifyListeners();
  }

  void pause() {
    if (_state != PomodoroState.idle && isRunning) {
      _timer?.cancel();
      _pauseTime = DateTime.now();
      _previousState = _state; // Store the current state before pausing
      _state = PomodoroState.paused;
      _saveState();
      notifyListeners();
    }
  }

  void stop() {
    _timer?.cancel();
    _state = PomodoroState.idle;
    _remainingSeconds = 0;
    _startTime = null;
    _pauseTime = null;

    // Disable focus mode
    if (_focusModeEnabled) {
      FocusMode.disableFocusMode(reason: 'Timer stopped');
    }

    _clearState();
    notifyListeners();
  }

  void skip() {
    _timer?.cancel();
    _moveToNextState(completed: false);
    _saveState();
    notifyListeners();
  }

  void addTime(int minutes) {
    if (_state != PomodoroState.idle) {
      _remainingSeconds += minutes * 60;
      // Ensure we don't go negative
      if (_remainingSeconds < 0) {
        _remainingSeconds = 0;
      }
      _saveState();
      notifyListeners();
    }
  }

  void subtractTime(int minutes) {
    if (_state != PomodoroState.idle) {
      _remainingSeconds -= minutes * 60;
      // Ensure we don't go negative
      if (_remainingSeconds < 0) {
        _remainingSeconds = 0;
      }
      _saveState();
      notifyListeners();
    }
  }

  void _startWorkSession() {
    final oldState = _state;
    _state = PomodoroState.work;
    _currentSession++;

    // Use adaptive duration if enabled and task is selected
    if (_adaptiveTimingEnabled && _selectedTask != null) {
      _remainingSeconds = adaptivePomodoro.calculateOptimalDuration(_selectedTask!) * 60;
    } else {
      _remainingSeconds = session.workDuration * 60;
    }

    _startTime = DateTime.now();
    _workStartTime = DateTime.now();

    // Enable focus mode if configured
    if (_focusModeEnabled && _selectedTask != null) {
      FocusMode.enableFocusMode(task: _selectedTask);
    }

    _notifyStateChange(oldState, _state);
    _startTimer();
  }

  void _startShortBreak() {
    final oldState = _state;
    _state = PomodoroState.shortBreak;
    _remainingSeconds = session.shortBreakDuration * 60;
    _startTime = DateTime.now();
    _notifyStateChange(oldState, _state);
    _startTimer();
  }

  void _startLongBreak() {
    final oldState = _state;
    _state = PomodoroState.longBreak;
    _remainingSeconds = session.longBreakDuration * 60;
    _startTime = DateTime.now();
    _notifyStateChange(oldState, _state);
    _startTimer();
  }

  void _notifyStateChange(PomodoroState oldState, PomodoroState newState) {
    // Play sound and vibrate on state change
    if (oldState != PomodoroState.idle && oldState != PomodoroState.paused) {
      _playCompletionFeedback();
    }
    onStateChange?.call(oldState, newState);
  }

  Future<void> _playCompletionFeedback() async {
    if (_enableVibration) {
      HapticFeedback.heavyImpact();
    }
    if (_enableSound) {
      try {
        await _audioPlayer.play(AssetSource('sounds/session_complete.mp3'));
      } catch (e) {
        // Sound file may not exist, ignore
        AppLogging.logError('Could not play completion sound: $e');
      }
    }
  }

  void _resume() {
    if (_pauseTime != null && _startTime != null) {
      final pausedDuration = DateTime.now().difference(_pauseTime!);
      _startTime = _startTime!.add(pausedDuration);
      _pauseTime = null;
    }
    _state = _previousState;
    notifyListeners();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        // Save state every 10 seconds for persistence
        if (_remainingSeconds % 10 == 0) {
          await _saveState();
        }
        notifyListeners();
      } else {
        _timer?.cancel();
        _moveToNextState();
        _saveState();
        // Send notification when session completes
        if (Platform.isAndroid || Platform.isIOS) {
          NotificationService().showTaskCompletedNotification(Task(id: 'pomodoro', title: LocalizationService.pomodoroSessionCompleted, createdAt: DateTime.now(), updatedAt: DateTime.now()));
        }
        notifyListeners();
      }
    });
  }

  void _moveToNextState({bool completed = true}) async {
    try {
      switch (_state) {
        case PomodoroState.work:
          if (completed) {
            _completedSessions++;

            // Record session data for adaptive learning
            if (_selectedTask != null && _workStartTime != null) {
              final workDuration = DateTime.now().difference(_workStartTime!).inMinutes;
              final sessionData = {'startTime': _workStartTime!.toIso8601String(), 'duration': workDuration, 'completed': true, 'taskId': _selectedTask!.id, 'taskTitle': _selectedTask!.title};
              _sessionHistory.add(sessionData);

              // Learn from this session
              try {
                adaptivePomodoro.learnFromSession(
                  _selectedTask!,
                  workDuration,
                  true, // Assume productive for completed sessions
                  null,
                );
              } catch (e) {
                // Adaptive learning errors are non-critical
                AppLogging.logError('Adaptive learning error: $e');
              }

              // Update task with enhanced data
              final updatedTask = _selectedTask!.copyWith(
                pomodoroCount: _selectedTask!.pomodoroCount + 1,
                timeSpent: _selectedTask!.timeSpent + Duration(minutes: workDuration),
                lastPomodoroDate: DateTime.now(),
                pomodoroSessions: [..._selectedTask!.pomodoroSessions, sessionData],
                updatedAt: DateTime.now(),
              );

              try {
                await taskRepository!.updateTask(updatedTask);

                // Update progress tracking
                try {
                  progressTracker.calculateProgress(updatedTask);
                } catch (e) {
                  AppLogging.logError('Progress tracking error: $e');
                }

                // Handle session chaining
                if (_currentChain != null) {
                  try {
                    final nextSubtask = _currentChain!.completeSubtaskSession(_selectedTask!, 'Work session completed');
                    if (nextSubtask != null && _currentChain!.shouldContinueChaining()) {
                      setSelectedTask(nextSubtask);
                    }
                  } catch (e) {
                    AppLogging.logError('Session chaining error: $e');
                  }
                }
              } catch (e) {
                // Task update errors are critical but shouldn't crash the timer
                AppLogging.logError('Task update error: $e');
                // Continue with state transition even if task update fails
              }
            }
          }

          // Disable focus mode during breaks
          if (_focusModeEnabled) {
            try {
              await FocusMode.disableFocusMode(reason: 'Break time');
            } catch (e) {
              AppLogging.logError('Focus mode disable error: $e');
            }
          }

          if (_shouldTakeLongBreak()) {
            _startLongBreak();
          } else {
            _startShortBreak();
          }
          break;
        case PomodoroState.shortBreak:
        case PomodoroState.longBreak:
          _startWorkSession();
          break;
        case PomodoroState.paused:
        case PomodoroState.idle:
          // No action needed for these states
          break;
      }
    } catch (e) {
      // Log error but don't crash the timer
      AppLogging.logError('Error in _moveToNextState: $e');
      // Try to continue with basic state transition
      try {
        if (_state == PomodoroState.work) {
          _startShortBreak();
        } else {
          _startWorkSession();
        }
      } catch (fallbackError) {
        AppLogging.logError('Fallback state transition failed: $fallbackError');
        // Stop the timer if everything fails
        stop();
      }
    }
  }

  bool _shouldTakeLongBreak() {
    return _completedSessions > 0 && _completedSessions % session.sessionsUntilLongBreak == 0;
  }

  int _getTotalSecondsForCurrentState() {
    switch (_state) {
      case PomodoroState.work:
        return session.workDuration * 60;
      case PomodoroState.shortBreak:
        return session.shortBreakDuration * 60;
      case PomodoroState.longBreak:
        return session.longBreakDuration * 60;
      case PomodoroState.paused:
        // Return the duration for the state that was paused
        switch (_previousState) {
          case PomodoroState.work:
            return session.workDuration * 60;
          case PomodoroState.shortBreak:
            return session.shortBreakDuration * 60;
          case PomodoroState.longBreak:
            return session.longBreakDuration * 60;
          case PomodoroState.paused:
          case PomodoroState.idle:
            return 0;
        }
      case PomodoroState.idle:
        return 0;
    }
  }

  // Statistics methods
  Duration getTotalWorkTime() {
    return Duration(minutes: _completedSessions * session.workDuration);
  }

  Duration getTotalBreakTime() {
    // Breaks taken = completedSessions - 1 (no break before first session)
    // But we need to count breaks that have actually been taken
    if (_completedSessions <= 0) return Duration.zero;

    final breaksTaken = _completedSessions; // Each completed work session is followed by a break
    final longBreaksTaken = _completedSessions ~/ session.sessionsUntilLongBreak;
    final shortBreaksTaken = breaksTaken - longBreaksTaken;

    return Duration(minutes: shortBreaksTaken * session.shortBreakDuration + longBreaksTaken * session.longBreakDuration);
  }

  double getAverageSessionTime() {
    if (_completedSessions == 0) return 0.0;
    // Calculate actual average based on completed sessions
    return getTotalWorkTime().inMinutes / _completedSessions.toDouble();
  }

  int getSessionsCompletedToday() {
    // This would need to be tracked separately with persistent storage
    return _completedSessions;
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'state': _state.index,
      'previousState': _previousState.index,
      'currentSession': _currentSession,
      'completedSessions': _completedSessions,
      'remainingSeconds': _remainingSeconds,
      'startTime': _startTime?.toIso8601String(),
      'pauseTime': _pauseTime?.toIso8601String(),
    };
    await prefs.setString(_pomodoroDataKey, jsonEncode(data));
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString(_pomodoroDataKey);
    if (dataString != null) {
      final decodedData = jsonDecode(dataString);
      if (decodedData is Map) {
        // Convert Map<dynamic, dynamic> to Map<String, dynamic> safely
        final Map<String, dynamic> data = {};
        decodedData.forEach((key, value) {
          data[key.toString()] = value;
        });
        _state = PomodoroState.values[data['state']];
        _previousState = PomodoroState.values[data['previousState']];
        _currentSession = data['currentSession'];
        _completedSessions = data['completedSessions'];
        _remainingSeconds = data['remainingSeconds'];
        _startTime = data['startTime'] != null ? DateTime.parse(data['startTime']) : null;
        _pauseTime = data['pauseTime'] != null ? DateTime.parse(data['pauseTime']) : null;
      }

      // Resume timer if it was running
      if (_state != PomodoroState.idle && _state != PomodoroState.paused) {
        _startTimer();
      }
    }
  }

  Future<void> _clearState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pomodoroDataKey);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    FocusMode.dispose();
    super.dispose();
  }

  // Enhanced feature methods

  /// Enable or disable adaptive timing
  void setAdaptiveTiming(bool enabled) {
    _adaptiveTimingEnabled = enabled;
    if (enabled && _selectedTask != null) {
      // Recalculate current session duration
      final optimalDuration = adaptivePomodoro.calculateOptimalDuration(_selectedTask!);
      if (_state == PomodoroState.work) {
        _remainingSeconds = optimalDuration * 60;
        notifyListeners();
      }
    }
  }

  /// Enable or disable focus mode
  void setFocusMode(bool enabled) {
    _focusModeEnabled = enabled;
    if (!enabled && FocusMode.isActive) {
      FocusMode.disableFocusMode(reason: 'Focus mode disabled');
    }
  }

  /// Get current session chain info
  Map<String, dynamic>? getCurrentChainInfo() {
    if (_currentChain == null) return null;
    return _currentChain!.getSessionSummary();
  }

  /// Get enhanced progress for selected task
  EnhancedProgress? getTaskProgress() {
    if (_selectedTask == null) return null;
    return progressTracker.calculateProgress(_selectedTask!);
  }

  /// Get productivity insights
  Map<String, dynamic> getProductivityInsights() {
    return adaptivePomodoro.getWorkPatternInsights();
  }

  /// Get personalized recommendations
  List<String> getRecommendations() {
    final recommendations = <String>[];

    // Get adaptive pomodoro recommendations
    recommendations.addAll(adaptivePomodoro.getPersonalizedRecommendations());

    // Get progress recommendations
    if (_selectedTask != null) {
      recommendations.addAll(progressTracker.getProgressInsights(_selectedTask!.id));
    }

    // Get focus mode recommendations
    if (_focusModeEnabled) {
      recommendations.addAll(
        FocusMode.getFocusRecommendations(
          currentFocusLevel: 0.8, // Simplified, would calculate from actual data
          recentSessionProductivity: _sessionHistory.map((s) => s['completed'] as bool).toList(),
          averageSessionLength: _getAverageSessionLength().toInt(),
        ),
      );
    }

    return recommendations;
  }

  /// Get session history
  List<Map<String, dynamic>> getSessionHistory() {
    return List.unmodifiable(_sessionHistory);
  }

  /// Export timer data
  Map<String, dynamic> exportData() {
    return {
      'sessionHistory': _sessionHistory,
      'adaptiveData': adaptivePomodoro.exportLearningData(),
      'progressData': progressTracker.exportProgressData(),
      'settings': {'adaptiveTimingEnabled': _adaptiveTimingEnabled, 'focusModeEnabled': _focusModeEnabled},
    };
  }

  /// Import timer data
  void importData(Map<String, dynamic> data) {
    if (data['sessionHistory'] != null) {
      _sessionHistory.clear();
      _sessionHistory.addAll((data['sessionHistory'] as List).cast<Map<String, dynamic>>());
    }

    if (data['adaptiveData'] != null) {
      adaptivePomodoro.importLearningData(data['adaptiveData']);
    }

    if (data['progressData'] != null) {
      progressTracker.importProgressData(data['progressData']);
    }

    if (data['settings'] != null) {
      final settings = data['settings'] as Map<String, dynamic>;
      _adaptiveTimingEnabled = settings['adaptiveTimingEnabled'] ?? true;
      _focusModeEnabled = settings['focusModeEnabled'] ?? false;
    }
  }

  double _getAverageSessionLength() {
    if (_sessionHistory.isEmpty) return 25.0;

    final totalLength = _sessionHistory.map((s) => s['duration'] as int).fold<int>(0, (sum, length) => sum + length);

    return totalLength / _sessionHistory.length;
  }
}
