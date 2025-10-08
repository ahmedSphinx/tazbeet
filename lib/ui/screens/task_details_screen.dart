import 'package:tazbeet/services/app_logging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:reorderables/reorderables.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';
import '../../blocs/task_details/task_details_bloc.dart';
import '../../blocs/task_details/task_details_event.dart';
import '../../blocs/task_details/task_details_state.dart';
import '../../models/task.dart';
import '../../repositories/task_repository.dart';
import '../widgets/subtask_widget.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/edit_task_dialog.dart';

import '../widgets/error_display.dart';
import '../../services/notification_service.dart';
import 'pomodoro_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _fabAnimationController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _fabAnimationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _fabAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => TaskDetailsBloc(taskRepository: context.read<TaskRepository>())..add(LoadTaskDetails(widget.taskId)),
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
              builder: (context, state) {
                if (state is TaskDetailsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskDetailsError) {
                  return ErrorDisplay(message: state.message, onRetry: () => context.read<TaskDetailsBloc>().add(LoadTaskDetails(widget.taskId)));
                } else if (state is TaskDetailsLoaded) {
                  return _buildContent(context, state, l10n);
                }
                return const SizedBox.shrink();
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(confettiController: _confettiController, blastDirectionality: BlastDirectionality.explosive, shouldLoop: false, colors: const [Colors.red, Colors.blue, Colors.green, Colors.yellow]),
            ),
          ],
        ),
        floatingActionButton: _buildFAB(context, l10n),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TaskDetailsLoaded state, AppLocalizations l10n) {
    final task = state.task;
    final progress = state.progress;
    isCompleted = task.isCompleted;
    // AppLogging.logInfo('Building content for task: ${task.id} with progress: $progress', name: 'TaskDetailsScreen');
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _buildAppBar(context, task, l10n),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMotivationalQuote(context, task, l10n),
                const SizedBox(height: 16),
                if (task.subtasks.isNotEmpty) _buildProgressCard(context, progress, task, l10n),
                const SizedBox(height: 16),
                _buildTaskDetails(context, task, l10n),
                const SizedBox(height: 16),
                _buildSubtasksSection(context, task, l10n),
                const SizedBox(height: 16),
                _buildPomodoroSection(context, task, l10n),
                const SizedBox(height: 16),
                _buildTimelineSection(context, task, l10n),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, Task task, AppLocalizations l10n) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Hero(
          tag: 'task_title_${task.id}',
          child: Text(
            task.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: _getPriorityColors(task.priority), begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Center(child: Icon(_getPriorityIcon(task.priority), size: 80, color: Colors.white.withValues(alpha: 0.3))),
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'focus':
                _startFocusMode(context, task);
                break;
              case 'edit':
                _editTask(context, task);
                break;
              case 'duplicate':
                _duplicateTask(context, task);
                break;
              case 'delete':
                _deleteTask(context, task, l10n);
                break;
              case 'close':
                Navigator.of(context).pop();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'focus',
              child: ListTile(leading: const Icon(Icons.center_focus_strong), title: Text(l10n.focusMode)),
            ),
            PopupMenuItem(
              value: 'edit',
              child: ListTile(leading: const Icon(Icons.edit), title: Text(l10n.editTaskButton)),
            ),
            PopupMenuItem(
              value: 'duplicate',
              child: ListTile(leading: const Icon(Icons.copy), title: Text(l10n.duplicateTask)),
            ),
            PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text(l10n.deleteTaskButton, style: const TextStyle(color: Colors.red)),
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'close',
              child: ListTile(leading: const Icon(Icons.close), title: Text(l10n.cancelButton)),
            ),
          ],
        ),
      ],
    );
  }

  var isCompleted;
  Widget _buildMotivationalQuote(BuildContext context, Task task, AppLocalizations l10n) {
    final quotes = [l10n.motivationalQuoteHigh, l10n.motivationalQuoteMedium, l10n.motivationalQuoteLow];
    final quote = quotes[task.priority.index];

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: isCompleted ? 0.5 : 1.0,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(colors: _getPriorityColors(task.priority).map((c) => c.withValues(alpha: 0.1)).toList()),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  quote,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                ),
              ),
              Lottie.asset(
                'assets/animations/motivation.json',
                width: 60,
                height: 60,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.emoji_emotions, size: 60, color: Theme.of(context).colorScheme.primary);
                },
              ),
            ],
          ),
        ),
      ).animate().fadeIn().slideY(begin: 0.2),
    );
  }

  Widget _buildProgressCard(BuildContext context, double progress, Task task, AppLocalizations l10n) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: isCompleted ? 0.5 : 1.0,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.taskProgress, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(value: progress * 100, title: '${(progress * 100).toInt()}%', color: Colors.green, radius: 60),
                      PieChartSectionData(value: (1 - progress) * 100, title: '${((1 - progress) * 100).toInt()}%', color: Colors.grey.shade300, radius: 60),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade300, valueColor: AlwaysStoppedAnimation<Color>(_getPriorityColors(task.priority)[0])),
              const SizedBox(height: 8),
              Text('${_getCompletedSubtasksCount(task)}/${_getTotalSubtasksCount(task)} ${l10n.subtasks}', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ).animate().fadeIn().slideY(begin: 0.1),
    );
  }

  Widget _buildTaskDetails(BuildContext context, Task task, AppLocalizations l10n) {
    AppLogging.logError(task.repeatRule!.getDisplayText(), name: 'TaskDetailsScreen');
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: isCompleted ? 0.5 : 1.0,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.taskDetails, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              if (task.description != null) ...[
                ExpansionTile(
                  title: Text(l10n.taskDescriptionLabel),
                  children: [Padding(padding: const EdgeInsets.all(16), child: Text(task.description!))],
                ),
                const SizedBox(height: 16),
              ],
              _buildDetailRow(Icons.calendar_today, l10n.dueDate, task.dueDate != null ? DateFormat.yMMMd().format(task.dueDate!) : l10n.noDueDate),
              _buildDetailRow(Icons.flag, l10n.priority, _getPriorityText(task.priority, l10n)),
              if (task.reminderIntervals.isNotEmpty) ...[_buildDetailRow(Icons.notifications, l10n.reminders, task.reminderIntervals.map((min) => '${min}m').join(', '))],
              if (task.repeatRule != null) ...[_buildDetailRow(Icons.repeat, l10n.repeat, task.repeatRule!.getDisplayText())],
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _setReminder(context, task, l10n),
                icon: const Icon(Icons.notifications_active),
                label: Text(task.reminderDate != null ? l10n.editButton : l10n.setReminderButton),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
              ),
            ],
          ),
        ),
      ).animate().fadeIn().slideY(begin: 0.05),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtasksSection(BuildContext context, Task task, AppLocalizations l10n) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: isCompleted ? 0.5 : 1.0,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.subtasks, style: Theme.of(context).textTheme.titleLarge),
                  IconButton(icon: const Icon(Icons.add), onPressed: isCompleted ? null : () => _addSubtask(context, task, l10n)),
                ],
              ),
              const SizedBox(height: 16),
              if (task.subtasks.isEmpty)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.checklist, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(l10n.noSubtasks),
                    ],
                  ),
                )
              else
                ReorderableColumn(
                  onReorder: (oldIndex, newIndex) => _reorderSubtasks(context, task, oldIndex, newIndex),
                  children: task.subtasks.map((subtask) {
                    return Slidable(
                      key: ValueKey(subtask.id),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(onPressed: (_) => _editSubtask(context, subtask, l10n), backgroundColor: Colors.blue, foregroundColor: Colors.white, icon: Icons.edit, label: l10n.editButton),
                          SlidableAction(onPressed: (_) => _deleteSubtask(context, subtask, l10n), backgroundColor: Colors.red, foregroundColor: Colors.white, icon: Icons.delete, label: l10n.deleteButton),
                        ],
                      ),
                      child: SubtaskWidget(
                        subtask: subtask,
                        depth: 0,
                        maxDepth: task.maxSubtaskDepth,
                        onToggle: (updated) => _toggleSubtask(context, updated),
                        onEdit: (sub) => context.read<TaskDetailsBloc>().add(UpdateSubtask(sub)),
                        onDelete: (id) => context.read<TaskDetailsBloc>().add(DeleteSubtask(id)),
                        onAddNested: (subtask) => context.read<TaskDetailsBloc>().add(AddSubtask(task.id, subtask)),
                        strictMode: task.strictCompletionMode,
                        isParentCompleted: task.isCompleted,
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ).animate().fadeIn().slideY(begin: 0.0),
    );
  }

  Widget _buildPomodoroSection(BuildContext context, Task task, AppLocalizations l10n) {
    //  AppLogging.logInfo('Building Pomodoro section for task: ${task.id}, isCompleted $isCompleted', name: 'TaskDetailsScreen');
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: isCompleted ? 0.5 : 1.0,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.pomodoroSessions, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              // Placeholder for Pomodoro stats - would integrate with Pomodoro service
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildPomodoroStat(l10n.sessions, '0'), _buildPomodoroStat(l10n.timeSpent, '0m'), _buildPomodoroStat(l10n.avgSession, '0m')]),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: isCompleted ? null : () => _startPomodoro(context, task),
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.startPomodoroSession),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              ),
            ],
          ),
        ),
      ).animate().fadeIn().slideY(begin: -0.05),
    );
  }

  Widget _buildPomodoroStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTimelineSection(BuildContext context, Task task, AppLocalizations l10n) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.timeline, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildTimelineItem(Icons.add, l10n.created, DateFormat.yMMMd().format(task.createdAt)),
            _buildTimelineItem(Icons.update, l10n.lastModified, DateFormat.yMMMd().format(task.updatedAt)),
            if (task.dueDate != null) _buildTimelineItem(Icons.event, l10n.dueDate, DateFormat.yMMMd().format(task.dueDate!)),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildTimelineItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(value, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context, AppLocalizations l10n) {
    return BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
      builder: (context, state) {
        if (state is TaskDetailsLoaded) {
          if (state.task.isCompleted) {
            return FloatingActionButton.extended(
              onPressed: () => _uncompleteTask(context, state.task),
              backgroundColor: Colors.orange,
              icon: const Icon(Icons.undo),
              label: Text(l10n.uncompleteTaskButton /* 'Uncomplete Task' */),
            ).animate(controller: _fabAnimationController, autoPlay: false).shake(duration: 500.ms, hz: 4);
          }
          final canComplete = state.canComplete;
          return FloatingActionButton.extended(
            onPressed: canComplete ? () => _completeTask(context, state.task) : null,
            backgroundColor: canComplete ? Colors.green : Colors.grey,
            icon: const Icon(Icons.check),
            label: Text(canComplete ? l10n.completeTaskButton : l10n.completeSubtasksFirst /* 'Complete All Subtasks First' */),
          ).animate(controller: _fabAnimationController, autoPlay: false).shake(duration: 500.ms, hz: 4);
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _startFocusMode(BuildContext context, Task task) {
    // Navigate to focus mode screen
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Focus mode for ${task.title}')));
  }

  void _editTask(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => EditTaskDialog(
        task: task,
        onTaskUpdated: (updatedTask) {
          context.read<TaskDetailsBloc>().add(UpdateTaskDetails(updatedTask));
        },
      ),
    );
  }

  void _duplicateTask(BuildContext context, Task task) {
    context.read<TaskDetailsBloc>().add(DuplicateTask(task.id));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task duplicated successfully')));
  }

  void _deleteTask(BuildContext context, Task task, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTaskConfirmationTitle),
        content: Text(l10n.confirmDeleteTask(task.title)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancelButton)),
          TextButton(
            onPressed: () {
              // Delete task logic
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.deleteButton),
          ),
        ],
      ),
    );
  }

  void _addSubtask(BuildContext context, Task task, AppLocalizations l10n) {
    AppLogging.logInfo('Opening add subtask dialog for task: ${task.id}', name: 'TaskDetailsScreen');
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: AddTaskDialog(
          onTaskAdded: (subtask) {
            try {
              AppLogging.logInfo('Adding subtask: ${subtask.title} to task: ${task.id}', name: 'TaskDetailsScreen');
              context.read<TaskDetailsBloc>().add(AddSubtask(task.id, subtask));
              AppLogging.logInfo('Subtask added successfully: ${subtask.id}', name: 'TaskDetailsScreen');
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Subtask added successfully')));
            } catch (e, stackTrace) {
              AppLogging.logError('Error adding subtask: $e', name: 'TaskDetailsScreen', error: e, stackTrace: stackTrace);
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add subtask: $e'), backgroundColor: Colors.red));
            }
          },
          isSubtask: true,
        ),
      ),
    );
  }

  void _toggleSubtask(BuildContext context, Task subtask) {
    context.read<TaskDetailsBloc>().add(UpdateSubtask(subtask));
    HapticFeedback.lightImpact();
  }

  void _editSubtask(BuildContext context, Task subtask, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => EditTaskDialog(
        task: subtask,
        onTaskUpdated: (updatedSubtask) {
          context.read<TaskDetailsBloc>().add(UpdateSubtask(updatedSubtask));
        },
      ),
    );
  }

  void _deleteSubtask(BuildContext context, Task subtask, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteSubtask),
        content: Text(l10n.confirmDeleteSubtask),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancelButton)),
          TextButton(
            onPressed: () {
              context.read<TaskDetailsBloc>().add(DeleteSubtask(subtask.id));
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.deleteButton),
          ),
        ],
      ),
    );
  }

  void _reorderSubtasks(BuildContext context, Task task, int oldIndex, int newIndex) {
    final subtasks = List<Task>.from(task.subtasks);
    final item = subtasks.removeAt(oldIndex);
    subtasks.insert(newIndex, item);
    context.read<TaskDetailsBloc>().add(ReorderSubtasks(task.id, subtasks));
  }

  void _startPomodoro(BuildContext context, Task task) {
    // Navigate to Pomodoro screen with task pre-selected
    Navigator.push(context, MaterialPageRoute(builder: (context) => PomodoroScreen(initialTask: task)));
  }

  void _completeTask(BuildContext context, Task task) {
    context.read<TaskDetailsBloc>().add(CompleteTask(task.id));
    _confettiController.play();
    HapticFeedback.heavyImpact();
  }

  void _uncompleteTask(BuildContext context, Task task) {
    context.read<TaskDetailsBloc>().add(UncompleteTask(task.id));
    HapticFeedback.mediumImpact();
  }

  List<Color> _getPriorityColors(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return [Colors.red, Colors.amberAccent];
      case TaskPriority.medium:
        return [Colors.orange, Colors.orangeAccent];
      case TaskPriority.low:
        return [Colors.green, Colors.greenAccent];
    }
  }

  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Icons.flag;
      case TaskPriority.medium:
        return Icons.flag_outlined;
      case TaskPriority.low:
        return Icons.outlined_flag;
    }
  }

  String _getPriorityText(TaskPriority priority, AppLocalizations l10n) {
    switch (priority) {
      case TaskPriority.high:
        return l10n.highPriority;
      case TaskPriority.medium:
        return l10n.mediumPriority;
      case TaskPriority.low:
        return l10n.lowPriority;
    }
  }

  int _getCompletedSubtasksCount(Task task) {
    int count = 0;
    void countCompleted(Task t) {
      if (t.isCompleted) count++;
      for (var s in t.subtasks) {
        countCompleted(s);
      }
    }

    for (var s in task.subtasks) {
      countCompleted(s);
    }
    return count;
  }

  int _getTotalSubtasksCount(Task task) {
    int count = 0;
    void countTotal(Task t) {
      count++;
      for (var s in t.subtasks) {
        countTotal(s);
      }
    }

    for (var s in task.subtasks) {
      countTotal(s);
    }
    return count;
  }

  void _setReminder(BuildContext context, Task task, AppLocalizations l10n) async {
    final DateTime? pickedDate = await showDatePicker(context: context, initialDate: task.reminderDate ?? DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(task.reminderDate ?? DateTime.now().add(Duration(minutes: 1))));

      if (pickedTime != null) {
        final DateTime reminderDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);

        final updatedTask = task.copyWith(reminderDate: reminderDate);
        context.read<TaskDetailsBloc>().add(UpdateTaskDetails(updatedTask));

        // Schedule the notification
        await NotificationService().scheduleTaskReminder(updatedTask);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reminder set for ${DateFormat.yMMMd().add_jm().format(reminderDate)}')));
      }
    }
  }
}
