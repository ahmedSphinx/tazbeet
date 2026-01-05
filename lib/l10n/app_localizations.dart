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
  /// **'Are you sure you want to delete this task?'**
  String confirmDeleteTask(String taskTitle);

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
  /// **'Color:'**
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
  /// **'{count} tasks'**
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

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

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
  /// **'Very Bad'**
  String get moodVeryBad;

  /// No description provided for @moodBad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get moodBad;

  /// No description provided for @moodNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get moodNeutral;

  /// No description provided for @moodGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get moodGood;

  /// No description provided for @moodVeryGood.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
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
  /// **'Task completed!'**
  String get taskCompleted;

  /// No description provided for @taskDeleted.
  ///
  /// In en, this message translates to:
  /// **'Task deleted'**
  String get taskDeleted;

  /// No description provided for @categoryCreated.
  ///
  /// In en, this message translates to:
  /// **'Category created'**
  String get categoryCreated;

  /// No description provided for @categoryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Category deleted'**
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

  /// No description provided for @addTaskToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Add a task to get started'**
  String get addTaskToGetStarted;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
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
  /// **'Delete Subtask'**
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
  /// **'High'**
  String get highPriority;

  /// No description provided for @mediumPriority.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get mediumPriority;

  /// No description provided for @lowPriority.
  ///
  /// In en, this message translates to:
  /// **'Low'**
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
  /// **'Overdue tasks - need immediate attention'**
  String get overdueTasks;

  /// No description provided for @todayTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks to complete today'**
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
  /// **'Test notification sent!'**
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
  /// **'All notifications cancelled!'**
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
  /// **'Version {version}'**
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
  /// **'No due date'**
  String get noDueDate;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

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
  /// **'No subtasks yet'**
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
  /// **'Pomodoro'**
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
  /// **'min'**
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
  /// **'Icon'**
  String get icon;

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

  /// No description provided for @deleteTask.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get deleteTask;

  /// No description provided for @deleteTaskConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{task}\"?'**
  String deleteTaskConfirmation(String task);

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

  /// No description provided for @noRecurringTasksFound.
  ///
  /// In en, this message translates to:
  /// **'No recurring tasks found'**
  String get noRecurringTasksFound;

  /// No description provided for @recurringTasksOptimized.
  ///
  /// In en, this message translates to:
  /// **'Recurring tasks optimized for performance'**
  String get recurringTasksOptimized;
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
