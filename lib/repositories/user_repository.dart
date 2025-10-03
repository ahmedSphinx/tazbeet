import 'package:tazbeet/services/app_logging.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../services/firebase_service_wrapper.dart';

class UserRepository {
  static const String _boxName = 'user';
  late Box<User> _box;

  FirebaseFirestore? get _firestore => FirebaseServiceWrapper.firestore;

  Future<void> init() async {
    _box = await Hive.openBox<User>(_boxName);
  }

  Future<User?> getUser(String userId) async {
    // Try local first
    final localUser = _box.get(userId);
    if (localUser != null) {
      return localUser;
    }

    // Fetch from Firestore if available
    if (_firestore != null) {
      try {
        final doc = await _firestore!.collection('users').doc(userId).get();
        if (doc.exists) {
          final data = doc.data();
          if (data != null) {
            // Convert Map<dynamic, dynamic> to Map<String, dynamic> safely
            final Map<String, dynamic> convertedData = {};
            data.forEach((key, value) {
              convertedData[key.toString()] = value;
            });
            final user = User.fromJson(convertedData);
            await _box.put(userId, user);
            return user;
          }
        }
      } catch (e) {
        // If Firestore fails, return null or handle error
        AppLogging.logInfo('Error fetching user from Firestore: $e');
      }
    }

    return null;
  }

  Future<void> saveUser(User user) async {
    // Save locally
    await _box.put(user.id, user);

    // Save to Firestore if available
    if (_firestore != null) {
      try {
        await _firestore!.collection('users').doc(user.id).set(user.toJson());
      } catch (e) {
        AppLogging.logInfo('Error saving user to Firestore: $e');
        // Could throw or handle differently
      }
    }
  }

  Future<void> updateUser(User user) async {
    user = user.copyWith(updatedAt: DateTime.now());
    await saveUser(user);
  }

  Future<void> deleteUser(String userId) async {
    // Delete locally
    await _box.delete(userId);

    // Delete from Firestore if available
    if (_firestore != null) {
      try {
        await _firestore!.collection('users').doc(userId).delete();
      } catch (e) {
        AppLogging.logInfo('Error deleting user from Firestore: $e');
      }
    }
  }
}
