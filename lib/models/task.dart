import 'package:equatable/equatable.dart';
import 'repeat_rule.dart';

enum TaskPriority { low, medium, high }

class Task extends Equatable {
  final String id;
  final String title;
  final String? description;
  final TaskPriority priority;
  final DateTime? dueDate;
  final DateTime? reminderDate;
  final bool isCompleted;
  final String? categoryId;
  final String? parentId;
  final List<Task> subtasks;
  final int maxSubtaskDepth;
  final bool strictCompletionMode;
  final List<int> reminderIntervals;
  final RepeatRule? repeatRule;
  final bool isRecurringInstance;
  final String? originalTaskId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int progress;
  final List<String> tags;
  final List<String> attachments;
  final List<String> voiceNotes;
  final int pomodoroCount;
  final Duration timeSpent;
  final List<Map<String, dynamic>> pomodoroSessions;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.priority = TaskPriority.medium,
    this.dueDate,
    this.reminderDate,
    this.isCompleted = false,
    this.categoryId,
    this.parentId,
    this.subtasks = const [], // NEW
    this.maxSubtaskDepth = 3, // NEW
    this.strictCompletionMode = true, // NEW
    this.reminderIntervals = const [30, 60], // NEW
    this.repeatRule, // NEW
    this.isRecurringInstance = false, // NEW
    this.originalTaskId, // NEW
    required this.createdAt,
    required this.updatedAt,
    this.progress = 0,
    this.tags = const [],
    this.attachments = const [],
    this.voiceNotes = const [],
    this.pomodoroCount = 0,
    this.timeSpent = Duration.zero,
    this.pomodoroSessions = const [],
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    DateTime? dueDate,
    DateTime? reminderDate,
    bool? isCompleted,
    String? categoryId,
    String? parentId,
    List<Task>? subtasks,
    int? maxSubtaskDepth,
    bool? strictCompletionMode,
    List<int>? reminderIntervals,
    RepeatRule? repeatRule,
    bool? isRecurringInstance,
    String? originalTaskId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? progress,
    List<String>? tags,
    List<String>? attachments,
    List<String>? voiceNotes,
    int? pomodoroCount,
    Duration? timeSpent,
    List<Map<String, dynamic>>? pomodoroSessions,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      reminderDate: reminderDate ?? this.reminderDate,
      isCompleted: isCompleted ?? this.isCompleted,
      categoryId: categoryId ?? this.categoryId,
      parentId: parentId ?? this.parentId,
      subtasks: subtasks ?? this.subtasks,
      maxSubtaskDepth: maxSubtaskDepth ?? this.maxSubtaskDepth,
      strictCompletionMode: strictCompletionMode ?? this.strictCompletionMode,
      reminderIntervals: reminderIntervals ?? this.reminderIntervals,
      repeatRule: repeatRule ?? this.repeatRule,
      isRecurringInstance: isRecurringInstance ?? this.isRecurringInstance,
      originalTaskId: originalTaskId ?? this.originalTaskId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      progress: progress ?? this.progress,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
      voiceNotes: voiceNotes ?? this.voiceNotes,
      pomodoroCount: pomodoroCount ?? this.pomodoroCount,
      timeSpent: timeSpent ?? this.timeSpent,
      pomodoroSessions: pomodoroSessions ?? this.pomodoroSessions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.index,
      'dueDate': dueDate?.toIso8601String(),
      'reminderDate': reminderDate?.toIso8601String(),
      'isCompleted': isCompleted,
      'categoryId': categoryId,
      'parentId': parentId,
      'subtasks': subtasks.map((t) => t.toJson()).toList(), // NEW
      'maxSubtaskDepth': maxSubtaskDepth, // NEW
      'strictCompletionMode': strictCompletionMode, // NEW
      'reminderIntervals': reminderIntervals, // NEW
      'repeatRule': repeatRule?.toJson(), // NEW
      'isRecurringInstance': isRecurringInstance, // NEW
      'originalTaskId': originalTaskId, // NEW
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'progress': progress,
      'tags': tags,
      'attachments': attachments,
      'voiceNotes': voiceNotes,
      'pomodoroCount': pomodoroCount,
      'timeSpent': timeSpent.inMilliseconds,
      'pomodoroSessions': pomodoroSessions,
    };
  }

  // Helper method to safely convert any value to the expected type
  static T _safeConvert<T>(dynamic value, T defaultValue) {
    if (value is T) {
      return value;
    }
    return defaultValue;
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    try {
      return Task(
        id: _safeConvert(json['id'], ''),
        title: _safeConvert(json['title'], ''),
        description: json['description'],
        priority: json['priority'] != null && json['priority'] is int ? TaskPriority.values[_safeConvert(json['priority'], 1)] : TaskPriority.medium,
        dueDate: json['dueDate'] != null && json['dueDate'] is String ? DateTime.tryParse(json['dueDate']) : null,
        reminderDate: json['reminderDate'] != null && json['reminderDate'] is String ? DateTime.tryParse(json['reminderDate']) : null,
        isCompleted: _safeConvert(json['isCompleted'], false),
        categoryId: json['categoryId'],
        parentId: json['parentId'],
        subtasks: _parseSubtasks(json['subtasks']), // NEW
        maxSubtaskDepth: _safeConvert(json['maxSubtaskDepth'], 3), // NEW
        strictCompletionMode: _safeConvert(json['strictCompletionMode'], true), // NEW
        reminderIntervals: json['reminderIntervals'] is List ? List<int>.from(json['reminderIntervals']) : [30, 60], // NEW
        repeatRule: _parseRepeatRule(json['repeatRule']), // NEW
        isRecurringInstance: _safeConvert(json['isRecurringInstance'], false), // NEW
        originalTaskId: json['originalTaskId'],
        createdAt: json['createdAt'] is String ? DateTime.parse(json['createdAt']) : DateTime.now(),
        updatedAt: json['updatedAt'] is String ? DateTime.parse(json['updatedAt']) : DateTime.now(),
        progress: _safeConvert(json['progress'], 0),
        tags: json['tags'] is List ? List<String>.from(json['tags']) : [],
        attachments: json['attachments'] is List ? List<String>.from(json['attachments']) : [],
        voiceNotes: json['voiceNotes'] is List ? List<String>.from(json['voiceNotes']) : [],
        pomodoroCount: _safeConvert(json['pomodoroCount'], 0),
        timeSpent: json['timeSpent'] is int ? Duration(milliseconds: json['timeSpent']) : Duration.zero,
        pomodoroSessions: json['pomodoroSessions'] is List ? List<Map<String, dynamic>>.from(json['pomodoroSessions']) : [],
      );
    } catch (e) {
      // If parsing fails, return a basic task with required fields
      return Task(id: _safeConvert(json['id'], DateTime.now().millisecondsSinceEpoch.toString()), title: _safeConvert(json['title'], 'Untitled Task'), createdAt: DateTime.now(), updatedAt: DateTime.now());
    }
  }

  // Helper method to safely parse subtasks
  static List<Task> _parseSubtasks(dynamic subtasksData) {
    if (subtasksData is List) {
      return subtasksData
          .whereType<Map>()
          .map((t) {
            try {
              final Map<String, dynamic> convertedSubtask = {};
              t.forEach((key, value) {
                convertedSubtask[key.toString()] = value;
              });
              return Task.fromJson(convertedSubtask);
            } catch (e) {
              return null;
            }
          })
          .whereType<Task>()
          .toList();
    }
    return [];
  }

  // Helper method to safely parse repeat rule
  static RepeatRule? _parseRepeatRule(dynamic repeatRuleData) {
    if (repeatRuleData is Map) {
      try {
        final Map<String, dynamic> converted = {};
        repeatRuleData.forEach((key, value) {
          converted[key.toString()] = value;
        });
        return RepeatRule.fromJson(converted);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // NEW: Helper method to check if task is fully completed (recursive)
  bool isFullyCompleted() {
    if (!isCompleted) return false;
    for (final subtask in subtasks) {
      if (!subtask.isFullyCompleted()) return false;
    }
    return true;
  }

  // NEW: Helper method to get completion progress (recursive)
  double getCompletionProgress() {
    if (subtasks.isEmpty) return isCompleted ? 1.0 : 0.0;
    int total = 0;
    int completed = 0;
    void count(Task t) {
      total++;
      if (t.isCompleted) completed++;
      for (var s in t.subtasks) count(s);
    }

    count(this);
    return completed / total;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    priority,
    dueDate,
    reminderDate,
    isCompleted,
    categoryId,
    parentId,
    subtasks,
    maxSubtaskDepth,
    strictCompletionMode,
    reminderIntervals,
    repeatRule,
    isRecurringInstance,
    originalTaskId,
    createdAt,
    updatedAt,
    progress,
    tags,
    attachments,
    voiceNotes,
    pomodoroCount,
    timeSpent,
    pomodoroSessions,
  ];
}
