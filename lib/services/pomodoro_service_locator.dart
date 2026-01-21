import '../repositories/task_repository.dart';
import 'pomodoro_service.dart';
import 'adaptive_pomodoro.dart';
import 'enhanced_progress.dart';
import 'pomodoro_audio_manager.dart';

/// Service locator for Pomodoro dependencies
class PomodoroServiceLocator {
  static TaskRepository? _taskRepository;
  static AdaptivePomodoro? _adaptivePomodoro;
  static ProgressTracker? _progressTracker;
  static PomodoroAudioManager? _audioManager;

  /// Initialize all services
  static void initialize({TaskRepository? taskRepository, AdaptivePomodoro? adaptivePomodoro, ProgressTracker? progressTracker, PomodoroAudioManager? audioManager}) {
    _taskRepository = taskRepository;
    _adaptivePomodoro = adaptivePomodoro ?? AdaptivePomodoro();
    _progressTracker = progressTracker ?? ProgressTracker();
    _audioManager = audioManager ?? PomodoroAudioManager();
  }

  /// Get task repository
  static TaskRepository? get taskRepository => _taskRepository;

  /// Get adaptive pomodoro service
  static AdaptivePomodoro get adaptivePomodoro => _adaptivePomodoro ?? AdaptivePomodoro();

  /// Get progress tracker
  static ProgressTracker get progressTracker => _progressTracker ?? ProgressTracker();

  /// Get audio manager
  static PomodoroAudioManager get audioManager => _audioManager ?? PomodoroAudioManager();

  /// Create PomodoroTimer with injected dependencies
  static PomodoroTimer createTimer({PomodoroSession? session}) {
    return PomodoroTimer(session: session, taskRepository: _taskRepository, adaptivePomodoro: _adaptivePomodoro, progressTracker: _progressTracker, audioManager: _audioManager);
  }

  /// Dispose all services
  static void dispose() {
    _taskRepository = null;
    _adaptivePomodoro = null;
    _progressTracker = null;
    _audioManager?.dispose();
    _audioManager = null;
  }
}
