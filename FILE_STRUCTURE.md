# Tazbeet App File Structure

## Overview
Tazbeet is a comprehensive task management and mood tracking Flutter application with BLoC state management architecture.

## Root Directory Structure

```
lib/
├── main.dart                    # App entry point with service initialization
├── firebase_options.dart        # Firebase configuration
├── blocs/                       # BLoC state management layer
├── models/                      # Data models and entities
├── services/                    # Business logic and services
├── ui/                          # User interface layer
├── repositories/                # Data access layer
├── providers/                   # Provider implementations
├── helpers/                     # Utility functions
├── utils/                       # General utilities
├── l10n/                        # Internationalization
└── _archive/                    # Archived code
```

## Detailed Structure

### 📁 Core Files

#### `main.dart`
- App entry point
- Service initialization and dependency injection
- BLoC providers setup
- Firebase and Hive initialization
- Material app configuration

#### `firebase_options.dart`
- Firebase project configuration
- Platform-specific settings

---

### 📁 BLoC State Management (`/blocs/`)

```
blocs/
├── auth/                         # Authentication state management
│   ├── auth_bloc.dart
│   ├── auth_event.dart
│   └── auth_state.dart
├── category/                     # Category management
│   ├── category_bloc.dart
│   ├── category_event.dart
│   └── category_state.dart
├── mood/                         # Mood tracking features
│   ├── mood_bloc.dart
│   ├── mood_event.dart
│   └── mood_state.dart
├── notification/                 # Notification system
│   ├── notification_bloc.dart
│   ├── notification_event.dart
│   └── notification_state.dart
├── task_details/                 # Individual task operations
│   ├── task_details_bloc.dart
│   ├── task_details_event.dart
│   └── task_details_state.dart
├── task_list/                    # Task list management
│   ├── task_list_bloc.dart
│   ├── task_list_event.dart
│   └── task_list_state.dart
├── user/                         # User profile management
│   ├── user_bloc.dart
│   ├── user_event.dart
│   └── user_state.dart
└── theme/                        # Theme management (empty)
```

---

### 📁 Data Models (`/models/`)

```
models/
├── Core Entities
│   ├── task.dart                 # Main task model (15.8KB)
│   ├── category.dart             # Category model
│   ├── user.dart                 # User profile model
│   ├── mood.dart                 # Mood entry model
│   └── app_settings.dart        # Application settings
├── Generated Models (*.g.dart)
│   ├── mood.g.dart              # JSON serialization for mood
│   ├── mood_achievement.g.dart
│   ├── mood_streak.g.dart
│   ├── notification_item.g.dart
│   ├── notification_preferences.g.dart
│   └── user.g.dart
├── Mood Tracking Models
│   ├── mood_achievement.dart     # Mood achievements system
│   ├── mood_insight.dart         # Mood analytics insights
│   ├── mood_streak.dart          # Mood tracking streaks
│   └── mood_tag.dart             # Mood tagging system
├── Notification Models
│   ├── notification_item.dart    # Individual notification (9.2KB)
│   └── notification_preferences.dart # Notification settings (9.5KB)
├── Pomodoro Models
│   ├── pomodoro_plan.dart        # Pomodoro session planning (7.9KB)
│   ├── pomodoro_strategy.dart    # Pomodoro strategies
│   ├── pomodoro_template_model.dart
│   └── pomodoro_templates.dart   # Template collection (13.1KB)
├── Task Models
│   ├── repeat_rule.dart          # Recurring task rules (5.8KB)
│   └── voice_task_result.dart    # Voice task processing results
```

---

### 📁 Services Layer (`/services/` - 56 files)

