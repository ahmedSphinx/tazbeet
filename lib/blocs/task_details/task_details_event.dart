import 'package:equatable/equatable.dart';
import '../../models/task.dart';

abstract class TaskDetailsEvent extends Equatable {
  const TaskDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadTaskDetails extends TaskDetailsEvent {
  final String taskId;

  const LoadTaskDetails(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ToggleStrictMode extends TaskDetailsEvent {
  final String taskId;
  final bool strictMode;

  const ToggleStrictMode(this.taskId, this.strictMode);

  @override
  List<Object?> get props => [taskId, strictMode];
}

class AddSubtask extends TaskDetailsEvent {
  final String parentTaskId;
  final Task subtask;

  const AddSubtask(this.parentTaskId, this.subtask);

  @override
  List<Object?> get props => [parentTaskId, subtask];
}

class UpdateSubtask extends TaskDetailsEvent {
  final Task updatedSubtask;

  const UpdateSubtask(this.updatedSubtask);

  @override
  List<Object?> get props => [updatedSubtask];
}

class DeleteSubtask extends TaskDetailsEvent {
  final String subtaskId;

  const DeleteSubtask(this.subtaskId);

  @override
  List<Object?> get props => [subtaskId];
}

class ReorderSubtasks extends TaskDetailsEvent {
  final String parentTaskId;
  final List<Task> reorderedSubtasks;

  const ReorderSubtasks(this.parentTaskId, this.reorderedSubtasks);

  @override
  List<Object?> get props => [parentTaskId, reorderedSubtasks];
}

class UpdateTaskDetails extends TaskDetailsEvent {
  final Task task;

  const UpdateTaskDetails(this.task);

  @override
  List<Object?> get props => [task];
}

class CompleteTask extends TaskDetailsEvent {
  final String taskId;

  const CompleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class DuplicateTask extends TaskDetailsEvent {
  final String taskId;

  const DuplicateTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class UncompleteTask extends TaskDetailsEvent {
  final String taskId;

  const UncompleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}
