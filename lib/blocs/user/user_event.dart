import 'package:equatable/equatable.dart';
import '../../models/user.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUser extends UserEvent {
  const LoadUser();

  @override
  List<Object?> get props => [];
}

class UpdateUser extends UserEvent {
  final User user;

  const UpdateUser(this.user);

  @override
  List<Object?> get props => [user];
}

class CreateUser extends UserEvent {
  final User user;

  const CreateUser(this.user);

  @override
  List<Object?> get props => [user];
}
