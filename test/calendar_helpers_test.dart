import 'package:flutter_test/flutter_test.dart';
import 'package:tazbeet/models/task.dart';

void main() {
  group('Calendar Helper Functions', () {
    test('Date in range check - task is within day range', () {
      final testDate = DateTime(2024, 3, 15);
      final start = DateTime(testDate.year, testDate.month, testDate.day);
      final end = start.add(const Duration(days: 1));

      final task = Task(id: '1', title: 'Test Task', dueDate: DateTime(2024, 3, 15, 14, 30), createdAt: DateTime.now(), updatedAt: DateTime.now());

      final isInRange = task.dueDate != null && !task.dueDate!.isBefore(start) && task.dueDate!.isBefore(end);

      expect(isInRange, true);
    });

    test('Date in range check - task is outside day range', () {
      final testDate = DateTime(2024, 3, 15);
      final start = DateTime(testDate.year, testDate.month, testDate.day);
      final end = start.add(const Duration(days: 1));

      final task = Task(id: '2', title: 'Test Task', dueDate: DateTime(2024, 3, 16, 10, 0), createdAt: DateTime.now(), updatedAt: DateTime.now());

      final isInRange = task.dueDate != null && !task.dueDate!.isBefore(start) && task.dueDate!.isBefore(end);

      expect(isInRange, false);
    });

    test('Undated tasks filter', () {
      final tasks = [
        Task(id: '1', title: 'With Date', dueDate: DateTime(2024, 3, 15), createdAt: DateTime.now(), updatedAt: DateTime.now()),
        Task(id: '2', title: 'No Date', createdAt: DateTime.now(), updatedAt: DateTime.now()),
        Task(id: '3', title: 'Another With Date', dueDate: DateTime(2024, 3, 16), createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ];

      final undatedTasks = tasks.where((task) => task.dueDate == null).toList();

      expect(undatedTasks.length, 1);
      expect(undatedTasks[0].id, '2');
    });

    test('Overdue task detection', () {
      final now = DateTime.now();
      final pastDate = now.subtract(const Duration(days: 1));

      final overdueTask = Task(id: '1', title: 'Overdue Task', dueDate: pastDate, isCompleted: false, createdAt: DateTime.now(), updatedAt: DateTime.now());

      final isOverdue = !overdueTask.isCompleted && overdueTask.dueDate != null && overdueTask.dueDate!.isBefore(now);

      expect(isOverdue, true);
    });

    test('Completed task is not overdue', () {
      final now = DateTime.now();
      final pastDate = now.subtract(const Duration(days: 1));

      final completedTask = Task(id: '2', title: 'Completed Task', dueDate: pastDate, isCompleted: true, createdAt: DateTime.now(), updatedAt: DateTime.now());

      final isOverdue = !completedTask.isCompleted && completedTask.dueDate != null && completedTask.dueDate!.isBefore(now);

      expect(isOverdue, false);
    });

    test('Tasks with due dates filter', () {
      final tasks = [
        Task(id: '1', title: 'With Date 1', dueDate: DateTime(2024, 3, 15), createdAt: DateTime.now(), updatedAt: DateTime.now()),
        Task(id: '2', title: 'No Date', createdAt: DateTime.now(), updatedAt: DateTime.now()),
        Task(id: '3', title: 'With Date 2', dueDate: DateTime(2024, 3, 16), createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ];

      final datedTasks = tasks.where((task) => task.dueDate != null).toList();

      expect(datedTasks.length, 2);
      expect(datedTasks.every((task) => task.dueDate != null), true);
    });

    test('Task count for specific date', () {
      final targetDate = DateTime(2024, 3, 15);
      final start = DateTime(targetDate.year, targetDate.month, targetDate.day);
      final end = start.add(const Duration(days: 1));

      final tasks = [
        Task(id: '1', title: 'Task 1', dueDate: DateTime(2024, 3, 15, 10, 0), createdAt: DateTime.now(), updatedAt: DateTime.now()),
        Task(id: '2', title: 'Task 2', dueDate: DateTime(2024, 3, 15, 15, 30), createdAt: DateTime.now(), updatedAt: DateTime.now()),
        Task(id: '3', title: 'Task 3', dueDate: DateTime(2024, 3, 16, 10, 0), createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ];

      final dayTasks = tasks.where((task) {
        final d = task.dueDate;
        if (d == null) return false;
        return !d.isBefore(start) && d.isBefore(end);
      }).toList();

      expect(dayTasks.length, 2);
    });
  });
}

