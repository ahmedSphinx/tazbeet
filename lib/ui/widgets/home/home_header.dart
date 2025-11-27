import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_state.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/ui/design_system/ds_spacing.dart';
import 'package:tazbeet/ui/design_system/ds_typography.dart';
import 'package:tazbeet/ui/design_system/ds_border_radius.dart';
import 'package:tazbeet/ui/design_system/ds_elevation.dart';

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
          margin: const EdgeInsets.fromLTRB(DSSpacing.md, DSSpacing.md, DSSpacing.md, DSSpacing.sm),
          padding: const EdgeInsets.all(DSSpacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.6), Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: DSBorderRadius.lgRadius,
            boxShadow: DSElevation.getBoxShadow(context, DSElevation.level2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.today, style: DSTypography.subtitle(context).copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)),
                    const SizedBox(height: DSSpacing.xs),
                    Text('$completedToday / $todayTasks ${AppLocalizations.of(context)!.completedTasks}', style: DSTypography.body(context).copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(DSSpacing.sm),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: Icon(todayTasks > 0 && completedToday == todayTasks ? Icons.check_circle : Icons.today, size: 28, color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        );
      },
    );
  }
}
