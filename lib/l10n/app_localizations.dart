import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Tazbeet'**
  String get appTitle;

  /// No description provided for @homeScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeScreenTitle;

  /// No description provided for @settingsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsScreenTitle;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @themeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeLabel;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @taskTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Task Title'**
  String get taskTitleLabel;

  /// No description provided for @taskDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get taskDescriptionLabel;

  /// No description provided for @addTaskButton.
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTaskButton;

  /// No description provided for @editTaskButton.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTaskButton;

  /// No description provided for @deleteTaskButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get deleteTaskButton;

  /// No description provided for @confirmDeleteTask.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{taskTitle}\"?'**
  String confirmDeleteTask(String taskTitle);

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTask;

  /// No description provided for @addTaskToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Add a task to get started'**
  String get addTaskToGetStarted;

  /// No description provided for @voiceTaskCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Task with Voice'**
  String get voiceTaskCreate;

  /// No description provided for @voiceTaskHint.
  ///
  /// In en, this message translates to:
  /// **'Tap microphone to speak'**
  String get voiceTaskHint;

  /// No description provided for @voiceTaskProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing your voice...'**
  String get voiceTaskProcessing;

  /// No description provided for @voiceTaskCreated.
  ///
  /// In en, this message translates to:
  /// **'Voice task created'**
  String get voiceTaskCreated;

  /// No description provided for @taskValidationFailed.
  ///
  /// In en, this message translates to:
  /// **'Task validation failed'**
  String get taskValidationFailed;

  /// No description provided for @errorCreatingTask.
  ///
  /// In en, this message translates to:
  /// **'Error creating task'**
  String get errorCreatingTask;

  /// No description provided for @tryVoiceTasks.
  ///
  /// In en, this message translates to:
  /// **'Try voice tasks! Tap the microphone to create tasks instantly.'**
  String get tryVoiceTasks;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @resetButton.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetButton;

  /// No description provided for @appearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSection;

  /// No description provided for @notificationsSection.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSection;

  /// No description provided for @notificationHistory.
  ///
  /// In en, this message translates to:
  /// **'Notification History'**
  String get notificationHistory;

  /// No description provided for @notificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notificationPreferences;

  /// No description provided for @pomodoroSection.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Timer'**
  String get pomodoroSection;

  /// No description provided for @dataBackupSection.
  ///
  /// In en, this message translates to:
  /// **'Data & Backup'**
  String get dataBackupSection;

  /// No description provided for @privacyAnalyticsSection.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Analytics'**
  String get privacyAnalyticsSection;

  /// No description provided for @regionalSection.
  ///
  /// In en, this message translates to:
  /// **'Regional'**
  String get regionalSection;

  /// No description provided for @moodSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mood Settings'**
  String get moodSettingsTitle;

  /// No description provided for @moodSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure mood check-in notifications'**
  String get moodSettingsSubtitle;

  /// No description provided for @enableMoodNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Mood Notifications'**
  String get enableMoodNotifications;

  /// No description provided for @moodCheckInTimes.
  ///
  /// In en, this message translates to:
  /// **'Check-in Times'**
  String get moodCheckInTimes;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @suggestTimes.
  ///
  /// In en, this message translates to:
  /// **'Suggest Times'**
  String get suggestTimes;

  /// No description provided for @completedTasks.
  ///
  /// In en, this message translates to:
  /// **'Completed tasks'**
  String get completedTasks;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @shortBreak.
  ///
  /// In en, this message translates to:
  /// **'Short Break'**
  String get shortBreak;

  /// No description provided for @longBreak.
  ///
  /// In en, this message translates to:
  /// **'Long Break'**
  String get longBreak;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @idle.
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get idle;

  /// No description provided for @pomodoroSessionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Session Completed'**
  String get pomodoroSessionCompleted;

  /// No description provided for @highPriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get highPriorityLabel;

  /// No description provided for @mediumPriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get mediumPriorityLabel;

  /// No description provided for @lowPriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get lowPriorityLabel;

  /// No description provided for @addTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Task'**
  String get addTaskTitle;

  /// No description provided for @priorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority:'**
  String get priorityLabel;

  /// No description provided for @dueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Due Date (Optional)'**
  String get dueDateLabel;

  /// No description provided for @selectDueDate.
  ///
  /// In en, this message translates to:
  /// **'Select due date'**
  String get selectDueDate;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category (Optional)'**
  String get categoryLabel;

  /// No description provided for @noCategory.
  ///
  /// In en, this message translates to:
  /// **'No Category'**
  String get noCategory;

  /// No description provided for @repeatSettings.
  ///
  /// In en, this message translates to:
  /// **'Repeat Settings'**
  String get repeatSettings;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @editTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTaskTitle;

  /// No description provided for @updateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateButton;

  /// No description provided for @ambientSounds.
  ///
  /// In en, this message translates to:
  /// **'Ambient Sounds'**
  String get ambientSounds;

  /// No description provided for @focusAndRelaxation.
  ///
  /// In en, this message translates to:
  /// **'Focus & Relaxation'**
  String get focusAndRelaxation;

  /// No description provided for @chooseBackgroundSound.
  ///
  /// In en, this message translates to:
  /// **'Choose a background sound to help you concentrate or relax'**
  String get chooseBackgroundSound;

  /// No description provided for @volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// No description provided for @fadeIn.
  ///
  /// In en, this message translates to:
  /// **'Fade In'**
  String get fadeIn;

  /// No description provided for @fadeOut.
  ///
  /// In en, this message translates to:
  /// **'Fade Out'**
  String get fadeOut;

  /// No description provided for @noCategoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get noCategoriesYet;

  /// No description provided for @createCategoriesToOrganize.
  ///
  /// In en, this message translates to:
  /// **'Create categories to organize your tasks'**
  String get createCategoriesToOrganize;

  /// No description provided for @createCategory.
  ///
  /// In en, this message translates to:
  /// **'Create Category'**
  String get createCategory;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @enterCategoryName.
  ///
  /// In en, this message translates to:
  /// **'Enter category name'**
  String get enterCategoryName;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @pickAColor.
  ///
  /// In en, this message translates to:
  /// **'Pick a color'**
  String get pickAColor;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get deleteCategory;

  /// No description provided for @confirmDeleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{categoryName}\"? This will remove the category from all associated tasks.'**
  String confirmDeleteCategory(String categoryName);

  /// No description provided for @tasksCount.
  ///
  /// In en, this message translates to:
  /// **'Tasks Count'**
  String tasksCount(int count);

  /// No description provided for @selectButton.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectButton;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @productivityScore.
  ///
  /// In en, this message translates to:
  /// **'Productivity Score'**
  String get productivityScore;

  /// No description provided for @weeklyProgress.
  ///
  /// In en, this message translates to:
  /// **'Weekly Progress'**
  String get weeklyProgress;

  /// No description provided for @categoryProgress.
  ///
  /// In en, this message translates to:
  /// **'Category Progress'**
  String get categoryProgress;

  /// No description provided for @totaltasks.
  ///
  /// In en, this message translates to:
  /// **'Total Tasks'**
  String get totaltasks;

  /// No description provided for @dueDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDateTitle;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date: {dueDate}'**
  String dueDate(Object dueDate);

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @dueThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Due This Week'**
  String get dueThisWeek;

  /// No description provided for @logMood.
  ///
  /// In en, this message translates to:
  /// **'Log Your Mood'**
  String get logMood;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @energyLevel.
  ///
  /// In en, this message translates to:
  /// **'Energy Level'**
  String get energyLevel;

  /// No description provided for @focusLevel.
  ///
  /// In en, this message translates to:
  /// **'Focus Level'**
  String get focusLevel;

  /// No description provided for @stressLevel.
  ///
  /// In en, this message translates to:
  /// **'Stress Level'**
  String get stressLevel;

  /// No description provided for @saveMood.
  ///
  /// In en, this message translates to:
  /// **'Save Mood'**
  String get saveMood;

  /// No description provided for @veryBad.
  ///
  /// In en, this message translates to:
  /// **'Very Bad'**
  String get veryBad;

  /// No description provided for @bad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get bad;

  /// No description provided for @neutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get neutral;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @veryGood.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
  String get veryGood;

  /// No description provided for @moodCheckInTitle.
  ///
  /// In en, this message translates to:
  /// **'Mood Check-In'**
  String get moodCheckInTitle;

  /// No description provided for @moodHowAreYouFeeling.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get moodHowAreYouFeeling;

  /// No description provided for @moodSelectLevel.
  ///
  /// In en, this message translates to:
  /// **'Select your mood level'**
  String get moodSelectLevel;

  /// No description provided for @moodEnergyLevel.
  ///
  /// In en, this message translates to:
  /// **'Energy Level'**
  String get moodEnergyLevel;

  /// No description provided for @moodFocusLevel.
  ///
  /// In en, this message translates to:
  /// **'Focus Level'**
  String get moodFocusLevel;

  /// No description provided for @moodStressLevel.
  ///
  /// In en, this message translates to:
  /// **'Stress Level'**
  String get moodStressLevel;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @moodNoteOptional.
  ///
  /// In en, this message translates to:
  /// **'Add a note (optional)'**
  String get moodNoteOptional;

  /// No description provided for @moodNoteHint.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get moodNoteHint;

  /// No description provided for @moodSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Mood'**
  String get moodSaveButton;

  /// No description provided for @moodVeryBad.
  ///
  /// In en, this message translates to:
  /// **'Really struggling'**
  String get moodVeryBad;

  /// No description provided for @moodBad.
  ///
  /// In en, this message translates to:
  /// **'Not great'**
  String get moodBad;

  /// No description provided for @moodNeutral.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get moodNeutral;

  /// No description provided for @moodGood.
  ///
  /// In en, this message translates to:
  /// **'Pretty good'**
  String get moodGood;

  /// No description provided for @moodVeryGood.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get moodVeryGood;

  /// No description provided for @moodSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Mood saved successfully!'**
  String get moodSavedSuccess;

  /// No description provided for @moodSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save mood'**
  String get moodSaveFailed;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @noCategoriesYetDescription.
  ///
  /// In en, this message translates to:
  /// **'Create categories to organize your tasks'**
  String get noCategoriesYetDescription;

  /// No description provided for @editButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editButton;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @emergencyControls.
  ///
  /// In en, this message translates to:
  /// **'Emergency Controls'**
  String get emergencyControls;

  /// No description provided for @emergencyMode.
  ///
  /// In en, this message translates to:
  /// **'Emergency Mode'**
  String get emergencyMode;

  /// No description provided for @activateEmergencyMode.
  ///
  /// In en, this message translates to:
  /// **'Activate emergency mode to suspend all reminders and timers'**
  String get activateEmergencyMode;

  /// No description provided for @emergencyModeActive.
  ///
  /// In en, this message translates to:
  /// **'Emergency Mode Active'**
  String get emergencyModeActive;

  /// No description provided for @allRemindersSuspended.
  ///
  /// In en, this message translates to:
  /// **'All reminders and timers are suspended'**
  String get allRemindersSuspended;

  /// No description provided for @emergencyModeInactive.
  ///
  /// In en, this message translates to:
  /// **'Emergency Mode'**
  String get emergencyModeInactive;

  /// No description provided for @suspendRemindersTimers.
  ///
  /// In en, this message translates to:
  /// **'Suspend all reminders and timers immediately'**
  String get suspendRemindersTimers;

  /// No description provided for @quickControls.
  ///
  /// In en, this message translates to:
  /// **'Quick Controls'**
  String get quickControls;

  /// No description provided for @fifteenMinPause.
  ///
  /// In en, this message translates to:
  /// **'15 Min Pause'**
  String get fifteenMinPause;

  /// No description provided for @oneHourPause.
  ///
  /// In en, this message translates to:
  /// **'1 Hour Pause'**
  String get oneHourPause;

  /// No description provided for @resumeAll.
  ///
  /// In en, this message translates to:
  /// **'Resume All'**
  String get resumeAll;

  /// No description provided for @remindersSuspended.
  ///
  /// In en, this message translates to:
  /// **'Reminders Suspended'**
  String get remindersSuspended;

  /// No description provided for @timeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time remaining: {time}'**
  String timeRemaining(String time);

  /// No description provided for @resumeNow.
  ///
  /// In en, this message translates to:
  /// **'Resume Now'**
  String get resumeNow;

  /// No description provided for @moodHistory.
  ///
  /// In en, this message translates to:
  /// **'Mood History'**
  String get moodHistory;

  /// No description provided for @noMoodEntriesYet.
  ///
  /// In en, this message translates to:
  /// **'No mood entries yet'**
  String get noMoodEntriesYet;

  /// No description provided for @startLoggingMoods.
  ///
  /// In en, this message translates to:
  /// **'Start logging your moods to see your history'**
  String get startLoggingMoods;

  /// No description provided for @moodHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Mood History'**
  String get moodHistoryTitle;

  /// No description provided for @startTracking.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your mood journey'**
  String get startTracking;

  /// No description provided for @quickMoodCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Quick Mood Check-In'**
  String get quickMoodCheckIn;

  /// No description provided for @moodsForDate.
  ///
  /// In en, this message translates to:
  /// **'Moods for {date}'**
  String moodsForDate(Object date);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @positive.
  ///
  /// In en, this message translates to:
  /// **'Positive'**
  String get positive;

  /// No description provided for @negative.
  ///
  /// In en, this message translates to:
  /// **'Negative'**
  String get negative;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @energy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energy;

  /// No description provided for @focus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focus;

  /// No description provided for @stress.
  ///
  /// In en, this message translates to:
  /// **'Stress'**
  String get stress;

  /// No description provided for @howAreYou.
  ///
  /// In en, this message translates to:
  /// **'How are you?'**
  String get howAreYou;

  /// No description provided for @yourMood.
  ///
  /// In en, this message translates to:
  /// **'Your mood'**
  String get yourMood;

  /// No description provided for @howAreYouFeelingRightNow.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling right now?'**
  String get howAreYouFeelingRightNow;

  /// No description provided for @tapOptionBestDescribesMood.
  ///
  /// In en, this message translates to:
  /// **'Tap the option that best describes your mood'**
  String get tapOptionBestDescribesMood;

  /// No description provided for @addNoteOptional.
  ///
  /// In en, this message translates to:
  /// **'Add a note (optional)'**
  String get addNoteOptional;

  /// No description provided for @whatsOnYourMind.
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind?'**
  String get whatsOnYourMind;

  /// No description provided for @moodAdded.
  ///
  /// In en, this message translates to:
  /// **'Mood added'**
  String get moodAdded;

  /// No description provided for @moodUpdated.
  ///
  /// In en, this message translates to:
  /// **'Mood updated'**
  String get moodUpdated;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @reallyStruggling.
  ///
  /// In en, this message translates to:
  /// **'Really struggling'**
  String get reallyStruggling;

  /// No description provided for @notGreat.
  ///
  /// In en, this message translates to:
  /// **'Not great'**
  String get notGreat;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @prettyGood.
  ///
  /// In en, this message translates to:
  /// **'Pretty good'**
  String get prettyGood;

  /// No description provided for @great.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get great;

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String percent(int value);

  /// No description provided for @rain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get rain;

  /// No description provided for @oceanWaves.
  ///
  /// In en, this message translates to:
  /// **'Ocean Waves'**
  String get oceanWaves;

  /// No description provided for @forest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get forest;

  /// No description provided for @whiteNoise.
  ///
  /// In en, this message translates to:
  /// **'White Noise'**
  String get whiteNoise;

  /// No description provided for @coffeeShop.
  ///
  /// In en, this message translates to:
  /// **'Coffee Shop'**
  String get coffeeShop;

  /// No description provided for @fireplace.
  ///
  /// In en, this message translates to:
  /// **'Fireplace'**
  String get fireplace;

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// No description provided for @thunderstorm.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get thunderstorm;

  /// No description provided for @taskCompleted.
  ///
  /// In en, this message translates to:
  /// **'Task completed successfully'**
  String get taskCompleted;

  /// No description provided for @taskDeleted.
  ///
  /// In en, this message translates to:
  /// **'Task deleted successfully'**
  String get taskDeleted;

  /// No description provided for @categoryCreated.
  ///
  /// In en, this message translates to:
  /// **'Category created successfully'**
  String get categoryCreated;

  /// No description provided for @categoryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Category deleted successfully'**
  String get categoryDeleted;

  /// No description provided for @pomodoroStarted.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro session started'**
  String get pomodoroStarted;

  /// No description provided for @pomodoroCompleted.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro session completed'**
  String get pomodoroCompleted;

  /// No description provided for @breakTime.
  ///
  /// In en, this message translates to:
  /// **'Break time!'**
  String get breakTime;

  /// No description provided for @workTime.
  ///
  /// In en, this message translates to:
  /// **'Work time!'**
  String get workTime;

  /// No description provided for @sessionComplete.
  ///
  /// In en, this message translates to:
  /// **'Session complete'**
  String get sessionComplete;

  /// No description provided for @allSessionsComplete.
  ///
  /// In en, this message translates to:
  /// **'All sessions complete'**
  String get allSessionsComplete;

  /// No description provided for @progressSaved.
  ///
  /// In en, this message translates to:
  /// **'Progress saved'**
  String get progressSaved;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @dataExported.
  ///
  /// In en, this message translates to:
  /// **'Data exported successfully'**
  String get dataExported;

  /// No description provided for @dataImported.
  ///
  /// In en, this message translates to:
  /// **'Data imported successfully'**
  String get dataImported;

  /// No description provided for @backupCreated.
  ///
  /// In en, this message translates to:
  /// **'Backup created'**
  String get backupCreated;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get backupRestored;

  /// No description provided for @notificationEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get notificationEnabled;

  /// No description provided for @notificationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get notificationDisabled;

  /// No description provided for @soundEnabled.
  ///
  /// In en, this message translates to:
  /// **'Sound enabled'**
  String get soundEnabled;

  /// No description provided for @soundDisabled.
  ///
  /// In en, this message translates to:
  /// **'Sound disabled'**
  String get soundDisabled;

  /// No description provided for @vibrationEnabled.
  ///
  /// In en, this message translates to:
  /// **'Vibration enabled'**
  String get vibrationEnabled;

  /// No description provided for @vibrationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Vibration disabled'**
  String get vibrationDisabled;

  /// No description provided for @highContrastEnabled.
  ///
  /// In en, this message translates to:
  /// **'High contrast enabled'**
  String get highContrastEnabled;

  /// No description provided for @highContrastDisabled.
  ///
  /// In en, this message translates to:
  /// **'High contrast disabled'**
  String get highContrastDisabled;

  /// No description provided for @largeTextEnabled.
  ///
  /// In en, this message translates to:
  /// **'Large text enabled'**
  String get largeTextEnabled;

  /// No description provided for @largeTextDisabled.
  ///
  /// In en, this message translates to:
  /// **'Large text disabled'**
  String get largeTextDisabled;

  /// No description provided for @screenReaderEnabled.
  ///
  /// In en, this message translates to:
  /// **'Screen reader enabled'**
  String get screenReaderEnabled;

  /// No description provided for @screenReaderDisabled.
  ///
  /// In en, this message translates to:
  /// **'Screen reader disabled'**
  String get screenReaderDisabled;

  /// No description provided for @autoBackupEnabled.
  ///
  /// In en, this message translates to:
  /// **'Auto backup enabled'**
  String get autoBackupEnabled;

  /// No description provided for @autoBackupDisabled.
  ///
  /// In en, this message translates to:
  /// **'Auto backup disabled'**
  String get autoBackupDisabled;

  /// No description provided for @analyticsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Analytics enabled'**
  String get analyticsEnabled;

  /// No description provided for @analyticsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Analytics disabled'**
  String get analyticsDisabled;

  /// No description provided for @crashReportingEnabled.
  ///
  /// In en, this message translates to:
  /// **'Crash reporting enabled'**
  String get crashReportingEnabled;

  /// No description provided for @crashReportingDisabled.
  ///
  /// In en, this message translates to:
  /// **'Crash reporting disabled'**
  String get crashReportingDisabled;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @tapToAddFirstTask.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to add your first task'**
  String get tapToAddFirstTask;

  /// No description provided for @deleteTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get deleteTaskTitle;

  /// No description provided for @filterTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter Tasks'**
  String get filterTasksTitle;

  /// No description provided for @allLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allLabel;

  /// No description provided for @incompleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Incomplete'**
  String get incompleteLabel;

  /// No description provided for @completedLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedLabel;

  /// No description provided for @applyButton.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyButton;

  /// No description provided for @clearAllButton.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAllButton;

  /// No description provided for @profileScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileScreenTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @birthdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthdayLabel;

  /// No description provided for @selectBirthday.
  ///
  /// In en, this message translates to:
  /// **'Select birthday'**
  String get selectBirthday;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully'**
  String get profileSaved;

  /// No description provided for @pleaseFixErrors.
  ///
  /// In en, this message translates to:
  /// **'Please fix the errors above'**
  String get pleaseFixErrors;

  /// No description provided for @splashAppName.
  ///
  /// In en, this message translates to:
  /// **'Tazbeet'**
  String get splashAppName;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Your Personal Task Manager'**
  String get splashTagline;

  /// No description provided for @splashBranding.
  ///
  /// In en, this message translates to:
  /// **'Stay Organized, Stay Productive'**
  String get splashBranding;

  /// No description provided for @splashVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get splashVersion;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Organize your tasks and boost productivity'**
  String get loginSubtitle;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// No description provided for @termsAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'By signing in, you agree to our Terms of Service and Privacy Policy'**
  String get termsAndPrivacy;

  /// No description provided for @moodTracking.
  ///
  /// In en, this message translates to:
  /// **'Mood Tracking'**
  String get moodTracking;

  /// No description provided for @ambientMode.
  ///
  /// In en, this message translates to:
  /// **'Ambient Mode'**
  String get ambientMode;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @noTasksYet.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get noTasksYet;

  /// No description provided for @noTasksInCategory.
  ///
  /// In en, this message translates to:
  /// **'No tasks in this category'**
  String get noTasksInCategory;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String error(String message);

  /// No description provided for @editProfileInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit your profile information'**
  String get editProfileInfo;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @highContrast.
  ///
  /// In en, this message translates to:
  /// **'High Contrast'**
  String get highContrast;

  /// No description provided for @increaseContrast.
  ///
  /// In en, this message translates to:
  /// **'Increase contrast for better visibility'**
  String get increaseContrast;

  /// No description provided for @largeText.
  ///
  /// In en, this message translates to:
  /// **'Large Text'**
  String get largeText;

  /// No description provided for @useLargerFontSizes.
  ///
  /// In en, this message translates to:
  /// **'Use larger font sizes'**
  String get useLargerFontSizes;

  /// No description provided for @screenReader.
  ///
  /// In en, this message translates to:
  /// **'Screen Reader'**
  String get screenReader;

  /// No description provided for @enableScreenReaderSupport.
  ///
  /// In en, this message translates to:
  /// **'Enable screen reader support'**
  String get enableScreenReaderSupport;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @notificationFrequency.
  ///
  /// In en, this message translates to:
  /// **'Notification Frequency'**
  String get notificationFrequency;

  /// No description provided for @immediate.
  ///
  /// In en, this message translates to:
  /// **'Immediate'**
  String get immediate;

  /// No description provided for @hourly.
  ///
  /// In en, this message translates to:
  /// **'Hourly'**
  String get hourly;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @pomodoroPreset.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Preset'**
  String get pomodoroPreset;

  /// No description provided for @classicPreset.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get classicPreset;

  /// No description provided for @quickstart.
  ///
  /// In en, this message translates to:
  /// **'Quick Start'**
  String get quickstart;

  /// No description provided for @deepWork.
  ///
  /// In en, this message translates to:
  /// **'Deep Work'**
  String get deepWork;

  /// No description provided for @students.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get students;

  /// No description provided for @shortPreset.
  ///
  /// In en, this message translates to:
  /// **'Short (15/3/10)'**
  String get shortPreset;

  /// No description provided for @longPreset.
  ///
  /// In en, this message translates to:
  /// **'Long (50/10/30)'**
  String get longPreset;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @customDurations.
  ///
  /// In en, this message translates to:
  /// **'Custom Durations (minutes)'**
  String get customDurations;

  /// No description provided for @sessionsToLongBreak.
  ///
  /// In en, this message translates to:
  /// **'Sessions to Long Break'**
  String get sessionsToLongBreak;

  /// No description provided for @autoBackup.
  ///
  /// In en, this message translates to:
  /// **'Auto Backup'**
  String get autoBackup;

  /// No description provided for @automaticallyBackupData.
  ///
  /// In en, this message translates to:
  /// **'Automatically backup your data'**
  String get automaticallyBackupData;

  /// No description provided for @backupFrequency.
  ///
  /// In en, this message translates to:
  /// **'Backup Frequency'**
  String get backupFrequency;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String days(int count);

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @helpImproveApp.
  ///
  /// In en, this message translates to:
  /// **'Help improve the app with usage data'**
  String get helpImproveApp;

  /// No description provided for @crashReporting.
  ///
  /// In en, this message translates to:
  /// **'Crash Reporting'**
  String get crashReporting;

  /// No description provided for @sendCrashReports.
  ///
  /// In en, this message translates to:
  /// **'Send crash reports to help fix issues'**
  String get sendCrashReports;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @dateFormat.
  ///
  /// In en, this message translates to:
  /// **'Date Format'**
  String get dateFormat;

  /// No description provided for @timeFormat.
  ///
  /// In en, this message translates to:
  /// **'Time Format'**
  String get timeFormat;

  /// No description provided for @twelveHour.
  ///
  /// In en, this message translates to:
  /// **'12h'**
  String get twelveHour;

  /// No description provided for @twentyFourHour.
  ///
  /// In en, this message translates to:
  /// **'24h'**
  String get twentyFourHour;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @howAreYouFeeling.
  ///
  /// In en, this message translates to:
  /// **'😊 How are you feeling?'**
  String get howAreYouFeeling;

  /// No description provided for @tapToLogMood.
  ///
  /// In en, this message translates to:
  /// **'Tap to log your mood'**
  String get tapToLogMood;

  /// No description provided for @yourMoodInsights.
  ///
  /// In en, this message translates to:
  /// **'Your Mood Insights'**
  String get yourMoodInsights;

  /// No description provided for @totalEntries.
  ///
  /// In en, this message translates to:
  /// **'Total Entries'**
  String get totalEntries;

  /// No description provided for @averageMood.
  ///
  /// In en, this message translates to:
  /// **'Average Mood'**
  String get averageMood;

  /// No description provided for @mostCommonMood.
  ///
  /// In en, this message translates to:
  /// **'Most Common Mood'**
  String get mostCommonMood;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @averageEnergy.
  ///
  /// In en, this message translates to:
  /// **'Average Energy'**
  String get averageEnergy;

  /// No description provided for @averageFocus.
  ///
  /// In en, this message translates to:
  /// **'Average Focus'**
  String get averageFocus;

  /// No description provided for @averageStress.
  ///
  /// In en, this message translates to:
  /// **'Average Stress'**
  String get averageStress;

  /// No description provided for @metricValue.
  ///
  /// In en, this message translates to:
  /// **'{label}: {value}/10'**
  String metricValue(String label, int value);

  /// No description provided for @noTasksFound.
  ///
  /// In en, this message translates to:
  /// **'No tasks found'**
  String get noTasksFound;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search tasks...'**
  String get searchHint;

  /// No description provided for @deleteTaskConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get deleteTaskConfirmationTitle;

  /// No description provided for @deleteSubtask.
  ///
  /// In en, this message translates to:
  /// **'Delete subtask'**
  String get deleteSubtask;

  /// No description provided for @confirmDeleteSubtask.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this subtask?'**
  String get confirmDeleteSubtask;

  /// No description provided for @collapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get collapse;

  /// No description provided for @expand.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get expand;

  /// No description provided for @copySuffix.
  ///
  /// In en, this message translates to:
  /// **'(Copy)'**
  String get copySuffix;

  /// No description provided for @highPriority.
  ///
  /// In en, this message translates to:
  /// **'High Priority'**
  String get highPriority;

  /// No description provided for @mediumPriority.
  ///
  /// In en, this message translates to:
  /// **'Medium Priority'**
  String get mediumPriority;

  /// No description provided for @lowPriority.
  ///
  /// In en, this message translates to:
  /// **'Low Priority'**
  String get lowPriority;

  /// No description provided for @addSubtask.
  ///
  /// In en, this message translates to:
  /// **'Add Subtask'**
  String get addSubtask;

  /// No description provided for @recurringTasksManager.
  ///
  /// In en, this message translates to:
  /// **'Recurring Tasks Manager'**
  String get recurringTasksManager;

  /// No description provided for @generateRecurringInstances.
  ///
  /// In en, this message translates to:
  /// **'Generate Recurring Instances'**
  String get generateRecurringInstances;

  /// No description provided for @recurringInstancesGenerated.
  ///
  /// In en, this message translates to:
  /// **'Recurring instances generated'**
  String get recurringInstancesGenerated;

  /// No description provided for @errorGeneratingInstances.
  ///
  /// In en, this message translates to:
  /// **'Error generating instances'**
  String get errorGeneratingInstances;

  /// No description provided for @duplicateTask.
  ///
  /// In en, this message translates to:
  /// **'Duplicate Task'**
  String get duplicateTask;

  /// No description provided for @allRecurringUpToDate.
  ///
  /// In en, this message translates to:
  /// **'All recurring up to date'**
  String get allRecurringUpToDate;

  /// No description provided for @generateNextInstance.
  ///
  /// In en, this message translates to:
  /// **'Generate Next Instance'**
  String get generateNextInstance;

  /// No description provided for @generateAllInstances.
  ///
  /// In en, this message translates to:
  /// **'Generate All Instances'**
  String get generateAllInstances;

  /// No description provided for @activeRecurringTasks.
  ///
  /// In en, this message translates to:
  /// **'Active Recurring Tasks'**
  String get activeRecurringTasks;

  /// No description provided for @totalRecurringInstances.
  ///
  /// In en, this message translates to:
  /// **'Total Recurring Instances'**
  String get totalRecurringInstances;

  /// No description provided for @tasksNeedingInstances.
  ///
  /// In en, this message translates to:
  /// **'Tasks Needing Instances'**
  String get tasksNeedingInstances;

  /// No description provided for @refreshRecurringTasks.
  ///
  /// In en, this message translates to:
  /// **'Refresh Recurring Tasks'**
  String get refreshRecurringTasks;

  /// No description provided for @subtaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Subtask Title'**
  String get subtaskTitle;

  /// No description provided for @subtaskDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get subtaskDescription;

  /// No description provided for @pleaseEnterSubtaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a subtask title'**
  String get pleaseEnterSubtaskTitle;

  /// No description provided for @customizePomodoroSession.
  ///
  /// In en, this message translates to:
  /// **'Customize Pomodoro Session'**
  String get customizePomodoroSession;

  /// No description provided for @workDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Work Duration'**
  String get workDurationLabel;

  /// No description provided for @shortBreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Short Break'**
  String get shortBreakLabel;

  /// No description provided for @longBreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Long Break'**
  String get longBreakLabel;

  /// No description provided for @startSession.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get startSession;

  /// No description provided for @pomodoroFocus.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Focus'**
  String get pomodoroFocus;

  /// No description provided for @pomodoroDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose a task to focus on and customize your session'**
  String get pomodoroDescription;

  /// No description provided for @sessionProgress.
  ///
  /// In en, this message translates to:
  /// **'Session Progress'**
  String get sessionProgress;

  /// No description provided for @settingsButton.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsButton;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @overdueTasks.
  ///
  /// In en, this message translates to:
  /// **'Overdue Tasks'**
  String get overdueTasks;

  /// No description provided for @todayTasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s tasks'**
  String get todayTasks;

  /// No description provided for @tomorrowTasks.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow\'s tasks'**
  String get tomorrowTasks;

  /// No description provided for @thisWeekTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks for this week'**
  String get thisWeekTasks;

  /// No description provided for @laterTasks.
  ///
  /// In en, this message translates to:
  /// **'Later tasks'**
  String get laterTasks;

  /// No description provided for @noDateTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks without a specific date'**
  String get noDateTasks;

  /// No description provided for @receiveNotificationsForTasksAndReminders.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications for tasks and reminders'**
  String get receiveNotificationsForTasksAndReminders;

  /// No description provided for @playSoundForNotifications.
  ///
  /// In en, this message translates to:
  /// **'Play sound for notifications'**
  String get playSoundForNotifications;

  /// No description provided for @vibrateForNotifications.
  ///
  /// In en, this message translates to:
  /// **'Vibrate for notifications'**
  String get vibrateForNotifications;

  /// No description provided for @noUpcomingTasksWithReminders.
  ///
  /// In en, this message translates to:
  /// **'No upcoming tasks with reminders'**
  String get noUpcomingTasksWithReminders;

  /// No description provided for @noOverdueTasks.
  ///
  /// In en, this message translates to:
  /// **'No overdue tasks'**
  String get noOverdueTasks;

  /// No description provided for @testNotification.
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get testNotification;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @reminderCancelledFor.
  ///
  /// In en, this message translates to:
  /// **'Reminder cancelled for: {taskTitle}'**
  String reminderCancelledFor(String taskTitle);

  /// No description provided for @testNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent'**
  String get testNotificationSent;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder: {date}'**
  String reminder(String date);

  /// No description provided for @noReminderSet.
  ///
  /// In en, this message translates to:
  /// **'No reminder set'**
  String get noReminderSet;

  /// No description provided for @allNotificationsCleared.
  ///
  /// In en, this message translates to:
  /// **'All notifications cleared!'**
  String get allNotificationsCleared;

  /// No description provided for @checkPendingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Check Pending'**
  String get checkPendingNotifications;

  /// No description provided for @cancelAllNotifications.
  ///
  /// In en, this message translates to:
  /// **'Cancel All'**
  String get cancelAllNotifications;

  /// No description provided for @allNotificationsCancelled.
  ///
  /// In en, this message translates to:
  /// **'All notifications cancelled'**
  String get allNotificationsCancelled;

  /// No description provided for @moodCheckInNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Mood Check-In'**
  String get moodCheckInNotificationTitle;

  /// No description provided for @moodCheckInNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling right now? Tap to record your mood.'**
  String get moodCheckInNotificationBody;

  /// No description provided for @testMoodNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Test Mood Notification'**
  String get testMoodNotificationTitle;

  /// No description provided for @testMoodNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'This is a test mood check-in notification.'**
  String get testMoodNotificationBody;

  /// No description provided for @testReminderIn10Seconds.
  ///
  /// In en, this message translates to:
  /// **'Test Reminder in 10s'**
  String get testReminderIn10Seconds;

  /// No description provided for @testReminderScheduled.
  ///
  /// In en, this message translates to:
  /// **'Test reminder scheduled for 10 seconds from now'**
  String get testReminderScheduled;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @appUpdates.
  ///
  /// In en, this message translates to:
  /// **'App Updates'**
  String get appUpdates;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get checkForUpdates;

  /// No description provided for @currentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current Version'**
  String get currentVersion;

  /// No description provided for @latestVersion.
  ///
  /// In en, this message translates to:
  /// **'Latest Version'**
  String get latestVersion;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get updateAvailable;

  /// No description provided for @updateDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Update Downloaded'**
  String get updateDownloaded;

  /// No description provided for @installUpdate.
  ///
  /// In en, this message translates to:
  /// **'Install Update'**
  String get installUpdate;

  /// No description provided for @downloadingUpdate.
  ///
  /// In en, this message translates to:
  /// **'Downloading Update...'**
  String get downloadingUpdate;

  /// No description provided for @installingUpdate.
  ///
  /// In en, this message translates to:
  /// **'Installing Update...'**
  String get installingUpdate;

  /// No description provided for @noUpdatesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Updates Available'**
  String get noUpdatesAvailable;

  /// No description provided for @updateError.
  ///
  /// In en, this message translates to:
  /// **'Update Error'**
  String get updateError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version: {version}'**
  String version(String version);

  /// No description provided for @updatePersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get updatePersonalInfo;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturday;

  /// No description provided for @focusMode.
  ///
  /// In en, this message translates to:
  /// **'Focus Mode'**
  String get focusMode;

  /// No description provided for @motivationalQuoteHigh.
  ///
  /// In en, this message translates to:
  /// **'You\'ve got this! 🚀'**
  String get motivationalQuoteHigh;

  /// No description provided for @motivationalQuoteMedium.
  ///
  /// In en, this message translates to:
  /// **'Keep going! 💪'**
  String get motivationalQuoteMedium;

  /// No description provided for @motivationalQuoteLow.
  ///
  /// In en, this message translates to:
  /// **'Take it easy! 😊'**
  String get motivationalQuoteLow;

  /// No description provided for @taskDetails.
  ///
  /// In en, this message translates to:
  /// **'Task Details'**
  String get taskDetails;

  /// No description provided for @noDueDate.
  ///
  /// In en, this message translates to:
  /// **'No Due Date'**
  String get noDueDate;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority: {priority}'**
  String priority(Object priority);

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @noSubtasks.
  ///
  /// In en, this message translates to:
  /// **'No subtasks'**
  String get noSubtasks;

  /// No description provided for @subtasks.
  ///
  /// In en, this message translates to:
  /// **'Subtasks'**
  String get subtasks;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @timeSpent.
  ///
  /// In en, this message translates to:
  /// **'Time Spent'**
  String get timeSpent;

  /// No description provided for @avgSession.
  ///
  /// In en, this message translates to:
  /// **'Avg Session'**
  String get avgSession;

  /// No description provided for @pomodoroSessions.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Sessions'**
  String get pomodoroSessions;

  /// No description provided for @startPomodoroSession.
  ///
  /// In en, this message translates to:
  /// **'Start Pomodoro Session'**
  String get startPomodoroSession;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @lastModified.
  ///
  /// In en, this message translates to:
  /// **'Last Modified'**
  String get lastModified;

  /// No description provided for @taskProgress.
  ///
  /// In en, this message translates to:
  /// **'Task Progress'**
  String get taskProgress;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status:'**
  String get statusLabel;

  /// No description provided for @setReminderButton.
  ///
  /// In en, this message translates to:
  /// **'Set Reminder'**
  String get setReminderButton;

  /// No description provided for @uncompleteTaskButton.
  ///
  /// In en, this message translates to:
  /// **'Uncomplete Task'**
  String get uncompleteTaskButton;

  /// No description provided for @completeTaskButton.
  ///
  /// In en, this message translates to:
  /// **'Complete Task'**
  String get completeTaskButton;

  /// No description provided for @completeSubtasksFirst.
  ///
  /// In en, this message translates to:
  /// **'Complete Subtasks First'**
  String get completeSubtasksFirst;

  /// No description provided for @testNotifications.
  ///
  /// In en, this message translates to:
  /// **'Test Notifications'**
  String get testNotifications;

  /// No description provided for @tryAllNotificationFeatures.
  ///
  /// In en, this message translates to:
  /// **'Try all notification features'**
  String get tryAllNotificationFeatures;

  /// No description provided for @customizeNotificationBehavior.
  ///
  /// In en, this message translates to:
  /// **'Customize notification behavior'**
  String get customizeNotificationBehavior;

  /// No description provided for @viewPastNotifications.
  ///
  /// In en, this message translates to:
  /// **'View past notifications'**
  String get viewPastNotifications;

  /// No description provided for @notificationTesting.
  ///
  /// In en, this message translates to:
  /// **'🧪 Notification Testing'**
  String get notificationTesting;

  /// No description provided for @quickTestGuide.
  ///
  /// In en, this message translates to:
  /// **'🎯 Quick Test Guide'**
  String get quickTestGuide;

  /// No description provided for @totalNotifications.
  ///
  /// In en, this message translates to:
  /// **'Total Notifications: {count}'**
  String totalNotifications(int count);

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled: ✅'**
  String get notificationsEnabled;

  /// No description provided for @notificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled: ❌'**
  String get notificationsDisabled;

  /// No description provided for @basicNotifications.
  ///
  /// In en, this message translates to:
  /// **'1. Basic Notifications'**
  String get basicNotifications;

  /// No description provided for @testSimpleNotification.
  ///
  /// In en, this message translates to:
  /// **'Test: Simple Notification'**
  String get testSimpleNotification;

  /// No description provided for @appearsIn10Seconds.
  ///
  /// In en, this message translates to:
  /// **'Appears in 10 seconds'**
  String get appearsIn10Seconds;

  /// No description provided for @testTaskReminder.
  ///
  /// In en, this message translates to:
  /// **'Test: Task Reminder'**
  String get testTaskReminder;

  /// No description provided for @withActionButtons15Seconds.
  ///
  /// In en, this message translates to:
  /// **'With action buttons - 15 seconds'**
  String get withActionButtons15Seconds;

  /// No description provided for @testMoodCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Test: Mood Check-in'**
  String get testMoodCheckIn;

  /// No description provided for @testIn20Seconds.
  ///
  /// In en, this message translates to:
  /// **'20 seconds'**
  String get testIn20Seconds;

  /// No description provided for @priorityLevels.
  ///
  /// In en, this message translates to:
  /// **'2. Priority Levels'**
  String get priorityLevels;

  /// No description provided for @testHighPriority.
  ///
  /// In en, this message translates to:
  /// **'Test: High Priority'**
  String get testHighPriority;

  /// No description provided for @urgentNotification10Seconds.
  ///
  /// In en, this message translates to:
  /// **'Urgent notification - 10 seconds'**
  String get urgentNotification10Seconds;

  /// No description provided for @testLowPriority.
  ///
  /// In en, this message translates to:
  /// **'Test: Low Priority'**
  String get testLowPriority;

  /// No description provided for @silentNotification10Seconds.
  ///
  /// In en, this message translates to:
  /// **'Silent notification - 10 seconds'**
  String get silentNotification10Seconds;

  /// No description provided for @notificationManagement.
  ///
  /// In en, this message translates to:
  /// **'3. Notification Management'**
  String get notificationManagement;

  /// No description provided for @viewNotificationHistory.
  ///
  /// In en, this message translates to:
  /// **'View Notification History'**
  String get viewNotificationHistory;

  /// No description provided for @seeAllPastNotifications.
  ///
  /// In en, this message translates to:
  /// **'See all past notifications'**
  String get seeAllPastNotifications;

  /// No description provided for @configureNotificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Configure notification settings'**
  String get configureNotificationSettings;

  /// No description provided for @testingTips.
  ///
  /// In en, this message translates to:
  /// **'Testing Tips'**
  String get testingTips;

  /// No description provided for @grantNotificationPermissions.
  ///
  /// In en, this message translates to:
  /// **'1. Grant notification permissions when prompted'**
  String get grantNotificationPermissions;

  /// No description provided for @keepAppInBackground.
  ///
  /// In en, this message translates to:
  /// **'2. Keep app in background after scheduling'**
  String get keepAppInBackground;

  /// No description provided for @checkHistoryAfterDelivery.
  ///
  /// In en, this message translates to:
  /// **'3. Check notification history after delivery'**
  String get checkHistoryAfterDelivery;

  /// No description provided for @tryActionButtons.
  ///
  /// In en, this message translates to:
  /// **'4. Try action buttons on task notifications'**
  String get tryActionButtons;

  /// No description provided for @testDNDMode.
  ///
  /// In en, this message translates to:
  /// **'5. Test DND mode in preferences'**
  String get testDNDMode;

  /// No description provided for @notificationScheduledFor10Seconds.
  ///
  /// In en, this message translates to:
  /// **'⏰ Notification scheduled for 10 seconds'**
  String get notificationScheduledFor10Seconds;

  /// No description provided for @taskNotificationIn15Seconds.
  ///
  /// In en, this message translates to:
  /// **'⏰ Task notification in 15 seconds (has action buttons!)'**
  String get taskNotificationIn15Seconds;

  /// No description provided for @moodNotificationIn20Seconds.
  ///
  /// In en, this message translates to:
  /// **'⏰ Mood notification in 20 seconds'**
  String get moodNotificationIn20Seconds;

  /// No description provided for @highPriorityNotificationIn10Seconds.
  ///
  /// In en, this message translates to:
  /// **'⏰ High priority notification in 10 seconds'**
  String get highPriorityNotificationIn10Seconds;

  /// No description provided for @lowPriorityNotificationIn10Seconds.
  ///
  /// In en, this message translates to:
  /// **'⏰ Low priority (silent) notification in 10 seconds'**
  String get lowPriorityNotificationIn10Seconds;

  /// No description provided for @testNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'✅ Test Notification'**
  String get testNotificationTitle;

  /// No description provided for @testNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'The new notification system works!'**
  String get testNotificationBody;

  /// No description provided for @taskCompleteReport.
  ///
  /// In en, this message translates to:
  /// **'📋 Task: Complete Report'**
  String get taskCompleteReport;

  /// No description provided for @dueInOneHour.
  ///
  /// In en, this message translates to:
  /// **'Due in 1 hour - tap to view'**
  String get dueInOneHour;

  /// No description provided for @highPriorityAlert.
  ///
  /// In en, this message translates to:
  /// **'🚨 High Priority Alert'**
  String get highPriorityAlert;

  /// No description provided for @urgentNotificationMessage.
  ///
  /// In en, this message translates to:
  /// **'This is an urgent notification!'**
  String get urgentNotificationMessage;

  /// No description provided for @lowPriorityInfo.
  ///
  /// In en, this message translates to:
  /// **'ℹ️ Low Priority Info'**
  String get lowPriorityInfo;

  /// No description provided for @quietNotificationMessage.
  ///
  /// In en, this message translates to:
  /// **'This is a quiet notification'**
  String get quietNotificationMessage;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @searchNotifications.
  ///
  /// In en, this message translates to:
  /// **'Search notifications...'**
  String get searchNotifications;

  /// No description provided for @filterByType.
  ///
  /// In en, this message translates to:
  /// **'Filter by Type'**
  String get filterByType;

  /// No description provided for @filterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by Status'**
  String get filterByStatus;

  /// No description provided for @notificationAnalyticsLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Analytics (Last 7 Days)'**
  String get notificationAnalyticsLast7Days;

  /// No description provided for @notificationAnalyticsSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get notificationAnalyticsSent;

  /// No description provided for @notificationAnalyticsDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get notificationAnalyticsDelivered;

  /// No description provided for @notificationAnalyticsOpened.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get notificationAnalyticsOpened;

  /// No description provided for @notificationAnalyticsAction.
  ///
  /// In en, this message translates to:
  /// **'Action Rate'**
  String get notificationAnalyticsAction;

  /// No description provided for @notificationStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get notificationStatusDelivered;

  /// No description provided for @notificationStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get notificationStatusPending;

  /// No description provided for @notificationStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get notificationStatusFailed;

  /// No description provided for @notificationStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get notificationStatusCancelled;

  /// No description provided for @notificationStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get notificationStatusExpired;

  /// No description provided for @doNotDisturb.
  ///
  /// In en, this message translates to:
  /// **'Do Not Disturb'**
  String get doNotDisturb;

  /// No description provided for @scheduledQuietHours.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Quiet Hours'**
  String get scheduledQuietHours;

  /// No description provided for @allowUrgentNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow Urgent Notifications During DND'**
  String get allowUrgentNotifications;

  /// No description provided for @smartScheduling.
  ///
  /// In en, this message translates to:
  /// **'Smart Scheduling'**
  String get smartScheduling;

  /// No description provided for @enableSmartScheduling.
  ///
  /// In en, this message translates to:
  /// **'Enable Smart Scheduling'**
  String get enableSmartScheduling;

  /// No description provided for @maxNotificationsPerHour.
  ///
  /// In en, this message translates to:
  /// **'Max Notifications Per Hour'**
  String get maxNotificationsPerHour;

  /// No description provided for @minimumMinutesBetweenSameType.
  ///
  /// In en, this message translates to:
  /// **'Minimum Minutes Between Same Type'**
  String get minimumMinutesBetweenSameType;

  /// No description provided for @groupSimilarNotifications.
  ///
  /// In en, this message translates to:
  /// **'Group Similar Notifications'**
  String get groupSimilarNotifications;

  /// No description provided for @respectSystemDND.
  ///
  /// In en, this message translates to:
  /// **'Respect System Do Not Disturb'**
  String get respectSystemDND;

  /// No description provided for @notificationTypes.
  ///
  /// In en, this message translates to:
  /// **'Notification Types'**
  String get notificationTypes;

  /// No description provided for @taskReminders.
  ///
  /// In en, this message translates to:
  /// **'Task Reminders'**
  String get taskReminders;

  /// No description provided for @moodCheckIns.
  ///
  /// In en, this message translates to:
  /// **'Mood Check-ins'**
  String get moodCheckIns;

  /// No description provided for @pomodoroNotifications.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Notifications'**
  String get pomodoroNotifications;

  /// No description provided for @emergencyNotifications.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergencyNotifications;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @adaptiveTiming.
  ///
  /// In en, this message translates to:
  /// **'Adaptive Timing'**
  String get adaptiveTiming;

  /// No description provided for @openSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Open System Settings'**
  String get openSystemSettings;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// No description provided for @emergencyAlertsWillBypassQuietHours.
  ///
  /// In en, this message translates to:
  /// **'Emergency alerts will bypass quiet hours'**
  String get emergencyAlertsWillBypassQuietHours;

  /// No description provided for @intelligentNotificationManagement.
  ///
  /// In en, this message translates to:
  /// **'Intelligent Notification Management'**
  String get intelligentNotificationManagement;

  /// No description provided for @automaticallyOptimizeNotificationTiming.
  ///
  /// In en, this message translates to:
  /// **'Automatically optimize notification timing to avoid interrupting you'**
  String get automaticallyOptimizeNotificationTiming;

  /// No description provided for @combineNotificationsOfTheSameType.
  ///
  /// In en, this message translates to:
  /// **'Combine notifications of the same type into groups'**
  String get combineNotificationsOfTheSameType;

  /// No description provided for @honorDeviceDoNotDisturbSettings.
  ///
  /// In en, this message translates to:
  /// **'Honor device Do Not Disturb settings'**
  String get honorDeviceDoNotDisturbSettings;

  /// No description provided for @customizeEachNotificationType.
  ///
  /// In en, this message translates to:
  /// **'Customize each notification type'**
  String get customizeEachNotificationType;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @showBadge.
  ///
  /// In en, this message translates to:
  /// **'Show Badge'**
  String get showBadge;

  /// No description provided for @enableActions.
  ///
  /// In en, this message translates to:
  /// **'Enable Actions'**
  String get enableActions;

  /// No description provided for @showActionButtons.
  ///
  /// In en, this message translates to:
  /// **'Show action buttons'**
  String get showActionButtons;

  /// No description provided for @advancedSettings.
  ///
  /// In en, this message translates to:
  /// **'Advanced Settings'**
  String get advancedSettings;

  /// No description provided for @expertOptions.
  ///
  /// In en, this message translates to:
  /// **'Expert options for power users'**
  String get expertOptions;

  /// No description provided for @badgeOnlyMode.
  ///
  /// In en, this message translates to:
  /// **'Badge Only Mode'**
  String get badgeOnlyMode;

  /// No description provided for @badgeOnlyModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show badge without sound or popup'**
  String get badgeOnlyModeSubtitle;

  /// No description provided for @deliveryTracking.
  ///
  /// In en, this message translates to:
  /// **'Delivery Tracking'**
  String get deliveryTracking;

  /// No description provided for @trackWhenNotificationsAreDelivered.
  ///
  /// In en, this message translates to:
  /// **'Track when notifications are delivered and opened'**
  String get trackWhenNotificationsAreDelivered;

  /// No description provided for @trackNotificationInteractionStatistics.
  ///
  /// In en, this message translates to:
  /// **'Track notification interaction statistics'**
  String get trackNotificationInteractionStatistics;

  /// No description provided for @learnFromYourBehaviorToOptimizeNotificationTiming.
  ///
  /// In en, this message translates to:
  /// **'Learn from your behavior to optimize notification timing'**
  String get learnFromYourBehaviorToOptimizeNotificationTiming;

  /// No description provided for @moodCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Mood Check-in'**
  String get moodCheckIn;

  /// No description provided for @masterToggleForAllNotifications.
  ///
  /// In en, this message translates to:
  /// **'Master toggle for all notifications'**
  String get masterToggleForAllNotifications;

  /// No description provided for @activeNotificationsMuted.
  ///
  /// In en, this message translates to:
  /// **'Active - Notifications muted'**
  String get activeNotificationsMuted;

  /// No description provided for @configureQuietHours.
  ///
  /// In en, this message translates to:
  /// **'Configure quiet hours'**
  String get configureQuietHours;

  /// No description provided for @setAutomaticQuietHours.
  ///
  /// In en, this message translates to:
  /// **'Set automatic quiet hours'**
  String get setAutomaticQuietHours;

  /// No description provided for @sendTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Send Test Notification'**
  String get sendTestNotification;

  /// No description provided for @taskDue.
  ///
  /// In en, this message translates to:
  /// **'Task Due'**
  String get taskDue;

  /// No description provided for @pomodoroWork.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Work'**
  String get pomodoroWork;

  /// No description provided for @pomodoroBreak.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Break'**
  String get pomodoroBreak;

  /// No description provided for @pomodoroComplete.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Complete'**
  String get pomodoroComplete;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// No description provided for @notificationPreferencesInfo.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences Info'**
  String get notificationPreferencesInfo;

  /// No description provided for @notificationPreferencesInfoDetails.
  ///
  /// In en, this message translates to:
  /// **'Configure how and when you receive notifications. Customize each notification type, set quiet hours, and control notification behavior.'**
  String get notificationPreferencesInfoDetails;

  /// No description provided for @smartSchedulingInfo.
  ///
  /// In en, this message translates to:
  /// **'Smart scheduling learns from your usage patterns to deliver notifications at optimal times.'**
  String get smartSchedulingInfo;

  /// No description provided for @dndInfo.
  ///
  /// In en, this message translates to:
  /// **'Do Not Disturb mode silences all notifications except emergencies during specified hours.'**
  String get dndInfo;

  /// No description provided for @manualDND.
  ///
  /// In en, this message translates to:
  /// **'Manual DND'**
  String get manualDND;

  /// No description provided for @resetSettings.
  ///
  /// In en, this message translates to:
  /// **'Reset Settings'**
  String get resetSettings;

  /// No description provided for @resetSettingsConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all settings to default?'**
  String get resetSettingsConfirmation;

  /// No description provided for @searchSettings.
  ///
  /// In en, this message translates to:
  /// **'Search Settings'**
  String get searchSettings;

  /// No description provided for @typeToFilterSettingsSections.
  ///
  /// In en, this message translates to:
  /// **'Type to filter settings sections'**
  String get typeToFilterSettingsSections;

  /// No description provided for @searchSettingsHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchSettingsHint;

  /// No description provided for @increaseContrastForBetterVisibility.
  ///
  /// In en, this message translates to:
  /// **'Increase contrast for better visibility'**
  String get increaseContrastForBetterVisibility;

  /// No description provided for @taskCompletionSounds.
  ///
  /// In en, this message translates to:
  /// **'Task Completion Sounds'**
  String get taskCompletionSounds;

  /// No description provided for @enableTaskCompletionSound.
  ///
  /// In en, this message translates to:
  /// **'Enable Task Completion Sound'**
  String get enableTaskCompletionSound;

  /// No description provided for @playSoundWhenTasksAreCompleted.
  ///
  /// In en, this message translates to:
  /// **'Play sound when tasks are completed'**
  String get playSoundWhenTasksAreCompleted;

  /// No description provided for @soundSelection.
  ///
  /// In en, this message translates to:
  /// **'Sound Selection'**
  String get soundSelection;

  /// No description provided for @testSound.
  ///
  /// In en, this message translates to:
  /// **'Test Sound'**
  String get testSound;

  /// No description provided for @customDurationsMinutes.
  ///
  /// In en, this message translates to:
  /// **'Custom Durations (minutes)'**
  String get customDurationsMinutes;

  /// No description provided for @workDuration.
  ///
  /// In en, this message translates to:
  /// **'Work Duration'**
  String get workDuration;

  /// No description provided for @shortBreakDuration.
  ///
  /// In en, this message translates to:
  /// **'Short Break Duration'**
  String get shortBreakDuration;

  /// No description provided for @longBreakDuration.
  ///
  /// In en, this message translates to:
  /// **'Long Break Duration'**
  String get longBreakDuration;

  /// No description provided for @helpImproveTheAppWithUsageData.
  ///
  /// In en, this message translates to:
  /// **'Help improve the app with usage data'**
  String get helpImproveTheAppWithUsageData;

  /// No description provided for @sendCrashReportsToHelpFixIssues.
  ///
  /// In en, this message translates to:
  /// **'Send crash reports to help fix issues'**
  String get sendCrashReportsToHelpFixIssues;

  /// No description provided for @failedToCheckForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Failed to check for updates'**
  String get failedToCheckForUpdates;

  /// No description provided for @mood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get mood;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @taskSounds.
  ///
  /// In en, this message translates to:
  /// **'Task Sounds'**
  String get taskSounds;

  /// No description provided for @pomodoro.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro'**
  String get pomodoro;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @regional.
  ///
  /// In en, this message translates to:
  /// **'Regional'**
  String get regional;

  /// No description provided for @updates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get updates;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @clearDateFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear date filter'**
  String get clearDateFilter;

  /// No description provided for @tasksForDate.
  ///
  /// In en, this message translates to:
  /// **'Tasks for {date}'**
  String tasksForDate(String date);

  /// No description provided for @tasksDue.
  ///
  /// In en, this message translates to:
  /// **'{count} tasks due'**
  String tasksDue(int count);

  /// No description provided for @undatedTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks without dates'**
  String get undatedTasks;

  /// No description provided for @monthView.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get monthView;

  /// No description provided for @weekView.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get weekView;

  /// No description provided for @calendarView.
  ///
  /// In en, this message translates to:
  /// **'Calendar View'**
  String get calendarView;

  /// No description provided for @rescheduleTask.
  ///
  /// In en, this message translates to:
  /// **'Reschedule Task'**
  String get rescheduleTask;

  /// No description provided for @taskRescheduled.
  ///
  /// In en, this message translates to:
  /// **'Task rescheduled'**
  String get taskRescheduled;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @viewDayTasks.
  ///
  /// In en, this message translates to:
  /// **'View day tasks'**
  String get viewDayTasks;

  /// No description provided for @noTasksForThisDay.
  ///
  /// In en, this message translates to:
  /// **'No tasks for this day'**
  String get noTasksForThisDay;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh when connected'**
  String get pullToRefresh;

  /// No description provided for @showCalendar.
  ///
  /// In en, this message translates to:
  /// **'Show calendar'**
  String get showCalendar;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @recommendedForAdhd.
  ///
  /// In en, this message translates to:
  /// **'Recommended for ADHD'**
  String get recommendedForAdhd;

  /// No description provided for @mostPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get mostPopular;

  /// No description provided for @stopPomodoroConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to stop the current session? Your progress will be lost.'**
  String get stopPomodoroConfirmation;

  /// No description provided for @selectATemplateOrCustomizeYourSession.
  ///
  /// In en, this message translates to:
  /// **'Select a template or customize your session'**
  String get selectATemplateOrCustomizeYourSession;

  /// No description provided for @stopPomodoroTimer.
  ///
  /// In en, this message translates to:
  /// **'Stop Timer'**
  String get stopPomodoroTimer;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @sessionsUntilLongBreak.
  ///
  /// In en, this message translates to:
  /// **'Sessions until Long Break'**
  String get sessionsUntilLongBreak;

  /// No description provided for @customizeYourPomodoroSession.
  ///
  /// In en, this message translates to:
  /// **'Customize your pomodoro session'**
  String get customizeYourPomodoroSession;

  /// No description provided for @whatsHappeningRightNow.
  ///
  /// In en, this message translates to:
  /// **'What\'s happening right now?'**
  String get whatsHappeningRightNow;

  /// No description provided for @wantToShareMore.
  ///
  /// In en, this message translates to:
  /// **'Want to share more?'**
  String get wantToShareMore;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @failedToAccessGallery.
  ///
  /// In en, this message translates to:
  /// **'Failed to access gallery'**
  String get failedToAccessGallery;

  /// No description provided for @nameRequiredForProfile.
  ///
  /// In en, this message translates to:
  /// **'Name is required for profile'**
  String get nameRequiredForProfile;

  /// No description provided for @birthdayRequiredForProfile.
  ///
  /// In en, this message translates to:
  /// **'Birthday is required for profile'**
  String get birthdayRequiredForProfile;

  /// No description provided for @failedToUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image'**
  String get failedToUploadImage;

  /// No description provided for @userNotAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'User not authenticated'**
  String get userNotAuthenticated;

  /// No description provided for @notificationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Notification permission required'**
  String get notificationPermissionRequired;

  /// No description provided for @notificationPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enable notifications to set reminders'**
  String get notificationPermissionMessage;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermission;

  /// No description provided for @cannotSetReminderWithoutPermission.
  ///
  /// In en, this message translates to:
  /// **'Cannot set reminder without notification permission'**
  String get cannotSetReminderWithoutPermission;

  /// No description provided for @customColors.
  ///
  /// In en, this message translates to:
  /// **'Custom Colors'**
  String get customColors;

  /// No description provided for @personalizeAppTheme.
  ///
  /// In en, this message translates to:
  /// **'Personalize App Theme'**
  String get personalizeAppTheme;

  /// No description provided for @primaryColor.
  ///
  /// In en, this message translates to:
  /// **'Primary Color'**
  String get primaryColor;

  /// No description provided for @choosePrimaryColor.
  ///
  /// In en, this message translates to:
  /// **'Choose Primary Color'**
  String get choosePrimaryColor;

  /// No description provided for @subtasksCount.
  ///
  /// In en, this message translates to:
  /// **'{count} subtasks'**
  String subtasksCount(int count);

  /// No description provided for @deliveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get deliveryLabel;

  /// No description provided for @openLabel.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openLabel;

  /// No description provided for @actionLabel.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get actionLabel;

  /// No description provided for @averageResponseTime.
  ///
  /// In en, this message translates to:
  /// **'Average Response Time'**
  String get averageResponseTime;

  /// No description provided for @helpUsUnderstandState.
  ///
  /// In en, this message translates to:
  /// **'Help us understand your current state'**
  String get helpUsUnderstandState;

  /// No description provided for @optionalAddContext.
  ///
  /// In en, this message translates to:
  /// **'Optional: Add context'**
  String get optionalAddContext;

  /// No description provided for @optionalWriteNote.
  ///
  /// In en, this message translates to:
  /// **'Optional: Write a note'**
  String get optionalWriteNote;

  /// No description provided for @imGratefulFor.
  ///
  /// In en, this message translates to:
  /// **'I\'m grateful for'**
  String get imGratefulFor;

  /// No description provided for @todayI.
  ///
  /// In en, this message translates to:
  /// **'Today I'**
  String get todayI;

  /// No description provided for @imFeeling.
  ///
  /// In en, this message translates to:
  /// **'I\'m feeling'**
  String get imFeeling;

  /// No description provided for @whatsWeighingOnYou.
  ///
  /// In en, this message translates to:
  /// **'What\'s weighing on you?'**
  String get whatsWeighingOnYou;

  /// No description provided for @whatsMakingTodayTough.
  ///
  /// In en, this message translates to:
  /// **'What\'s making today tough?'**
  String get whatsMakingTodayTough;

  /// No description provided for @whatsGoingWell.
  ///
  /// In en, this message translates to:
  /// **'What\'s going well?'**
  String get whatsGoingWell;

  /// No description provided for @whatMadeTodayGreat.
  ///
  /// In en, this message translates to:
  /// **'What made today great?'**
  String get whatMadeTodayGreat;

  /// No description provided for @howsYourDayGoing.
  ///
  /// In en, this message translates to:
  /// **'How\'s your day going?'**
  String get howsYourDayGoing;

  /// No description provided for @chooseEmojiFeeling.
  ///
  /// In en, this message translates to:
  /// **'Choose an emoji that represents how you\'re feeling'**
  String get chooseEmojiFeeling;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'day streak'**
  String get dayStreak;

  /// No description provided for @moodSaved.
  ///
  /// In en, this message translates to:
  /// **'Mood saved'**
  String get moodSaved;

  /// No description provided for @testButton.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get testButton;

  /// No description provided for @clearAllNotifications.
  ///
  /// In en, this message translates to:
  /// **'Clear All Notifications'**
  String get clearAllNotifications;

  /// No description provided for @clearAllNotificationsConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all notifications?'**
  String get clearAllNotificationsConfirmation;

  /// No description provided for @generateRecurringConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to generate recurring instances?'**
  String get generateRecurringConfirmation;

  /// No description provided for @includeSpecificTime.
  ///
  /// In en, this message translates to:
  /// **'Include specific time'**
  String get includeSpecificTime;

  /// No description provided for @repeatSameTimeEachDay.
  ///
  /// In en, this message translates to:
  /// **'Repeat at same time each day'**
  String get repeatSameTimeEachDay;

  /// No description provided for @syncStatus.
  ///
  /// In en, this message translates to:
  /// **'Sync Status'**
  String get syncStatus;

  /// No description provided for @pendingOperations.
  ///
  /// In en, this message translates to:
  /// **'Pending operations'**
  String get pendingOperations;

  /// No description provided for @someSyncOperationsFailed.
  ///
  /// In en, this message translates to:
  /// **'Some sync operations failed'**
  String get someSyncOperationsFailed;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @clearFailedButton.
  ///
  /// In en, this message translates to:
  /// **'Clear Failed'**
  String get clearFailedButton;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @syncStatusSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get syncStatusSuccess;

  /// No description provided for @syncStatusSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing'**
  String get syncStatusSyncing;

  /// No description provided for @syncStatusIdle.
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get syncStatusIdle;

  /// No description provided for @syncStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get syncStatusFailed;

  /// No description provided for @moodInsightsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your emotional patterns and gain insights'**
  String get moodInsightsSubtitle;

  /// No description provided for @yourMoodJourney.
  ///
  /// In en, this message translates to:
  /// **'Your Mood Journey'**
  String get yourMoodJourney;

  /// No description provided for @aIPoweredAnalysis.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Analysis'**
  String get aIPoweredAnalysis;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @goodDays.
  ///
  /// In en, this message translates to:
  /// **'Good Days'**
  String get goodDays;

  /// No description provided for @neutralDays.
  ///
  /// In en, this message translates to:
  /// **'Neutral Days'**
  String get neutralDays;

  /// No description provided for @challengingDays.
  ///
  /// In en, this message translates to:
  /// **'Challenging Days'**
  String get challengingDays;

  /// No description provided for @dominantMood.
  ///
  /// In en, this message translates to:
  /// **'Dominant Mood'**
  String get dominantMood;

  /// No description provided for @hiThere.
  ///
  /// In en, this message translates to:
  /// **'Hi there!'**
  String get hiThere;

  /// No description provided for @howIsYourDay.
  ///
  /// In en, this message translates to:
  /// **'How is your day?'**
  String get howIsYourDay;

  /// No description provided for @imHereForYou.
  ///
  /// In en, this message translates to:
  /// **'I\'m here for you!'**
  String get imHereForYou;

  /// No description provided for @itsOkayToHaveToughDays.
  ///
  /// In en, this message translates to:
  /// **'It\'s okay to have tough days'**
  String get itsOkayToHaveToughDays;

  /// No description provided for @sendingYouStrength.
  ///
  /// In en, this message translates to:
  /// **'Sending you strength'**
  String get sendingYouStrength;

  /// No description provided for @everyDayIsANewOpportunity.
  ///
  /// In en, this message translates to:
  /// **'Every day is a new opportunity'**
  String get everyDayIsANewOpportunity;

  /// No description provided for @findingBalance.
  ///
  /// In en, this message translates to:
  /// **'Finding balance'**
  String get findingBalance;

  /// No description provided for @sometimesNeutralIsExactlyWhereWeNeedToBe.
  ///
  /// In en, this message translates to:
  /// **'Sometimes neutral is exactly where we need to be'**
  String get sometimesNeutralIsExactlyWhereWeNeedToBe;

  /// No description provided for @youreDoingGreat.
  ///
  /// In en, this message translates to:
  /// **'You\'re doing great!'**
  String get youreDoingGreat;

  /// No description provided for @keepShiningBright.
  ///
  /// In en, this message translates to:
  /// **'Keep shining bright!'**
  String get keepShiningBright;

  /// No description provided for @absolutelyAmazing.
  ///
  /// In en, this message translates to:
  /// **'Absolutely amazing!'**
  String get absolutelyAmazing;

  /// No description provided for @yourJoyIsContagious.
  ///
  /// In en, this message translates to:
  /// **'Your joy is contagious!'**
  String get yourJoyIsContagious;

  /// No description provided for @moodIntensity.
  ///
  /// In en, this message translates to:
  /// **'Mood Intensity'**
  String get moodIntensity;

  /// No description provided for @smartView.
  ///
  /// In en, this message translates to:
  /// **'Smart'**
  String get smartView;

  /// No description provided for @timelineView.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timelineView;

  /// No description provided for @patternsView.
  ///
  /// In en, this message translates to:
  /// **'Patterns'**
  String get patternsView;

  /// No description provided for @goodIntensity.
  ///
  /// In en, this message translates to:
  /// **'Good Intensity'**
  String get goodIntensity;

  /// No description provided for @veryGoodIntensity.
  ///
  /// In en, this message translates to:
  /// **'Very Good Intensity'**
  String get veryGoodIntensity;

  /// No description provided for @noMoodRecorded.
  ///
  /// In en, this message translates to:
  /// **'No mood recorded'**
  String get noMoodRecorded;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning!'**
  String get goodMorning;

  /// No description provided for @howAreYouFeelingToday.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling today?'**
  String get howAreYouFeelingToday;

  /// No description provided for @todayYoureFeeling.
  ///
  /// In en, this message translates to:
  /// **'Today you\'re feeling'**
  String get todayYoureFeeling;

  /// No description provided for @addAnother.
  ///
  /// In en, this message translates to:
  /// **'Add Another'**
  String get addAnother;

  /// No description provided for @earlierToday.
  ///
  /// In en, this message translates to:
  /// **'Earlier today'**
  String get earlierToday;

  /// No description provided for @struggling.
  ///
  /// In en, this message translates to:
  /// **'Struggling'**
  String get struggling;

  /// No description provided for @down.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get down;

  /// No description provided for @wantToShareMoreDetails.
  ///
  /// In en, this message translates to:
  /// **'Want to share more details?'**
  String get wantToShareMoreDetails;

  /// No description provided for @guidedCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Guided Check-in'**
  String get guidedCheckIn;

  /// No description provided for @detailedEntry.
  ///
  /// In en, this message translates to:
  /// **'Detailed Entry'**
  String get detailedEntry;

  /// No description provided for @quickInsights.
  ///
  /// In en, this message translates to:
  /// **'Quick Insights'**
  String get quickInsights;

  /// No description provided for @recentMoods.
  ///
  /// In en, this message translates to:
  /// **'Recent Moods'**
  String get recentMoods;

  /// No description provided for @noInsightsYet.
  ///
  /// In en, this message translates to:
  /// **'No insights yet'**
  String get noInsightsYet;

  /// No description provided for @trackYourMoodForAWeek.
  ///
  /// In en, this message translates to:
  /// **'Track your mood for a week to see insights'**
  String get trackYourMoodForAWeek;

  /// No description provided for @daysStreak.
  ///
  /// In en, this message translates to:
  /// **'days streak'**
  String get daysStreak;

  /// No description provided for @moodBuddyFeelingSad.
  ///
  /// In en, this message translates to:
  /// **'Feeling sad?'**
  String get moodBuddyFeelingSad;

  /// No description provided for @moodBuddyTipSad.
  ///
  /// In en, this message translates to:
  /// **'Try a gentle walk or listen to calming music'**
  String get moodBuddyTipSad;

  /// No description provided for @moodBuddyFeelingDown.
  ///
  /// In en, this message translates to:
  /// **'Feeling down?'**
  String get moodBuddyFeelingDown;

  /// No description provided for @moodBuddyTipDown.
  ///
  /// In en, this message translates to:
  /// **'Reach out to a friend or practice deep breathing'**
  String get moodBuddyTipDown;

  /// No description provided for @moodBuddyFeelingOkay.
  ///
  /// In en, this message translates to:
  /// **'Feeling okay?'**
  String get moodBuddyFeelingOkay;

  /// No description provided for @moodBuddyTipOkay.
  ///
  /// In en, this message translates to:
  /// **'Maintain balance with light exercise or hobbies'**
  String get moodBuddyTipOkay;

  /// No description provided for @moodBuddyFeelingGood.
  ///
  /// In en, this message translates to:
  /// **'Feeling good?'**
  String get moodBuddyFeelingGood;

  /// No description provided for @moodBuddyTipGood.
  ///
  /// In en, this message translates to:
  /// **'Share your positivity and help others'**
  String get moodBuddyTipGood;

  /// No description provided for @moodBuddyFeelingGreat.
  ///
  /// In en, this message translates to:
  /// **'Feeling great?'**
  String get moodBuddyFeelingGreat;

  /// No description provided for @moodBuddyTipGreat.
  ///
  /// In en, this message translates to:
  /// **'Channel this energy into creative projects'**
  String get moodBuddyTipGreat;

  /// No description provided for @moodPatternsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Mood Patterns'**
  String get moodPatternsTitle;

  /// No description provided for @moodPatternsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover trends in your emotional well-being'**
  String get moodPatternsSubtitle;

  /// No description provided for @moodSuggestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Personalized Suggestions'**
  String get moodSuggestionsTitle;

  /// No description provided for @moodSuggestionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered recommendations based on your mood'**
  String get moodSuggestionsSubtitle;

  /// No description provided for @veryBadIntensity.
  ///
  /// In en, this message translates to:
  /// **'Very Bad Intensity'**
  String get veryBadIntensity;

  /// No description provided for @badIntensity.
  ///
  /// In en, this message translates to:
  /// **'Bad Intensity'**
  String get badIntensity;

  /// No description provided for @neutralIntensity.
  ///
  /// In en, this message translates to:
  /// **'Neutral Intensity'**
  String get neutralIntensity;

  /// No description provided for @insightGenerallyPositive.
  ///
  /// In en, this message translates to:
  /// **'Generally positive 😊'**
  String get insightGenerallyPositive;

  /// No description provided for @insightNeedsSupport.
  ///
  /// In en, this message translates to:
  /// **'Needs support 🤗'**
  String get insightNeedsSupport;

  /// No description provided for @insightGreatConsistency.
  ///
  /// In en, this message translates to:
  /// **'Great consistency! 🔥'**
  String get insightGreatConsistency;

  /// No description provided for @insightMissingToday.
  ///
  /// In en, this message translates to:
  /// **'Missing today 📝'**
  String get insightMissingToday;

  /// No description provided for @pleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get pleaseTryAgainLater;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon: {icon}'**
  String icon(Object icon);

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @searchCategories.
  ///
  /// In en, this message translates to:
  /// **'Search categories...'**
  String get searchCategories;

  /// No description provided for @keyInsights.
  ///
  /// In en, this message translates to:
  /// **'Key Insights'**
  String get keyInsights;

  /// No description provided for @patternAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Pattern Analysis'**
  String get patternAnalysis;

  /// No description provided for @aiPredictions.
  ///
  /// In en, this message translates to:
  /// **'AI Predictions'**
  String get aiPredictions;

  /// No description provided for @positiveTrend.
  ///
  /// In en, this message translates to:
  /// **'Positive Trend'**
  String get positiveTrend;

  /// No description provided for @yourOverallMoodIsGenerallyPositive.
  ///
  /// In en, this message translates to:
  /// **'Your overall mood is generally positive'**
  String get yourOverallMoodIsGenerallyPositive;

  /// No description provided for @supportNeeded.
  ///
  /// In en, this message translates to:
  /// **'Support Needed'**
  String get supportNeeded;

  /// No description provided for @youMightBenefitFromAdditionalSupport.
  ///
  /// In en, this message translates to:
  /// **'You might benefit from additional support'**
  String get youMightBenefitFromAdditionalSupport;

  /// No description provided for @greatConsistency.
  ///
  /// In en, this message translates to:
  /// **'Great Consistency'**
  String get greatConsistency;

  /// No description provided for @youveBeenTrackingYourMoodForDays.
  ///
  /// In en, this message translates to:
  /// **'You\'ve been tracking your mood for {days} days'**
  String youveBeenTrackingYourMoodForDays(Object days);

  /// No description provided for @missingToday.
  ///
  /// In en, this message translates to:
  /// **'Missing Today'**
  String get missingToday;

  /// No description provided for @youHaventLoggedYourMoodTodayYet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t logged your mood today yet'**
  String get youHaventLoggedYourMoodTodayYet;

  /// No description provided for @recentImprovement.
  ///
  /// In en, this message translates to:
  /// **'Recent Improvement'**
  String get recentImprovement;

  /// No description provided for @yourMoodHasBeenImprovingLately.
  ///
  /// In en, this message translates to:
  /// **'Your mood has been improving lately'**
  String get yourMoodHasBeenImprovingLately;

  /// No description provided for @challengingPeriod.
  ///
  /// In en, this message translates to:
  /// **'Challenging Period'**
  String get challengingPeriod;

  /// No description provided for @recentEntriesSuggestAChallengingTime.
  ///
  /// In en, this message translates to:
  /// **'Recent entries suggest a challenging time'**
  String get recentEntriesSuggestAChallengingTime;

  /// No description provided for @moreDataNeeded.
  ///
  /// In en, this message translates to:
  /// **'More Data Needed'**
  String get moreDataNeeded;

  /// No description provided for @trackYourMoodForAWeekToGetAIPredictions.
  ///
  /// In en, this message translates to:
  /// **'Track your mood for a week to get AI predictions'**
  String get trackYourMoodForAWeekToGetAIPredictions;

  /// No description provided for @positiveOutlook.
  ///
  /// In en, this message translates to:
  /// **'Positive Outlook'**
  String get positiveOutlook;

  /// No description provided for @basedOnRecentPatternsTomorrowLooksPromising.
  ///
  /// In en, this message translates to:
  /// **'Based on recent patterns, tomorrow looks promising'**
  String get basedOnRecentPatternsTomorrowLooksPromising;

  /// No description provided for @selfCareRecommended.
  ///
  /// In en, this message translates to:
  /// **'Self-Care Recommended'**
  String get selfCareRecommended;

  /// No description provided for @considerPrioritizingSelfCareActivitiesTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Consider prioritizing self-care activities tomorrow'**
  String get considerPrioritizingSelfCareActivitiesTomorrow;

  /// No description provided for @balancedDayAhead.
  ///
  /// In en, this message translates to:
  /// **'Balanced Day Ahead'**
  String get balancedDayAhead;

  /// No description provided for @tomorrowShouldBeATypicalDayForYou.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow should be a typical day for you'**
  String get tomorrowShouldBeATypicalDayForYou;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong'**
  String get errorTitle;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @errorLoadingTasks.
  ///
  /// In en, this message translates to:
  /// **'Error loading tasks'**
  String get errorLoadingTasks;

  /// No description provided for @deleteTask.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get deleteTask;

  /// No description provided for @deleteTaskConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{taskTitle}\"?'**
  String deleteTaskConfirmation(String task, Object taskTitle);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @filtersAppliedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Filters applied successfully'**
  String get filtersAppliedSuccessfully;

  /// No description provided for @closeSearch.
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get closeSearch;

  /// No description provided for @adminPanel.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanel;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @dashboardOverview.
  ///
  /// In en, this message translates to:
  /// **'Dashboard & Overview'**
  String get dashboardOverview;

  /// No description provided for @statisticsAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Statistics & Analytics'**
  String get statisticsAnalytics;

  /// No description provided for @focusTimeManagement.
  ///
  /// In en, this message translates to:
  /// **'Focus & Time Management'**
  String get focusTimeManagement;

  /// No description provided for @organizeManage.
  ///
  /// In en, this message translates to:
  /// **'Organize & Manage'**
  String get organizeManage;

  /// No description provided for @wellnessEmotions.
  ///
  /// In en, this message translates to:
  /// **'Wellness & Emotions'**
  String get wellnessEmotions;

  /// No description provided for @preferencesConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Preferences & Configuration'**
  String get preferencesConfiguration;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appInformationHelp.
  ///
  /// In en, this message translates to:
  /// **'App Information & Help'**
  String get appInformationHelp;

  /// No description provided for @biweekly.
  ///
  /// In en, this message translates to:
  /// **'Bi-weekly'**
  String get biweekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @repeatForever.
  ///
  /// In en, this message translates to:
  /// **'(forever)'**
  String get repeatForever;

  /// No description provided for @repeatUntil.
  ///
  /// In en, this message translates to:
  /// **'until {date}'**
  String repeatUntil(Object date);

  /// No description provided for @repeatCount.
  ///
  /// In en, this message translates to:
  /// **'({count} times)'**
  String repeatCount(Object count);

  /// No description provided for @onDays.
  ///
  /// In en, this message translates to:
  /// **'on {days}'**
  String onDays(Object days);

  /// No description provided for @recurringTaskGenerationFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate recurring task'**
  String get recurringTaskGenerationFailed;

  /// No description provided for @recurringTaskRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get recurringTaskRetry;

  /// No description provided for @recurringTaskRetryLater.
  ///
  /// In en, this message translates to:
  /// **'Retry Later'**
  String get recurringTaskRetryLater;

  /// No description provided for @bulkGenerationComplete.
  ///
  /// In en, this message translates to:
  /// **'Generated {count} recurring instances'**
  String bulkGenerationComplete(String count);

  /// No description provided for @recurringTaskNotification.
  ///
  /// In en, this message translates to:
  /// **'New recurring task created: {title}'**
  String recurringTaskNotification(String title);

  /// No description provided for @recurringTaskError.
  ///
  /// In en, this message translates to:
  /// **'Error in recurring task: {error}'**
  String recurringTaskError(String error);

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing you in..'**
  String get signingIn;

  /// No description provided for @yourPersonalTaskManager.
  ///
  /// In en, this message translates to:
  /// **'Your Personal Task Manager'**
  String get yourPersonalTaskManager;

  /// No description provided for @bySigningInYouAgree.
  ///
  /// In en, this message translates to:
  /// **'By signing in, you agree to our Terms of Service and Privacy Policy'**
  String get bySigningInYouAgree;

  /// No description provided for @authenticationServiceNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Authentication service not available. Please try again.'**
  String get authenticationServiceNotAvailable;

  /// No description provided for @anErrorOccurredPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get anErrorOccurredPleaseTryAgain;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @passwordResetFunctionality.
  ///
  /// In en, this message translates to:
  /// **'Password reset functionality will be implemented soon. Please contact support for assistance.'**
  String get passwordResetFunctionality;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @smartSortingConsidersTimeOfDayEnergyLevelsAndPatterns.
  ///
  /// In en, this message translates to:
  /// **'Smart sorting considers time of day, energy levels, and patterns'**
  String get smartSortingConsidersTimeOfDayEnergyLevelsAndPatterns;

  /// No description provided for @youCanOverrideWithManualSortingAnytime.
  ///
  /// In en, this message translates to:
  /// **'You can override with manual sorting anytime'**
  String get youCanOverrideWithManualSortingAnytime;

  /// No description provided for @trySortingTasksWithSmartSortOption.
  ///
  /// In en, this message translates to:
  /// **'Try sorting tasks with \"Smart Sort\" option'**
  String get trySortingTasksWithSmartSortOption;

  /// No description provided for @adaptivePomodoro.
  ///
  /// In en, this message translates to:
  /// **'Adaptive Pomodoro'**
  String get adaptivePomodoro;

  /// No description provided for @adaptivePomodoroDescription.
  ///
  /// In en, this message translates to:
  /// **'Focus sessions that adapt to your performance'**
  String get adaptivePomodoroDescription;

  /// No description provided for @sessionTimingAdjustsBasedOnYourFocusPatterns.
  ///
  /// In en, this message translates to:
  /// **'Session timing adjusts based on your focus patterns'**
  String get sessionTimingAdjustsBasedOnYourFocusPatterns;

  /// No description provided for @breakSuggestionsMatchYourCurrentEnergyLevel.
  ///
  /// In en, this message translates to:
  /// **'Break suggestions match your current energy level'**
  String get breakSuggestionsMatchYourCurrentEnergyLevel;

  /// No description provided for @productivityInsightsHelpYouOptimizeWorkSessions.
  ///
  /// In en, this message translates to:
  /// **'Productivity insights help you optimize work sessions'**
  String get productivityInsightsHelpYouOptimizeWorkSessions;

  /// No description provided for @achievementSystemKeepsYouMotivated.
  ///
  /// In en, this message translates to:
  /// **'Achievement system keeps you motivated'**
  String get achievementSystemKeepsYouMotivated;

  /// No description provided for @startAPomodoroSessionToSeeAdaptiveTiming.
  ///
  /// In en, this message translates to:
  /// **'Start a Pomodoro session to see adaptive timing'**
  String get startAPomodoroSessionToSeeAdaptiveTiming;

  /// No description provided for @energyAwarePlanning.
  ///
  /// In en, this message translates to:
  /// **'Energy-Aware Planning'**
  String get energyAwarePlanning;

  /// No description provided for @energyAwarePlanningDescription.
  ///
  /// In en, this message translates to:
  /// **'Schedule tasks based on your energy patterns'**
  String get energyAwarePlanningDescription;

  /// No description provided for @morningPeakBestForComplexTasks.
  ///
  /// In en, this message translates to:
  /// **'Morning peak: Best for complex tasks'**
  String get morningPeakBestForComplexTasks;

  /// No description provided for @afternoonSteadyGoodForRoutineWork.
  ///
  /// In en, this message translates to:
  /// **'Afternoon steady: Good for routine work'**
  String get afternoonSteadyGoodForRoutineWork;

  /// No description provided for @eveningDeclineLightTasksAndPlanning.
  ///
  /// In en, this message translates to:
  /// **'Evening decline: Light tasks and planning'**
  String get eveningDeclineLightTasksAndPlanning;

  /// No description provided for @energyTrackingHelpsIdentifyYourPatterns.
  ///
  /// In en, this message translates to:
  /// **'Energy tracking helps identify your patterns'**
  String get energyTrackingHelpsIdentifyYourPatterns;

  /// No description provided for @checkYourEnergyLevelsThroughoutTheDay.
  ///
  /// In en, this message translates to:
  /// **'Check your energy levels throughout the day'**
  String get checkYourEnergyLevelsThroughoutTheDay;

  /// No description provided for @analyticsDashboard.
  ///
  /// In en, this message translates to:
  /// **'Analytics Dashboard'**
  String get analyticsDashboard;

  /// No description provided for @analyticsDashboardDescription.
  ///
  /// In en, this message translates to:
  /// **'Deep insights into your productivity'**
  String get analyticsDashboardDescription;

  /// No description provided for @trackFocusPatternsAndSessionPerformance.
  ///
  /// In en, this message translates to:
  /// **'Track focus patterns and session performance'**
  String get trackFocusPatternsAndSessionPerformance;

  /// No description provided for @identifyYourMostProductiveTimes.
  ///
  /// In en, this message translates to:
  /// **'Identify your most productive times'**
  String get identifyYourMostProductiveTimes;

  /// No description provided for @monitorMoodAndEnergyCorrelations.
  ///
  /// In en, this message translates to:
  /// **'Monitor mood and energy correlations'**
  String get monitorMoodAndEnergyCorrelations;

  /// No description provided for @getPersonalizedProductivityTips.
  ///
  /// In en, this message translates to:
  /// **'Get personalized productivity tips'**
  String get getPersonalizedProductivityTips;

  /// No description provided for @exploreYourAnalyticsDashboard.
  ///
  /// In en, this message translates to:
  /// **'Explore your analytics dashboard'**
  String get exploreYourAnalyticsDashboard;

  /// No description provided for @tutorialCompletedYoureAllSetToUseSmartFeatures.
  ///
  /// In en, this message translates to:
  /// **'Tutorial completed! You\'re all set to use smart features.'**
  String get tutorialCompletedYoureAllSetToUseSmartFeatures;

  /// No description provided for @errorCompletingTutorial.
  ///
  /// In en, this message translates to:
  /// **'Error completing tutorial'**
  String get errorCompletingTutorial;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get accessDenied;

  /// No description provided for @youDoNotHaveAdminPrivileges.
  ///
  /// In en, this message translates to:
  /// **'You do not have admin privileges.'**
  String get youDoNotHaveAdminPrivileges;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @descriptionOfActivity.
  ///
  /// In en, this message translates to:
  /// **'Description of activity'**
  String get descriptionOfActivity;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @toggleAdminStatus.
  ///
  /// In en, this message translates to:
  /// **'Toggle Admin Status'**
  String get toggleAdminStatus;

  /// No description provided for @areYouSureYouWantToToggleAdminRights.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to {action} {userName}?'**
  String areYouSureYouWantToToggleAdminRights(Object action, Object userName);

  /// No description provided for @removeAdminRightsFrom.
  ///
  /// In en, this message translates to:
  /// **'remove admin rights from'**
  String get removeAdminRightsFrom;

  /// No description provided for @grantAdminRightsTo.
  ///
  /// In en, this message translates to:
  /// **'grant admin rights to'**
  String get grantAdminRightsTo;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @errorUpdatingUser.
  ///
  /// In en, this message translates to:
  /// **'Error updating user: {error}'**
  String errorUpdatingUser(Object error);

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get deleteUser;

  /// No description provided for @areYouSureYouWantToDeleteUser.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {userName}?\n\nThis will permanently delete:\n• User account\n• All tasks\n• All categories\n• All moods\n\nThis action cannot be undone.'**
  String areYouSureYouWantToDeleteUser(Object userName);

  /// No description provided for @userAndAllAssociatedDataDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{userName} and all associated data deleted successfully'**
  String userAndAllAssociatedDataDeletedSuccessfully(Object userName);

  /// No description provided for @errorDeletingUser.
  ///
  /// In en, this message translates to:
  /// **'Error deleting user: {error}'**
  String errorDeletingUser(Object error);

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email: {email}'**
  String email(Object email);

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin: {isAdmin}'**
  String admin(Object isAdmin);

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated: {date}'**
  String updated(Object date);

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday: {birthday}'**
  String birthday(Object birthday);

  /// No description provided for @errorUpdatingTask.
  ///
  /// In en, this message translates to:
  /// **'Error updating task: {error}'**
  String errorUpdatingTask(Object error);

  /// No description provided for @areYouSureYouWantToDeleteTask.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{taskTitle}\"?'**
  String areYouSureYouWantToDeleteTask(Object taskTitle);

  /// No description provided for @taskDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{taskTitle} deleted successfully'**
  String taskDeletedSuccessfully(Object taskTitle);

  /// No description provided for @errorDeletingTask.
  ///
  /// In en, this message translates to:
  /// **'Error deleting task: {error}'**
  String errorDeletingTask(Object error);

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description: {description}'**
  String description(Object description);

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed: {isCompleted}'**
  String completed(Object isCompleted);

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID: {userId}'**
  String userId(Object userId);

  /// No description provided for @noCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get noCategoriesFound;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @selectIcon.
  ///
  /// In en, this message translates to:
  /// **'Select Icon'**
  String get selectIcon;

  /// No description provided for @errorCreatingCategory.
  ///
  /// In en, this message translates to:
  /// **'Error creating category'**
  String get errorCreatingCategory;

  /// No description provided for @categoryCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Category created successfully'**
  String get categoryCreatedSuccessfully;

  /// No description provided for @categoryUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Category updated successfully'**
  String get categoryUpdatedSuccessfully;

  /// No description provided for @areYouSureYouWantToDeleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{categoryName}\"?\n\nNote: If this category is being used by any tasks, deletion will fail. Please reassign those tasks first.'**
  String areYouSureYouWantToDeleteCategory(Object categoryName);

  /// No description provided for @categoryDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Category \"{categoryName}\" deleted successfully'**
  String categoryDeletedSuccessfully(Object categoryName);

  /// No description provided for @errorDeletingCategory.
  ///
  /// In en, this message translates to:
  /// **'Error deleting category: {error}'**
  String errorDeletingCategory(Object error);

  /// No description provided for @na.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get na;

  /// No description provided for @loadingPreferences.
  ///
  /// In en, this message translates to:
  /// **'Loading preferences...'**
  String get loadingPreferences;

  /// No description provided for @oneHour.
  ///
  /// In en, this message translates to:
  /// **'1 Hour'**
  String get oneHour;

  /// No description provided for @threeHours.
  ///
  /// In en, this message translates to:
  /// **'3 Hours'**
  String get threeHours;

  /// No description provided for @achievementUnlocks.
  ///
  /// In en, this message translates to:
  /// **'Achievement Unlocks'**
  String get achievementUnlocks;

  /// No description provided for @systemUpdates.
  ///
  /// In en, this message translates to:
  /// **'System Updates'**
  String get systemUpdates;

  /// No description provided for @notificationSounds.
  ///
  /// In en, this message translates to:
  /// **'Notification Sounds'**
  String get notificationSounds;

  /// No description provided for @scheduleDnd.
  ///
  /// In en, this message translates to:
  /// **'Schedule DND'**
  String get scheduleDnd;

  /// No description provided for @enableSmartNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Smart Notifications'**
  String get enableSmartNotifications;

  /// No description provided for @smartNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Automatically adjust notification timing based on your activity patterns'**
  String get smartNotificationsDescription;

  /// No description provided for @priorityNotifications.
  ///
  /// In en, this message translates to:
  /// **'Priority Notifications'**
  String get priorityNotifications;

  /// No description provided for @priorityNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Only show high-priority notifications during focus time'**
  String get priorityNotificationsDescription;

  /// No description provided for @quietHours.
  ///
  /// In en, this message translates to:
  /// **'Quiet Hours'**
  String get quietHours;

  /// No description provided for @quietHoursDescription.
  ///
  /// In en, this message translates to:
  /// **'Temporarily silence all notifications'**
  String get quietHoursDescription;

  /// No description provided for @notificationChannels.
  ///
  /// In en, this message translates to:
  /// **'Notification Channels'**
  String get notificationChannels;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @inAppNotifications.
  ///
  /// In en, this message translates to:
  /// **'In-App Notifications'**
  String get inAppNotifications;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @quickEdit.
  ///
  /// In en, this message translates to:
  /// **'Quick Edit'**
  String get quickEdit;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @noTasksFoundForSearch.
  ///
  /// In en, this message translates to:
  /// **'No tasks found for \"{searchQuery}\"'**
  String noTasksFoundForSearch(Object searchQuery);

  /// No description provided for @addYourFirstTask.
  ///
  /// In en, this message translates to:
  /// **'Add Your First Task'**
  String get addYourFirstTask;

  /// No description provided for @taskUncompleted.
  ///
  /// In en, this message translates to:
  /// **'Task marked as incomplete'**
  String get taskUncompleted;

  /// No description provided for @taskUpdated.
  ///
  /// In en, this message translates to:
  /// **'Task updated successfully'**
  String get taskUpdated;

  /// No description provided for @createYourFirstCategory.
  ///
  /// In en, this message translates to:
  /// **'Create your first category to organize tasks'**
  String get createYourFirstCategory;

  /// No description provided for @noMoodEntriesFound.
  ///
  /// In en, this message translates to:
  /// **'No mood entries found'**
  String get noMoodEntriesFound;

  /// No description provided for @startTrackingYourMood.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your mood to see insights'**
  String get startTrackingYourMood;

  /// No description provided for @noPomodoroSessionsFound.
  ///
  /// In en, this message translates to:
  /// **'No Pomodoro sessions found'**
  String get noPomodoroSessionsFound;

  /// No description provided for @startYourFirstPomodoroSession.
  ///
  /// In en, this message translates to:
  /// **'Start your first Pomodoro session to boost productivity'**
  String get startYourFirstPomodoroSession;

  /// No description provided for @noProgressData.
  ///
  /// In en, this message translates to:
  /// **'No progress data available'**
  String get noProgressData;

  /// No description provided for @completeTasksToSeeProgress.
  ///
  /// In en, this message translates to:
  /// **'Complete tasks to see your progress'**
  String get completeTasksToSeeProgress;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @allTasks.
  ///
  /// In en, this message translates to:
  /// **'All Tasks'**
  String get allTasks;

  /// No description provided for @unableToLoadProgressData.
  ///
  /// In en, this message translates to:
  /// **'Unable to load progress data'**
  String get unableToLoadProgressData;

  /// No description provided for @progressOverview.
  ///
  /// In en, this message translates to:
  /// **'Progress Overview'**
  String get progressOverview;

  /// No description provided for @tasksCompleted.
  ///
  /// In en, this message translates to:
  /// **'Tasks Completed'**
  String get tasksCompleted;

  /// No description provided for @tasksCompletedThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Tasks Completed This Week'**
  String get tasksCompletedThisWeek;

  /// No description provided for @averageCompletionTime.
  ///
  /// In en, this message translates to:
  /// **'Avg completion time: {time}'**
  String averageCompletionTime(Object time);

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'Streak Days'**
  String get streakDays;

  /// No description provided for @monthlyProgress.
  ///
  /// In en, this message translates to:
  /// **'Monthly Progress'**
  String get monthlyProgress;

  /// No description provided for @categoryBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Category Breakdown'**
  String get categoryBreakdown;

  /// No description provided for @completionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion Rate'**
  String get completionRate;

  /// No description provided for @totalTasks.
  ///
  /// In en, this message translates to:
  /// **'Total Tasks'**
  String get totalTasks;

  /// No description provided for @pendingTasks.
  ///
  /// In en, this message translates to:
  /// **'Pending Tasks'**
  String get pendingTasks;

  /// No description provided for @productivityTrends.
  ///
  /// In en, this message translates to:
  /// **'Productivity Trends'**
  String get productivityTrends;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get last7Days;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get last30Days;

  /// No description provided for @last90Days.
  ///
  /// In en, this message translates to:
  /// **'Last 90 Days'**
  String get last90Days;

  /// No description provided for @noProgressDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No progress data available'**
  String get noProgressDataAvailable;

  /// No description provided for @completeTasksToSeeYourProgress.
  ///
  /// In en, this message translates to:
  /// **'Complete tasks to see your progress'**
  String get completeTasksToSeeYourProgress;

  /// No description provided for @greatProgress.
  ///
  /// In en, this message translates to:
  /// **'Great progress!'**
  String get greatProgress;

  /// No description provided for @keepUpTheGoodWork.
  ///
  /// In en, this message translates to:
  /// **'Keep up the good work'**
  String get keepUpTheGoodWork;

  /// No description provided for @youCanDoBetter.
  ///
  /// In en, this message translates to:
  /// **'You can do better'**
  String get youCanDoBetter;

  /// No description provided for @tryToCompleteMoreTasks.
  ///
  /// In en, this message translates to:
  /// **'Try to complete more tasks'**
  String get tryToCompleteMoreTasks;

  /// No description provided for @excellentPerformance.
  ///
  /// In en, this message translates to:
  /// **'Excellent performance!'**
  String get excellentPerformance;

  /// No description provided for @youAreOnARoll.
  ///
  /// In en, this message translates to:
  /// **'You are on a roll!'**
  String get youAreOnARoll;

  /// No description provided for @voiceTasks.
  ///
  /// In en, this message translates to:
  /// **'Voice Tasks'**
  String get voiceTasks;

  /// No description provided for @startRecording.
  ///
  /// In en, this message translates to:
  /// **'Start Recording'**
  String get startRecording;

  /// No description provided for @tasksCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Tasks created successfully!'**
  String get tasksCreatedSuccessfully;

  /// No description provided for @textInputComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Text input coming soon!'**
  String get textInputComingSoon;

  /// No description provided for @recentTasksComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Recent tasks coming soon!'**
  String get recentTasksComingSoon;

  /// No description provided for @voiceRecording.
  ///
  /// In en, this message translates to:
  /// **'Voice Recording'**
  String get voiceRecording;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @tapToStartRecording.
  ///
  /// In en, this message translates to:
  /// **'Tap to start recording'**
  String get tapToStartRecording;

  /// No description provided for @recordingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Recording in progress'**
  String get recordingInProgress;

  /// No description provided for @stopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop Recording'**
  String get stopRecording;

  /// No description provided for @errorCreatingVoiceTask.
  ///
  /// In en, this message translates to:
  /// **'Error creating voice task'**
  String get errorCreatingVoiceTask;

  /// No description provided for @pleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get pleaseTryAgain;

  /// No description provided for @noSpeechDetected.
  ///
  /// In en, this message translates to:
  /// **'No speech detected'**
  String get noSpeechDetected;

  /// No description provided for @speakClearly.
  ///
  /// In en, this message translates to:
  /// **'Please speak clearly'**
  String get speakClearly;

  /// No description provided for @voiceCommands.
  ///
  /// In en, this message translates to:
  /// **'Voice Commands'**
  String get voiceCommands;

  /// No description provided for @showTasks.
  ///
  /// In en, this message translates to:
  /// **'Show tasks'**
  String get showTasks;

  /// No description provided for @voiceSettings.
  ///
  /// In en, this message translates to:
  /// **'Voice Settings'**
  String get voiceSettings;

  /// No description provided for @enableVoiceCommands.
  ///
  /// In en, this message translates to:
  /// **'Enable Voice Commands'**
  String get enableVoiceCommands;

  /// No description provided for @voiceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Voice Language'**
  String get voiceLanguage;

  /// No description provided for @voiceFeedback.
  ///
  /// In en, this message translates to:
  /// **'Voice Feedback'**
  String get voiceFeedback;

  /// No description provided for @autoDetectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Auto-detect Language'**
  String get autoDetectLanguage;

  /// No description provided for @voiceRecognitionAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Voice Recognition Accuracy'**
  String get voiceRecognitionAccuracy;

  /// No description provided for @subtaskCompleted.
  ///
  /// In en, this message translates to:
  /// **'Subtask completed'**
  String get subtaskCompleted;

  /// No description provided for @subtaskUncompleted.
  ///
  /// In en, this message translates to:
  /// **'Subtask marked as incomplete'**
  String get subtaskUncompleted;

  /// No description provided for @areYouSureYouWantToDeleteSubtask.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this subtask?'**
  String get areYouSureYouWantToDeleteSubtask;

  /// No description provided for @taskNotes.
  ///
  /// In en, this message translates to:
  /// **'Task Notes'**
  String get taskNotes;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes'**
  String get noNotes;

  /// No description provided for @taskAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get taskAttachments;

  /// No description provided for @addAttachment.
  ///
  /// In en, this message translates to:
  /// **'Add Attachment'**
  String get addAttachment;

  /// No description provided for @noAttachments.
  ///
  /// In en, this message translates to:
  /// **'No attachments'**
  String get noAttachments;

  /// No description provided for @taskHistory.
  ///
  /// In en, this message translates to:
  /// **'Task History'**
  String get taskHistory;

  /// No description provided for @modified.
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get modified;

  /// No description provided for @completedAt.
  ///
  /// In en, this message translates to:
  /// **'Completed at'**
  String get completedAt;

  /// No description provided for @taskStatistics.
  ///
  /// In en, this message translates to:
  /// **'Task Statistics'**
  String get taskStatistics;

  /// No description provided for @completionTime.
  ///
  /// In en, this message translates to:
  /// **'Completion Time'**
  String get completionTime;

  /// No description provided for @categoryColor.
  ///
  /// In en, this message translates to:
  /// **'Category Color'**
  String get categoryColor;

  /// No description provided for @categoryIcon.
  ///
  /// In en, this message translates to:
  /// **'Category Icon'**
  String get categoryIcon;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get selectColor;

  /// No description provided for @categoryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Category updated successfully'**
  String get categoryUpdated;

  /// No description provided for @errorUpdatingCategory.
  ///
  /// In en, this message translates to:
  /// **'Error updating category'**
  String get errorUpdatingCategory;

  /// No description provided for @categoryTasksCount.
  ///
  /// In en, this message translates to:
  /// **'Tasks: {count}'**
  String categoryTasksCount(Object count);

  /// No description provided for @addTasksToCategory.
  ///
  /// In en, this message translates to:
  /// **'Add tasks to this category'**
  String get addTasksToCategory;

  /// No description provided for @categoryStatistics.
  ///
  /// In en, this message translates to:
  /// **'Category Statistics'**
  String get categoryStatistics;

  /// No description provided for @totalTasksInCategory.
  ///
  /// In en, this message translates to:
  /// **'Total tasks: {count}'**
  String totalTasksInCategory(Object count);

  /// No description provided for @completedTasksInCategory.
  ///
  /// In en, this message translates to:
  /// **'Completed: {count}'**
  String completedTasksInCategory(Object count);

  /// No description provided for @pendingTasksInCategory.
  ///
  /// In en, this message translates to:
  /// **'Pending: {count}'**
  String pendingTasksInCategory(Object count);

  /// No description provided for @overdueTasksInCategory.
  ///
  /// In en, this message translates to:
  /// **'Overdue: {count}'**
  String overdueTasksInCategory(Object count);

  /// No description provided for @categoryPerformance.
  ///
  /// In en, this message translates to:
  /// **'Category Performance'**
  String get categoryPerformance;

  /// No description provided for @categoryEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Efficiency: {score}%'**
  String categoryEfficiency(Object score);

  /// No description provided for @errorCompletingOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Error completing onboarding'**
  String get errorCompletingOnboarding;

  /// No description provided for @accessibilitySettingsAppliedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Accessibility settings applied successfully'**
  String get accessibilitySettingsAppliedSuccessfully;

  /// No description provided for @errorApplyingSettings.
  ///
  /// In en, this message translates to:
  /// **'Error applying settings: {error}'**
  String errorApplyingSettings(Object error);

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for Now'**
  String get skipForNow;

  /// No description provided for @highContrastMode.
  ///
  /// In en, this message translates to:
  /// **'High Contrast Mode'**
  String get highContrastMode;

  /// No description provided for @largeTextMode.
  ///
  /// In en, this message translates to:
  /// **'Large Text Mode'**
  String get largeTextMode;

  /// No description provided for @reducedMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduced Motion'**
  String get reducedMotion;

  /// No description provided for @accessibilitySetup.
  ///
  /// In en, this message translates to:
  /// **'Accessibility Setup'**
  String get accessibilitySetup;

  /// No description provided for @accessibilitySetupDescription.
  ///
  /// In en, this message translates to:
  /// **'Customize your app experience for better accessibility'**
  String get accessibilitySetupDescription;

  /// No description provided for @weRecommendTheseSettings.
  ///
  /// In en, this message translates to:
  /// **'We recommend these settings based on your preferences'**
  String get weRecommendTheseSettings;

  /// No description provided for @youCanChangeTheseLater.
  ///
  /// In en, this message translates to:
  /// **'You can change these later in settings'**
  String get youCanChangeTheseLater;

  /// No description provided for @applySettings.
  ///
  /// In en, this message translates to:
  /// **'Apply Settings'**
  String get applySettings;

  /// No description provided for @accessibilityCompleted.
  ///
  /// In en, this message translates to:
  /// **'Accessibility setup completed'**
  String get accessibilityCompleted;

  /// No description provided for @continueToApp.
  ///
  /// In en, this message translates to:
  /// **'Continue to App'**
  String get continueToApp;

  /// No description provided for @clearAllLocalData.
  ///
  /// In en, this message translates to:
  /// **'Clear All Local Data'**
  String get clearAllLocalData;

  /// No description provided for @thisWillPermanentlyDelete.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete:'**
  String get thisWillPermanentlyDelete;

  /// No description provided for @allTasksCategoriesMoodsLocalSettings.
  ///
  /// In en, this message translates to:
  /// **'• All tasks\n• All categories\n• All moods\n• All local settings'**
  String get allTasksCategoriesMoodsLocalSettings;

  /// No description provided for @afterDeletionTheAppWillResyncAllDataFromFirebase.
  ///
  /// In en, this message translates to:
  /// **'After deletion, the app will resync all data from Firebase.'**
  String get afterDeletionTheAppWillResyncAllDataFromFirebase;

  /// No description provided for @thisActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone!'**
  String get thisActionCannotBeUndone;

  /// No description provided for @deleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Delete All Data'**
  String get deleteAllData;

  /// No description provided for @forceSyncFromFirebase.
  ///
  /// In en, this message translates to:
  /// **'Force Sync from Firebase'**
  String get forceSyncFromFirebase;

  /// No description provided for @thisWill.
  ///
  /// In en, this message translates to:
  /// **'This will:'**
  String get thisWill;

  /// No description provided for @downloadFreshDataOverwriteLocalChanges.
  ///
  /// In en, this message translates to:
  /// **'• Download fresh data from Firebase\n• Overwrite any local changes\n• Update all repositories'**
  String get downloadFreshDataOverwriteLocalChanges;

  /// No description provided for @anyUnsyncedLocalChangesWillBeLost.
  ///
  /// In en, this message translates to:
  /// **'Any unsynced local changes will be lost!'**
  String get anyUnsyncedLocalChangesWillBeLost;

  /// No description provided for @forceSync.
  ///
  /// In en, this message translates to:
  /// **'Force Sync'**
  String get forceSync;

  /// No description provided for @clearingData.
  ///
  /// In en, this message translates to:
  /// **'Clearing data...'**
  String get clearingData;

  /// No description provided for @allDataClearedAndResyncedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'All data cleared and resynced successfully!'**
  String get allDataClearedAndResyncedSuccessfully;

  /// No description provided for @syncingFromFirebase.
  ///
  /// In en, this message translates to:
  /// **'Syncing from Firebase...'**
  String get syncingFromFirebase;

  /// No description provided for @dataSyncedSuccessfullyFromFirebase.
  ///
  /// In en, this message translates to:
  /// **'Data synced successfully from Firebase!'**
  String get dataSyncedSuccessfullyFromFirebase;

  /// No description provided for @syncError.
  ///
  /// In en, this message translates to:
  /// **'Sync error: {error}'**
  String syncError(Object error);

  /// No description provided for @developerTools.
  ///
  /// In en, this message translates to:
  /// **'Developer Tools'**
  String get developerTools;

  /// No description provided for @performanceMemoryAndQualityMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Performance, memory, and quality monitoring'**
  String get performanceMemoryAndQualityMonitoring;

  /// No description provided for @enablePomodoroOptimization.
  ///
  /// In en, this message translates to:
  /// **'Enable Pomodoro Optimization'**
  String get enablePomodoroOptimization;

  /// No description provided for @automaticallyPlanWorkSessions.
  ///
  /// In en, this message translates to:
  /// **'Automatically plan work sessions'**
  String get automaticallyPlanWorkSessions;

  /// No description provided for @suggestedPlan.
  ///
  /// In en, this message translates to:
  /// **'Suggested Plan:'**
  String get suggestedPlan;

  /// No description provided for @workSessions.
  ///
  /// In en, this message translates to:
  /// **'work sessions'**
  String get workSessions;

  /// No description provided for @minPerSession.
  ///
  /// In en, this message translates to:
  /// **'min per session'**
  String get minPerSession;

  /// No description provided for @totalEstimatedTime.
  ///
  /// In en, this message translates to:
  /// **'Total estimated time: {minutes} min'**
  String totalEstimatedTime(Object minutes);

  /// No description provided for @taskTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Title'**
  String get taskTitle;

  /// No description provided for @taskDescription.
  ///
  /// In en, this message translates to:
  /// **'Task Description'**
  String get taskDescription;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @setDueDate.
  ///
  /// In en, this message translates to:
  /// **'Set Due Date'**
  String get setDueDate;

  /// No description provided for @setReminder.
  ///
  /// In en, this message translates to:
  /// **'Set Reminder'**
  String get setReminder;

  /// No description provided for @noReminder.
  ///
  /// In en, this message translates to:
  /// **'No Reminder'**
  String get noReminder;

  /// No description provided for @setPriority.
  ///
  /// In en, this message translates to:
  /// **'Set Priority'**
  String get setPriority;

  /// No description provided for @addSubtasks.
  ///
  /// In en, this message translates to:
  /// **'Add Subtasks'**
  String get addSubtasks;

  /// No description provided for @saveTask.
  ///
  /// In en, this message translates to:
  /// **'Save Task'**
  String get saveTask;

  /// No description provided for @taskCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Task created successfully'**
  String get taskCreatedSuccessfully;

  /// No description provided for @pleaseFillAllRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get pleaseFillAllRequiredFields;

  /// No description provided for @taskTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Task title is required'**
  String get taskTitleRequired;

  /// No description provided for @invalidDueDate.
  ///
  /// In en, this message translates to:
  /// **'Invalid due date'**
  String get invalidDueDate;

  /// No description provided for @dueDateMustBeInFuture.
  ///
  /// In en, this message translates to:
  /// **'Due date must be in the future'**
  String get dueDateMustBeInFuture;

  /// No description provided for @focusModeFor.
  ///
  /// In en, this message translates to:
  /// **'Focus mode for {taskTitle}'**
  String focusModeFor(Object taskTitle);

  /// No description provided for @taskDuplicatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Task duplicated successfully'**
  String get taskDuplicatedSuccessfully;

  /// No description provided for @subtaskAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Subtask added successfully'**
  String get subtaskAddedSuccessfully;

  /// No description provided for @failedToAddSubtask.
  ///
  /// In en, this message translates to:
  /// **'Failed to add subtask: {error}'**
  String failedToAddSubtask(Object error);

  /// No description provided for @reminderSetFor.
  ///
  /// In en, this message translates to:
  /// **'Reminder set for {date}'**
  String reminderSetFor(Object date);

  /// No description provided for @startFocusMode.
  ///
  /// In en, this message translates to:
  /// **'Start Focus Mode'**
  String get startFocusMode;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTask;

  /// No description provided for @markAsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as Completed'**
  String get markAsCompleted;

  /// No description provided for @markAsIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as Incomplete'**
  String get markAsIncomplete;

  /// No description provided for @taskActions.
  ///
  /// In en, this message translates to:
  /// **'Task Actions'**
  String get taskActions;

  /// No description provided for @taskInformation.
  ///
  /// In en, this message translates to:
  /// **'Task Information'**
  String get taskInformation;

  /// No description provided for @timeTracking.
  ///
  /// In en, this message translates to:
  /// **'Time Tracking'**
  String get timeTracking;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @galleryPermissionIsRequiredToSelectProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Gallery permission is required to select profile image'**
  String get galleryPermissionIsRequiredToSelectProfileImage;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @profilePicture.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get profilePicture;

  /// No description provided for @changeProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Change Profile Picture'**
  String get changeProfilePicture;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @tellUsAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get tellUsAboutYourself;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @errorUpdatingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile'**
  String get errorUpdatingProfile;

  /// No description provided for @profilePictureUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile picture updated successfully'**
  String get profilePictureUpdatedSuccessfully;

  /// No description provided for @errorUpdatingProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile picture'**
  String get errorUpdatingProfilePicture;

  /// No description provided for @aboutTazbeet.
  ///
  /// In en, this message translates to:
  /// **'About Tazbeet'**
  String get aboutTazbeet;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'A smart task management app with Pomodoro integration and AI-powered recommendations.'**
  String get appDescription;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features:'**
  String get features;

  /// No description provided for @smartTaskSortingWithAiRecommendations.
  ///
  /// In en, this message translates to:
  /// **'• Smart task sorting with AI recommendations'**
  String get smartTaskSortingWithAiRecommendations;

  /// No description provided for @pomodoroTimerWithAdaptiveTiming.
  ///
  /// In en, this message translates to:
  /// **'• Pomodoro timer with adaptive timing'**
  String get pomodoroTimerWithAdaptiveTiming;

  /// No description provided for @analyticsAndProductivityInsights.
  ///
  /// In en, this message translates to:
  /// **'• Analytics and productivity insights'**
  String get analyticsAndProductivityInsights;

  /// No description provided for @moodTrackingAndAmbientSettings.
  ///
  /// In en, this message translates to:
  /// **'• Mood tracking and ambient settings'**
  String get moodTrackingAndAmbientSettings;

  /// No description provided for @recurringTaskAutomation.
  ///
  /// In en, this message translates to:
  /// **'• Recurring task automation'**
  String get recurringTaskAutomation;

  /// No description provided for @welcomeToTazbeet.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Tazbeet'**
  String get welcomeToTazbeet;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @exploreFeatures.
  ///
  /// In en, this message translates to:
  /// **'Explore Features'**
  String get exploreFeatures;

  /// No description provided for @viewAllTasks.
  ///
  /// In en, this message translates to:
  /// **'View All Tasks'**
  String get viewAllTasks;

  /// No description provided for @createYourFirstTaskToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Create your first task to get started'**
  String get createYourFirstTaskToGetStarted;

  /// No description provided for @searchTasks.
  ///
  /// In en, this message translates to:
  /// **'Search tasks...'**
  String get searchTasks;

  /// No description provided for @filterTasks.
  ///
  /// In en, this message translates to:
  /// **'Filter tasks'**
  String get filterTasks;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @tryDifferentFilters.
  ///
  /// In en, this message translates to:
  /// **'Try different filters or search terms'**
  String get tryDifferentFilters;

  /// No description provided for @errorLoadingAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Error loading analytics: {error}'**
  String errorLoadingAnalytics(Object error);

  /// No description provided for @weeklyProgressOf.
  ///
  /// In en, this message translates to:
  /// **'{progress} of {goal} sessions'**
  String weeklyProgressOf(Object goal, Object progress);

  /// No description provided for @recommendedAdjustments.
  ///
  /// In en, this message translates to:
  /// **'Recommended Adjustments:'**
  String get recommendedAdjustments;

  /// No description provided for @noRecommendationsAvailableAtThisTime.
  ///
  /// In en, this message translates to:
  /// **'No recommendations available at this time.'**
  String get noRecommendationsAvailableAtThisTime;

  /// No description provided for @pomodoroAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Analytics'**
  String get pomodoroAnalytics;

  /// No description provided for @weeklyStats.
  ///
  /// In en, this message translates to:
  /// **'Weekly Stats'**
  String get weeklyStats;

  /// No description provided for @monthlyStats.
  ///
  /// In en, this message translates to:
  /// **'Monthly Stats'**
  String get monthlyStats;

  /// No description provided for @allTimeStats.
  ///
  /// In en, this message translates to:
  /// **'All-Time Stats'**
  String get allTimeStats;

  /// No description provided for @totalSessions.
  ///
  /// In en, this message translates to:
  /// **'Total Sessions'**
  String get totalSessions;

  /// No description provided for @completedSessions.
  ///
  /// In en, this message translates to:
  /// **'Completed Sessions'**
  String get completedSessions;

  /// No description provided for @averageSessionLength.
  ///
  /// In en, this message translates to:
  /// **'Average Session Length'**
  String get averageSessionLength;

  /// No description provided for @totalFocusTime.
  ///
  /// In en, this message translates to:
  /// **'Total Focus Time'**
  String get totalFocusTime;

  /// No description provided for @bestPerformanceDay.
  ///
  /// In en, this message translates to:
  /// **'Best Performance Day'**
  String get bestPerformanceDay;

  /// No description provided for @mostProductiveHour.
  ///
  /// In en, this message translates to:
  /// **'Most Productive Hour'**
  String get mostProductiveHour;

  /// No description provided for @sessionCompletionRate.
  ///
  /// In en, this message translates to:
  /// **'Session Completion Rate'**
  String get sessionCompletionRate;

  /// No description provided for @focusTimeDistribution.
  ///
  /// In en, this message translates to:
  /// **'Focus Time Distribution'**
  String get focusTimeDistribution;

  /// No description provided for @breakTimeDistribution.
  ///
  /// In en, this message translates to:
  /// **'Break Time Distribution'**
  String get breakTimeDistribution;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @performanceMetrics.
  ///
  /// In en, this message translates to:
  /// **'Performance Metrics'**
  String get performanceMetrics;

  /// No description provided for @sessionHistory.
  ///
  /// In en, this message translates to:
  /// **'Session History'**
  String get sessionHistory;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @shareReport.
  ///
  /// In en, this message translates to:
  /// **'Share Report'**
  String get shareReport;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// No description provided for @customRange.
  ///
  /// In en, this message translates to:
  /// **'Custom Range'**
  String get customRange;

  /// No description provided for @defaultValue.
  ///
  /// In en, this message translates to:
  /// **'Default: {isDefault}'**
  String defaultValue(Object isDefault);

  /// No description provided for @editMaintenanceMessage.
  ///
  /// In en, this message translates to:
  /// **'Edit Maintenance Message'**
  String get editMaintenanceMessage;

  /// No description provided for @blockAllNonAdminUsers.
  ///
  /// In en, this message translates to:
  /// **'• Block all non-admin users'**
  String get blockAllNonAdminUsers;

  /// No description provided for @showMaintenanceScreenToUsers.
  ///
  /// In en, this message translates to:
  /// **'• Show maintenance screen to users'**
  String get showMaintenanceScreenToUsers;

  /// No description provided for @onlyAdminsCanAccessTheApp.
  ///
  /// In en, this message translates to:
  /// **'• Only admins can access the app'**
  String get onlyAdminsCanAccessTheApp;

  /// No description provided for @allowAllUsersToAccessTheApp.
  ///
  /// In en, this message translates to:
  /// **'• Allow all users to access the app'**
  String get allowAllUsersToAccessTheApp;

  /// No description provided for @returnToNormalOperation.
  ///
  /// In en, this message translates to:
  /// **'• Return to normal operation'**
  String get returnToNormalOperation;

  /// No description provided for @maintenanceMode.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Mode'**
  String get maintenanceMode;

  /// No description provided for @maintenanceModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Put the app in maintenance mode'**
  String get maintenanceModeDescription;

  /// No description provided for @maintenanceMessage.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Message'**
  String get maintenanceMessage;

  /// No description provided for @enterMaintenanceMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter maintenance message'**
  String get enterMaintenanceMessage;

  /// No description provided for @saveMaintenanceSettings.
  ///
  /// In en, this message translates to:
  /// **'Save Maintenance Settings'**
  String get saveMaintenanceSettings;

  /// No description provided for @maintenanceSettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Maintenance settings saved successfully'**
  String get maintenanceSettingsSaved;

  /// No description provided for @errorSavingMaintenanceSettings.
  ///
  /// In en, this message translates to:
  /// **'Error saving maintenance settings'**
  String get errorSavingMaintenanceSettings;

  /// No description provided for @viewDetailsButton.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetailsButton;

  /// No description provided for @quickEditButton.
  ///
  /// In en, this message translates to:
  /// **'Quick Edit'**
  String get quickEditButton;

  /// No description provided for @clearButton.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearButton;

  /// No description provided for @searchButton.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchButton;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @resetToDefaults.
  ///
  /// In en, this message translates to:
  /// **'Reset to Defaults'**
  String get resetToDefaults;

  /// No description provided for @resetAllThemeSettingsToDefaultValues.
  ///
  /// In en, this message translates to:
  /// **'Reset all theme settings to default values'**
  String get resetAllThemeSettingsToDefaultValues;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetThemeSettings.
  ///
  /// In en, this message translates to:
  /// **'Reset Theme Settings'**
  String get resetThemeSettings;

  /// No description provided for @thisWillResetAllThemeSettingsToTheirDefaultValues.
  ///
  /// In en, this message translates to:
  /// **'This will reset all theme settings to their default values. You can always change them back later.'**
  String get thisWillResetAllThemeSettingsToTheirDefaultValues;

  /// No description provided for @themeSettingsResetToDefaults.
  ///
  /// In en, this message translates to:
  /// **'Theme settings reset to defaults'**
  String get themeSettingsResetToDefaults;

  /// No description provided for @themeSettings.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @systemMode.
  ///
  /// In en, this message translates to:
  /// **'System Mode'**
  String get systemMode;

  /// No description provided for @followSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Follow system settings'**
  String get followSystemSettings;

  /// No description provided for @useDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Use dark theme'**
  String get useDarkTheme;

  /// No description provided for @useLightTheme.
  ///
  /// In en, this message translates to:
  /// **'Use light theme'**
  String get useLightTheme;

  /// No description provided for @colorTheme.
  ///
  /// In en, this message translates to:
  /// **'Color Theme'**
  String get colorTheme;

  /// No description provided for @accentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent Color'**
  String get accentColor;

  /// No description provided for @backgroundColor.
  ///
  /// In en, this message translates to:
  /// **'Background Color'**
  String get backgroundColor;

  /// No description provided for @surfaceColor.
  ///
  /// In en, this message translates to:
  /// **'Surface Color'**
  String get surfaceColor;

  /// No description provided for @textColor.
  ///
  /// In en, this message translates to:
  /// **'Text Color'**
  String get textColor;

  /// No description provided for @enableCustomColors.
  ///
  /// In en, this message translates to:
  /// **'Enable Custom Colors'**
  String get enableCustomColors;

  /// No description provided for @customColorSettings.
  ///
  /// In en, this message translates to:
  /// **'Custom Color Settings'**
  String get customColorSettings;

  /// No description provided for @selectPrimaryColor.
  ///
  /// In en, this message translates to:
  /// **'Select Primary Color'**
  String get selectPrimaryColor;

  /// No description provided for @selectAccentColor.
  ///
  /// In en, this message translates to:
  /// **'Select Accent Color'**
  String get selectAccentColor;

  /// No description provided for @selectBackgroundColor.
  ///
  /// In en, this message translates to:
  /// **'Select Background Color'**
  String get selectBackgroundColor;

  /// No description provided for @selectSurfaceColor.
  ///
  /// In en, this message translates to:
  /// **'Select Surface Color'**
  String get selectSurfaceColor;

  /// No description provided for @selectTextColor.
  ///
  /// In en, this message translates to:
  /// **'Select Text Color'**
  String get selectTextColor;

  /// No description provided for @colorPicker.
  ///
  /// In en, this message translates to:
  /// **'Color Picker'**
  String get colorPicker;

  /// No description provided for @chooseColor.
  ///
  /// In en, this message translates to:
  /// **'Choose Color'**
  String get chooseColor;

  /// No description provided for @selectedColor.
  ///
  /// In en, this message translates to:
  /// **'Selected Color'**
  String get selectedColor;

  /// No description provided for @applyColors.
  ///
  /// In en, this message translates to:
  /// **'Apply Colors'**
  String get applyColors;

  /// No description provided for @resetColors.
  ///
  /// In en, this message translates to:
  /// **'Reset Colors'**
  String get resetColors;

  /// No description provided for @colorSettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Color settings saved successfully'**
  String get colorSettingsSaved;

  /// No description provided for @errorSavingColorSettings.
  ///
  /// In en, this message translates to:
  /// **'Error saving color settings'**
  String get errorSavingColorSettings;

  /// No description provided for @noMoodHistoryAvailableForSuggestions.
  ///
  /// In en, this message translates to:
  /// **'No mood history available for suggestions'**
  String get noMoodHistoryAvailableForSuggestions;

  /// No description provided for @addedSuggestedCheckInTimesFromYourMoodHistory.
  ///
  /// In en, this message translates to:
  /// **'Added {count} suggested check-in times from your mood history'**
  String addedSuggestedCheckInTimesFromYourMoodHistory(Object count);

  /// No description provided for @allSuggestedTimesAreAlreadyInYourList.
  ///
  /// In en, this message translates to:
  /// **'All suggested times are already in your list'**
  String get allSuggestedTimesAreAlreadyInYourList;

  /// No description provided for @failedToGetSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Failed to get suggestions: {error}'**
  String failedToGetSuggestions(Object error);

  /// No description provided for @testMoodNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'Test mood notification sent!'**
  String get testMoodNotificationSent;

  /// No description provided for @failedToSendTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Failed to send test notification: {error}'**
  String failedToSendTestNotification(Object error);

  /// No description provided for @pendingMoodNotifications.
  ///
  /// In en, this message translates to:
  /// **'Pending Mood Notifications'**
  String get pendingMoodNotifications;

  /// No description provided for @moodNotificationsScheduledTotalPending.
  ///
  /// In en, this message translates to:
  /// **'{count} mood notifications scheduled\nTotal pending: {pending}'**
  String moodNotificationsScheduledTotalPending(Object count, Object pending);

  /// No description provided for @failedToCheckPendingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Failed to check pending notifications: {error}'**
  String failedToCheckPendingNotifications(Object error);

  /// No description provided for @removeThisCheckInTime.
  ///
  /// In en, this message translates to:
  /// **'Remove this check-in time?'**
  String get removeThisCheckInTime;

  /// No description provided for @receivePeriodicMoodCheckInReminders.
  ///
  /// In en, this message translates to:
  /// **'Receive periodic mood check-in reminders'**
  String get receivePeriodicMoodCheckInReminders;

  /// No description provided for @testMoodNotificationScheduledFor1MinuteFromNow.
  ///
  /// In en, this message translates to:
  /// **'Test mood notification scheduled for 1 minute from now!'**
  String get testMoodNotificationScheduledFor1MinuteFromNow;

  /// No description provided for @failedToScheduleTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Failed to schedule test notification: {error}'**
  String failedToScheduleTestNotification(Object error);

  /// No description provided for @testScheduledNotification.
  ///
  /// In en, this message translates to:
  /// **'Test Scheduled Notification'**
  String get testScheduledNotification;

  /// No description provided for @failedToCancelNotifications.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel notifications: {error}'**
  String failedToCancelNotifications(Object error);

  /// No description provided for @moodSettings.
  ///
  /// In en, this message translates to:
  /// **'Mood Settings'**
  String get moodSettings;

  /// No description provided for @notificationTimes.
  ///
  /// In en, this message translates to:
  /// **'Notification Times'**
  String get notificationTimes;

  /// No description provided for @addNotificationTime.
  ///
  /// In en, this message translates to:
  /// **'Add Notification Time'**
  String get addNotificationTime;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @suggestedTimes.
  ///
  /// In en, this message translates to:
  /// **'Suggested Times'**
  String get suggestedTimes;

  /// No description provided for @getSuggestionsFromHistory.
  ///
  /// In en, this message translates to:
  /// **'Get Suggestions from History'**
  String get getSuggestionsFromHistory;

  /// No description provided for @notificationTools.
  ///
  /// In en, this message translates to:
  /// **'Notification Tools'**
  String get notificationTools;

  /// No description provided for @noCheckInTimesSetAddOneToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'No check-in times set. Add one to get started!'**
  String get noCheckInTimesSetAddOneToGetStarted;

  /// No description provided for @pomodoroPlanning.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Planning'**
  String get pomodoroPlanning;

  /// No description provided for @focusDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Focus Difficulty: {score}'**
  String focusDifficulty(Object score);

  /// No description provided for @easyFocusDeepFocusRequired.
  ///
  /// In en, this message translates to:
  /// **'1 = Easy focus, 10 = Deep focus required'**
  String get easyFocusDeepFocusRequired;

  /// No description provided for @priorityTitle.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priorityTitle;

  /// No description provided for @galleryPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Gallery permission is required to select profile image'**
  String get galleryPermissionRequired;

  /// No description provided for @authenticationErrorPleaseLogInAgain.
  ///
  /// In en, this message translates to:
  /// **'Authentication error. Please log in again.'**
  String get authenticationErrorPleaseLogInAgain;

  /// No description provided for @tryAdjustingYourSearchTerms.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search terms'**
  String get tryAdjustingYourSearchTerms;

  /// No description provided for @defaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultLabel;

  /// No description provided for @defaultCategory.
  ///
  /// In en, this message translates to:
  /// **'Default Category'**
  String get defaultCategory;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @refreshData.
  ///
  /// In en, this message translates to:
  /// **'Refresh Data'**
  String get refreshData;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @defaultYes.
  ///
  /// In en, this message translates to:
  /// **'Default: {value}'**
  String defaultYes(Object value);

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @generalSettings.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSettings;

  /// No description provided for @userRegistration.
  ///
  /// In en, this message translates to:
  /// **'User Registration'**
  String get userRegistration;

  /// No description provided for @newUsersCanRegister.
  ///
  /// In en, this message translates to:
  /// **'New users can register'**
  String get newUsersCanRegister;

  /// No description provided for @registrationIsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Registration is disabled'**
  String get registrationIsDisabled;

  /// No description provided for @appInformation.
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInformation;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @supportEmail.
  ///
  /// In en, this message translates to:
  /// **'Support Email'**
  String get supportEmail;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @enterMessageUsersWillSee.
  ///
  /// In en, this message translates to:
  /// **'Enter the message users will see...'**
  String get enterMessageUsersWillSee;

  /// No description provided for @maintenanceModeConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to {action} maintenance mode?\n\n{details}'**
  String maintenanceModeConfirmation(Object action, Object details);

  /// No description provided for @onlyAdminsCanAccessApp.
  ///
  /// In en, this message translates to:
  /// **'• Only admins can access the app'**
  String get onlyAdminsCanAccessApp;

  /// No description provided for @allowAllUsersToAccessApp.
  ///
  /// In en, this message translates to:
  /// **'• Allow all users to access the app'**
  String get allowAllUsersToAccessApp;

  /// No description provided for @enableMaintenanceMode.
  ///
  /// In en, this message translates to:
  /// **'Enable Maintenance Mode'**
  String get enableMaintenanceMode;

  /// No description provided for @disableMaintenanceMode.
  ///
  /// In en, this message translates to:
  /// **'Disable Maintenance Mode'**
  String get disableMaintenanceMode;

  /// No description provided for @disable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @performanceMonitor.
  ///
  /// In en, this message translates to:
  /// **'Performance Monitor'**
  String get performanceMonitor;

  /// No description provided for @trackedOperations.
  ///
  /// In en, this message translates to:
  /// **'Tracked Operations: {count}'**
  String trackedOperations(Object count);

  /// No description provided for @slowOperations.
  ///
  /// In en, this message translates to:
  /// **'Slow Operations (>500ms): {count}'**
  String slowOperations(Object count);

  /// No description provided for @logReport.
  ///
  /// In en, this message translates to:
  /// **'Log Report'**
  String get logReport;

  /// No description provided for @memoryManager.
  ///
  /// In en, this message translates to:
  /// **'Memory Manager'**
  String get memoryManager;

  /// No description provided for @forceCleanup.
  ///
  /// In en, this message translates to:
  /// **'Force Cleanup'**
  String get forceCleanup;

  /// No description provided for @logStats.
  ///
  /// In en, this message translates to:
  /// **'Log Stats'**
  String get logStats;

  /// No description provided for @animationOptimizer.
  ///
  /// In en, this message translates to:
  /// **'Animation Optimizer'**
  String get animationOptimizer;

  /// No description provided for @codeQualityMonitor.
  ///
  /// In en, this message translates to:
  /// **'Code Quality Monitor'**
  String get codeQualityMonitor;

  /// No description provided for @qualityScore.
  ///
  /// In en, this message translates to:
  /// **'Quality Score: '**
  String get qualityScore;

  /// No description provided for @notificationVerification.
  ///
  /// In en, this message translates to:
  /// **'Notification Verification'**
  String get notificationVerification;

  /// No description provided for @checkPending.
  ///
  /// In en, this message translates to:
  /// **'Check Pending'**
  String get checkPending;

  /// No description provided for @verifyAllTasks.
  ///
  /// In en, this message translates to:
  /// **'Verify All Tasks'**
  String get verifyAllTasks;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @clearPerformance.
  ///
  /// In en, this message translates to:
  /// **'Clear Performance'**
  String get clearPerformance;

  /// No description provided for @clearQuality.
  ///
  /// In en, this message translates to:
  /// **'Clear Quality'**
  String get clearQuality;

  /// No description provided for @performanceReportLoggedToConsole.
  ///
  /// In en, this message translates to:
  /// **'Performance report logged to console'**
  String get performanceReportLoggedToConsole;

  /// No description provided for @memoryCleanupCompleted.
  ///
  /// In en, this message translates to:
  /// **'Memory cleanup completed'**
  String get memoryCleanupCompleted;

  /// No description provided for @memoryStatsLoggedToConsole.
  ///
  /// In en, this message translates to:
  /// **'Memory stats logged to console'**
  String get memoryStatsLoggedToConsole;

  /// No description provided for @animationStatsLoggedToConsole.
  ///
  /// In en, this message translates to:
  /// **'Animation stats logged to console'**
  String get animationStatsLoggedToConsole;

  /// No description provided for @qualityReportLoggedToConsole.
  ///
  /// In en, this message translates to:
  /// **'Quality report logged to console'**
  String get qualityReportLoggedToConsole;

  /// No description provided for @performanceMetricsCleared.
  ///
  /// In en, this message translates to:
  /// **'Performance metrics cleared'**
  String get performanceMetricsCleared;

  /// No description provided for @qualityMetricsCleared.
  ///
  /// In en, this message translates to:
  /// **'Quality metrics cleared'**
  String get qualityMetricsCleared;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// No description provided for @backupAndRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupAndRestore;

  /// No description provided for @exportYourTasksToExternalFormats.
  ///
  /// In en, this message translates to:
  /// **'Export your tasks to external formats'**
  String get exportYourTasksToExternalFormats;

  /// No description provided for @exportCSV.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCSV;

  /// No description provided for @exportJSON.
  ///
  /// In en, this message translates to:
  /// **'Export JSON'**
  String get exportJSON;

  /// No description provided for @exportICSCalendar.
  ///
  /// In en, this message translates to:
  /// **'Export ICS (Calendar)'**
  String get exportICSCalendar;

  /// No description provided for @importTasksFromExternalFiles.
  ///
  /// In en, this message translates to:
  /// **'Import tasks from external files'**
  String get importTasksFromExternalFiles;

  /// No description provided for @importFromFile.
  ///
  /// In en, this message translates to:
  /// **'Import from File'**
  String get importFromFile;

  /// No description provided for @createAndRestoreBackups.
  ///
  /// In en, this message translates to:
  /// **'Create and restore backups'**
  String get createAndRestoreBackups;

  /// No description provided for @createBackup.
  ///
  /// In en, this message translates to:
  /// **'Create Backup'**
  String get createBackup;

  /// No description provided for @restoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get restoreBackup;

  /// No description provided for @notificationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Notification deleted'**
  String get notificationDeleted;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @areYouSureYouWantToClearAllNotificationHistory.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all notification history?'**
  String get areYouSureYouWantToClearAllNotificationHistory;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @historyCleared.
  ///
  /// In en, this message translates to:
  /// **'History cleared'**
  String get historyCleared;

  /// No description provided for @smartFeaturesTutorial.
  ///
  /// In en, this message translates to:
  /// **'Smart Features Tutorial'**
  String get smartFeaturesTutorial;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @completeTutorial.
  ///
  /// In en, this message translates to:
  /// **'Complete Tutorial'**
  String get completeTutorial;

  /// No description provided for @customizeYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Customize your experience'**
  String get customizeYourExperience;

  /// No description provided for @adjustTheseSettingsToMakeTheAppWorkBetterForYou.
  ///
  /// In en, this message translates to:
  /// **'Adjust these settings to make the app work better for you'**
  String get adjustTheseSettingsToMakeTheAppWorkBetterForYou;

  /// No description provided for @minimizeAnimationsAndTransitions.
  ///
  /// In en, this message translates to:
  /// **'Minimize animations and transitions'**
  String get minimizeAnimationsAndTransitions;

  /// No description provided for @controlTheAppWithYourVoice.
  ///
  /// In en, this message translates to:
  /// **'Control the app with your voice'**
  String get controlTheAppWithYourVoice;

  /// No description provided for @increaseColorContrastForBetterVisibility.
  ///
  /// In en, this message translates to:
  /// **'Increase color contrast for better visibility'**
  String get increaseColorContrastForBetterVisibility;

  /// No description provided for @makeTextLargerAndEasierToRead.
  ///
  /// In en, this message translates to:
  /// **'Make text larger and easier to read'**
  String get makeTextLargerAndEasierToRead;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get needHelp;

  /// No description provided for @enableVoiceTasks.
  ///
  /// In en, this message translates to:
  /// **'Enable Voice Tasks'**
  String get enableVoiceTasks;

  /// No description provided for @createTasksWithYourVoice.
  ///
  /// In en, this message translates to:
  /// **'Create tasks with your voice'**
  String get createTasksWithYourVoice;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @thankYouForYourPatience.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your patience 💙'**
  String get thankYouForYourPatience;

  /// No description provided for @moodAlreadyLoggedToday.
  ///
  /// In en, this message translates to:
  /// **'You have already logged your mood today'**
  String get moodAlreadyLoggedToday;

  /// No description provided for @updateTodaysEntryInstead.
  ///
  /// In en, this message translates to:
  /// **'You can update today\'s entry instead'**
  String get updateTodaysEntryInstead;

  /// No description provided for @viewAndUpdateMood.
  ///
  /// In en, this message translates to:
  /// **'View & Update Mood'**
  String get viewAndUpdateMood;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @yourIntelligentTaskManagementCompanionWithAIPoweredFeatures.
  ///
  /// In en, this message translates to:
  /// **'Your intelligent task management companion with AI-powered features'**
  String get yourIntelligentTaskManagementCompanionWithAIPoweredFeatures;

  /// No description provided for @smartTaskSorting.
  ///
  /// In en, this message translates to:
  /// **'Smart Task Sorting'**
  String get smartTaskSorting;

  /// No description provided for @experienceAIPoweredTaskPrioritizationThatAdaptsToYourPatterns.
  ///
  /// In en, this message translates to:
  /// **'Experience AI-powered task prioritization that adapts to your patterns'**
  String get experienceAIPoweredTaskPrioritizationThatAdaptsToYourPatterns;

  /// No description provided for @pomodoroIntegration.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Integration'**
  String get pomodoroIntegration;

  /// No description provided for @focusBetterWithAdaptiveTimingAndSmartBreaks.
  ///
  /// In en, this message translates to:
  /// **'Focus better with adaptive timing and smart breaks'**
  String get focusBetterWithAdaptiveTimingAndSmartBreaks;

  /// No description provided for @moodEnergyTracking.
  ///
  /// In en, this message translates to:
  /// **'Mood & Energy Tracking'**
  String get moodEnergyTracking;

  /// No description provided for @understandYourPatternsAndOptimizeYourProductivity.
  ///
  /// In en, this message translates to:
  /// **'Understand your patterns and optimize your productivity'**
  String get understandYourPatternsAndOptimizeYourProductivity;

  /// No description provided for @accessibilityFeatures.
  ///
  /// In en, this message translates to:
  /// **'Accessibility Features'**
  String get accessibilityFeatures;

  /// No description provided for @customizeTheAppToWorkBestForYou.
  ///
  /// In en, this message translates to:
  /// **'Customize the app to work best for you'**
  String get customizeTheAppToWorkBestForYou;

  /// No description provided for @viewAndUpdateTodaysMoodEntry.
  ///
  /// In en, this message translates to:
  /// **'Would you like to view and update today\'s mood entry?'**
  String get viewAndUpdateTodaysMoodEntry;

  /// No description provided for @hiveBoxes.
  ///
  /// In en, this message translates to:
  /// **'Hive Boxes: {count}'**
  String hiveBoxes(Object count);

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String status(Object status);

  /// No description provided for @pendingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Pending notifications: {count}'**
  String pendingNotifications(Object count);

  /// No description provided for @verificationReportLoggedToConsole.
  ///
  /// In en, this message translates to:
  /// **'Verification report logged to console'**
  String get verificationReportLoggedToConsole;

  /// No description provided for @performanceMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Performance Monitoring'**
  String get performanceMonitoring;

  /// No description provided for @memoryManagement.
  ///
  /// In en, this message translates to:
  /// **'Memory Management'**
  String get memoryManagement;

  /// No description provided for @animationOptimization.
  ///
  /// In en, this message translates to:
  /// **'Animation Optimization'**
  String get animationOptimization;

  /// No description provided for @codeQuality.
  ///
  /// In en, this message translates to:
  /// **'Code Quality'**
  String get codeQuality;

  /// No description provided for @dataSync.
  ///
  /// In en, this message translates to:
  /// **'Data Sync'**
  String get dataSync;

  /// No description provided for @clearAllMetrics.
  ///
  /// In en, this message translates to:
  /// **'Clear All Metrics'**
  String get clearAllMetrics;

  /// No description provided for @developerOptions.
  ///
  /// In en, this message translates to:
  /// **'Developer Options'**
  String get developerOptions;

  /// No description provided for @debugMode.
  ///
  /// In en, this message translates to:
  /// **'Debug Mode'**
  String get debugMode;

  /// No description provided for @enableDebugMode.
  ///
  /// In en, this message translates to:
  /// **'Enable Debug Mode'**
  String get enableDebugMode;

  /// No description provided for @disableDebugMode.
  ///
  /// In en, this message translates to:
  /// **'Disable Debug Mode'**
  String get disableDebugMode;

  /// No description provided for @debugModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable additional logging and debugging features'**
  String get debugModeDescription;

  /// No description provided for @memoryUsage.
  ///
  /// In en, this message translates to:
  /// **'Memory Usage'**
  String get memoryUsage;

  /// No description provided for @databaseSize.
  ///
  /// In en, this message translates to:
  /// **'Database Size'**
  String get databaseSize;

  /// No description provided for @cacheSize.
  ///
  /// In en, this message translates to:
  /// **'Cache Size'**
  String get cacheSize;

  /// No description provided for @networkRequests.
  ///
  /// In en, this message translates to:
  /// **'Network Requests'**
  String get networkRequests;

  /// No description provided for @errorTracking.
  ///
  /// In en, this message translates to:
  /// **'Error Tracking'**
  String get errorTracking;

  /// No description provided for @logLevel.
  ///
  /// In en, this message translates to:
  /// **'Log Level'**
  String get logLevel;

  /// No description provided for @verbose.
  ///
  /// In en, this message translates to:
  /// **'Verbose'**
  String get verbose;

  /// No description provided for @debug.
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get debug;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @exportLogs.
  ///
  /// In en, this message translates to:
  /// **'Export Logs'**
  String get exportLogs;

  /// No description provided for @importLogs.
  ///
  /// In en, this message translates to:
  /// **'Import Logs'**
  String get importLogs;

  /// No description provided for @clearLogs.
  ///
  /// In en, this message translates to:
  /// **'Clear Logs'**
  String get clearLogs;

  /// No description provided for @logsExported.
  ///
  /// In en, this message translates to:
  /// **'Logs exported successfully'**
  String get logsExported;

  /// No description provided for @logsImported.
  ///
  /// In en, this message translates to:
  /// **'Logs imported successfully'**
  String get logsImported;

  /// No description provided for @logsCleared.
  ///
  /// In en, this message translates to:
  /// **'Logs cleared successfully'**
  String get logsCleared;

  /// No description provided for @errorExportingLogs.
  ///
  /// In en, this message translates to:
  /// **'Error exporting logs'**
  String get errorExportingLogs;

  /// No description provided for @errorImportingLogs.
  ///
  /// In en, this message translates to:
  /// **'Error importing logs'**
  String get errorImportingLogs;

  /// No description provided for @errorClearingLogs.
  ///
  /// In en, this message translates to:
  /// **'Error clearing logs'**
  String get errorClearingLogs;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
