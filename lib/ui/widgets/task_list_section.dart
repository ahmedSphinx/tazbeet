import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/models/task.dart';
import 'package:tazbeet/ui/screens/task_details_screen.dart';
import 'package:tazbeet/ui/widgets/task_item.dart';
import 'package:tazbeet/ui/widgets/empty_state.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    final groups = _applyFilters(tasks);

    if (groups.isEmpty || groups.values.every((list) => list.isEmpty)) {
      return const EmptyState();
    }

    final l10n = AppLocalizations.of(context)!;
    final groupOrder = ['Overdue', 'Today', 'Tomorrow', 'This Week', 'Later', 'No Date', 'Completed'];
    final groupTitles = {
      'Overdue': l10n.overdueTasks,
      'Today': l10n.todayTasks,
      'Tomorrow': l10n.tomorrowTasks,
      'This Week': l10n.thisWeekTasks,
      'Later': l10n.laterTasks,
      'No Date': l10n.noDateTasks,
      'Completed': l10n.completedTasks,
    };

    // Sort within groups by priority and due date
    for (var entry in groups.entries) {
      entry.value.sort((a, b) {
        int comp = b.priority.index.compareTo(a.priority.index);
        if (comp != 0) return comp;
        return (b.dueDate ?? b.createdAt).compareTo(a.dueDate ?? a.createdAt);
      });
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupOrder.where((k) => groups.containsKey(k) && groups[k]!.isNotEmpty).length,
      itemBuilder: (context, groupIndex) {
        final key = groupOrder.where((k) => groups.containsKey(k) && groups[k]!.isNotEmpty).elementAt(groupIndex);
        final tasksInGroup = groups[key]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  Icon(_getGroupIcon(key), color: _getGroupColor(context, key)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      groupTitles[key] ?? key,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            AnimationLimiter(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasksInGroup.length,
                itemBuilder: (context, index) {
                  final task = tasksInGroup[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      curve: Curves.easeOutCubic,
                      child: FadeInAnimation(
                        curve: Curves.easeOut,
                        child: ScaleAnimation(
                          scale: 0.95,
                          curve: Curves.easeOutBack,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: TaskItem(
                              task: task,
                              onEdit: () => onTaskEdit(task),
                              onDelete: () => onTaskDelete(task.id),
                              onToggle: task.subtasks.isEmpty
                                  ? () => onTaskToggle(task.id)
                                  : () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => TaskDetailsScreen(taskId: task.id)),
                                      );
                                      context.read<TaskListBloc>().add(LoadTasks());
                                    },
                              onLongTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TaskDetailsScreen(taskId: task.id)),
                                );
                                context.read<TaskListBloc>().add(LoadTasks());
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Map<String, List<Task>> _applyFilters(List<Task> tasks) {
    var filteredTasks = selectedCategoryId == null
        ? tasks
        : tasks.where((task) => task.categoryId == selectedCategoryId).toList();

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
