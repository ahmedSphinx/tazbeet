# Tazbeet Project Context

## Overview
Tazbeet is a comprehensive task management and productivity app built with Flutter. The app combines task management, mood tracking, Pomodoro timer, and admin features in a single unified interface with multi-platform support.

## Core Business Logic

### Authentication System
- **Multi-provider Auth**: Google Sign-In, Apple Sign-In, Email/Password
- **Admin System**: First user automatically gets admin privileges, subsequent users require admin assignment
- **Profile Management**: Users can complete profile with name, birthday, profile image
- **Admin Notifications**: New user signups trigger immediate notifications to all admin users
- **Session Management**: Persistent authentication with automatic token refresh

### Task Management
- **Task Creation**: Tasks with title, description, due date, priority, categories, and subtasks
- **Task States**: Pending, In Progress, Completed, Cancelled
- **Recurring Tasks**: Support for daily, weekly, monthly recurring patterns with complex scheduling
- **Task Filtering**: By date, priority, category, completion status, overdue status
- **Overdue Tasks**: Automatic detection and filtering with visual indicators
- **Task Progress**: Completion percentage calculated based on subtasks completion
- **Task Dependencies**: Support for task dependencies and ordering
- **Bulk Operations**: Multi-select for bulk actions (delete, complete, categorize)

### Mood Tracking
- **Mood Check-ins**: Multiple daily mood recording sessions with configurable schedules
- **Mood Analytics**: Trends, patterns, and achievement tracking with visual charts
- **Streak System**: Consecutive mood check-in tracking with rewards
- **Mood Categories**: Different mood types with visual representations and emojis
- **Mood Insights**: AI-powered mood analysis and recommendations
- **Historical Tracking**: Long-term mood data with export capabilities

### Pomodoro Timer
- **Work Sessions**: 25-minute focused work periods with customizable duration
- **Break Sessions**: 5-minute short breaks, 15-minute long breaks
- **Session Tracking**: Complete Pomodoro cycle management with statistics
- **Task Integration**: Link Pomodoro sessions with specific tasks
- **Sound Customization**: Custom notification sounds for work/break transitions
- **Session History**: Track completed sessions and productivity metrics

### Notification System
- **Smart Notifications**: Context-aware notifications with user preferences
- **Quiet Hours**: Do Not Disturb mode with configurable time windows
- **Notification Types**: Task reminders, mood check-ins, Pomodoro sessions, user signups, system alerts
- **Delivery Tracking**: Monitor notification delivery status and retry failed notifications
- **Admin Notifications**: Real-time alerts for admin users about system events

## Architecture

### State Management
- **BLoC Pattern**: Used throughout the app for reactive state management
- **Key BLoCs**:
  - `AuthBloc`: Authentication state and user management
  - `TaskListBloc`: Task CRUD operations, filtering, and bulk operations
  - `TaskDetailsBloc`: Individual task management with subtask support
  - `NotificationBloc`: Notification scheduling, management, and analytics
  - `MoodBloc`: Mood tracking, analytics, and streak management
  - `CategoryBloc`: Task category management with hierarchy support
  - `UserBloc`: User profile, preferences, and settings management
  - `AdminBloc`: Admin operations and user management (admin only)

### Data Layer
- **Firebase Backend**: Firestore for data persistence with real-time synchronization
- **Local Storage**: Hive for offline data caching and performance optimization
- **Repositories**: Abstract data access layer with caching strategies
  - `UserRepository`: User data management with profile caching
  - `TaskRepository`: Task CRUD operations with efficient querying
  - `CategoryRepository`: Category management with hierarchical support
  - `NotificationRepository`: Notification history and preferences
  - `MoodRepository`: Mood data storage and analytics

