import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/task/task_bloc.dart';
import '../../blocs/task/task_state.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/category/category_state.dart';
import '../../models/task.dart';
import '../../services/progress_service.dart';
import '../../models/category.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final ProgressService _progressService = ProgressService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, taskState) {
          if (taskState is TaskLoaded) {
            return BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, categoryState) {
                return _buildProgressContent(taskState.tasks, categoryState);
              },
            );
          } else if (taskState is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Unable to load progress data'));
          }
        },
      ),
    );
  }

  Widget _buildProgressContent(List<Task> tasks, CategoryState categoryState) {
    final categories = categoryState is CategoryLoaded
        ? categoryState.categories
        : <Category>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewCard(tasks),
          const SizedBox(height: 24),
          _buildWeeklyProgressCard(tasks),
          const SizedBox(height: 24),
          _buildCategoryProgressCard(tasks, categories),
          const SizedBox(height: 24),
          _buildStatsCard(tasks),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(List<Task> tasks) {
    final todayProgress = _progressService.getDailyCompletionPercentage(
      tasks,
      DateTime.now(),
    );
    final weekProgress = _progressService.getWeeklyCompletionPercentage(
      tasks,
      _getWeekStart(),
    );
    final monthProgress = _progressService.getMonthlyCompletionPercentage(
      tasks,
      _getMonthStart(),
    );
    final streak = _progressService.getCompletionStreak(tasks);
    final productivityScore = _progressService.getProductivityScore(tasks);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildProgressMetric(
                    'Today',
                    '${(todayProgress * 100).round()}%',
                    todayProgress,
                    Icons.today,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProgressMetric(
                    'This Week',
                    '${(weekProgress * 100).round()}%',
                    weekProgress,
                    Icons.calendar_view_week,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildProgressMetric(
                    'This Month',
                    '${(monthProgress * 100).round()}%',
                    monthProgress,
                    Icons.calendar_month,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProgressMetric(
                    'Streak',
                    '$streak days',
                    streak / 30.0, // Normalize to 0-1 scale
                    Icons.local_fire_department,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProductivityScore(productivityScore),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressMetric(
    String label,
    String value,
    double progress,
    IconData icon, {
    Color? color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildProductivityScore(double score) {
    final percentage = (score * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.trending_up,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 8),
            Text(
              'Productivity Score',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: score,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$percentage%',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyProgressCard(List<Task> tasks) {
    final weeklyData = _progressService.getWeeklyProgressData(tasks);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Progress',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: weeklyData.entries.map((entry) {
                  final dayName = DateFormat('E').format(entry.key);
                  final progress = entry.value;
                  return _buildDayBar(dayName, progress);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayBar(String day, double progress) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 32,
          height: (progress * 80).clamp(
            4,
            80,
          ), // Min height of 4 for visibility
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildCategoryProgressCard(
    List<Task> tasks,
    List<Category> categories,
  ) {
    if (categories.isEmpty) return const SizedBox.shrink();

    final categoryProgress = _progressService.getCategoryProgress(
      tasks,
      categories.map((c) => c.id).toList(),
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Progress',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...categories.map((category) {
              final progress = categoryProgress[category.id] ?? 0.0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: category.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        category.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(List<Task> tasks) {
    final overdueCount = _progressService.getOverdueTasksCount(tasks);
    final dueTodayCount = _progressService.getTasksDueTodayCount(tasks);
    final dueThisWeekCount = _progressService.getTasksDueThisWeekCount(tasks);
    final totalTasks = tasks.length;
    final completedTasks = tasks
        .where((task) => task.isCompleted ?? false)
        .length;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Tasks',
                    totalTasks.toString(),
                    Icons.assignment,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    'Completed',
                    completedTasks.toString(),
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Due Today',
                    dueTodayCount.toString(),
                    Icons.today,
                    color: dueTodayCount > 0 ? Colors.orange : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    'Overdue',
                    overdueCount.toString(),
                    Icons.warning,
                    color: overdueCount > 0 ? Colors.red : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatItem(
              'Due This Week',
              dueThisWeekCount.toString(),
              Icons.calendar_view_week,
              color: dueThisWeekCount > 0 ? Colors.blue : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color ?? Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DateTime _getWeekStart() {
    final now = DateTime.now();
    return now.subtract(Duration(days: now.weekday - 1));
  }

  DateTime _getMonthStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }
}
