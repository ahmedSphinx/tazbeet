import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';
import '../../models/task.dart';
import '../../blocs/task_details/task_details_bloc.dart';
import '../../blocs/task_details/task_details_event.dart';

class ReminderStatusWidget extends StatelessWidget {
  final Task task;
  final AppLocalizations l10n;

  const ReminderStatusWidget({super.key, required this.task, required this.l10n});

  @override
  Widget build(BuildContext context) {
    if (task.reminderDate == null) {
      return _buildNoReminderCard(context);
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getStatusIcon(), color: _getStatusColor(), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.reminderStatus, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      Text(_getStatusText(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: _getStatusColor())),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildReminderDetails(context),
            if (task.reminderFailureReason != null) ...[const SizedBox(height: 8), _buildFailureReason(context)],
            if (task.reminderRetryCount > 0) ...[const SizedBox(height: 8), _buildRetryInfo(context)],
          ],
        ),
      ),
    );
  }

  Widget _buildNoReminderCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.notifications_off_outlined, color: Colors.grey, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.reminderStatus, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  Text(l10n.noReminderSet, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => _setDefaultReminder(context),
              icon: const Icon(Icons.add, size: 16),
              label: Text(l10n.setSmartReminder),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text('${l10n.scheduledFor}: ${DateFormat.yMMMd().add_jm().format(task.reminderDate!)}', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          if (task.reminderLastAttempt != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.history, size: 16, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                const SizedBox(width: 8),
                Text(
                  '${l10n.lastAttempt}: ${DateFormat.yMMMd().add_jm().format(task.reminderLastAttempt!)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFailureReason(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 16, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text('${l10n.failureReason}: ${task.reminderFailureReason!}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildRetryInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.refresh, size: 16, color: Colors.orange),
          const SizedBox(width: 8),
          Text('${l10n.retryAttempts}: ${task.reminderRetryCount}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.orange)),
          const SizedBox(width: 8),
          if (task.reminderState != ReminderState.failed)
            TextButton.icon(
              onPressed: () => _retryReminder(context),
              icon: const Icon(Icons.refresh, size: 14),
              label: Text(l10n.retryNow),
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            ),
        ],
      ),
    );
  }

  IconData _getStatusIcon() {
    switch (task.reminderState) {
      case ReminderState.none:
        return Icons.notifications_off_outlined;
      case ReminderState.scheduled:
        return Icons.schedule;
      case ReminderState.delivered:
        return Icons.notifications_active;
      case ReminderState.failed:
        return Icons.error_outline;
      case ReminderState.cancelled:
        return Icons.cancel_outlined;
    }
  }

  Color _getStatusColor() {
    switch (task.reminderState) {
      case ReminderState.none:
        return Colors.grey;
      case ReminderState.scheduled:
        return Colors.blue;
      case ReminderState.delivered:
        return Colors.green;
      case ReminderState.failed:
        return Colors.red;
      case ReminderState.cancelled:
        return Colors.orange;
    }
  }

  String _getStatusText() {
    switch (task.reminderState) {
      case ReminderState.none:
        return l10n.noReminder;
      case ReminderState.scheduled:
        return l10n.scheduled;
      case ReminderState.delivered:
        return l10n.delivered;
      case ReminderState.failed:
        return l10n.failed;
      case ReminderState.cancelled:
        return l10n.cancelled;
    }
  }

  void _setDefaultReminder(BuildContext context) {
    final defaultReminder = task.defaultReminderDate;

    if (defaultReminder != null) {
      final updatedTask = task.copyWith(reminderDate: defaultReminder);
      context.read<TaskDetailsBloc>().add(UpdateTaskDetails(updatedTask));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.smartReminderSet), backgroundColor: Colors.green));
    }
  }

  void _retryReminder(BuildContext context) {
    final updatedTask = task.copyWith(reminderState: ReminderState.scheduled, reminderFailureReason: null);
    context.read<TaskDetailsBloc>().add(UpdateTaskDetails(updatedTask));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.reminderRetryScheduled), backgroundColor: Colors.blue));
  }
}
