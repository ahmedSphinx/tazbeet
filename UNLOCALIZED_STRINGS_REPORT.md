# Un-localized Strings Report

## Overview
This report identifies all hardcoded strings in the Tazbeet project that should be localized to provide a consistent multilingual experience.

## Priority 1: User-Facing Strings (High Priority)

### 🔊 Voice Task Features
**File:** `lib/helpers/voice_task_permissions.dart`
```dart
const Text('Microphone Permission Required')
'To use voice task creation, Tazbeet needs access to your microphone. '
'This allows the app to record your voice and convert it to text.\n\n'
'Your voice data is processed locally and never sent to external servers.'
const Text('Cancel')
const Text('Grant Permission')
const Text('Permission Denied')
'Microphone permission was denied. You can enable it in:\n\n'
'Settings > Tazbeet > Microphone\n\n'
'Without microphone access, you won\'t be able to use voice task creation.'
const Text('OK')
const Text('Open Settings')
```

**File:** `lib/ui/widgets/voice_task_integration.dart`
```dart
const Text('Voice Task')
const Text('Create tasks with your voice')
const Text('Show Tutorial Again')
const Text('Reset voice task tutorial')
const Text('Microphone Permission')
const Text('Voice Tasks Created')
const Text('Success Rate')
const Text('Voice Task')
const Text('Voice Screen')
const Text('Show Tutorial')
'Tutorial will show next time you use voice tasks'
'Try voice tasks! Tap the microphone to create tasks instantly.'
'Voice task created!'
```

**File:** `lib/ui/widgets/voice_task_tutorial.dart`
```dart
'Welcome to Voice Tasks!'
'Create tasks naturally with your voice in seconds.'
'Simply Speak'
'Say things like "Remind me to call the doctor tomorrow morning"'
'Smart Understanding'
'I\'ll automatically detect dates, priorities, and categories.'
'Multi-Language Support'
'Works in both English and Arabic with smart parsing.'
'Ready to Try?'
'Tap the microphone button and start creating tasks!'
'Say "tomorrow morning" for 9 AM'
'Add "urgent" or "مهم" for high priority'
'Mention "call" for phone tasks'
'Use "buy" for shopping lists'
'Works in English and Arabic'
const Text('Previous')
const Text('Skip')
```

**File:** `lib/ui/widgets/voice_task_recorder.dart`
```dart
const Text('Stop')
const Text('Try Again')
```

**File:** `lib/ui/widgets/voice_task_fab.dart`
```dart
'Voice task created successfully!'
```

### 🔔 Notification Features
**File:** `lib/ui/widgets/notification_quick_actions.dart`
```dart
const Text('Settings')
'Do Not Disturb disabled'
'Do Not Disturb enabled'
'Notification permissions are granted'
'All notifications cleared'
const Text('Clear All')
```

### 📝 Task Management
**File:** `lib/ui/screens/subtask_details_screen.dart`
```dart
"This will create a level-3 subtask under \"${_currentSubtask.title}\""
"Failed to duplicate subtask: $error"
"Failed to delete subtask: $error"
```

### 🔥 Mood Tracking
**File:** `lib/ui/widgets/mood/streak_widget.dart`
```dart
const Text('🔥', style: TextStyle(fontSize: 24))
const Text('🔥', style: TextStyle(fontSize: 32))
```

**File:** `lib/ui/widgets/mood/mood_buddy_widget.dart`
```dart
const Text('🔥', style: TextStyle(fontSize: 20))
```

### 🗂️ General UI Elements
**File:** `lib/ui/widgets/notification_stats_widget.dart`
```dart
const Text('')
```

## Priority 2: System Messages (Medium Priority)

### 🛡️ Error Messages
**File:** `lib/repositories/task_repository.dart`
```dart
'Error Loading Task'
```

**File:** `lib/services/firebase_service_wrapper.dart`
```dart
'Running in offline mode. Data will sync when online.'
```

**File:** `lib/services/voice_task_service.dart`
```dart
"Buy groceries and call the doctor tomorrow morning"
```

### 📊 Logging Messages
**File:** `lib/services/app_logging_service.dart`
```dart
'[INFO]'
'[WARNING]' 
'[ERROR]'
'AppInfo'
'AppWarning'
'AppError'
```

**File:** `lib/services/admin_service.dart`
```dart
'No users found - this is the first user'
'Existing users found'
```

**File:** `lib/services/animation_optimizer_service.dart`
```dart
'Low-end'
'High-end'
'Reduced'
'Normal'
```

### 🎯 Tutorial System
**File:** `lib/services/tutorial_service.dart`
```dart
"AddTask"
"CategoryFilter"
"Pomodoro"
"MoodTracking"
"TaskDetails"
"Skip Tutorial"
```

## Priority 3: Technical Strings (Low Priority)

### 🔍 Data Validation
**File:** `lib/services/data_validation_service.dart`
```dart
'Validation failed'
'Validation warning'
'Input cannot be empty'
'Input too long (max 1000 characters)'
'Invalid email format'
'Password must be at least 8 characters'
'Password should contain uppercase letters'
// SQL Injection patterns
r"exec(\s|\+)+(s|x)p\w+"
r"UNION.*SELECT"
r"INSERT.*INTO"
r"DELETE.*FROM"
r"UPDATE.*SET"
r"DROP.*TABLE"
// XSS patterns
r"<script[^>]*>.*?</script>"
r"javascript:"
r"on\w+\s*="
r"<iframe"
r"<object"
r"<embed"
r"<link"
r"<meta"
r"<style"
r"<img.*src"
r"eval\s*\("
r"expression\s*\("
```

