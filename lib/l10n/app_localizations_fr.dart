// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Application de Liste de Tâches';

  @override
  String get homeScreenTitle => 'Accueil';

  @override
  String get settingsScreenTitle => 'Paramètres';

  @override
  String get languageLabel => 'Langue';

  @override
  String get themeLabel => 'Thème';

  @override
  String get darkTheme => 'Sombre';

  @override
  String get lightTheme => 'Clair';

  @override
  String get systemTheme => 'Système';

  @override
  String get saveButton => 'Enregistrer';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get taskTitleLabel => 'Titre de la Tâche';

  @override
  String get taskDescriptionLabel => 'Description (Optional)';

  @override
  String get addTaskButton => 'Ajouter une Tâche';

  @override
  String get editTaskButton => 'Modifier la Tâche';

  @override
  String get deleteTaskButton => 'Supprimer la Tâche';

  @override
  String confirmDeleteTask(String taskTitle) {
    return 'Êtes-vous sûr de vouloir supprimer \"$taskTitle\" ?';
  }

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get resetButton => 'Réinitialiser';

  @override
  String get appearanceSection => 'Apparence';

  @override
  String get notificationsSection => 'Notifications';

  @override
  String get pomodoroSection => 'Minuteur Pomodoro';

  @override
  String get dataBackupSection => 'Données et Sauvegarde';

  @override
  String get privacyAnalyticsSection => 'Confidentialité et Analyses';

  @override
  String get regionalSection => 'Régional';

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
  String get completedTasks => 'Tâches terminées';

  @override
  String get work => 'Travail';

  @override
  String get shortBreak => 'Pause Courte';

  @override
  String get longBreak => 'Pause Longue';

  @override
  String get paused => 'En Pause';

  @override
  String get idle => 'Inactif';

  @override
  String get pomodoroSessionCompleted => 'Session Pomodoro Terminée';

  @override
  String get highPriorityLabel => 'Élevée';

  @override
  String get mediumPriorityLabel => 'Moyenne';

  @override
  String get lowPriorityLabel => 'Faible';

  @override
  String get addTaskTitle => 'Ajouter une Nouvelle Tâche';

  @override
  String get priorityLabel => 'Priorité :';

  @override
  String get dueDateLabel => 'Due Date (Optional)';

  @override
  String get selectDueDate => 'Select due date';

  @override
  String get categoryLabel => 'Category (Optional)';

  @override
  String get noCategory => 'Aucune Catégorie';

  @override
  String get repeatSettings => 'Paramètres de Répétition';

  @override
  String get nameRequired => 'Le nom est requis';

  @override
  String get editTaskTitle => 'Modifier la Tâche';

  @override
  String get updateButton => 'Mettre à Jour';

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
    return '$count tâches';
  }

  @override
  String get selectButton => 'Sélectionner';

  @override
  String get pause => 'Pause';

  @override
  String get start => 'Démarrer';

  @override
  String get stop => 'Arrêter';

  @override
  String get skip => 'Ignorer';

  @override
  String get next => 'Suivant';

  @override
  String get statistics => 'Statistiques';

  @override
  String get overview => 'Aperçu';

  @override
  String get week => 'Semaine';

  @override
  String get month => 'Mois';

  @override
  String get streak => 'Série';

  @override
  String get productivityScore => 'Score de Productivité';

  @override
  String get weeklyProgress => 'Progrès Hebdomadaire';

  @override
  String get categoryProgress => 'Progrès de Catégorie';

  @override
  String get totaltasks => 'Tâches Totales';

  @override
  String get dueDate => 'Date d\'Échéance';

  @override
  String get overdue => 'En Retard';

  @override
  String get dueThisWeek => 'Dû Cette Semaine';

  @override
  String get logMood => 'Enregistrer Votre Humeur';

  @override
  String get notesOptional => 'Notes (optionnel)';

  @override
  String get energyLevel => 'Niveau d\'Énergie';

  @override
  String get focusLevel => 'Niveau de Concentration';

  @override
  String get stressLevel => 'Niveau de Stress';

  @override
  String get saveMood => 'Sauvegarder l\'Humeur';

  @override
  String get veryBad => 'Très Mauvais';

  @override
  String get bad => 'Mauvais';

  @override
  String get neutral => 'Neutre';

  @override
  String get good => 'Bon';

  @override
  String get veryGood => 'Très Bon';

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
  String get noCategoriesYetDescription => 'Créez des catégories pour organiser vos tâches';

  @override
  String get editButton => 'Modifier';

  @override
  String get deleteButton => 'Supprimer';

  @override
  String get addButton => 'Ajouter';

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
  String get taskCompleted => 'Tâche terminée !';

  @override
  String get taskDeleted => 'Tâche supprimée';

  @override
  String get categoryCreated => 'Catégorie créée';

  @override
  String get categoryDeleted => 'Catégorie supprimée';

  @override
  String get pomodoroStarted => 'Session Pomodoro démarrée';

  @override
  String get pomodoroCompleted => 'Session Pomodoro terminée';

  @override
  String get breakTime => 'Temps de pause !';

  @override
  String get workTime => 'Temps de travail !';

  @override
  String get sessionComplete => 'Session terminée';

  @override
  String get allSessionsComplete => 'Toutes les sessions terminées';

  @override
  String get progressSaved => 'Progrès enregistré';

  @override
  String get settingsSaved => 'Paramètres enregistrés';

  @override
  String get dataExported => 'Données exportées avec succès';

  @override
  String get dataImported => 'Données importées avec succès';

  @override
  String get backupCreated => 'Sauvegarde créée';

  @override
  String get backupRestored => 'Sauvegarde restaurée';

  @override
  String get notificationEnabled => 'Notifications activées';

  @override
  String get notificationDisabled => 'Notifications désactivées';

  @override
  String get soundEnabled => 'Son activé';

  @override
  String get soundDisabled => 'Son désactivé';

  @override
  String get vibrationEnabled => 'Vibration activée';

  @override
  String get vibrationDisabled => 'Vibration désactivée';

  @override
  String get highContrastEnabled => 'Contraste élevé activé';

  @override
  String get highContrastDisabled => 'Contraste élevé désactivé';

  @override
  String get largeTextEnabled => 'Texte large activé';

  @override
  String get largeTextDisabled => 'Texte large désactivé';

  @override
  String get screenReaderEnabled => 'Lecteur d\'écran activé';

  @override
  String get screenReaderDisabled => 'Lecteur d\'écran désactivé';

  @override
  String get autoBackupEnabled => 'Sauvegarde automatique activée';

  @override
  String get autoBackupDisabled => 'Sauvegarde automatique désactivée';

  @override
  String get analyticsEnabled => 'Analyses activées';

  @override
  String get analyticsDisabled => 'Analyses désactivées';

  @override
  String get crashReportingEnabled => 'Rapports de plantage activés';

  @override
  String get crashReportingDisabled => 'Rapports de plantage désactivés';

  @override
  String get allCategories => 'Toutes les catégories';

  @override
  String get tapToAddFirstTask => 'Appuyez sur le bouton + pour ajouter votre première tâche';

  @override
  String get deleteTaskTitle => 'Supprimer la Tâche';

  @override
  String get filterTasksTitle => 'Filtrer les Tâches';

  @override
  String get allLabel => 'Toutes';

  @override
  String get incompleteLabel => 'Incomplète';

  @override
  String get completedLabel => 'Terminée';

  @override
  String get applyButton => 'Appliquer';

  @override
  String get clearAllButton => 'Tout Effacer';

  @override
  String get profileScreenTitle => 'Profil';

  @override
  String get nameLabel => 'Nom';

  @override
  String get birthdayLabel => 'Anniversaire';

  @override
  String get selectBirthday => 'Sélectionner l\'anniversaire';

  @override
  String get profileSaved => 'Profil enregistré avec succès';

  @override
  String get pleaseFixErrors => 'Veuillez corriger les erreurs ci-dessus';

  @override
  String get splashAppName => 'Application de Liste de Tâches';

  @override
  String get splashTagline => 'Votre Gestionnaire de Tâches Personnel';

  @override
  String get splashBranding => 'Restez Organisé, Restez Productif';

  @override
  String get splashVersion => 'Version 1.0.0';

  @override
  String get loginSubtitle => 'Organisez vos tâches et boostez votre productivité';

  @override
  String get signInWithGoogle => 'Se connecter avec Google';

  @override
  String get termsAndPrivacy => 'En vous connectant, vous acceptez nos Conditions d\'utilisation et notre Politique de confidentialité';

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
  String get noTasksFound => 'Aucune tâche trouvée';

  @override
  String get searchHint => 'Rechercher des tâches...';

  @override
  String get deleteTaskConfirmationTitle => 'Delete Task';

  @override
  String get deleteSubtask => 'Delete Subtask';

  @override
  String get confirmDeleteSubtask => 'Are you sure you want to delete this subtask?';

  @override
  String get highPriority => 'High';

  @override
  String get mediumPriority => 'Medium';

  @override
  String get lowPriority => 'Low';

  @override
  String get addSubtask => 'Add Subtask';

  @override
  String get recurringTasksManager => 'Gestionnaire de Tâches Récurrentes';

  @override
  String get generateRecurringInstances => 'Générer des Instances Récurrentes';

  @override
  String get recurringInstancesGenerated => 'Instances récurrentes générées avec succès !';

  @override
  String get errorGeneratingInstances => 'Erreur lors de la génération d\'instances récurrentes';

  @override
  String get duplicateTask => 'Dupliquer la Tâche';

  @override
  String get allRecurringUpToDate => 'Toutes les tâches récurrentes sont à jour !';

  @override
  String get generateNextInstance => 'Générer l\'Instance Suivante';

  @override
  String get generateAllInstances => 'Générer Toutes les Instances';

  @override
  String get activeRecurringTasks => 'Tâches Récurrentes Actives';

  @override
  String get totalRecurringInstances => 'Total des Instances Récurrentes';

  @override
  String get tasksNeedingInstances => 'Tâches Nécessitant de Nouvelles Instances';

  @override
  String get refreshRecurringTasks => 'Actualiser les Tâches Récurrentes';

  @override
  String get subtaskTitle => 'Titre de la Sous-tâche';

  @override
  String get subtaskDescription => 'Description (optionnel)';

  @override
  String get pleaseEnterSubtaskTitle => 'Veuillez saisir un titre de sous-tâche';

  @override
  String get customizePomodoroSession => 'Personnaliser la Session Pomodoro';

  @override
  String get workDurationLabel => 'Durée de Travail';

  @override
  String get shortBreakLabel => 'Pause Courte';

  @override
  String get longBreakLabel => 'Pause Longue';

  @override
  String get startSession => 'Démarrer la Session';

  @override
  String get pomodoroFocus => 'Focus Pomodoro';

  @override
  String get pomodoroDescription => 'Choisissez une tâche sur laquelle vous concentrer et personnalisez votre session';

  @override
  String get sessionProgress => 'Progrès de la Session';

  @override
  String get settingsButton => 'Paramètres';

  @override
  String get tomorrow => 'Demain';

  @override
  String get yesterday => 'Hier';

  @override
  String get overdueTasks => 'Tâches en retard - nécessitent une attention immédiate';

  @override
  String get todayTasks => 'Tâches à accomplir aujourd\'hui';

  @override
  String get tomorrowTasks => 'Tâches de demain';

  @override
  String get thisWeekTasks => 'Tâches de cette semaine';

  @override
  String get laterTasks => 'Tâches ultérieures';

  @override
  String get noDateTasks => 'Tâches sans date spécifique';

  @override
  String get receiveNotificationsForTasksAndReminders => 'Recevoir des notifications pour les tâches et les rappels';

  @override
  String get playSoundForNotifications => 'Jouer un son pour les notifications';

  @override
  String get vibrateForNotifications => 'Vibrer pour les notifications';

  @override
  String get noUpcomingTasksWithReminders => 'Aucune tâche à venir avec des rappels';

  @override
  String get noOverdueTasks => 'Aucune tâche en retard';

  @override
  String get testNotification => 'Notification de Test';

  @override
  String get quickActions => 'Actions Rapides';

  @override
  String reminderCancelledFor(String taskTitle) {
    return 'Rappel annulé pour : $taskTitle';
  }

  @override
  String get testNotificationSent => 'Notification de test envoyée !';

  @override
  String reminder(String date) {
    return 'Rappel : $date';
  }

  @override
  String get noReminderSet => 'Aucun rappel défini';

  @override
  String get allNotificationsCleared => 'Toutes les notifications effacées !';

  @override
  String get testReminderIn10Seconds => 'Test Reminder in 10s';

  @override
  String get testReminderScheduled => 'Test reminder scheduled for 10 seconds from now';

  @override
  String get upcoming => 'À venir';

  @override
  String get appUpdates => 'Mises à Jour de l\'App';

  @override
  String get checkForUpdates => 'Rechercher des Mises à Jour';

  @override
  String get currentVersion => 'Version Actuelle';

  @override
  String get latestVersion => 'Dernière Version';

  @override
  String get updateAvailable => 'Mise à Jour Disponible';

  @override
  String get updateDownloaded => 'Mise à Jour Téléchargée';

  @override
  String get installUpdate => 'Installer la Mise à Jour';

  @override
  String get downloadingUpdate => 'Téléchargement de la Mise à Jour...';

  @override
  String get installingUpdate => 'Installation de la Mise à Jour...';

  @override
  String get noUpdatesAvailable => 'Aucune Mise à Jour Disponible';

  @override
  String get updateError => 'Erreur de Mise à Jour';

  @override
  String get retry => 'Réessayer';

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
  String get statusLabel => 'Statut :';
}
