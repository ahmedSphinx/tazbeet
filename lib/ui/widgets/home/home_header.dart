import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_state.dart';
import 'package:tazbeet/l10n/app_localizations.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskListBloc, TaskListState>(
      builder: (context, state) {
        if (state is! TaskListLoaded) return const SizedBox.shrink();

        final today = DateTime.now();
        final todayStart = DateTime(today.year, today.month, today.day);
        final todayEnd = todayStart.add(const Duration(days: 1));

        final todayTasks = state.tasks.where((task) {
          final d = task.dueDate;
          return d != null && !d.isBefore(todayStart) && d.isBefore(todayEnd);
        }).length;

        final completedToday = state.tasks.where((task) {
          final d = task.dueDate;
          return task.isCompleted && d != null && !d.isBefore(todayStart) && d.isBefore(todayEnd);
        }).length;

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primaryContainer, Theme.of(context).colorScheme.secondaryContainer], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.today,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$completedToday / $todayTasks ${AppLocalizations.of(context)!.completedTasks}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2), shape: BoxShape.circle),
                child: Icon(todayTasks > 0 && completedToday == todayTasks ? Icons.check_circle : Icons.today, size: 32, color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        );
      },
    );
  }
}
