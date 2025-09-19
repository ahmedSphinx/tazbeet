import 'package:equatable/equatable.dart';

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
  final String? parentId; // For hierarchical tasks
  final DateTime createdAt;
  final DateTime updatedAt;
  final int progress; // 0-100
  final List<String> tags;
  final List<String> attachments;
  final List<String> voiceNotes;

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
    required this.createdAt,
    required this.updatedAt,
    this.progress = 0,
    this.tags = const [],
    this.attachments = const [],
    this.voiceNotes = const [],
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
    DateTime? createdAt,
    DateTime? updatedAt,
    int? progress,
    List<String>? tags,
    List<String>? attachments,
    List<String>? voiceNotes,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      progress: progress ?? this.progress,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
      voiceNotes: voiceNotes ?? this.voiceNotes,
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'progress': progress,
      'tags': tags,
      'attachments': attachments,
      'voiceNotes': voiceNotes,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priority: TaskPriority.values[json['priority'] ?? 1],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      reminderDate: json['reminderDate'] != null ? DateTime.parse(json['reminderDate']) : null,
      isCompleted: json['isCompleted'] ?? false,
      categoryId: json['categoryId'],
      parentId: json['parentId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      progress: json['progress'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      attachments: List<String>.from(json['attachments'] ?? []),
      voiceNotes: List<String>.from(json['voiceNotes'] ?? []),
    );
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
        createdAt,
        updatedAt,
        progress,
        tags,
        attachments,
        voiceNotes,
      ];
}
