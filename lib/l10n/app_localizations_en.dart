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
  String get classicPreset => 'Classic (25/5/15)';

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
  String get howAreYouFeeling => 'How are you feeling today?';

  @override
  String get tapToLogMood => 'Tap the + button to log your mood';

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
  String get energy => 'Energy';

  @override
  String get focus => 'Focus';

  @override
  String get stress => 'Stress';

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
  String get sunday => 'Sunday';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

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
}
