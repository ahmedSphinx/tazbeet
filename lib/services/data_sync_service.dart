import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../models/category.dart';
import '../models/mood.dart';
import '../models/user.dart';
import '../models/repeat_rule.dart';
import '../repositories/task_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/mood_repository.dart';
import '../repositories/user_repository.dart';
import 'firebase_service_wrapper.dart';

class DataSyncService {
  final FirebaseFirestore? _firestore = FirebaseServiceWrapper.firestore;
  final TaskRepository _taskRepository = TaskRepository();
  final CategoryRepository _categoryRepository = CategoryRepository();
  final MoodRepository _moodRepository = MoodRepository();
  final UserRepository _userRepository = UserRepository();

  // Sync data from Firestore to local storage after sign-in
  Future<void> syncFromFirestore(String userId) async {
    if (_firestore == null) {
      dev.log('Firestore not available, skipping sync', name: 'DataSyncService');
      return;
    }

    dev.log('Starting data sync from Firestore for user: $userId', name: 'DataSyncService');

    try {
      // Initialize repositories
      await _taskRepository.init();
      await _categoryRepository.init();
      await _moodRepository.init();
      await _userRepository.init();

      // Sync tasks
      await _syncTasksFromFirestore(userId);

      // Sync categories
      await _syncCategoriesFromFirestore(userId);

      // Sync moods
      await _syncMoodsFromFirestore(userId);

      // Sync user profile
      await _syncUserFromFirestore(userId);

      // Sync subtasks
      await _syncSubtasksFromFirestore(userId);

      dev.log('Data sync from Firestore completed successfully', name: 'DataSyncService');
    } catch (e) {
      dev.log('Error during data sync from Firestore', name: 'DataSyncService', error: e);
      throw Exception('Failed to sync data from Firestore: $e');
    }
  }

  // Sync data from local storage to Firestore
  Future<void> syncToFirestore(String userId) async {
    if (_firestore == null) {
      dev.log('Firestore not available, skipping sync', name: 'DataSyncService');
      return;
    }

    dev.log('Starting data sync to Firestore for user: $userId', name: 'DataSyncService');

    try {
      // Initialize repositories
      await _taskRepository.init();
      await _categoryRepository.init();
      await _moodRepository.init();
      await _userRepository.init();

      // Sync tasks
      await _syncTasksToFirestore(userId);

      // Sync categories
      await _syncCategoriesToFirestore(userId);

      // Sync moods
      await _syncMoodsToFirestore(userId);

      // Sync user profile
      await _syncUserToFirestore(userId);

      // Sync subtasks
      await _syncSubtasksToFirestore(userId);

      dev.log('Data sync to Firestore completed successfully', name: 'DataSyncService');
    } catch (e) {
      dev.log('Error during data sync to Firestore', name: 'DataSyncService', error: e);
      throw Exception('Failed to sync data to Firestore: $e');
    }
  }

  Future<void> _syncTasksFromFirestore(String userId) async {
    dev.log('Syncing tasks from Firestore', name: 'DataSyncService');

    final tasksRef = _firestore!.collection('users').doc(userId).collection('tasks');
    final snapshot = await tasksRef.get();

    final tasks = snapshot.docs.map((doc) {
      final data = doc.data();
      return Task(
        id: doc.id,
        title: data['title'] ?? '',
        description: data['description'],
        priority: TaskPriority.values[data['priority'] ?? 1],
        dueDate: data['dueDate'] != null ? DateTime.parse(data['dueDate']) : null,
        reminderDate: data['reminderDate'] != null ? DateTime.parse(data['reminderDate']) : null,
        categoryId: data['categoryId'],
        parentId: data['parentId'],
        isCompleted: data['isCompleted'] ?? false,
        subtasks: [], // Will be populated separately by subtask sync
        maxSubtaskDepth: data['maxSubtaskDepth'] ?? 3,
        strictCompletionMode: data['strictCompletionMode'] ?? true,
        reminderIntervals: data['reminderIntervals'] is List ? List<int>.from(data['reminderIntervals']) : [30, 60],
        repeatRule: data['repeatRule'] != null ? RepeatRule.fromJson(data['repeatRule']) : null,
        isRecurringInstance: data['isRecurringInstance'] ?? false,
        originalTaskId: data['originalTaskId'],
        createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : DateTime.now(),
        updatedAt: data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : DateTime.now(),
        progress: data['progress'] ?? 0,
        tags: data['tags'] is List ? List<String>.from(data['tags']) : [],
        attachments: data['attachments'] is List ? List<String>.from(data['attachments']) : [],
        voiceNotes: data['voiceNotes'] is List ? List<String>.from(data['voiceNotes']) : [],
      );
    }).toList();

    // Clear local tasks and add synced tasks using repository
    await _taskRepository.clearAllTasks();
    for (final task in tasks) {
      await _taskRepository.addTask(task);
    }

    dev.log('Synced ${tasks.length} tasks from Firestore', name: 'DataSyncService');
  }

