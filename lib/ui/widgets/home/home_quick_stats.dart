import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_state.dart';
import 'package:tazbeet/l10n/app_localizations.dart';

class HomeQuickStats extends StatelessWidget {
  const HomeQuickStats({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        children: const [
          Expanded(child: _OverdueCard()),
          SizedBox(width: 12),
          Expanded(child: _HighPriorityCard()),
          SizedBox(width: 12),
          Expanded(child: _UndatedCard()),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  const _StatCard({required this.icon, required this.value, required this.label, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.8), fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverdueCard extends StatelessWidget {
  const _OverdueCard();
  @override
  Widget build(BuildContext context) {
    return BlocSelector<TaskListBloc, TaskListState, int>(
      selector: (state) {
        if (state is! TaskListLoaded) return 0;
        final now = DateTime.now();
        return state.tasks.where((t) => !t.isCompleted && t.dueDate != null && t.dueDate!.isBefore(now)).length;
      },
      builder: (context, count) => _StatCard(icon: Icons.warning_amber_rounded, value: '$count', label: AppLocalizations.of(context)!.overdue, color: Colors.red),
    );
  }
}

class _HighPriorityCard extends StatelessWidget {
  const _HighPriorityCard();
  @override
  Widget build(BuildContext context) {
    return BlocSelector<TaskListBloc, TaskListState, int>(
      selector: (state) {
        if (state is! TaskListLoaded) return 0;
        return state.tasks.where((t) => !t.isCompleted && t.priority.index == 2).length; // TaskPriority.high
      },
      builder: (context, count) => _StatCard(icon: Icons.priority_high, value: '$count', label: AppLocalizations.of(context)!.highPriorityLabel, color: Colors.orange),
    );
  }
}

class _UndatedCard extends StatelessWidget {
  const _UndatedCard();
  @override
  Widget build(BuildContext context) {
    return BlocSelector<TaskListBloc, TaskListState, int>(
      selector: (state) {
        if (state is! TaskListLoaded) return 0;
        return state.tasks.where((t) => t.dueDate == null).length;
      },
      builder: (context, count) => _StatCard(icon: Icons.event_busy, value: '$count', label: AppLocalizations.of(context)!.noDueDate, color: Colors.blue),
    );
  }
}
