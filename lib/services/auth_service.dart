import 'dart:developer' as dev;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    dev.log('Starting Google Sign-In process', name: 'AuthService');
    try {
      // Trigger the authentication flow
      dev.log('Requesting Google Sign-In account', name: 'AuthService');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        dev.log('User canceled Google Sign-In', name: 'AuthService');
        return null;
      }

      dev.log('Google user authenticated: ${googleUser.email}', name: 'AuthService');

      // Obtain the auth details from the request
      dev.log('Obtaining authentication details', name: 'AuthService');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        dev.log('Failed to obtain authentication tokens', name: 'AuthService', error: 'Missing tokens');
        throw Exception('Failed to obtain authentication tokens from Google');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      dev.log('Signing in with Firebase using Google credential', name: 'AuthService');
      // Once signed in, return the UserCredential
      final userCredential = await _auth.signInWithCredential(credential);
      dev.log('Successfully signed in user: ${userCredential.user?.uid}', name: 'AuthService');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      dev.log('Firebase Auth error during Google Sign-In', name: 'AuthService', error: e);
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
      dev.log('Unexpected error during Google Sign-In', name: 'AuthService', error: e);
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    dev.log('Starting sign out process', name: 'AuthService');
    try {
      dev.log('Signing out from Google', name: 'AuthService');
      await _googleSignIn.signOut();
      dev.log('Signing out from Firebase', name: 'AuthService');
      await _auth.signOut();
      dev.log('Successfully signed out', name: 'AuthService');
    } catch (e) {
      dev.log('Error during sign out', name: 'AuthService', error: e);
      throw Exception('Failed to sign out: $e');
    }
  }

  // Get user ID token
  Future<String?> getIdToken() async {
    dev.log('Getting ID token for current user', name: 'AuthService');
    try {
      final user = _auth.currentUser;
      if (user == null) {
        dev.log('No current user found', name: 'AuthService');
        return null;
      }
      dev.log('Retrieving ID token for user: ${user.uid}', name: 'AuthService');
      final token = await user.getIdToken();
      dev.log('Successfully retrieved ID token', name: 'AuthService');
      return token;
    } catch (e) {
      dev.log('Error getting ID token', name: 'AuthService', error: e);
      throw Exception('Failed to get ID token: $e');
    }
  }
}
