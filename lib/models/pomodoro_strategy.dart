enum PomodoroStrategy {
  sequential, // Work through subtasks in order
  priority, // High priority subtasks first
  timeBoxed, // Fixed time per subtask
  flexible, // User chooses during session
}

extension PomodoroStrategyExtension on PomodoroStrategy {
  String get displayName {
    switch (this) {
      case PomodoroStrategy.sequential:
        return 'Sequential';
      case PomodoroStrategy.priority:
        return 'Priority First';
      case PomodoroStrategy.timeBoxed:
        return 'Time Boxed';
      case PomodoroStrategy.flexible:
        return 'Flexible';
    }
  }

  String get description {
    switch (this) {
      case PomodoroStrategy.sequential:
        return 'Work through subtasks in the order they appear';
      case PomodoroStrategy.priority:
        return 'Focus on high priority subtasks first';
      case PomodoroStrategy.timeBoxed:
        return 'Allocate fixed time to each subtask';
      case PomodoroStrategy.flexible:
        return 'Choose which subtask to work on during each session';
    }
  }
}
