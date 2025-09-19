import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import 'notification_service.dart';
import 'pomodoro_service.dart';

class EmergencyService extends ChangeNotifier {
  static final EmergencyService _instance = EmergencyService._internal();
  factory EmergencyService() => _instance;
  EmergencyService._internal();

  final NotificationService _notificationService = NotificationService();
  final PomodoroTimer _pomodoroTimer = PomodoroTimer();

  bool _isEmergencyMode = false;
  bool _remindersSuspended = false;
  DateTime? _suspensionEndTime;
  Timer? _suspensionTimer;

  // Getters
  bool get isEmergencyMode => _isEmergencyMode;
  bool get remindersSuspended => _remindersSuspended;
  DateTime? get suspensionEndTime => _suspensionEndTime;
  bool get isSuspended => _remindersSuspended && _suspensionEndTime != null;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isEmergencyMode = prefs.getBool('emergency_mode') ?? false;
    _remindersSuspended = prefs.getBool('reminders_suspended') ?? false;

    final suspensionEndMillis = prefs.getInt('suspension_end_time');
    if (suspensionEndMillis != null) {
      _suspensionEndTime = DateTime.fromMillisecondsSinceEpoch(suspensionEndMillis);
      _checkSuspensionExpiry();
    }

    notifyListeners();
  }

  Future<void> toggleEmergencyMode() async {
    _isEmergencyMode = !_isEmergencyMode;

    if (_isEmergencyMode) {
      // Enter emergency mode
      await _suspendAllReminders();
      await _pausePomodoroIfRunning();
      await _showEmergencyNotification();
    } else {
      // Exit emergency mode
      await _resumeAllReminders();
    }

    await _savePreferences();
    notifyListeners();
  }

  Future<void> suspendReminders({Duration duration = const Duration(hours: 1)}) async {
    _remindersSuspended = true;
    _suspensionEndTime = DateTime.now().add(duration);

    await _savePreferences();
    _startSuspensionTimer();

    notifyListeners();
  }

  Future<void> resumeReminders() async {
    _remindersSuspended = false;
    _suspensionEndTime = null;
    _suspensionTimer?.cancel();
    _suspensionTimer = null;

    await _savePreferences();
    notifyListeners();
  }

  Future<void> quickPause({Duration duration = const Duration(minutes: 15)}) async {
    await suspendReminders(duration: duration);
  }

  Future<void> _suspendAllReminders() async {
    // This would integrate with notification service to suspend all scheduled reminders
    // For now, we'll just set the suspension flag
    _remindersSuspended = true;
    await _savePreferences();
  }

  Future<void> _resumeAllReminders() async {
    _remindersSuspended = false;
    await _savePreferences();
  }

  Future<void> _pausePomodoroIfRunning() async {
    if (_pomodoroTimer.isRunning) {
      _pomodoroTimer.pause();
    }
  }

  Future<void> _showEmergencyNotification() async {
    // Show a notification that emergency mode is active
    await _notificationService.showTaskCompletedNotification(
      // Create a dummy task for the notification
      Task(
        id: 'emergency_mode',
        title: 'Emergency Mode Active',
        description: 'All reminders and timers have been suspended',
        priority: TaskPriority.high,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  void _checkSuspensionExpiry() {
    if (_suspensionEndTime != null && DateTime.now().isAfter(_suspensionEndTime!)) {
      resumeReminders();
    }
  }

  void _startSuspensionTimer() {
    _suspensionTimer?.cancel();

    if (_suspensionEndTime != null) {
      final duration = _suspensionEndTime!.difference(DateTime.now());
      if (duration.isNegative) {
        resumeReminders();
      } else {
        _suspensionTimer = Timer(duration, () {
          resumeReminders();
        });
      }
    }
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('emergency_mode', _isEmergencyMode);
    await prefs.setBool('reminders_suspended', _remindersSuspended);

    if (_suspensionEndTime != null) {
      await prefs.setInt('suspension_end_time', _suspensionEndTime!.millisecondsSinceEpoch);
    } else {
      await prefs.remove('suspension_end_time');
    }
  }

  String getSuspensionTimeRemaining() {
    if (_suspensionEndTime == null) return '';

    final remaining = _suspensionEndTime!.difference(DateTime.now());
    if (remaining.isNegative) return '';

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours h $minutes m';
    } else {
      return '$minutes m';
    }
  }

  @override
  void dispose() {
    _suspensionTimer?.cancel();
    super.dispose();
  }
}
