import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';

class UserRepository {
  static const String _boxName = 'user';
  late Box<User> _box;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> init() async {
    _box = await Hive.openBox<User>(_boxName);
  }

  Future<User?> getUser(String userId) async {
    // Try local first
    final localUser = _box.get(userId);
    if (localUser != null) {
      return localUser;
    }

    // Fetch from Firestore
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final user = User.fromJson(doc.data()!);
        await _box.put(userId, user);
        return user;
      }
    } catch (e) {
      // If Firestore fails, return null or handle error
      print('Error fetching user from Firestore: $e');
    }

    return null;
  }

  Future<void> saveUser(User user) async {
    // Save locally
    await _box.put(user.id, user);

    // Save to Firestore
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } catch (e) {
      print('Error saving user to Firestore: $e');
      // Could throw or handle differently
    }
  }

  Future<void> updateUser(User user) async {
    user = user.copyWith(updatedAt: DateTime.now());
    await saveUser(user);
  }

  Future<void> deleteUser(String userId) async {
    // Delete locally
    await _box.delete(userId);

    // Delete from Firestore
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      print('Error deleting user from Firestore: $e');
    }
  }
}
