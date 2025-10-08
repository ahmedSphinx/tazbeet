import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/category/category_bloc.dart';
import 'package:tazbeet/blocs/category/category_state.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_event.dart';
import 'package:tazbeet/blocs/task_list/task_list_state.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/models/task.dart';
import 'package:tazbeet/ui/widgets/edit_task_dialog.dart';
import 'package:tazbeet/ui/widgets/error_display.dart';
import 'package:tazbeet/ui/widgets/loading_skeleton.dart';
import 'package:tazbeet/ui/widgets/task_list_section.dart';

class HomeScreenBody extends StatefulWidget {
  final String? selectedCategoryId;
  final bool sortByPriority;
  final String searchQuery;
  final TaskPriority? filterPriority;
  final bool? filterCompleted;
  final Function(String?)? onCategoryChanged;
  final GlobalKey? categoryFilterKey;

  const HomeScreenBody({
    super.key,
    this.selectedCategoryId,
    this.sortByPriority = false,
    this.searchQuery = '',
    this.filterPriority,
    this.filterCompleted,
    this.onCategoryChanged,
    this.categoryFilterKey,
  });

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskListBloc, TaskListState>(
      listener: (context, state) {
        if (state is TaskListError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildCategoryFilter(),
            _buildTaskListSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoaded && state.categories.isNotEmpty) {
          return Container(
            key: widget.categoryFilterKey,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryChip(null, AppLocalizations.of(context)!.allCategories, Icons.align_horizontal_left_rounded, Theme.of(context).colorScheme.primary),
                ...state.categories.map((category) => _buildCategoryChip(category.id, category.name, Icons.folder, category.color)),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCategoryChip(String? categoryId, String label, IconData icon, Color color) {
    final isSelected = _selectedCategoryId == categoryId;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategoryId = selected ? categoryId : null;
          });
          widget.onCategoryChanged?.call(_selectedCategoryId);
        },
        backgroundColor: !isSelected ? color.withValues(alpha: 0.4) : Theme.of(context).colorScheme.surface,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }

  Widget _buildTaskListSection() {
    return BlocBuilder<TaskListBloc, TaskListState>(
      builder: (context, state) {
        if (state is TaskListLoading) {
          return const LoadingSkeleton();
        } else if (state is TaskListLoaded) {
          return TaskListSection(
            tasks: state.tasks,
            selectedCategoryId: _selectedCategoryId,
            sortByPriority: widget.sortByPriority,
            searchQuery: widget.searchQuery,
            filterPriority: widget.filterPriority,
            filterCompleted: widget.filterCompleted,
            onTaskToggle: (taskId) {
              context.read<TaskListBloc>().add(ToggleTaskCompletion(taskId));
            },
            onTaskEdit: (task) => _showEditTaskDialog(task),
            onTaskDelete: (taskId) {
              context.read<TaskListBloc>().add(DeleteTask(taskId));
            },
          );
        } else if (state is TaskListError) {
          return ErrorDisplay(
            message: state.message,
            onRetry: () {
              context.read<TaskListBloc>().add(LoadTasks());
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showEditTaskDialog(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => EditTaskDialog(
        task: task,
        onTaskUpdated: (updatedTask) {
          context.read<TaskListBloc>().add(UpdateTask(updatedTask));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.settingsSaved),
              backgroundColor: Colors.blue,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
}
