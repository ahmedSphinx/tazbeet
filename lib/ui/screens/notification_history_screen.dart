import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import '../../blocs/notification/notification_bloc.dart';
import '../../blocs/notification/notification_event.dart';
import '../../blocs/notification/notification_state.dart';
import '../../models/notification_item.dart';

/// Screen displaying notification history with timeline, filters, and analytics
class NotificationHistoryScreen extends StatefulWidget {
  const NotificationHistoryScreen({super.key});

  @override
  State<NotificationHistoryScreen> createState() => _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState extends State<NotificationHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    // Load notification history and analytics when screen opens
    context.read<NotificationBloc>().add(const LoadNotificationHistory(days: 30));
    context.read<NotificationBloc>().add(const LoadNotificationAnalytics(7));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationHistory, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            tooltip: l10n.filters,
          ),
          IconButton(icon: const Icon(Icons.delete_sweep), onPressed: () => _showClearHistoryDialog(context), tooltip: 'Clear History'),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${state.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NotificationBloc>().add(const LoadNotificationHistory());
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            );
          }

          if (state is! NotificationLoaded) {
            return Center(child: Text(l10n.notificationsSection));
          }

          final notifications = state.filteredNotifications;
          final analytics = state.analytics;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: l10n.searchNotifications,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                context.read<NotificationBloc>().add(const SearchNotifications(''));
                              },
                            )
                          : null,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (query) {
                      context.read<NotificationBloc>().add(SearchNotifications(query));
                    },
                  ),
                ),

                // Filters (expandable)
                if (_showFilters) _buildFilters(context, state),

                // Analytics summary
                if (analytics != null) _buildAnalyticsSummary(analytics, theme),

                // Notification counts by type
                _buildNotificationCounts(state.countsByType, theme),

                const Divider(),

                // Notification list
                notifications.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_none, size: 64, color: theme.colorScheme.outline),
                            const SizedBox(height: 16),
                            Text(state.searchQuery != null ? 'No notifications match your search' : 'No notifications yet', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.outline)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return _buildNotificationCard(notification, theme);
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilters(BuildContext context, NotificationLoaded state) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.filterByType, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: Text(l10n.allLabel),
                selected: state.activeFilter == null,
                onSelected: (_) {
                  context.read<NotificationBloc>().add(const FilterNotificationsByType(null));
                },
              ),
              ...NotificationType.values.map((type) {
                return FilterChip(
                  label: Text(_getTypeLabel(type)),
                  selected: state.activeFilter == type,
                  onSelected: (_) {
                    context.read<NotificationBloc>().add(FilterNotificationsByType(type));
                  },
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          Text(l10n.filterByStatus, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: Text(AppLocalizations.of(context)!.all),
                selected: state.statusFilter == null,
                onSelected: (_) {
                  context.read<NotificationBloc>().add(const FilterNotificationsByStatus(null));
                },
              ),
              ...NotificationDeliveryStatus.values.map((status) {
                return FilterChip(
                  label: Text(_getStatusLabel(status)),
                  selected: state.statusFilter == status,
                  onSelected: (_) {
                    context.read<NotificationBloc>().add(FilterNotificationsByStatus(status));
                  },
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSummary(Map<String, dynamic> analytics, ThemeData theme) {
    final deliveryRate = ((analytics['deliveryRate'] ?? 0.0) * 100).toStringAsFixed(1);
    final openRate = ((analytics['openRate'] ?? 0.0) * 100).toStringAsFixed(1);
    final actionRate = ((analytics['actionRate'] ?? 0.0) * 100).toStringAsFixed(1);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [theme.colorScheme.primaryContainer, theme.colorScheme.secondaryContainer]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.notificationAnalyticsLast7Days, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Icon(Icons.analytics, color: theme.colorScheme.primary),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAnalyticsStat(l10n.notificationAnalyticsSent, analytics['totalSent']?.toString() ?? '0', Icons.send, theme),
              _buildAnalyticsStat(l10n.notificationAnalyticsDelivered, '$deliveryRate%', Icons.check_circle, theme),
              _buildAnalyticsStat(l10n.notificationAnalyticsOpened, '$openRate%', Icons.open_in_new, theme),
              _buildAnalyticsStat(l10n.notificationAnalyticsAction, '$actionRate%', Icons.touch_app, theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsStat(String label, String value, IconData icon, ThemeData theme) {
    return Column(
      children: [
        Icon(icon, size: 24, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildNotificationCounts(Map<NotificationType, int> counts, ThemeData theme) {
    final totalCount = counts.values.fold(0, (sum, count) => sum + count);

    if (totalCount == 0) return const SizedBox.shrink();

    return Container(
      height: 95,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: counts.length,
        itemBuilder: (context, index) {
          final entry = counts.entries.elementAt(index);
          if (entry.value == 0) return const SizedBox.shrink();

          return Card(
            margin: const EdgeInsets.only(right: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 50),
                  Icon(_getTypeIcon(entry.key), color: _getTypeColor(entry.key)),
                  //const SizedBox(height: 4),
                  Text(entry.value.toString(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(_getTypeLabel(entry.key), style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification, ThemeData theme) {
    final dateFormat = DateFormat('MMM d, yyyy HH:mm');
    final displayDate = notification.deliveredAt ?? notification.createdAt;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showNotificationDetails(notification),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Type icon, title, and status
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: _getTypeColor(notification.type).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                    child: Icon(_getTypeIcon(notification.type), color: _getTypeColor(notification.type), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text(dateFormat.format(displayDate), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
                      ],
                    ),
                  ),
                  _buildStatusChip(notification.status, theme),
                ],
              ),

              const SizedBox(height: 12),

              // Body
              Text(notification.body, style: theme.textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),

              // Action taken (if any)
              if (notification.action != NotificationAction.none) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(_getActionIcon(notification.action), size: 16, color: theme.colorScheme.secondary),
                    const SizedBox(width: 4),
                    Text(
                      'Action: ${_getActionLabel(notification.action)}',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.secondary, fontWeight: FontWeight.w500),
                    ),
                    if (notification.interactedAt != null) ...[const SizedBox(width: 8), Text('• ${dateFormat.format(notification.interactedAt!)}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline))],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(NotificationDeliveryStatus status, ThemeData theme) {
    Color color;
    IconData icon;

    switch (status) {
      case NotificationDeliveryStatus.delivered:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case NotificationDeliveryStatus.pending:
        color = Colors.orange;
        icon = Icons.schedule;
        break;
      case NotificationDeliveryStatus.failed:
        color = Colors.red;
        icon = Icons.error;
        break;
      case NotificationDeliveryStatus.cancelled:
        color = Colors.grey;
        icon = Icons.cancel;
        break;
      case NotificationDeliveryStatus.expired:
        color = Colors.brown;
        icon = Icons.timer_off;
        break;
    }

    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(_getStatusLabel(status), style: TextStyle(color: color, fontSize: 12)),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
    );
  }

  void _showNotificationDetails(NotificationItem notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Notification Details', style: Theme.of(context).textTheme.headlineSmall),
                const Divider(height: 24),
                _buildDetailRow('ID', notification.id),
                _buildDetailRow('Title', notification.title),
                _buildDetailRow('Body', notification.body),
                _buildDetailRow('Type', _getTypeLabel(notification.type)),
                _buildDetailRow('Priority', _getPriorityLabel(notification.priority)),
                _buildDetailRow('Status', _getStatusLabel(notification.status)),
                _buildDetailRow('Created', DateFormat('MMM d, yyyy HH:mm:ss').format(notification.createdAt)),
                if (notification.scheduledAt != null) _buildDetailRow('Scheduled', DateFormat('MMM d, yyyy HH:mm:ss').format(notification.scheduledAt!)),
                if (notification.deliveredAt != null) _buildDetailRow('Delivered', DateFormat('MMM d, yyyy HH:mm:ss').format(notification.deliveredAt!)),
                if (notification.interactedAt != null) _buildDetailRow('Interacted', DateFormat('MMM d, yyyy HH:mm:ss').format(notification.interactedAt!)),
                if (notification.action != NotificationAction.none) _buildDetailRow('Action', _getActionLabel(notification.action)),
                if (notification.responseTime != null) _buildDetailRow('Response Time', '${notification.responseTime!.inSeconds}s'),
                if (notification.failureReason != null) _buildDetailRow('Failure Reason', notification.failureReason!),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<NotificationBloc>().add(DeleteNotification(notification.id));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.notificationDeleted)));
                    },
                    icon: const Icon(Icons.delete),
                    label: Text(AppLocalizations.of(context)!.deleteButton),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.clearHistory),
        content: Text(AppLocalizations.of(context)!.areYouSureYouWantToClearAllNotificationHistory),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancelButton)),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<NotificationBloc>().add(const ClearNotificationHistory());
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.historyCleared)));
            },
            child: Text(AppLocalizations.of(context)!.clearAll, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.taskReminder:
        return 'Task';
      case NotificationType.taskDue:
        return 'Due';
      case NotificationType.taskCompleted:
        return 'Done';
      case NotificationType.moodCheckIn:
        return 'Mood';
      case NotificationType.pomodoroWork:
        return 'Pomodoro';
      case NotificationType.pomodoroBreak:
        return 'Break';
      case NotificationType.pomodoroComplete:
        return 'Complete';
      case NotificationType.emergency:
        return 'Emergency';
      case NotificationType.system:
        return 'System';
      case NotificationType.userSignup:
        return 'New User';
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

  String _getStatusLabel(NotificationDeliveryStatus status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case NotificationDeliveryStatus.delivered:
        return l10n.notificationStatusDelivered;
      case NotificationDeliveryStatus.pending:
        return l10n.notificationStatusPending;
      case NotificationDeliveryStatus.failed:
        return l10n.notificationStatusFailed;
      case NotificationDeliveryStatus.cancelled:
        return l10n.notificationStatusCancelled;
      case NotificationDeliveryStatus.expired:
        return l10n.notificationStatusExpired;
    }
  }

  String _getActionLabel(NotificationAction action) {
    switch (action) {
      case NotificationAction.none:
        return 'None';
      case NotificationAction.opened:
        return 'Opened';
      case NotificationAction.dismissed:
        return 'Dismissed';
      case NotificationAction.snoozed:
        return 'Snoozed';
      case NotificationAction.completed:
        return 'Completed';
      case NotificationAction.clicked:
        return 'Clicked';
    }
  }

  IconData _getActionIcon(NotificationAction action) {
    switch (action) {
      case NotificationAction.none:
        return Icons.circle;
      case NotificationAction.opened:
        return Icons.open_in_new;
      case NotificationAction.dismissed:
        return Icons.close;
      case NotificationAction.snoozed:
        return Icons.snooze;
      case NotificationAction.completed:
        return Icons.check;
      case NotificationAction.clicked:
        return Icons.touch_app;
    }
  }

  String _getPriorityLabel(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return 'Low';
      case NotificationPriority.medium:
        return 'Medium';
      case NotificationPriority.high:
        return 'High';
      case NotificationPriority.urgent:
        return 'Urgent';
    }
  }
}
