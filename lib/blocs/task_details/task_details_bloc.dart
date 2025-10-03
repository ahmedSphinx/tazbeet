import 'package:tazbeet/services/app_logging.dart';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/task.dart';
import '../../repositories/task_repository.dart';
import '../../services/data_sync_service.dart';
import 'task_details_event.dart';
import 'task_details_state.dart';

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  final TaskRepository taskRepository;
  final DataSyncService _dataSyncService = DataSyncService();

  TaskDetailsBloc({required this.taskRepository}) : super(TaskDetailsInitial()) {
    on<LoadTaskDetails>(_onLoadTaskDetails);
    on<ToggleStrictMode>(_onToggleStrictMode);
    on<AddSubtask>(_onAddSubtask);
    on<UpdateSubtask>(_onUpdateSubtask);
    on<DeleteSubtask>(_onDeleteSubtask);
    on<ReorderSubtasks>(_onReorderSubtasks);
    on<UpdateTaskDetails>(_onUpdateTaskDetails);
    on<CompleteTask>(_onCompleteTask);
    on<DuplicateTask>(_onDuplicateTask);
    on<UncompleteTask>(_onUncompleteTask);
  }

  Future<void> _onLoadTaskDetails(LoadTaskDetails event, Emitter<TaskDetailsState> emit) async {
    emit(TaskDetailsLoading());
    try {
      final task = await taskRepository.getTaskById(event.taskId);
      if (task != null) {
        final progress = _calculateProgress(task);
        final canComplete = _canComplete(task);
        emit(TaskDetailsLoaded(task, progress, canComplete));
      } else {
        emit(const TaskDetailsError('Task not found'));
      }
    } catch (e) {
      emit(TaskDetailsError('Failed to load task details: $e'));
    }
  }

  Future<void> _onToggleStrictMode(ToggleStrictMode event, Emitter<TaskDetailsState> emit) async {
    if (state is TaskDetailsLoaded) {
      final currentTask = (state as TaskDetailsLoaded).task;
      final updatedTask = currentTask.copyWith(strictCompletionMode: event.strictMode, updatedAt: DateTime.now());

      final progress = _calculateProgress(updatedTask);
      final canComplete = _canComplete(updatedTask);
      emit(TaskDetailsLoaded(updatedTask, progress, canComplete));
      await taskRepository.updateTask(updatedTask);

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          AppLogging.logInfo('Failed to sync strict mode toggle to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onAddSubtask(AddSubtask event, Emitter<TaskDetailsState> emit) async {
    if (state is TaskDetailsLoaded) {
      final currentTask = (state as TaskDetailsLoaded).task;

      // Helper function to add subtask to the correct parent in the tree
      Task addSubtaskToTree(Task task, String parentId, Task subtask) {
        if (task.id == parentId) {
          return task.copyWith(subtasks: [...task.subtasks, subtask]);
        }
        final updatedSubtasks = task.subtasks.map((s) => addSubtaskToTree(s, parentId, subtask)).toList();
        return task.copyWith(subtasks: updatedSubtasks);
      }

      final updatedTask = addSubtaskToTree(currentTask, event.parentTaskId, event.subtask).copyWith(updatedAt: DateTime.now());

      final progress = _calculateProgress(updatedTask);
      final canComplete = _canComplete(updatedTask);
      emit(TaskDetailsLoaded(updatedTask, progress, canComplete));
      await taskRepository.updateTask(updatedTask);

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          AppLogging.logInfo('Failed to sync subtask addition to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onUpdateSubtask(UpdateSubtask event, Emitter<TaskDetailsState> emit) async {
    if (state is TaskDetailsLoaded) {
      final currentTask = (state as TaskDetailsLoaded).task;

      // Helper function to recursively update subtasks
      Task updateSubtaskInTree(Task task, String subtaskId, Task updatedSubtask) {
        if (task.id == subtaskId) {
          return updatedSubtask;
        }

        final updatedSubtasks = task.subtasks.map((subtask) {
          return updateSubtaskInTree(subtask, subtaskId, updatedSubtask);
        }).toList();

        return task.copyWith(subtasks: updatedSubtasks);
      }

      final updatedTask = updateSubtaskInTree(currentTask, event.updatedSubtask.id, event.updatedSubtask.copyWith(updatedAt: DateTime.now()));

      final progress = _calculateProgress(updatedTask);
      final canComplete = _canComplete(updatedTask);
      emit(TaskDetailsLoaded(updatedTask, progress, canComplete));
      await taskRepository.updateTask(updatedTask);

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          AppLogging.logInfo('Failed to sync subtask update to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onDeleteSubtask(DeleteSubtask event, Emitter<TaskDetailsState> emit) async {
    if (state is TaskDetailsLoaded) {
      final currentTask = (state as TaskDetailsLoaded).task;

      // Helper function to recursively delete subtasks
      Task deleteSubtaskFromTree(Task task, String subtaskId) {
        final updatedSubtasks = task.subtasks.where((subtask) => subtask.id != subtaskId).map((subtask) {
          return deleteSubtaskFromTree(subtask, subtaskId);
        }).toList();

        return task.copyWith(subtasks: updatedSubtasks);
      }

      final updatedTask = deleteSubtaskFromTree(currentTask, event.subtaskId).copyWith(updatedAt: DateTime.now());

      final progress = _calculateProgress(updatedTask);
      final canComplete = _canComplete(updatedTask);
      emit(TaskDetailsLoaded(updatedTask, progress, canComplete));
      await taskRepository.updateTask(updatedTask);

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          AppLogging.logInfo('Failed to sync subtask deletion to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onReorderSubtasks(ReorderSubtasks event, Emitter<TaskDetailsState> emit) async {
    if (state is TaskDetailsLoaded) {
      final currentTask = (state as TaskDetailsLoaded).task;
      final updatedTask = currentTask.copyWith(subtasks: event.reorderedSubtasks, updatedAt: DateTime.now());

      final progress = _calculateProgress(updatedTask);
      final canComplete = _canComplete(updatedTask);
      emit(TaskDetailsLoaded(updatedTask, progress, canComplete));
      await taskRepository.updateTask(updatedTask);

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          AppLogging.logInfo('Failed to sync subtasks reordering to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onUpdateTaskDetails(UpdateTaskDetails event, Emitter<TaskDetailsState> emit) async {
    final progress = _calculateProgress(event.task);
    final canComplete = _canComplete(event.task);
    emit(TaskDetailsLoaded(event.task, progress, canComplete));
    await taskRepository.updateTask(event.task);

    // Sync to Firestore if user is signed in
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _dataSyncService.syncToFirestore(user.uid);
      } catch (e) {
        AppLogging.logInfo('Failed to sync task details update to Firestore: $e');
      }
    }
  }

  Future<void> _onCompleteTask(CompleteTask event, Emitter<TaskDetailsState> emit) async {
    if (state is TaskDetailsLoaded) {
      final current = state as TaskDetailsLoaded;
      final updatedTask = current.task.copyWith(isCompleted: true, updatedAt: DateTime.now());
      await taskRepository.updateTask(updatedTask);
      // Handle repeats if applicable
      final progress = _calculateProgress(updatedTask);
      final canComplete = _canComplete(updatedTask);
      emit(TaskDetailsLoaded(updatedTask, progress, canComplete));

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          AppLogging.logInfo('Failed to sync task completion to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onDuplicateTask(DuplicateTask event, Emitter<TaskDetailsState> emit) async {
    if (state is TaskDetailsLoaded) {
      final current = state as TaskDetailsLoaded;
      final originalTask = current.task;

      // Create a duplicate task
      final duplicatedTask = _duplicateTask(originalTask);

      await taskRepository.addTask(duplicatedTask);

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          AppLogging.logInfo('Failed to sync task duplication to Firestore: $e');
        }
      }
    }
  }

  Future<void> _onUncompleteTask(UncompleteTask event, Emitter<TaskDetailsState> emit) async {
    if (state is TaskDetailsLoaded) {
      final current = state as TaskDetailsLoaded;
      final updatedTask = current.task.copyWith(isCompleted: false, updatedAt: DateTime.now());
      await taskRepository.updateTask(updatedTask);
      final progress = _calculateProgress(updatedTask);
      final canComplete = _canComplete(updatedTask);
      emit(TaskDetailsLoaded(updatedTask, progress, canComplete));

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          AppLogging.logInfo('Failed to sync task uncompletion to Firestore: $e');
        }
      }
    }
  }

  Task _duplicateTask(Task task) {
    final now = DateTime.now();
    final newId = now.millisecondsSinceEpoch.toString();

    // Duplicate subtasks recursively
    final duplicatedSubtasks = task.subtasks.map((subtask) => _duplicateTask(subtask)).toList();

    return Task(
      id: newId,
      title: '${task.title} (Copy)',
      description: task.description,
      isCompleted: false, // Reset completion
      priority: task.priority,
      dueDate: task.dueDate,
      categoryId: task.categoryId,
      reminderIntervals: task.reminderIntervals,
      repeatRule: task.repeatRule,
      parentId: task.parentId,
      subtasks: duplicatedSubtasks,
      maxSubtaskDepth: task.maxSubtaskDepth,
      strictCompletionMode: task.strictCompletionMode,
      createdAt: now,
      updatedAt: now,
    );
  }

  double _calculateProgress(Task task) {
    if (task.subtasks.isEmpty) return task.isCompleted ? 1.0 : 0.0;
    int total = 0;
    int completed = 0;
    void count(Task t) {
      total++;
      if (t.isCompleted) completed++;
      for (var s in t.subtasks) {
        count(s);
      }
    }

    for (var s in task.subtasks) {
      count(s);
    }
    return total == 0 ? 0.0 : completed / total;
  }

  bool _canComplete(Task task) {
    if (!task.strictCompletionMode) return true;
    // In strict mode, can complete only if all subtasks are fully completed
    bool areAllSubtasksCompleted(Task t) {
      if (!t.isCompleted) return false;
      for (final sub in t.subtasks) {
        if (!areAllSubtasksCompleted(sub)) return false;
      }
      return true;
    }

    for (final sub in task.subtasks) {
      if (!areAllSubtasksCompleted(sub)) return false;
    }
    return true;
  }
}
