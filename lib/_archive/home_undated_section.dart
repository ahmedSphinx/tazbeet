import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_event.dart';
import 'package:tazbeet/blocs/task_list/task_list_state.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/models/task.dart';
import 'package:tazbeet/ui/widgets/task_list_section.dart';

/// Collapsible section displaying tasks without due dates

class HomeUndatedSection extends StatefulWidget {
  final Function(Task)? onTaskEdit;

  const HomeUndatedSection({super.key, this.onTaskEdit});

  @override
  State<HomeUndatedSection> createState() => _HomeUndatedSectionState();
}

class _HomeUndatedSectionState extends State<HomeUndatedSection> with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void _handleExpansionChanged(bool expanded) {
    setState(() => _expanded = expanded);
    if (expanded) {
      _iconController.forward();
    } else {
      _iconController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TaskListBloc, TaskListState, List<Task>>(
      selector: (state) {
        if (state is! TaskListLoaded) return [];
        return state.tasks.where((t) => t.dueDate == null).toList();
      },
      builder: (context, undatedTasks) {
        if (undatedTasks.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: _buildExpansionTile(context, undatedTasks),
          ),
        );
      },
    );
  }

  Widget _buildExpansionTile(BuildContext context, List<Task> undatedTasks) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: EdgeInsets.zero,
        leading: _buildLeadingIcon(theme),
        title: Text(l10n.undatedTasks, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: _buildSubtitle(context, undatedTasks.length, l10n),
        trailing: RotationTransition(
          turns: Tween(begin: 0.0, end: 0.5).animate(_iconController),
          child: Icon(Icons.expand_more, color: theme.colorScheme.onSurface),
        ),
        initiallyExpanded: _expanded,
        onExpansionChanged: _handleExpansionChanged,
        children: [_buildTaskList(context, undatedTasks)],
      ),
    );
  }

  Widget _buildLeadingIcon(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: theme.colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(12)),
      child: Icon(Icons.event_busy, color: theme.colorScheme.secondary, size: 24),
    );
  }

  Widget _buildSubtitle(BuildContext context, int count, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: theme.colorScheme.tertiaryContainer, borderRadius: BorderRadius.circular(8)),
            child: Text(
              '$count',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.colorScheme.onTertiaryContainer),
            ),
          ),
          const SizedBox(width: 8),
          Text(l10n.tasksCount(count), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, List<Task> undatedTasks) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
      ),
      child: TaskListSection(
        tasks: undatedTasks,
        selectedCategoryId: null,
        sortByPriority: false,
        searchQuery: '',
        filterPriority: null,
        filterCompleted: null,
        onTaskToggle: (taskId) => context.read<TaskListBloc>().add(ToggleTaskCompletion(taskId)),
        onTaskEdit: widget.onTaskEdit ?? (task) {},
        onTaskDelete: (taskId) => context.read<TaskListBloc>().add(DeleteTask(taskId)),
      ),
    );
  }
}
