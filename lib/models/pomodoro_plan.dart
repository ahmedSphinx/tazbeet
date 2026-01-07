import 'package:equatable/equatable.dart';

/// Represents a complete pomodoro plan for a task
class PomodoroPlan extends Equatable {
  final String taskId;
  final int totalSessions;
  final int workDuration; // minutes
  final int breakDuration; // minutes
  final int longBreakDuration; // minutes
  final int sessionsBeforeLongBreak;
  final List<PomodoroSessionPlan> sessions;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  const PomodoroPlan({
    required this.taskId,
    required this.totalSessions,
    required this.workDuration,
    required this.breakDuration,
    required this.longBreakDuration,
    required this.sessionsBeforeLongBreak,
    required this.sessions,
    required this.createdAt,
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [taskId, totalSessions, workDuration, breakDuration, longBreakDuration, sessionsBeforeLongBreak, sessions, createdAt, metadata];

  PomodoroPlan copyWith({
    String? taskId,
    int? totalSessions,
    int? workDuration,
    int? breakDuration,
    int? longBreakDuration,
    int? sessionsBeforeLongBreak,
    List<PomodoroSessionPlan>? sessions,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return PomodoroPlan(
      taskId: taskId ?? this.taskId,
      totalSessions: totalSessions ?? this.totalSessions,
      workDuration: workDuration ?? this.workDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      sessionsBeforeLongBreak: sessionsBeforeLongBreak ?? this.sessionsBeforeLongBreak,
      sessions: sessions ?? this.sessions,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'totalSessions': totalSessions,
      'workDuration': workDuration,
      'breakDuration': breakDuration,
      'longBreakDuration': longBreakDuration,
      'sessionsBeforeLongBreak': sessionsBeforeLongBreak,
      'sessions': sessions.map((s) => s.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory PomodoroPlan.fromJson(Map<String, dynamic> json) {
    return PomodoroPlan(
      taskId: json['taskId'] as String,
      totalSessions: json['totalSessions'] as int,
      workDuration: json['workDuration'] as int,
      breakDuration: json['breakDuration'] as int,
      longBreakDuration: json['longBreakDuration'] as int,
      sessionsBeforeLongBreak: json['sessionsBeforeLongBreak'] as int,
      sessions: (json['sessions'] as List<dynamic>).map((s) => PomodoroSessionPlan.fromJson(s as Map<String, dynamic>)).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}

/// Represents a single session in a pomodoro plan
class PomodoroSessionPlan extends Equatable {
  final int sessionNumber;
  final SessionType type;
  final int duration; // minutes
  final String? focusArea; // What to focus on in this session
  final List<String> subtasks; // Subtasks to tackle in this session
  final Map<String, dynamic> metadata;

  const PomodoroSessionPlan({required this.sessionNumber, required this.type, required this.duration, this.focusArea, this.subtasks = const [], this.metadata = const {}});

  @override
  List<Object?> get props => [sessionNumber, type, duration, focusArea, subtasks, metadata];

  PomodoroSessionPlan copyWith({int? sessionNumber, SessionType? type, int? duration, String? focusArea, List<String>? subtasks, Map<String, dynamic>? metadata}) {
    return PomodoroSessionPlan(
      sessionNumber: sessionNumber ?? this.sessionNumber,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      focusArea: focusArea ?? this.focusArea,
      subtasks: subtasks ?? this.subtasks,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {'sessionNumber': sessionNumber, 'type': type.index, 'duration': duration, 'focusArea': focusArea, 'subtasks': subtasks, 'metadata': metadata};
  }

  factory PomodoroSessionPlan.fromJson(Map<String, dynamic> json) {
    return PomodoroSessionPlan(
      sessionNumber: json['sessionNumber'] as int,
      type: SessionType.values[json['type'] as int],
      duration: json['duration'] as int,
      focusArea: json['focusArea'] as String?,
      subtasks: List<String>.from(json['subtasks'] ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}

/// Types of pomodoro sessions
enum SessionType { work, shortBreak, longBreak }

/// Represents a completed pomodoro session
class CompletedPomodoroSession extends Equatable {
  final String id;
  final String taskId;
  final int sessionNumber;
  final SessionType type;
  final DateTime startTime;
  final DateTime endTime;
  final int actualDuration; // minutes
  final bool completed; // Was the session completed fully
  final String? notes;
  final List<String> completedSubtasks;
  final int focusRating; // 1-10 how focused the user was
  final Map<String, dynamic> metadata;

  const CompletedPomodoroSession({
    required this.id,
    required this.taskId,
    required this.sessionNumber,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.actualDuration,
    required this.completed,
    this.notes,
    this.completedSubtasks = const [],
    this.focusRating = 5,
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [id, taskId, sessionNumber, type, startTime, endTime, actualDuration, completed, notes, completedSubtasks, focusRating, metadata];

  CompletedPomodoroSession copyWith({
    String? id,
    String? taskId,
    int? sessionNumber,
    SessionType? type,
    DateTime? startTime,
    DateTime? endTime,
    int? actualDuration,
    bool? completed,
    String? notes,
    List<String>? completedSubtasks,
    int? focusRating,
    Map<String, dynamic>? metadata,
  }) {
    return CompletedPomodoroSession(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      sessionNumber: sessionNumber ?? this.sessionNumber,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      actualDuration: actualDuration ?? this.actualDuration,
      completed: completed ?? this.completed,
      notes: notes ?? this.notes,
      completedSubtasks: completedSubtasks ?? this.completedSubtasks,
      focusRating: focusRating ?? this.focusRating,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'sessionNumber': sessionNumber,
      'type': type.index,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'actualDuration': actualDuration,
      'completed': completed,
      'notes': notes,
      'completedSubtasks': completedSubtasks,
      'focusRating': focusRating,
      'metadata': metadata,
    };
  }

  factory CompletedPomodoroSession.fromJson(Map<String, dynamic> json) {
    return CompletedPomodoroSession(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      sessionNumber: json['sessionNumber'] as int,
      type: SessionType.values[json['type'] as int],
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      actualDuration: json['actualDuration'] as int,
      completed: json['completed'] as bool,
      notes: json['notes'] as String?,
      completedSubtasks: List<String>.from(json['completedSubtasks'] ?? []),
      focusRating: json['focusRating'] as int? ?? 5,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}
