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

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @editButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editButton;

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search tasks...'**
  String get searchHint;

  /// No description provided for @noTasksFound.
  ///
  /// In en, this message translates to:
  /// **'No tasks found'**
  String get noTasksFound;

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

  /// No description provided for @addTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Task'**
  String get addTaskTitle;

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

  /// No description provided for @deleteTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get deleteTaskTitle;

  /// No description provided for @noCategory.
  ///
  /// In en, this message translates to:
  /// **'No Category'**
  String get noCategory;

  /// No description provided for @filterTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter Tasks'**
  String get filterTasksTitle;

  /// No description provided for @priorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority:'**
  String get priorityLabel;

  /// No description provided for @allLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allLabel;

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

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status:'**
  String get statusLabel;

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

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

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

  /// No description provided for @termsAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'By signing in, you agree to our Terms of Service and Privacy Policy'**
  String get termsAndPrivacy;

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
  /// **'Classic (25/5/15)'**
  String get classicPreset;

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
  /// **'How are you feeling today?'**
  String get howAreYouFeeling;

  /// No description provided for @tapToLogMood.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to log your mood'**
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

  /// No description provided for @metricValue.
  ///
  /// In en, this message translates to:
  /// **'{label}: {value}/10'**
  String metricValue(String label, int value);

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

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String percent(int value);

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

  /// No description provided for @tapToManage.
  ///
  /// In en, this message translates to:
  /// **'Tap to manage'**
  String get tapToManage;

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

  /// No description provided for @noCategoriesYetDescription.
  ///
  /// In en, this message translates to:
  /// **'Create categories to organize your tasks'**
  String get noCategoriesYetDescription;

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
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
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

  /// No description provided for @repeatSettings.
  ///
  /// In en, this message translates to:
  /// **'Repeat Settings'**
  String get repeatSettings;

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
