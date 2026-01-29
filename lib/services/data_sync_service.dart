import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tazbeet/services/app_logging_service.dart';
import 'package:tazbeet/services/sync_status_service.dart';
import 'package:tazbeet/services/auth_service.dart';
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
import 'settings_service.dart'; // Contains UserSettings class

class DataSyncService {
  // Singleton pattern
  static final DataSyncService _instance = DataSyncService._internal();
  factory DataSyncService() => _instance;
  DataSyncService._internal();

  final FirebaseFirestore? _firestore = FirebaseServiceWrapper.firestore;
  final TaskRepository _taskRepository = TaskRepository();
  final CategoryRepository _categoryRepository = CategoryRepository();
  final MoodRepository _moodRepository = MoodRepository();
  final UserRepository _userRepository = UserRepository();
  final SettingsService _settingsService = SettingsService();
  final AuthService _authService = AuthService();

  /// Get the current authenticated user ID
  String? get _currentUserId {
    final user = _authService.currentUser;
    if (user == null) {
      AppLogging.logError('No authenticated user found for Firestore sync');
      return null;
    }
    return user.uid;
  }

  /// Get user document reference with proper authentication
  DocumentReference? _getUserDocRef() {
    final userId = _currentUserId;
    if (userId == null) return null;
    return _firestore?.collection('users').doc(userId);
  }

  // Individual sync methods for sync queue
  Future<void> syncTaskToFirestore(Task task) async {
    final userDoc = _getUserDocRef();
    if (userDoc == null) {
      AppLogging.logError('Cannot sync task: No authenticated user');
      return;
    }

    try {
      // Update task with current user ID if not set
      final taskToSync = task.userId == null ? task.copyWith(userId: _currentUserId) : task;
      await userDoc.collection('tasks').doc(taskToSync.id).set(taskToSync.toJson());
      AppLogging.logInfo('Synced task to Firestore: ${taskToSync.id}');
    } catch (e) {
      AppLogging.logError('Failed to sync task to Firestore: ${task.id} - $e');
      rethrow;
    }
  }

  Future<void> deleteTaskFromFirestore(String taskId) async {
    final userDoc = _getUserDocRef();
    if (userDoc == null) {
      AppLogging.logError('Cannot delete task: No authenticated user');
      return;
    }

    if (taskId.isEmpty) {
      AppLogging.logError('Cannot delete task: taskId is empty');
      return;
    }

    try {
      await userDoc.collection('tasks').doc(taskId).delete();
      AppLogging.logInfo('Deleted task from Firestore: $taskId');
    } catch (e) {
      AppLogging.logError('Failed to delete task from Firestore: $taskId - $e');
      rethrow;
    }
  }

  Future<void> syncCategoryToFirestore(Category category) async {
    final userDoc = _getUserDocRef();
    if (userDoc == null) {
      AppLogging.logError('Cannot sync category: No authenticated user');
      return;
    }

    try {
      await userDoc.collection('categories').doc(category.id).set(category.toJson());
      AppLogging.logInfo('Synced category to Firestore: ${category.id}');
    } catch (e) {
      AppLogging.logError('Failed to sync category to Firestore: ${category.id} - $e');
      rethrow;
    }
  }

  Future<void> deleteCategoryFromFirestore(String categoryId) async {
    final userDoc = _getUserDocRef();
    if (userDoc == null) {
      AppLogging.logError('Cannot delete category: No authenticated user');
      return;
    }

    try {
      await userDoc.collection('categories').doc(categoryId).delete();
      AppLogging.logInfo('Deleted category from Firestore: $categoryId');
    } catch (e) {
      AppLogging.logError('Failed to delete category from Firestore: $categoryId - $e');
      rethrow;
    }
  }

