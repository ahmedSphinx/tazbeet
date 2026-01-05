// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tazbeet';

  @override
  String get homeScreenTitle => 'Home';

  @override
  String get settingsScreenTitle => 'Settings';

  @override
  String get languageLabel => 'Language';

  @override
  String get themeLabel => 'Theme';

  @override
  String get darkTheme => 'Dark';

  @override
  String get lightTheme => 'Light';

  @override
  String get systemTheme => 'System';

  @override
  String get saveButton => 'Save';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get taskTitleLabel => 'Task Title';

  @override
  String get taskDescriptionLabel => 'Description (Optional)';

  @override
  String get addTaskButton => 'Add Task';

  @override
  String get editTaskButton => 'Edit Task';

  @override
  String get deleteTaskButton => 'Delete Task';

  @override
  String confirmDeleteTask(String taskTitle) {
    return 'Are you sure you want to delete this task?';
  }

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get resetButton => 'Reset';

  @override
  String get appearanceSection => 'Appearance';

  @override
  String get notificationsSection => 'Notifications';

  @override
  String get notificationHistory => 'Notification History';

  @override
  String get notificationPreferences => 'Notification Preferences';

  @override
  String get pomodoroSection => 'Pomodoro Timer';

  @override
  String get dataBackupSection => 'Data & Backup';

  @override
  String get privacyAnalyticsSection => 'Privacy & Analytics';

  @override
  String get regionalSection => 'Regional';

  @override
  String get moodSettingsTitle => 'Mood Settings';

  @override
  String get moodSettingsSubtitle => 'Configure mood check-in notifications';

  @override
  String get enableMoodNotifications => 'Enable Mood Notifications';

  @override
  String get moodCheckInTimes => 'Check-in Times';

  @override
  String get add => 'Add';

  @override
  String get suggestTimes => 'Suggest Times';

  @override
  String get completedTasks => 'Completed tasks';

  @override
  String get work => 'Work';

  @override
  String get shortBreak => 'Short Break';

  @override
  String get longBreak => 'Long Break';

  @override
  String get paused => 'Paused';

  @override
  String get idle => 'Idle';

  @override
  String get pomodoroSessionCompleted => 'Pomodoro Session Completed';

  @override
  String get highPriorityLabel => 'High';

  @override
  String get mediumPriorityLabel => 'Medium';

  @override
  String get lowPriorityLabel => 'Low';

  @override
  String get addTaskTitle => 'Add New Task';

  @override
  String get priorityLabel => 'Priority:';

  @override
  String get dueDateLabel => 'Due Date (Optional)';

  @override
  String get selectDueDate => 'Select due date';

  @override
  String get categoryLabel => 'Category (Optional)';

  @override
  String get noCategory => 'No Category';

  @override
  String get repeatSettings => 'Repeat Settings';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get editTaskTitle => 'Edit Task';

  @override
  String get updateButton => 'Update';

  @override
  String get ambientSounds => 'Ambient Sounds';

  @override
  String get focusAndRelaxation => 'Focus & Relaxation';

  @override
  String get chooseBackgroundSound => 'Choose a background sound to help you concentrate or relax';

  @override
  String get volume => 'Volume';

  @override
  String get fadeIn => 'Fade In';

  @override
  String get fadeOut => 'Fade Out';

  @override
  String get noCategoriesYet => 'No categories yet';

  @override
  String get createCategoriesToOrganize => 'Create categories to organize your tasks';

  @override
  String get createCategory => 'Create Category';

  @override
  String get edit => 'Edit';

  @override
  String get addCategory => 'Add Category';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get categoryName => 'Category Name';

  @override
  String get enterCategoryName => 'Enter category name';

  @override
  String get color => 'Color:';

  @override
  String get pickAColor => 'Pick a color';

  @override
  String get select => 'Select';

  @override
  String get deleteCategory => 'Delete Category';

  @override
  String confirmDeleteCategory(String categoryName) {
    return 'Are you sure you want to delete \"$categoryName\"? This will remove the category from all associated tasks.';
  }

  @override
  String tasksCount(int count) {
    return '$count tasks';
  }

  @override
  String get selectButton => 'Select';

  @override
  String get pause => 'Pause';

  @override
  String get start => 'Start';

  @override
  String get stop => 'Stop';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get statistics => 'Statistics';

  @override
  String get overview => 'Overview';

  @override
  String get week => 'Week';

  @override
  String get month => 'Month';

  @override
  String get streak => 'Streak';

  @override
  String get productivityScore => 'Productivity Score';

  @override
  String get weeklyProgress => 'Weekly Progress';

  @override
  String get categoryProgress => 'Category Progress';

  @override
  String get totaltasks => 'Total Tasks';

  @override
  String get dueDate => 'Due Date';

  @override
  String get overdue => 'Overdue';

  @override
  String get dueThisWeek => 'Due This Week';

  @override
  String get logMood => 'Log Your Mood';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get energyLevel => 'Energy Level';

  @override
  String get focusLevel => 'Focus Level';

  @override
  String get stressLevel => 'Stress Level';

  @override
  String get saveMood => 'Save Mood';

  @override
  String get veryBad => 'Very Bad';

  @override
  String get bad => 'Bad';

  @override
  String get neutral => 'Neutral';

  @override
  String get good => 'Good';

  @override
  String get veryGood => 'Very Good';

  @override
  String get moodCheckInTitle => 'Mood Check-In';

  @override
  String get moodHowAreYouFeeling => 'How are you feeling?';

  @override
  String get moodSelectLevel => 'Select your mood level';

  @override
  String get moodEnergyLevel => 'Energy Level';

  @override
  String get moodFocusLevel => 'Focus Level';

  @override
  String get moodStressLevel => 'Stress Level';

  @override
  String get low => 'Low';

  @override
  String get high => 'High';

  @override
  String get moodNoteOptional => 'Add a note (optional)';

  @override
  String get moodNoteHint => 'How are you feeling?';

  @override
  String get moodSaveButton => 'Save Mood';

  @override
  String get moodVeryBad => 'Very Bad';

  @override
  String get moodBad => 'Bad';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodGood => 'Good';

  @override
  String get moodVeryGood => 'Very Good';

  @override
  String get moodSavedSuccess => 'Mood saved successfully!';

  @override
  String get moodSaveFailed => 'Failed to save mood';

  @override
  String get save => 'Save';

  @override
  String get noCategoriesYetDescription => 'Create categories to organize your tasks';

  @override
  String get editButton => 'Edit';

  @override
  String get deleteButton => 'Delete';

  @override
  String get addButton => 'Add';

  @override
  String get emergencyControls => 'Emergency Controls';

  @override
  String get emergencyMode => 'Emergency Mode';

  @override
  String get activateEmergencyMode => 'Activate emergency mode to suspend all reminders and timers';

  @override
  String get emergencyModeActive => 'Emergency Mode Active';

  @override
  String get allRemindersSuspended => 'All reminders and timers are suspended';

  @override
  String get emergencyModeInactive => 'Emergency Mode';

  @override
  String get suspendRemindersTimers => 'Suspend all reminders and timers immediately';

  @override
  String get quickControls => 'Quick Controls';

  @override
  String get fifteenMinPause => '15 Min Pause';

  @override
  String get oneHourPause => '1 Hour Pause';

  @override
  String get resumeAll => 'Resume All';

  @override
  String get remindersSuspended => 'Reminders Suspended';

  @override
  String timeRemaining(String time) {
    return 'Time remaining: $time';
  }

  @override
  String get resumeNow => 'Resume Now';

  @override
  String get moodHistory => 'Mood History';

  @override
  String get noMoodEntriesYet => 'No mood entries yet';

  @override
  String get startLoggingMoods => 'Start logging your moods to see your history';

  @override
  String get moodHistoryTitle => 'Mood History';

  @override
  String get startTracking => 'Start tracking your mood journey';

  @override
  String get quickMoodCheckIn => 'Quick Mood Check-In';

  @override
  String moodsForDate(Object date) {
    return 'Moods for $date';
  }

  @override
  String get close => 'Close';

  @override
  String get filter => 'Filter';

  @override
  String get all => 'All';

  @override
  String get positive => 'Positive';

  @override
  String get negative => 'Negative';

  @override
  String get recent => 'Recent';

  @override
  String get energy => 'Energy';

  @override
  String get focus => 'Focus';

  @override
  String get stress => 'Stress';

  @override
  String get howAreYou => 'How are you?';

  @override
  String get yourMood => 'Your mood';

  @override
  String get howAreYouFeelingRightNow => 'How are you feeling right now?';

  @override
  String get tapOptionBestDescribesMood => 'Tap the option that best describes your mood';

  @override
  String get addNoteOptional => 'Add a note (optional)';

  @override
  String get whatsOnYourMind => 'What\'s on your mind?';

  @override
  String get moodAdded => 'Mood added';

  @override
  String get moodUpdated => 'Mood updated';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get reallyStruggling => 'Really struggling';

  @override
  String get notGreat => 'Not great';

  @override
  String get okay => 'Okay';

  @override
  String get prettyGood => 'Pretty good';

  @override
  String get great => 'Great';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String get rain => 'Rain';

  @override
  String get oceanWaves => 'Ocean Waves';

  @override
  String get forest => 'Forest';

  @override
  String get whiteNoise => 'White Noise';

  @override
  String get coffeeShop => 'Coffee Shop';

  @override
  String get fireplace => 'Fireplace';

  @override
  String get wind => 'Wind';

  @override
  String get thunderstorm => 'Thunderstorm';

  @override
  String get taskCompleted => 'Task completed!';

  @override
  String get taskDeleted => 'Task deleted';

  @override
  String get categoryCreated => 'Category created';

  @override
  String get categoryDeleted => 'Category deleted';

  @override
  String get pomodoroStarted => 'Pomodoro session started';

  @override
  String get pomodoroCompleted => 'Pomodoro session completed';

  @override
  String get breakTime => 'Break time!';

  @override
  String get workTime => 'Work time!';

  @override
  String get sessionComplete => 'Session complete';

  @override
  String get allSessionsComplete => 'All sessions complete';

  @override
  String get progressSaved => 'Progress saved';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get dataExported => 'Data exported successfully';

  @override
  String get dataImported => 'Data imported successfully';

  @override
  String get backupCreated => 'Backup created';

  @override
  String get backupRestored => 'Backup restored';

  @override
  String get notificationEnabled => 'Notifications enabled';

  @override
  String get notificationDisabled => 'Notifications disabled';

  @override
  String get soundEnabled => 'Sound enabled';

  @override
  String get soundDisabled => 'Sound disabled';

  @override
  String get vibrationEnabled => 'Vibration enabled';

  @override
  String get vibrationDisabled => 'Vibration disabled';

  @override
  String get highContrastEnabled => 'High contrast enabled';

  @override
  String get highContrastDisabled => 'High contrast disabled';

  @override
  String get largeTextEnabled => 'Large text enabled';

  @override
  String get largeTextDisabled => 'Large text disabled';

  @override
  String get screenReaderEnabled => 'Screen reader enabled';

  @override
  String get screenReaderDisabled => 'Screen reader disabled';

  @override
  String get autoBackupEnabled => 'Auto backup enabled';

  @override
  String get autoBackupDisabled => 'Auto backup disabled';

  @override
  String get analyticsEnabled => 'Analytics enabled';

  @override
  String get analyticsDisabled => 'Analytics disabled';

  @override
  String get crashReportingEnabled => 'Crash reporting enabled';

  @override
  String get crashReportingDisabled => 'Crash reporting disabled';

  @override
  String get allCategories => 'All Categories';

  @override
  String get tapToAddFirstTask => 'Tap the + button to add your first task';

  @override
  String get deleteTaskTitle => 'Delete Task';

  @override
  String get filterTasksTitle => 'Filter Tasks';

  @override
  String get allLabel => 'All';

  @override
  String get incompleteLabel => 'Incomplete';

  @override
  String get completedLabel => 'Completed';

  @override
  String get applyButton => 'Apply';

  @override
  String get clearAllButton => 'Clear All';

  @override
  String get profileScreenTitle => 'Profile';

  @override
  String get nameLabel => 'Name';

  @override
  String get birthdayLabel => 'Birthday';

  @override
  String get selectBirthday => 'Select birthday';

  @override
  String get profileSaved => 'Profile saved successfully';

  @override
  String get pleaseFixErrors => 'Please fix the errors above';

  @override
  String get splashAppName => 'Tazbeet';

  @override
  String get splashTagline => 'Your Personal Task Manager';

  @override
  String get splashBranding => 'Stay Organized, Stay Productive';

  @override
  String get splashVersion => 'Version 1.0.0';

  @override
  String get loginSubtitle => 'Organize your tasks and boost productivity';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get termsAndPrivacy => 'By signing in, you agree to our Terms of Service and Privacy Policy';

  @override
  String get moodTracking => 'Mood Tracking';

  @override
  String get ambientMode => 'Ambient Mode';

  @override
  String get emergency => 'Emergency';

  @override
  String get profile => 'Profile';

  @override
  String get signOut => 'Sign Out';

  @override
  String get noTasksYet => 'No tasks yet';

  @override
  String get noTasksInCategory => 'No tasks in this category';

  @override
  String get addTaskToGetStarted => 'Add a task to get started';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get editProfileInfo => 'Edit your profile information';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get highContrast => 'High Contrast';

  @override
  String get increaseContrast => 'Increase contrast for better visibility';

  @override
  String get largeText => 'Large Text';

  @override
  String get useLargerFontSizes => 'Use larger font sizes';

  @override
  String get screenReader => 'Screen Reader';

  @override
  String get enableScreenReaderSupport => 'Enable screen reader support';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get notificationFrequency => 'Notification Frequency';

  @override
  String get immediate => 'Immediate';

  @override
  String get hourly => 'Hourly';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get sound => 'Sound';

  @override
  String get vibration => 'Vibration';

  @override
  String get pomodoroPreset => 'Pomodoro Preset';

  @override
  String get classicPreset => 'Classic';

  @override
  String get quickstart => 'Quick Start';

  @override
  String get deepWork => 'Deep Work';

  @override
  String get students => 'Students';

  @override
  String get shortPreset => 'Short (15/3/10)';

  @override
  String get longPreset => 'Long (50/10/30)';

  @override
  String get custom => 'Custom';

  @override
  String get customDurations => 'Custom Durations (minutes)';

  @override
  String get sessionsToLongBreak => 'Sessions to Long Break';

  @override
  String get autoBackup => 'Auto Backup';

  @override
  String get automaticallyBackupData => 'Automatically backup your data';

  @override
  String get backupFrequency => 'Backup Frequency';

  @override
  String days(int count) {
    return '$count days';
  }

  @override
  String get analytics => 'Analytics';

  @override
  String get helpImproveApp => 'Help improve the app with usage data';

  @override
  String get crashReporting => 'Crash Reporting';

  @override
  String get sendCrashReports => 'Send crash reports to help fix issues';

  @override
  String get language => 'Language';

  @override
  String get dateFormat => 'Date Format';

  @override
  String get timeFormat => 'Time Format';

  @override
  String get twelveHour => '12h';

  @override
  String get twentyFourHour => '24h';

  @override
  String get today => 'Today';

  @override
  String get history => 'History';

  @override
  String get insights => 'Insights';

  @override
  String get howAreYouFeeling => '😊 How are you feeling?';

  @override
  String get tapToLogMood => 'Tap to log your mood';

  @override
  String get yourMoodInsights => 'Your Mood Insights';

  @override
  String get totalEntries => 'Total Entries';

  @override
  String get averageMood => 'Average Mood';

  @override
  String get mostCommonMood => 'Most Common Mood';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get averageEnergy => 'Average Energy';

  @override
  String get averageFocus => 'Average Focus';

  @override
  String get averageStress => 'Average Stress';

  @override
  String metricValue(String label, int value) {
    return '$label: $value/10';
  }

  @override
  String get noTasksFound => 'No tasks found';

  @override
  String get searchHint => 'Search tasks...';

  @override
  String get deleteTaskConfirmationTitle => 'Delete Task';

  @override
  String get deleteSubtask => 'Delete Subtask';

  @override
  String get confirmDeleteSubtask => 'Are you sure you want to delete this subtask?';

  @override
  String get collapse => 'Collapse';

  @override
  String get expand => 'Expand';

  @override
  String get copySuffix => '(Copy)';

  @override
  String get highPriority => 'High';

  @override
  String get mediumPriority => 'Medium';

  @override
  String get lowPriority => 'Low';

  @override
  String get addSubtask => 'Add Subtask';

  @override
  String get recurringTasksManager => 'Recurring Tasks Manager';

  @override
  String get generateRecurringInstances => 'Generate Recurring Instances';

  @override
  String get recurringInstancesGenerated => 'Recurring instances generated';

  @override
  String get errorGeneratingInstances => 'Error generating instances';

  @override
  String get duplicateTask => 'Duplicate Task';

  @override
  String get allRecurringUpToDate => 'All recurring up to date';

  @override
  String get generateNextInstance => 'Generate Next Instance';

  @override
  String get generateAllInstances => 'Generate All Instances';

  @override
  String get activeRecurringTasks => 'Active Recurring Tasks';

  @override
  String get totalRecurringInstances => 'Total Recurring Instances';

  @override
  String get tasksNeedingInstances => 'Tasks Needing Instances';

  @override
  String get refreshRecurringTasks => 'Refresh Recurring Tasks';

  @override
  String get subtaskTitle => 'Subtask Title';

  @override
  String get subtaskDescription => 'Description (optional)';

  @override
  String get pleaseEnterSubtaskTitle => 'Please enter a subtask title';

  @override
  String get customizePomodoroSession => 'Customize Pomodoro Session';

  @override
  String get workDurationLabel => 'Work Duration';

  @override
  String get shortBreakLabel => 'Short Break';

  @override
  String get longBreakLabel => 'Long Break';

  @override
  String get startSession => 'Start Session';

  @override
  String get pomodoroFocus => 'Pomodoro Focus';

  @override
  String get pomodoroDescription => 'Choose a task to focus on and customize your session';

  @override
  String get sessionProgress => 'Session Progress';

  @override
  String get settingsButton => 'Settings';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get overdueTasks => 'Overdue tasks - need immediate attention';

  @override
  String get todayTasks => 'Tasks to complete today';

  @override
  String get tomorrowTasks => 'Tomorrow\'s tasks';

  @override
  String get thisWeekTasks => 'Tasks for this week';

  @override
  String get laterTasks => 'Later tasks';

  @override
  String get noDateTasks => 'Tasks without a specific date';

  @override
  String get receiveNotificationsForTasksAndReminders => 'Receive notifications for tasks and reminders';

  @override
  String get playSoundForNotifications => 'Play sound for notifications';

  @override
  String get vibrateForNotifications => 'Vibrate for notifications';

  @override
  String get noUpcomingTasksWithReminders => 'No upcoming tasks with reminders';

  @override
  String get noOverdueTasks => 'No overdue tasks';

  @override
  String get testNotification => 'Test Notification';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String reminderCancelledFor(String taskTitle) {
    return 'Reminder cancelled for: $taskTitle';
  }

  @override
  String get testNotificationSent => 'Test notification sent!';

  @override
  String reminder(String date) {
    return 'Reminder: $date';
  }

  @override
  String get noReminderSet => 'No reminder set';

  @override
  String get allNotificationsCleared => 'All notifications cleared!';

  @override
  String get checkPendingNotifications => 'Check Pending';

  @override
  String get cancelAllNotifications => 'Cancel All';

  @override
  String get allNotificationsCancelled => 'All notifications cancelled!';

  @override
  String get moodCheckInNotificationTitle => 'Mood Check-In';

  @override
  String get moodCheckInNotificationBody => 'How are you feeling right now? Tap to record your mood.';

  @override
  String get testMoodNotificationTitle => 'Test Mood Notification';

  @override
  String get testMoodNotificationBody => 'This is a test mood check-in notification.';

  @override
  String get testReminderIn10Seconds => 'Test Reminder in 10s';

  @override
  String get testReminderScheduled => 'Test reminder scheduled for 10 seconds from now';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get appUpdates => 'App Updates';

  @override
  String get checkForUpdates => 'Check for Updates';

  @override
  String get currentVersion => 'Current Version';

  @override
  String get latestVersion => 'Latest Version';

  @override
  String get updateAvailable => 'Update Available';

  @override
  String get updateDownloaded => 'Update Downloaded';

  @override
  String get installUpdate => 'Install Update';

  @override
  String get downloadingUpdate => 'Downloading Update...';

  @override
  String get installingUpdate => 'Installing Update...';

  @override
  String get noUpdatesAvailable => 'No Updates Available';

  @override
  String get updateError => 'Update Error';

  @override
  String get retry => 'Retry';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get updatePersonalInfo => 'Update your personal information';

  @override
  String get sunday => 'Sun';

  @override
  String get monday => 'Mon';

  @override
  String get tuesday => 'Tue';

  @override
  String get wednesday => 'Wed';

  @override
  String get thursday => 'Thu';

  @override
  String get friday => 'Fri';

  @override
  String get saturday => 'Sat';

  @override
  String get focusMode => 'Focus Mode';

  @override
  String get motivationalQuoteHigh => 'You\'ve got this! 🚀';

  @override
  String get motivationalQuoteMedium => 'Keep going! 💪';

  @override
  String get motivationalQuoteLow => 'Take it easy! 😊';

  @override
  String get taskDetails => 'Task Details';

  @override
  String get noDueDate => 'No due date';

  @override
  String get priority => 'Priority';

  @override
  String get reminders => 'Reminders';

  @override
  String get repeat => 'Repeat';

  @override
  String get noSubtasks => 'No subtasks yet';

  @override
  String get subtasks => 'Subtasks';

  @override
  String get sessions => 'Sessions';

  @override
  String get timeSpent => 'Time Spent';

  @override
  String get avgSession => 'Avg Session';

  @override
  String get pomodoroSessions => 'Pomodoro Sessions';

  @override
  String get startPomodoroSession => 'Start Pomodoro Session';

  @override
  String get timeline => 'Timeline';

  @override
  String get created => 'Created';

  @override
  String get lastModified => 'Last Modified';

  @override
  String get taskProgress => 'Task Progress';

  @override
  String get statusLabel => 'Status:';

  @override
  String get setReminderButton => 'Set Reminder';

  @override
  String get uncompleteTaskButton => 'Uncomplete Task';

  @override
  String get completeTaskButton => 'Complete Task';

  @override
  String get completeSubtasksFirst => 'Complete Subtasks First';

  @override
  String get testNotifications => 'Test Notifications';

  @override
  String get tryAllNotificationFeatures => 'Try all notification features';

  @override
  String get customizeNotificationBehavior => 'Customize notification behavior';

  @override
  String get viewPastNotifications => 'View past notifications';

  @override
  String get notificationTesting => '🧪 Notification Testing';

  @override
  String get quickTestGuide => '🎯 Quick Test Guide';

  @override
  String totalNotifications(int count) {
    return 'Total Notifications: $count';
  }

  @override
  String get notificationsEnabled => 'Enabled: ✅';

  @override
  String get notificationsDisabled => 'Enabled: ❌';

  @override
  String get basicNotifications => '1. Basic Notifications';

  @override
  String get testSimpleNotification => 'Test: Simple Notification';

  @override
  String get appearsIn10Seconds => 'Appears in 10 seconds';

  @override
  String get testTaskReminder => 'Test: Task Reminder';

  @override
  String get withActionButtons15Seconds => 'With action buttons - 15 seconds';

  @override
  String get testMoodCheckIn => 'Test: Mood Check-in';

  @override
  String get testIn20Seconds => '20 seconds';

  @override
  String get priorityLevels => '2. Priority Levels';

  @override
  String get testHighPriority => 'Test: High Priority';

  @override
  String get urgentNotification10Seconds => 'Urgent notification - 10 seconds';

  @override
  String get testLowPriority => 'Test: Low Priority';

  @override
  String get silentNotification10Seconds => 'Silent notification - 10 seconds';

  @override
  String get notificationManagement => '3. Notification Management';

  @override
  String get viewNotificationHistory => 'View Notification History';

  @override
  String get seeAllPastNotifications => 'See all past notifications';

  @override
  String get configureNotificationSettings => 'Configure notification settings';

  @override
  String get testingTips => 'Testing Tips';

  @override
  String get grantNotificationPermissions => '1. Grant notification permissions when prompted';

  @override
  String get keepAppInBackground => '2. Keep app in background after scheduling';

  @override
  String get checkHistoryAfterDelivery => '3. Check notification history after delivery';

  @override
  String get tryActionButtons => '4. Try action buttons on task notifications';

  @override
  String get testDNDMode => '5. Test DND mode in preferences';

  @override
  String get notificationScheduledFor10Seconds => '⏰ Notification scheduled for 10 seconds';

  @override
  String get taskNotificationIn15Seconds => '⏰ Task notification in 15 seconds (has action buttons!)';

  @override
  String get moodNotificationIn20Seconds => '⏰ Mood notification in 20 seconds';

  @override
  String get highPriorityNotificationIn10Seconds => '⏰ High priority notification in 10 seconds';

  @override
  String get lowPriorityNotificationIn10Seconds => '⏰ Low priority (silent) notification in 10 seconds';

  @override
  String get testNotificationTitle => '✅ Test Notification';

  @override
  String get testNotificationBody => 'The new notification system works!';

  @override
  String get taskCompleteReport => '📋 Task: Complete Report';

  @override
  String get dueInOneHour => 'Due in 1 hour - tap to view';

  @override
  String get highPriorityAlert => '🚨 High Priority Alert';

  @override
  String get urgentNotificationMessage => 'This is an urgent notification!';

  @override
  String get lowPriorityInfo => 'ℹ️ Low Priority Info';

  @override
  String get quietNotificationMessage => 'This is a quiet notification';

  @override
  String get filters => 'Filters';

  @override
  String get searchNotifications => 'Search notifications...';

  @override
  String get filterByType => 'Filter by Type';

  @override
  String get filterByStatus => 'Filter by Status';

  @override
  String get notificationAnalyticsLast7Days => 'Analytics (Last 7 Days)';

  @override
  String get notificationAnalyticsSent => 'Sent';

  @override
  String get notificationAnalyticsDelivered => 'Delivered';

  @override
  String get notificationAnalyticsOpened => 'Opened';

  @override
  String get notificationAnalyticsAction => 'Action Rate';

  @override
  String get notificationStatusDelivered => 'Delivered';

  @override
  String get notificationStatusPending => 'Pending';

  @override
  String get notificationStatusFailed => 'Failed';

  @override
  String get notificationStatusCancelled => 'Cancelled';

  @override
  String get notificationStatusExpired => 'Expired';

  @override
  String get doNotDisturb => 'Do Not Disturb';

  @override
  String get scheduledQuietHours => 'Scheduled Quiet Hours';

  @override
  String get allowUrgentNotifications => 'Allow Urgent Notifications During DND';

  @override
  String get smartScheduling => 'Smart Scheduling';

  @override
  String get enableSmartScheduling => 'Enable Smart Scheduling';

  @override
  String get maxNotificationsPerHour => 'Max Notifications Per Hour';

  @override
  String get minimumMinutesBetweenSameType => 'Minimum Minutes Between Same Type';

  @override
  String get groupSimilarNotifications => 'Group Similar Notifications';

  @override
  String get respectSystemDND => 'Respect System Do Not Disturb';

  @override
  String get notificationTypes => 'Notification Types';

  @override
  String get taskReminders => 'Task Reminders';

  @override
  String get moodCheckIns => 'Mood Check-ins';

  @override
  String get pomodoroNotifications => 'Pomodoro';

  @override
  String get emergencyNotifications => 'Emergency';

  @override
  String get enabled => 'Enabled';

  @override
  String get adaptiveTiming => 'Adaptive Timing';

  @override
  String get openSystemSettings => 'Open System Settings';

  @override
  String get viewHistory => 'View History';

  @override
  String get emergencyAlertsWillBypassQuietHours => 'Emergency alerts will bypass quiet hours';

  @override
  String get intelligentNotificationManagement => 'Intelligent Notification Management';

  @override
  String get automaticallyOptimizeNotificationTiming => 'Automatically optimize notification timing to avoid interrupting you';

  @override
  String get combineNotificationsOfTheSameType => 'Combine notifications of the same type into groups';

  @override
  String get honorDeviceDoNotDisturbSettings => 'Honor device Do Not Disturb settings';

  @override
  String get customizeEachNotificationType => 'Customize each notification type';

  @override
  String get disabled => 'Disabled';

  @override
  String get enable => 'Enable';

  @override
  String get showBadge => 'Show Badge';

  @override
  String get enableActions => 'Enable Actions';

  @override
  String get showActionButtons => 'Show action buttons';

  @override
  String get advancedSettings => 'Advanced Settings';

  @override
  String get expertOptions => 'Expert options for power users';

  @override
  String get badgeOnlyMode => 'Badge Only Mode';

  @override
  String get badgeOnlyModeSubtitle => 'Show badge without sound or popup';

  @override
  String get deliveryTracking => 'Delivery Tracking';

  @override
  String get trackWhenNotificationsAreDelivered => 'Track when notifications are delivered and opened';

  @override
  String get trackNotificationInteractionStatistics => 'Track notification interaction statistics';

  @override
  String get learnFromYourBehaviorToOptimizeNotificationTiming => 'Learn from your behavior to optimize notification timing';

  @override
  String get moodCheckIn => 'Mood Check-in';

  @override
  String get masterToggleForAllNotifications => 'Master toggle for all notifications';

  @override
  String get activeNotificationsMuted => 'Active - Notifications muted';

  @override
  String get configureQuietHours => 'Configure quiet hours';

  @override
  String get setAutomaticQuietHours => 'Set automatic quiet hours';

  @override
  String get sendTestNotification => 'Send Test Notification';

  @override
  String get taskDue => 'Task Due';

  @override
  String get pomodoroWork => 'Pomodoro Work';

  @override
  String get pomodoroBreak => 'Pomodoro Break';

  @override
  String get pomodoroComplete => 'Pomodoro Complete';

  @override
  String get medium => 'Medium';

  @override
  String get urgent => 'Urgent';

  @override
  String get notificationPreferencesInfo => 'Notification Preferences Info';

  @override
  String get notificationPreferencesInfoDetails => 'Configure how and when you receive notifications. Customize each notification type, set quiet hours, and control notification behavior.';

  @override
  String get smartSchedulingInfo => 'Smart scheduling learns from your usage patterns to deliver notifications at optimal times.';

  @override
  String get dndInfo => 'Do Not Disturb mode silences all notifications except emergencies during specified hours.';

  @override
  String get manualDND => 'Manual DND';

  @override
  String get resetSettings => 'Reset Settings';

  @override
  String get resetSettingsConfirmation => 'Are you sure you want to reset all settings to default?';

  @override
  String get searchSettings => 'Search Settings';

  @override
  String get typeToFilterSettingsSections => 'Type to filter settings sections';

  @override
  String get searchSettingsHint => 'Search...';

  @override
  String get increaseContrastForBetterVisibility => 'Increase contrast for better visibility';

  @override
  String get taskCompletionSounds => 'Task Completion Sounds';

  @override
  String get enableTaskCompletionSound => 'Enable Task Completion Sound';

  @override
  String get playSoundWhenTasksAreCompleted => 'Play sound when tasks are completed';

  @override
  String get soundSelection => 'Sound Selection';

  @override
  String get testSound => 'Test Sound';

  @override
  String get customDurationsMinutes => 'Custom Durations (minutes)';

  @override
  String get workDuration => 'Work Duration';

  @override
  String get shortBreakDuration => 'Short Break Duration';

  @override
  String get longBreakDuration => 'Long Break Duration';

  @override
  String get helpImproveTheAppWithUsageData => 'Help improve the app with usage data';

  @override
  String get sendCrashReportsToHelpFixIssues => 'Send crash reports to help fix issues';

  @override
  String get failedToCheckForUpdates => 'Failed to check for updates';

  @override
  String get mood => 'Mood';

  @override
  String get appearance => 'Appearance';

  @override
  String get notifications => 'Notifications';

  @override
  String get taskSounds => 'Task Sounds';

  @override
  String get pomodoro => 'Pomodoro';

  @override
  String get backup => 'Backup';

  @override
  String get privacy => 'Privacy';

  @override
  String get regional => 'Regional';

  @override
  String get updates => 'Updates';

  @override
  String get calendar => 'Calendar';

  @override
  String get clearDateFilter => 'Clear date filter';

  @override
  String tasksForDate(String date) {
    return 'Tasks for $date';
  }

  @override
  String tasksDue(int count) {
    return '$count tasks due';
  }

  @override
  String get undatedTasks => 'Tasks without dates';

  @override
  String get monthView => 'Month';

  @override
  String get weekView => 'Week';

  @override
  String get calendarView => 'Calendar View';

  @override
  String get rescheduleTask => 'Reschedule Task';

  @override
  String get taskRescheduled => 'Task rescheduled';

  @override
  String get undo => 'Undo';

  @override
  String get viewDayTasks => 'View day tasks';

  @override
  String get noTasksForThisDay => 'No tasks for this day';

  @override
  String get noInternetConnection => 'No Internet Connection';

  @override
  String get pullToRefresh => 'Pull down to refresh when connected';

  @override
  String get showCalendar => 'Show calendar';

  @override
  String get minutes => 'min';

  @override
  String get recommendedForAdhd => 'Recommended for ADHD';

  @override
  String get mostPopular => 'Most Popular';

  @override
  String get stopPomodoroConfirmation => 'Are you sure you want to stop the current session? Your progress will be lost.';

  @override
  String get whatsHappeningRightNow => 'What\'s happening right now?';

  @override
  String get wantToShareMore => 'Want to share more?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get failedToAccessGallery => 'Failed to access gallery';

  @override
  String get nameRequiredForProfile => 'Name is required for profile';

  @override
  String get birthdayRequiredForProfile => 'Birthday is required for profile';

  @override
  String get failedToUploadImage => 'Failed to upload image';

  @override
  String get userNotAuthenticated => 'User not authenticated';

  @override
  String get notificationPermissionRequired => 'Notification permission required';

  @override
  String get notificationPermissionMessage => 'Please enable notifications to set reminders';

  @override
  String get grantPermission => 'Grant Permission';

  @override
  String get cannotSetReminderWithoutPermission => 'Cannot set reminder without notification permission';

  @override
  String get customColors => 'Custom Colors';

  @override
  String get personalizeAppTheme => 'Personalize App Theme';

  @override
  String get primaryColor => 'Primary Color';

  @override
  String get choosePrimaryColor => 'Choose Primary Color';

  @override
  String subtasksCount(int count) {
    return '$count subtasks';
  }

  @override
  String get deliveryLabel => 'Delivery';

  @override
  String get openLabel => 'Open';

  @override
  String get actionLabel => 'Action';

  @override
  String get averageResponseTime => 'Average Response Time';

  @override
  String get helpUsUnderstandState => 'Help us understand your current state';

  @override
  String get optionalAddContext => 'Optional: Add context';

  @override
  String get optionalWriteNote => 'Optional: Write a note';

  @override
  String get imGratefulFor => 'I\'m grateful for';

  @override
  String get todayI => 'Today I';

  @override
  String get imFeeling => 'I\'m feeling';

  @override
  String get whatsWeighingOnYou => 'What\'s weighing on you?';

  @override
  String get whatsMakingTodayTough => 'What\'s making today tough?';

  @override
  String get whatsGoingWell => 'What\'s going well?';

  @override
  String get whatMadeTodayGreat => 'What made today great?';

  @override
  String get howsYourDayGoing => 'How\'s your day going?';

  @override
  String get chooseEmojiFeeling => 'Choose an emoji that represents how you\'re feeling';

  @override
  String get dayStreak => 'day streak';

  @override
  String get moodSaved => 'Mood saved';

  @override
  String get testButton => 'Test';

  @override
  String get clearAllNotifications => 'Clear All Notifications';

  @override
  String get clearAllNotificationsConfirmation => 'Are you sure you want to clear all notifications?';

  @override
  String get generateRecurringConfirmation => 'Are you sure you want to generate recurring instances?';

  @override
  String get includeSpecificTime => 'Include specific time';

  @override
  String get repeatSameTimeEachDay => 'Repeat at same time each day';

  @override
  String get syncStatus => 'Sync Status';

  @override
  String get pendingOperations => 'Pending operations';

  @override
  String get someSyncOperationsFailed => 'Some sync operations failed';

  @override
  String get retryButton => 'Retry';

  @override
  String get clearFailedButton => 'Clear Failed';

  @override
  String get closeButton => 'Close';

  @override
  String get syncStatusSuccess => 'Success';

  @override
  String get syncStatusSyncing => 'Syncing';

  @override
  String get syncStatusIdle => 'Idle';

  @override
  String get syncStatusFailed => 'Failed';

  @override
  String get moodInsightsSubtitle => 'Track your emotional patterns and gain insights';

  @override
  String get yourMoodJourney => 'Your Mood Journey';

  @override
  String get aIPoweredAnalysis => 'AI-Powered Analysis';

  @override
  String get thisWeek => 'This Week';

  @override
  String get goodDays => 'Good Days';

  @override
  String get neutralDays => 'Neutral Days';

  @override
  String get challengingDays => 'Challenging Days';

  @override
  String get dominantMood => 'Dominant Mood';

  @override
  String get hiThere => 'Hi there!';

  @override
  String get howIsYourDay => 'How is your day?';

  @override
  String get imHereForYou => 'I\'m here for you!';

  @override
  String get itsOkayToHaveToughDays => 'It\'s okay to have tough days';

  @override
  String get sendingYouStrength => 'Sending you strength';

  @override
  String get everyDayIsANewOpportunity => 'Every day is a new opportunity';

  @override
  String get findingBalance => 'Finding balance';

  @override
  String get sometimesNeutralIsExactlyWhereWeNeedToBe => 'Sometimes neutral is exactly where we need to be';

  @override
  String get youreDoingGreat => 'You\'re doing great!';

  @override
  String get keepShiningBright => 'Keep shining bright!';

  @override
  String get absolutelyAmazing => 'Absolutely amazing!';

  @override
  String get yourJoyIsContagious => 'Your joy is contagious!';

  @override
  String get moodIntensity => 'Mood Intensity';

  @override
  String get smartView => 'Smart';

  @override
  String get timelineView => 'Timeline';

  @override
  String get patternsView => 'Patterns';

  @override
  String get goodIntensity => 'Good Intensity';

  @override
  String get veryGoodIntensity => 'Very Good Intensity';

  @override
  String get noMoodRecorded => 'No mood recorded';

  @override
  String get goodMorning => 'Good Morning!';

  @override
  String get howAreYouFeelingToday => 'How are you feeling today?';

  @override
  String get todayYoureFeeling => 'Today you\'re feeling';

  @override
  String get addAnother => 'Add Another';

  @override
  String get earlierToday => 'Earlier today';

  @override
  String get struggling => 'Struggling';

  @override
  String get down => 'Down';

  @override
  String get wantToShareMoreDetails => 'Want to share more details?';

  @override
  String get guidedCheckIn => 'Guided Check-in';

  @override
  String get detailedEntry => 'Detailed Entry';

  @override
  String get quickInsights => 'Quick Insights';

  @override
  String get recentMoods => 'Recent Moods';

  @override
  String get noInsightsYet => 'No insights yet';

  @override
  String get trackYourMoodForAWeek => 'Track your mood for a week to see insights';

  @override
  String get daysStreak => 'days streak';

  @override
  String get moodBuddyFeelingSad => 'Feeling sad?';

  @override
  String get moodBuddyTipSad => 'Try a gentle walk or listen to calming music';

  @override
  String get moodBuddyFeelingDown => 'Feeling down?';

  @override
  String get moodBuddyTipDown => 'Reach out to a friend or practice deep breathing';

  @override
  String get moodBuddyFeelingOkay => 'Feeling okay?';

  @override
  String get moodBuddyTipOkay => 'Maintain balance with light exercise or hobbies';

  @override
  String get moodBuddyFeelingGood => 'Feeling good?';

  @override
  String get moodBuddyTipGood => 'Share your positivity and help others';

  @override
  String get moodBuddyFeelingGreat => 'Feeling great?';

  @override
  String get moodBuddyTipGreat => 'Channel this energy into creative projects';

  @override
  String get moodPatternsTitle => 'Your Mood Patterns';

  @override
  String get moodPatternsSubtitle => 'Discover trends in your emotional well-being';

  @override
  String get moodSuggestionsTitle => 'Personalized Suggestions';

  @override
  String get moodSuggestionsSubtitle => 'AI-powered recommendations based on your mood';

  @override
  String get veryBadIntensity => 'Very Bad Intensity';

  @override
  String get badIntensity => 'Bad Intensity';

  @override
  String get neutralIntensity => 'Neutral Intensity';

  @override
  String get insightGenerallyPositive => 'Generally positive 😊';

  @override
  String get insightNeedsSupport => 'Needs support 🤗';

  @override
  String get insightGreatConsistency => 'Great consistency! 🔥';

  @override
  String get insightMissingToday => 'Missing today 📝';

  @override
  String get pleaseTryAgainLater => 'Please try again later';

  @override
  String get icon => 'Icon';

  @override
  String get categories => 'Categories';

  @override
  String get searchCategories => 'Search categories...';

  @override
  String get keyInsights => 'Key Insights';

  @override
  String get patternAnalysis => 'Pattern Analysis';

  @override
  String get aiPredictions => 'AI Predictions';

  @override
  String get positiveTrend => 'Positive Trend';

  @override
  String get yourOverallMoodIsGenerallyPositive => 'Your overall mood is generally positive';

  @override
  String get supportNeeded => 'Support Needed';

  @override
  String get youMightBenefitFromAdditionalSupport => 'You might benefit from additional support';

  @override
  String get greatConsistency => 'Great Consistency';

  @override
  String youveBeenTrackingYourMoodForDays(Object days) {
    return 'You\'ve been tracking your mood for $days days';
  }

  @override
  String get missingToday => 'Missing Today';

  @override
  String get youHaventLoggedYourMoodTodayYet => 'You haven\'t logged your mood today yet';

  @override
  String get recentImprovement => 'Recent Improvement';

  @override
  String get yourMoodHasBeenImprovingLately => 'Your mood has been improving lately';

  @override
  String get challengingPeriod => 'Challenging Period';

  @override
  String get recentEntriesSuggestAChallengingTime => 'Recent entries suggest a challenging time';

  @override
  String get moreDataNeeded => 'More Data Needed';

  @override
  String get trackYourMoodForAWeekToGetAIPredictions => 'Track your mood for a week to get AI predictions';

  @override
  String get positiveOutlook => 'Positive Outlook';

  @override
  String get basedOnRecentPatternsTomorrowLooksPromising => 'Based on recent patterns, tomorrow looks promising';

  @override
  String get selfCareRecommended => 'Self-Care Recommended';

  @override
  String get considerPrioritizingSelfCareActivitiesTomorrow => 'Consider prioritizing self-care activities tomorrow';

  @override
  String get balancedDayAhead => 'Balanced Day Ahead';

  @override
  String get tomorrowShouldBeATypicalDayForYou => 'Tomorrow should be a typical day for you';

  @override
  String get errorTitle => 'Oops! Something went wrong';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get deleteTask => 'Delete Task';

  @override
  String deleteTaskConfirmation(String task) {
    return 'Are you sure you want to delete \"$task\"?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get search => 'Search';

  @override
  String get options => 'Options';

  @override
  String get filtersAppliedSuccessfully => 'Filters applied successfully';

  @override
  String get closeSearch => 'Close search';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get premium => 'Premium';

  @override
  String get dashboardOverview => 'Dashboard & Overview';

  @override
  String get statisticsAnalytics => 'Statistics & Analytics';

  @override
  String get focusTimeManagement => 'Focus & Time Management';

  @override
  String get organizeManage => 'Organize & Manage';

  @override
  String get wellnessEmotions => 'Wellness & Emotions';

  @override
  String get preferencesConfiguration => 'Preferences & Configuration';

  @override
  String get about => 'About';

  @override
  String get appInformationHelp => 'App Information & Help';

  @override
  String get biweekly => 'Bi-weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get repeatForever => '(forever)';

  @override
  String repeatUntil(Object date) {
    return 'until $date';
  }

  @override
  String repeatCount(Object count) {
    return '($count times)';
  }

  @override
  String onDays(Object days) {
    return 'on $days';
  }

  @override
  String get recurringTaskGenerationFailed => 'Failed to generate recurring task';

  @override
  String get recurringTaskRetry => 'Retry';

  @override
  String get recurringTaskRetryLater => 'Retry Later';

  @override
  String bulkGenerationComplete(String count) {
    return 'Generated $count recurring instances';
  }

  @override
  String recurringTaskNotification(String title) {
    return 'New recurring task created: $title';
  }

  @override
  String recurringTaskError(String error) {
    return 'Error in recurring task: $error';
  }

  @override
  String get noRecurringTasksFound => 'No recurring tasks found';

  @override
  String get recurringTasksOptimized => 'Recurring tasks optimized for performance';
}
