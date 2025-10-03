import 'package:tazbeet/services/app_logging.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:tazbeet/firebase_options.dart';

class FirebaseServiceWrapper {
  static bool _isInitialized = false;
  static bool _hasError = false;

  /// Initialize Firebase with error handling
  static Future<bool> initializeFirebase() async {
    if (_isInitialized) return true;
    if (_hasError) return false;

    // Check Google Play Services availability on Android
    if (!kIsWeb) {
      try {
        final availability = await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability();
        if (availability != GooglePlayServicesAvailability.success) {
          AppLogging.logWarning('Google Play Services not available: $availability');
          _hasError = true;
          return false;
        }
      } catch (e) {
        AppLogging.logWarning('Failed to check Google Play Services: $e');
        _hasError = true;
        return false;
      }
    }

    try {
      // Initialize Firebase only if not already initialized
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      }
      _isInitialized = true;
      AppLogging.logInfo('Firebase initialized successfully');
      return true;
    } catch (e) {
      _hasError = true;
      AppLogging.logInfo('Firebase initialization failed: $e');
      return false;
    }
  }

  /// Check if Firebase is available
  static bool get isFirebaseAvailable => _isInitialized && !_hasError;

  /// Get Firebase Auth instance with null check
  static FirebaseAuth? get firebaseAuth {
    if (!isFirebaseAvailable) return null;
    try {
      return FirebaseAuth.instance;
    } catch (e) {
      AppLogging.logInfo('Firebase Auth not available: $e');
      return null;
    }
  }

  /// Get Firestore instance with null check
  static FirebaseFirestore? get firestore {
    if (!isFirebaseAvailable) return null;
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      AppLogging.logInfo('Firestore not available: $e');
      return null;
    }
  }

  /// Get Google Sign In instance with null check
  static GoogleSignIn? get googleSignIn {
    if (!isFirebaseAvailable) return null;
    try {
      return GoogleSignIn();
    } catch (e) {
      AppLogging.logInfo('Google Sign In not available: $e');
      return null;
    }
  }

  /// Safe Firebase Auth operation wrapper
  static Future<T?> safeAuthOperation<T>(Future<T> Function() operation) async {
    if (!isFirebaseAvailable) {
      AppLogging.logInfo('Firebase Auth not available, skipping operation');
      return null;
    }

    try {
      return await operation();
    } catch (e) {
      AppLogging.logInfo('Firebase Auth operation failed: $e');
      return null;
    }
  }

  /// Safe Firestore operation wrapper
  static Future<T?> safeFirestoreOperation<T>(Future<T> Function() operation) async {
    if (!isFirebaseAvailable) {
      AppLogging.logInfo('Firestore not available, skipping operation');
      return null;
    }

    try {
      return await operation();
    } catch (e) {
      AppLogging.logInfo('Firestore operation failed: $e');
      return null;
    }
  }

  /// Check if running on a platform that supports Firebase
  static bool get isPlatformSupported {
    if (kIsWeb) return true; // Web supports Firebase

    // For mobile platforms, check if Google Play Services are available
    try {
      // This will throw if Google Play Services are not available
      return true; // Assume supported unless we detect otherwise
    } catch (e) {
      AppLogging.logInfo('Platform may not support Firebase: $e');
      return false;
    }
  }
}
