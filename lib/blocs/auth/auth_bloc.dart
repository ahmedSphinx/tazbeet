import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:tazbeet/services/app_logging_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/user_repository.dart';
import '../../repositories/category_repository.dart';
import '../../services/data_sync_service.dart';
import '../../services/admin_service.dart';
import '../../services/onboarding_service.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart' as user_model;
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final DataSyncService _dataSyncService = DataSyncService();
  final CategoryRepository _categoryRepository = CategoryRepository();
  final AdminService _adminService = AdminService();
  StreamSubscription<firebase_auth.User?>? _authSubscription;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthAppleSignInRequested>(_onAppleSignInRequested);
    on<AuthGuestModeRequested>(_onGuestModeRequested);
    // Facebook sign-in removed
    on<AuthEmailSignInRequested>(_onEmailSignInRequested);
    on<AuthEmailSignUpRequested>(_onEmailSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthProfileCompleted>(_onProfileCompleted);
    on<AuthLoggedIn>(_onLoggedIn);
    on<AuthLoggedOut>(_onLoggedOut);
  }

  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    AppLogging.logInfo('Auth started - initializing authentication state monitoring', name: 'AuthBloc');
    emit(AuthLoading());

    try {
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

      // Fallback: if no state change after 3 seconds, emit Unauthenticated
      await Future.delayed(const Duration(seconds: 3));
      if (state is AuthLoading) {
        AppLogging.logWarning('Auth timeout - no state change received, emitting AuthUnauthenticated', name: 'AuthBloc');
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      AppLogging.logError('Error initializing auth state monitoring', name: 'AuthBloc', error: e);
      emit(AuthUnauthenticated());
    }
  }

  /// Common post-sign-in handling: save user, sync data, setup first-time user
  ///
  /// IMPORTANT:
  /// - We must NOT overwrite existing profile fields like `birthday` or
  ///   `isAdmin` on every social login.
  /// - For existing users, we only merge in fresh name/photo/email data from
  ///   Firebase and keep `birthday` and `isAdmin` as they are.
  /// - For brand-new users, we create the user with `birthday: null` and
  ///   compute `isAdmin` based on whether this is the first user.
  Future<void> _handlePostSignIn({required firebase_auth.User firebaseUser, required bool useDisplayName}) async {
    // Save user data to Firestore after successful sign-in
    try {
      final userRepository = UserRepository();
      await userRepository.init();

      // Always force refresh so we see the latest Firestore state
      final existingUser = await userRepository.getUser(firebaseUser.uid, forceRefresh: true);

      user_model.User userModel;

      if (existingUser != null) {
        // Existing user:
        // - keep birthday and isAdmin
        // - merge in name/photo/email from Firebase if present
        final displayName = firebaseUser.displayName ?? '';
        final photoUrl = firebaseUser.photoURL ?? '';
        final email = firebaseUser.email ?? existingUser.email;

        userModel = existingUser.copyWith(
          name: useDisplayName && displayName.isNotEmpty ? displayName : existingUser.name,
          profileImageUrl: useDisplayName && photoUrl.isNotEmpty ? photoUrl : existingUser.profileImageUrl,
          email: email,
          updatedAt: DateTime.now(),
          // birthday and isAdmin remain unchanged
        );

        AppLogging.logInfo('Merging Google profile into existing user (isAdmin: ${existingUser.isAdmin}, birthday: ${existingUser.birthday})', name: 'AuthBloc');
      } else {
        // New user: compute admin status and start with null birthday
        final isAdmin = await _determineAdminStatus();
        userModel = user_model.User(
          id: firebaseUser.uid,
          name: useDisplayName ? (firebaseUser.displayName ?? '') : '',
          profileImageUrl: useDisplayName ? (firebaseUser.photoURL ?? '') : '',
          birthday: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          email: firebaseUser.email,
          isAdmin: isAdmin,
        );
        AppLogging.logInfo('Creating new user from Google sign-in (isAdmin: $isAdmin)', name: 'AuthBloc');

        // Send notification to admins about new user signup
        if (!isAdmin) {
          await _adminService.notifyAdminsOfNewUser(userModel);
        }
      }

      await _dataSyncService.saveUserData(userModel);
      AppLogging.logInfo('User data saved to Firestore successfully (isAdmin: ${userModel.isAdmin}, birthday: ${userModel.birthday})', name: 'AuthBloc');
    } catch (saveError) {
      AppLogging.logError('Failed to save user data to Firestore', name: 'AuthBloc', error: saveError);
    }

    // Sync data from Firestore
    try {
      await _dataSyncService.syncFromFirestore(firebaseUser.uid);
      AppLogging.logInfo('Data sync completed successfully', name: 'AuthBloc');
    } catch (syncError) {
      AppLogging.logError('Data sync failed, but continuing with authentication', name: 'AuthBloc', error: syncError);
    }

    // Create default categories for first-time users
    try {
      await _handleFirstTimeUserSetup(firebaseUser.uid);
    } catch (setupError) {
      AppLogging.logError('First-time user setup failed, but continuing with authentication', name: 'AuthBloc', error: setupError);
    }
  }

  void _onSignInRequested(AuthSignInRequested event, Emitter<AuthState> emit) async {
    AppLogging.logInfo('Sign-in requested', name: 'AuthBloc');
    emit(AuthLoading());

    try {
      // Add Firebase initialization check
      if (!_authService.isFirebaseAuthAvailable) {
        AppLogging.logError('Firebase Auth not initialized', name: 'AuthBloc');
        emit(AuthError('Authentication service not available. Please restart the app.'));
        return;
      }

      if (!_authService.isGoogleSignInAvailable) {
        AppLogging.logError('Google Sign-In not available', name: 'AuthBloc');
        emit(AuthError('Google Sign-In not available on this device.'));
        return;
      }

      AppLogging.logInfo('Calling AuthService.signInWithGoogle()', name: 'AuthBloc');
      final userCredential = await _authService.signInWithGoogle();

      if (userCredential != null) {
        AppLogging.logInfo('Sign-in successful for user: ${userCredential.user!.uid}', name: 'AuthBloc');
        await _handlePostSignIn(firebaseUser: userCredential.user!, useDisplayName: true);
        emit(AuthAuthenticated(userCredential.user!));
      } else {
        AppLogging.logInfo('Sign-in cancelled by user', name: 'AuthBloc');
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      AppLogging.logError('Sign-in failed', name: 'AuthBloc', error: e);
      final errorMessage = _cleanErrorMessage(e.toString());
      emit(AuthError(errorMessage));
    }
  }

  void _onAppleSignInRequested(AuthAppleSignInRequested event, Emitter<AuthState> emit) async {
    AppLogging.logInfo('Apple sign-in requested', name: 'AuthBloc');
    emit(AuthLoading());

    try {
      // Add Firebase initialization check
      if (!_authService.isFirebaseAuthAvailable) {
        AppLogging.logError('Firebase Auth not initialized', name: 'AuthBloc');
        emit(AuthError('Authentication service not available. Please restart the app.'));
        return;
      }

      AppLogging.logInfo('Calling AuthService.signInWithApple()', name: 'AuthBloc');
      final userCredential = await _authService.signInWithApple();

      if (userCredential != null) {
        AppLogging.logInfo('Apple sign-in successful for user: ${userCredential.user!.uid}', name: 'AuthBloc');
        await _handlePostSignIn(firebaseUser: userCredential.user!, useDisplayName: true);
        emit(AuthAuthenticated(userCredential.user!));
      } else {
        AppLogging.logInfo('Apple sign-in cancelled by user', name: 'AuthBloc');
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      AppLogging.logError('Apple sign-in failed', name: 'AuthBloc', error: e);
      final errorMessage = _cleanErrorMessage(e.toString());
      emit(AuthError(errorMessage));
    }
  }

  void _onGuestModeRequested(AuthGuestModeRequested event, Emitter<AuthState> emit) async {
    AppLogging.logInfo('Guest mode requested', name: 'AuthBloc');
    emit(AuthLoading());

    try {
      // Create a guest user session without Firebase authentication
      // We'll use a mock user object for guest mode
      final now = DateTime.now();
      final guestUser = user_model.User(id: 'guest_user', name: 'Guest User', email: 'guest@tazbeet.local', createdAt: now, updatedAt: now, isAdmin: false);
      AppLogging.logInfo('Guest mode activated', name: 'AuthBloc');

      emit(AuthenticatedAsGuest(guestUser));
    } catch (e) {
      AppLogging.logError('Failed to initialize guest mode', name: 'AuthBloc', error: e);
      emit(AuthError('Failed to start guest mode. Please try again.'));
    }
  }

  // Facebook sign-in handler removed

  void _onEmailSignInRequested(AuthEmailSignInRequested event, Emitter<AuthState> emit) async {
    AppLogging.logInfo('Email sign-in requested for: ${event.email}', name: 'AuthBloc');
    emit(AuthLoading());
    try {
      AppLogging.logInfo('Calling AuthService.signInWithEmailAndPassword()', name: 'AuthBloc');
      final userCredential = await _authService.signInWithEmailAndPassword(event.email, event.password);
      if (userCredential != null) {
        AppLogging.logInfo('Email sign-in successful for user: ${userCredential.user!.uid}', name: 'AuthBloc');
        await _handlePostSignIn(firebaseUser: userCredential.user!, useDisplayName: false);

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
      final errorMessage = _cleanErrorMessage(e.toString());
      emit(AuthError(errorMessage));
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
        await _handlePostSignIn(firebaseUser: userCredential.user!, useDisplayName: false);

        // For email sign-up, always require profile completion since we don't auto-populate name/birthday
        emit(AuthProfileIncomplete(userCredential.user!));
      } else {
        AppLogging.logInfo('Email sign-up failed', name: 'AuthBloc');
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      AppLogging.logError('Email sign-up failed', name: 'AuthBloc', error: e);
      final errorMessage = _cleanErrorMessage(e.toString());
      emit(AuthError(errorMessage));
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

      // Check if onboarding is needed for first-time users
      await _handleOnboardingForFirstTimeUser(userId);
    } else {
      AppLogging.logInfo('Returning user detected, skipping default categories creation', name: 'AuthBloc');

      // Even for returning users, check if they haven't completed onboarding
      await _handleOnboardingForReturningUser(userId);
    }
  }

  Future<void> _handleOnboardingForFirstTimeUser(String userId) async {
    try {
      final onboardingService = OnboardingService();
      final hasCompletedOnboarding = await onboardingService.hasCompletedOnboarding;

      if (!hasCompletedOnboarding) {
        AppLogging.logInfo('First-time user needs onboarding', name: 'AuthBloc');
        // Reset onboarding status to ensure it shows for first-time users
        await onboardingService.resetOnboarding();
      } else {
        AppLogging.logInfo('First-time user has already completed onboarding', name: 'AuthBloc');
      }
    } catch (e) {
      AppLogging.logError('Error checking onboarding status for first-time user: $e', name: 'AuthBloc');
    }
  }

  Future<void> _handleOnboardingForReturningUser(String userId) async {
    try {
      final onboardingService = OnboardingService();
      final hasCompletedOnboarding = await onboardingService.hasCompletedOnboarding;

      if (!hasCompletedOnboarding) {
        AppLogging.logInfo('Returning user needs onboarding', name: 'AuthBloc');
        // Reset onboarding status to ensure returning users who skipped it can complete it
        await onboardingService.resetOnboarding();
      } else {
        AppLogging.logInfo('Returning user has completed onboarding', name: 'AuthBloc');
      }
    } catch (e) {
      AppLogging.logError('Error checking onboarding status for returning user: $e', name: 'AuthBloc');
    }
  }

  /// Determine if user should be admin (first user gets admin rights)
  Future<bool> _determineAdminStatus() async {
    try {
      final isFirst = await _adminService.isFirstUser();
      if (isFirst) {
        AppLogging.logInfo('First user detected - granting admin privileges', name: 'AuthBloc');
      }
      return isFirst;
    } catch (e) {
      AppLogging.logError('Error determining admin status: $e', name: 'AuthBloc', error: e);
      return false;
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

      // Profile is complete if name is not empty/null (birthday is optional)
      final isComplete = user.name.isNotEmpty;
      AppLogging.logInfo('Profile completeness check: name="${user.name}", complete=$isComplete', name: 'AuthBloc');

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
      final errorMessage = _cleanErrorMessage(e.toString());
      emit(AuthError(errorMessage));
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

  /// Clean error message by removing "Exception: " prefix and other technical details
  String _cleanErrorMessage(String error) {
    // Remove "Exception: " prefix
    String cleaned = error.replaceFirst('Exception: ', '');
    // Remove "Failed to sign in: Exception: " redundancy
    cleaned = cleaned.replaceFirst('Failed to sign in: Exception: ', '');
    cleaned = cleaned.replaceFirst('Failed to sign in with Apple: Exception: ', '');
    return cleaned;
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
