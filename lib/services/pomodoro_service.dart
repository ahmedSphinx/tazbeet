import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../models/task.dart';
import 'notification_service.dart';

enum PomodoroState {
  idle,
  work,
  shortBreak,
  longBreak,
  paused,
}

class PomodoroSession {
  final int workDuration; // in minutes
  final int shortBreakDuration; // in minutes
  final int longBreakDuration; // in minutes
  final int sessionsUntilLongBreak;

  const PomodoroSession({
    this.workDuration = 30,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 15,
    this.sessionsUntilLongBreak = 4,
  });
}

class PomodoroTimer extends ChangeNotifier {
  final PomodoroSession session;

  PomodoroTimer({
    PomodoroSession? session,
  }) : session = session ?? const PomodoroSession();

  PomodoroState _state = PomodoroState.idle;
  PomodoroState _previousState = PomodoroState.idle; // Track previous state for paused
  int _currentSession = 0;
  int _completedSessions = 0;
  int _remainingSeconds = 0;
  Timer? _timer;
  DateTime? _startTime;
  DateTime? _pauseTime;

  static const String _pomodoroDataKey = 'pomodoro_data';

  // Getters
  PomodoroState get state => _state;
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
        return 'Work Session';
      case PomodoroState.shortBreak:
        return 'Short Break';
      case PomodoroState.longBreak:
        return 'Long Break';
      case PomodoroState.paused:
        return 'Paused';
      case PomodoroState.idle:
      return 'Ready to Start';
    }
  }

  String get nextStateLabel {
    switch (_state) {
      case PomodoroState.work:
        return _shouldTakeLongBreak() ? 'Long Break' : 'Short Break';
      case PomodoroState.shortBreak:
      case PomodoroState.longBreak:
        return 'Work Session';
      case PomodoroState.paused:
        return currentStateLabel;
      case PomodoroState.idle:
      return 'Work Session';
    }
  }

  Future<void> initialize() async {
    await _loadState();
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
    _clearState();
    notifyListeners();
  }

  void skip() {
    _timer?.cancel();
    _moveToNextState();
    _saveState();
    notifyListeners();
  }

  void _startWorkSession() {
    _state = PomodoroState.work;
    _currentSession++;
    _remainingSeconds = session.workDuration * 60;
    _startTime = DateTime.now();
    _startTimer();
  }

  void _startShortBreak() {
    _state = PomodoroState.shortBreak;
    _remainingSeconds = session.shortBreakDuration * 60;
    _startTime = DateTime.now();
    _startTimer();
  }

  void _startLongBreak() {
    _state = PomodoroState.longBreak;
    _remainingSeconds = session.longBreakDuration * 60;
    _startTime = DateTime.now();
    _startTimer();
  }

  void _resume() {
    if (_pauseTime != null && _startTime != null) {
      final pausedDuration = DateTime.now().difference(_pauseTime!);
      _startTime = _startTime!.add(pausedDuration);
      _pauseTime = null;
    }
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
          NotificationService().showTaskCompletedNotification(
            Task(
              id: 'pomodoro',
              title: 'Pomodoro Session Completed',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
        }
        notifyListeners();
      }
    });
  }

  void _moveToNextState() {
    switch (_state) {
      case PomodoroState.work:
        _completedSessions++;
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
        break;
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
    final shortBreaks = _completedSessions - (_completedSessions ~/ session.sessionsUntilLongBreak);
    final longBreaks = _completedSessions ~/ session.sessionsUntilLongBreak;
    return Duration(
      minutes: shortBreaks * session.shortBreakDuration + longBreaks * session.longBreakDuration,
    );
  }

  double getAverageSessionTime() {
    if (_completedSessions == 0) return 0.0;
    return session.workDuration.toDouble();
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
      final data = jsonDecode(dataString) as Map<String, dynamic>;
      _state = PomodoroState.values[data['state']];
      _previousState = PomodoroState.values[data['previousState']];
      _currentSession = data['currentSession'];
      _completedSessions = data['completedSessions'];
      _remainingSeconds = data['remainingSeconds'];
      _startTime = data['startTime'] != null ? DateTime.parse(data['startTime']) : null;
      _pauseTime = data['pauseTime'] != null ? DateTime.parse(data['pauseTime']) : null;

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
    super.dispose();
  }
}
