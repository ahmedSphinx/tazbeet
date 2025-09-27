import '../models/task.dart';

class ProgressService {
  // Calculate daily completion percentage
  double getDailyCompletionPercentage(List<Task> tasks, DateTime date) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final dayTasks = tasks.where((task) {
      return task.createdAt.isAfter(dayStart) &&
          task.createdAt.isBefore(dayEnd);
    }).toList();

    if (dayTasks.isEmpty) return 0.0;

    final completedTasks = dayTasks.where((task) => task.isCompleted).length;
    return completedTasks / dayTasks.length;
  }

  // Calculate weekly completion percentage
  double getWeeklyCompletionPercentage(List<Task> tasks, DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 7));

    final weekTasks = tasks.where((task) {
      return task.createdAt.isAfter(weekStart) &&
          task.createdAt.isBefore(weekEnd);
    }).toList();

    if (weekTasks.isEmpty) return 0.0;

    final completedTasks = weekTasks.where((task) => task.isCompleted).length;
    return completedTasks / weekTasks.length;
  }

  // Calculate monthly completion percentage
  double getMonthlyCompletionPercentage(List<Task> tasks, DateTime monthStart) {
    final monthEnd = DateTime(
      monthStart.year,
      monthStart.month + 1,
      monthStart.day,
    );

    final monthTasks = tasks.where((task) {
      return task.createdAt.isAfter(monthStart) &&
          task.createdAt.isBefore(monthEnd);
    }).toList();

    if (monthTasks.isEmpty) return 0.0;

    final completedTasks = monthTasks.where((task) => task.isCompleted).length;
    return completedTasks / monthTasks.length;
  }

  // Get daily progress data for the last 7 days
  Map<DateTime, double> getWeeklyProgressData(List<Task> tasks) {
    final progressData = <DateTime, double>{};
    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);
      progressData[dayStart] = getDailyCompletionPercentage(tasks, date);
    }

    return progressData;
  }

  // Get completion streak (consecutive days with completed tasks)
  int getCompletionStreak(List<Task> tasks) {
    final now = DateTime.now();
    int streak = 0;
    final completedTasksByDate = _groupTasksByDate(
      tasks.where((task) => task.isCompleted).toList(),
    );

    for (int i = 0; i < 365; i++) {
      // Check up to a year back
      final date = now.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);

      if (completedTasksByDate.containsKey(dayStart) &&
          completedTasksByDate[dayStart]!.isNotEmpty) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  // Get productivity score (weighted completion rate)
  double getProductivityScore(List<Task> tasks) {
    if (tasks.isEmpty) return 0.0;

    // Filter out tasks with null values
    final validTasks = tasks.where((task) => task.createdAt != null).toList();

    if (validTasks.isEmpty) return 0.0;

    final completedTasks = validTasks.where((task) => task.isCompleted).length;
    final baseScore = completedTasks / validTasks.length;

    // Weight by priority (high priority tasks are worth more)
    final highPriorityTasks = validTasks
        .where((task) => task.priority == TaskPriority.high)
        .toList();
    final highPriorityCompleted = highPriorityTasks
        .where((task) => task.isCompleted)
        .length;

    double priorityWeight = 0.0;
    if (highPriorityTasks.isNotEmpty) {
      priorityWeight = (highPriorityCompleted / highPriorityTasks.length) * 0.2;
    }

    // Weight by timeliness (tasks completed before due date)
    final onTimeTasks = validTasks.where((task) {
      if (!task.isCompleted || task.dueDate == null) return false;
      return task.updatedAt.isBefore(task.dueDate!);
    }).length;

    double timelinessWeight = 0.0;
    final tasksWithDueDate = validTasks
        .where((task) => task.dueDate != null)
        .length;
    if (tasksWithDueDate > 0) {
      timelinessWeight = (onTimeTasks / tasksWithDueDate) * 0.1;
    }

    return (baseScore + priorityWeight + timelinessWeight).clamp(0.0, 1.0);
  }

  // Get category-wise progress
  Map<String, double> getCategoryProgress(
    List<Task> tasks,
    List<String> categoryIds,
  ) {
    final categoryProgress = <String, double>{};

    for (final categoryId in categoryIds) {
      final categoryTasks = tasks
          .where((task) => task.categoryId == categoryId)
          .toList();
      if (categoryTasks.isNotEmpty) {
        final completedTasks = categoryTasks
            .where((task) => task.isCompleted)
            .length;
        categoryProgress[categoryId] = completedTasks / categoryTasks.length;
      } else {
        categoryProgress[categoryId] = 0.0;
      }
    }

    return categoryProgress;
  }

  // Helper method to group tasks by date
  Map<DateTime, List<Task>> _groupTasksByDate(List<Task> tasks) {
    final groupedTasks = <DateTime, List<Task>>{};

    for (final task in tasks) {
      final date = DateTime(
        task.createdAt.year,
        task.createdAt.month,
        task.createdAt.day,
      );
      if (!groupedTasks.containsKey(date)) {
        groupedTasks[date] = [];
      }
      groupedTasks[date]!.add(task);
    }

    return groupedTasks;
  }

  // Get overdue tasks count
  int getOverdueTasksCount(List<Task> tasks) {
    final now = DateTime.now();
    return tasks.where((task) {
      return task.dueDate != null &&
          !task.isCompleted &&
          task.dueDate!.isBefore(now);
    }).length;
  }

  // Get tasks due today
  int getTasksDueTodayCount(List<Task> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return tasks.where((task) {
      return task.dueDate != null &&
          !task.isCompleted &&
          task.dueDate!.isAfter(today) &&
          task.dueDate!.isBefore(tomorrow);
    }).length;
  }

  // Get tasks due this week
  int getTasksDueThisWeekCount(List<Task> tasks) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));

    return tasks.where((task) {
      return task.dueDate != null &&
          !task.isCompleted &&
          task.dueDate!.isAfter(weekStart) &&
          task.dueDate!.isBefore(weekEnd);
    }).length;
  }
}
