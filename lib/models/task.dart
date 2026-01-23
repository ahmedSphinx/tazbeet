import 'package:equatable/equatable.dart';
import 'repeat_rule.dart';
import 'pomodoro_strategy.dart';
import 'pomodoro_plan.dart';

enum TaskPriority { low, medium, high }

enum ReminderState {
  none, // No reminder scheduled
  scheduled, // Reminder active and scheduled
  delivered, // Reminder was shown
  failed, // Scheduling failed
  cancelled, // Reminder was cancelled
}

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
  final DateTime? lastGeneratedAt; // NEW: Track when last recurring instance was generated
  final DateTime createdAt;
  final DateTime updatedAt;
  final int progress;
  final int index;
  final List<String> tags;
  final List<String> attachments;
  final List<String> voiceNotes;
  final int pomodoroCount;
  final Duration timeSpent;
  final List<Map<String, dynamic>> pomodoroSessions;
  final String? userId; // For admin panel - which user this task belongs to

  // Enhanced Pomodoro Integration
  final int estimatedSessions; // How many pomodoros needed
  final int targetSessionsPerDay; // Daily work goal
  final DateTime? lastPomodoroDate; // Track work frequency
  final List<String> sessionNotes; // Notes from each session
  final PomodoroStrategy strategy; // How to break down work
  final bool autoStartNextSubtask; // Chain subtasks in sessions

  // NEW: Enhanced Pomodoro Integration
  final PomodoroPlan? pomodoroPlan; // Detailed pomodoro breakdown
  final Duration estimatedDuration; // AI-estimated time needed
  final Duration actualDuration; // Total time spent (enhanced)
  final List<CompletedPomodoroSession> completedSessions; // Session history
  final bool isPomodoroOptimized; // Flag for pomodoro-ready tasks
  final int focusScore; // 1-10 focus difficulty rating

  // Reminder tracking fields
  final ReminderState reminderState;
  final DateTime? reminderLastAttempt;
  final int reminderRetryCount;
  final String? reminderFailureReason;

  const Task({
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
    this.lastGeneratedAt, // NEW
    required this.createdAt,
    required this.updatedAt,
    this.progress = 0,
    this.index = 0,
    this.tags = const [],
    this.attachments = const [],
    this.voiceNotes = const [],
    this.pomodoroCount = 0,
    this.timeSpent = Duration.zero,
    this.pomodoroSessions = const [],
    this.userId, // For admin panel
    // Enhanced Pomodoro Integration
    this.estimatedSessions = 1,
    this.targetSessionsPerDay = 3,
    this.lastPomodoroDate,
    this.sessionNotes = const [],
    this.strategy = PomodoroStrategy.sequential,
    this.autoStartNextSubtask = false,
    // NEW: Enhanced Pomodoro Integration
    this.pomodoroPlan,
    this.estimatedDuration = const Duration(minutes: 25),
    this.actualDuration = Duration.zero,
    this.completedSessions = const [],
    this.isPomodoroOptimized = false,
    this.focusScore = 5,
    // Reminder tracking fields
    this.reminderState = ReminderState.none,
    this.reminderLastAttempt,
    this.reminderRetryCount = 0,
    this.reminderFailureReason,
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
    DateTime? lastGeneratedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? progress,
    int? index,
    List<String>? tags,
    List<String>? attachments,
    List<String>? voiceNotes,
    int? pomodoroCount,
    Duration? timeSpent,
    List<Map<String, dynamic>>? pomodoroSessions,
    String? userId,

    // Enhanced Pomodoro Integration
    int? estimatedSessions,
    int? targetSessionsPerDay,
    DateTime? lastPomodoroDate,
    List<String>? sessionNotes,
    PomodoroStrategy? strategy,
    bool? autoStartNextSubtask,

    // NEW: Enhanced Pomodoro Integration
    PomodoroPlan? pomodoroPlan,
    Duration? estimatedDuration,
    Duration? actualDuration,
    List<CompletedPomodoroSession>? completedSessions,
    bool? isPomodoroOptimized,
    int? focusScore,

    // Reminder tracking fields
    ReminderState? reminderState,
    DateTime? reminderLastAttempt,
    int? reminderRetryCount,
    String? reminderFailureReason,
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
      lastGeneratedAt: lastGeneratedAt ?? this.lastGeneratedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      progress: progress ?? this.progress,
      index: index ?? this.index,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
      voiceNotes: voiceNotes ?? this.voiceNotes,
      pomodoroCount: pomodoroCount ?? this.pomodoroCount,
      timeSpent: timeSpent ?? this.timeSpent,
      pomodoroSessions: pomodoroSessions ?? this.pomodoroSessions,
      userId: userId ?? this.userId,

      // Enhanced Pomodoro Integration
      estimatedSessions: estimatedSessions ?? this.estimatedSessions,
      targetSessionsPerDay: targetSessionsPerDay ?? this.targetSessionsPerDay,
      lastPomodoroDate: lastPomodoroDate ?? this.lastPomodoroDate,
      sessionNotes: sessionNotes ?? this.sessionNotes,
      strategy: strategy ?? this.strategy,
      autoStartNextSubtask: autoStartNextSubtask ?? this.autoStartNextSubtask,

      // NEW: Enhanced Pomodoro Integration
      pomodoroPlan: pomodoroPlan ?? this.pomodoroPlan,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      completedSessions: completedSessions ?? this.completedSessions,
      isPomodoroOptimized: isPomodoroOptimized ?? this.isPomodoroOptimized,
      focusScore: focusScore ?? this.focusScore,

      // Reminder tracking fields
      reminderState: reminderState ?? this.reminderState,
      reminderLastAttempt: reminderLastAttempt ?? this.reminderLastAttempt,
      reminderRetryCount: reminderRetryCount ?? this.reminderRetryCount,
      reminderFailureReason: reminderFailureReason ?? this.reminderFailureReason,
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
      'lastGeneratedAt': lastGeneratedAt?.toIso8601String(), // NEW
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'progress': progress,
      'index': index,
      'tags': tags,
      'attachments': attachments,
      'voiceNotes': voiceNotes,
      'pomodoroCount': pomodoroCount,
      'timeSpent': timeSpent.inMilliseconds,
      'pomodoroSessions': pomodoroSessions,
      'userId': userId, // For admin panel
      // Enhanced Pomodoro Integration
      'estimatedSessions': estimatedSessions,
      'targetSessionsPerDay': targetSessionsPerDay,
      'lastPomodoroDate': lastPomodoroDate?.toIso8601String(),
      'sessionNotes': sessionNotes,
      'strategy': strategy.index,
      'autoStartNextSubtask': autoStartNextSubtask,

      // Reminder tracking fields
      'reminderState': reminderState.index,
      'reminderLastAttempt': reminderLastAttempt?.toIso8601String(),
      'reminderRetryCount': reminderRetryCount,
      'reminderFailureReason': reminderFailureReason,
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
        lastGeneratedAt: json['lastGeneratedAt'] != null && json['lastGeneratedAt'] is String ? DateTime.tryParse(json['lastGeneratedAt']) : null, // NEW
        createdAt: json['createdAt'] is String ? DateTime.parse(json['createdAt']) : DateTime.now(),
        updatedAt: json['updatedAt'] is String ? DateTime.parse(json['updatedAt']) : DateTime.now(),
        progress: _safeConvert(json['progress'], 0),
        index: _safeConvert(json['index'], 0),
        tags: json['tags'] is List ? List<String>.from(json['tags']) : [],
        attachments: json['attachments'] is List ? List<String>.from(json['attachments']) : [],
        voiceNotes: json['voiceNotes'] is List ? List<String>.from(json['voiceNotes']) : [],
        pomodoroCount: _safeConvert(json['pomodoroCount'], 0),
        timeSpent: json['timeSpent'] is int ? Duration(milliseconds: json['timeSpent']) : Duration.zero,
        pomodoroSessions: json['pomodoroSessions'] is List ? List<Map<String, dynamic>>.from(json['pomodoroSessions']) : [],
        userId: json['userId'], // For admin panel
        // Enhanced Pomodoro Integration
        estimatedSessions: _safeConvert(json['estimatedSessions'], 1),
        targetSessionsPerDay: _safeConvert(json['targetSessionsPerDay'], 3),
        lastPomodoroDate: json['lastPomodoroDate'] != null && json['lastPomodoroDate'] is String ? DateTime.tryParse(json['lastPomodoroDate']) : null,
        sessionNotes: json['sessionNotes'] is List ? List<String>.from(json['sessionNotes']) : [],
        strategy: json['strategy'] != null && json['strategy'] is int ? PomodoroStrategy.values[_safeConvert(json['strategy'], 0)] : PomodoroStrategy.sequential,
        autoStartNextSubtask: _safeConvert(json['autoStartNextSubtask'], false),

        // Reminder tracking fields
        reminderState: json['reminderState'] != null && json['reminderState'] is int ? ReminderState.values[_safeConvert(json['reminderState'], 0)] : ReminderState.none,
        reminderLastAttempt: json['reminderLastAttempt'] != null && json['reminderLastAttempt'] is String ? DateTime.tryParse(json['reminderLastAttempt']) : null,
        reminderRetryCount: _safeConvert(json['reminderRetryCount'], 0),
        reminderFailureReason: json['reminderFailureReason'],
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
  // Only counts subtasks, not the parent task itself (consistent with TaskDetailsBloc)
  double getCompletionProgress() {
    if (subtasks.isEmpty) return isCompleted ? 1.0 : 0.0;
    int total = 0;
    int completed = 0;
    void count(Task t) {
      total++;
      if (t.isCompleted) completed++;
      for (var s in t.subtasks) {
        count(s);
      }
    }

    for (var s in subtasks) {
      count(s);
    }
    return total == 0 ? 0.0 : completed / total;
  }

  // NEW: Helper method to get task path (breadcrumb)
  static List<String> getTaskPath(Task task, Task? rootTask) {
    final path = <String>[];

    // If we have a root task, find the path from root to this task
    if (rootTask != null) {
      path.add(rootTask.title);

      // Find the path to the target task
      bool findPath(Task node, List<String> currentPath) {
        if (node.id == task.id) {
          return true;
        }

        for (var subtask in node.subtasks) {
          currentPath.add(subtask.title);
          if (findPath(subtask, currentPath)) {
            return true;
          }
          currentPath.removeLast();
        }

        return false;
      }

      final searchPath = <String>[rootTask.title];
      if (findPath(rootTask, searchPath)) {
        return searchPath;
      }
    } else {
      // For standalone tasks, just return the title
      path.add(task.title);
    }

    return path;
  }

  // NEW: Helper method to find a task by ID in the task tree
  static Task? findTaskById(String taskId, Task rootTask) {
    if (rootTask.id == taskId) {
      return rootTask;
    }

    for (var subtask in rootTask.subtasks) {
      final found = findTaskById(taskId, subtask);
      if (found != null) {
        return found;
      }
    }

    return null;
  }

  // Extension for default reminder calculation
  DateTime? get defaultReminderDate {
    if (dueDate == null) return null;
    // Default: 1 hour before due date for high priority, 24 hours for medium, 48 hours for low
    final hoursBefore = priority == TaskPriority.high
        ? 1
        : priority == TaskPriority.medium
        ? 24
        : 48;
    return dueDate!.subtract(Duration(hours: hoursBefore));
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
    index,
    tags,
    attachments,
    voiceNotes,
    pomodoroCount,
    timeSpent,
    pomodoroSessions,
    userId,

    // Enhanced Pomodoro Integration
    estimatedSessions,
    targetSessionsPerDay,
    lastPomodoroDate,
    sessionNotes,
    strategy,
    autoStartNextSubtask,
    pomodoroPlan,
    estimatedDuration,
    actualDuration,
    completedSessions,
    isPomodoroOptimized,
    focusScore,

    // Reminder tracking fields
    reminderState,
    reminderLastAttempt,
    reminderRetryCount,
    reminderFailureReason,
  ];
}
