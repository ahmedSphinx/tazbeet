import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Timeline event data class
class TimelineEvent {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final TimelineEventType type;
  final IconData icon;
  final Color color;
  final Map<String, dynamic>? metadata;

  const TimelineEvent({required this.id, required this.title, required this.description, required this.timestamp, required this.type, required this.icon, required this.color, this.metadata});
}

/// Types of timeline events
enum TimelineEventType { created, updated, completed, uncompleted, subtaskAdded, subtaskCompleted, reminderSet, pomodoroStarted, pomodoroCompleted, priorityChanged, dueDateSet, attachment, comment }

/// Visual progress timeline widget
class ProgressTimeline extends StatelessWidget {
  final List<TimelineEvent> events;
  final bool showDates;
  final bool isCompact;
  final double itemSpacing;
  final EdgeInsetsGeometry padding;

  const ProgressTimeline({super.key, required this.events, this.showDates = true, this.isCompact = false, this.itemSpacing = 16.0, this.padding = const EdgeInsets.all(16.0)});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return _buildEmptyTimeline(context);
    }

    return Container(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.timeline, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text('Progress Timeline', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),

          // Timeline items
          ...events.asMap().entries.map((entry) {
            final index = entry.key;
            final event = entry.value;
            final isLast = index == events.length - 1;

            return _buildTimelineItem(context, event, isLast: isLast, isFirst: index == 0);
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyTimeline(BuildContext context) {
    return Container(
      padding: padding,
      child: Column(
        children: [
          Icon(Icons.timeline, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('No timeline events yet', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text(
            'Task events will appear here as you work',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, TimelineEvent event, {required bool isLast, required bool isFirst}) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : itemSpacing),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            Column(
              children: [
                // Event icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: event.color,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: event.color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Icon(event.icon, color: Colors.white, size: 20),
                ),

                // Connecting line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [event.color.withValues(alpha: 0.5), Colors.grey.withValues(alpha: 0.3)]),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 16),

            // Event content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event header
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: event.color),
                          ),
                        ),
                        if (showDates) Text(_formatTimestamp(event.timestamp), style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                      ],
                    ),

                    if (event.description.isNotEmpty) ...[const SizedBox(height: 8), Text(event.description, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700], height: 1.4))],

                    // Metadata
                    if (event.metadata != null && event.metadata!.isNotEmpty) _buildEventMetadata(context, event),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventMetadata(BuildContext context, TimelineEvent event) {
    final metadata = event.metadata!;
    final widgets = <Widget>[];

    // Duration for Pomodoro sessions
    if (metadata.containsKey('duration')) {
      widgets.add(_buildMetadataChip(context, Icons.timer, '${metadata['duration']} min', Colors.orange));
    }

    // Progress percentage
    if (metadata.containsKey('progress')) {
      widgets.add(_buildMetadataChip(context, Icons.trending_up, '${metadata['progress']}%', Colors.green));
    }

    // Priority level
    if (metadata.containsKey('priority')) {
      widgets.add(_buildMetadataChip(context, Icons.flag, metadata['priority'], _getPriorityColor(metadata['priority'])));
    }

    // Subtask count
    if (metadata.containsKey('subtaskCount')) {
      widgets.add(_buildMetadataChip(context, Icons.checklist, '${metadata['subtaskCount']} subtasks', Colors.blue));
    }

    if (widgets.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Wrap(spacing: 8, runSpacing: 4, children: widgets),
    );
  }

  Widget _buildMetadataChip(BuildContext context, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat.MMMd().format(timestamp);
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

/// Helper class for creating timeline events from task data
class TaskTimelineBuilder {
  /// Creates timeline events from a task's history
  static List<TimelineEvent> fromTask(dynamic task) {
    final events = <TimelineEvent>[];

    // Task creation
    events.add(TimelineEvent(id: 'created_${task.id}', title: 'Task Created', description: 'Task "${task.title}" was created', timestamp: task.createdAt, type: TimelineEventType.created, icon: Icons.add_circle, color: Colors.blue, metadata: {'priority': task.priority.toString().split('.').last}));

    // Task updates (if updatedAt is different from createdAt)
    if (task.updatedAt.isAfter(task.createdAt.add(const Duration(seconds: 1)))) {
      events.add(TimelineEvent(id: 'updated_${task.id}', title: 'Task Updated', description: 'Task details were modified', timestamp: task.updatedAt, type: TimelineEventType.updated, icon: Icons.edit, color: Colors.orange));
    }

    // Subtask events
    for (final subtask in task.subtasks) {
      events.add(TimelineEvent(id: 'subtask_added_${subtask.id}', title: 'Subtask Added', description: 'Added subtask: ${subtask.title}', timestamp: subtask.createdAt, type: TimelineEventType.subtaskAdded, icon: Icons.add_task, color: Colors.teal));

      if (subtask.isCompleted) {
        events.add(TimelineEvent(id: 'subtask_completed_${subtask.id}', title: 'Subtask Completed', description: 'Completed: ${subtask.title}', timestamp: subtask.updatedAt, type: TimelineEventType.subtaskCompleted, icon: Icons.check_circle, color: Colors.green));
      }
    }

    // Pomodoro sessions
    for (int i = 0; i < task.pomodoroSessions.length; i++) {
      final session = task.pomodoroSessions[i];
      final duration = session['duration'] ?? 25;
      final completed = session['completed'] ?? true;

      events.add(
        TimelineEvent(
          id: 'pomodoro_${task.id}_$i',
          title: completed ? 'Focus Session Completed' : 'Focus Session Started',
          description: completed ? 'Completed a $duration-minute focus session' : 'Started a focus session',
          timestamp: DateTime.now().subtract(Duration(days: task.pomodoroSessions.length - i)),
          type: completed ? TimelineEventType.pomodoroCompleted : TimelineEventType.pomodoroStarted,
          icon: completed ? Icons.timer_off : Icons.timer,
          color: completed ? Colors.green : Colors.purple,
          metadata: {'duration': duration},
        ),
      );
    }

    // Due date set
    if (task.dueDate != null) {
      events.add(
        TimelineEvent(
          id: 'due_date_${task.id}',
          title: 'Due Date Set',
          description: 'Due date set to ${DateFormat.yMMMd().add_jm().format(task.dueDate!)}',
          timestamp: task.createdAt.add(const Duration(minutes: 5)), // Approximate
          type: TimelineEventType.dueDateSet,
          icon: Icons.schedule,
          color: Colors.amber,
        ),
      );
    }

    // Reminder set
    if (task.reminderDate != null) {
      events.add(TimelineEvent(id: 'reminder_${task.id}', title: 'Reminder Set', description: 'Reminder scheduled for ${DateFormat.yMMMd().add_jm().format(task.reminderDate!)}', timestamp: task.updatedAt, type: TimelineEventType.reminderSet, icon: Icons.notifications, color: Colors.amber));
    }

    // Task completion
    if (task.isCompleted) {
      events.add(TimelineEvent(id: 'completed_${task.id}', title: 'Task Completed! 🎉', description: 'Great job! Task was marked as complete', timestamp: task.updatedAt, type: TimelineEventType.completed, icon: Icons.celebration, color: Colors.green, metadata: {'progress': 100, 'subtaskCount': task.subtasks.length}));
    }

    // Sort events by timestamp (newest first for timeline display)
    events.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return events;
  }

  /// Creates a progress summary from timeline events
  static Map<String, dynamic> getProgressSummary(List<TimelineEvent> events) {
    final summary = <String, dynamic>{'totalEvents': events.length, 'completedSubtasks': 0, 'pomodoroSessions': 0, 'lastActivity': null, 'milestones': <String>[]};

    for (final event in events) {
      // Count completed subtasks
      if (event.type == TimelineEventType.subtaskCompleted) {
        summary['completedSubtasks']++;
      }

      // Count Pomodoro sessions
      if (event.type == TimelineEventType.pomodoroCompleted) {
        summary['pomodoroSessions']++;
      }

      // Track last activity
      if (summary['lastActivity'] == null || event.timestamp.isAfter(summary['lastActivity'])) {
        summary['lastActivity'] = event.timestamp;
      }

      // Identify milestones
      if (event.type == TimelineEventType.completed) {
        summary['milestones'].add('Task Completed');
      }
    }

    return summary;
  }
}
