import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_event.dart';
import 'package:tazbeet/blocs/task_list/task_list_state.dart';
import 'package:tazbeet/blocs/category/category_bloc.dart';
import 'package:tazbeet/blocs/category/category_state.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/models/task.dart';
import 'package:tazbeet/ui/controllers/home_screen_controller.dart';
import 'package:tazbeet/ui/design_system/ds_spacing.dart';
import 'package:tazbeet/ui/design_system/ds_typography.dart';
import 'package:tazbeet/ui/design_system/ds_colors.dart';
import 'package:tazbeet/ui/design_system/ds_border_radius.dart';
import 'package:tazbeet/ui/design_system/ds_elevation.dart';
import 'package:tazbeet/ui/design_system/ds_components.dart';
import 'package:tazbeet/ui/widgets/edit_task_dialog.dart';
import '../screens/task_details_screen.dart';

/// Complete Redesigned Home Screen
/// Following WCAG AA standards and design system tokens
class HomeScreenRedesigned extends StatefulWidget {
  const HomeScreenRedesigned({super.key});

  @override
  State<HomeScreenRedesigned> createState() => _HomeScreenRedesignedState();
}

class _HomeScreenRedesignedState extends State<HomeScreenRedesigned> {
  late final HomeScreenController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeScreenController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [_buildBackgroundGradient(context), _buildMainContent(context)]),
      floatingActionButton: DSEnhancedFAB(onPressed: () => _showAddTaskDialog(context), icon: Icons.add_rounded, tooltip: 'Add Task'),
    );
  }

  // ==========================================================================
  // BACKGROUND
  // ==========================================================================

  Widget _buildBackgroundGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark ? [const Color(0xFF0F172A), const Color(0xFF1E293B), const Color(0xFF334155)] : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0), const Color(0xFFCBD5E1)],
        ),
      ),
    );
  }

  // ==========================================================================
  // MAIN CONTENT
  // ==========================================================================

  Widget _buildMainContent(BuildContext context) {
    return BlocListener<TaskListBloc, TaskListState>(
      listener: _handleTaskListError,
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ValueListenableBuilder<bool>(
          valueListenable: _controller.showCalendar,
          builder: (context, showCalendar, _) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                // App Bar
                _buildAppBar(context),

                // Today's Progress Header
                SliverToBoxAdapter(child: _buildTodayHeader(context)),

                // Category Filter
                SliverToBoxAdapter(child: _buildCategoryFilter(context)),

                // Quick Stats
                SliverToBoxAdapter(child: _buildQuickStats(context)),

                // Active Filters
                SliverToBoxAdapter(child: _buildActiveFilters(context)),

                // Task List Header
                SliverToBoxAdapter(child: _buildTaskListHeader(context)),

                // Task List
                _buildTaskList(context),

                // Undated Tasks Section
                SliverToBoxAdapter(child: _buildUndatedSection(context)),

                // Bottom Padding for FAB
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            );
          },
        ),
      ),
    );
  }

  // ==========================================================================
  // APP BAR
  // ==========================================================================

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(AppLocalizations.of(context)!.appTitle, style: DSTypography.title(context).copyWith(color: Theme.of(context).colorScheme.primary)),
      actions: [
        IconButton(icon: const Icon(Icons.search_rounded), onPressed: () => _showSearchDialog(context), tooltip: 'Search'),
        IconButton(icon: const Icon(Icons.more_vert_rounded), onPressed: () => _showOptionsMenu(context), tooltip: 'Options'),
      ],
    );
  }

  // ==========================================================================
  // TODAY HEADER
  // ==========================================================================

  Widget _buildTodayHeader(BuildContext context) {
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

        return RepaintBoundary(
          child: Container(
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
                      Text('Today', style: DSTypography.subtitle(context).copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)),
                      const SizedBox(height: DSSpacing.xs),
                      Text('$completedToday / $todayTasks completed tasks', style: DSTypography.body(context).copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(DSSpacing.sm),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: Icon(todayTasks > 0 && completedToday == todayTasks ? Icons.check_circle_rounded : Icons.today_rounded, size: 28, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // CATEGORY FILTER
  // ==========================================================================

  Widget _buildCategoryFilter(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is! CategoryLoaded || state.categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return ValueListenableBuilder<String?>(
          valueListenable: _controller.selectedCategoryId,
          builder: (context, selectedCategoryId, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(DSSpacing.md, DSSpacing.md, DSSpacing.sm, DSSpacing.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.filter_list_rounded, size: 18, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: DSSpacing.sm),
                          Text(
                            'Category',
                            style: DSTypography.label(context).copyWith(fontWeight: FontWeight.w600, color: DSColors.getOnSurfaceColor(context)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Chips
                SizedBox(
                  height: 56,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.sm),
                    children: [
                      DSCategoryChip(
                        id: null,
                        label: 'All Categories',
                        icon: Icons.apps_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        isSelected: selectedCategoryId == null,
                        onTap: () => _controller.setCategory(null),
                      ),
                      ...state.categories.map(
                        (c) => DSCategoryChip(id: c.id, label: c.name, icon: Icons.folder_rounded, color: c.color, isSelected: selectedCategoryId == c.id, onTap: () => _controller.setCategory(c.id)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // QUICK STATS
  // ==========================================================================

  Widget _buildQuickStats(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.sm),
        child: BlocBuilder<TaskListBloc, TaskListState>(
          builder: (context, state) {
            if (state is! TaskListLoaded) {
              return const SizedBox.shrink();
            }

            final now = DateTime.now();
            final overdueCount = state.tasks.where((t) => !t.isCompleted && t.dueDate != null && t.dueDate!.isBefore(now)).length;

            final highPriorityCount = state.tasks.where((t) => !t.isCompleted && t.priority == TaskPriority.high).length;

            final undatedCount = state.tasks.where((t) => t.dueDate == null).length;

            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return Column(
                    children: [
                      DSStatCard(
                        icon: Icons.warning_amber_rounded,
                        value: '$overdueCount',
                        label: 'Overdue',
                        color: DSColors.getOverdueColor(context),
                        onTap: () => _controller.setOverdueFilter(),
                        semanticLabel: 'Overdue tasks: $overdueCount',
                      ),
                      const SizedBox(height: DSSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: DSStatCard(
                              icon: Icons.priority_high_rounded,
                              value: '$highPriorityCount',
                              label: 'High Priority',
                              color: DSColors.getHighPriorityColor(context),
                              onTap: () => _controller.setPriorityFilter(TaskPriority.high),
                              semanticLabel: 'High priority tasks: $highPriorityCount',
                            ),
                          ),
                          const SizedBox(width: DSSpacing.sm),
                          Expanded(
                            child: DSStatCard(
                              icon: Icons.event_busy_rounded,
                              value: '$undatedCount',
                              label: 'No Due Date',
                              color: DSColors.getUndatedColor(context),
                              onTap: () => _controller.setUndatedFilter(),
                              semanticLabel: 'Undated tasks: $undatedCount',
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child: DSStatCard(icon: Icons.warning_amber_rounded, value: '$overdueCount', label: 'Overdue', color: DSColors.getOverdueColor(context), onTap: () => _controller.setOverdueFilter()),
                      ),
                      const SizedBox(width: DSSpacing.sm),
                      Expanded(
                        child: DSStatCard(
                          icon: Icons.priority_high_rounded,
                          value: '$highPriorityCount',
                          label: 'High Priority',
                          color: DSColors.getHighPriorityColor(context),
                          onTap: () => _controller.setPriorityFilter(TaskPriority.high),
                        ),
                      ),
                      const SizedBox(width: DSSpacing.sm),
                      Expanded(
                        child: DSStatCard(icon: Icons.event_busy_rounded, value: '$undatedCount', label: 'No Due Date', color: DSColors.getUndatedColor(context), onTap: () => _controller.setUndatedFilter()),
                      ),
                    ],
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  // ==========================================================================
  // ACTIVE FILTERS
  // ==========================================================================

  Widget _buildActiveFilters(BuildContext context) {
    return ValueListenableBuilder<DateTime?>(
      valueListenable: _controller.selectedDate,
      builder: (context, selectedDate, _) {
        return ValueListenableBuilder<String?>(
          valueListenable: _controller.selectedCategoryId,
          builder: (context, selectedCategoryId, _) {
            if (selectedDate == null && selectedCategoryId == null) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.sm),
              child: Wrap(
                spacing: DSSpacing.sm,
                runSpacing: DSSpacing.sm,
                children: [
                  if (selectedDate != null) Chip(label: Text('${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'), onDeleted: () => _controller.clearDate(), deleteIcon: const Icon(Icons.close, size: 18)),
                  if (selectedCategoryId != null)
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is! CategoryLoaded) {
                          return const SizedBox.shrink();
                        }
                        final category = state.categories.firstWhere((c) => c.id == selectedCategoryId);
                        return Chip(label: Text(category.name), avatar: const Icon(Icons.folder, size: 16), onDeleted: () => _controller.setCategory(null), deleteIcon: const Icon(Icons.close, size: 18));
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // TASK LIST HEADER
  // ==========================================================================

  Widget _buildTaskListHeader(BuildContext context) {
    return BlocBuilder<TaskListBloc, TaskListState>(
      builder: (context, state) {
        int taskCount = 0;
        if (state is TaskListLoaded) {
          taskCount = state.tasks.where((t) => !t.isCompleted).length;
        }

        return DSSectionHeader(title: 'Tasks', icon: Icons.task_alt_rounded, badge: '$taskCount');
      },
    );
  }

  // ==========================================================================
  // TASK LIST
  // ==========================================================================

  Widget _buildTaskList(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: _controller.selectedCategoryId,
      builder: (context, selectedCategoryId, _) {
        return ValueListenableBuilder<DateTime?>(
          valueListenable: _controller.selectedDate,
          builder: (context, selectedDate, _) {
            return ValueListenableBuilder<String>(
              valueListenable: _controller.searchQuery,
              builder: (context, searchQuery, _) {
                return BlocBuilder<TaskListBloc, TaskListState>(
                  builder: (context, state) {
                    if (state is TaskListLoading) {
                      return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                    }

                    if (state is TaskListLoaded) {
                      var tasks = state.tasks.where((t) => t.dueDate != null && !t.isCompleted).toList();

                      // Apply category filter
                      if (selectedCategoryId != null) {
                        tasks = tasks.where((t) => t.categoryId == selectedCategoryId).toList();
                      }

                      // Apply date filter
                      if (selectedDate != null) {
                        final start = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
                        final end = start.add(const Duration(days: 1));
                        tasks = tasks.where((t) {
                          final d = t.dueDate!;
                          return !d.isBefore(start) && d.isBefore(end);
                        }).toList();
                      }

                      // Apply search filter
                      if (searchQuery.isNotEmpty) {
                        final query = searchQuery.toLowerCase();
                        tasks = tasks.where((t) {
                          return t.title.toLowerCase().contains(query) || (t.description?.toLowerCase().contains(query) ?? false);
                        }).toList();
                      }

                      // Apply sort
                      tasks = _controller.sortTasks(tasks);

                      if (tasks.isEmpty) {
                        return SliverFillRemaining(
                          child: DSEmptyState(
                            icon: Icons.task_alt_rounded,
                            title: searchQuery.isNotEmpty ? 'No matching tasks' : 'No tasks',
                            message: searchQuery.isNotEmpty ? 'Try a different search term' : 'Add a task to get started',
                            actionLabel: searchQuery.isNotEmpty ? null : 'Add Task',
                            onAction: searchQuery.isNotEmpty ? null : () => _showAddTaskDialog(context),
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final task = tasks[index];
                          return RepaintBoundary(
                            child: DSTaskCard(
                              task: task,
                              onTap: () => _navigateToTaskDetails(context, task),
                              onToggle: () => context.read<TaskListBloc>().add(ToggleTaskCompletion(task.id)),
                              onDelete: () => _deleteTask(context, task),
                              onLongPress: () => _showQuickActions(context, task),
                            ),
                          );
                        }, childCount: tasks.length),
                      );
                    }

                    return const SliverFillRemaining(child: Center(child: Text('Error loading tasks')));
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // UNDATED SECTION
  // ==========================================================================

  Widget _buildUndatedSection(BuildContext context) {
    return BlocBuilder<TaskListBloc, TaskListState>(
      builder: (context, state) {
        if (state is! TaskListLoaded) return const SizedBox.shrink();

        final undatedTasks = state.tasks.where((t) => t.dueDate == null).toList();

        if (undatedTasks.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.all(DSSpacing.md),
          child: ExpansionTile(
            title: Text('Tasks without dates', style: DSTypography.subtitle(context)),
            leading: Icon(Icons.event_busy_rounded, color: Theme.of(context).colorScheme.primary),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: DSSpacing.sm, vertical: DSSpacing.xs),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.errorContainer, borderRadius: DSBorderRadius.fullRadius),
              child: Text(
                '${undatedTasks.length}',
                style: DSTypography.caption(context).copyWith(color: Theme.of(context).colorScheme.onErrorContainer, fontWeight: FontWeight.w600),
              ),
            ),
            children: undatedTasks
                .map(
                  (task) => Padding(
                    padding: const EdgeInsets.only(top: DSSpacing.xs),
                    child: DSTaskCard(
                      task: task,
                      onTap: () => _navigateToTaskDetails(context, task),
                      onToggle: () => context.read<TaskListBloc>().add(ToggleTaskCompletion(task.id)),
                      onDelete: () => _deleteTask(context, task),
                      onLongPress: () => _showQuickActions(context, task),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  void _handleTaskListError(BuildContext context, TaskListState state) {
    if (state is TaskListError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(state.message)),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: DSBorderRadius.mdRadius),
          margin: const EdgeInsets.all(DSSpacing.md),
        ),
      );
    }
  }

  Future<void> _onRefresh() async {
    context.read<TaskListBloc>().add(LoadTasks());
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _showAddTaskDialog(BuildContext context) {
    // Create empty task for new task dialog
    final now = DateTime.now();
    final newTask = Task(id: '', title: '', isCompleted: false, createdAt: now, updatedAt: now, priority: TaskPriority.medium);
    showDialog(
      context: context,
      builder: (context) => EditTaskDialog(
        task: newTask,
        onTaskUpdated: (task) {
          context.read<TaskListBloc>().add(LoadTasks());
        },
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => EditTaskDialog(
        task: task,
        onTaskUpdated: (updatedTask) {
          context.read<TaskListBloc>().add(LoadTasks());
        },
      ),
    );
  }

  void _navigateToTaskDetails(BuildContext context, Task task) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetailsScreen(taskId: task.id)));

    // Refresh if task was modified
    if (result == true) {
      context.read<TaskListBloc>().add(LoadTasks());
    }
  }

  void _deleteTask(BuildContext context, Task task) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 12),
            const Text('Delete Task?'),
          ],
        ),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Delete task
    context.read<TaskListBloc>().add(DeleteTask(task.id));

    // Show undo snackbar
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            context.read<TaskListBloc>().add(AddTask(task));
          },
        ),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: DSBorderRadius.mdRadius),
        margin: const EdgeInsets.all(DSSpacing.md),
      ),
    );
  }

  void _showQuickActions(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                _navigateToTaskDetails(context, task);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Quick Edit'),
              onTap: () {
                Navigator.pop(context);
                _showEditTaskDialog(context, task);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteTask(context, task);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    // Search is now handled by main_screen search bar
    // This method can be used for advanced search if needed
  }

  void _showOptionsMenu(BuildContext context) {
    // Show sort and filter options
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Sort By'),
              trailing: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ),
            const Divider(),
            ValueListenableBuilder<TaskSortOption>(
              valueListenable: _controller.sortOption,
              builder: (context, currentSort, _) {
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Due Date'),
                      trailing: currentSort == TaskSortOption.dueDate ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
                      onTap: () {
                        _controller.setSortOption(TaskSortOption.dueDate);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.priority_high),
                      title: const Text('Priority'),
                      trailing: currentSort == TaskSortOption.priority ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
                      onTap: () {
                        _controller.setSortOption(TaskSortOption.priority);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.sort_by_alpha),
                      title: const Text('Title'),
                      trailing: currentSort == TaskSortOption.title ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
                      onTap: () {
                        _controller.setSortOption(TaskSortOption.title);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Created Date'),
                      trailing: currentSort == TaskSortOption.createdDate ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
                      onTap: () {
                        _controller.setSortOption(TaskSortOption.createdDate);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
