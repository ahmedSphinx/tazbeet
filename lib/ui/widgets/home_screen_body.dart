import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_event.dart';
import 'package:tazbeet/blocs/task_list/task_list_state.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/models/task.dart';
import 'package:tazbeet/ui/controllers/home_screen_controller.dart';
import 'package:tazbeet/ui/widgets/edit_task_dialog.dart';
import 'package:tazbeet/ui/widgets/home/home_header.dart';
import 'package:tazbeet/ui/widgets/home/home_quick_stats.dart';
import 'package:tazbeet/ui/widgets/home/home_category_filter.dart';
import 'package:tazbeet/ui/widgets/home/home_active_filters_bar.dart';
import 'package:tazbeet/ui/widgets/home/home_calendar_panel.dart';
import 'package:tazbeet/ui/widgets/home/home_task_list_container.dart';
import 'package:tazbeet/ui/widgets/home/home_undated_section.dart';
import 'package:intl/intl.dart' as intl;

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
    return BlocListener<TaskListBloc, TaskListState>(
      listener: (context, state) {
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
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<TaskListBloc>().add(LoadTasks());
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: ValueListenableBuilder<bool>(
          valueListenable: _controller.showCalendar,
          builder: (context, showCalendar, _) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                // Enhanced Header with Stats
                const SliverToBoxAdapter(child: HomeHeader()),

                // Quick Stats Cards
                const SliverToBoxAdapter(
                  child: Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: HomeQuickStats()),
                ),

                // Category Filter with Calendar Toggle
                SliverToBoxAdapter(
                  child: HomeCategoryFilter(controller: _controller, listKey: widget.categoryFilterKey),
                ),

                // Calendar Section
                SliverToBoxAdapter(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: showCalendar ? HomeCalendarPanel(controller: _controller, onDayLongPress: _showDayBottomSheet, onTaskReschedule: _handleTaskReschedule) : const SizedBox.shrink(),
                  ),
                ),

                // Active Filters Display
                SliverToBoxAdapter(child: HomeActiveFiltersBar(controller: _controller)),

                // Task List with Enhanced UI
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<TaskListBloc, TaskListState>(
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
                        const SizedBox(height: 12),
                        HomeTaskListContainer(
                          controller: _controller,
                          sortByPriority: widget.sortByPriority,
                          searchQuery: widget.searchQuery,
                          filterPriority: widget.filterPriority,
                          filterCompleted: widget.filterCompleted,
                          onTaskEdit: _showEditTaskDialog,
                        ),
                      ],
                    ),
                  ),
                ),

                // Undated Tasks Section
                SliverToBoxAdapter(child: HomeUndatedSection(onTaskEdit: _showEditTaskDialog)),

                // Bottom Padding
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            );
          },
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

  void _showDayBottomSheet(DateTime date, List<Task> dayTasks) {
    final l10n = AppLocalizations.of(context)!;
    final dateStr = intl.DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(date);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (bottomSheetContext) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.viewDayTasks, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          Text(dateStr, style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
              // Task list
              Expanded(
                child: dayTasks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_available, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(l10n.noTasksForThisDay, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: dayTasks.length,
                        itemBuilder: (context, index) {
                          final task = dayTasks[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Checkbox(
                                value: task.isCompleted,
                                onChanged: (_) {
                                  this.context.read<TaskListBloc>().add(ToggleTaskCompletion(task.id));
                                },
                              ),
                              title: Text(task.title, style: TextStyle(decoration: task.isCompleted ? TextDecoration.lineThrough : null)),
                              subtitle: task.description != null ? Text(task.description!) : null,
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: ListTile(leading: const Icon(Icons.edit), title: Text(l10n.editTaskButton), contentPadding: EdgeInsets.zero),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _showEditTaskDialog(task);
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: ListTile(
                                      leading: const Icon(Icons.delete, color: Colors.red),
                                      title: Text(l10n.deleteTaskButton, style: const TextStyle(color: Colors.red)),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      this.context.read<TaskListBloc>().add(DeleteTask(task.id));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleTaskReschedule(Task task, DateTime newDate) {
    final l10n = AppLocalizations.of(context)!;
    final updatedTask = task.copyWith(dueDate: newDate);

    // Store original task for undo
    final originalTask = task;

    context.read<TaskListBloc>().add(UpdateTask(updatedTask));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.taskRescheduled),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: l10n.undo,
          textColor: Colors.white,
          onPressed: () {
            context.read<TaskListBloc>().add(UpdateTask(originalTask));
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