  Future<void> _syncCategoriesFromFirestore(String userId) async {
    dev.log('Syncing categories from Firestore', name: 'DataSyncService');

    final categoriesRef = _firestore!.collection('users').doc(userId).collection('categories');
    final snapshot = await categoriesRef.get();

    final categories = snapshot.docs.map((doc) {
      final data = doc.data();
      return Category(
        id: doc.id,
        name: data['name'] ?? '',
        color: Color(data['color'] ?? 0xFF2196F3),
        icon: data['icon'] ?? 'folder',
        createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : DateTime.now(),
      );
    }).toList();

    // Clear local categories and add synced categories using repository
    final allCategories = await _categoryRepository.getAllCategories();
    for (final category in allCategories) {
      if (!category.isDefault) {
        await _categoryRepository.deleteCategory(category.id);
      }
    }
    for (final category in categories) {
      await _categoryRepository.addCategory(category);
    }

    dev.log('Synced ${categories.length} categories from Firestore', name: 'DataSyncService');
  }

  Future<void> _syncMoodsFromFirestore(String userId) async {
    dev.log('Syncing moods from Firestore', name: 'DataSyncService');

    final moodsRef = _firestore!.collection('users').doc(userId).collection('moods');
    final snapshot = await moodsRef.get();

    final moods = snapshot.docs.map((doc) {
      final data = doc.data();
      return Mood(
        id: doc.id,
        level: MoodLevel.values[data['level'] ?? 0],
        note: data['note'],
        date: data['date'] != null ? DateTime.parse(data['date']) : DateTime.now(),
        createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : DateTime.now(),
        updatedAt: data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : DateTime.now(),
      );
    }).toList();

    // Clear local moods and add synced moods using repository
    await _moodRepository.deleteAllMoods();
    for (final mood in moods) {
      await _moodRepository.addMood(mood);
    }

    dev.log('Synced ${moods.length} moods from Firestore', name: 'DataSyncService');
  }

  Future<void> _syncTasksToFirestore(String userId) async {
    dev.log('Syncing tasks to Firestore', name: 'DataSyncService');

    final localTasks = await _taskRepository.getAllTasks();
    final localTaskIds = localTasks.map((task) => task.id).toSet();

    final batch = _firestore!.batch();
    final tasksRef = _firestore.collection('users').doc(userId).collection('tasks');

    // Get all tasks currently in Firestore
    final firestoreSnapshot = await tasksRef.get();
    final firestoreTaskIds = firestoreSnapshot.docs.map((doc) => doc.id).toSet();

    // Delete tasks from Firestore that don't exist locally (handles deletions)
    final tasksToDelete = firestoreTaskIds.difference(localTaskIds);
    for (final taskId in tasksToDelete) {
      batch.delete(tasksRef.doc(taskId));
      dev.log('Deleting task $taskId from Firestore', name: 'DataSyncService');
    }

    // Add/update tasks that exist locally
    for (final task in localTasks) {
      final taskRef = tasksRef.doc(task.id);
      batch.set(taskRef, {
        'title': task.title,
        'description': task.description,
        'priority': task.priority.index,
        'dueDate': task.dueDate?.toIso8601String(),
        'reminderDate': task.reminderDate?.toIso8601String(),
        'categoryId': task.categoryId,
        'parentId': task.parentId,
        'isCompleted': task.isCompleted,
        'subtasks': task.subtasks.map((t) => t.toJson()).toList(),
        'maxSubtaskDepth': task.maxSubtaskDepth,
        'strictCompletionMode': task.strictCompletionMode,
        'reminderIntervals': task.reminderIntervals,
        'repeatRule': task.repeatRule?.toJson(),
        'isRecurringInstance': task.isRecurringInstance,
        'originalTaskId': task.originalTaskId,
        'createdAt': task.createdAt.toIso8601String(),
        'updatedAt': task.updatedAt.toIso8601String(),
        'progress': task.progress,
        'tags': task.tags,
        'attachments': task.attachments,
        'voiceNotes': task.voiceNotes,
      });
    }

    await batch.commit();
    dev.log('Synced ${localTasks.length} tasks to Firestore, deleted ${tasksToDelete.length} tasks', name: 'DataSyncService');
  }

