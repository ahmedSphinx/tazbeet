import 'package:flutter/material.dart';
import '../../models/notification_item.dart';

/// Preview card showing how a notification will appear
class NotificationPreviewCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback? onTest;

  const NotificationPreviewCard({super.key, required this.notification, this.onTest});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(_getTypeIcon(notification.type), color: _getTypeColor(notification.type)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Notification Preview', style: theme.textTheme.labelSmall),
                      Text(_getTypeLabel(notification.type), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                _buildPriorityBadge(notification.priority, theme),
              ],
            ),
          ),

          // Notification Content
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Icon and Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.check_circle, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tazbeet', style: theme.textTheme.labelSmall),
                          Text(notification.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Text('now', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline)),
                  ],
                ),

                const SizedBox(height: 8),

                // Body
                Text(notification.body, style: theme.textTheme.bodyMedium),

                // Action Buttons
                if (notification.actionButtons.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: notification.actionButtons.map((action) {
                      return OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), minimumSize: Size.zero),
                        child: Text(action, style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),

          // Footer with Test Button
          if (onTest != null)
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onTest,
                  icon: const Icon(Icons.send),
                  label: const Text('Send Test Notification'),
                  style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary, foregroundColor: theme.colorScheme.onPrimary),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(NotificationPriority priority, ThemeData theme) {
    Color color;
    String label;

    switch (priority) {
      case NotificationPriority.urgent:
        color = Colors.red;
        label = 'URGENT';
        break;
      case NotificationPriority.high:
        color = Colors.orange;
        label = 'HIGH';
        break;
      case NotificationPriority.medium:
        color = Colors.blue;
        label = 'MEDIUM';
        break;
      case NotificationPriority.low:
        color = Colors.grey;
        label = 'LOW';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.taskReminder:
        return 'Task Reminder';
      case NotificationType.taskDue:
        return 'Task Due';
      case NotificationType.taskCompleted:
        return 'Task Completed';
      case NotificationType.moodCheckIn:
        return 'Mood Check-In';
      case NotificationType.pomodoroWork:
        return 'Pomodoro Work';
      case NotificationType.pomodoroBreak:
        return 'Pomodoro Break';
      case NotificationType.pomodoroComplete:
        return 'Pomodoro Complete';
      case NotificationType.emergency:
        return 'Emergency Alert';
      case NotificationType.system:
        return 'System Notification';
      case NotificationType.userSignup:
        return 'New User Signup';
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.taskReminder:
        return Icons.task_alt;
      case NotificationType.taskDue:
        return Icons.alarm;
      case NotificationType.taskCompleted:
        return Icons.check_circle;
      case NotificationType.moodCheckIn:
        return Icons.mood;
      case NotificationType.pomodoroWork:
        return Icons.work;
      case NotificationType.pomodoroBreak:
        return Icons.coffee;
      case NotificationType.pomodoroComplete:
        return Icons.done_all;
      case NotificationType.emergency:
        return Icons.warning;
      case NotificationType.system:
        return Icons.settings;
      case NotificationType.userSignup:
        return Icons.person_add;
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.taskReminder:
        return Colors.blue;
      case NotificationType.taskDue:
        return Colors.orange;
      case NotificationType.taskCompleted:
        return Colors.green;
      case NotificationType.moodCheckIn:
        return Colors.purple;
      case NotificationType.pomodoroWork:
        return Colors.red;
      case NotificationType.pomodoroBreak:
        return Colors.teal;
      case NotificationType.pomodoroComplete:
        return Colors.green;
      case NotificationType.emergency:
        return Colors.red;
      case NotificationType.system:
        return Colors.grey;
      case NotificationType.userSignup:
        return Colors.indigo;
    }
  }
}
