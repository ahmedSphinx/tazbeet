import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_event.dart';
import 'package:tazbeet/blocs/task_list/task_list_state.dart';
import 'package:tazbeet/models/task.dart';
import 'package:tazbeet/ui/widgets/task_list_section.dart';
import 'package:tazbeet/l10n/app_localizations.dart';

class HomeUndatedSection extends StatefulWidget {
  final Function(Task)? onTaskEdit;
  const HomeUndatedSection({super.key, this.onTaskEdit});

  @override
  State<HomeUndatedSection> createState() => _HomeUndatedSectionState();
}

class _HomeUndatedSectionState extends State<HomeUndatedSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskListBloc, TaskListState>(
      builder: (context, state) {
        if (state is! TaskListLoaded) return const SizedBox.shrink();
        final undatedTasks = state.tasks.where((t) => t.dueDate == null).toList();
        if (undatedTasks.isEmpty) return const SizedBox.shrink();

        final l10n = AppLocalizations.of(context)!;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                childrenPadding: const EdgeInsets.only(bottom: 12),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.event_busy, color: Theme.of(context).colorScheme.secondary, size: 24),
                ),
                title: Text(l10n.undatedTasks, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                subtitle: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        '${undatedTasks.length}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.tasksCount(undatedTasks.length), style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                initiallyExpanded: _expanded,
                onExpansionChanged: (v) => setState(() => _expanded = v),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