  Future<void> _syncCategoriesToFirestore(String userId) async {
    dev.log('Syncing categories to Firestore', name: 'DataSyncService');

    final localCategories = await _categoryRepository.getAllCategories();
    final localCategoryIds = localCategories.map((category) => category.id).toSet();

    final batch = _firestore!.batch();
    final categoriesRef = _firestore.collection('users').doc(userId).collection('categories');

    // Get all categories currently in Firestore
    final firestoreSnapshot = await categoriesRef.get();
    final firestoreCategoryIds = firestoreSnapshot.docs.map((doc) => doc.id).toSet();

    // Delete categories from Firestore that don't exist locally (handles deletions)
    final categoriesToDelete = firestoreCategoryIds.difference(localCategoryIds);
    for (final categoryId in categoriesToDelete) {
      batch.delete(categoriesRef.doc(categoryId));
      dev.log('Deleting category $categoryId from Firestore', name: 'DataSyncService');
    }

    // Add/update categories that exist locally
    for (final category in localCategories) {
      final categoryRef = categoriesRef.doc(category.id);
      batch.set(categoryRef, {'name': category.name, 'color': category.color.value, 'icon': category.icon, 'createdAt': category.createdAt.toIso8601String()});
    }

    await batch.commit();
    dev.log('Synced ${localCategories.length} categories to Firestore, deleted ${categoriesToDelete.length} categories', name: 'DataSyncService');
  }

  Future<void> _syncMoodsToFirestore(String userId) async {
    dev.log('Syncing moods to Firestore', name: 'DataSyncService');

    final moods = await _moodRepository.getAllMoods();

    final batch = _firestore!.batch();
    final moodsRef = _firestore.collection('users').doc(userId).collection('moods');

    for (final mood in moods) {
      final moodRef = moodsRef.doc(mood.id);
      batch.set(moodRef, {'level': mood.level.index, 'note': mood.note, 'date': mood.date.toIso8601String(), 'createdAt': mood.createdAt.toIso8601String(), 'updatedAt': mood.updatedAt.toIso8601String()});
    }

    await batch.commit();
    dev.log('Synced ${moods.length} moods to Firestore', name: 'DataSyncService');
  }

  Future<void> _syncUserFromFirestore(String userId) async {
    dev.log('Syncing user profile from Firestore', name: 'DataSyncService');

    // Since UserRepository.getUser already fetches from Firestore if not local
    await _userRepository.getUser(userId);

    dev.log('Synced user profile from Firestore', name: 'DataSyncService');
  }

  Future<void> _syncUserToFirestore(String userId) async {
    dev.log('Syncing user profile to Firestore', name: 'DataSyncService');

    final user = await _userRepository.getUser(userId);
    if (user != null) {
      // Since UserRepository.saveUser already saves to Firestore
      await _userRepository.saveUser(user);
    }

    dev.log('Synced user profile to Firestore', name: 'DataSyncService');
  }

  // Public method to save user data during sign-in
  Future<void> saveUserData(User user) async {
    await _userRepository.init();
    await _userRepository.saveUser(user);
  }

