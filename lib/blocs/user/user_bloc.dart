import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../repositories/user_repository.dart';
import '../../models/user.dart' as model;
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<UpdateUser>(_onUpdateUser);
    on<CreateUser>(_onCreateUser);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await userRepository.init();
      final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        emit(UserError('No logged in user'));
        return;
      }
      final user = await userRepository.getUser(firebaseUser.uid);
      if (user == null) {
        // Create user from Firebase user info
        final newUser = model.User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? '',
          profileImageUrl: firebaseUser.photoURL ?? '',
          birthday: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await userRepository.saveUser(newUser);
        emit(UserLoaded(newUser));
      } else {
        // Update user name and profileImageUrl from Firebase user info if changed
        bool updated = false;
        model.User updatedUser = user;
        if (user.name != (firebaseUser.displayName ?? '')) {
          updatedUser = updatedUser.copyWith(name: firebaseUser.displayName ?? '');
          updated = true;
        }
        if (user.profileImageUrl != (firebaseUser.photoURL ?? '')) {
          updatedUser = updatedUser.copyWith(profileImageUrl: firebaseUser.photoURL ?? '');
          updated = true;
        }
        if (updated) {
          await userRepository.updateUser(updatedUser);
          emit(UserLoaded(updatedUser));
        } else {
          emit(UserLoaded(user));
        }
      }
    } catch (e) {
      emit(UserError('Failed to load user: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    try {
      await userRepository.init();
      await userRepository.updateUser(event.user);
      emit(UserLoaded(event.user));
    } catch (e) {
      emit(UserError('Failed to update user: ${e.toString()}'));
    }
  }

  Future<void> _onCreateUser(CreateUser event, Emitter<UserState> emit) async {
    try {
      await userRepository.init();
      await userRepository.saveUser(event.user);
      emit(UserLoaded(event.user));
    } catch (e) {
      emit(UserError('Failed to create user: ${e.toString()}'));
    }
  }
}
