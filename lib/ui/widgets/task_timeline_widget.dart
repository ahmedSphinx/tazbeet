import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import '../../models/task.dart';
import '../../services/app_logging_service.dart';

class TaskTimelineWidget extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task)? onTaskTap;
  final Function(Task)? onTaskComplete;
  final Function(Task)? onTaskEdit;
  final bool showFocusModeInfo;
  final int? maxItems;

  const TaskTimelineWidget({super.key, required this.tasks, this.onTaskTap, this.onTaskComplete, this.onTaskEdit, this.showFocusModeInfo = true, this.maxItems});

  @override
  State<TaskTimelineWidget> createState() => _TaskTimelineWidgetState();
}

class _TaskTimelineWidgetState extends State<TaskTimelineWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final displayTasks = widget.maxItems != null ? widget.tasks.take(widget.maxItems!).toList() : widget.tasks;

    if (displayTasks.isEmpty) {
      return _buildEmptyState(l10n);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(l10n),
          const SizedBox(height: 16),
          _buildTimeline(displayTasks),
          if (widget.maxItems != null && widget.tasks.length > widget.maxItems!) ...[const SizedBox(height: 16), _buildShowMoreButton(l10n)],
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timeline_outlined, size: 64, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('No task history', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: 8),
          Text('Tasks will appear here as you work on them', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4))),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Row(
      children: [
        Icon(Icons.timeline, color: Theme.of(context).colorScheme.primary, size: 24),
        const SizedBox(width: 12),
        Text(
          'Task Timeline',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
        ),
        const Spacer(),
        Text('${widget.tasks.length} tasks', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
      ],
    );
  }

  Widget _buildTimeline(List<Task> tasks) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: tasks.asMap().entries.map((entry) {
            final index = entry.key;
            final task = entry.value;
            return _buildTimelineItem(task, index, tasks.length);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(Task task, int index, int totalTasks) {
    final isLast = index == totalTasks - 1;
    final isCompleted = task.isCompleted;
    final hasFocusMode = widget.showFocusModeInfo && task.estimatedSessions > 0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line and dot
          _buildTimelineIndicator(isCompleted, isLast, hasFocusMode),

          // Task content
          Expanded(child: _buildTaskCard(task, isCompleted, hasFocusMode)),

          // Actions
          _buildTaskActions(task, isCompleted),
        ],
      ),
    );
  }

  Widget _buildTimelineIndicator(bool isCompleted, bool isLast, bool hasFocusMode) {
    return Column(
      children: [
        // Dot
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? Colors.green
                : hasFocusMode
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            border: Border.all(
              color: isCompleted
                  ? Colors.green
                  : hasFocusMode
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
              width: 2,
            ),
          ),
        ),

        // Line
        if (!isLast)
          Expanded(
            child: Container(
              width: 2,
              height: 60,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    isCompleted
                        ? Colors.green.withValues(alpha: 0.3)
                        : hasFocusMode
                        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                        : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTaskCard(Task task, bool isCompleted, bool hasFocusMode) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 8, bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green.withValues(alpha: 0.05)
            : hasFocusMode
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? Colors.green.withValues(alpha: 0.2)
              : hasFocusMode
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task title
          Text(
            task.title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, decoration: isCompleted ? TextDecoration.lineThrough : null, color: isCompleted ? Colors.green.withValues(alpha: 0.7) : null),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // Task metadata
          Row(
            children: [
              // Priority
              _buildPriorityChip(task.priority),

              const SizedBox(width: 8),

              // Due date
              if (task.dueDate != null) ...[_buildDueDateChip(task.dueDate!), const SizedBox(width: 8)],

              // Focus mode info
              if (hasFocusMode) ...[_buildFocusModeChip(task)],
            ],
          ),

          // Progress (if has subtasks)
          if (task.subtasks.isNotEmpty) ...[const SizedBox(height: 12), _buildProgressBar(task)],

          // Tags
          if (task.tags.isNotEmpty) ...[const SizedBox(height: 12), _buildTagsRow(task.tags)],
        ],
      ),
    );
  }

  Widget _buildPriorityChip(TaskPriority priority) {
    Color color;
    String label;

    switch (priority) {
      case TaskPriority.high:
        color = Colors.red;
        label = 'High';
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        label = 'Medium';
        break;
      case TaskPriority.low:
        color = Colors.blue;
        label = 'Low';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  Widget _buildDueDateChip(DateTime dueDate) {
    final now = DateTime.now();
    final isOverdue = dueDate.isBefore(now);
    final isToday = dueDate.year == now.year && dueDate.month == now.month && dueDate.day == now.day;
    final isTomorrow = dueDate.year == now.year && dueDate.month == now.month && dueDate.day == now.day + 1;

    Color color;
    String label;

    if (isOverdue) {
      color = Colors.red;
      label = 'Overdue';
    } else if (isToday) {
      color = Colors.orange;
      label = 'Today';
    } else if (isTomorrow) {
      color = Colors.blue;
      label = 'Tomorrow';
    } else {
      color = Colors.grey;
      label = '${dueDate.day}/${dueDate.month}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  Widget _buildFocusModeChip(Task task) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 12, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            '${task.pomodoroCount}/${task.estimatedSessions}',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(Task task) {
    final progress = task.getCompletionProgress();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Progress', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
            Text(
              '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 4,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(2)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsRow(List<String> tags) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: tags.take(3).map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiaryContainer, borderRadius: BorderRadius.circular(6)),
          child: Text(tag, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onTertiaryContainer, fontSize: 10)),
        );
      }).toList(),
    );
  }

  Widget _buildTaskActions(Task task, bool isCompleted) {
    return Column(
      children: [
        if (!isCompleted)
          IconButton(
            icon: Icon(Icons.check_circle_outline, size: 20),
            onPressed: () {
              HapticFeedback.lightImpact();
              widget.onTaskComplete?.call(task);
            },
            tooltip: 'Complete Task',
          ),
        if (isCompleted)
          IconButton(
            icon: Icon(Icons.undo, size: 20),
            onPressed: () {
              HapticFeedback.lightImpact();
              widget.onTaskComplete?.call(task);
            },
            tooltip: 'Uncomplete Task',
          ),
        IconButton(
          icon: Icon(Icons.edit_outlined, size: 20),
          onPressed: () {
            HapticFeedback.lightImpact();
            widget.onTaskEdit?.call(task);
          },
          tooltip: 'Edit Task',
        ),
      ],
    );
  }

  Widget _buildShowMoreButton(AppLocalizations l10n) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          HapticFeedback.lightImpact();
          // Navigate to full timeline or show more items
        },
        icon: const Icon(Icons.expand_more),
        label: Text('Show ${widget.tasks.length - widget.maxItems!} More Tasks'),
        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white),
      ),
    );
  }
}
