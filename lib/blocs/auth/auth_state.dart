import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user.dart' as user_model;

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthProfileIncomplete extends AuthState {
  final User user;

  const AuthProfileIncomplete(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthenticatedAsGuest extends AuthState {
  final user_model.User user;

  const AuthenticatedAsGuest(this.user);

  @override
  List<Object?> get props => [user];
}
