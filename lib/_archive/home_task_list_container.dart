import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_event.dart';
import 'package:tazbeet/blocs/task_list/task_list_state.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/models/task.dart';
import 'package:tazbeet/ui/controllers/home_screen_controller.dart';
import 'package:tazbeet/ui/widgets/error_display.dart';
import 'package:tazbeet/ui/widgets/loading_skeleton.dart';
import 'package:tazbeet/ui/widgets/task_list_section.dart';
import 'package:tazbeet/utils/date_range.dart';

/// Container widget that displays the filtered task list with loading/empty/error states

class HomeTaskListContainer extends StatefulWidget {
  final HomeScreenController controller;
  final bool sortByPriority;
  final String searchQuery;
  final TaskPriority? filterPriority;
  final bool? filterCompleted;
  final Function(Task)? onTaskEdit;
  final Function(String)? onTaskSelected;
  final bool batchSelectionMode;
  final Set<String>? selectedTaskIds;
  final VoidCallback? onBatchComplete;
  final VoidCallback? onBatchDelete;

  const HomeTaskListContainer({
    super.key,
    required this.controller,
    this.sortByPriority = false,
    this.searchQuery = '',
    this.filterPriority,
    this.filterCompleted,
    this.onTaskEdit,
    this.onTaskSelected,
    this.batchSelectionMode = false,
    this.selectedTaskIds,
    this.onBatchComplete,
    this.onBatchDelete,
  });

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
              builder: (context, state) => _buildContent(
                context,
                state,
                selectedDate,
                selectedCategoryId,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    TaskListState state,
    DateTime? selectedDate,
    String? selectedCategoryId,
  ) {
    if (state is TaskListLoading) {
      return const LoadingSkeleton();
    }

    if (state is TaskListError) {
      return ErrorDisplay(
        message: state.message,
        onRetry: () => context.read<TaskListBloc>().add(LoadTasks()),
      );
    }

    if (state is TaskListLoaded) {
      final tasks = _filterTasks(state.tasks, selectedDate, selectedCategoryId);

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
        batchSelectionMode: widget.batchSelectionMode,
        onTaskSelected: widget.onTaskSelected,
        selectedTaskIds: widget.selectedTaskIds,
      );
    }

    return const SizedBox.shrink();
  }

  /// Filters tasks by category, date, and excludes undated tasks
  List<Task> _filterTasks(
    List<Task> tasks,
    DateTime? selectedDate,
    String? selectedCategoryId,
  ) {
    var filtered = tasks.toList();

    // Apply category filter
    if (selectedCategoryId != null) {
      filtered = filtered.where((t) => t.categoryId == selectedCategoryId).toList();
    }

    // Apply date filter
    if (selectedDate != null) {
      final r = dayRange(selectedDate);
      filtered = filtered.where((t) {
        final d = t.dueDate;
        if (d == null) return false;
        return !d.isBefore(r.start) && d.isBefore(r.end);
      }).toList();
    }

    // Filter out undated tasks (they have their own section)
    return filtered.where((t) => t.dueDate != null).toList();
  }

  Widget _buildEmptyState(
    BuildContext context,
    DateTime? selectedDate,
    String? selectedCategoryId,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Determine message and icon based on active filters
    final (String message, IconData icon) = switch ((selectedDate, selectedCategoryId)) {
      (DateTime _, String _) => (l10n.noTasksForThisDay, Icons.event_available),
      (DateTime _, null) => (l10n.noTasksForThisDay, Icons.event_available),
      (null, String _) => (l10n.noTasksInCategory, Icons.folder_open),
      (null, null) => (l10n.noTasksYet, Icons.task_alt),
    };

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: child,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.addTaskToGetStarted,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
