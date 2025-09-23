import 'dart:async';
import 'dart:developer' as dev;
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:tazbeet/services/auth_service.dart';
import 'package:tazbeet/services/data_sync_service.dart';
import 'package:tazbeet/models/user.dart' as model;
import 'package:tazbeet/repositories/category_repository.dart';
import 'package:tazbeet/repositories/user_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final DataSyncService _dataSyncService = DataSyncService();
  final CategoryRepository _categoryRepository = CategoryRepository();
  StreamSubscription<firebase_auth.User?>? _authSubscription;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthFacebookSignInRequested>(_onFacebookSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthLoggedIn>(_onLoggedIn);
    on<AuthLoggedOut>(_onLoggedOut);
  }

  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) {
    dev.log('Auth started - initializing authentication state monitoring', name: 'AuthBloc');
    emit(AuthLoading());
    _authSubscription = _authService.authStateChanges.listen((user) {
      dev.log('Auth state changed - user: ${user?.uid ?? 'null'}', name: 'AuthBloc');
      if (user != null) {
        add(AuthLoggedIn());
      } else {
        add(AuthLoggedOut());
      }
    }, onError: (error) {
      dev.log('Error in auth state changes stream', name: 'AuthBloc', error: error);
      emit(AuthError('Authentication state monitoring failed: $error'));
    });
  }

  void _onSignInRequested(AuthSignInRequested event, Emitter<AuthState> emit) async {
    dev.log('Sign-in requested', name: 'AuthBloc');
    emit(AuthLoading());
    try {
      dev.log('Calling AuthService.signInWithGoogle()', name: 'AuthBloc');
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential != null) {
        dev.log('Sign-in successful for user: ${userCredential.user!.uid}', name: 'AuthBloc');

        // Save user data to Firestore after successful sign-in
        try {
          final user = userCredential.user!;
          // Create user model
          final userModel = model.User(
            id: user.uid,
            name: user.displayName ?? '',
            profileImageUrl: user.photoURL ?? '',
            birthday: null,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await _dataSyncService.saveUserData(userModel);
          dev.log('User data saved to Firestore successfully', name: 'AuthBloc');
        } catch (saveError) {
          dev.log('Failed to save user data to Firestore', name: 'AuthBloc', error: saveError);
          // Continue authentication even if saving fails
        }

        // Sync data from Firestore after successful sign-in
        try {
          await _dataSyncService.syncFromFirestore(userCredential.user!.uid);
          dev.log('Data sync completed successfully', name: 'AuthBloc');
        } catch (syncError) {
          dev.log('Data sync failed, but continuing with authentication', name: 'AuthBloc', error: syncError);
          // Don't fail authentication if sync fails, just log it
        }

        // Create default categories only for first-time users
        try {
          await _handleFirstTimeUserSetup(userCredential.user!.uid);
        } catch (setupError) {
          dev.log('First-time user setup failed, but continuing with authentication', name: 'AuthBloc', error: setupError);
        }

        emit(AuthAuthenticated(userCredential.user!));
      } else {
        dev.log('Sign-in cancelled by user', name: 'AuthBloc');
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      dev.log('Sign-in failed', name: 'AuthBloc', error: e);
      emit(AuthError('Failed to sign in: $e'));
    }
  }

  void _onFacebookSignInRequested(AuthFacebookSignInRequested event, Emitter<AuthState> emit) async {
    dev.log('Facebook sign-in requested', name: 'AuthBloc');
    emit(AuthLoading());
    try {
      dev.log('Calling AuthService.signInWithFacebook()', name: 'AuthBloc');
      final userCredential = await _authService.signInWithFacebook();
      if (userCredential != null) {
        dev.log('Facebook sign-in successful for user: ${userCredential.user!.uid}', name: 'AuthBloc');

        // Save user data to Firestore after successful sign-in
        try {
          final user = userCredential.user!;
          // Create user model
          final userModel = model.User(
            id: user.uid,
            name: user.displayName ?? '',
            profileImageUrl: user.photoURL ?? '',
            birthday: null,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await _dataSyncService.saveUserData(userModel);
          dev.log('User data saved to Firestore successfully', name: 'AuthBloc');
        } catch (saveError) {
          dev.log('Failed to save user data to Firestore', name: 'AuthBloc', error: saveError);
          // Continue authentication even if saving fails
        }

        // Sync data from Firestore after successful sign-in
        try {
          await _dataSyncService.syncFromFirestore(userCredential.user!.uid);
          dev.log('Data sync completed successfully', name: 'AuthBloc');
        } catch (syncError) {
          dev.log('Data sync failed, but continuing with authentication', name: 'AuthBloc', error: syncError);
          // Don't fail authentication if sync fails, just log it
        }

        // Create default categories only for first-time users
        try {
          await _handleFirstTimeUserSetup(userCredential.user!.uid);
        } catch (setupError) {
          dev.log('First-time user setup failed, but continuing with authentication', name: 'AuthBloc', error: setupError);
        }

        emit(AuthAuthenticated(userCredential.user!));
      } else {
        dev.log('Facebook sign-in cancelled by user', name: 'AuthBloc');
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      dev.log('Facebook sign-in failed', name: 'AuthBloc', error: e);
      emit(AuthError('Failed to sign in with Facebook: $e'));
    }
  }

  Future<void> _handleFirstTimeUserSetup(String userId) async {
    dev.log('Checking if user is first-time user: $userId', name: 'AuthBloc');

    // Check if user exists locally (indicates first-time login)
    final userRepository = UserRepository();
    await userRepository.init();

    final existingUser = await userRepository.getUser(userId);

    if (existingUser == null) {
      dev.log('First-time user detected, creating default categories', name: 'AuthBloc');

      // Initialize category repository and create default categories
      await _categoryRepository.init();
      await _categoryRepository.createDefaultCategories();

      dev.log('Default categories created successfully for first-time user', name: 'AuthBloc');
    } else {
      dev.log('Returning user detected, skipping default categories creation', name: 'AuthBloc');
    }
  }

  void _onSignOutRequested(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authService.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Failed to sign out: $e'));
    }
  }

  void _onLoggedIn(AuthLoggedIn event, Emitter<AuthState> emit) {
    final user = _authService.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  void _onLoggedOut(AuthLoggedOut event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticated());
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
