# Tazbeet - تظبيت

## Comprehensive Technical Documentation

**Version:** 1.0.7+7  
**Flutter SDK:** 3.8.1+  
**Dart SDK:** 3.8.1+

---

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Features](#features)
4. [Technical Stack](#technical-stack)
5. [Project Structure](#project-structure)
6. [Data Models](#data-models)
7. [State Management](#state-management)
8. [Services Layer](#services-layer)
9. [Firebase Integration](#firebase-integration)
10. [UI Components](#ui-components)
11. [Localization](#localization)
12. [Testing](#testing)
13. [Deployment](#deployment)
14. [Security](#security)
15. [Performance Optimization](#performance-optimization)
16. [Future Enhancements](#future-enhancements)

---

## Overview

**Tazbeet** (تظبيت) is a comprehensive task management and productivity application designed specifically for Arabic users. The app combines smart task management, mood tracking, Pomodoro technique, and intelligent reminders in a single, easy-to-use application.

### Key Objectives

- **Task Organization**: Advanced task management with categories, priorities, subtasks, and recurring tasks
- **Productivity Tracking**: Pomodoro timer, progress analytics, and time tracking
- **Mood Monitoring**: Daily mood logging with insights and analytics
- **Smart Notifications**: Intelligent notification system with customizable preferences
- **Multi-language Support**: Full support for Arabic, English, French, and Spanish
- **Offline-First**: Works seamlessly offline with cloud synchronization

---

## Architecture

### Clean Architecture Pattern

The app follows **Clean Architecture** principles with clear separation of concerns:

```
┌─────────────────────────────────────────────────┐
│              Presentation Layer                 │
│  (UI Screens, Widgets, BLoC/Provider)           │
├─────────────────────────────────────────────────┤
│              Domain Layer                       │
│  (Business Logic, Use Cases, Entities)          │
├─────────────────────────────────────────────────┤
│              Data Layer                         │
│  (Repositories, Data Sources)                   │
├─────────────────────────────────────────────────┤
│              Services Layer                     │
│  (Firebase, Notifications, Analytics)           │
└─────────────────────────────────────────────────┘
```

### Key Architectural Decisions

1. **BLoC Pattern for State Management**: Event-driven state management using `flutter_bloc`
2. **Provider for Services**: Dependency injection and service management
3. **Repository Pattern**: Abstraction layer for data access
4. **Hive for Local Storage**: Fast, lightweight NoSQL database
5. **Firebase for Backend**: Real-time sync, authentication, and cloud storage

---

## Features

### 1. Task Management

#### Core Features

- ✅ Create, read, update, delete (CRUD) tasks
- 🏷️ Task categorization with custom colors
- ⭐ Priority levels (Low, Medium, High)
- 📅 Due dates and reminders
- 🔄 Recurring tasks (weekly, bi-weekly, monthly)
- 📋 Subtasks with hierarchical structure (up to 3 levels deep)
- 🎤 Voice notes attachments
- 📎 File attachments
- 🏷️ Tags for organization
- 📊 Task progress tracking

#### Advanced Features

- **Strict Completion Mode**: Requires all subtasks to be completed before parent task
- **Recurring Task Management**: Automatic generation of task instances
- **Task Templates**: Quick task creation from templates
- **Bulk Operations**: Multi-select and batch operations
- **Search & Filter**: Advanced search with multiple filters
- **Calendar View**: Visual task scheduling with drag-and-drop

### 2. Pomodoro Timer

#### Features

- ⏱️ Customizable work/break durations
- 🎯 Task-linked Pomodoro sessions
- 📊 Session statistics and analytics
- 🔊 Ambient sounds for focus (rain, ocean, forest, white noise)
- 🎵 Sound customization with volume control
- 📈 Productivity tracking
- ⏸️ Pause/resume functionality
- ⏭️ Skip sessions

#### Presets

- Classic: 25min work / 5min short break / 15min long break
- Short: 15min work / 3min short break / 10min long break
- Long: 50min work / 10min short break / 30min long break
- Custom: User-defined durations

### 3. Mood Tracking

#### Features

- 😊 5-level mood scale (Very Bad to Very Good)
- 📊 Additional metrics:
  - Energy Level (1-10)
  - Focus Level (1-10)
  - Stress Level (1-10)
- 📝 Notes and tags
- 📈 Historical analytics
- 📉 Mood patterns and insights
- 🔔 Configurable check-in reminders
- 📅 Calendar view of mood history

#### Analytics

- Average mood over time
- Most common mood
- Streak tracking
- Correlation with task completion
- Energy/Focus/Stress trends

### 4. Smart Notifications

#### Notification Types

- 📋 **Task Reminders**: Scheduled task notifications
- ⏰ **Task Due**: Alerts for due tasks
- ✅ **Task Completed**: Celebration notifications
- 😊 **Mood Check-in**: Daily mood reminders
- ⏱️ **Pomodoro**: Work/break/completion alerts
- 🚨 **Emergency**: High-priority system alerts

#### Advanced Features

- **Smart Scheduling**: Learns user patterns for optimal delivery timing
- **Do Not Disturb**: Quiet hours with emergency bypass
- **Notification Grouping**: Similar notifications grouped
- **Action Buttons**: Quick actions from notifications
- **Priority Levels**: Low (silent), Medium, High, Urgent
- **Delivery Tracking**: Analytics on notification performance
- **Adaptive Timing**: Prevents notification fatigue

### 5. Categories

#### Features

- 📁 Custom categories with colors and icons
- 🎨 Color picker for visual organization
- 📊 Task count per category
- 🔒 Default categories (cannot be deleted)
- 🎯 Category-based filtering
- 📈 Category progress tracking

### 6. Progress Tracking

#### Metrics

- 📊 Total tasks completed
- 🔥 Current streak
- 💯 Productivity score
- 📈 Weekly/monthly progress
- 📉 Category-wise breakdown
- ⏱️ Time spent on tasks
- 🎯 Pomodoro sessions completed

#### Visualizations

- Line charts for trends
- Pie charts for category distribution
- Bar charts for daily/weekly stats
- Circular progress indicators
- Streak calendars

### 7. User Profile & Authentication

#### Authentication Methods

- 🔐 Google Sign-In
- 📧 Email/Password (planned)

#### Profile Features

- 👤 User name and photo
- 🎂 Birthday tracking
- 📊 User statistics
- ⚙️ Personalized settings
- 🔄 Data sync across devices

### 8. Settings & Customization

#### Appearance

- 🌓 Light/Dark/System theme
- 🎨 Color customization
- 🔠 Large text support
- ♿ High contrast mode
- 🌐 RTL support for Arabic

#### Notifications

- 🔔 Master toggle
- 📱 Per-type customization
- 🔊 Sound selection
- 📳 Vibration settings
- ⏰ Quiet hours

#### Regional

- 🌍 Language selection (AR, EN, FR, ES)
- 📅 Date format
- ⏰ Time format (12h/24h)

#### Data & Backup

- 💾 Auto-backup
- 📤 Export to CSV
- 📥 Import data
- ☁️ Cloud sync settings

---

## Technical Stack

### Core Technologies

#### Flutter & Dart

- **Flutter**: 3.8.1+ (Cross-platform UI framework)
- **Dart**: 3.8.1+ (Programming language)

#### State Management

- **flutter_bloc**: 9.1.1 (BLoC pattern implementation)
- **bloc**: 9.0.0 (Business logic component)
- **provider**: 6.1.2 (Dependency injection)
- **equatable**: 2.0.7 (Value equality)

#### Backend & Cloud

- **firebase_core**: 3.15.1 (Firebase SDK)
- **firebase_auth**: 5.6.2 (Authentication)
- **cloud_firestore**: 5.6.11 (Cloud database)
- **firebase_storage**: 12.4.9 (File storage)
- **firebase_analytics**: 11.4.1 (Analytics)
- **firebase_crashlytics**: 4.3.6 (Crash reporting)
- **google_sign_in**: 6.3.0 (Google authentication)

#### Local Storage

- **hive**: 2.2.3 (NoSQL database)
- **hive_flutter**: 1.1.0 (Hive Flutter integration)
- **shared_preferences**: 2.3.2 (Key-value storage)
- **path_provider**: 2.1.5 (File system paths)

#### Notifications

- **flutter_local_notifications**: 19.4.2 (Local notifications)
- **workmanager**: 0.9.0+3 (Background tasks)
- **timezone**: 0.10.1 (Timezone support)
- **permission_handler**: 12.0.1 (Permission management)

#### UI/UX Libraries

- **fl_chart**: 0.69.0 (Charts and graphs)
- **syncfusion_flutter_calendar**: 31.1.19 (Calendar widget)
- **syncfusion_flutter_gauges**: 31.1.19 (Gauge widgets)
- **flutter_animate**: 4.5.0 (Animations)
- **flutter_staggered_animations**: 1.1.1 (Staggered animations)
- **lottie**: 3.1.3 (Lottie animations)
- **shimmer**: 3.0.0 (Loading shimmer effect)
- **confetti**: 0.8.0 (Celebration effects)
- **flutter_colorpicker**: 1.1.0 (Color picker)
- **percent_indicator**: 4.2.3 (Progress indicators)

#### Utilities

- **intl**: 0.20.2 (Internationalization)
- **uuid**: 4.5.1 (UUID generation)
- **connectivity_plus**: 7.0.0 (Network connectivity)
- **package_info_plus**: 8.3.0 (App info)
- **in_app_update**: 4.2.2 (In-app updates)
- **csv**: 6.0.0 (CSV export/import)
- **http**: 1.2.2 (HTTP requests)

#### Audio

- **audioplayers**: 6.5.1 (Audio playback)
- **flutter_tts**: 4.1.0 (Text-to-speech)

#### Media

- **image_picker**: 1.1.2 (Image selection)
- **file_picker**: 10.3.3 (File selection)

#### UI Components

- **flutter_slidable**: 4.0.1 (Swipeable list items)
- **reorderables**: 0.6.0 (Reorderable lists)
- **tutorial_coach_mark**: 1.3.1 (Tutorial overlays)

---

## Project Structure

```
lib/
├── blocs/                        # BLoC state management
│   ├── auth/                     # Authentication BLoC
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   ├── task_list/               # Task list BLoC
│   │   ├── task_list_bloc.dart
│   │   ├── task_list_event.dart
│   │   └── task_list_state.dart
│   ├── task_details/            # Task details BLoC
│   ├── category/                # Categories BLoC
│   ├── mood/                    # Mood tracking BLoC
│   ├── user/                    # User profile BLoC
│   └── notification/            # Notifications BLoC
│
├── models/                       # Data models
│   ├── task.dart                # Task entity
│   ├── category.dart            # Category entity
│   ├── mood.dart                # Mood entity
│   ├── user.dart                # User entity
│   ├── notification_item.dart   # Notification entity
│   ├── notification_preferences.dart
│   ├── repeat_rule.dart         # Recurring task rules
│   └── app_settings.dart        # App settings model
│
├── repositories/                 # Data access layer
│   ├── task_repository.dart     # Task data operations
│   ├── category_repository.dart # Category data operations
│   ├── mood_repository.dart     # Mood data operations
│   ├── user_repository.dart     # User data operations
│   └── notification_repository.dart
│
├── services/                     # Business logic services
│   ├── auth_service.dart        # Authentication service
│   ├── notification_service.dart # Notification management
│   ├── notification_service_enhanced.dart
│   ├── data_sync_service.dart   # Firestore sync
│   ├── pomodoro_service.dart    # Pomodoro timer logic
│   ├── ambient_service.dart     # Ambient sounds
│   ├── task_sound_service.dart  # Task completion sounds
│   ├── analytics_service.dart   # Firebase Analytics
│   ├── admin_service.dart       # Admin operations
│   ├── maintenance_service.dart # Maintenance mode
│   ├── settings_service.dart    # App settings
│   ├── background_service.dart  # Background tasks
│   ├── emergency_service.dart   # Emergency mode
│   ├── progress_service.dart    # Progress calculation
│   ├── repeat_service.dart      # Recurring tasks
│   ├── tutorial_service.dart    # Tutorial system
│   ├── update_service.dart      # In-app updates
│   ├── color_customization_service.dart
│   ├── localization_service.dart
│   ├── navigation_service.dart
│   ├── firebase_service_wrapper.dart
│   ├── data_management_service.dart
│   └── app_logging.dart         # Logging utility
│
├── ui/                          # User interface
│   ├── screens/                 # App screens
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── registration_screen.dart
│   │   ├── main_screen.dart     # Home navigation
│   │   ├── add_task_screen.dart
│   │   ├── edit_task_screen.dart
│   │   ├── task_details_screen.dart
│   │   ├── category_screen.dart
│   │   ├── pomodoro_screen.dart
│   │   ├── ambient_screen.dart
│   │   ├── mood_screen.dart
│   │   ├── mood_input_screen.dart
│   │   ├── mood_history_screen.dart
│   │   ├── mood_logging_screen.dart
│   │   ├── mood_settings_screen.dart
│   │   ├── progress_screen.dart
│   │   ├── settings_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── emergency_screen.dart
│   │   ├── recurring_tasks_screen.dart
│   │   ├── notification_history_screen.dart
│   │   ├── notification_preferences_screen.dart
│   │   ├── notification_test_screen.dart
│   │   ├── notifications_dashboard.dart
│   │   ├── admin_panel_screen.dart
│   │   ├── maintenance_screen.dart
│   │   └── data_management_screen.dart
│   │
│   ├── widgets/                 # Reusable widgets
│   │   ├── home/               # Home screen widgets
│   │   │   ├── home_header.dart
│   │   │   ├── home_quick_stats.dart
│   │   │   ├── home_calendar_panel.dart
│   │   │   ├── home_category_filter.dart
│   │   │   ├── home_task_list_container.dart
│   │   │   ├── home_active_filters_bar.dart
│   │   │   └── home_undated_section.dart
│   │   ├── task_item.dart
│   │   ├── task_list_section.dart
│   │   ├── subtask_widget.dart
│   │   ├── add_task_dialog.dart
│   │   ├── edit_task_dialog.dart
│   │   ├── filter_dialog.dart
│   │   ├── calendar_section.dart
│   │   ├── empty_state.dart
│   │   ├── error_display.dart
│   │   ├── loading_skeleton.dart
│   │   ├── search_bar.dart
│   │   ├── priority_indicator.dart
│   │   ├── progress_indicator_card.dart
│   │   ├── circular_progress_card.dart
│   │   ├── gradient_card.dart
│   │   ├── hero_section.dart
│   │   ├── quick_actions_card.dart
│   │   ├── animated_expansion_card.dart
│   │   ├── recurring_tasks_manager.dart
│   │   ├── repeat_config_widget.dart
│   │   ├── notification_preview_card.dart
│   │   ├── notification_quick_actions.dart
│   │   ├── notification_stats_widget.dart
│   │   ├── color_customization_widget.dart
│   │   └── home_screen_body.dart
│   │
│   └── themes/                  # App themes
│       └── app_themes.dart
│
├── l10n/                        # Localization
│   ├── app_localizations.dart   # Localization delegate
│   ├── app_localizations_ar.dart # Arabic translations
│   ├── app_localizations_en.dart # English translations
│   ├── app_localizations_es.dart # Spanish translations
│   ├── app_localizations_fr.dart # French translations
│   ├── app_ar.arb              # Arabic strings
│   └── app_en.arb              # English strings
│
├── utils/                       # Utilities
│   └── date_range.dart         # Date utilities
│
├── firebase_options.dart        # Firebase configuration
└── main.dart                    # App entry point
```

---

## Data Models

### 1. Task Model

```dart
class Task {
  final String id;
  final String title;
  final String? description;
  final TaskPriority priority;        // low, medium, high
  final DateTime? dueDate;
  final DateTime? reminderDate;
  final bool isCompleted;
  final String? categoryId;
  final String? parentId;            // For subtasks
  final List<Task> subtasks;
  final int maxSubtaskDepth;         // Max 3 levels
  final bool strictCompletionMode;
  final List<int> reminderIntervals; // [30, 60] minutes before
  final RepeatRule? repeatRule;
  final bool isRecurringInstance;
  final String? originalTaskId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int progress;                // 0-100
  final List<String> tags;
  final List<String> attachments;    // File paths
  final List<String> voiceNotes;     // Voice note paths
  final int pomodoroCount;
  final Duration timeSpent;
  final List<Map<String, dynamic>> pomodoroSessions;
  final String? userId;              // For admin features
}
```

**Key Features:**

- Hierarchical subtask structure
- Recurring task support
- Rich metadata (tags, attachments, voice notes)
- Pomodoro integration
- Time tracking
- Multi-user support for admin

### 2. Category Model

```dart
class Category {
  final String id;
  final String name;
  final Color color;
  final String icon;
  final DateTime createdAt;
  final bool isDefault;
  final int tasksCount;
}
```

### 3. Mood Model

```dart
enum MoodLevel { very_bad, bad, neutral, good, very_good }

class Mood {
  final String id;
  final MoodLevel level;
  final String? note;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final int energyLevel;    // 1-10
  final int focusLevel;     // 1-10
  final int stressLevel;    // 1-10
}
```

### 4. User Model

```dart
class User {
  final String id;
  final String name;
  final String? profileImageUrl;
  final DateTime? birthday;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? email;
  final bool isAdmin;
}
```

### 5. Notification Models

```dart
enum NotificationType {
  taskReminder, taskDue, taskCompleted,
  moodCheckIn, pomodoroWork, pomodoroBreak,
  pomodoroComplete, emergency, system
}

enum NotificationPriority {
  low,      // Badge only, no sound
  medium,   // Standard notification
  high,     // Prominent with sound
  urgent    // Full-screen with sound and vibration
}

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final NotificationPriority priority;
  final DateTime createdAt;
  final DateTime? scheduledAt;
  final DateTime? deliveredAt;
  final DateTime? interactedAt;
  final NotificationAction action;
  final NotificationDeliveryStatus status;
  final String? payload;
  final String? relatedTaskId;
  final List<String> actionButtons;
  final Map<String, dynamic>? metadata;
  // ... and more fields
}
```

### 6. Repeat Rule Model

```dart
enum RepeatFrequency { weekly, biweekly, monthly }
enum RepeatType { forever, untilDate, count }

class RepeatRule {
  final RepeatFrequency frequency;
  final RepeatType repeatType;
  final List<int> daysOfWeek;    // 0-6 (Sunday-Saturday)
  final DateTime? endDate;
  final int? repeatCount;
  final DateTime startDate;
  final bool includeTime;
}
```

---

## State Management

### BLoC Pattern Implementation

The app uses the **BLoC (Business Logic Component)** pattern for state management:

#### 1. Auth BLoC

**Events:**

```dart
- AuthStarted          // App initialization
- AuthSignInRequested  // User login
- AuthSignOutRequested // User logout
- AuthUserChanged      // Firebase auth state change
```

**States:**

```dart
- AuthInitial          // Initial state
- AuthLoading          // Processing authentication
- AuthAuthenticated    // User logged in
- AuthUnauthenticated  // No user logged in
- AuthProfileIncomplete // Profile needs completion
- AuthError            // Authentication error
```

#### 2. Task List BLoC

**Events:**

```dart
- LoadTasks
- AddTask
- UpdateTask
- DeleteTask
- ToggleTaskCompletion
- ScheduleTaskReminder
- CancelTaskReminder
- AddRepeatRule
- UpdateRepeatRule
- RemoveRepeatRule
- GenerateRecurringInstances
- ProcessCompletedRecurringTask
```

**States:**

```dart
- TaskListInitial
- TaskListLoading
- TaskListLoaded(List<Task> tasks)
- TaskListError(String message)
```

#### 3. Notification BLoC

**Events:**

```dart
- InitializeNotifications
- LoadNotificationHistory
- SendNotification
- ScheduleNotification
- CancelNotification
- UpdateNotificationPreferences
- MarkNotificationAsRead
- TrackNotificationDelivery
```

**States:**

```dart
- NotificationInitial
- NotificationLoading
- NotificationLoaded
- NotificationError
```

### Provider Usage

Services are provided using the `Provider` package:

```dart
MultiProvider(
  providers: [
    Provider<TaskRepository>.value(value: taskRepository),
    Provider<CategoryRepository>.value(value: categoryRepository),
    ChangeNotifierProvider.value(value: settingsService),
    ChangeNotifierProvider.value(value: colorCustomizationService),
    ChangeNotifierProvider.value(value: ambientService),
    Provider<AnalyticsService>.value(value: analyticsService),
  ],
  child: MyApp(),
)
```

---

## Services Layer

### 1. Authentication Service (`auth_service.dart`)

**Responsibilities:**

- Google Sign-In integration
- Email/Password authentication
- User session management
- Token retrieval
- Cache clearing on logout

**Key Methods:**

```dart
Future<UserCredential?> signInWithGoogle()
Future<UserCredential?> signInWithEmailAndPassword(String email, String password)
Future<void> signOut()
Future<String?> getIdToken()
```

### 2. Notification Service (`notification_service.dart`)

**Responsibilities:**

- Local notification scheduling
- Notification channel management
- Permission handling
- Timezone configuration
- Notification analytics

**Key Features:**

- Task reminders
- Mood check-in notifications
- Pomodoro notifications
- Test notifications
- Pending notifications list

**Key Methods:**

```dart
Future<void> initialize()
Future<void> scheduleTaskReminder(Task task)
Future<void> scheduleMoodCheckInNotifications(List<String> times)
Future<void> showTaskCompletedNotification(Task task)
Future<bool> areNotificationsEnabled()
Future<List<PendingNotificationRequest>> getPendingNotifications()
```

### 3. Data Sync Service (`data_sync_service.dart`)

**Responsibilities:**

- Firebase Firestore synchronization
- Offline-first data management
- Conflict resolution
- Batch operations

### 4. Pomodoro Service (`pomodoro_service.dart`)

**Features:**

- Timer management (work/break cycles)
- Session tracking
- Task integration
- Persistent state
- Statistics calculation

**States:**

```dart
enum PomodoroState { idle, work, shortBreak, longBreak, paused }
```

### 5. Analytics Service (`analytics_service.dart`)

**Tracked Events:**

- Screen views
- Task operations (create, complete, delete)
- Pomodoro sessions
- Mood logs
- User engagement
- Admin actions

### 6. Background Service (`background_service.dart`)

**Responsibilities:**

- WorkManager integration
- Periodic data sync
- Notification scheduling
- Database cleanup

### 7. Settings Service (`settings_service.dart`)

**Managed Settings:**

- Theme preferences
- Language selection
- Notification preferences
- Pomodoro configurations
- Backup settings
- Analytics opt-in

---

## Firebase Integration

### Firebase Services Used

#### 1. Firebase Authentication

- Google Sign-In
- User management
- Session handling

#### 2. Cloud Firestore

**Collections Structure:**

```
users/
  {userId}/
    - User document
    tasks/
      {taskId}/
        - Task document
    categories/
      {categoryId}/
        - Category document
    moods/
      {moodId}/
        - Mood document
    notification_preferences/
      {prefId}/
        - Preference document
    notification_history/
      {notificationId}/
        - Notification document

admin_settings/
  app_settings/
    - Global app settings (maintenance mode, etc.)

admin_activity_log/
  {activityId}/
    - Admin action logs
```

#### 3. Firebase Storage

- User profile images
- Task attachments
- Voice notes
- Backup files

#### 4. Firebase Analytics

- User behavior tracking
- Feature usage analytics
- Performance monitoring

#### 5. Firebase Crashlytics

- Crash reporting
- Error tracking
- Custom logs

### Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function isAuthenticated() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }

    function isAdmin() {
      return isAuthenticated() &&
             get(/databases/$(database)/documents/users/$(request.auth.uid))
             .data.isAdmin == true;
    }

    // Users collection
    match /users/{userId} {
      allow read: if isOwner(userId) || isAdmin();
      allow create: if isOwner(userId);
      allow update: if (isOwner(userId) &&
                        request.resource.data.isAdmin == resource.data.isAdmin)
                       || isAdmin();
      allow delete: if isAdmin();

      // Subcollections
      match /tasks/{taskId} {
        allow read, write: if isOwner(userId) || isAdmin();
      }

      match /categories/{categoryId} {
        allow read, write: if isOwner(userId) || isAdmin();
      }

      match /moods/{moodId} {
        allow read, write: if isOwner(userId) || isAdmin();
      }
    }

    // Admin settings (read by all for maintenance mode)
    match /admin_settings/{settingId} {
      allow read: if true;
      allow write: if isAdmin();
    }
  }
}
```

---

## UI Components

### Theme System

**Light Theme:**

- Primary: Blue gradient
- Background: White
- Surface: Light gray
- Text: Dark gray

**Dark Theme:**

- Primary: Blue gradient
- Background: Dark gray
- Surface: Darker gray
- Text: White

**Material 3 Design:**

- Modern, adaptive UI
- Smooth animations
- Consistent spacing
- Accessible colors

### Key Widgets

#### 1. Task Item (`task_item.dart`)

- Swipeable actions (edit, delete)
- Checkbox for completion
- Priority indicator
- Due date badge
- Subtask counter
- Pomodoro session indicator

#### 2. Calendar Section (`calendar_section.dart`)

- Syncfusion calendar integration
- Task markers
- Drag-and-drop rescheduling
- Month/Week view toggle

#### 3. Empty State (`empty_state.dart`)

- Contextual illustrations
- Action buttons
- Helpful messages

#### 4. Loading Skeleton (`loading_skeleton.dart`)

- Shimmer effect
- Content placeholders
- Smooth loading experience

---

## Localization

### Supported Languages

1. **Arabic (ar)** - Primary language with full RTL support
2. **English (en)** - Secondary language
3. **French (fr)** - Additional language
4. **Spanish (es)** - Additional language

### Translation Files

- `app_ar.arb` - Arabic strings
- `app_en.arb` - English strings (650+ strings)
- `app_es.arb` - Spanish strings
- `app_fr.arb` - French strings

### Key Features

- Runtime language switching
- RTL layout support
- Number/date localization
- Pluralization support
- Context-aware translations

### Usage Example

```dart
Text(AppLocalizations.of(context)!.appTitle)
Text(AppLocalizations.of(context)!.taskCompleted)
```

---

## Testing

### Unit Tests

**Test Coverage:**

- Date range utilities (`date_range_test.dart`)
- Calendar helpers (`calendar_helpers_test.dart`)
- Home screen controller (`home_screen_controller_test.dart`)

### Widget Tests

**Test Coverage:**

- UI components
- Navigation flows
- User interactions

### Integration Tests

**Planned:**

- End-to-end task creation
- Authentication flow
- Data synchronization

### Running Tests

```bash
# All tests
flutter test

# Specific test
flutter test test/date_range_test.dart

# With coverage
flutter test --coverage
```

---

## Deployment

### Android Build

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Release App Bundle (for Play Store)
flutter build appbundle --release
```

**Key Configuration:**

- `android/app/build.gradle.kts`
- ProGuard rules: `android/app/proguard-rules.pro`
- Keystore: `android/keystore/tazbeet.keystore`

### iOS Build

```bash
# Release build
flutter build ios --release

# Create IPA
flutter build ipa --release
```

**Key Configuration:**

- `ios/Runner/Info.plist`
- Podfile dependencies
- App icons and launch screens

### Web Build

```bash
flutter build web --release
```

**Hosting:** Firebase Hosting

- Configuration: `firebase.json`
- Public directory: `y/`

---

## Security

### Best Practices

1. **Authentication:**

   - Firebase Auth for secure user management
   - Token-based API calls
   - Automatic session management

2. **Data Encryption:**

   - HTTPS for all network calls
   - Hive encryption for sensitive local data
   - Secure storage for credentials

3. **Permissions:**

   - Minimal permission requests
   - Runtime permission handling
   - User-friendly permission explanations

4. **API Keys:**

   - Environment-specific configurations
   - No hardcoded secrets
   - Firebase App Check (planned)

5. **Input Validation:**
   - Form validation
   - Sanitization of user inputs
   - SQL injection prevention (NoSQL)

---

## Performance Optimization

### Implemented Optimizations

1. **Lazy Loading:**

   - ListView.builder for task lists
   - Pagination for large datasets
   - Image lazy loading

2. **Caching:**

   - Local data caching with Hive
   - Image caching
   - API response caching

3. **Const Constructors:**

   - Immutable widgets
   - Reduced rebuilds

4. **Code Splitting:**

   - Modular architecture
   - Separate BLoCs for features

5. **Asset Optimization:**
   - Compressed images
   - Optimized fonts
   - Minimal asset bundle

### Performance Metrics

**Target Metrics:**

- App startup: < 2s
- Navigation: < 300ms
- Task list rendering: < 100ms for 100 tasks
- Memory usage: < 150MB
- Frame rate: 60 FPS

---

## Future Enhancements

### Planned Features

1. **Advanced Features:**

   - [ ] Task dependencies
   - [ ] Gantt chart view
   - [ ] Team collaboration
   - [ ] Task templates library
   - [ ] Custom fields for tasks
   - [ ] Advanced filtering & sorting

2. **AI/ML Integration:**

   - [ ] Smart task suggestions
   - [ ] Automatic categorization
   - [ ] Productivity insights
   - [ ] Optimal scheduling

3. **Social Features:**

   - [ ] Share tasks/lists
   - [ ] Family/team workspaces
   - [ ] Public task templates
   - [ ] Leaderboards

4. **Integrations:**

   - [ ] Google Calendar sync
   - [ ] Apple Calendar integration
   - [ ] Email task creation
   - [ ] Voice commands
   - [ ] Smartwatch app

5. **Platform Expansion:**

   - [ ] Desktop app (Windows, macOS, Linux)
   - [ ] Browser extension
   - [ ] API for third-party apps

6. **Enhanced Analytics:**
   - [ ] Detailed productivity reports
   - [ ] Export to PDF
   - [ ] Custom dashboards
   - [ ] Comparative analytics

---

## API Documentation

### Repository Methods

#### TaskRepository

```dart
Future<List<Task>> getAllTasks()
Future<Task?> getTaskById(String id)
Future<void> addTask(Task task)
Future<void> updateTask(Task task)
Future<void> deleteTask(String id)
Future<List<Task>> getTasksByCategory(String categoryId)
Future<List<Task>> getTasksDueToday()
Future<List<Task>> getOverdueTasks()
Future<void> clearAllTasks()
```

#### CategoryRepository

```dart
Future<List<Category>> getAllCategories()
Future<Category?> getCategoryById(String id)
Future<void> addCategory(Category category)
Future<void> updateCategory(Category category)
Future<void> deleteCategory(String id)
Future<void> createDefaultCategories()
Future<void> updateCategoryTaskCounts(List<Task> tasks)
```

#### MoodRepository

```dart
Future<List<Mood>> getAllMoods()
Future<Mood?> getMoodById(String id)
Future<void> addMood(Mood mood)
Future<void> updateMood(Mood mood)
Future<void> deleteMood(String id)
Future<List<Mood>> getMoodsByDateRange(DateTime start, DateTime end)
Future<Mood?> getTodaysMood()
```

---

## Environment Setup

### Prerequisites

1. **Flutter SDK**: 3.8.1+
2. **Dart SDK**: 3.8.1+
3. **Android Studio** or **VS Code**
4. **Xcode** (for iOS development)
5. **Firebase Project**

### Installation Steps

1. **Clone Repository:**

```bash
git clone https://github.com/yourusername/tazbeet.git
cd tazbeet
```

2. **Install Dependencies:**

```bash
flutter pub get
```

3. **Firebase Setup:**

   - Create Firebase project
   - Add Android app (download `google-services.json` → `android/app/`)
   - Add iOS app (download `GoogleService-Info.plist` → `ios/Runner/`)
   - Enable Authentication, Firestore, Storage

4. **Run Code Generation:**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

5. **Run App:**

```bash
flutter run
```

---

## Troubleshooting

### Common Issues

1. **Firebase Not Initializing:**

   - Check `google-services.json` placement
   - Verify package name matches Firebase config
   - Ensure Firebase services are enabled

2. **Notifications Not Working:**

   - Check permissions granted
   - Verify notification channels created
   - Test with immediate notification first
   - Check timezone configuration

3. **Hive Type Adapter Issues:**

   - Run code generation: `flutter pub run build_runner build`
   - Check adapter registration in `main.dart`
   - Ensure unique typeId for each adapter

4. **Build Errors:**
   - Clean build: `flutter clean`
   - Update dependencies: `flutter pub upgrade`
   - Check Gradle versions (Android)
   - Check Pod versions (iOS)

---

## Contributing Guidelines

### Code Style

- Follow Dart effective practices
- Use `flutter analyze` before commits
- Format code: `dart format .`
- Add comments for complex logic

### Git Workflow

1. Create feature branch: `git checkout -b feature/feature-name`
2. Make changes and commit: `git commit -m "Description"`
3. Push to remote: `git push origin feature/feature-name`
4. Create Pull Request

### Commit Message Format

```
feat: Add new feature
fix: Bug fix
docs: Documentation update
style: Code style changes
refactor: Code refactoring
test: Add tests
chore: Maintenance tasks
```

---

## License

This project is proprietary. All rights reserved.

---

## Contact & Support

- **Email**: support@tazbeet.com
- **Website**: https://tazbeet.com
- **Privacy Policy**: https://tazbeet.com/privacy

---

## Acknowledgments

- Flutter Team for the amazing framework
- Firebase for backend infrastructure
- Open-source community for packages used
- All contributors and testers

---

## Appendix

### A. Keyboard Shortcuts (Planned)

| Shortcut       | Action                 |
| -------------- | ---------------------- |
| `Ctrl/Cmd + N` | New Task               |
| `Ctrl/Cmd + F` | Search Tasks           |
| `Ctrl/Cmd + P` | Start Pomodoro         |
| `Space`        | Toggle Task Completion |

### B. File Size Limits

- Profile Image: 5 MB
- Task Attachment: 10 MB per file
- Voice Note: 5 MB per file
- Total Storage: 100 MB per user (free tier)

### C. Rate Limits

- API Calls: 1000 requests/minute
- Notification Scheduling: 100/hour
- Data Export: 10/day

---

**Last Updated:** October 13, 2025  
**Documentation Version:** 1.0.0  
**App Version:** 1.0.7+7
