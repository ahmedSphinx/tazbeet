import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/notification/notification_bloc.dart';
import '../../blocs/notification/notification_event.dart';
import '../../blocs/notification/notification_state.dart';
import '../../models/notification_item.dart';
import '../../l10n/app_localizations.dart';
import 'notification_history_screen.dart';
import 'notification_preferences_screen.dart';

/// Quick test screen to try all notification features
class NotificationTestScreen extends StatelessWidget {
  const NotificationTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationTesting), backgroundColor: Colors.deepPurple),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          // Get data from state
          final notificationCount = state is NotificationLoaded ? state.allNotifications.length : 0;
          final isEnabled = state is NotificationLoaded
              ? state.preferences.masterNotificationsEnabled
              : state is NotificationInitialized
              ? state.preferences.masterNotificationsEnabled
              : true;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header
              Card(
                color: Colors.deepPurple.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.quickTestGuide, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(l10n.totalNotifications(notificationCount), style: const TextStyle(fontSize: 16)),
                      Text(isEnabled ? l10n.notificationsEnabled : l10n.notificationsDisabled, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Test Section 1: Basic Notifications
              _buildSectionHeader(l10n.basicNotifications),
              _buildTestButton(
                context,
                icon: Icons.notifications,
                title: l10n.testSimpleNotification,
                subtitle: l10n.appearsIn10Seconds,
                color: Colors.blue,
                onTap: () {
                  final now = DateTime.now();
                  final notification = NotificationItem(
                    id: 'test_${now.millisecondsSinceEpoch}',
                    type: NotificationType.system,
                    title: l10n.testNotificationTitle,
                    body: l10n.testNotificationBody,
                    createdAt: now,
                    scheduledAt: now.add(const Duration(seconds: 10)),
                    status: NotificationDeliveryStatus.pending,
                    action: NotificationAction.none,
                    priority: NotificationPriority.medium,
                  );
                  context.read<NotificationBloc>().add(ShowImmediateNotification(notification));
                  _showSnackBar(context, l10n.notificationScheduledFor10Seconds);
                },
              ),
              _buildTestButton(
                context,
                icon: Icons.task_alt,
                title: l10n.testTaskReminder,
                subtitle: l10n.withActionButtons15Seconds,
                color: Colors.green,
                onTap: () {
                  final now = DateTime.now();
                  final notification = NotificationItem(
                    id: 'task_test_${now.millisecondsSinceEpoch}',
                    type: NotificationType.taskReminder,
                    title: l10n.taskCompleteReport,
                    body: l10n.dueInOneHour,
                    createdAt: now,
                    scheduledAt: now.add(const Duration(seconds: 15)),
                    payload: 'test_task_123',
                    status: NotificationDeliveryStatus.pending,
                    action: NotificationAction.none,
                    priority: NotificationPriority.medium,
                  );
                  context.read<NotificationBloc>().add(ShowImmediateNotification(notification));
                  _showSnackBar(context, l10n.taskNotificationIn15Seconds);
                },
              ),
              _buildTestButton(
                context,
                icon: Icons.mood,
                title: l10n.testMoodCheckIn,
                subtitle: l10n.testIn20Seconds,
                color: Colors.orange,
                onTap: () {
                  final now = DateTime.now();
                  final notification = NotificationItem(
                    id: 'mood_test_${now.millisecondsSinceEpoch}',
                    type: NotificationType.moodCheckIn,
                    title: l10n.howAreYouFeeling,
                    body: l10n.tapToLogMood,
                    createdAt: now,
                    scheduledAt: now.add(const Duration(seconds: 20)),
                    status: NotificationDeliveryStatus.pending,
                    action: NotificationAction.none,
                    priority: NotificationPriority.medium,
                  );
                  context.read<NotificationBloc>().add(ShowImmediateNotification(notification));
                  _showSnackBar(context, l10n.moodNotificationIn20Seconds);
                },
              ),

              const SizedBox(height: 16),

              // Test Section 2: Priority Levels
              _buildSectionHeader(l10n.priorityLevels),
              _buildTestButton(
                context,
                icon: Icons.priority_high,
                title: l10n.testHighPriority,
                subtitle: l10n.urgentNotification10Seconds,
                color: Colors.red,
                onTap: () {
                  final now = DateTime.now();
                  final notification = NotificationItem(
                    id: 'urgent_test_${now.millisecondsSinceEpoch}',
                    type: NotificationType.emergency,
                    title: l10n.highPriorityAlert,
                    body: l10n.urgentNotificationMessage,
                    createdAt: now,
                    scheduledAt: now.add(const Duration(seconds: 10)),
                    status: NotificationDeliveryStatus.pending,
                    action: NotificationAction.none,
                    priority: NotificationPriority.urgent,
                  );
                  context.read<NotificationBloc>().add(ShowImmediateNotification(notification));
                  _showSnackBar(context, l10n.highPriorityNotificationIn10Seconds);
                },
              ),
              _buildTestButton(
                context,
                icon: Icons.low_priority,
                title: l10n.testLowPriority,
                subtitle: l10n.silentNotification10Seconds,
                color: Colors.grey,
                onTap: () {
                  final now = DateTime.now();
                  final notification = NotificationItem(
                    id: 'low_test_${now.millisecondsSinceEpoch}',
                    type: NotificationType.system,
                    title: l10n.lowPriorityInfo,
                    body: l10n.quietNotificationMessage,
                    createdAt: now,
                    scheduledAt: now.add(const Duration(seconds: 10)),
                    status: NotificationDeliveryStatus.pending,
                    action: NotificationAction.none,
                    priority: NotificationPriority.low,
                  );
                  context.read<NotificationBloc>().add(ShowImmediateNotification(notification));
                  _showSnackBar(context, l10n.lowPriorityNotificationIn10Seconds);
                },
              ),

              const SizedBox(height: 16),

              // Test Section 3: Notification Management
              _buildSectionHeader(l10n.notificationManagement),
              _buildTestButton(
                context,
                icon: Icons.history,
                title: l10n.viewNotificationHistory,
                subtitle: l10n.seeAllPastNotifications,
                color: Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(value: context.read<NotificationBloc>(), child: const NotificationHistoryScreen()),
                    ),
                  );
                },
              ),
              _buildTestButton(
                context,
                icon: Icons.settings,
                title: l10n.notificationPreferences,
                subtitle: l10n.configureNotificationSettings,
                color: Colors.indigo,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPreferencesScreen()));
                },
              ),

              const SizedBox(height: 32),

              // Instructions
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.amber.shade900),
                          const SizedBox(width: 8),
                          Text(
                            l10n.testingTips,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(l10n.grantNotificationPermissions),
                      const SizedBox(height: 4),
                      Text(l10n.keepAppInBackground),
                      const SizedBox(height: 4),
                      Text(l10n.checkHistoryAfterDelivery),
                      const SizedBox(height: 4),
                      Text(l10n.tryActionButtons),
                      const SizedBox(height: 4),
                      Text(l10n.testDNDMode),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildTestButton(BuildContext context, {required IconData icon, required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.play_arrow, color: color),
        onTap: onTap,
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 3), behavior: SnackBarBehavior.floating));
  }
}
