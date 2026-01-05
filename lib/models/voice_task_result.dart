import 'package:equatable/equatable.dart';
import '../models/task.dart';

/// Result of voice task processing
class VoiceTaskResult extends Equatable {
  final List<ParsedTask> tasks;
  final double confidence;
  final String originalTranscription;
  final String? audioPath;
  final List<String> alternatives;
  final Map<String, dynamic> extractedEntities;

  const VoiceTaskResult({required this.tasks, required this.confidence, required this.originalTranscription, this.audioPath, this.alternatives = const [], this.extractedEntities = const {}});

  @override
  List<Object?> get props => [tasks, confidence, originalTranscription, audioPath, alternatives, extractedEntities];

  VoiceTaskResult copyWith({List<ParsedTask>? tasks, double? confidence, String? originalTranscription, String? audioPath, List<String>? alternatives, Map<String, dynamic>? extractedEntities}) {
    return VoiceTaskResult(
      tasks: tasks ?? this.tasks,
      confidence: confidence ?? this.confidence,
      originalTranscription: originalTranscription ?? this.originalTranscription,
      audioPath: audioPath ?? this.audioPath,
      alternatives: alternatives ?? this.alternatives,
      extractedEntities: extractedEntities ?? this.extractedEntities,
    );
  }
}

/// Parsed task from voice input
class ParsedTask extends Equatable {
  final String title;
  final DateTime? dueDate;
  final DateTime? reminderDate;
  final String? categoryId;
  final TaskPriority priority;
  final List<String> subtasks;
  final double confidence;
  final String? description;

  const ParsedTask({required this.title, this.dueDate, this.reminderDate, this.categoryId, this.priority = TaskPriority.medium, this.subtasks = const [], required this.confidence, this.description});

  /// Convert to Task model
  Task toTask({String? id}) {
    return Task(
      id: id ?? 'voice_task_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      reminderDate: reminderDate,
      categoryId: categoryId,
      isCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      progress: 0,
      index: 0,
      tags: const [],
      attachments: const [],
      voiceNotes: const [],
      pomodoroCount: 0,
      timeSpent: Duration.zero,
      pomodoroSessions: const [],
      estimatedSessions: 1,
      targetSessionsPerDay: 3,
      lastPomodoroDate: null,
      sessionNotes: const [],
      autoStartNextSubtask: false,
      subtasks: const [],
      maxSubtaskDepth: 3,
      strictCompletionMode: true,
      reminderIntervals: const [30, 60],
      repeatRule: null,
      isRecurringInstance: false,
      originalTaskId: null,
      lastGeneratedAt: null,
    );
  }

  @override
  List<Object?> get props => [title, dueDate, reminderDate, categoryId, priority, subtasks, confidence, description];

  ParsedTask copyWith({String? title, DateTime? dueDate, DateTime? reminderDate, String? categoryId, TaskPriority? priority, List<String>? subtasks, double? confidence, String? description}) {
    return ParsedTask(
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      reminderDate: reminderDate ?? this.reminderDate,
      categoryId: categoryId ?? this.categoryId,
      priority: priority ?? this.priority,
      subtasks: subtasks ?? this.subtasks,
      confidence: confidence ?? this.confidence,
      description: description ?? this.description,
    );
  }
}

/// Voice task processing status
enum VoiceTaskStatus { idle, recording, processing, completed, error }

/// Voice task error types
enum VoiceTaskError { permissionDenied, recordingFailed, transcriptionFailed, parsingFailed, networkError, unknown }

/// Voice task error details
class VoiceTaskErrorDetails extends Equatable {
  final VoiceTaskError type;
  final String message;
  final String? details;

  const VoiceTaskErrorDetails({required this.type, required this.message, this.details});

  @override
  List<Object?> get props => [type, message, details];
}
