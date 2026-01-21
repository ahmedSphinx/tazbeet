import 'package:tazbeet/services/app_logging_service.dart';

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
import 'home/pomodoro/pomodoro_screen.dart';
import 'home/pomodoro/pomodoro_template_screen.dart';

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
    return RefreshIndicator(
      onRefresh: () async {
        // Trigger refresh by reloading task details
        context.read<TaskDetailsBloc>().add(LoadTaskDetails(widget.taskId));
        AppLogging.logInfo('TaskDetailsScreen: Manual refresh triggered for task ${widget.taskId}', name: 'TaskDetailsRefresh');
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(), // Enable pull-to-refresh
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
                  _buildTaskPath(context, task, l10n),
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
      ),
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

  // ignore: prefer_typing_uninitialized_variables
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
    // AppLogging.logError(task.repeatRule!.getDisplayText(), name: 'TaskDetailsScreen');
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
              _buildDetailRow(Icons.calendar_today, AppLocalizations.of(context)!.dueDateTitle, task.dueDate != null ? DateFormat.yMMMd().format(task.dueDate!) : AppLocalizations.of(context)!.noDueDate),
              _buildDetailRow(Icons.flag, AppLocalizations.of(context)!.priorityTitle, _getPriorityText(task.priority, l10n)),
              if (task.reminderIntervals.isNotEmpty) ...[_buildDetailRow(Icons.notifications, AppLocalizations.of(context)!.reminders, task.reminderIntervals.map((min) => '${min}m').join(', '))],
              if (task.repeatRule != null) ...[_buildDetailRow(Icons.repeat, AppLocalizations.of(context)!.repeat, task.repeatRule!.getDisplayText())],
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

  Widget _buildTaskPath(BuildContext context, Task task, AppLocalizations l10n) {
    // Only show path if this is a subtask (has parentId)
    if (task.parentId == null) {
      return const SizedBox.shrink();
    }

    // Get the root task from the bloc state
    final currentState = context.read<TaskDetailsBloc>().state;
    Task? rootTask;

    if (currentState is TaskDetailsLoaded) {
      rootTask = currentState.task;
    }

    final path = Task.getTaskPath(task, rootTask);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.taskPath,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: path.asMap().entries.map((entry) {
                  final index = entry.key;
                  final title = entry.value;
                  final isLast = index == path.length - 1;

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (index > 0) ...[Icon(Icons.chevron_right, size: 16, color: Colors.grey[400]), const SizedBox(width: 4)],
                      Flexible(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isLast ? Theme.of(context).colorScheme.primary : Colors.grey[700], fontWeight: isLast ? FontWeight.w600 : FontWeight.normal),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
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
                  Text(l10n.pomodoroSessions, style: Theme.of(context).textTheme.titleLarge),
                  if (task.pomodoroCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        '${task.pomodoroCount} sessions',
                        style: TextStyle(fontSize: 12, color: Colors.blue.shade600, fontWeight: FontWeight.w500),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Enhanced Pomodoro Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPomodoroStat(l10n.sessions, '${task.pomodoroCount}', Icons.timer_outlined, Colors.blue),
                  _buildPomodoroStat(l10n.timeSpent, '${_formatDuration(task.timeSpent)}', Icons.schedule, Colors.green),
                  _buildPomodoroStat(l10n.avgSession, '${_calculateAverageSession(task)}', Icons.trending_up, Colors.orange),
                ],
              ),

              // Progress Bar
              if (task.estimatedSessions > 0) ...[
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Progress', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        Text('${((task.pomodoroCount / task.estimatedSessions) * 100).round()}%', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (task.pomodoroCount / task.estimatedSessions).clamp(0.0, 1.0),
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                      minHeight: 8,
                    ),
                    const SizedBox(height: 4),
                    Text('${task.pomodoroCount} of ${task.estimatedSessions} estimated sessions', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
              ],

              // Session History
              if (task.pomodoroSessions.isNotEmpty) ...[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Session History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    TextButton(
                      onPressed: () => _showAllSessions(context, task),
                      child: Text('View All (${task.pomodoroSessions.length})', style: TextStyle(fontSize: 12, color: Colors.blue.shade600)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(height: 200, child: _buildSessionsChart(task)),
                const SizedBox(height: 12),
                // Recent sessions list
                _buildRecentSessionsList(task),
              ],

              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: isCompleted ? null : () => _startPomodoro(context, task),
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.startPomodoroSession),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48), backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      ).animate().fadeIn().slideY(begin: -0.05),
    );
  }

  Widget _buildPomodoroStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  // Helper methods for Pomodoro section
  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  String _calculateAverageSession(Task task) {
    if (task.pomodoroCount == 0) return '0m';
    final avgMinutes = task.timeSpent.inMinutes / task.pomodoroCount;
    return '${avgMinutes.round()}m';
  }

  Widget _buildSessionsChart(Task task) {
    if (task.pomodoroSessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text('No sessions yet', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }

    // Take last 10 sessions for the chart
    final recentSessions = task.pomodoroSessions.take(10).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < recentSessions.length) {
                  return Text('S${value.toInt() + 1}', style: TextStyle(fontSize: 10, color: Colors.grey[600]));
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: recentSessions.asMap().entries.map((entry) {
              final session = entry.value;
              final duration = session['duration'] as int? ?? 25; // Default 25 minutes
              return FlSpot(entry.key.toDouble(), duration.toDouble());
            }).toList(),
            isCurved: true,
            color: Colors.blue.shade600,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(radius: 4, color: Colors.blue.shade600, strokeWidth: 2, strokeColor: Colors.white);
              },
            ),
            belowBarData: BarAreaData(show: true, color: Colors.blue.shade100),
          ),
        ],
        minY: 0,
      ),
    );
  }

  Widget _buildRecentSessionsList(Task task) {
    final recentSessions = task.pomodoroSessions.take(3).toList();

    return Column(
      children: recentSessions.asMap().entries.map((entry) {
        final session = entry.value;
        final startTime = session['startTime'] as String?;
        final duration = session['duration'] as int? ?? 25;
        final completed = session['completed'] as bool? ?? true;

        DateTime? sessionDate;
        if (startTime != null) {
          try {
            sessionDate = DateTime.parse(startTime);
          } catch (e) {
            sessionDate = null;
          }
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: completed ? Colors.green.shade50 : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: completed ? Colors.green.shade200 : Colors.orange.shade200, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: completed ? Colors.green : Colors.orange, shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${duration} minute session',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: completed ? Colors.green.shade800 : Colors.orange.shade800),
                    ),
                    if (sessionDate != null) Text(_formatSessionDate(sessionDate), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
              Icon(completed ? Icons.check_circle : Icons.timer, size: 16, color: completed ? Colors.green : Colors.orange),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatSessionDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today at ${DateFormat.jm().format(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${DateFormat.jm().format(date)}';
    } else if (difference.inDays < 7) {
      return '${DateFormat.E().format(date)} at ${DateFormat.jm().format(date)}';
    } else {
      return DateFormat.yMMMd().add_jm().format(date);
    }
  }

  void _showAllSessions(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('All Sessions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: task.pomodoroSessions.length,
                  itemBuilder: (context, index) {
                    final session = task.pomodoroSessions[task.pomodoroSessions.length - 1 - index];
                    return _buildDetailedSessionItem(session, task);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedSessionItem(Map<String, dynamic> session, Task task) {
    final startTime = session['startTime'] as String?;
    final duration = session['duration'] as int? ?? 25;
    final completed = session['completed'] as bool? ?? true;
    final notes = session['notes'] as String?;

    DateTime? sessionDate;
    if (startTime != null) {
      try {
        sessionDate = DateTime.parse(startTime);
      } catch (e) {
        sessionDate = null;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(completed ? Icons.check_circle : Icons.timer, color: completed ? Colors.green : Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Text('${duration} minute session', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
                if (sessionDate != null) Text(DateFormat.yMMMd().add_jm().format(sessionDate), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
            if (notes != null && notes.isNotEmpty) ...[const SizedBox(height: 8), Text(notes, style: TextStyle(fontSize: 14, color: Colors.grey[700]))],
            const SizedBox(height: 8),
            Row(children: [_buildSessionTag('Session ${task.pomodoroSessions.indexOf(session) + 1}'), const SizedBox(width: 8), _buildSessionTag(completed ? 'Completed' : 'Incomplete')]),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
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
            _buildTimelineItem(Icons.add, AppLocalizations.of(context)!.created, DateFormat.yMMMd().format(task.createdAt)),
            _buildTimelineItem(Icons.update, AppLocalizations.of(context)!.lastModified, DateFormat.yMMMd().format(task.updatedAt)),
            if (task.dueDate != null) _buildTimelineItem(Icons.event, AppLocalizations.of(context)!.dueDateTitle, DateFormat.yMMMd().format(task.dueDate!)),
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.taskDuplicatedSuccessfully)));
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
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.subtaskAddedSuccessfully)));
            } catch (e, stackTrace) {
              AppLogging.logError('Error adding subtask: $e', name: 'TaskDetailsScreen', error: e, stackTrace: stackTrace);
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.error}: $e'), backgroundColor: Colors.red));
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

  void _startPomodoro(BuildContext context, Task task) async {
    // Show template selection modal and wait for result
    final template = await PomodoroTemplateScreen.showAsModal(context, initialTask: task);

    // If user selected a template, launch Pomodoro screen with both task and template
    if (template != null) {
      HapticFeedback.mediumImpact();
      PomodoroScreen.showAsPage(context, initialTask: task, template: template);
    }
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
    // Check notification permissions first
    final notificationService = NotificationService();
    final hasPermission = await notificationService.hasNotificationPermission();

    if (!hasPermission) {
      final shouldRequest = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.notificationPermissionRequired),
          content: Text(l10n.notificationPermissionMessage),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancelButton)),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.grantPermission)),
          ],
        ),
      );

      if (shouldRequest == true) {
        final granted = await notificationService.requestNotificationPermission();
        if (!granted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.cannotSetReminderWithoutPermission)));
          return;
        }
      } else {
        return;
      }
    }

    final DateTime? pickedDate = await showDatePicker(context: context, initialDate: task.reminderDate ?? DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(task.reminderDate ?? DateTime.now().add(Duration(minutes: 1))));

      if (pickedTime != null) {
        final DateTime reminderDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);

        final updatedTask = task.copyWith(reminderDate: reminderDate);
        context.read<TaskDetailsBloc>().add(UpdateTaskDetails(updatedTask));

        // Schedule the notification
        await notificationService.scheduleTaskReminder(updatedTask);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reminder set for ${DateFormat.yMMMd().add_jm().format(reminderDate)}')));
      }
    }
  }
}
