import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tazbeet/services/app_logging.dart';
import 'package:tazbeet/services/firebase_service_wrapper.dart';

class AuthService {
  final FirebaseAuth? _auth = FirebaseServiceWrapper.firebaseAuth;
  final GoogleSignIn? _googleSignIn = FirebaseServiceWrapper.googleSignIn;

  // Stream of authentication state changes
  Stream<User?>? get authStateChanges {
    return _auth?.authStateChanges();
  }

  // Get current user
  User? get currentUser => _auth?.currentUser;

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    if (_googleSignIn == null || _auth == null) {
      AppLogging.logInfo('Google Sign-In not available', name: 'AuthService');
      return null;
    }

    AppLogging.logInfo('Starting Google Sign-In process', name: 'AuthService');
    try {
      // Trigger the authentication flow
      AppLogging.logInfo('Requesting Google Sign-In account', name: 'AuthService');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        AppLogging.logInfo('User canceled Google Sign-In', name: 'AuthService');
        return null;
      }

      AppLogging.logInfo('Google user authenticated: ${googleUser.email}', name: 'AuthService');

      // Obtain the auth details from the request
      AppLogging.logInfo('Obtaining authentication details', name: 'AuthService');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        AppLogging.logError ('Failed to obtain authentication tokens', name: 'AuthService', error: 'Missing tokens');
        throw Exception('Failed to obtain authentication tokens from Google');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      AppLogging.logInfo('Signing in with Firebase using Google credential', name: 'AuthService');
      // Once signed in, return the UserCredential
      final userCredential = await _auth.signInWithCredential(credential);
      AppLogging.logInfo('Successfully signed in user: ${userCredential.user?.uid}', name: 'AuthService');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      AppLogging.logError('Firebase Auth error during Google Sign-In', name: 'AuthService', error: e);
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw Exception('Account exists with different sign-in method');
        case 'invalid-credential':
          throw Exception('Invalid Google credential');
        case 'user-disabled':
          throw Exception('User account has been disabled');
        case 'user-not-found':
          throw Exception('User not found');
        case 'wrong-password':
          throw Exception('Wrong password');
        default:
          throw Exception('Authentication failed: ${e.message}');
      }
    } catch (e) {
      AppLogging.logError('Unexpected error during Google Sign-In', name: 'AuthService', error: e);
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  // Sign in with Facebook
  Future<UserCredential?> signInWithFacebook() async {
    if (_auth == null) {
      AppLogging.logInfo('Firebase Auth not available', name: 'AuthService');
      return null;
    }

    AppLogging.logInfo('Starting Facebook Sign-In process', name: 'AuthService');
    try {
      // Trigger the sign-in flow
      AppLogging.logInfo('Requesting Facebook login', name: 'AuthService');
      final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);

      if (loginResult.status != LoginStatus.success) {
        AppLogging.logInfo('Facebook login failed or was cancelled', name: 'AuthService');
        return null;
      }

      AppLogging.logInfo('Facebook login successful', name: 'AuthService');

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

      AppLogging.logInfo('Signing in with Firebase using Facebook credential', name: 'AuthService');
      // Once signed in, return the UserCredential
      final userCredential = await _auth.signInWithCredential(facebookAuthCredential);
      AppLogging.logInfo('Successfully signed in user: ${userCredential.user?.uid}', name: 'AuthService');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      AppLogging.logError('Firebase Auth error during Facebook Sign-In', name: 'AuthService', error: e);
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw Exception('Account exists with different sign-in method');
        case 'invalid-credential':
          throw Exception('Invalid Facebook credential');
        case 'user-disabled':
          throw Exception('User account has been disabled');
        case 'user-not-found':
          throw Exception('User not found');
        default:
          throw Exception('Authentication failed: ${e.message}');
      }
    } catch (e) {
      AppLogging.logError('Unexpected error during Facebook Sign-In', name: 'AuthService', error: e);
      throw Exception('Failed to sign in with Facebook: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    if (_googleSignIn == null || _auth == null) {
      AppLogging.logInfo('Sign out not available', name: 'AuthService');
      return;
    }

    AppLogging.logInfo('Starting sign out process', name: 'AuthService');
    try {
      AppLogging.logInfo('Signing out from Google', name: 'AuthService');
      await _googleSignIn.signOut();
      AppLogging.logInfo('Signing out from Facebook', name: 'AuthService');
      await FacebookAuth.instance.logOut();
      AppLogging.logInfo('Signing out from Firebase', name: 'AuthService');
      await _auth.signOut();

      // Clear all caches and memories after successful sign out
      AppLogging.logInfo('Clearing all caches and memories', name: 'AuthService');
      await _clearAllCachesAndMemories();

      AppLogging.logInfo('Successfully signed out and cleared all data', name: 'AuthService');
    } catch (e) {
      AppLogging.logError('Error during sign out', name: 'AuthService', error: e);
      throw Exception('Failed to sign out: $e');
    }
  }

  // Clear all caches and memories
  Future<void> _clearAllCachesAndMemories() async {
    try {
      AppLogging.logInfo('Starting cache and memory cleanup', name: 'AuthService');

      // Clear SharedPreferences
      AppLogging.logInfo('Clearing SharedPreferences', name: 'AuthService');
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      AppLogging.logInfo('SharedPreferences cleared successfully', name: 'AuthService');

      // Clear all Hive box data but keep boxes intact
      AppLogging.logInfo('Clearing Hive box data', name: 'AuthService');

      // List of known box names to clear
      final boxNames = ['tasks', 'categories', 'moods', 'users'];

      for (final boxName in boxNames) {
        try {
          if (Hive.isBoxOpen(boxName)) {
            final box = Hive.box(boxName);
            await box.clear();
            AppLogging.logInfo('Cleared data from open box: $boxName', name: 'AuthService');
          } else {
            // Try to open and clear the box
            final box = await Hive.openBox(boxName);
            await box.clear();
            await box.close();
            AppLogging.logInfo('Opened, cleared, and closed box: $boxName', name: 'AuthService');
          }
        } catch (e) {
          AppLogging.logInfo('Error clearing box $boxName: $e', name: 'AuthService');
          // Continue with other boxes
        }
      }

      AppLogging.logInfo('All Hive box data cleared successfully', name: 'AuthService');

      // Clear any cached images or other temporary data
      AppLogging.logInfo('Cache and memory cleanup completed', name: 'AuthService');
    } catch (e) {
      AppLogging.logError('Error during cache cleanup', name: 'AuthService', error: e);
      // Don't throw here as sign out was successful, just log the cleanup error
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    if (_auth == null) {
      AppLogging.logInfo('Firebase Auth not available', name: 'AuthService');
      return null;
    }

    AppLogging.logInfo('Starting email/password sign-in process', name: 'AuthService');
    try {
      AppLogging.logInfo('Signing in with email: $email', name: 'AuthService');
      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      AppLogging.logInfo('Successfully signed in user: ${userCredential.user?.uid}', name: 'AuthService');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      AppLogging.logError('Firebase Auth error during email sign-in', name: 'AuthService', error: e);
      switch (e.code) {
        case 'user-disabled':
          throw Exception('User account has been disabled');
        case 'user-not-found':
          throw Exception('No user found with this email');
        case 'wrong-password':
          throw Exception('Wrong password provided');
        case 'invalid-email':
          throw Exception('Invalid email address');
        case 'too-many-requests':
          throw Exception('Too many failed login attempts. Please try again later');
        default:
          throw Exception('Login failed: ${e.message}');
      }
    } catch (e) {
      AppLogging.logError('Unexpected error during email sign-in', name: 'AuthService', error: e);
      throw Exception('Failed to sign in: $e');
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(String email, String password) async {
    if (_auth == null) {
      AppLogging.logInfo('Firebase Auth not available', name: 'AuthService');
      return null;
    }

    AppLogging.logInfo('Starting email/password sign-up process', name: 'AuthService');
    try {
      AppLogging.logInfo('Creating account with email: $email', name: 'AuthService');
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      AppLogging.logInfo('Successfully created account for user: ${userCredential.user?.uid}', name: 'AuthService');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      AppLogging.logError('Firebase Auth error during email sign-up', name: 'AuthService', error: e);
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('An account already exists with this email');
        case 'invalid-email':
          throw Exception('Invalid email address');
        case 'operation-not-allowed':
          throw Exception('Email/password accounts are not enabled');
        case 'weak-password':
          throw Exception('Password is too weak. Please choose a stronger password');
        default:
          throw Exception('Registration failed: ${e.message}');
      }
    } catch (e) {
      AppLogging.logError('Unexpected error during email sign-up', name: 'AuthService', error: e);
      throw Exception('Failed to create account: $e');
    }
  }

  // Get user ID token
  Future<String?> getIdToken() async {
    if (_auth == null) {
      AppLogging.logInfo('Firebase Auth not available', name: 'AuthService');
      return null;
    }

    AppLogging.logInfo('Getting ID token for current user', name: 'AuthService');
    try {
      final user = _auth.currentUser;
      if (user == null) {
        AppLogging.logInfo('No current user found', name: 'AuthService');
        return null;
      }
      AppLogging.logInfo('Retrieving ID token for user: ${user.uid}', name: 'AuthService');
      final token = await user.getIdToken();
      AppLogging.logInfo('Successfully retrieved ID token', name: 'AuthService');
      return token;
    } catch (e) {
      AppLogging.logError('Error getting ID token', name: 'AuthService', error: e);
      throw Exception('Failed to get ID token: $e');
    }
  }
}
