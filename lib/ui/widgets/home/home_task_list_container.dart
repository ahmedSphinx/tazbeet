import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_event.dart';
import 'package:tazbeet/blocs/task_list/task_list_state.dart';
import 'package:tazbeet/models/task.dart';
import 'package:tazbeet/ui/controllers/home_screen_controller.dart';
import 'package:tazbeet/ui/widgets/loading_skeleton.dart';
import 'package:tazbeet/ui/widgets/error_display.dart';
import 'package:tazbeet/ui/widgets/task_list_section.dart';
import 'package:tazbeet/utils/date_range.dart';
import 'package:tazbeet/l10n/app_localizations.dart';

class HomeTaskListContainer extends StatefulWidget {
  final HomeScreenController controller;
  final bool sortByPriority;
  final String searchQuery;
  final TaskPriority? filterPriority;
  final bool? filterCompleted;
  final Function(Task)? onTaskEdit;
  const HomeTaskListContainer({super.key, required this.controller, this.sortByPriority = false, this.searchQuery = '', this.filterPriority, this.filterCompleted, this.onTaskEdit});

  @override
  State<HomeTaskListContainer> createState() => _HomeTaskListContainerState();
}

class _HomeTaskListContainerState extends State<HomeTaskListContainer> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder<DateTime?>(
      valueListenable: widget.controller.selectedDate,
      builder: (context, selectedDate, _) {
        return ValueListenableBuilder<String?>(
          valueListenable: widget.controller.selectedCategoryId,
          builder: (context, selectedCategoryId, __) {
            return BlocBuilder<TaskListBloc, TaskListState>(
              builder: (context, state) {
                if (state is TaskListLoading) {
                  return const LoadingSkeleton();
                } else if (state is TaskListLoaded) {
                  List<Task> tasks = state.tasks;

                  // Apply category filter
                  if (selectedCategoryId != null) {
                    tasks = tasks.where((t) => t.categoryId == selectedCategoryId).toList();
                  }

                  // Apply date filter
                  if (selectedDate != null) {
                    final r = dayRange(selectedDate);
                    tasks = tasks.where((t) {
                      final d = t.dueDate;
                      if (d == null) return false;
                      return !d.isBefore(r.start) && d.isBefore(r.end);
                    }).toList();
                  }

                  // Filter out undated tasks (they have their own section)
                  tasks = tasks.where((t) => t.dueDate != null).toList();

                  // Show empty state if no tasks
                  if (tasks.isEmpty) {
                    return _buildEmptyState(context, selectedDate, selectedCategoryId);
                  }

                  return TaskListSection(
                    tasks: tasks,
                    selectedCategoryId: selectedCategoryId,
                    sortByPriority: widget.sortByPriority,
                    searchQuery: widget.searchQuery,
                    filterPriority: widget.filterPriority,
                    filterCompleted: widget.filterCompleted,
                    onTaskToggle: (taskId) => context.read<TaskListBloc>().add(ToggleTaskCompletion(taskId)),
                    onTaskEdit: widget.onTaskEdit ?? (task) {},
                    onTaskDelete: (taskId) => context.read<TaskListBloc>().add(DeleteTask(taskId)),
                  );
                } else if (state is TaskListError) {
                  return ErrorDisplay(message: state.message, onRetry: () => context.read<TaskListBloc>().add(LoadTasks()));
                }
                return const SizedBox.shrink();
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, DateTime? selectedDate, String? selectedCategoryId) {
    final l10n = AppLocalizations.of(context)!;
    String message;
    IconData icon;

    if (selectedDate != null && selectedCategoryId != null) {
      message = l10n.noTasksForThisDay;
      icon = Icons.event_available;
    } else if (selectedDate != null) {
      message = l10n.noTasksForThisDay;
      icon = Icons.event_available;
    } else if (selectedCategoryId != null) {
      message = l10n.noTasksInCategory;
      icon = Icons.folder_open;
    } else {
      message = l10n.noTasksYet;
      icon = Icons.task_alt;
    }

    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3), shape: BoxShape.circle),
            child: Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.addTaskToGetStarted,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
