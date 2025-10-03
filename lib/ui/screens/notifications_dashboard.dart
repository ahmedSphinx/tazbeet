import 'package:flutter/material.dart';
import 'package:tazbeet/l10n/app_localizations.dart';

import '../../services/notification_service.dart';
import '../../models/task.dart';
import '../../repositories/task_repository.dart';

class NotificationsDashboard extends StatefulWidget {
  const NotificationsDashboard({super.key});

  @override
  State<NotificationsDashboard> createState() => _NotificationsDashboardState();
}

class _NotificationsDashboardState extends State<NotificationsDashboard> {
  final NotificationService _notificationService = NotificationService();
  final TaskRepository _taskRepository = TaskRepository();
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _systemNotificationsEnabled = false;
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
    final systemEnabled = await _notificationService.areNotificationsEnabled();
    setState(() {
      // These would be loaded from SharedPreferences in a real implementation
      _notificationsEnabled = true;
      _soundEnabled = true;
      _vibrationEnabled = true;
      _systemNotificationsEnabled = systemEnabled;
    });
  }

  Future<void> _loadUpcomingTasks() async {
    final allTasks = await _taskRepository.getAllTasks();
    final now = DateTime.now();
    final upcoming = allTasks.where((task) => task.reminderDate != null && task.reminderDate!.isAfter(now) && !task.isCompleted).toList();
    final overdue = allTasks.where((task) => task.dueDate != null && task.dueDate!.isBefore(now) && !task.isCompleted).toList();
    upcoming.sort((a, b) => a.reminderDate!.compareTo(b.reminderDate!));
    overdue.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    setState(() {
      _upcomingTasks = upcoming;
      _overdueTasks = overdue;
    });

    // Reschedule all reminders on load to ensure notifications are up to date
    await _notificationService.rescheduleAllReminders(upcoming);
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
            Text(AppLocalizations.of(context)!.notificationsSection, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              _systemNotificationsEnabled ? 'الإشعارات مفعلة في النظام' : 'الإشعارات معطلة في النظام - اذهب إلى الإعدادات لتفعيلها',
              style: TextStyle(color: _systemNotificationsEnabled ? Colors.green : Colors.red, fontSize: 14),
            ),
            const SizedBox(height: 8),

            // Enable/Disable Notifications
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.enableNotifications),
              subtitle: Text(AppLocalizations.of(context)!.receiveNotificationsForTasksAndReminders),
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
                title: Text(AppLocalizations.of(context)!.sound),
                subtitle: Text(AppLocalizations.of(context)!.playSoundForNotifications),
                value: _soundEnabled,
                onChanged: (value) {
                  setState(() {
                    _soundEnabled = value;
                  });
                },
              ),

              // Vibration Settings
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.vibration),
                subtitle: Text(AppLocalizations.of(context)!.vibrateForNotifications),
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
                Text(AppLocalizations.of(context)!.upcoming, style: Theme.of(context).textTheme.titleLarge),
                Text('${_upcomingTasks.length}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
              ],
            ),
            const SizedBox(height: 16),

            if (_upcomingTasks.isEmpty)
              Text(AppLocalizations.of(context)!.noUpcomingTasksWithReminders)
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
                    subtitle: Text(
                      task.reminderDate != null ? AppLocalizations.of(context)!.reminder('${task.reminderDate!.day}/${task.reminderDate!.month}/${task.reminderDate!.year}') : AppLocalizations.of(context)!.noReminderSet,
                    ),
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
                Text(AppLocalizations.of(context)!.overdueTasks, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red)),
                Text('${_overdueTasks.length}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red)),
              ],
            ),
            const SizedBox(height: 16),

            if (_overdueTasks.isEmpty)
              Text(AppLocalizations.of(context)!.noOverdueTasks)
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
                    subtitle: Text('${AppLocalizations.of(context)!.dueDate}: ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}'),
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
            Text(AppLocalizations.of(context)!.quickControls, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('ملاحظة: التذكيرات المجدولة لا تظهر إذا كان التطبيق مفتوح. أغلق التطبيق لاختبارها.', style: TextStyle(color: Colors.orange, fontSize: 12)),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _testNotification,
                    icon: const Icon(Icons.notification_add),
                    label: Text(AppLocalizations.of(context)!.testNotification),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _clearAllNotifications,
                    icon: const Icon(Icons.clear_all),
                    label: Text(AppLocalizations.of(context)!.clearAllButton),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _testReminderIn10Seconds,
                    icon: const Icon(Icons.timer),
                    label: Text(AppLocalizations.of(context)!.testReminderIn10Seconds),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _openNotificationSettings,
                    icon: const Icon(Icons.settings),
                    label: const Text('Settings'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.reminderCancelledFor(task.title))));
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.testNotificationSent)));
    }
  }

  Future<void> _clearAllNotifications() async {
    // Cancel all notifications
    for (var task in _upcomingTasks) {
      await _notificationService.cancelTaskReminder(task.id);
    }

    await _loadUpcomingTasks(); // Refresh the list

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.allNotificationsCleared)));
    }
  }

  Future<void> _testReminderIn10Seconds() async {
    await _notificationService.scheduleTestReminder();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.testReminderScheduled)));
    }
  }

  Future<void> _openNotificationSettings() async {
    // Open app notification settings
    await _notificationService.openNotificationSettings();
  }
}
