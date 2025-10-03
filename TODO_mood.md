# Mood Tracking Feature Implementation

## Overview

Add a mood tracking feature with periodic notifications at user-selected times. Users can set multiple check-in times per day, receive notifications, and input their mood through a dedicated screen.

## Tasks

### 1. Extend AppSettings for Mood Notifications

- [x] Add `enableMoodNotifications` bool to AppSettings
- [x] Add `moodCheckInTimes` List<TimeOfDay> to AppSettings
- [x] Update `toJson` and `fromJson` in AppSettings
- [x] Add convenience methods in SettingsService for mood settings

### 2. Extend NotificationService for Mood Check-ins

- [x] Add method `scheduleMoodCheckInNotifications()` to schedule recurring notifications at user times
- [x] Add method `cancelMoodCheckInNotifications()` to cancel all mood notifications
- [x] Create notification channel for mood check-ins (Android)
- [x] Handle notification payload to distinguish mood check-ins from task reminders

### 3. Create Mood Input Screen

- [x] Create `lib/ui/screens/mood_input_screen.dart`
- [x] Design UI with mood level selection (emoji/buttons)
- [x] Add sliders for energy, focus, stress levels
- [x] Add optional note field
- [x] Add save/cancel buttons
- [x] Integrate with MoodBloc for saving mood

### 4. Create Mood Settings Screen

- [x] Create `lib/ui/screens/mood_settings_screen.dart`
- [x] Toggle for enabling/disabling mood notifications
- [x] Time picker to add/remove check-in times
- [x] List view of current check-in times with delete option
- [x] Save settings to SettingsService

### 5. Extend MoodBloc for Check-in Events

- [x] Add `MoodCheckInTriggered` event
- [x] Add `QuickAddMood` event for simplified mood entry
- [x] Update state handling for check-in flow
- [x] Add navigation to mood input screen on check-in trigger

### 6. Update Main App Navigation

- [x] Add mood settings to settings screen or profile screen
- [x] Handle notification tap in main.dart to navigate to mood input
- [x] Update app routing for new screens

### 7. Add Localization Strings

- [x] Update `lib/l10n/app_*.arb` files with new strings:
  - Mood check-in notification text
  - Mood input screen labels
  - Mood settings labels
  - Error messages

### 8. UX Improvements

- [ ] Add snooze option to notifications (5min, 15min, 1hour)
- [ ] Customizable notification sound for mood check-ins
- [ ] Mood streak tracking and badges
- [ ] Mood insights dashboard with trends
- [ ] Gentle reminders if no mood entered for 24+ hours
- [ ] Integration with task productivity (mood affects task recommendations)

### 9. Testing and Validation

- [ ] Test notification scheduling at various times
- [ ] Test mood input flow from notification tap
- [ ] Test settings persistence
- [ ] Test on different devices/timezones
- [ ] Validate mood data saving and syncing

### 10. Documentation

- [ ] Update README with mood tracking feature description
- [ ] Add comments to new code
- [ ] Document notification handling flow
