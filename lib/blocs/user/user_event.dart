import 'package:equatable/equatable.dart';
import '../../models/user.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUser extends UserEvent {
  final bool forceRefresh;

  const LoadUser({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
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
