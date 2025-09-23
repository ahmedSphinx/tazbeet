import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {}

class AuthLoggedOut extends AuthEvent {}

class AuthSignInRequested extends AuthEvent {}

class AuthFacebookSignInRequested extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}