  // Sync data from Firestore to local storage after sign-in
  Future<void> syncFromFirestore(String userId) async {
    if (_firestore == null) {
      AppLogging.logInfo('Firestore not available, skipping sync', name: 'DataSyncService');
      return;
    }

    AppLogging.logInfo('Starting data sync from Firestore for user: $userId', name: 'DataSyncService');
    SyncStatusService().startSync();

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

      // Sync user settings
      await _syncSettingsFromFirestore(userId);

      // Note: Subtasks are already embedded in parent tasks, no separate sync needed

      AppLogging.logInfo('Data sync from Firestore completed successfully', name: 'DataSyncService');
      SyncStatusService().syncCompleted();
    } catch (e) {
      AppLogging.logError('Error syncing data from Firestore: $e', name: 'DataSyncService');
      SyncStatusService().syncFailed(e.toString());
      rethrow;
    }
  }

  // Sync data from local storage to Firestore
  Future<void> syncToFirestore(String userId) async {
    if (_firestore == null) {
      AppLogging.logInfo('Firestore not available, skipping sync', name: 'DataSyncService');
      return;
    }

    AppLogging.logInfo('Starting data sync to Firestore for user: $userId', name: 'DataSyncService');
    SyncStatusService().startSync();

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

      // Sync user settings
      await _syncSettingsToFirestore(userId);

      // Note: Subtasks are already embedded in parent tasks, no separate sync needed

      AppLogging.logInfo('Data sync to Firestore completed successfully', name: 'DataSyncService');
      SyncStatusService().syncCompleted();
    } catch (e) {
      AppLogging.logError('Error during data sync to Firestore', name: 'DataSyncService', error: e);
      SyncStatusService().syncFailed(e.toString());
      throw Exception('Failed to sync data to Firestore: $e');
    }
  }

  Future<void> _syncTasksFromFirestore(String userId) async {
    AppLogging.logInfo('Syncing tasks from Firestore', name: 'DataSyncService');

    final tasksRef = _firestore!.collection('users').doc(userId).collection('tasks');
    final snapshot = await tasksRef.get();

    final firestoreTasks = snapshot.docs.map((doc) {
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

    // Get local tasks to compare
    final localTasks = await _taskRepository.getAllTasks();
    final localTaskIds = localTasks.map((t) => t.id).toSet();
    final firestoreTaskIds = firestoreTasks.map((t) => t.id).toSet();

    // Delete local tasks that don't exist in Firestore
    final tasksToDelete = localTaskIds.difference(firestoreTaskIds);
    for (final taskId in tasksToDelete) {
      await _taskRepository.deleteTask(taskId);
    }

    // Add or update tasks from Firestore (merge strategy - no data loss window)
    for (final task in firestoreTasks) {
      await _taskRepository.addTask(task); // addTask uses put(), which updates if exists
    }

    AppLogging.logInfo('Synced ${firestoreTasks.length} tasks from Firestore (merged with local)', name: 'DataSyncService');
  }

  Future<void> _syncCategoriesFromFirestore(String userId) async {
    AppLogging.logInfo('Syncing categories from Firestore', name: 'DataSyncService');

    final categoriesRef = _firestore!.collection('users').doc(userId).collection('categories');
    final snapshot = await categoriesRef.get();

    final firestoreCategories = snapshot.docs.map((doc) {
      final data = doc.data();
      return Category(id: doc.id, name: data['name'] ?? '', color: Color(data['color'] ?? 0xFF2196F3), icon: data['icon'] ?? 'folder', createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : DateTime.now());
    }).toList();

    // Add or update categories from Firestore
    for (final category in firestoreCategories) {
      await _categoryRepository.addCategory(category); // addCategory uses put(), which updates if exists
    }

    AppLogging.logInfo('Synced ${firestoreCategories.length} categories from Firestore (merged with local)', name: 'DataSyncService');
  }

  Future<void> _syncMoodsFromFirestore(String userId) async {
    AppLogging.logInfo('Syncing moods from Firestore', name: 'DataSyncService');

    final moodsRef = _firestore!.collection('users').doc(userId).collection('moods');
    final snapshot = await moodsRef.get();

    final firestoreMoods = snapshot.docs.map((doc) {
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

    // Get local moods to compare
    final localMoods = await _moodRepository.getAllMoods();
    final localMoodIds = localMoods.map((m) => m.id).toSet();
    final firestoreMoodIds = firestoreMoods.map((m) => m.id).toSet();

    // Delete local moods that don't exist in Firestore
    final moodsToDelete = localMoodIds.difference(firestoreMoodIds);
    for (final moodId in moodsToDelete) {
      await _moodRepository.deleteMood(moodId);
    }

    // Add or update moods from Firestore (merge strategy - no data loss window)
    for (final mood in firestoreMoods) {
      await _moodRepository.addMood(mood); // addMood uses put(), which updates if exists
    }

    AppLogging.logInfo('Synced ${firestoreMoods.length} moods from Firestore (merged with local)', name: 'DataSyncService');
  }

  Future<void> _syncTasksToFirestore(String userId) async {
    AppLogging.logInfo('Syncing tasks to Firestore', name: 'DataSyncService');

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
      AppLogging.logInfo('Deleting task $taskId from Firestore', name: 'DataSyncService');
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
    AppLogging.logInfo('Synced ${localTasks.length} tasks to Firestore, deleted ${tasksToDelete.length} tasks', name: 'DataSyncService');
  }

  Future<void> _syncCategoriesToFirestore(String userId) async {
    AppLogging.logInfo('Syncing categories to Firestore', name: 'DataSyncService');

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
      AppLogging.logInfo('Deleting category $categoryId from Firestore', name: 'DataSyncService');
    }

    // Add/update categories that exist locally
    for (final category in localCategories) {
      final categoryRef = categoriesRef.doc(category.id);
      batch.set(categoryRef, {'name': category.name, 'color': category.color.value, 'icon': category.icon, 'createdAt': category.createdAt.toIso8601String()});
    }

    await batch.commit();
    AppLogging.logInfo('Synced ${localCategories.length} categories to Firestore, deleted ${categoriesToDelete.length} categories', name: 'DataSyncService');
  }

  Future<void> _syncMoodsToFirestore(String userId) async {
    AppLogging.logInfo('Syncing moods to Firestore', name: 'DataSyncService');

    final localMoods = await _moodRepository.getAllMoods();
    final localMoodIds = localMoods.map((mood) => mood.id).toSet();

    final batch = _firestore!.batch();
    final moodsRef = _firestore.collection('users').doc(userId).collection('moods');

    // Get all moods currently in Firestore
    final firestoreSnapshot = await moodsRef.get();
    final firestoreMoodIds = firestoreSnapshot.docs.map((doc) => doc.id).toSet();

    // Delete moods from Firestore that don't exist locally (handles deletions)
    final moodsToDelete = firestoreMoodIds.difference(localMoodIds);
    for (final moodId in moodsToDelete) {
      batch.delete(moodsRef.doc(moodId));
      AppLogging.logInfo('Deleting mood $moodId from Firestore', name: 'DataSyncService');
    }

    // Add/update moods that exist locally (with all fields)
    for (final mood in localMoods) {
      final moodRef = moodsRef.doc(mood.id);
      batch.set(moodRef, {'level': mood.level.index, 'note': mood.note, 'date': mood.date.toIso8601String(), 'createdAt': mood.createdAt.toIso8601String(), 'updatedAt': mood.updatedAt.toIso8601String(), 'tags': mood.tags, 'energyLevel': mood.energyLevel, 'focusLevel': mood.focusLevel, 'stressLevel': mood.stressLevel});
    }

    await batch.commit();
    AppLogging.logInfo('Synced ${localMoods.length} moods to Firestore, deleted ${moodsToDelete.length} moods', name: 'DataSyncService');
  }

  Future<void> _syncUserFromFirestore(String userId) async {
    AppLogging.logInfo('Syncing user profile from Firestore', name: 'DataSyncService');

    // Since UserRepository.getUser already fetches from Firestore if not local
    await _userRepository.getUser(userId);

    AppLogging.logInfo('Synced user profile from Firestore', name: 'DataSyncService');
  }

  Future<void> _syncUserToFirestore(String userId) async {
    AppLogging.logInfo('Syncing user profile to Firestore', name: 'DataSyncService');

    final user = await _userRepository.getUser(userId);
    if (user != null) {
      // Since UserRepository.saveUser already saves to Firestore
      await _userRepository.saveUser(user);
    }

    AppLogging.logInfo('Synced user profile to Firestore', name: 'DataSyncService');
  }

  Future<void> _syncSettingsFromFirestore(String userId) async {
    AppLogging.logInfo('Syncing user settings from Firestore', name: 'DataSyncService');

    final settingsRef = _firestore!.collection('users').doc(userId).collection('settings').doc('user_settings');
    final doc = await settingsRef.get();

    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        final settings = UserSettings.fromJson(data);
        await _settingsService.updateSettings(settings);
      }
    }

    AppLogging.logInfo('Synced user settings from Firestore', name: 'DataSyncService');
  }

  Future<void> _syncSettingsToFirestore(String userId) async {
    AppLogging.logInfo('Syncing user settings to Firestore', name: 'DataSyncService');

    final settingsRef = _firestore!.collection('users').doc(userId).collection('settings').doc('user_settings');
    final settingsJson = _settingsService.settings.toJson();
    await settingsRef.set(settingsJson);

    AppLogging.logInfo('Synced user settings to Firestore', name: 'DataSyncService');
  }

  // Public method to save user data during sign-in
  Future<void> saveUserData(User user) async {
    await _userRepository.init();
    await _userRepository.saveUser(user);
  }

  // Note: Subtask sync methods removed - subtasks are now embedded in parent task's subtasks field
  // and synced together with the parent task in _syncTasksToFirestore/_syncTasksFromFirestore
}
