import 'package:equatable/equatable.dart';
import '../../models/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;

  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TaskEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ToggleTaskCompletion extends TaskEvent {
  final String taskId;

  const ToggleTaskCompletion(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ScheduleTaskReminder extends TaskEvent {
  final Task task;

  const ScheduleTaskReminder(this.task);

  @override
  List<Object?> get props => [task];
}

class CancelTaskReminder extends TaskEvent {
  final String taskId;

  const CancelTaskReminder(this.taskId);

  @override
  List<Object?> get props => [taskId];
}
