import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/task.dart';
import '../../repositories/task_repository.dart';
import '../../repositories/category_repository.dart';
import '../../services/notification_service.dart';
import '../../services/data_sync_service.dart';
import '../../services/task_sound_service.dart';
import '../../services/repeat_service.dart';
import 'task_list_event.dart';
import 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final TaskRepository taskRepository;
  final CategoryRepository categoryRepository;
  final NotificationService notificationService;
  final DataSyncService _dataSyncService = DataSyncService();
  final TaskSoundService _taskSoundService = TaskSoundService();
  final RepeatService _repeatService = RepeatService();

  TaskListBloc({required this.taskRepository, required this.categoryRepository, required this.notificationService})
    : super(TaskListInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<ScheduleTaskReminder>(_onScheduleTaskReminder);
    on<CancelTaskReminder>(_onCancelTaskReminder);

    // Repeat Task Event Handlers
    on<AddRepeatRule>(_onAddRepeatRule);
    on<UpdateRepeatRule>(_onUpdateRepeatRule);
    on<RemoveRepeatRule>(_onRemoveRepeatRule);
    on<GenerateRecurringInstances>(_onGenerateRecurringInstances);
    on<ProcessCompletedRecurringTask>(_onProcessCompletedRecurringTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskListState> emit) async {
    emit(TaskListLoading());
    try {
      final tasks = await taskRepository.getAllTasks();
      emit(TaskListLoaded(tasks));

      // Update category task counts when loading tasks
      await categoryRepository.updateCategoryTaskCounts(tasks);
    } catch (e) {
      emit(TaskListError('Failed to load tasks'));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      final List<Task> updatedTasks = List.from((state as TaskListLoaded).tasks)
        ..add(event.task);
      emit(TaskListLoaded(updatedTasks));
      await taskRepository.addTask(event.task);

      // Update category task counts
      await categoryRepository.updateCategoryTaskCounts(updatedTasks);

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          // Log error but don't fail the operation
          print('Failed to sync task addition to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      final List<Task> updatedTasks = (state as TaskListLoaded).tasks.map((task) {
        return task.id == event.task.id ? event.task : task;
      }).toList();
      emit(TaskListLoaded(updatedTasks));
      await taskRepository.updateTask(event.task);

      // Update category task counts
      await categoryRepository.updateCategoryTaskCounts(updatedTasks);

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          // Log error but don't fail the operation
          print('Failed to sync task update to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      final List<Task> updatedTasks = (state as TaskListLoaded).tasks
          .where((task) => task.id != event.taskId)
          .toList();
      emit(TaskListLoaded(updatedTasks));
      await taskRepository.deleteTask(event.taskId);

      // Update category task counts
      await categoryRepository.updateCategoryTaskCounts(updatedTasks);

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          // Log error but don't fail the operation
          print('Failed to sync task deletion to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletion event,
    Emitter<TaskListState> emit,
  ) async {
    if (state is TaskListLoaded) {
      final List<Task> updatedTasks = (state as TaskListLoaded).tasks.map((task) {
        if (task.id == event.taskId) {
          return task.copyWith(isCompleted: !task.isCompleted);
        }
        return task;
      }).toList();
      emit(TaskListLoaded(updatedTasks));
      final toggledTask = updatedTasks.firstWhere(
        (task) => task.id == event.taskId,
      );
      await taskRepository.updateTask(toggledTask);

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
          print('Failed to sync task completion toggle to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onScheduleTaskReminder(
    ScheduleTaskReminder event,
    Emitter<TaskListState> emit,
  ) async {
    await notificationService.scheduleTaskReminder(event.task);
  }

  Future<void> _onCancelTaskReminder(
    CancelTaskReminder event,
    Emitter<TaskListState> emit,
  ) async {
    await notificationService.cancelTaskReminder(event.taskId);
  }

  // Repeat Task Event Handlers
  Future<void> _onAddRepeatRule(AddRepeatRule event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      final List<Task> updatedTasks = (state as TaskListLoaded).tasks.map((task) {
        if (task.id == event.taskId) {
          return task.copyWith(
            repeatRule: event.repeatRule,
            updatedAt: DateTime.now(),
          );
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
          print('Failed to sync repeat rule addition to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onUpdateRepeatRule(UpdateRepeatRule event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      final List<Task> updatedTasks = (state as TaskListLoaded).tasks.map((task) {
        if (task.id == event.taskId) {
          return task.copyWith(
            repeatRule: event.repeatRule,
            updatedAt: DateTime.now(),
          );
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
          print('Failed to sync repeat rule update to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onRemoveRepeatRule(RemoveRepeatRule event, Emitter<TaskListState> emit) async {
    if (state is TaskListLoaded) {
      final List<Task> updatedTasks = (state as TaskListLoaded).tasks.map((task) {
        if (task.id == event.taskId) {
          return task.copyWith(
            repeatRule: null,
            updatedAt: DateTime.now(),
          );
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
          print('Failed to sync repeat rule removal to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onGenerateRecurringInstances(
    GenerateRecurringInstances event,
    Emitter<TaskListState> emit,
  ) async {
    if (state is TaskListLoaded) {
      final originalTask = (state as TaskListLoaded).tasks.firstWhere(
        (task) => task.id == event.taskId,
      );

      if (originalTask.repeatRule != null) {
        final nextInstance = await _repeatService.generateNextRecurringTask(originalTask);
        if (nextInstance != null) {
          final List<Task> updatedTasks = List.from((state as TaskListLoaded).tasks)
            ..add(nextInstance);
          emit(TaskListLoaded(updatedTasks));
          await taskRepository.addTask(nextInstance);

          // Sync to Firestore if user is signed in
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            try {
              await _dataSyncService.syncToFirestore(user.uid);
            } catch (e) {
              print('Failed to sync recurring instance to Firestore: $e');
            }
          }
        }
      }
    }
  }

  Future<void> _onProcessCompletedRecurringTask(
    ProcessCompletedRecurringTask event,
    Emitter<TaskListState> emit,
  ) async {
    await _repeatService.processCompletedRecurringTask(event.task);

    // Reload tasks to reflect any new recurring instances
    final tasks = await taskRepository.getAllTasks();
    emit(TaskListLoaded(tasks));
  }
}
