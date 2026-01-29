import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tazbeet/models/task.dart';
import 'package:tazbeet/repositories/task_repository.dart';

void main() {
  late TaskRepository taskRepository;

  setUpAll(() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
  });

  setUp(() async {
    taskRepository = TaskRepository();
    await taskRepository.init();
  });

  tearDown(() async {
    final box = Hive.box<Task>('tasks');
    await box.clear();
    await box.close();
  });

  group('TaskRepository', () {
    final testTask = Task(id: 'test-task-1', title: 'Test Task', description: 'Test Description', isCompleted: false, createdAt: DateTime.now(), updatedAt: DateTime.now());

    test('init registers adapter and opens box', () async {
      expect(Hive.isAdapterRegistered(0), true);
      expect(Hive.isBoxOpen('tasks'), true);
    });

    test('addTask adds task to repository', () async {
      await taskRepository.addTask(testTask);

      final retrievedTask = await taskRepository.getTaskById(testTask.id);
      expect(retrievedTask, isNotNull);
      expect(retrievedTask!.id, testTask.id);
      expect(retrievedTask.title, testTask.title);
    });

    test('getAllTasks returns all tasks', () async {
      final task1 = testTask;
      final task2 = testTask.copyWith(id: 'test-task-2', title: 'Task 2');

      await taskRepository.addTask(task1);
      await taskRepository.addTask(task2);

      final allTasks = await taskRepository.getAllTasks();
      expect(allTasks.length, 2);
      expect(allTasks.any((t) => t.id == task1.id), true);
      expect(allTasks.any((t) => t.id == task2.id), true);
    });

    test('getTaskById returns correct task', () async {
      await taskRepository.addTask(testTask);

      final retrievedTask = await taskRepository.getTaskById(testTask.id);
      expect(retrievedTask, isNotNull);
      expect(retrievedTask!.id, testTask.id);
      expect(retrievedTask.title, testTask.title);
    });

    test('getTaskById returns null for non-existent task', () async {
      final retrievedTask = await taskRepository.getTaskById('non-existent');
      expect(retrievedTask, isNull);
    });

    test('updateTask updates existing task', () async {
      await taskRepository.addTask(testTask);

      final updatedTask = testTask.copyWith(title: 'Updated Title', isCompleted: true);
      await taskRepository.updateTask(updatedTask);

      final retrievedTask = await taskRepository.getTaskById(testTask.id);
      expect(retrievedTask!.title, 'Updated Title');
      expect(retrievedTask.isCompleted, true);
    });

    test('updateTasks updates multiple tasks', () async {
      final task1 = testTask;
      final task2 = testTask.copyWith(id: 'test-task-2');

      await taskRepository.addTask(task1);
      await taskRepository.addTask(task2);

      final updatedTasks = [task1.copyWith(isCompleted: true), task2.copyWith(isCompleted: true)];

      await taskRepository.updateTasks(updatedTasks);

      final allTasks = await taskRepository.getAllTasks();
      expect(allTasks.every((t) => t.isCompleted), true);
    });

    test('deleteTask removes task from repository', () async {
      await taskRepository.addTask(testTask);

      await taskRepository.deleteTask(testTask.id);

      final retrievedTask = await taskRepository.getTaskById(testTask.id);
      expect(retrievedTask, isNull);
    });

    test('deleteTasks removes multiple tasks', () async {
      final task1 = testTask;
      final task2 = testTask.copyWith(id: 'test-task-2');
      final task3 = testTask.copyWith(id: 'test-task-3');

      await taskRepository.addTask(task1);
      await taskRepository.addTask(task2);
      await taskRepository.addTask(task3);

      await taskRepository.deleteTasks([task1.id, task2.id]);

      final allTasks = await taskRepository.getAllTasks();
      expect(allTasks.length, 1);
      expect(allTasks.first.id, task3.id);
    });

    test('getTasksByCategory returns tasks with matching category', () async {
      final task1 = testTask.copyWith(categoryId: 'category-1');
      final task2 = testTask.copyWith(id: 'test-task-2', categoryId: 'category-1');
      final task3 = testTask.copyWith(id: 'test-task-3', categoryId: 'category-2');

      await taskRepository.addTask(task1);
      await taskRepository.addTask(task2);
      await taskRepository.addTask(task3);

      final categoryTasks = await taskRepository.getTasksByCategory('category-1');
      expect(categoryTasks.length, 2);
      expect(categoryTasks.every((t) => t.categoryId == 'category-1'), true);
    });

    test('getTasksDueToday returns tasks due today', () async {
      final today = DateTime.now();
      final tomorrow = today.add(const Duration(days: 1));

      final task1 = testTask.copyWith(dueDate: today);
      final task2 = testTask.copyWith(id: 'test-task-2', dueDate: tomorrow);

      await taskRepository.addTask(task1);
      await taskRepository.addTask(task2);

      final todayTasks = await taskRepository.getTasksDueToday();
      expect(todayTasks.length, 1);
      expect(todayTasks.first.id, task1.id);
    });

    test('getOverdueTasks returns tasks with past due dates', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final tomorrow = DateTime.now().add(const Duration(days: 1));

      final task1 = testTask.copyWith(dueDate: yesterday, isCompleted: false);
      final task2 = testTask.copyWith(id: 'test-task-2', dueDate: tomorrow);

      await taskRepository.addTask(task1);
      await taskRepository.addTask(task2);

      final overdueTasks = await taskRepository.getOverdueTasks();
      expect(overdueTasks.length, 1);
      expect(overdueTasks.first.id, task1.id);
    });

    test('clearAllTasks removes all tasks', () async {
      await taskRepository.addTask(testTask);
      await taskRepository.addTask(testTask.copyWith(id: 'test-task-2'));

      await taskRepository.clearAllTasks();

      final allTasks = await taskRepository.getAllTasks();
      expect(allTasks.isEmpty, true);
    });
  });
}