#### Core Business Services
```
services/
├── Authentication & User Management
│   ├── auth_service.dart         # Authentication logic (13.4KB)
│   ├── user_repository.dart      # User data operations
│   └── onboarding_service.dart   # User onboarding flow
├── Task Management
│   ├── task_analytics.dart       # Task analytics (16.7KB)
│   ├── repeat_service.dart        # Recurring task logic (7.9KB)
│   ├── smart_task_selector.dart  # Intelligent task selection (10.4KB)
│   └── voice_task_service.dart   # Voice task processing (12.6KB)
├── Pomodoro System
│   ├── pomodoro_service.dart     # Core Pomodoro logic (21.2KB)
│   ├── adaptive_pomodoro.dart    # Adaptive timing (13.7KB)
│   ├── pomodoro_planner.dart     # Session planning (15.5KB)
│   ├── pomodoro_planner_service.dart
│   ├── pomodoro_recommendation_engine.dart (18.9KB)
│   ├── pomodoro_notification_service.dart (17.3KB)
│   ├── pomodoro_audio_manager.dart
│   └── pomodoro_service_locator.dart
├── Mood Tracking
│   ├── mood_insights_service.dart # Mood analytics (10.1KB)
│   ├── mood_achievement_service.dart (6.4KB)
│   ├── mood_context_service.dart  # Mood context analysis (10.7KB)
│   └── mood_export_service.dart   # Data export functionality
├── Notification System
│   ├── notification_service.dart  # Core notification logic (31.6KB)
│   ├── notification_verification_service.dart
│   └── pomodoro_notification_service.dart
├── Data Management
│   ├── data_sync_service.dart     # Data synchronization (19.8KB)
│   ├── data_management_service.dart (5.6KB)
│   ├── data_validation_service.dart (14.8KB)
│   ├── sync_queue.dart           # Sync queue management (8.5KB)
│   └── sync_status_service.dart  # Sync status monitoring
├── Settings & Configuration
│   ├── settings_service.dart      # App settings (16.4KB)
│   ├── theme_service.dart         # Theme management (10.5KB)
│   ├── color_customization_service.dart
│   └── navigation_service.dart    # Navigation utilities
├── Analytics & Monitoring
│   ├── analytics_service.dart     # App analytics (12.9KB)
│   ├── performance_monitor_service.dart
│   ├── performance_optimization_service.dart (16.4KB)
│   ├── logging_monitoring_service.dart (22.9KB)
│   └── app_logging_service.dart   # Application logging
├── Error Handling & Maintenance
│   ├── error_handling_service.dart (15.4KB)
│   ├── error_notification_service.dart
│   ├── maintenance_service.dart   # App maintenance (5.8KB)
│   └── emergency_service.dart     # Emergency procedures
├── Focus & Productivity
│   ├── focus_mode.dart           # Focus mode features (14.5KB)
│   ├── ambient_service.dart       # Ambient sounds (5.8KB)
│   ├── session_chain.dart        # Session chaining (9.9KB)
│   └── achievement_system.dart    # Achievement tracking (19.4KB)
├── Infrastructure Services
│   ├── background_service.dart   # Background processing
│   ├── accessibility_service.dart # Accessibility features (20.7KB)
│   ├── memory_manager_service.dart
│   ├── animation_optimizer_service.dart
│   ├── code_quality_monitor_service.dart
│   ├── firebase_service_wrapper.dart
│   ├── localization_service.dart
│   ├── tutorial_service.dart      # Tutorial system (10.3KB)
│   ├── update_service.dart        # App updates
│   ├── task_sound_service.dart    # Task sound effects
│   ├── progress_service.dart      # Progress tracking
│   └── enhanced_progress.dart    # Enhanced progress features (15.2KB)
```

---

### 📁 UI Layer (`/ui/`)

