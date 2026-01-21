# Task Reminder Service Guide

## Overview

The Task Reminder Service is a comprehensive notification system that handles scheduling, managing, and verifying task reminders in the Tazbeet app. It provides reliable local notifications with timezone support, permission handling, and detailed logging.

## Architecture

### Core Components

1. **NotificationService** - Main service class for all notification operations
2. **NotificationBloc** - State management for notification-related UI
3. **TaskListBloc** - Integrates reminder scheduling with task management
4. **NotificationVerificationService** - Validates scheduled reminders

### Key Features

- ✅ **Smart Scheduling** - Automatic timezone handling and past-date validation
- ✅ **Unique IDs** - Prevents notification collisions with timestamp-based IDs
- ✅ **Bulk Operations** - Efficient rescheduling of multiple reminders
- ✅ **Verification** - Confirms reminders are properly scheduled
- ✅ **Permission Management** - Handles iOS/Android notification permissions
- ✅ **Error Handling** - Comprehensive logging and user feedback

## API Reference

### Core Methods

#### `scheduleTaskReminder(Task task)`
Schedules a reminder for a specific task.

```dart
await notificationService.scheduleTaskReminder(task);
```

**Parameters:**
- `task` - Task object with `reminderDate` set

**Features:**
- Validates reminder date is in the future
- Generates unique notification ID
- Handles timezone conversion automatically
- Verifies scheduling success
- Logs detailed information

#### `cancelTaskReminder(String taskId)`
Cancels all notifications related to a task.

```dart
await notificationService.cancelTaskReminder(taskId);
```

**Features:**
- Cancels reminder, due, and completion notifications
- Uses multiple ID patterns for thorough cleanup
- Logs cancellation details

#### `rescheduleAllReminders(List<Task> tasks)`
Reschedules all active task reminders (used on app startup).

```dart
await notificationService.rescheduleAllReminders(tasks);
```

**Features:**
- Bulk operation with error tracking
- Success/failure statistics
- Detailed error logging for failed tasks
- Suppresses user-facing errors during bulk ops

### Utility Methods

#### `areNotificationsEnabled()`
Checks if notifications are permitted and available.

```dart
bool enabled = await notificationService.areNotificationsEnabled();
```

#### `getPendingNotifications()`
Returns all currently scheduled notifications.

```dart
List<PendingNotificationRequest> pending = await notificationService.getPendingNotifications();
```

#### `requestNotificationPermission()`
Requests notification permissions from the user.

```dart
bool granted = await notificationService.requestNotificationPermission();
```

## Integration Guide

### 1. Basic Setup

```dart
// In your main.dart or app initialization
final notificationService = NotificationService();
await notificationService.initialize();

// Provide to BLoCs
BlocProvider(
  create: (context) => TaskListBloc(
    taskRepository: taskRepository,
    categoryRepository: categoryRepository,
    notificationService: notificationService,
  ),
  child: YourApp(),
);
```

### 2. Scheduling a Reminder

```dart
// When creating or updating a task
final task = Task(
  id: 'unique-task-id',
  title: 'Complete project',
  reminderDate: DateTime.now().add(Duration(hours: 2)),
);

// Schedule reminder
await notificationService.scheduleTaskReminder(task);
```

### 3. Handling Task Updates

```dart
// In TaskListBloc
Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskListState> emit) async {
  // Update task in repository
  await taskRepository.updateTask(event.task);
  
  // Reschedule reminder if changed
  if (event.task.reminderDate != null) {
    await notificationService.scheduleTaskReminder(event.task);
  }
  
  emit(TaskListLoaded(updatedTasks));
}
```

### 4. App Startup Rescheduling

```dart
// In TaskListBloc _onLoadTasks
Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskListState> emit) async {
  final tasks = await taskRepository.getAllTasks();
  emit(TaskListLoaded(tasks));
  
  // Reschedule all reminders to ensure persistence
  await notificationService.rescheduleAllReminders(tasks);
}
```

## Advanced Features

### Unique Notification IDs

The service generates unique IDs to prevent collisions:

```dart
int _generateTaskNotificationId(String taskId, {String suffix = ''}) {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final hash = taskId.hashCode.abs();
  return int.parse('${timestamp.toString().substring(6)}${hash.toString().substring(0, 3)}$suffix');
}
```

### Timezone Handling

Automatic timezone conversion ensures reliable scheduling:

```dart
final scheduledTime = tz.TZDateTime.from(task.reminderDate!, tz.local);
```

### Verification System

Post-scheduling verification catches issues early:

```dart
await _verifyReminderScheduled(task.id, task.title);
```

## Error Handling

### Bulk Operation Logging

