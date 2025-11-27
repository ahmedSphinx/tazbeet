import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_event.dart';
import 'package:tazbeet/blocs/task_list/task_list_state.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/models/task.dart';
import 'package:tazbeet/ui/controllers/home_screen_controller.dart';
import 'package:tazbeet/ui/widgets/edit_task_dialog.dart';
import 'package:tazbeet/ui/widgets/home/home_active_filters_bar.dart';
import 'package:tazbeet/ui/widgets/home/home_calendar_panel.dart';
import 'package:tazbeet/ui/widgets/home/home_category_filter.dart';
import 'package:tazbeet/ui/widgets/home/home_header.dart';
import 'package:tazbeet/ui/widgets/home/home_quick_stats.dart';
import 'package:tazbeet/ui/widgets/home/home_task_list_container.dart';
import 'package:tazbeet/ui/widgets/home/home_undated_section.dart';
import 'package:tazbeet/ui/design_system/ds_spacing.dart';

class HomeScreenBody extends StatefulWidget {
  final String? selectedCategoryId;
  final bool sortByPriority;
  final String searchQuery;
  final TaskPriority? filterPriority;
  final bool? filterCompleted;
  final Function(String?)? onCategoryChanged;
  final GlobalKey? categoryFilterKey;

  const HomeScreenBody({super.key, this.selectedCategoryId, this.sortByPriority = false, this.searchQuery = '', this.filterPriority, this.filterCompleted, this.onCategoryChanged, this.categoryFilterKey});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  late final HomeScreenController _controller;
  final Set<String> _selectedTaskIds = {};
  bool _batchSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _controller = HomeScreenController();
    if (widget.selectedCategoryId != null) {
      _controller.setCategory(widget.selectedCategoryId);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(HomeScreenBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCategoryId != oldWidget.selectedCategoryId) {
      _controller.setCategory(widget.selectedCategoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_buildBackgroundGradient(context), _buildMainContent(context)]);
  }

  /// Builds the background gradient based on theme brightness
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

  /// Main content with error handling and refresh capability
  Widget _buildMainContent(BuildContext context) {
    return BlocListener<TaskListBloc, TaskListState>(
      listener: _handleTaskListError,
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ValueListenableBuilder<bool>(valueListenable: _controller.showCalendar, builder: (context, showCalendar, _) => _buildScrollView(context, showCalendar)),
      ),
    );
  }

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(DSSpacing.md),
        ),
      );
    }
  }

  Future<void> _onRefresh() async {
    context.read<TaskListBloc>().add(LoadTasks());
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Widget _buildScrollView(BuildContext context, bool showCalendar) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        // Today's Progress Header
        const SliverToBoxAdapter(child: HomeHeader()),

        // Category Filter with Calendar Toggle
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.lg / 2),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: HomeCategoryFilter(controller: _controller, listKey: widget.categoryFilterKey),
            ),
          ),
        ),

        // Calendar Panel (conditionally shown)
        if (showCalendar)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: HomeCalendarPanel(controller: _controller),
              ),
            ),
          ),

        // Search Bar
        SliverToBoxAdapter(child: _buildSearchBar(context)),

        // Quick Stats Cards
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.lg / 2),
            child: HomeQuickStats(
              onOverdueTap: () => setState(() => _controller.setOverdueFilter()),
              onHighPriorityTap: () => setState(() => _controller.setPriorityFilter(TaskPriority.high)),
              onUndatedTap: () => setState(() => _controller.setUndatedFilter()),
            ),
          ),
        ),

        // Active Filters Display
        SliverToBoxAdapter(child: HomeActiveFiltersBar(controller: _controller)),

        // Task List Section Header
        SliverToBoxAdapter(child: _buildTaskListHeader(context)),

        // Task List with Enhanced UI
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md),
            child: ValueListenableBuilder<TaskPriority?>(
              valueListenable: _controller.filterPriority,
              builder: (context, filterPriority, _) {
                return Stack(
                  children: [
                    HomeTaskListContainer(
                      controller: _controller,
                      sortByPriority: widget.sortByPriority,
                      searchQuery: widget.searchQuery,
                      filterPriority: filterPriority,
                      filterCompleted: widget.filterCompleted,
                      onTaskEdit: _showEditTaskDialog,
                      onTaskSelected: _toggleTaskSelection,
                      batchSelectionMode: _batchSelectionMode,
                      selectedTaskIds: _selectedTaskIds,
                    ),
                    if (_batchSelectionMode && _selectedTaskIds.isNotEmpty) _buildBatchActionBar(),
                  ],
                );
              },
            ),
          ),
        ),

        // Undated Tasks Section
        SliverToBoxAdapter(child: HomeUndatedSection(onTaskEdit: _showEditTaskDialog)),

        // Bottom Padding for FAB
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  /// Search bar widget
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.lg / 2),
      child: TextField(
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchHint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: _controller.setSearchQuery,
      ),
    );
  }

  /// Task list section header with count badge
  Widget _buildTaskListHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.lg / 2),
      child: BlocBuilder<TaskListBloc, TaskListState>(
        builder: (context, state) {
          int taskCount = 0;
          if (state is TaskListLoaded) {
            taskCount = state.tasks.where((t) => !t.isCompleted).length;
          }
          return Row(
            children: [
              Icon(Icons.task_alt, size: 22, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.tasksCount(taskCount),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              ),
              if (taskCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    '$taskCount',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  /// Batch action bar for multi-select mode
  Widget _buildBatchActionBar() {
    final l10n = AppLocalizations.of(context)!;
    return Positioned(
      bottom: DSSpacing.lg,
      left: 0,
      right: 0,
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: DSSpacing.md),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BatchActionButton(icon: Icons.check_circle, label: l10n.completeTaskButton, onPressed: _batchCompleteTasks, color: Theme.of(context).colorScheme.primary),
              _BatchActionButton(icon: Icons.delete, label: l10n.deleteButton, onPressed: _batchDeleteTasks, color: Colors.red),
              _BatchActionButton(icon: Icons.close, label: l10n.cancelButton, onPressed: _toggleBatchSelectionMode, color: Theme.of(context).colorScheme.outline),
            ],
          ),
        ),
      ),
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.settingsSaved), backgroundColor: Colors.blue, behavior: SnackBarBehavior.floating));
        },
      ),
    );
  }

  void _toggleBatchSelectionMode() {
    setState(() {
      _batchSelectionMode = !_batchSelectionMode;
      if (!_batchSelectionMode) _selectedTaskIds.clear();
    });
  }

  void _toggleTaskSelection(String taskId) {
    setState(() {
      if (_selectedTaskIds.contains(taskId)) {
        _selectedTaskIds.remove(taskId);
      } else {
        _selectedTaskIds.add(taskId);
      }
    });
  }

  void _batchCompleteTasks() {
    for (final id in _selectedTaskIds) {
      context.read<TaskListBloc>().add(ToggleTaskCompletion(id));
    }
    _toggleBatchSelectionMode();
  }

  void _batchDeleteTasks() {
    for (final id in _selectedTaskIds) {
      context.read<TaskListBloc>().add(DeleteTask(id));
    }
    _toggleBatchSelectionMode();
  }
}

/// Reusable batch action button widget
class _BatchActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const _BatchActionButton({required this.icon, required this.label, required this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
