/*import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_event.dart';
import 'package:tazbeet/blocs/task_list/task_list_state.dart';
import 'package:tazbeet/models/task.dart';
import 'package:tazbeet/repositories/task_repository.dart';
import 'package:tazbeet/repositories/category_repository.dart';
import 'package:tazbeet/services/notification_service.dart';

@GenerateMocks([TaskRepository, CategoryRepository, NotificationService])
import 'task_list_bloc_test.mocks.dart';

void main() {
  late TaskListBloc taskListBloc;
  late MockTaskRepository mockTaskRepository;
  late MockCategoryRepository mockCategoryRepository;
  late MockNotificationService mockNotificationService;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    mockCategoryRepository = MockCategoryRepository();
    mockNotificationService = MockNotificationService();

    taskListBloc = TaskListBloc(taskRepository: mockTaskRepository, categoryRepository: mockCategoryRepository, notificationService: mockNotificationService);
  });

  tearDown(() {
    taskListBloc.close();
  });

  group('TaskListBloc', () {
    final now = DateTime.now();
    final testTask = Task(id: 'test-task-1', title: 'Test Task', description: 'Test Description', isCompleted: false, createdAt: now, updatedAt: now);

    final testTasks = [testTask];

    test('initial state is TaskListInitial', () {
      expect(taskListBloc.state, equals(TaskListInitial()));
    });

    group('LoadTasks', () {
      blocTest<TaskListBloc, TaskListState>(
        'emits [TaskListLoading, TaskListLoaded] when tasks are loaded successfully',
        build: () {
          when(mockTaskRepository.getAllTasks()).thenAnswer((_) async => testTasks);
          return taskListBloc;
        },
        act: (bloc) => bloc.add(LoadTasks()),
        expect: () => [TaskListLoading(), TaskListLoaded(testTasks)],
        verify: (_) {
          verify(mockTaskRepository.getAllTasks()).called(1);
        },
      );

      blocTest<TaskListBloc, TaskListState>(
        'emits [TaskListLoading, TaskListError] when loading fails',
        build: () {
          when(mockTaskRepository.getAllTasks()).thenThrow(Exception('Failed to load tasks'));
          return taskListBloc;
        },
        act: (bloc) => bloc.add(LoadTasks()),
        expect: () => [TaskListLoading(), isA<TaskListError>()],
      );
    });

    group('AddTask', () {
      blocTest<TaskListBloc, TaskListState>(
        'adds task and emits TaskListLoaded with new task',
        build: () {
          when(mockTaskRepository.addTask(any)).thenAnswer((_) async => {});
          when(mockTaskRepository.getAllTasks()).thenAnswer((_) async => testTasks);
          return taskListBloc;
        },
        seed: () => TaskListLoaded([]),
        act: (bloc) => bloc.add(AddTask(testTask)),
        expect: () => [isA<TaskListLoaded>().having((state) => state.tasks.length, 'tasks length', 1)],
        verify: (_) {
          verify(mockTaskRepository.addTask(testTask)).called(1);
        },
      );
    });

    group('UpdateTask', () {
      blocTest<TaskListBloc, TaskListState>(
        'emits [TaskListLoaded] when UpdateTask is added',
        build: () {
          final updatedTask = testTask.copyWith(title: 'Updated Task');
          when(mockTaskRepository.updateTask(any)).thenAnswer((_) async => {});
          when(mockTaskRepository.getAllTasks()).thenAnswer((_) async => [updatedTask]);
          return taskListBloc;
        },
        act: (bloc) {
          final updatedTask = testTask.copyWith(title: 'Updated Task');
          return bloc.add(UpdateTask(updatedTask));
        },
        expect: () => [
          TaskListLoaded([testTask.copyWith(title: 'Updated Task')]),
        ],
      );
    });

    group('DeleteTask', () {
      blocTest<TaskListBloc, TaskListState>(
        'deletes task and emits TaskListLoaded without deleted task',
        build: () {
          when(mockTaskRepository.deleteTask(any)).thenAnswer((_) async => {});
          return taskListBloc;
        },
        seed: () => TaskListLoaded(testTasks),
        act: (bloc) => bloc.add(DeleteTask(testTask.id)),
        expect: () => [isA<TaskListLoaded>().having((state) => state.tasks.length, 'tasks length', 0)],
        verify: (_) {
          verify(mockTaskRepository.deleteTask(testTask.id)).called(1);
        },
      );
    });

    group('ToggleTaskCompletion', () {
      blocTest<TaskListBloc, TaskListState>(
        'toggles task completion status',
        build: () {
          when(mockTaskRepository.updateTask(any)).thenAnswer((_) async => {});
          return taskListBloc;
        },
        seed: () => TaskListLoaded(testTasks),
        act: (bloc) => bloc.add(ToggleTaskCompletion(testTask.id)),
        expect: () => [isA<TaskListLoaded>().having((state) => state.tasks.first.isCompleted, 'is completed', true)],
      );
    });

    group('BulkDeleteTasks', () {
      blocTest<TaskListBloc, TaskListState>(
        'deletes multiple tasks',
        build: () {
          when(mockTaskRepository.deleteTasks(any)).thenAnswer((_) async => {});
          return taskListBloc;
        },
        seed: () => TaskListLoaded(testTasks),
        act: (bloc) => bloc.add(BulkDeleteTasks([testTask.id])),
        expect: () => [isA<TaskListLoaded>().having((state) => state.tasks.length, 'tasks length', 0)],
        verify: (_) {
          verify(mockTaskRepository.deleteTasks([testTask.id])).called(1);
        },
      );
    });
  });
}
 */