#### Screens (`/ui/screens/` - 42 files)
```
screens/
├── Main Navigation
│   ├── home/
│   │   ├── main_screen.dart       # Main app container (68.5KB)
│   │   ├── home_screen.dart       # Home screen (90.3KB)
│   │   ├── category_screen.dart   # Category management (38.5KB)
│   │   ├── progress_screen.dart   # Progress tracking (14.8KB)
│   │   ├── mood/                  # Mood-related screens
│   │   │   ├── mood_screen.dart
│   │   │   ├── mood_insights_screen.dart
│   │   │   ├── mood_achievements_screen.dart
│   │   │   ├── mood_settings_screen.dart (16.1KB)
│   │   │   ├── mood_calendar_screen.dart
│   │   │   ├── mood_statistics_screen.dart
│   │   │   └── mood_export_screen.dart
│   │   └── pomodoro/             # Pomodoro screens
│   │       ├── pomodoro_screen.dart
│   │       ├── pomodoro_settings_screen.dart
│   │       ├── pomodoro_stats_screen.dart
│   │       └── pomodoro_templates_screen.dart
│   ├── splash_screen.dart         # App splash screen (16.3KB)
│   ├── onboarding_screen.dart     # User onboarding (23.4KB)
│   ├── login_screen.dart          # User authentication (31.1KB)
│   └── registration_screen.dart   # User registration (14.2KB)
├── Task Management
│   ├── add_task_screen.dart       # Add new task (17.1KB)
│   ├── edit_task_screen.dart      # Edit existing task (14.1KB)
│   ├── task_details_screen.dart   # Task details view (45.4KB)
│   ├── subtask_details_screen.dart # Subtask management (37.1KB)
│   └── recurring_tasks_screen.dart # Recurring tasks (605B)
├── Settings & Configuration
│   ├── settings_screen.dart       # Main settings (52.5KB)
│   ├── theme_settings_screen.dart # Theme configuration (13.8KB)
│   ├── notification_preferences_screen.dart (28.7KB)
│   ├── mood_settings_screen.dart  # Mood settings (16.1KB)
│   └── data_management_screen.dart # Data management (7.8KB)
├── Notification System
│   ├── notification_history_screen.dart # Notification history (24.5KB)
│   ├── notification_test_screen.dart    # Notification testing (12KB)
│   ├── notifications_dashboard.dart     # Notification dashboard (13.2KB)
│   └── notification_preferences_screen.dart (28.7KB)
├── Voice Features
│   ├── voice_task_screen.dart     # Voice task interface (15.3KB)
│   ├── voice_task_dashboard.dart  # Voice task dashboard (13.7KB)
│   └── voice_task_confirmation.dart
├── Analytics & Insights
│   └── analytics/                # Analytics screens
│       └── analytics_screen.dart
├── Admin & Development
│   ├── admin_panel_screen.dart    # Admin panel (51.3KB)
│   ├── developer_tools_screen.dart # Developer tools (14KB)
│   └── maintenance_screen.dart    # Maintenance tools (8.6KB)
├── Special Features
│   ├── ambient_screen.dart        # Ambient sounds (6.3KB)
│   ├── emergency_screen.dart     # Emergency procedures (8.2KB)
│   ├── profile_screen.dart       # User profile (16.3KB)
│   └── smart_features_tutorial.dart # Feature tutorial (14.7KB)
```

