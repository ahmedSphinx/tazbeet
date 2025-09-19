import 'dart:async';
import 'dart:developer' as dev;
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:tazbeet/services/auth_service.dart';
import 'package:tazbeet/services/data_sync_service.dart';
import 'package:tazbeet/models/user.dart' as model;
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final DataSyncService _dataSyncService = DataSyncService();
  StreamSubscription<firebase_auth.User?>? _authSubscription;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthSignInRequested>(_onSignInRequested);
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