```dart
// Example output from rescheduleAllReminders
AppLogging.logInfo('Reschedule Summary: 15 successful, 2 failed out of 17 tasks');
AppLogging.logWarning('Failed to reschedule reminders for: Task A (abc123): Permission denied; Task B (def456): Invalid date');
```

### Permission Handling

The service automatically handles permissions:

- **Android**: Requests notification and exact alarm permissions
- **iOS**: Requests alert, badge, and sound permissions
- **Fallback**: Shows user-friendly error messages

## Best Practices

### 1. Always Check Permissions

```dart
final enabled = await notificationService.areNotificationsEnabled();
if (!enabled) {
  // Show permission request UI
  await notificationService.requestNotificationPermission();
}
```

### 2. Handle Past Dates Gracefully

```dart
// The service automatically handles past dates
// No need for manual validation in your code
```

### 3. Use Bulk Operations for Efficiency

```dart
// Good: Reschedule all at once
await notificationService.rescheduleAllReminders(tasks);

// Avoid: Individual rescheduling in loops
for (final task in tasks) {
  await notificationService.scheduleTaskReminder(task); // Less efficient
}
```

### 4. Monitor Logs

Enable debug logging to track issues:

```dart
// Check logs for:
// - "✅ Reminder verified as scheduled"
// - "⚠️ Reminder may not be scheduled"
// - "Reschedule Summary: X successful, Y failed"
```

## Troubleshooting

### Common Issues

1. **Reminders Not Showing**
   - Check notification permissions
   - Verify exact alarm permissions (Android)
   - Check battery optimization settings

2. **Wrong Time for Reminders**
   - Timezone automatically handled
   - Ensure device time is correct
   - Check for timezone changes

3. **Duplicate Notifications**
   - Unique IDs prevent this
   - Check if multiple scheduling calls occur

4. **Bulk Operation Failures**
   - Check detailed error logs
   - Individual task errors don't stop bulk operation
   - Failed tasks are listed in logs

### Debug Commands

```dart
// Check pending notifications
final pending = await notificationService.getPendingNotifications();
print('Pending notifications: ${pending.length}');

// Test notification scheduling
await notificationService.scheduleTestReminder();

// Verify specific task reminder
await notificationVerificationService.verifyTaskReminder(task);
```

## Performance Considerations

- **Memory**: Efficient bulk operations with error suppression
- **Battery**: Uses exact alarms sparingly
- **Storage**: Minimal local storage usage
- **Network**: No network dependency for local notifications

## Migration Guide

### From Simple Notification Scheduling

```dart
// Old approach
await flutterLocalNotificationsPlugin.zonedSchedule(
  task.id.hashCode,
  title,
  body,
  scheduledTime,
  platformDetails,
);

// New approach
await notificationService.scheduleTaskReminder(task);
// Includes: validation, unique IDs, verification, logging
```

### From Manual Permission Handling

```dart
// Old approach
final status = await Permission.notification.request();
if (status.isGranted) {
  // Schedule notification
}

// New approach
final enabled = await notificationService.areNotificationsEnabled();
if (enabled) {
  await notificationService.scheduleTaskReminder(task);
}
// Includes: platform-specific permissions, battery optimization, exact alarms
```

## Testing

### Unit Tests

```dart
test('schedules task reminder', () async {
  final task = Task(
    id: 'test',
    title: 'Test Task',
    reminderDate: DateTime.now().add(Duration(hours: 1)),
  );
  
  await notificationService.scheduleTaskReminder(task);
  
  final pending = await notificationService.getPendingNotifications();
  expect(pending.any((n) => n.title.contains('Test Task')), isTrue);
});
```

### Integration Tests

```dart
testWidgets('handles permission denial', (tester) async {
  // Mock permission denial
  when(mockPermissionService.requestNotificationPermission())
      .thenAnswer((_) async => false);
  
  await tester.pumpWidget(MyApp());
  
  // Verify error message shown
  expect(find.text('Notification permission required'), findsOneWidget);
});
```

## Future Enhancements

### Planned Features

- **Smart Rescheduling** - Automatic retry for failed notifications
- **Location-based Reminders** - Geofenced task notifications
- **Adaptive Timing** - ML-based optimal reminder times
- **Rich Notifications** - Interactive notification buttons
- **Snooze Options** - Customizable snooze durations

### Extension Points

The service is designed for extensibility:

```dart
// Custom notification types
class CustomNotificationService extends NotificationService {
  Future<void> scheduleLocationReminder(Task task, Location location) async {
    // Custom location-based scheduling
  }
}
```

## Support

For issues or questions:

1. Check the application logs
2. Verify permissions and settings
3. Test with `scheduleTestReminder()`
4. Review this guide for common solutions

---

**Last Updated**: January 2026
**Version**: 1.0
**Compatible**: Flutter 3.8.1+, iOS 12.0+, Android API 21+