#### Widgets (`/ui/widgets/` - 49 files)
```
widgets/
├── Task Management Widgets
│   ├── task_item.dart            # Task list item (14.3KB)
│   ├── subtask_widget.dart       # Subtask component (19.9KB)
│   ├── add_task_dialog.dart      # Add task dialog (10.2KB)
│   ├── edit_task_dialog.dart     # Edit task dialog (14.3KB)
│   ├── recurring_tasks_manager.dart # Recurring tasks (8.9KB)
│   ├── repeat_config_widget.dart  # Repeat configuration (7.8KB)
│   └── priority_indicator.dart    # Task priority indicator
├── Mood Widgets
│   └── mood/                     # Mood-specific widgets (10 files)
│       ├── mood_card.dart
│       ├── mood_chart.dart
│       ├── mood_input_widget.dart
│       ├── mood_insight_card.dart
│       ├── mood_achievement_widget.dart
│       ├── mood_streak_widget.dart
│       ├── mood_calendar_widget.dart
│       ├── mood_statistics_widget.dart
│       ├── mood_export_widget.dart
│       └── mood_tag_selector.dart
├── Voice Task Widgets
│   ├── voice_task_recorder.dart  # Voice recording interface (13.3KB)
│   ├── voice_task_confirmation.dart # Voice confirmation (11.9KB)
│   ├── voice_task_fab.dart       # Voice FAB button (7.6KB)
│   ├── voice_task_integration.dart # Voice integration (9.5KB)
│   └── voice_task_tutorial.dart  # Voice tutorial (8.3KB)
├── Common UI Components
│   ├── enhanced_search_bar.dart  # Advanced search (7.8KB)
│   ├── filter_dialog.dart        # Filter options (6KB)
│   ├── optimized_filter_chips.dart # Filter chips (5.4KB)
│   ├── calendar_section.dart     # Calendar view (11.6KB)
│   ├── empty_state.dart          # Empty state display
│   ├── loading_skeleton.dart     # Loading skeleton
│   ├── error_display.dart        # Error display widget
│   └── search_bar.dart           # Basic search bar
├── Progress & Analytics
│   ├── progress_indicator_card.dart # Progress indicator (5.3KB)
│   ├── circular_progress_card.dart # Circular progress
│   ├── task_list_section.dart    # Task list section (8.3KB)
│   └── quick_actions_card.dart   # Quick actions (5.1KB)
├── Notification Widgets
│   ├── notification_preview_card.dart # Notification preview (8KB)
│   ├── notification_quick_actions.dart # Quick actions (6.4KB)
│   └── notification_stats_widget.dart # Notification stats (9.8KB)
├── Design System
│   ├── gradient_card.dart        # Gradient card component
│   ├── floating_shapes.dart      # Floating background shapes
│   ├── hero_section.dart         # Hero section (6.8KB)
│   └── animated_expansion_card.dart # Animated card
├── Home Screen Widgets
│   └── home/                     # Home-specific widgets (3 files)
│       ├── home_fab.dart
│       ├── home_header.dart
│       └── home_stats_card.dart
├── Common Widgets
│   └── common/                   # Shared widgets (2 files)
│       ├── custom_app_bar.dart
│       └── bottom_nav_bar.dart
└── Utility Widgets
    ├── sync_status_indicator.dart # Sync status (4.2KB)
    ├── color_customization_widget.dart # Color picker (4KB)
    └── password_strength_indicator.dart # Password strength
```

#### UI Support (`/ui/`)
```
ui/
├── controllers/                  # Screen controllers (6 files)
│   ├── home_controller.dart
│   ├── mood_controller.dart
│   ├── pomodoro_controller.dart
│   ├── task_controller.dart
│   ├── notification_controller.dart
│   └── settings_controller.dart
├── design_system/               # Design system components (6 files)
│   ├── colors.dart
│   ├── typography.dart
│   ├── spacing.dart
│   ├── shadows.dart
│   ├── animations.dart
│   └── components.dart
├── helpers/                     # UI helpers (1 file)
│   └── screen_utils.dart
├── themes/                      # Theme definitions (2 files)
│   ├── app_theme.dart
│   └── dark_theme.dart
└── utils/                       # UI utilities (1 file)
    └── form_validators.dart
```

---

### 📁 Data Layer (`/repositories/`)

```
repositories/
├── task_repository.dart          # Task data operations (3KB)
├── category_repository.dart     # Category management (4.3KB)
├── mood_repository.dart         # Mood data operations (5.4KB)
├── notification_repository.dart # Notification data (12.6KB)
└── user_repository.dart         # User data operations (2.5KB)
```

---

### 📁 Support Directories

#### Helpers (`/helpers/`)
```
helpers/
└── date_helper.dart             # Date manipulation utilities
```

