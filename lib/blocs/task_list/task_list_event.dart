import 'package:equatable/equatable.dart';
import '../../models/task.dart';
import '../../models/repeat_rule.dart';

abstract class TaskListEvent extends Equatable {
  const TaskListEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskListEvent {}

class AddTask extends TaskListEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskListEvent {
  final Task task;

  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TaskListEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ToggleTaskCompletion extends TaskListEvent {
  final String taskId;

  const ToggleTaskCompletion(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ScheduleTaskReminder extends TaskListEvent {
  final Task task;

  const ScheduleTaskReminder(this.task);

  @override
  List<Object?> get props => [task];
}

class CancelTaskReminder extends TaskListEvent {
  final String taskId;

  const CancelTaskReminder(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

// NEW: Repeat Task Events
class AddRepeatRule extends TaskListEvent {
  final String taskId;
  final RepeatRule repeatRule;

  const AddRepeatRule(this.taskId, this.repeatRule);

  @override
  List<Object?> get props => [taskId, repeatRule];
}

class UpdateRepeatRule extends TaskListEvent {
  final String taskId;
  final RepeatRule repeatRule;

  const UpdateRepeatRule(this.taskId, this.repeatRule);

  @override
  List<Object?> get props => [taskId, repeatRule];
}

class RemoveRepeatRule extends TaskListEvent {
  final String taskId;

  const RemoveRepeatRule(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class GenerateRecurringInstances extends TaskListEvent {
  final String taskId;

  const GenerateRecurringInstances(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ProcessCompletedRecurringTask extends TaskListEvent {
  final Task task;

  const ProcessCompletedRecurringTask(this.task);

  @override
  List<Object?> get props => [task];
}
