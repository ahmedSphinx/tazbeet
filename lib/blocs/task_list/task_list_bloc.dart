import 'package:tazbeet/services/app_logging_service.dart';
import 'package:tazbeet/services/error_notification_service.dart';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/task.dart';
import '../../repositories/task_repository.dart';
import '../../repositories/category_repository.dart';
import '../../services/notification_service.dart';
import '../../services/data_sync_service.dart';
import '../../services/task_sound_service.dart';
import '../../services/repeat_service.dart';
import '../../services/sync_queue.dart';
import 'task_list_event.dart';
import 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final TaskRepository taskRepository;
  final CategoryRepository categoryRepository;
  final NotificationService notificationService;
  final DataSyncService _dataSyncService = DataSyncService();
  final TaskSoundService _taskSoundService = TaskSoundService();
  final RepeatService _repeatService = RepeatService();

  TaskListBloc({required this.taskRepository, required this.categoryRepository, required this.notificationService}) : super(TaskListInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<ReorderTasks>(_onReorderTasks);
    on<ScheduleTaskReminder>(_onScheduleTaskReminder);
    on<CancelTaskReminder>(_onCancelTaskReminder);

    // Repeat Task Event Handlers
    on<AddRepeatRule>(_onAddRepeatRule);
    on<UpdateRepeatRule>(_onUpdateRepeatRule);
    on<RemoveRepeatRule>(_onRemoveRepeatRule);
    on<GenerateRecurringInstances>(_onGenerateRecurringInstances);
    on<ProcessCompletedRecurringTask>(_onProcessCompletedRecurringTask);
    on<BulkDeleteTasks>(_onBulkDeleteTasks);
    on<BulkToggleTaskCompletion>(_onBulkToggleTaskCompletion);
    on<BulkUpdateTasksCategory>(_onBulkUpdateTasksCategory);
    on<BulkUpdateTasksPriority>(_onBulkUpdateTasksPriority);
    on<BulkUpdateTasksDueDate>(_onBulkUpdateTasksDueDate);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskListState> emit) async {
    emit(TaskListLoading());
    try {
      final tasks = await taskRepository.getAllTasks();
      emit(TaskListLoaded(tasks));

      // Update category task counts when loading tasks
      await categoryRepository.updateCategoryTaskCounts(tasks);

      // Reschedule all reminders on app start to ensure notifications persist
      await notificationService.rescheduleAllReminders(tasks);
      await notificationService.getPendingNotifications();
    } catch (e) {
      emit(TaskListError('Failed to load tasks'));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      // Auto-create default reminder if task has dueDate but no reminder
      Task taskToAdd = event.task;
      if (taskToAdd.dueDate != null && taskToAdd.reminderDate == null) {
        taskToAdd = taskToAdd.copyWith(reminderDate: taskToAdd.defaultReminderDate, reminderState: ReminderState.scheduled);
      }

      // Persist FIRST to prevent data loss on crash
      await taskRepository.addTask(taskToAdd);

      final List<Task> updatedTasks = List.from((state as TaskListLoaded).tasks)..add(taskToAdd);
      emit(TaskListLoaded(updatedTasks));

      // Update category task counts
      await categoryRepository.updateCategoryTaskCounts(updatedTasks);

      // Queue for sync instead of immediate sync
      syncQueue.enqueueTaskCreate(taskToAdd);

      // Schedule reminder if needed
      if (taskToAdd.reminderDate != null) {
        await notificationService.scheduleTaskReminder(taskToAdd);
      }
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      // Auto-create default reminder if task has dueDate but no reminder
      Task taskToUpdate = event.task;
      if (taskToUpdate.dueDate != null && taskToUpdate.reminderDate == null) {
        taskToUpdate = taskToUpdate.copyWith(reminderDate: taskToUpdate.defaultReminderDate, reminderState: ReminderState.scheduled);
      }

      // Persist FIRST to prevent data loss on crash
      await taskRepository.updateTask(taskToUpdate);

      final List<Task> updatedTasks = (state as TaskListLoaded).tasks.map((task) {
        return task.id == taskToUpdate.id ? taskToUpdate : task;
      }).toList();
      emit(TaskListLoaded(updatedTasks));

      // Update category task counts
      await categoryRepository.updateCategoryTaskCounts(updatedTasks);

      // Queue for sync instead of immediate sync
      syncQueue.enqueueTaskUpdate(taskToUpdate);

      // Schedule reminder if needed
      if (taskToUpdate.reminderDate != null) {
        await notificationService.scheduleTaskReminder(taskToUpdate);
      }
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      // Persist FIRST to prevent data loss on crash
      await taskRepository.deleteTask(event.taskId);

      final List<Task> updatedTasks = (state as TaskListLoaded).tasks.where((task) => task.id != event.taskId).toList();
      emit(TaskListLoaded(updatedTasks));

      // Update category task counts
      await categoryRepository.updateCategoryTaskCounts(updatedTasks);

      // Queue for sync instead of immediate sync
      syncQueue.enqueueTaskDelete(event.taskId);
    }
  }

  Future<void> _onToggleTaskCompletion(ToggleTaskCompletion event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      final List<Task> updatedTasks = (state as TaskListLoaded).tasks.map((task) {
        if (task.id == event.taskId) {
          return task.copyWith(isCompleted: !task.isCompleted);
        }
        return task;
      }).toList();
      final toggledTask = updatedTasks.firstWhere((task) => task.id == event.taskId);

      // Persist FIRST to prevent data loss on crash
      await taskRepository.updateTask(toggledTask);
      emit(TaskListLoaded(updatedTasks));

      // Handle recurring task completion
      if (toggledTask.isCompleted && toggledTask.isRecurringInstance) {
        await _repeatService.processCompletedRecurringTask(toggledTask);
        // Reload tasks to reflect any new recurring instances
        final tasks = await taskRepository.getAllTasks();
        emit(TaskListLoaded(tasks));
      }

      // Play completion sound if task was just completed (not uncompleted)
      if (toggledTask.isCompleted) {
        await _taskSoundService.playTaskCompletionSound();
      }

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          // Log error but don't fail the operation
          AppLogging.logError('Failed to sync task completion toggle to Firestore: $e');
          ErrorNotificationService().showSyncError('task completion', null);
        }
      }
    }
  }

  Future<void> _onReorderTasks(ReorderTasks event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      final currentTasks = (state as TaskListLoaded).tasks;
      // Create a map for quick lookup of updated tasks
      final updatedTaskMap = {for (var t in event.tasks) t.id: t};

      // Update the full task list with the new versions
      final List<Task> updatedTasks = currentTasks.map((task) {
        return updatedTaskMap[task.id] ?? task;
      }).toList();

      emit(TaskListLoaded(updatedTasks));

      // Persist changes
      for (var task in event.tasks) {
        await taskRepository.updateTask(task);
      }

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          AppLogging.logInfo('Failed to sync reordered tasks to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onScheduleTaskReminder(ScheduleTaskReminder event, Emitter<TaskListState> emit) async {
    await notificationService.scheduleTaskReminder(event.task);
  }

  Future<void> _onCancelTaskReminder(CancelTaskReminder event, Emitter<TaskListState> emit) async {
    await notificationService.cancelTaskReminder(event.taskId);
  }

  // Repeat Task Event Handlers
  Future<void> _onAddRepeatRule(AddRepeatRule event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      final List<Task> updatedTasks = (state as TaskListLoaded).tasks.map((task) {
        if (task.id == event.taskId) {
          return task.copyWith(repeatRule: event.repeatRule, updatedAt: DateTime.now());
        }
        return task;
      }).toList();

      emit(TaskListLoaded(updatedTasks));
      final updatedTask = updatedTasks.firstWhere((task) => task.id == event.taskId);
      await taskRepository.updateTask(updatedTask);

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          AppLogging.logInfo('Failed to sync repeat rule addition to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onUpdateRepeatRule(UpdateRepeatRule event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      final List<Task> updatedTasks = (state as TaskListLoaded).tasks.map((task) {
        if (task.id == event.taskId) {
          return task.copyWith(repeatRule: event.repeatRule, updatedAt: DateTime.now());
        }
        return task;
      }).toList();

      emit(TaskListLoaded(updatedTasks));
      final updatedTask = updatedTasks.firstWhere((task) => task.id == event.taskId);
      await taskRepository.updateTask(updatedTask);

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          AppLogging.logInfo('Failed to sync repeat rule update to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onRemoveRepeatRule(RemoveRepeatRule event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      final List<Task> updatedTasks = (state as TaskListLoaded).tasks.map((task) {
        if (task.id == event.taskId) {
          return task.copyWith(repeatRule: null, updatedAt: DateTime.now());
        }
        return task;
      }).toList();

      emit(TaskListLoaded(updatedTasks));
      final updatedTask = updatedTasks.firstWhere((task) => task.id == event.taskId);
      await taskRepository.updateTask(updatedTask);

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          AppLogging.logInfo('Failed to sync repeat rule removal to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onGenerateRecurringInstances(GenerateRecurringInstances event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      final originalTask = (state as TaskListLoaded).tasks.firstWhere((task) => task.id == event.taskId);

      if (originalTask.repeatRule != null) {
        final nextInstance = await _repeatService.generateNextRecurringTask(originalTask);
        if (nextInstance != null) {
          // Update original task with lastGeneratedAt timestamp
          final updatedOriginalTask = originalTask.copyWith(lastGeneratedAt: DateTime.now(), updatedAt: DateTime.now());
          await taskRepository.updateTask(updatedOriginalTask);

          // Add new instance and update original in the list
          final List<Task> updatedTasks = (state as TaskListLoaded).tasks.map((task) {
            return task.id == originalTask.id ? updatedOriginalTask : task;
          }).toList()..add(nextInstance);

          emit(TaskListLoaded(updatedTasks));
          await taskRepository.addTask(nextInstance);

          // Queue both updates for sync
          syncQueue.enqueueTaskUpdate(updatedOriginalTask);
          syncQueue.enqueueTaskCreate(nextInstance);
        }
      }
    }
  }

  Future<void> _onProcessCompletedRecurringTask(ProcessCompletedRecurringTask event, Emitter<TaskListState> emit) async {
    await _repeatService.processCompletedRecurringTask(event.task);

    // Reload tasks to reflect any new recurring instances
    final tasks = await taskRepository.getAllTasks();
    emit(TaskListLoaded(tasks));
  }

  Future<void> _onBulkDeleteTasks(BulkDeleteTasks event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      await taskRepository.deleteTasks(event.taskIds);

      final List<Task> updatedTasks = (state as TaskListLoaded).tasks.where((task) => !event.taskIds.contains(task.id)).toList();
      emit(TaskListLoaded(updatedTasks));
      await categoryRepository.updateCategoryTaskCounts(updatedTasks);

      for (var id in event.taskIds) {
        syncQueue.enqueueTaskDelete(id);
      }
    }
  }

  Future<void> _onBulkToggleTaskCompletion(BulkToggleTaskCompletion event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      bool anyCompleted = false;
      final List<Task> updatedTasks = (state as TaskListLoaded).tasks.map((task) {
        if (event.taskIds.contains(task.id)) {
          final updated = task.copyWith(isCompleted: !task.isCompleted, updatedAt: DateTime.now());
          if (updated.isCompleted) anyCompleted = true;
          return updated;
        }
        return task;
      }).toList();

      final tasksToUpdate = updatedTasks.where((t) => event.taskIds.contains(t.id)).toList();
      await taskRepository.updateTasks(tasksToUpdate);
      emit(TaskListLoaded(updatedTasks));

      if (anyCompleted) {
        await _taskSoundService.playTaskCompletionSound();
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _dataSyncService.syncToFirestore(user.uid).catchError((e) {
          AppLogging.logError('Failed to sync bulk task completion to Firestore: $e');
        });
      }
    }
  }

  Future<void> _onBulkUpdateTasksCategory(BulkUpdateTasksCategory event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      final List<Task> updatedTasks = (state as TaskListLoaded).tasks.map((task) {
        if (event.taskIds.contains(task.id)) {
          return task.copyWith(categoryId: event.categoryId, updatedAt: DateTime.now());
        }
        return task;
      }).toList();

      final tasksToUpdate = updatedTasks.where((t) => event.taskIds.contains(t.id)).toList();
      await taskRepository.updateTasks(tasksToUpdate);
      emit(TaskListLoaded(updatedTasks));
      await categoryRepository.updateCategoryTaskCounts(updatedTasks);

      for (var task in tasksToUpdate) {
        syncQueue.enqueueTaskUpdate(task);
      }
    }
  }

  Future<void> _onBulkUpdateTasksPriority(BulkUpdateTasksPriority event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      final List<Task> updatedTasks = (state as TaskListLoaded).tasks.map((task) {
        if (event.taskIds.contains(task.id)) {
          return task.copyWith(priority: event.priority, updatedAt: DateTime.now());
        }
        return task;
      }).toList();

      final tasksToUpdate = updatedTasks.where((t) => event.taskIds.contains(t.id)).toList();
      await taskRepository.updateTasks(tasksToUpdate);
      emit(TaskListLoaded(updatedTasks));

      for (var task in tasksToUpdate) {
        syncQueue.enqueueTaskUpdate(task);
      }
    }
  }

  Future<void> _onBulkUpdateTasksDueDate(BulkUpdateTasksDueDate event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded && event.dueDate != null) {
      final targetDate = event.dueDate!;
      final List<Task> updatedTasks = (state as TaskListLoaded).tasks.map((task) {
        if (event.taskIds.contains(task.id)) {
          DateTime newDueDate = targetDate;
          // Preserve time if original had it
          if (task.dueDate != null) {
            newDueDate = DateTime(targetDate.year, targetDate.month, targetDate.day, task.dueDate!.hour, task.dueDate!.minute);
          }

          // Also adjust reminder if it exists
          DateTime? newReminderDate = task.reminderDate;
          if (task.reminderDate != null) {
            newReminderDate = DateTime(targetDate.year, targetDate.month, targetDate.day, task.reminderDate!.hour, task.reminderDate!.minute);
          }

          return task.copyWith(dueDate: newDueDate, reminderDate: newReminderDate, updatedAt: DateTime.now());
        }
        return task;
      }).toList();

      final tasksToUpdate = updatedTasks.where((t) => event.taskIds.contains(t.id)).toList();
      await taskRepository.updateTasks(tasksToUpdate);
      emit(TaskListLoaded(updatedTasks));

      // Reschedule notifications for updated tasks
      for (var task in tasksToUpdate) {
        if (task.reminderDate != null) {
          notificationService.scheduleTaskReminder(task);
        }
        syncQueue.enqueueTaskUpdate(task);
      }
    }
  }
}
