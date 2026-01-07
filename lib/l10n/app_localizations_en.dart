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
    return 'Are you sure you want to delete \"$taskTitle\"?';
  }

  @override
  String get addTask => 'Add Task';

  @override
  String get addTaskToGetStarted => 'Add a task to get started';

  @override
  String get voiceTaskCreate => 'Create Task with Voice';

  @override
  String get voiceTaskHint => 'Tap microphone to speak';

  @override
  String get voiceTaskProcessing => 'Processing your voice...';

  @override
  String get voiceTaskCreated => 'Voice task created';

  @override
  String get taskValidationFailed => 'Task validation failed';

  @override
  String get errorCreatingTask => 'Error creating task';

  @override
  String get tryVoiceTasks => 'Try voice tasks! Tap the microphone to create tasks instantly.';

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
  String get color => 'Color';

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
    return 'Tasks Count';
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
  String get dueDateTitle => 'Due Date';

  @override
  String dueDate(Object dueDate) {
    return 'Due Date: $dueDate';
  }

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
  String get moodVeryBad => 'Really struggling';

  @override
  String get moodBad => 'Not great';

  @override
  String get moodNeutral => 'Okay';

  @override
  String get moodGood => 'Pretty good';

  @override
  String get moodVeryGood => 'Great';

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
  String get taskCompleted => 'Task completed successfully';

  @override
  String get taskDeleted => 'Task deleted successfully';

  @override
  String get categoryCreated => 'Category created successfully';

  @override
  String get categoryDeleted => 'Category deleted successfully';

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
  String error(String message) {
    return 'Error';
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
  String get deleteSubtask => 'Delete subtask';

  @override
  String get confirmDeleteSubtask => 'Are you sure you want to delete this subtask?';

  @override
  String get collapse => 'Collapse';

  @override
  String get expand => 'Expand';

  @override
  String get copySuffix => '(Copy)';

  @override
  String get highPriority => 'High Priority';

  @override
  String get mediumPriority => 'Medium Priority';

  @override
  String get lowPriority => 'Low Priority';

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
  String get overdueTasks => 'Overdue Tasks';

  @override
  String get todayTasks => 'Today\'s tasks';

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
  String get testNotificationSent => 'Test notification sent';

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
  String get allNotificationsCancelled => 'All notifications cancelled';

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
    return 'Version: $version';
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
  String get noDueDate => 'No Due Date';

  @override
  String priority(Object priority) {
    return 'Priority: $priority';
  }

  @override
  String get reminders => 'Reminders';

  @override
  String get repeat => 'Repeat';

  @override
  String get noSubtasks => 'No subtasks';

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
  String get pomodoroNotifications => 'Pomodoro Notifications';

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
  String get minutes => 'minutes';

  @override
  String get recommendedForAdhd => 'Recommended for ADHD';

  @override
  String get mostPopular => 'Most Popular';

  @override
  String get stopPomodoroConfirmation => 'Are you sure you want to stop the current session? Your progress will be lost.';

  @override
  String get selectATemplateOrCustomizeYourSession => 'Select a template or customize your session';

  @override
  String get stopPomodoroTimer => 'Stop Timer';

  @override
  String get resume => 'Resume';

  @override
  String get sessionsUntilLongBreak => 'Sessions until Long Break';

  @override
  String get customizeYourPomodoroSession => 'Customize your pomodoro session';

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
  String icon(Object icon) {
    return 'Icon: $icon';
  }

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
  String get errorLoadingTasks => 'Error loading tasks';

  @override
  String get deleteTask => 'Delete Task';

  @override
  String deleteTaskConfirmation(String task, Object taskTitle) {
    return 'Are you sure you want to delete \"$taskTitle\"?';
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
  String get signingIn => 'Signing you in..';

  @override
  String get yourPersonalTaskManager => 'Your Personal Task Manager';

  @override
  String get bySigningInYouAgree => 'By signing in, you agree to our Terms of Service and Privacy Policy';

  @override
  String get authenticationServiceNotAvailable => 'Authentication service not available. Please try again.';

  @override
  String get anErrorOccurredPleaseTryAgain => 'An error occurred. Please try again.';

  @override
  String get or => 'or';

  @override
  String get signIn => 'Sign In';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get register => 'Register';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get passwordResetFunctionality => 'Password reset functionality will be implemented soon. Please contact support for assistance.';

  @override
  String get ok => 'OK';

  @override
  String get smartSortingConsidersTimeOfDayEnergyLevelsAndPatterns => 'Smart sorting considers time of day, energy levels, and patterns';

  @override
  String get youCanOverrideWithManualSortingAnytime => 'You can override with manual sorting anytime';

  @override
  String get trySortingTasksWithSmartSortOption => 'Try sorting tasks with \"Smart Sort\" option';

  @override
  String get adaptivePomodoro => 'Adaptive Pomodoro';

  @override
  String get adaptivePomodoroDescription => 'Focus sessions that adapt to your performance';

  @override
  String get sessionTimingAdjustsBasedOnYourFocusPatterns => 'Session timing adjusts based on your focus patterns';

  @override
  String get breakSuggestionsMatchYourCurrentEnergyLevel => 'Break suggestions match your current energy level';

  @override
  String get productivityInsightsHelpYouOptimizeWorkSessions => 'Productivity insights help you optimize work sessions';

  @override
  String get achievementSystemKeepsYouMotivated => 'Achievement system keeps you motivated';

  @override
  String get startAPomodoroSessionToSeeAdaptiveTiming => 'Start a Pomodoro session to see adaptive timing';

  @override
  String get energyAwarePlanning => 'Energy-Aware Planning';

  @override
  String get energyAwarePlanningDescription => 'Schedule tasks based on your energy patterns';

  @override
  String get morningPeakBestForComplexTasks => 'Morning peak: Best for complex tasks';

  @override
  String get afternoonSteadyGoodForRoutineWork => 'Afternoon steady: Good for routine work';

  @override
  String get eveningDeclineLightTasksAndPlanning => 'Evening decline: Light tasks and planning';

  @override
  String get energyTrackingHelpsIdentifyYourPatterns => 'Energy tracking helps identify your patterns';

  @override
  String get checkYourEnergyLevelsThroughoutTheDay => 'Check your energy levels throughout the day';

  @override
  String get analyticsDashboard => 'Analytics Dashboard';

  @override
  String get analyticsDashboardDescription => 'Deep insights into your productivity';

  @override
  String get trackFocusPatternsAndSessionPerformance => 'Track focus patterns and session performance';

  @override
  String get identifyYourMostProductiveTimes => 'Identify your most productive times';

  @override
  String get monitorMoodAndEnergyCorrelations => 'Monitor mood and energy correlations';

  @override
  String get getPersonalizedProductivityTips => 'Get personalized productivity tips';

  @override
  String get exploreYourAnalyticsDashboard => 'Explore your analytics dashboard';

  @override
  String get tutorialCompletedYoureAllSetToUseSmartFeatures => 'Tutorial completed! You\'re all set to use smart features.';

  @override
  String get errorCompletingTutorial => 'Error completing tutorial';

  @override
  String get accessDenied => 'Access Denied';

  @override
  String get youDoNotHaveAdminPrivileges => 'You do not have admin privileges.';

  @override
  String get activity => 'Activity';

  @override
  String get descriptionOfActivity => 'Description of activity';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get toggleAdminStatus => 'Toggle Admin Status';

  @override
  String areYouSureYouWantToToggleAdminRights(Object action, Object userName) {
    return 'Are you sure you want to $action $userName?';
  }

  @override
  String get removeAdminRightsFrom => 'remove admin rights from';

  @override
  String get grantAdminRightsTo => 'grant admin rights to';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String errorUpdatingUser(Object error) {
    return 'Error updating user: $error';
  }

  @override
  String get deleteUser => 'Delete User';

  @override
  String areYouSureYouWantToDeleteUser(Object userName) {
    return 'Are you sure you want to delete $userName?\n\nThis will permanently delete:\n• User account\n• All tasks\n• All categories\n• All moods\n\nThis action cannot be undone.';
  }

  @override
  String userAndAllAssociatedDataDeletedSuccessfully(Object userName) {
    return '$userName and all associated data deleted successfully';
  }

  @override
  String errorDeletingUser(Object error) {
    return 'Error deleting user: $error';
  }

  @override
  String email(Object email) {
    return 'Email: $email';
  }

  @override
  String admin(Object isAdmin) {
    return 'Admin: $isAdmin';
  }

  @override
  String updated(Object date) {
    return 'Updated: $date';
  }

  @override
  String birthday(Object birthday) {
    return 'Birthday: $birthday';
  }

  @override
  String errorUpdatingTask(Object error) {
    return 'Error updating task: $error';
  }

  @override
  String areYouSureYouWantToDeleteTask(Object taskTitle) {
    return 'Are you sure you want to delete \"$taskTitle\"?';
  }

  @override
  String taskDeletedSuccessfully(Object taskTitle) {
    return '$taskTitle deleted successfully';
  }

  @override
  String errorDeletingTask(Object error) {
    return 'Error deleting task: $error';
  }

  @override
  String description(Object description) {
    return 'Description: $description';
  }

  @override
  String completed(Object isCompleted) {
    return 'Completed: $isCompleted';
  }

  @override
  String userId(Object userId) {
    return 'User ID: $userId';
  }

  @override
  String get noCategoriesFound => 'No categories found';

  @override
  String get tasks => 'Tasks';

  @override
  String get selectIcon => 'Select Icon';

  @override
  String get errorCreatingCategory => 'Error creating category';

  @override
  String get categoryCreatedSuccessfully => 'Category created successfully';

  @override
  String get categoryUpdatedSuccessfully => 'Category updated successfully';

  @override
  String areYouSureYouWantToDeleteCategory(Object categoryName) {
    return 'Are you sure you want to delete \"$categoryName\"?\n\nNote: If this category is being used by any tasks, deletion will fail. Please reassign those tasks first.';
  }

  @override
  String categoryDeletedSuccessfully(Object categoryName) {
    return 'Category \"$categoryName\" deleted successfully';
  }

  @override
  String errorDeletingCategory(Object error) {
    return 'Error deleting category: $error';
  }

  @override
  String get na => 'N/A';

  @override
  String get loadingPreferences => 'Loading preferences...';

  @override
  String get oneHour => '1 Hour';

  @override
  String get threeHours => '3 Hours';

  @override
  String get achievementUnlocks => 'Achievement Unlocks';

  @override
  String get systemUpdates => 'System Updates';

  @override
  String get notificationSounds => 'Notification Sounds';

  @override
  String get scheduleDnd => 'Schedule DND';

  @override
  String get enableSmartNotifications => 'Enable Smart Notifications';

  @override
  String get smartNotificationsDescription => 'Automatically adjust notification timing based on your activity patterns';

  @override
  String get priorityNotifications => 'Priority Notifications';

  @override
  String get priorityNotificationsDescription => 'Only show high-priority notifications during focus time';

  @override
  String get quietHours => 'Quiet Hours';

  @override
  String get quietHoursDescription => 'Temporarily silence all notifications';

  @override
  String get notificationChannels => 'Notification Channels';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get inAppNotifications => 'In-App Notifications';

  @override
  String get viewDetails => 'View Details';

  @override
  String get quickEdit => 'Quick Edit';

  @override
  String get clear => 'Clear';

  @override
  String noTasksFoundForSearch(Object searchQuery) {
    return 'No tasks found for \"$searchQuery\"';
  }

  @override
  String get addYourFirstTask => 'Add Your First Task';

  @override
  String get taskUncompleted => 'Task marked as incomplete';

  @override
  String get taskUpdated => 'Task updated successfully';

  @override
  String get createYourFirstCategory => 'Create your first category to organize tasks';

  @override
  String get noMoodEntriesFound => 'No mood entries found';

  @override
  String get startTrackingYourMood => 'Start tracking your mood to see insights';

  @override
  String get noPomodoroSessionsFound => 'No Pomodoro sessions found';

  @override
  String get startYourFirstPomodoroSession => 'Start your first Pomodoro session to boost productivity';

  @override
  String get noProgressData => 'No progress data available';

  @override
  String get completeTasksToSeeProgress => 'Complete tasks to see your progress';

  @override
  String get pending => 'Pending';

  @override
  String get inProgress => 'In Progress';

  @override
  String get allTasks => 'All Tasks';

  @override
  String get unableToLoadProgressData => 'Unable to load progress data';

  @override
  String get progressOverview => 'Progress Overview';

  @override
  String get tasksCompleted => 'Tasks Completed';

  @override
  String get tasksCompletedThisWeek => 'Tasks Completed This Week';

  @override
  String averageCompletionTime(Object time) {
    return 'Avg completion time: $time';
  }

  @override
  String get streakDays => 'Streak Days';

  @override
  String get monthlyProgress => 'Monthly Progress';

  @override
  String get categoryBreakdown => 'Category Breakdown';

  @override
  String get completionRate => 'Completion Rate';

  @override
  String get totalTasks => 'Total Tasks';

  @override
  String get pendingTasks => 'Pending Tasks';

  @override
  String get productivityTrends => 'Productivity Trends';

  @override
  String get last7Days => 'Last 7 Days';

  @override
  String get last30Days => 'Last 30 Days';

  @override
  String get last90Days => 'Last 90 Days';

  @override
  String get noProgressDataAvailable => 'No progress data available';

  @override
  String get completeTasksToSeeYourProgress => 'Complete tasks to see your progress';

  @override
  String get greatProgress => 'Great progress!';

  @override
  String get keepUpTheGoodWork => 'Keep up the good work';

  @override
  String get youCanDoBetter => 'You can do better';

  @override
  String get tryToCompleteMoreTasks => 'Try to complete more tasks';

  @override
  String get excellentPerformance => 'Excellent performance!';

  @override
  String get youAreOnARoll => 'You are on a roll!';

  @override
  String get voiceTasks => 'Voice Tasks';

  @override
  String get startRecording => 'Start Recording';

  @override
  String get tasksCreatedSuccessfully => 'Tasks created successfully!';

  @override
  String get textInputComingSoon => 'Text input coming soon!';

  @override
  String get recentTasksComingSoon => 'Recent tasks coming soon!';

  @override
  String get voiceRecording => 'Voice Recording';

  @override
  String get listening => 'Listening...';

  @override
  String get processing => 'Processing...';

  @override
  String get tapToStartRecording => 'Tap to start recording';

  @override
  String get recordingInProgress => 'Recording in progress';

  @override
  String get stopRecording => 'Stop Recording';

  @override
  String get errorCreatingVoiceTask => 'Error creating voice task';

  @override
  String get pleaseTryAgain => 'Please try again';

  @override
  String get noSpeechDetected => 'No speech detected';

  @override
  String get speakClearly => 'Please speak clearly';

  @override
  String get voiceCommands => 'Voice Commands';

  @override
  String get showTasks => 'Show tasks';

  @override
  String get voiceSettings => 'Voice Settings';

  @override
  String get enableVoiceCommands => 'Enable Voice Commands';

  @override
  String get voiceLanguage => 'Voice Language';

  @override
  String get voiceFeedback => 'Voice Feedback';

  @override
  String get autoDetectLanguage => 'Auto-detect Language';

  @override
  String get voiceRecognitionAccuracy => 'Voice Recognition Accuracy';

  @override
  String get subtaskCompleted => 'Subtask completed';

  @override
  String get subtaskUncompleted => 'Subtask marked as incomplete';

  @override
  String get areYouSureYouWantToDeleteSubtask => 'Are you sure you want to delete this subtask?';

  @override
  String get taskNotes => 'Task Notes';

  @override
  String get addNote => 'Add Note';

  @override
  String get noNotes => 'No notes';

  @override
  String get taskAttachments => 'Attachments';

  @override
  String get addAttachment => 'Add Attachment';

  @override
  String get noAttachments => 'No attachments';

  @override
  String get taskHistory => 'Task History';

  @override
  String get modified => 'Modified';

  @override
  String get completedAt => 'Completed at';

  @override
  String get taskStatistics => 'Task Statistics';

  @override
  String get completionTime => 'Completion Time';

  @override
  String get categoryColor => 'Category Color';

  @override
  String get categoryIcon => 'Category Icon';

  @override
  String get selectColor => 'Select Color';

  @override
  String get categoryUpdated => 'Category updated successfully';

  @override
  String get errorUpdatingCategory => 'Error updating category';

  @override
  String categoryTasksCount(Object count) {
    return 'Tasks: $count';
  }

  @override
  String get addTasksToCategory => 'Add tasks to this category';

  @override
  String get categoryStatistics => 'Category Statistics';

  @override
  String totalTasksInCategory(Object count) {
    return 'Total tasks: $count';
  }

  @override
  String completedTasksInCategory(Object count) {
    return 'Completed: $count';
  }

  @override
  String pendingTasksInCategory(Object count) {
    return 'Pending: $count';
  }

  @override
  String overdueTasksInCategory(Object count) {
    return 'Overdue: $count';
  }

  @override
  String get categoryPerformance => 'Category Performance';

  @override
  String categoryEfficiency(Object score) {
    return 'Efficiency: $score%';
  }

  @override
  String get errorCompletingOnboarding => 'Error completing onboarding';

  @override
  String get accessibilitySettingsAppliedSuccessfully => 'Accessibility settings applied successfully';

  @override
  String errorApplyingSettings(Object error) {
    return 'Error applying settings: $error';
  }

  @override
  String get skipForNow => 'Skip for Now';

  @override
  String get highContrastMode => 'High Contrast Mode';

  @override
  String get largeTextMode => 'Large Text Mode';

  @override
  String get reducedMotion => 'Reduced Motion';

  @override
  String get accessibilitySetup => 'Accessibility Setup';

  @override
  String get accessibilitySetupDescription => 'Customize your app experience for better accessibility';

  @override
  String get weRecommendTheseSettings => 'We recommend these settings based on your preferences';

  @override
  String get youCanChangeTheseLater => 'You can change these later in settings';

  @override
  String get applySettings => 'Apply Settings';

  @override
  String get accessibilityCompleted => 'Accessibility setup completed';

  @override
  String get continueToApp => 'Continue to App';

  @override
  String get clearAllLocalData => 'Clear All Local Data';

  @override
  String get thisWillPermanentlyDelete => 'This will permanently delete:';

  @override
  String get allTasksCategoriesMoodsLocalSettings => '• All tasks\n• All categories\n• All moods\n• All local settings';

  @override
  String get afterDeletionTheAppWillResyncAllDataFromFirebase => 'After deletion, the app will resync all data from Firebase.';

  @override
  String get thisActionCannotBeUndone => 'This action cannot be undone!';

  @override
  String get deleteAllData => 'Delete All Data';

  @override
  String get forceSyncFromFirebase => 'Force Sync from Firebase';

  @override
  String get thisWill => 'This will:';

  @override
  String get downloadFreshDataOverwriteLocalChanges => '• Download fresh data from Firebase\n• Overwrite any local changes\n• Update all repositories';

  @override
  String get anyUnsyncedLocalChangesWillBeLost => 'Any unsynced local changes will be lost!';

  @override
  String get forceSync => 'Force Sync';

  @override
  String get clearingData => 'Clearing data...';

  @override
  String get allDataClearedAndResyncedSuccessfully => 'All data cleared and resynced successfully!';

  @override
  String get syncingFromFirebase => 'Syncing from Firebase...';

  @override
  String get dataSyncedSuccessfullyFromFirebase => 'Data synced successfully from Firebase!';

  @override
  String syncError(Object error) {
    return 'Sync error: $error';
  }

  @override
  String get developerTools => 'Developer Tools';

  @override
  String get performanceMemoryAndQualityMonitoring => 'Performance, memory, and quality monitoring';

  @override
  String get enablePomodoroOptimization => 'Enable Pomodoro Optimization';

  @override
  String get automaticallyPlanWorkSessions => 'Automatically plan work sessions';

  @override
  String get suggestedPlan => 'Suggested Plan:';

  @override
  String get workSessions => 'work sessions';

  @override
  String get minPerSession => 'min per session';

  @override
  String totalEstimatedTime(Object minutes) {
    return 'Total estimated time: $minutes min';
  }

  @override
  String get taskTitle => 'Task Title';

  @override
  String get taskDescription => 'Task Description';

  @override
  String get optional => 'Optional';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get setDueDate => 'Set Due Date';

  @override
  String get setReminder => 'Set Reminder';

  @override
  String get noReminder => 'No Reminder';

  @override
  String get setPriority => 'Set Priority';

  @override
  String get addSubtasks => 'Add Subtasks';

  @override
  String get saveTask => 'Save Task';

  @override
  String get taskCreatedSuccessfully => 'Task created successfully';

  @override
  String get pleaseFillAllRequiredFields => 'Please fill all required fields';

  @override
  String get taskTitleRequired => 'Task title is required';

  @override
  String get invalidDueDate => 'Invalid due date';

  @override
  String get dueDateMustBeInFuture => 'Due date must be in the future';

  @override
  String focusModeFor(Object taskTitle) {
    return 'Focus mode for $taskTitle';
  }

  @override
  String get taskDuplicatedSuccessfully => 'Task duplicated successfully';

  @override
  String get subtaskAddedSuccessfully => 'Subtask added successfully';

  @override
  String failedToAddSubtask(Object error) {
    return 'Failed to add subtask: $error';
  }

  @override
  String reminderSetFor(Object date) {
    return 'Reminder set for $date';
  }

  @override
  String get startFocusMode => 'Start Focus Mode';

  @override
  String get editTask => 'Edit Task';

  @override
  String get markAsCompleted => 'Mark as Completed';

  @override
  String get markAsIncomplete => 'Mark as Incomplete';

  @override
  String get taskActions => 'Task Actions';

  @override
  String get taskInformation => 'Task Information';

  @override
  String get timeTracking => 'Time Tracking';

  @override
  String get notes => 'Notes';

  @override
  String get attachments => 'Attachments';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get loading => 'Loading...';

  @override
  String get galleryPermissionIsRequiredToSelectProfileImage => 'Gallery permission is required to select profile image';

  @override
  String get settings => 'Settings';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get profilePicture => 'Profile Picture';

  @override
  String get changeProfilePicture => 'Change Profile Picture';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get removePhoto => 'Remove Photo';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get bio => 'Bio';

  @override
  String get tellUsAboutYourself => 'Tell us about yourself';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get security => 'Security';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get logout => 'Logout';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get errorUpdatingProfile => 'Error updating profile';

  @override
  String get profilePictureUpdatedSuccessfully => 'Profile picture updated successfully';

  @override
  String get errorUpdatingProfilePicture => 'Error updating profile picture';

  @override
  String get aboutTazbeet => 'About Tazbeet';

  @override
  String get appDescription => 'A smart task management app with Pomodoro integration and AI-powered recommendations.';

  @override
  String get features => 'Features:';

  @override
  String get smartTaskSortingWithAiRecommendations => '• Smart task sorting with AI recommendations';

  @override
  String get pomodoroTimerWithAdaptiveTiming => '• Pomodoro timer with adaptive timing';

  @override
  String get analyticsAndProductivityInsights => '• Analytics and productivity insights';

  @override
  String get moodTrackingAndAmbientSettings => '• Mood tracking and ambient settings';

  @override
  String get recurringTaskAutomation => '• Recurring task automation';

  @override
  String get welcomeToTazbeet => 'Welcome to Tazbeet';

  @override
  String get getStarted => 'Get Started';

  @override
  String get exploreFeatures => 'Explore Features';

  @override
  String get viewAllTasks => 'View All Tasks';

  @override
  String get createYourFirstTaskToGetStarted => 'Create your first task to get started';

  @override
  String get searchTasks => 'Search tasks...';

  @override
  String get filterTasks => 'Filter tasks';

  @override
  String get sortBy => 'Sort by';

  @override
  String get tryDifferentFilters => 'Try different filters or search terms';

  @override
  String errorLoadingAnalytics(Object error) {
    return 'Error loading analytics: $error';
  }

  @override
  String weeklyProgressOf(Object goal, Object progress) {
    return '$progress of $goal sessions';
  }

  @override
  String get recommendedAdjustments => 'Recommended Adjustments:';

  @override
  String get noRecommendationsAvailableAtThisTime => 'No recommendations available at this time.';

  @override
  String get pomodoroAnalytics => 'Pomodoro Analytics';

  @override
  String get weeklyStats => 'Weekly Stats';

  @override
  String get monthlyStats => 'Monthly Stats';

  @override
  String get allTimeStats => 'All-Time Stats';

  @override
  String get totalSessions => 'Total Sessions';

  @override
  String get completedSessions => 'Completed Sessions';

  @override
  String get averageSessionLength => 'Average Session Length';

  @override
  String get totalFocusTime => 'Total Focus Time';

  @override
  String get bestPerformanceDay => 'Best Performance Day';

  @override
  String get mostProductiveHour => 'Most Productive Hour';

  @override
  String get sessionCompletionRate => 'Session Completion Rate';

  @override
  String get focusTimeDistribution => 'Focus Time Distribution';

  @override
  String get breakTimeDistribution => 'Break Time Distribution';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get performanceMetrics => 'Performance Metrics';

  @override
  String get sessionHistory => 'Session History';

  @override
  String get exportData => 'Export Data';

  @override
  String get shareReport => 'Share Report';

  @override
  String get dateRange => 'Date Range';

  @override
  String get customRange => 'Custom Range';

  @override
  String defaultValue(Object isDefault) {
    return 'Default: $isDefault';
  }

  @override
  String get editMaintenanceMessage => 'Edit Maintenance Message';

  @override
  String get blockAllNonAdminUsers => '• Block all non-admin users';

  @override
  String get showMaintenanceScreenToUsers => '• Show maintenance screen to users';

  @override
  String get onlyAdminsCanAccessTheApp => '• Only admins can access the app';

  @override
  String get allowAllUsersToAccessTheApp => '• Allow all users to access the app';

  @override
  String get returnToNormalOperation => '• Return to normal operation';

  @override
  String get maintenanceMode => 'Maintenance Mode';

  @override
  String get maintenanceModeDescription => 'Put the app in maintenance mode';

  @override
  String get maintenanceMessage => 'Maintenance Message';

  @override
  String get enterMaintenanceMessage => 'Enter maintenance message';

  @override
  String get saveMaintenanceSettings => 'Save Maintenance Settings';

  @override
  String get maintenanceSettingsSaved => 'Maintenance settings saved successfully';

  @override
  String get errorSavingMaintenanceSettings => 'Error saving maintenance settings';

  @override
  String get viewDetailsButton => 'View Details';

  @override
  String get quickEditButton => 'Quick Edit';

  @override
  String get clearButton => 'Clear';

  @override
  String get searchButton => 'Search';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get resetToDefaults => 'Reset to Defaults';

  @override
  String get resetAllThemeSettingsToDefaultValues => 'Reset all theme settings to default values';

  @override
  String get reset => 'Reset';

  @override
  String get resetThemeSettings => 'Reset Theme Settings';

  @override
  String get thisWillResetAllThemeSettingsToTheirDefaultValues => 'This will reset all theme settings to their default values. You can always change them back later.';

  @override
  String get themeSettingsResetToDefaults => 'Theme settings reset to defaults';

  @override
  String get themeSettings => 'Theme Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get systemMode => 'System Mode';

  @override
  String get followSystemSettings => 'Follow system settings';

  @override
  String get useDarkTheme => 'Use dark theme';

  @override
  String get useLightTheme => 'Use light theme';

  @override
  String get colorTheme => 'Color Theme';

  @override
  String get accentColor => 'Accent Color';

  @override
  String get backgroundColor => 'Background Color';

  @override
  String get surfaceColor => 'Surface Color';

  @override
  String get textColor => 'Text Color';

  @override
  String get enableCustomColors => 'Enable Custom Colors';

  @override
  String get customColorSettings => 'Custom Color Settings';

  @override
  String get selectPrimaryColor => 'Select Primary Color';

  @override
  String get selectAccentColor => 'Select Accent Color';

  @override
  String get selectBackgroundColor => 'Select Background Color';

  @override
  String get selectSurfaceColor => 'Select Surface Color';

  @override
  String get selectTextColor => 'Select Text Color';

  @override
  String get colorPicker => 'Color Picker';

  @override
  String get chooseColor => 'Choose Color';

  @override
  String get selectedColor => 'Selected Color';

  @override
  String get applyColors => 'Apply Colors';

  @override
  String get resetColors => 'Reset Colors';

  @override
  String get colorSettingsSaved => 'Color settings saved successfully';

  @override
  String get errorSavingColorSettings => 'Error saving color settings';

  @override
  String get noMoodHistoryAvailableForSuggestions => 'No mood history available for suggestions';

  @override
  String addedSuggestedCheckInTimesFromYourMoodHistory(Object count) {
    return 'Added $count suggested check-in times from your mood history';
  }

  @override
  String get allSuggestedTimesAreAlreadyInYourList => 'All suggested times are already in your list';

  @override
  String failedToGetSuggestions(Object error) {
    return 'Failed to get suggestions: $error';
  }

  @override
  String get testMoodNotificationSent => 'Test mood notification sent!';

  @override
  String failedToSendTestNotification(Object error) {
    return 'Failed to send test notification: $error';
  }

  @override
  String get pendingMoodNotifications => 'Pending Mood Notifications';

  @override
  String moodNotificationsScheduledTotalPending(Object count, Object pending) {
    return '$count mood notifications scheduled\nTotal pending: $pending';
  }

  @override
  String failedToCheckPendingNotifications(Object error) {
    return 'Failed to check pending notifications: $error';
  }

  @override
  String get removeThisCheckInTime => 'Remove this check-in time?';

  @override
  String get receivePeriodicMoodCheckInReminders => 'Receive periodic mood check-in reminders';

  @override
  String get testMoodNotificationScheduledFor1MinuteFromNow => 'Test mood notification scheduled for 1 minute from now!';

  @override
  String failedToScheduleTestNotification(Object error) {
    return 'Failed to schedule test notification: $error';
  }

  @override
  String get testScheduledNotification => 'Test Scheduled Notification';

  @override
  String failedToCancelNotifications(Object error) {
    return 'Failed to cancel notifications: $error';
  }

  @override
  String get moodSettings => 'Mood Settings';

  @override
  String get notificationTimes => 'Notification Times';

  @override
  String get addNotificationTime => 'Add Notification Time';

  @override
  String get selectTime => 'Select Time';

  @override
  String get suggestedTimes => 'Suggested Times';

  @override
  String get getSuggestionsFromHistory => 'Get Suggestions from History';

  @override
  String get notificationTools => 'Notification Tools';

  @override
  String get noCheckInTimesSetAddOneToGetStarted => 'No check-in times set. Add one to get started!';

  @override
  String get pomodoroPlanning => 'Pomodoro Planning';

  @override
  String focusDifficulty(Object score) {
    return 'Focus Difficulty: $score';
  }

  @override
  String get easyFocusDeepFocusRequired => '1 = Easy focus, 10 = Deep focus required';

  @override
  String get priorityTitle => 'Priority';

  @override
  String get galleryPermissionRequired => 'Gallery permission is required to select profile image';

  @override
  String get authenticationErrorPleaseLogInAgain => 'Authentication error. Please log in again.';

  @override
  String get tryAdjustingYourSearchTerms => 'Try adjusting your search terms';

  @override
  String get defaultLabel => 'Default';

  @override
  String get defaultCategory => 'Default Category';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get refreshData => 'Refresh Data';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String defaultYes(Object value) {
    return 'Default: $value';
  }

  @override
  String get appSettings => 'App Settings';

  @override
  String get generalSettings => 'General Settings';

  @override
  String get userRegistration => 'User Registration';

  @override
  String get newUsersCanRegister => 'New users can register';

  @override
  String get registrationIsDisabled => 'Registration is disabled';

  @override
  String get appInformation => 'App Information';

  @override
  String get appVersion => 'App Version';

  @override
  String get supportEmail => 'Support Email';

  @override
  String get lastUpdated => 'Last Updated';

  @override
  String get message => 'Message';

  @override
  String get enterMessageUsersWillSee => 'Enter the message users will see...';

  @override
  String maintenanceModeConfirmation(Object action, Object details) {
    return 'Are you sure you want to $action maintenance mode?\n\n$details';
  }

  @override
  String get onlyAdminsCanAccessApp => '• Only admins can access the app';

  @override
  String get allowAllUsersToAccessApp => '• Allow all users to access the app';

  @override
  String get enableMaintenanceMode => 'Enable Maintenance Mode';

  @override
  String get disableMaintenanceMode => 'Disable Maintenance Mode';

  @override
  String get disable => 'Disable';

  @override
  String get refresh => 'Refresh';

  @override
  String get performanceMonitor => 'Performance Monitor';

  @override
  String trackedOperations(Object count) {
    return 'Tracked Operations: $count';
  }

  @override
  String slowOperations(Object count) {
    return 'Slow Operations (>500ms): $count';
  }

  @override
  String get logReport => 'Log Report';

  @override
  String get memoryManager => 'Memory Manager';

  @override
  String get forceCleanup => 'Force Cleanup';

  @override
  String get logStats => 'Log Stats';

  @override
  String get animationOptimizer => 'Animation Optimizer';

  @override
  String get codeQualityMonitor => 'Code Quality Monitor';

  @override
  String get qualityScore => 'Quality Score: ';

  @override
  String get notificationVerification => 'Notification Verification';

  @override
  String get checkPending => 'Check Pending';

  @override
  String get verifyAllTasks => 'Verify All Tasks';

  @override
  String get actions => 'Actions';

  @override
  String get clearPerformance => 'Clear Performance';

  @override
  String get clearQuality => 'Clear Quality';

  @override
  String get performanceReportLoggedToConsole => 'Performance report logged to console';

  @override
  String get memoryCleanupCompleted => 'Memory cleanup completed';

  @override
  String get memoryStatsLoggedToConsole => 'Memory stats logged to console';

  @override
  String get animationStatsLoggedToConsole => 'Animation stats logged to console';

  @override
  String get qualityReportLoggedToConsole => 'Quality report logged to console';

  @override
  String get performanceMetricsCleared => 'Performance metrics cleared';

  @override
  String get qualityMetricsCleared => 'Quality metrics cleared';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get importData => 'Import Data';

  @override
  String get backupAndRestore => 'Backup & Restore';

  @override
  String get exportYourTasksToExternalFormats => 'Export your tasks to external formats';

  @override
  String get exportCSV => 'Export CSV';

  @override
  String get exportJSON => 'Export JSON';

  @override
  String get exportICSCalendar => 'Export ICS (Calendar)';

  @override
  String get importTasksFromExternalFiles => 'Import tasks from external files';

  @override
  String get importFromFile => 'Import from File';

  @override
  String get createAndRestoreBackups => 'Create and restore backups';

  @override
  String get createBackup => 'Create Backup';

  @override
  String get restoreBackup => 'Restore Backup';

  @override
  String get notificationDeleted => 'Notification deleted';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get areYouSureYouWantToClearAllNotificationHistory => 'Are you sure you want to clear all notification history?';

  @override
  String get clearAll => 'Clear All';

  @override
  String get historyCleared => 'History cleared';

  @override
  String get smartFeaturesTutorial => 'Smart Features Tutorial';

  @override
  String get previous => 'Previous';

  @override
  String get completeTutorial => 'Complete Tutorial';

  @override
  String get customizeYourExperience => 'Customize your experience';

  @override
  String get adjustTheseSettingsToMakeTheAppWorkBetterForYou => 'Adjust these settings to make the app work better for you';

  @override
  String get minimizeAnimationsAndTransitions => 'Minimize animations and transitions';

  @override
  String get controlTheAppWithYourVoice => 'Control the app with your voice';

  @override
  String get increaseColorContrastForBetterVisibility => 'Increase color contrast for better visibility';

  @override
  String get makeTextLargerAndEasierToRead => 'Make text larger and easier to read';

  @override
  String get needHelp => 'Need help?';

  @override
  String get enableVoiceTasks => 'Enable Voice Tasks';

  @override
  String get createTasksWithYourVoice => 'Create tasks with your voice';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get thankYouForYourPatience => 'Thank you for your patience 💙';

  @override
  String get moodAlreadyLoggedToday => 'You have already logged your mood today';

  @override
  String get updateTodaysEntryInstead => 'You can update today\'s entry instead';

  @override
  String get viewAndUpdateMood => 'View & Update Mood';

  @override
  String get okButton => 'OK';

  @override
  String get yourIntelligentTaskManagementCompanionWithAIPoweredFeatures => 'Your intelligent task management companion with AI-powered features';

  @override
  String get smartTaskSorting => 'Smart Task Sorting';

  @override
  String get experienceAIPoweredTaskPrioritizationThatAdaptsToYourPatterns => 'Experience AI-powered task prioritization that adapts to your patterns';

  @override
  String get pomodoroIntegration => 'Pomodoro Integration';

  @override
  String get focusBetterWithAdaptiveTimingAndSmartBreaks => 'Focus better with adaptive timing and smart breaks';

  @override
  String get moodEnergyTracking => 'Mood & Energy Tracking';

  @override
  String get understandYourPatternsAndOptimizeYourProductivity => 'Understand your patterns and optimize your productivity';

  @override
  String get accessibilityFeatures => 'Accessibility Features';

  @override
  String get customizeTheAppToWorkBestForYou => 'Customize the app to work best for you';

  @override
  String get viewAndUpdateTodaysMoodEntry => 'Would you like to view and update today\'s mood entry?';

  @override
  String hiveBoxes(Object count) {
    return 'Hive Boxes: $count';
  }

  @override
  String status(Object status) {
    return 'Status: $status';
  }

  @override
  String pendingNotifications(Object count) {
    return 'Pending notifications: $count';
  }

  @override
  String get verificationReportLoggedToConsole => 'Verification report logged to console';

  @override
  String get performanceMonitoring => 'Performance Monitoring';

  @override
  String get memoryManagement => 'Memory Management';

  @override
  String get animationOptimization => 'Animation Optimization';

  @override
  String get codeQuality => 'Code Quality';

  @override
  String get dataSync => 'Data Sync';

  @override
  String get clearAllMetrics => 'Clear All Metrics';

  @override
  String get developerOptions => 'Developer Options';

  @override
  String get debugMode => 'Debug Mode';

  @override
  String get enableDebugMode => 'Enable Debug Mode';

  @override
  String get disableDebugMode => 'Disable Debug Mode';

  @override
  String get debugModeDescription => 'Enable additional logging and debugging features';

  @override
  String get memoryUsage => 'Memory Usage';

  @override
  String get databaseSize => 'Database Size';

  @override
  String get cacheSize => 'Cache Size';

  @override
  String get networkRequests => 'Network Requests';

  @override
  String get errorTracking => 'Error Tracking';

  @override
  String get logLevel => 'Log Level';

  @override
  String get verbose => 'Verbose';

  @override
  String get debug => 'Debug';

  @override
  String get info => 'Info';

  @override
  String get warning => 'Warning';

  @override
  String get none => 'None';

  @override
  String get exportLogs => 'Export Logs';

  @override
  String get importLogs => 'Import Logs';

  @override
  String get clearLogs => 'Clear Logs';

  @override
  String get logsExported => 'Logs exported successfully';

  @override
  String get logsImported => 'Logs imported successfully';

  @override
  String get logsCleared => 'Logs cleared successfully';

  @override
  String get errorExportingLogs => 'Error exporting logs';

  @override
  String get errorImportingLogs => 'Error importing logs';

  @override
  String get errorClearingLogs => 'Error clearing logs';
}