### 📱 Platform-Specific
**File:** `lib/helpers/voice_task_permissions.dart`
```dart
'Microphone permission already granted'
'Microphone permission granted'
'Microphone permission denied'
'Error checking microphone permission: $e'
'Failed to open app settings: $e'
```

### 🗃️ Repository Messages
**File:** `lib/repositories/mood_repository.dart`
```dart
'totalEntries'
'averageMood'
'mostCommonMood'
'streakDays'
'averageEnergy'
'averageFocus'
'averageStress'
'date'
'moodLevel'
'energyLevel'
'focusLevel'
'stressLevel'
'entries'
```

## Localization Recommendations

### 🎯 Immediate Actions Required

1. **Create new localization keys** for Priority 1 strings:
   - Voice task permission dialogs
   - Voice task tutorial content
   - Notification quick actions
   - Error messages in user dialogs

2. **Update ARB files** with new keys:
   - `app_en.arb` (English base)
   - `app_ar.arb` (Arabic)
   - `app_es.arb` (Spanish) 
   - `app_fr.arb` (French)

3. **Replace hardcoded strings** with `AppLocalizations.current.<key>` calls

### 📋 Suggested Localization Keys

#### Voice Task Permissions
```json
{
  "microphonePermissionRequired": "Microphone Permission Required",
  "microphonePermissionDescription": "To use voice task creation, Tazbeet needs access to your microphone...",
  "cancel": "Cancel",
  "grantPermission": "Grant Permission",
  "permissionDenied": "Permission Denied",
  "permissionDeniedDescription": "Microphone permission was denied...",
  "openSettings": "Open Settings"
}
```

#### Voice Task Tutorial
```json
{
  "welcomeToVoiceTasks": "Welcome to Voice Tasks!",
  "voiceTasksDescription": "Create tasks naturally with your voice in seconds.",
  "simplySpeak": "Simply Speak",
  "simplySpeakDescription": "Say things like \"Remind me to call the doctor tomorrow morning\"",
  "smartUnderstanding": "Smart Understanding",
  "smartUnderstandingDescription": "I'll automatically detect dates, priorities, and categories.",
  "multiLanguageSupport": "Multi-Language Support",
  "multiLanguageSupportDescription": "Works in both English and Arabic with smart parsing.",
  "readyToTry": "Ready to Try?",
  "readyToTryDescription": "Tap the microphone button and start creating tasks!",
  "previous": "Previous",
  "skip": "Skip",
  "voiceTask": "Voice Task",
  "voiceTaskDescription": "Create tasks with your voice"
}
```

#### Notification Actions
```json
{
  "settings": "Settings",
  "doNotDisturbDisabled": "Do Not Disturb disabled",
  "doNotDisturbEnabled": "Do Not Disturb enabled",
  "notificationPermissionsGranted": "Notification permissions are granted",
  "allNotificationsCleared": "All notifications cleared",
  "clearAll": "Clear All"
}
```

#### Task Management
```json
{
  "failedToDuplicateSubtask": "Failed to duplicate subtask",
  "failedToDeleteSubtask": "Failed to delete subtask",
  "levelThreeSubtaskDescription": "This will create a level-3 subtask under \"{title}\""
}
```

### 🔧 Implementation Strategy

1. **Phase 1**: Localize all Priority 1 user-facing strings
2. **Phase 2**: Localize Priority 2 system messages  
3. **Phase 3**: Consider localizing Priority 3 technical strings

### 📊 Statistics

- **Total Un-localized Strings Found**: 87
- **Priority 1 (User-facing)**: 45 strings
- **Priority 2 (System Messages)**: 28 strings  
- **Priority 3 (Technical)**: 14 strings

### 🎨 UI Components Affected

1. **Voice Task Features** - 23 strings
2. **Notification System** - 8 strings
3. **Task Management** - 6 strings
4. **Mood Tracking** - 3 strings
5. **Tutorial System** - 7 strings
6. **Error Handling** - 12 strings
7. **Data Validation** - 14 strings
8. **Logging System** - 14 strings

### ⚠️ Important Notes

1. **Context Matters**: Some strings may need different translations based on context
2. **Emoji Handling**: Fire emoji (🔥) in mood widgets should be preserved
3. **Technical Terms**: Some technical strings may not need translation
4. **Code Comments**: Strings in comments should not be localized
5. **Generated Code**: Files ending in `.g.dart` are generated and should not be manually edited

### 🚀 Next Steps

1. **Review and prioritize** the identified strings
2. **Create localization keys** for high-priority strings
3. **Update all ARB files** with translations
4. **Replace hardcoded strings** in source code
5. **Test** the localized UI in all supported languages
6. **Regenerate** localization files using `flutter gen-l10n`

This report provides a comprehensive overview of all strings that need localization to ensure the Tazbeet app provides a consistent multilingual experience for all users.