  // Subtask synchronization methods
  Future<void> _syncSubtasksFromFirestore(String userId) async {
    dev.log('Syncing subtasks from Firestore', name: 'DataSyncService');

    final tasks = await _taskRepository.getAllTasks();

    for (final task in tasks) {
      if (task.subtasks.isNotEmpty) {
        // Update task with subtasks from Firestore
        await _syncTaskSubtasksFromFirestore(userId, task);
      }
    }

    dev.log('Subtasks sync from Firestore completed', name: 'DataSyncService');
  }

  Future<void> _syncTaskSubtasksFromFirestore(String userId, Task parentTask) async {
    final subtasksRef = _firestore!.collection('users').doc(userId).collection('tasks').doc(parentTask.id).collection('subtasks');

    final snapshot = await subtasksRef.get();

    final subtasks = snapshot.docs.map((doc) {
      final data = doc.data();
      return Task(
        id: doc.id,
        title: data['title'] ?? '',
        description: data['description'],
        priority: TaskPriority.values[data['priority'] ?? 1],
        dueDate: data['dueDate'] != null ? DateTime.parse(data['dueDate']) : null,
        reminderDate: data['reminderDate'] != null ? DateTime.parse(data['reminderDate']) : null,
        categoryId: data['categoryId'],
        parentId: parentTask.id,
        isCompleted: data['isCompleted'] ?? false,
        createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : DateTime.now(),
        updatedAt: data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : DateTime.now(),
      );
    }).toList();

    // Update the parent task with synced subtasks
    final updatedTask = parentTask.copyWith(subtasks: subtasks);
    await _taskRepository.updateTask(updatedTask);

    dev.log('Synced ${subtasks.length} subtasks for task ${parentTask.id}', name: 'DataSyncService');
  }

  Future<void> _syncSubtasksToFirestore(String userId) async {
    dev.log('Syncing subtasks to Firestore', name: 'DataSyncService');

    final tasks = await _taskRepository.getAllTasks();

    for (final task in tasks) {
      if (task.subtasks.isNotEmpty) {
        await _syncTaskSubtasksToFirestore(userId, task);
      }
    }

    dev.log('Subtasks sync to Firestore completed', name: 'DataSyncService');
  }

  Future<void> _syncTaskSubtasksToFirestore(String userId, Task parentTask) async {
    final batch = _firestore!.batch();
    final subtasksRef = _firestore.collection('users').doc(userId).collection('tasks').doc(parentTask.id).collection('subtasks');

    // Clear existing subtasks
    final existingSubtasks = await subtasksRef.get();
    for (final doc in existingSubtasks.docs) {
      batch.delete(doc.reference);
    }

    // Add current subtasks
    for (final subtask in parentTask.subtasks) {
      final subtaskRef = subtasksRef.doc(subtask.id);
      batch.set(subtaskRef, {
        'title': subtask.title,
        'description': subtask.description,
        'priority': subtask.priority.index,
        'dueDate': subtask.dueDate?.toIso8601String(),
        'reminderDate': subtask.reminderDate?.toIso8601String(),
        'categoryId': subtask.categoryId,
        'parentId': subtask.parentId,
        'isCompleted': subtask.isCompleted,
        'createdAt': subtask.createdAt.toIso8601String(),
        'updatedAt': subtask.updatedAt.toIso8601String(),
      });
    }

    await batch.commit();
    dev.log('Synced ${parentTask.subtasks.length} subtasks for task ${parentTask.id}', name: 'DataSyncService');
  }

  // Method to sync a specific task's subtasks
  Future<void> syncTaskSubtasks(String userId, Task task) async {
    if (_firestore == null) {
      dev.log('Firestore not available, skipping subtask sync', name: 'DataSyncService');
      return;
    }

    try {
      await _syncTaskSubtasksFromFirestore(userId, task);
      await _syncTaskSubtasksToFirestore(userId, task);
      dev.log('Task subtasks synced successfully', name: 'DataSyncService');
    } catch (e) {
      dev.log('Error syncing task subtasks', name: 'DataSyncService', error: e);
      throw Exception('Failed to sync task subtasks: $e');
    }
  }
}
