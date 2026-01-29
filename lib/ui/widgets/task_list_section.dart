import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_event.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/models/task.dart';
import 'package:tazbeet/ui/widgets/task_item.dart';
import 'package:tazbeet/ui/widgets/empty_state.dart';

class TaskListSection extends StatelessWidget {
  final List<Task> tasks;
  final String? selectedCategoryId;
  final bool sortByPriority;
  final String searchQuery;
  final TaskPriority? filterPriority;
  final bool? filterCompleted;
  final Function(String) onTaskToggle;
  final Function(Task) onTaskEdit;
  final Function(String) onTaskDelete;
  final bool batchSelectionMode;
  final Function(String)? onTaskSelected;
  final Set<String>? selectedTaskIds;

  const TaskListSection({
    super.key,
    required this.tasks,
    this.selectedCategoryId,
    this.sortByPriority = false,
    this.searchQuery = '',
    this.filterPriority,
    this.filterCompleted,
    required this.onTaskToggle,
    required this.onTaskEdit,
    required this.onTaskDelete,
    this.batchSelectionMode = false,
    this.onTaskSelected,
    this.selectedTaskIds,
  });

  @override
  Widget build(BuildContext context) {
    final groups = _applyFilters(tasks);

    if (groups.isEmpty || groups.values.every((list) => list.isEmpty)) {
      return const EmptyState();
    }

    final l10n = AppLocalizations.of(context)!;
    final groupOrder = ['Overdue', 'Today', 'Tomorrow', 'This Week', 'Later', 'No Date', 'Completed'];
    final groupTitles = {'Overdue': l10n.overdueTasks, 'Today': l10n.todayTasks, 'Tomorrow': l10n.tomorrowTasks, 'This Week': l10n.thisWeekTasks, 'Later': l10n.laterTasks, 'No Date': l10n.noDateTasks, 'Completed': l10n.completedTasks};

    // Sort within groups by index, then priority and due date
    for (var entry in groups.entries) {
      entry.value.sort((a, b) {
        // Primary: Index
        if (a.index != b.index) {
          return a.index.compareTo(b.index);
        }
        // Secondary: Priority
        int comp = b.priority.index.compareTo(a.priority.index);
        if (comp != 0) return comp;
        // Tertiary: Due Date
        return (b.dueDate ?? b.createdAt).compareTo(a.dueDate ?? a.createdAt);
      });
    }

    return Column(
      children: [
        for (final groupKey in groupOrder.where((k) => groups.containsKey(k) && groups[k]!.isNotEmpty))
          Column(
            key: ValueKey(groupKey),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    Icon(_getGroupIcon(groupKey), color: _getGroupColor(context, groupKey)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(groupTitles[groupKey] ?? groupKey, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                onReorder: (oldIndex, newIndex) {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final groupTasks = groups[groupKey]!;
                  final item = groupTasks.removeAt(oldIndex);
                  groupTasks.insert(newIndex, item);

                  // Update indices for all tasks in this group
                  final updatedTasks = <Task>[];
                  for (int i = 0; i < groupTasks.length; i++) {
                    if (groupTasks[i].index != i) {
                      updatedTasks.add(groupTasks[i].copyWith(index: i));
                    }
                  }

                  if (updatedTasks.isNotEmpty) {
                    context.read<TaskListBloc>().add(ReorderTasks(updatedTasks));
                  }
                },
                children: [
                  for (final task in groups[groupKey]!)
                    TaskItem(key: ValueKey(task.id), task: task, onToggle: () => onTaskToggle(task.id), onEdit: () => onTaskEdit(task), onDelete: () => onTaskDelete(task.id), batchSelectionMode: batchSelectionMode, onTaskSelected: onTaskSelected, selected: selectedTaskIds?.contains(task.id) ?? false),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Map<String, List<Task>> _applyFilters(List<Task> tasks) {
    var filteredTasks = selectedCategoryId == null ? tasks : tasks.where((task) => task.categoryId == selectedCategoryId).toList();

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final queryLower = searchQuery.toLowerCase();
      filteredTasks = filteredTasks.where((task) {
        final titleLower = task.title.toLowerCase();
        final descLower = task.description?.toLowerCase() ?? '';
        return titleLower.contains(queryLower) || descLower.contains(queryLower);
      }).toList();
    }

    // Apply priority filter
    if (filterPriority != null) {
      filteredTasks = filteredTasks.where((task) => task.priority == filterPriority).toList();
    }

    // Apply completion filter
    if (filterCompleted != null) {
      filteredTasks = filteredTasks.where((task) => task.isCompleted == filterCompleted).toList();
    }

    // Group tasks by due date categories
    Map<String, List<Task>> groups = {};
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final endOfToday = startOfToday.add(const Duration(days: 1));
    final startOfTomorrow = endOfToday;
    final endOfTomorrow = startOfTomorrow.add(const Duration(days: 1));
    final endOfWeek = startOfToday.add(Duration(days: 7 - now.weekday + 1));

    for (var task in filteredTasks) {
      String key;
      if (task.isCompleted) {
        key = 'Completed';
      } else {
        final due = task.dueDate;
        if (due == null) {
          key = 'No Date';
        } else if (due.isBefore(startOfToday)) {
          key = 'Overdue';
        } else if (due.isBefore(endOfToday)) {
          key = 'Today';
        } else if (due.isBefore(endOfTomorrow)) {
          key = 'Tomorrow';
        } else if (due.isBefore(endOfWeek)) {
          key = 'This Week';
        } else {
          key = 'Later';
        }
      }
      groups.putIfAbsent(key, () => []).add(task);
    }

    return groups;
  }

  IconData _getGroupIcon(String key) {
    switch (key) {
      case 'Overdue':
        return Icons.warning;
      case 'Today':
        return Icons.today;
      case 'Tomorrow':
        return Icons.schedule;
      case 'This Week':
        return Icons.calendar_view_week;
      case 'Later':
        return Icons.date_range;
      case 'No Date':
        return Icons.help_outline;
      case 'Completed':
        return Icons.check_circle;
      default:
        return Icons.list;
    }
  }

  Color _getGroupColor(BuildContext context, String key) {
    switch (key) {
      case 'Overdue':
        return Colors.red;
      case 'Today':
        return Colors.blue;
      case 'Tomorrow':
        return Colors.orange;
      case 'This Week':
        return Colors.green;
      case 'Later':
        return Colors.purple;
      case 'No Date':
        return Colors.grey;
      case 'Completed':
        return Colors.teal;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
