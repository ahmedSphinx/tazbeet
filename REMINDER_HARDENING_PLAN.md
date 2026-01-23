# Reminder System Hardening Implementation

## DAY 1 – State & Visibility

### Add ReminderState enum
- **File**: `/lib/models/task.dart`
- **Action**: Add enum with values {none, scheduled, delivered, failed, cancelled}
- **Done**: Enum compiles and is referenced in Task model

### Update Task model with reminder fields
- **File**: `/lib/models/task.dart`
- **Action**: Add reminderState, reminderLastAttempt, reminderRetryCount, reminderFailureReason fields
- **Done**: Task model compiles with new fields

### Update Task.copyWith method
- **File**: `/lib/models/task.dart`
- **Action**: Add new reminder fields to copyWith method
- **Done**: copyWith accepts all new reminder fields

### Update Hive adapters for new fields
- **File**: `/lib/main.dart`
- **Action**: Register ReminderStateAdapter in main.dart
- **Done**: App starts without Hive adapter errors

### Add reminder lifecycle logging
- **File**: `/lib/services/notification_service.dart`
- **Action**: Add AppLogging calls for all reminder state transitions
- **Done**: All reminder operations log state changes

## DAY 2 – Default Decision Fix

### Add default reminder calculation
- **File**: `/lib/models/task.dart`
- **Action**: Add extension method to calculate default reminder based on priority
- **Done**: Extension returns correct reminder times (1h/24h/48h)

### Auto-create reminders in TaskListBloc
- **File**: `/lib/blocs/task_list/task_list_bloc.dart`
- **Action**: In _onAddTask and _onUpdateTask, auto-schedule default reminders
- **Done**: New tasks with dueDates get automatic reminders

### Remove manual reminder requirement
- **File**: `/lib/ui/screens/task_details_screen.dart`
- **Action**: Remove manual reminder picker, make it opt-out only
- **Done**: TaskDetailsScreen no longer requires manual reminder selection

### Add opt-out reminder option
- **File**: `/lib/ui/screens/task_details_screen.dart`
- **Action**: Add toggle to disable automatic reminders
- **Done**: User can opt out of automatic reminders

### Update quick add to use defaults
- **File**: `/lib/ui/screens/home/home_screen.dart`
- **Action**: Remove reminder creation from quick add dialog
- **Done**: Quick add relies on automatic defaults

## DAY 3 – Reliability & Verification

### Add VerifyScheduledReminders event
- **File**: `/lib/blocs/notification/notification_event.dart`
- **Action**: Add VerifyScheduledReminders event class
- **Done**: Event compiles and is used in NotificationBloc

### Implement reminder verification
- **File**: `/lib/blocs/notification/notification_bloc.dart`
- **Action**: Add _onVerifyScheduledReminders handler
- **Done**: Verification compares scheduled vs expected reminders

### Add one retry logic
- **File**: `/lib/services/notification_service.dart`
- **Action**: Implement _healFailedReminder with single retry after 5 minutes
- **Done**: Failed reminders retry exactly once

### Add fallback logic
- **File**: `/lib/services/notification_service.dart`
- **Action**: Use inexact alarms if exact alarms denied
- **Done**: Reminders schedule even without exact alarm permission

### Add permission change handling
- **File**: `/lib/blocs/notification/notification_bloc.dart`
- **Action**: In _onCheckPermissions, trigger reschedule on permission change
- **Done**: Permission changes trigger reminder reschedule

## DAY 4 – Platform Survival

### Add exact alarm fallback
- **File**: `/lib/services/notification_service.dart`
- **Action**: Modify scheduleTaskReminder to fallback to AllowWhileIdle
- **Done**: Reminders work without exact alarm permission

### Add Android boot receiver
- **File**: `/lib/services/background_service.dart`
- **Action**: Implement boot receiver to reschedule reminders
- **Done**: App reschedules reminders after device reboot

### Add app restart recovery
- **File**: `/lib/main.dart`
- **Action**: Call VerifyScheduledReminders after NotificationBloc initialization
- **Done**: App startup verifies all reminders are scheduled

### Add lifecycle monitoring
- **File**: `/lib/ui/screens/home/main_screen.dart`
- **Action**: Add AppLifecycleState.resumed listener to verify reminders
- **Done**: App resume triggers reminder verification

## DAY 5 – Actionable Notifications

### Add notification actions payload
- **File**: `/lib/services/notification_service.dart`
- **Action**: Enhance payload with action data (complete, snooze, view)
- **Done**: Notification payload includes action metadata

### Add Complete action
- **File**: `/lib/services/notification_service.dart`
- **Action**: Add complete action button to task reminders
- **Done**: Complete button appears in notification

### Add Snooze 15 minutes action
- **File**: `/lib/services/notification_service.dart`
- **Action**: Add snooze action button with 15-minute default
- **Done**: Snooze button appears and works for 15 minutes

### Dispatch actions to BLoC
- **File**: `/lib/services/notification_service.dart`
- **Action**: In onDidReceiveNotificationResponse, dispatch events to TaskListBloc
- **Done**: Notification actions trigger BLoC events directly

### Add SnoozeTaskReminder event
- **File**: `/lib/blocs/notification/notification_event.dart`
- **Action**: Add SnoozeTaskReminder event with duration parameter
- **Done**: Event compiles and handles snooze requests

## DAY 6 – Cleanup & Validation

### Prevent duplicate scheduling
- **File**: `/lib/services/notification_service.dart`
- **Action**: Check existing notifications before scheduling new ones
- **Done**: No duplicate notifications for same task

### Validate notification ID strategy
- **File**: `/lib/services/notification_service.dart`
- **Action**: Ensure _generateTaskNotificationId produces unique, valid IDs
- **Done**: All notification IDs are unique and within 32-bit range

### Add manual test checklist
- **File**: `/test/services/notification_service_test.dart`
- **Action**: Create test cases for app kill, device reboot, permission revoke, timezone change
- **Done**: All test scenarios pass

### Add integration test
- **File**: `/test/integration/reminder_system_test.dart`
- **Action**: Create end-to-end test for reminder lifecycle
- **Done**: Integration test covers full reminder flow

---

## FINAL DONE CHECKLIST

- [ ] ReminderState enum added to Task model
- [ ] Task model updated with reminder tracking fields
- [ ] Automatic default reminders created for tasks with dueDates
- [ ] Manual reminder dependency removed from UI
- [ ] Reminder verification system implemented
- [ ] One retry logic for failed reminders
- [ ] Fallback logic for restricted permissions
- [ ] Permission change handling added
- [ ] Android exact alarm fallback implemented
- [ ] Boot receiver for device restart recovery
- [ ] App restart recovery verification
- [ ] Notification actions (Complete, Snooze) implemented
- [ ] BLoC event dispatch from notification taps
- [ ] Duplicate scheduling prevention
- [ ] Notification ID strategy validated
- [ ] Manual test scenarios documented and passing