### Services
- **AuthService**: Firebase authentication wrapper with token management
- **NotificationService`: Local notification management with scheduling
- **AdminService`: Admin user management and notifications
- **DataSyncService**: Firebase synchronization with conflict resolution
- **AppLoggingService`: Centralized logging with error tracking
- **PerformanceService**: App performance monitoring and optimization
- **AccessibilityService**: Accessibility features and voice task support
- **NavigationService**: Centralized navigation management

## UI Structure

### Main Navigation
- **Bottom Navigation**: Home, Mood, Categories, Admin (if admin), Settings
- **IndexedStack**: Preserves state when switching tabs for seamless UX
- **Floating Action Buttons**: Context-sensitive actions per screen with animations
- **Navigation Rail**: Adaptive navigation for larger screens
- **Gesture Navigation**: Support for swipe gestures and back navigation

### Key Screens
- **MainScreen**: Tab container with state preservation and adaptive layout
- **HomeScreenRedesigned**: Task list with advanced filtering, search, and bulk operations
- **MoodScreen**: Mood input dashboard with analytics and insights
- **CategoryScreen**: Task category management with drag-and-drop organization
- **AdminPanelScreen**: User and system management (admin only) with comprehensive admin tools
- **TaskDetailsScreen**: Individual task editing with subtask management
- **NotificationHistoryScreen**: Notification log and analytics with filtering
- **SettingsScreen**: App preferences and user settings
- **TutorialScreen**: Interactive onboarding for new users

### UI Components
- **DSEnhancedFAB**: Enhanced floating action button with animations and contextual actions
- **Enhanced Search Bar**: Advanced search with filters, suggestions, and history
- **Notification Preview Cards**: Rich notification display with interactive elements
- **Mood Tracking Widgets**: Visual mood input components with animations
- **Task Cards**: Rich task display with progress indicators and quick actions
- **Calendar Widgets**: Custom calendar views for task scheduling
- **Analytics Charts**: Interactive charts for mood and productivity insights

## Data Models

### User Model
```dart
class User {
  String id;
  String name;
  String email;
  String? profileImageUrl;
  DateTime? birthday;
  bool isAdmin;
  DateTime createdAt;
  DateTime updatedAt;
  UserPreferences preferences;
  List<String> deviceTokens; // For push notifications
}
```

### Task Model
```dart
class Task {
  String id;
  String title;
  String description;
  DateTime? dueDate;
  DateTime? reminderDate;
  TaskPriority priority;
  TaskStatus status;
  String? categoryId;
  bool isRecurring;
  RecurringPattern? recurringPattern;
  List<Task> subtasks;
  List<String> dependencies;
  String userId;
  DateTime createdAt;
  DateTime updatedAt;
  Map<String, dynamic> metadata; // For custom fields
  int estimatedDuration; // In minutes
  int actualDuration; // Time tracking
}
```

### Notification System
- **Types**: Task reminders, mood check-ins, Pomodoro sessions, user signups, system alerts, emergency notifications
- **Priorities**: Low, Medium, High, Urgent
- **Delivery**: Immediate, scheduled, failed, cancelled, expired
- **Channels**: Task reminders, mood check-ins, Pomodoro, admin notifications, system updates
- **Analytics**: Delivery tracking, interaction rates, performance metrics

### Category Model
```dart
class Category {
  String id;
  String name;
  String description;
  Color color;
  IconData icon;
  String? parentId; // For hierarchical categories
  int sortOrder;
  DateTime createdAt;
  DateTime updatedAt;
  bool isDefault;
  Map<String, dynamic> metadata;
}
```

## Critical Business Rules

### Admin System
1. First user in system automatically becomes admin
2. Admins receive notifications for new user signups and system events
3. Admins can manage all users, tasks, and categories
4. Admin privileges cannot be revoked (except by deleting user)
5. Admin operations are logged for audit purposes
6. Admin users can view system analytics and performance metrics

### Task Management
1. Tasks can have subtasks for complex workflows
2. Task progress calculated as: (completed subtasks / total subtasks) * 100
3. Overdue tasks automatically flagged and filterable with visual indicators
4. Recurring tasks create new instances based on patterns with timezone support
5. Task categories can be hierarchical with unlimited depth
6. Task dependencies must be resolved before task completion
7. Deleted tasks are archived for recovery within 30 days

### Notification Logic
1. Task reminders trigger 15 minutes before due time (configurable)
2. Mood check-ins scheduled at configurable times with user preferences
3. Admin notifications sent immediately for new users and system events
4. Failed notifications retry up to 3 times with exponential backoff
5. Do Not Disturb mode respected during quiet hours
6. Emergency notifications bypass DND settings
7. Notifications are grouped and stacked for better user experience

### Data Synchronization
1. Local cache (Hive) for offline functionality with automatic sync
2. Firebase sync when network available with conflict resolution
3. Conflict resolution: Firebase takes precedence, local changes merged
4. Real-time updates for multi-user scenarios with optimistic UI
5. Background sync with battery optimization considerations
6. Data versioning for migration and compatibility

## Important Implementation Details

### Performance Optimizations
- Single-pass filtering for task lists with efficient algorithms
- Lazy loading and pagination for large datasets
- Efficient recurring task instance generation with caching
- Optimized Firestore queries with proper indexing
- Image caching and compression for better performance
- Memory management for large datasets with disposal patterns
- Background processing for heavy operations

### Error Handling
- Comprehensive logging throughout the app with structured logging
- Graceful degradation for network issues with offline support
- User-friendly error messages with contextual help
- Automatic retry for failed operations with exponential backoff
- Error reporting and crash analytics integration
- Recovery mechanisms for corrupted data

### Security Considerations
- Firebase security rules for data access with role-based permissions
- Admin-only operations protected server-side
- User data isolation (users can only access their own data)
- Secure token handling for authentication with refresh tokens
- Input validation and sanitization throughout the app
- Encryption for sensitive data at rest and in transit
- Audit logging for admin actions

### UI/UX Principles
- Material Design 3 compliance with dynamic theming
- Accessibility features throughout with screen reader support
- Responsive design for different screen sizes and orientations
- Consistent navigation patterns with intuitive user flow
- Tutorial system for first-time users with interactive guidance
- Dark mode support with system theme detection
- Micro-interactions and animations for better user engagement
- Voice task support for accessibility and convenience

### Internationalization
- Full localization support with ARB files
- RTL language support for Arabic and other RTL languages
- Dynamic language switching without app restart
- Cultural adaptation for date/time formats and number formatting
- Localized notification content and error messages

## Testing Strategy
- Unit tests for business logic with high code coverage
- Integration tests for data flows and API interactions
- UI tests for critical user journeys with automation
- Performance testing for large datasets and memory usage
- Accessibility testing with screen readers and accessibility tools
- Security testing for data protection and privacy
- Multi-platform testing for consistent behavior

## Deployment Configuration
- Multi-platform: Android, iOS, Web, Desktop (Windows, macOS, Linux)
- Firebase hosting for web version with CDN optimization
- App Store and Google Play deployment with automated builds
- Environment-specific configurations (dev, staging, prod)
- CI/CD pipeline with automated testing and deployment
- Code signing and certificate management
- Performance monitoring and crash reporting in production

## Development Guidelines for AI Agents

### DO NOT MODIFY Without Explicit Request:
1. Core business logic in BLoCs and repositories
2. Firebase security rules and database structure
3. Admin privilege system and user management
4. Data model structures and serialization
5. Authentication flow and token management
6. Notification scheduling and delivery logic
7. Data synchronization and conflict resolution

### SAFE TO MODIFY:
1. UI components and styling (non-critical visual changes)
2. Non-critical helper methods and utilities
3. Test implementations and test data
4. Documentation and comments
5. Build configuration and deployment scripts
6. Animation and micro-interaction improvements
7. Accessibility enhancements that don't affect core logic

### ALWAYS PRESERVE:
1. State management patterns and BLoC architecture
2. Error handling mechanisms and logging infrastructure
3. Data synchronization logic and offline support
4. User privacy controls and security measures
5. Notification system reliability and delivery
6. Performance optimizations and memory management
7. Internationalization and accessibility features

### BEFORE MAKING CHANGES:
1. Read this file completely and understand the system architecture
2. Understand the impact on related components and dependencies
3. Check for existing tests that need updating or new tests required
4. Verify no breaking changes to public APIs and interfaces
5. Test admin functionality if changes affect user management
6. Consider performance implications for large datasets
7. Verify accessibility and internationalization support
8. Test on multiple platforms if UI changes are made

### KEY DEPENDENCIES:
- **Flutter BLoC**: State management and reactive programming
- **Firebase**: Backend services (Firestore, Auth, Storage, Functions)
- **Hive**: Local storage and offline caching
- **Flutter Local Notifications**: Notification management and scheduling
- **Google/Apple Sign-In**: Authentication providers
- **Flutter Localizations**: Internationalization support
- **Material Design 3**: UI framework and theming
- **Equatable**: Value equality for immutable objects

### DEVELOPMENT ENVIRONMENT:
- Flutter SDK (latest stable version)
- Dart SDK (compatible with Flutter version)
- Firebase project configuration
- Android Studio / VS Code with Flutter extensions
- Git version control with feature branch workflow
- Code formatting and linting with dart analyzer

This context file should be consulted before any modifications to ensure understanding of the complete system architecture, business logic, and development guidelines. Updates to this file should be made when significant architectural changes occur.
