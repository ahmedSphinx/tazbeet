import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tazbeet/l10n/app_localizations.dart';

import '../../services/notification_service.dart';
import '../../models/task.dart';

class NotificationsDashboard extends StatefulWidget {
  const NotificationsDashboard({super.key});

  @override
  State<NotificationsDashboard> createState() => _NotificationsDashboardState();
}

class _NotificationsDashboardState extends State<NotificationsDashboard> {
  final NotificationService _notificationService = NotificationService();
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  List<Task> _upcomingTasks = [];
  List<Task> _overdueTasks = [];

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
    _loadUpcomingTasks();
  }

  Future<void> _loadNotificationSettings() async {
    // Load notification settings from shared preferences
    setState(() {
      // These would be loaded from SharedPreferences in a real implementation
      _notificationsEnabled = true;
      _soundEnabled = true;
      _vibrationEnabled = true;
    });
  }

  Future<void> _loadUpcomingTasks() async {
    // Load upcoming and overdue tasks
    setState(() {
      // This would be loaded from the task repository in a real implementation
      _upcomingTasks = [];
      _overdueTasks = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.notificationsSection), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Settings Section
            _buildSettingsSection(),

            const SizedBox(height: 24),

            // Upcoming Tasks Section
            _buildUpcomingTasksSection(),

            const SizedBox(height: 24),

            // Overdue Tasks Section
            _buildOverdueTasksSection(),

            const SizedBox(height: 24),

            // Quick Actions Section
            _buildQuickActionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notification Settings', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),

            // Enable/Disable Notifications
            SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text('Receive notifications for tasks and reminders'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                // Save to preferences and update notification service
              },
            ),

            if (_notificationsEnabled) ...[
              const Divider(),

              // Sound Settings
              SwitchListTile(
                title: const Text('Sound'),
                subtitle: const Text('Play sound for notifications'),
                value: _soundEnabled,
                onChanged: (value) {
                  setState(() {
                    _soundEnabled = value;
                  });
                },
              ),

              // Vibration Settings
              SwitchListTile(
                title: const Text('Vibration'),
                subtitle: const Text('Vibrate for notifications'),
                value: _vibrationEnabled,
                onChanged: (value) {
                  setState(() {
                    _vibrationEnabled = value;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingTasksSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Upcoming Tasks', style: Theme.of(context).textTheme.titleLarge),
                Text('${_upcomingTasks.length}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
              ],
            ),
            const SizedBox(height: 16),

            if (_upcomingTasks.isEmpty)
              const Text('No upcoming tasks with reminders')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _upcomingTasks.length,
                itemBuilder: (context, index) {
                  final task = _upcomingTasks[index];
                  return ListTile(
                    leading: const Icon(Icons.schedule),
                    title: Text(task.title),
                    subtitle: Text(task.reminderDate != null ? 'Reminder: ${task.reminderDate!.day}/${task.reminderDate!.month}/${task.reminderDate!.year}' : 'No reminder set'),
                    trailing: IconButton(icon: const Icon(Icons.notifications_off), onPressed: () => _cancelTaskReminder(task)),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverdueTasksSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Overdue Tasks', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red)),
                Text('${_overdueTasks.length}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red)),
              ],
            ),
            const SizedBox(height: 16),

            if (_overdueTasks.isEmpty)
              const Text('No overdue tasks')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _overdueTasks.length,
                itemBuilder: (context, index) {
                  final task = _overdueTasks[index];
                  return ListTile(
                    leading: const Icon(Icons.warning, color: Colors.red),
                    title: Text(task.title, style: const TextStyle(color: Colors.red)),
                    subtitle: Text('Due: ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.notifications_active, color: Colors.red),
                      onPressed: () => _showOverdueNotification(task),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _testNotification,
                    icon: const Icon(Icons.notification_add),
                    label: const Text('Test Notification'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _clearAllNotifications,
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Clear All'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cancelTaskReminder(Task task) async {
    await _notificationService.cancelTaskReminder(task.id);
    await _loadUpcomingTasks(); // Refresh the list
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reminder cancelled for: ${task.title}')));
    }
  }

  Future<void> _showOverdueNotification(Task task) async {
    await _notificationService.showTaskDueNotification(task);
  }

  Future<void> _testNotification() async {
    // Create a test task for notification
    final testTask = Task(id: 'test_notification', title: 'Test Notification', description: 'This is a test notification', createdAt: DateTime.now(), updatedAt: DateTime.now());

    await _notificationService.showTaskDueNotification(testTask);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test notification sent!')));
    }
  }

  Future<void> _clearAllNotifications() async {
    // Cancel all notifications
    for (var task in _upcomingTasks) {
      await _notificationService.cancelTaskReminder(task.id);
    }

    await _loadUpcomingTasks(); // Refresh the list

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All notifications cleared!')));
    }
  }
}
