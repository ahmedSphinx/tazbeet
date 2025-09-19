import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/task.dart';
import '../../repositories/task_repository.dart';
import '../../services/notification_service.dart';
import '../../services/data_sync_service.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;
  final NotificationService notificationService;
  final DataSyncService _dataSyncService = DataSyncService();

  TaskBloc({required this.taskRepository, required this.notificationService}) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<ScheduleTaskReminder>(_onScheduleTaskReminder);
    on<CancelTaskReminder>(_onCancelTaskReminder);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await taskRepository.getAllTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks'));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final List<Task> updatedTasks = List.from((state as TaskLoaded).tasks)
        ..add(event.task);
      emit(TaskLoaded(updatedTasks));
      await taskRepository.addTask(event.task);

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

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final List<Task> updatedTasks = (state as TaskLoaded).tasks.map((task) {
        return task.id == event.task.id ? event.task : task;
      }).toList();
      emit(TaskLoaded(updatedTasks));
      await taskRepository.updateTask(event.task);

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

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final List<Task> updatedTasks = (state as TaskLoaded)
          .tasks
          .where((task) => task.id != event.taskId)
          .toList();
      emit(TaskLoaded(updatedTasks));
      await taskRepository.deleteTask(event.taskId);

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
      ToggleTaskCompletion event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final List<Task> updatedTasks = (state as TaskLoaded).tasks.map((task) {
        if (task.id == event.taskId) {
          return task.copyWith(isCompleted: !task.isCompleted);
        }
        return task;
      }).toList();
      emit(TaskLoaded(updatedTasks));
      final toggledTask =
          updatedTasks.firstWhere((task) => task.id == event.taskId);
      await taskRepository.updateTask(toggledTask);

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
      ScheduleTaskReminder event, Emitter<TaskState> emit) async {
    await notificationService.scheduleTaskReminder(event.task);
  }

  Future<void> _onCancelTaskReminder(
      CancelTaskReminder event, Emitter<TaskState> emit) async {
    await notificationService.cancelTaskReminder(event.taskId);
  }
}