#### Providers (`/providers/`)
```
providers/
└── app_state_provider.dart      # Global app state provider
```

#### Utils (`/utils/`)
```
utils/
├── constants.dart               # App constants
└── extensions.dart              # Dart extensions
```

#### Internationalization (`/l10n/`)
```
l10n/
├── app_localizations.dart       # Localization setup
├── app_localizations.ar.dart    # Arabic translations
├── app_localizations.en.dart    # English translations
├── app_localizations.es.dart    # Spanish translations
├── app_localizations.fr.dart    # French translations
├── app_localizations.de.dart    # German translations
├── app_localizations.it.dart    # Italian translations
├── app_localizations.ja.dart    # Japanese translations
├── app_localizations.zh.dart    # Chinese translations
└── app_localizations_ru.dart    # Russian translations
```

#### Archive (`/_archive/`)
```
_archive/
├── old_auth_system.dart         # Deprecated auth system
├── legacy_task_manager.dart     # Old task management
├── deprecated_widgets.dart      # Old widget implementations
├── old_notification_system.dart # Legacy notification system
└── experimental_features.dart   # Experimental features
```

---

## Key Features & Architecture Patterns

### 🎯 Core Features
1. **Task Management**
   - Create, edit, delete tasks
   - Subtask support
   - Recurring tasks with complex rules
   - Priority levels and categories
   - Voice task creation

2. **Mood Tracking**
   - Daily mood entries
   - Mood insights and analytics
   - Achievement system
   - Streak tracking
   - Export functionality

3. **Pomodoro Timer**
   - Adaptive timing
   - Session planning
   - Recommendation engine
   - Template system
   - Audio notifications

4. **Notification System**
   - Smart notifications
   - Preferences management
   - History tracking
   - Quick actions

5. **Analytics & Insights**
   - Task analytics
   - Performance monitoring
   - Progress tracking
   - Mood insights

### 🏗️ Architecture Patterns
- **BLoC Pattern** for state management
- **Repository Pattern** for data access
- **Service Layer** for business logic
- **Dependency Injection** through providers
- **Clean Architecture** principles

### 🔧 Technologies & Libraries
- **Flutter** for UI framework
- **BLoC** for state management
- **Hive** for local storage
- **Firebase** for backend services
- **Provider** for dependency injection
- **Localizations** for multi-language support

---

## File Size Summary

### Largest Files
1. `home_screen.dart` - 90.3KB (Complex home screen)
2. `main_screen.dart` - 68.5KB (Main navigation container)
3. `admin_panel_screen.dart` - 51.3KB (Admin functionality)
4. `settings_screen.dart` - 52.5KB (Settings management)
5. `task_details_screen.dart` - 45.4KB (Task details)
6. `notification_service.dart` - 31.6KB (Core notification logic)
7. `pomodoro_service.dart` - 21.2KB (Pomodoro core logic)
8. `login_screen.dart` - 31.1KB (Authentication)
9. `task.dart` - 15.8KB (Main task model)
10. `logging_monitoring_service.dart` - 22.9KB (Logging system)

### Service Layer Distribution
- **Core Services**: ~200KB total
- **Pomodoro Features**: ~100KB total
- **Mood Features**: ~35KB total
- **Analytics & Monitoring**: ~60KB total
- **Infrastructure**: ~50KB total

---

## Development Notes

### State Management Flow
```
UI Events → BLoC Events → BLoC States → UI Updates
     ↓           ↓            ↓
Services → Repositories → Data Models
```

### Key Dependencies
- Flutter BLoC for state management
- Hive for local data persistence
- Firebase for cloud services
- Provider for dependency injection
- Localizations for i18n support

### Performance Considerations
- Large screens are split into smaller widgets
- Services are optimized for performance
- Lazy loading for heavy components
- Memory management services included

This structure represents a mature, feature-rich Flutter application with comprehensive task management, mood tracking, and productivity features.
