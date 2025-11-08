import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/task.dart';
import '../models/category.dart';
import '../services/firebase_service_wrapper.dart';
import '../services/app_logging.dart';

class AdminService {
  FirebaseFirestore? get _firestore => FirebaseServiceWrapper.firestore;

  /// Check if this is the first user in the system
  /// Returns true if no users exist in Firestore
  Future<bool> isFirstUser() async {
    if (_firestore == null) return false;

    try {
      final querySnapshot = await _firestore!.collection('users').limit(1).get();
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      AppLogging.logError('Error checking if first user: $e');
      return false;
    }
  }

  Future<List<User>> getAllUsers() async {
    if (_firestore == null) return [];

    try {
      final querySnapshot = await _firestore!.collection('users').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        final Map<String, dynamic> convertedData = {};
        data.forEach((key, value) {
          convertedData[key.toString()] = value;
        });
        return User.fromJson(convertedData);
      }).toList();
    } catch (e) {
      // AppLogging.logError('Error fetching users: $e');
      return [];
    }
  }

  Future<List<Task>> getAllTasks() async {
    if (_firestore == null) return [];

    try {
      final allTasks = <Task>[];

      // Get all users
      final usersSnapshot = await _firestore!.collection('users').get();

      // For each user, get their tasks
      for (final userDoc in usersSnapshot.docs) {
        final userId = userDoc.id;
        final tasksSnapshot = await _firestore!.collection('users').doc(userId).collection('tasks').get();

        for (final taskDoc in tasksSnapshot.docs) {
          final data = taskDoc.data();
          final Map<String, dynamic> convertedData = {};
          data.forEach((key, value) {
            convertedData[key.toString()] = value;
          });

          try {
            final task = Task.fromJson(convertedData).copyWith(userId: userId);
            allTasks.add(task);
          } catch (e) {
            AppLogging.logError('Error parsing task ${taskDoc.id}: $e');
          }
        }
      }

      return allTasks;
    } catch (e) {
      AppLogging.logError('Error fetching tasks: $e');
      return [];
    }
  }

  Future<List<Category>> getAllCategories() async {
    if (_firestore == null) return [];

    try {
      final querySnapshot = await _firestore!.collection('categories').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        final Map<String, dynamic> convertedData = {};
        data.forEach((key, value) {
          convertedData[key.toString()] = value;
        });
        return Category.fromJson(convertedData);
      }).toList();
    } catch (e) {
      AppLogging.logError('Error fetching categories: $e');
      return [];
    }
  }

  Future<void> updateUser(User user) async {
    if (_firestore == null) {
      throw Exception('Firebase not initialized');
    }

    try {
      await _firestore!.collection('users').doc(user.id).update(user.toJson());
      AppLogging.logInfo('User updated successfully: ${user.id}');
    } catch (e) {
      AppLogging.logError('Error updating user: $e');
      rethrow; // Propagate error to UI
    }
  }

  /// Delete user and all associated data (cascade delete)
  /// This includes: user document, all tasks, and user-specific categories
  Future<void> deleteUser(String userId) async {
    if (_firestore == null) {
      throw Exception('Firebase not initialized');
    }

    try {
      final batch = _firestore!.batch();

      // 1. Delete all user's tasks
      final tasksSnapshot = await _firestore!.collection('users').doc(userId).collection('tasks').get();

      AppLogging.logInfo('Deleting ${tasksSnapshot.docs.length} tasks for user: $userId');
      for (var taskDoc in tasksSnapshot.docs) {
        batch.delete(taskDoc.reference);
      }

      // 2. Delete all user's categories
      final categoriesSnapshot = await _firestore!.collection('users').doc(userId).collection('categories').get();

      AppLogging.logInfo('Deleting ${categoriesSnapshot.docs.length} categories for user: $userId');
      for (var categoryDoc in categoriesSnapshot.docs) {
        batch.delete(categoryDoc.reference);
      }

      // 3. Delete all user's moods (if exists)
      final moodsSnapshot = await _firestore!.collection('users').doc(userId).collection('moods').get();

      AppLogging.logInfo('Deleting ${moodsSnapshot.docs.length} moods for user: $userId');
      for (var moodDoc in moodsSnapshot.docs) {
        batch.delete(moodDoc.reference);
      }

      // 4. Delete user document itself
      final userRef = _firestore!.collection('users').doc(userId);
      batch.delete(userRef);

      // Execute all deletes atomically
      await batch.commit();

      AppLogging.logInfo('User and all associated data deleted successfully: $userId');
    } catch (e) {
      AppLogging.logError('Error deleting user and associated data: $e');
      rethrow; // Propagate error to UI
    }
  }

  Future<void> updateTask(Task task) async {
    if (_firestore == null) {
      throw Exception('Firebase not initialized');
    }

    if (task.userId == null || task.userId!.isEmpty) {
      throw Exception('Cannot update task: userId is null or empty');
    }

    try {
      await _firestore!.collection('users').doc(task.userId).collection('tasks').doc(task.id).update(task.toJson());
      AppLogging.logInfo('Task updated successfully: ${task.id}');
    } catch (e) {
      AppLogging.logError('Error updating task: $e');
      rethrow; // Propagate error to UI
    }
  }

  Future<void> deleteTask(Task task) async {
    if (_firestore == null) {
      throw Exception('Firebase not initialized');
    }

    if (task.userId == null || task.userId!.isEmpty) {
      throw Exception('Cannot delete task: userId is null or empty');
    }

    try {
      await _firestore!.collection('users').doc(task.userId).collection('tasks').doc(task.id).delete();
      AppLogging.logInfo('Task deleted successfully: ${task.id}');
    } catch (e) {
      AppLogging.logError('Error deleting task: $e');
      rethrow; // Propagate error to UI
    }
  }

  Future<void> updateCategory(Category category) async {
    if (_firestore == null) {
      throw Exception('Firebase not initialized');
    }

    try {
      await _firestore!.collection('categories').doc(category.id).update(category.toJson());
      AppLogging.logInfo('Category updated successfully: ${category.id}');
    } catch (e) {
      AppLogging.logError('Error updating category: $e');
      rethrow; // Propagate error to UI
    }
  }

  Future<void> createCategory(Category category) async {
    if (_firestore == null) {
      throw Exception('Firebase not initialized');
    }

    try {
      await _firestore!.collection('categories').doc(category.id).set(category.toJson());
      AppLogging.logInfo('Category created successfully: ${category.id}');
    } catch (e) {
      AppLogging.logError('Error creating category: $e');
      rethrow; // Propagate error to UI
    }
  }

  /// Check if any tasks are using this category
  Future<bool> categoryHasTasks(String categoryId) async {
    if (_firestore == null) return false;

    try {
      final usersSnapshot = await _firestore!.collection('users').get();

      for (var userDoc in usersSnapshot.docs) {
        final tasksWithCategory = await _firestore!.collection('users').doc(userDoc.id).collection('tasks').where('categoryId', isEqualTo: categoryId).limit(1).get();

        if (tasksWithCategory.docs.isNotEmpty) {
          return true;
        }
      }

      return false;
    } catch (e) {
      AppLogging.logError('Error checking if category has tasks: $e');
      return false;
    }
  }

  /// Delete category (with validation)
  /// Throws exception if tasks are using this category
  Future<void> deleteCategory(String categoryId) async {
    if (_firestore == null) {
      throw Exception('Firebase not initialized');
    }

    try {
      // Check if category has associated tasks
      final hasTasks = await categoryHasTasks(categoryId);

      if (hasTasks) {
        throw Exception('Cannot delete category: it is being used by one or more tasks. Please reassign or delete those tasks first.');
      }

      await _firestore!.collection('categories').doc(categoryId).delete();
      AppLogging.logInfo('Category deleted successfully: $categoryId');
    } catch (e) {
      AppLogging.logError('Error deleting category: $e');
      rethrow; // Propagate error to UI
    }
  }
}
