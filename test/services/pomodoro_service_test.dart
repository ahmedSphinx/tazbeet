import 'package:flutter_test/flutter_test.dart';
import 'package:tazbeet/services/pomodoro_service.dart';
import 'package:tazbeet/services/pomodoro_service_locator.dart';
import 'package:tazbeet/services/adaptive_pomodoro.dart';
import 'package:tazbeet/services/enhanced_progress.dart';
import 'package:tazbeet/models/task.dart';
import 'package:tazbeet/models/pomodoro_template_model.dart';

void main() {
  group('PomodoroTimer Tests', () {
    late PomodoroTimer timer;

    setUp(() {
      // Initialize service locator
      PomodoroServiceLocator.initialize();
      timer = PomodoroServiceLocator.createTimer();
    });

    tearDown(() {
      timer.dispose();
    });

    test('Timer should start in idle state', () {
      expect(timer.state, PomodoroState.idle);
      expect(timer.isRunning, false);
      expect(timer.isPaused, false);
    });

    test('Timer should start work session correctly', () {
      timer.start();
      expect(timer.state, PomodoroState.work);
      expect(timer.isRunning, true);
      expect(timer.currentSession, 1);
    });

    test('Timer should pause correctly', () {
      timer.start();
      timer.pause();
      expect(timer.state, PomodoroState.paused);
      expect(timer.isRunning, false);
      expect(timer.isPaused, true);
    });

    test('Timer should stop correctly', () {
      timer.start();
      timer.stop();
      expect(timer.state, PomodoroState.idle);
      expect(timer.isRunning, false);
      expect(timer.remainingSeconds, 0);
    });

    test('Timer should calculate progress correctly', () {
      timer.start();
      // Progress should be 1.0 at start (remainingSeconds / totalSeconds)
      expect(timer.progress, 1.0);
    });

    test('Timer should update session correctly', () {
      final newSession = PomodoroSession(workDuration: 30, shortBreakDuration: 10, longBreakDuration: 20, sessionsUntilLongBreak: 3);

      timer.updateSession(newSession);
      expect(timer.session.workDuration, 30);
      expect(timer.session.shortBreakDuration, 10);
      expect(timer.session.longBreakDuration, 20);
      expect(timer.session.sessionsUntilLongBreak, 3);
    });
  });

  group('PomodoroTemplate Tests', () {
    test('Template should create from JSON correctly', () {
      final json = {'name': 'Test Template', 'work': 25, 'rest': 5, 'long_rest': 15, 'cycles': 4, 'recommended_for': 'normal'};

      final template = PomodoroTemplate.fromJson(json);
      expect(template.name, 'Test Template');
      expect(template.workDuration, 25);
      expect(template.restDuration, 5);
      expect(template.longRestDuration, 15);
      expect(template.cycles, 4);
      expect(template.recommendedFor, 'normal');
    });

    test('Template should convert to JSON correctly', () {
      final template = PomodoroTemplate(id: 'test', name: 'Test Template', workDuration: 25, restDuration: 5, longRestDuration: 15, cycles: 4, recommendedFor: 'normal');

      final json = template.toJson();
      expect(json['name'], 'Test Template');
      expect(json['work'], 25);
      expect(json['rest'], 5);
      expect(json['long_rest'], 15);
      expect(json['cycles'], 4);
      expect(json['recommended_for'], 'normal');
    });
  });

  group('AdaptivePomodoro Tests', () {
    test('Should calculate optimal duration for high priority task', () {
      final adaptivePomodoro = AdaptivePomodoro();
      final task = Task(id: 'test', title: 'High Priority Task', priority: TaskPriority.high, createdAt: DateTime.now(), updatedAt: DateTime.now());

      final duration = adaptivePomodoro.calculateOptimalDuration(task);
      expect(duration, greaterThanOrEqualTo(25)); // Should be longer than default
      expect(duration, lessThanOrEqualTo(60)); // Should not exceed max
    });

    test('Should calculate optimal duration for low priority task', () {
      final adaptivePomodoro = AdaptivePomodoro();
      final task = Task(id: 'test', title: 'Low Priority Task', priority: TaskPriority.low, createdAt: DateTime.now(), updatedAt: DateTime.now());

      final duration = adaptivePomodoro.calculateOptimalDuration(task);
      expect(duration, lessThanOrEqualTo(25)); // Should be shorter than default
      expect(duration, greaterThanOrEqualTo(15)); // Should not be below min
    });
  });

  group('ProgressTracker Tests', () {
    test('Should calculate enhanced progress for task', () {
      final tracker = ProgressTracker();
      final task = Task(
        id: 'test',
        title: 'Test Task',
        priority: TaskPriority.medium,
        isCompleted: false,
        subtasks: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        pomodoroCount: 2,
        estimatedSessions: 4,
        timeSpent: const Duration(minutes: 50),
      );

      final progress = tracker.calculateProgress(task);
      expect(progress.completionProgress, 0.0); // Not completed
      expect(progress.sessionProgress, 0.5); // 2/4 sessions
      expect(progress.timeProgress, 1.0); // 50min / (4*25min)
    });
  });

  group('PomodoroServiceLocator Tests', () {
    test('Should provide services correctly', () {
      PomodoroServiceLocator.initialize();

      final adaptivePomodoro = PomodoroServiceLocator.adaptivePomodoro;
      final progressTracker = PomodoroServiceLocator.progressTracker;

      expect(adaptivePomodoro, isNotNull);
      expect(progressTracker, isNotNull);

      PomodoroServiceLocator.dispose();
    });

    test('Should create timer with dependencies', () {
      PomodoroServiceLocator.initialize();

      final timer = PomodoroServiceLocator.createTimer();
      expect(timer, isNotNull);
      expect(timer.state, PomodoroState.idle);

      timer.dispose();
      PomodoroServiceLocator.dispose();
    });
  });
}
