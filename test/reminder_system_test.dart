import 'package:flutter_test/flutter_test.dart';
import 'package:tazbeet/models/task.dart';

void main() {
  group('Reminder System Tests', () {
    test('Task default reminder calculation works', () {
      // Test high priority task (1 hour before due date)
      final highPriorityTask = Task(id: 'test1', title: 'High Priority Task', priority: TaskPriority.high, dueDate: DateTime.now().add(const Duration(hours: 2)), createdAt: DateTime.now(), updatedAt: DateTime.now());

      final reminder = highPriorityTask.defaultReminderDate;
      expect(reminder, isNotNull);
      expect(reminder?.isBefore(highPriorityTask.dueDate!) ?? false, true);
      expect(highPriorityTask.dueDate?.difference(reminder ?? DateTime.now()).inHours, 1);

      // Test medium priority task (24 hours before due date)
      final mediumPriorityTask = Task(
        id: 'test2',
        title: 'Medium Priority Task',
        priority: TaskPriority.medium,
        dueDate: DateTime.now().add(const Duration(hours: 25)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final mediumReminder = mediumPriorityTask.defaultReminderDate;
      expect(mediumReminder, isNotNull);
      expect(mediumReminder?.isBefore(mediumPriorityTask.dueDate!) ?? false, true);
      expect(mediumPriorityTask.dueDate?.difference(mediumReminder ?? DateTime.now()).inHours, 24);

      // Test low priority task (48 hours before due date)
      final lowPriorityTask = Task(id: 'test3', title: 'Low Priority Task', priority: TaskPriority.low, dueDate: DateTime.now().add(const Duration(hours: 49)), createdAt: DateTime.now(), updatedAt: DateTime.now());
      final lowReminder = lowPriorityTask.defaultReminderDate;
      expect(lowReminder, isNotNull);
      expect(lowReminder?.isBefore(lowPriorityTask.dueDate!) ?? false, true);
      expect(lowPriorityTask.dueDate?.difference(lowReminder ?? DateTime.now()).inHours, 48);
    });

    test('Task without due date returns null reminder', () {
      final task = Task(id: 'test4', title: 'No Due Date Task', priority: TaskPriority.medium, createdAt: DateTime.now(), updatedAt: DateTime.now());

      expect(task.defaultReminderDate!, isNull);
    });

    test('ReminderState enum values', () {
      expect(ReminderState.values.length, 5);
      expect(ReminderState.none, isNotNull);
      expect(ReminderState.scheduled, isNotNull);
      expect(ReminderState.delivered, isNotNull);
      expect(ReminderState.failed, isNotNull);
      expect(ReminderState.cancelled, isNotNull);
    });
  });
}
