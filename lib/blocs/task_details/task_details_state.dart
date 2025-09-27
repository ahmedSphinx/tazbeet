import 'package:equatable/equatable.dart';
import '../../models/task.dart';

abstract class TaskDetailsState extends Equatable {
  const TaskDetailsState();

  @override
  List<Object?> get props => [];
}

class TaskDetailsInitial extends TaskDetailsState {}

class TaskDetailsLoading extends TaskDetailsState {}

class TaskDetailsLoaded extends TaskDetailsState {
  final Task task;
  final double progress;
  final bool canComplete;

  const TaskDetailsLoaded(this.task, this.progress, this.canComplete);

  @override
  List<Object?> get props => [task, progress, canComplete];
}

class TaskDetailsError extends TaskDetailsState {
  final String message;

  const TaskDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
