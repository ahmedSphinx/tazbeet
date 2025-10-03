import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:tazbeet/services/app_logging.dart';
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
    on<AuthEmailSignInRequested>(_onEmailSignInRequested);
    on<AuthEmailSignUpRequested>(_onEmailSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthProfileCompleted>(_onProfileCompleted);
    on<AuthLoggedIn>(_onLoggedIn);
    on<AuthLoggedOut>(_onLoggedOut);
  }

  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) {
    AppLogging.logInfo('Auth started - initializing authentication state monitoring', name: 'AuthBloc');
    emit(AuthLoading());
    _authSubscription = _authService.authStateChanges!.listen(
      (user) {
        AppLogging.logInfo('Auth state changed - user: ${user?.uid ?? 'null'}', name: 'AuthBloc');
        if (user != null) {
          add(AuthLoggedIn());
        } else {
          add(AuthLoggedOut());
        }
      },
      onError: (error) {
        AppLogging.logError('Error in auth state changes stream', name: 'AuthBloc', error: error);
        emit(AuthError('Authentication state monitoring failed: $error'));
      },
    );
  }

  void _onSignInRequested(AuthSignInRequested event, Emitter<AuthState> emit) async {
    AppLogging.logInfo('Sign-in requested', name: 'AuthBloc');
    emit(AuthLoading());
    try {
      AppLogging.logInfo('Calling AuthService.signInWithGoogle()', name: 'AuthBloc');
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential != null) {
        AppLogging.logInfo('Sign-in successful for user: ${userCredential.user!.uid}', name: 'AuthBloc');

        // Save user data to Firestore after successful sign-in
        try {
          final user = userCredential.user!;
          // Create user model
          final userModel = model.User(id: user.uid, name: user.displayName ?? '', profileImageUrl: user.photoURL ?? '', birthday: null, createdAt: DateTime.now(), updatedAt: DateTime.now(), email: user.email);
          await _dataSyncService.saveUserData(userModel);
          AppLogging.logInfo('User data saved to Firestore successfully', name: 'AuthBloc');
        } catch (saveError) {
          AppLogging.logError('Failed to save user data to Firestore', name: 'AuthBloc', error: saveError);
          // Continue authentication even if saving fails
        }

        // Sync data from Firestore after successful sign-in
        try {
          await _dataSyncService.syncFromFirestore(userCredential.user!.uid);
          AppLogging.logInfo('Data sync completed successfully', name: 'AuthBloc');
        } catch (syncError) {
          AppLogging.logError('Data sync failed, but continuing with authentication', name: 'AuthBloc', error: syncError);
          // Don't fail authentication if sync fails, just log it
        }

        // Create default categories only for first-time users
        try {
          await _handleFirstTimeUserSetup(userCredential.user!.uid);
        } catch (setupError) {
          AppLogging.logError('First-time user setup failed, but continuing with authentication', name: 'AuthBloc', error: setupError);
        }

        emit(AuthAuthenticated(userCredential.user!));
      } else {
        AppLogging.logInfo('Sign-in cancelled by user', name: 'AuthBloc');
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      AppLogging.logError('Sign-in failed', name: 'AuthBloc', error: e);
      emit(AuthError('Failed to sign in: $e'));
    }
  }

  void _onFacebookSignInRequested(AuthFacebookSignInRequested event, Emitter<AuthState> emit) async {
    AppLogging.logInfo('Facebook sign-in requested', name: 'AuthBloc');
    emit(AuthLoading());
    try {
      AppLogging.logInfo('Calling AuthService.signInWithFacebook()', name: 'AuthBloc');
      final userCredential = await _authService.signInWithFacebook();
      if (userCredential != null) {
        AppLogging.logInfo('Facebook sign-in successful for user: ${userCredential.user!.uid}', name: 'AuthBloc');

        // Save user data to Firestore after successful sign-in
        try {
          final user = userCredential.user!;
          // Create user model
          final userModel = model.User(id: user.uid, name: user.displayName ?? '', profileImageUrl: user.photoURL ?? '', birthday: null, createdAt: DateTime.now(), updatedAt: DateTime.now(), email: user.email);
          await _dataSyncService.saveUserData(userModel);
          AppLogging.logInfo('User data saved to Firestore successfully', name: 'AuthBloc');
        } catch (saveError) {
          AppLogging.logError('Failed to save user data to Firestore', name: 'AuthBloc', error: saveError);
          // Continue authentication even if saving fails
        }

        // Sync data from Firestore after successful sign-in
        try {
          await _dataSyncService.syncFromFirestore(userCredential.user!.uid);
          AppLogging.logInfo('Data sync completed successfully', name: 'AuthBloc');
        } catch (syncError) {
          AppLogging.logError('Data sync failed, but continuing with authentication', name: 'AuthBloc', error: syncError);
          // Don't fail authentication if sync fails, just log it
        }

        // Create default categories only for first-time users
        try {
          await _handleFirstTimeUserSetup(userCredential.user!.uid);
        } catch (setupError) {
          AppLogging.logError('First-time user setup failed, but continuing with authentication', name: 'AuthBloc', error: setupError);
        }

        emit(AuthAuthenticated(userCredential.user!));
      } else {
        AppLogging.logInfo('Facebook sign-in cancelled by user', name: 'AuthBloc');
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      AppLogging.logError('Facebook sign-in failed', name: 'AuthBloc', error: e);
      emit(AuthError('Failed to sign in with Facebook: $e'));
    }
  }

  void _onEmailSignInRequested(AuthEmailSignInRequested event, Emitter<AuthState> emit) async {
    AppLogging.logInfo('Email sign-in requested for: ${event.email}', name: 'AuthBloc');
    emit(AuthLoading());
    try {
      AppLogging.logInfo('Calling AuthService.signInWithEmailAndPassword()', name: 'AuthBloc');
      final userCredential = await _authService.signInWithEmailAndPassword(event.email, event.password);
      if (userCredential != null) {
        AppLogging.logInfo('Email sign-in successful for user: ${userCredential.user!.uid}', name: 'AuthBloc');

        // Save minimal user data to Firestore after successful sign-in (without auto-populating name/birthday)
        try {
          final user = userCredential.user!;
          // Create user model with minimal data - name and birthday will be set during profile completion
          final userModel = model.User(id: user.uid, name: '', profileImageUrl: '', birthday: null, createdAt: DateTime.now(), updatedAt: DateTime.now(), email: user.email);
          await _dataSyncService.saveUserData(userModel);
          AppLogging.logInfo('Minimal user data saved to Firestore successfully', name: 'AuthBloc');
        } catch (saveError) {
          AppLogging.logError('Failed to save user data to Firestore', name: 'AuthBloc', error: saveError);
          // Continue authentication even if saving fails
        }

        // Sync data from Firestore after successful sign-in
        try {
          await _dataSyncService.syncFromFirestore(userCredential.user!.uid);
          AppLogging.logInfo('Data sync completed successfully', name: 'AuthBloc');
        } catch (syncError) {
          AppLogging.logError('Data sync failed, but continuing with authentication', name: 'AuthBloc', error: syncError);
          // Don't fail authentication if sync fails, just log it
        }

        // Create default categories only for first-time users
        try {
          await _handleFirstTimeUserSetup(userCredential.user!.uid);
        } catch (setupError) {
          AppLogging.logError('First-time user setup failed, but continuing with authentication', name: 'AuthBloc', error: setupError);
        }

        // Check if profile is complete for email login
        final isProfileComplete = await _isProfileComplete(userCredential.user!.uid);
        if (isProfileComplete) {
          emit(AuthAuthenticated(userCredential.user!));
        } else {
          emit(AuthProfileIncomplete(userCredential.user!));
        }
      } else {
        AppLogging.logInfo('Email sign-in failed', name: 'AuthBloc');
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      AppLogging.logError('Email sign-in failed', name: 'AuthBloc', error: e);
      emit(AuthError(e.toString()));
    }
  }

  void _onEmailSignUpRequested(AuthEmailSignUpRequested event, Emitter<AuthState> emit) async {
    AppLogging.logInfo('Email sign-up requested for: ${event.email}', name: 'AuthBloc');
    emit(AuthLoading());
    try {
      AppLogging.logInfo('Calling AuthService.signUpWithEmailAndPassword()', name: 'AuthBloc');
      final userCredential = await _authService.signUpWithEmailAndPassword(event.email, event.password);
      if (userCredential != null) {
        AppLogging.logInfo('Email sign-up successful for user: ${userCredential.user!.uid}', name: 'AuthBloc');

        // Save minimal user data to Firestore after successful sign-up (without auto-populating name/birthday)
        try {
          final user = userCredential.user!;
          // Create user model with minimal data - name and birthday will be set during profile completion
          final userModel = model.User(id: user.uid, name: '', profileImageUrl: '', birthday: null, createdAt: DateTime.now(), updatedAt: DateTime.now(), email: user.email);
          await _dataSyncService.saveUserData(userModel);
          AppLogging.logInfo('Minimal user data saved to Firestore successfully', name: 'AuthBloc');
        } catch (saveError) {
          AppLogging.logError('Failed to save user data to Firestore', name: 'AuthBloc', error: saveError);
          // Continue authentication even if saving fails
        }

        // Create default categories for new users
        try {
          await _handleFirstTimeUserSetup(userCredential.user!.uid);
        } catch (setupError) {
          AppLogging.logError('First-time user setup failed, but continuing with authentication', name: 'AuthBloc', error: setupError);
        }

        // For email sign-up, always require profile completion since we don't auto-populate name/birthday
        emit(AuthProfileIncomplete(userCredential.user!));
      } else {
        AppLogging.logInfo('Email sign-up failed', name: 'AuthBloc');
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      AppLogging.logError('Email sign-up failed', name: 'AuthBloc', error: e);
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _handleFirstTimeUserSetup(String userId) async {
    AppLogging.logInfo('Checking if user is first-time user: $userId', name: 'AuthBloc');

    // Check if user exists locally (indicates first-time login)
    final userRepository = UserRepository();
    await userRepository.init();

    final existingUser = await userRepository.getUser(userId);

    if (existingUser == null) {
      AppLogging.logInfo('First-time user detected, creating default categories', name: 'AuthBloc');

      // Initialize category repository and create default categories
      await _categoryRepository.init();
      await _categoryRepository.createDefaultCategories();

      AppLogging.logInfo('Default categories created successfully for first-time user', name: 'AuthBloc');
    } else {
      AppLogging.logInfo('Returning user detected, skipping default categories creation', name: 'AuthBloc');
    }
  }

  Future<bool> _isProfileComplete(String userId) async {
    AppLogging.logInfo('Checking if profile is complete for user: $userId', name: 'AuthBloc');

    try {
      final userRepository = UserRepository();
      await userRepository.init();

      final user = await userRepository.getUser(userId);

      if (user == null) {
        AppLogging.logInfo('User not found in local storage', name: 'AuthBloc');
        return false;
      }

      // Profile is complete if name is not empty/null and birthday is set
      final isComplete = user.name.isNotEmpty && user.birthday != null;
      AppLogging.logInfo('Profile completeness check: name="${user.name}", birthday=${user.birthday}, complete=$isComplete', name: 'AuthBloc');

      return isComplete;
    } catch (e) {
      AppLogging.logError('Error checking profile completeness: $e', name: 'AuthBloc', error: e);
      return false;
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

  void _onProfileCompleted(AuthProfileCompleted event, Emitter<AuthState> emit) {
    final user = _authService.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user));
    }
  }

  void _onLoggedIn(AuthLoggedIn event, Emitter<AuthState> emit) async {
    final user = _authService.currentUser;
    if (user != null) {
      // Check if profile is complete for returning users
      final isProfileComplete = await _isProfileComplete(user.uid);
      if (isProfileComplete) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthProfileIncomplete(user));
      }
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
