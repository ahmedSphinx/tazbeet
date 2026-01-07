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
  String get notificationHistory => 'Notification History';

  @override
  String get notificationPreferences => 'Notification Preferences';

  @override
  String get pomodoroSection => 'Minuteur Pomodoro';

  @override
  String get dataBackupSection => 'Données et Sauvegarde';

  @override
  String get privacyAnalyticsSection => 'Confidentialité et Analyses';

  @override
  String get regionalSection => 'Régional';

  @override
  String get moodSettingsTitle => 'Paramètres d\'Humeur';

  @override
  String get moodSettingsSubtitle => 'Configurer les notifications de check-in d\'humeur';

  @override
  String get enableMoodNotifications => 'Activer les notifications d\'humeur';

  @override
  String get moodCheckInTimes => 'Heures de Check-in';

  @override
  String get add => 'Ajouter';

  @override
  String get suggestTimes => 'Suggérer des heures';

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
  String get dueDateTitle => 'Due Date';

  @override
  String dueDate(Object dueDate) {
    return 'Date d\'Échéance';
  }

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
  String get moodCheckInTitle => 'Check-in d\'Humeur';

  @override
  String get moodHowAreYouFeeling => 'Comment vous sentez-vous aujourd\'hui ?';

  @override
  String get moodSelectLevel => 'Sélectionnez votre niveau d\'humeur';

  @override
  String get moodEnergyLevel => 'Niveau d\'Énergie';

  @override
  String get moodFocusLevel => 'Niveau de Concentration';

  @override
  String get moodStressLevel => 'Niveau de Stress';

  @override
  String get low => 'Faible';

  @override
  String get high => 'Élevé';

  @override
  String get moodNoteOptional => 'Note (optionnel)';

  @override
  String get moodNoteHint => 'Comment vous sentez-vous ?';

  @override
  String get moodSaveButton => 'Sauvegarder l\'Humeur';

  @override
  String get moodVeryBad => 'Très Mauvais';

  @override
  String get moodBad => 'Mauvais';

  @override
  String get moodNeutral => 'Neutre';

  @override
  String get moodGood => 'Bon';

  @override
  String get moodVeryGood => 'Très Bon';

  @override
  String get moodSavedSuccess => 'Humeur sauvegardée avec succès !';

  @override
  String get moodSaveFailed => 'Échec de la sauvegarde de l\'humeur';

  @override
  String get save => 'Sauvegarder';

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
  String get moodHistory => 'Historique de l\'Humeur';

  @override
  String get noMoodEntriesYet => 'Aucune entrée d\'humeur encore';

  @override
  String get startLoggingMoods => 'Commencez à enregistrer vos humeurs pour voir votre historique';

  @override
  String get moodHistoryTitle => 'Historique de l\'Humeur';

  @override
  String get startTracking => 'Commencez votre voyage de suivi d\'humeur';

  @override
  String get quickMoodCheckIn => 'Check-in d\'Humeur Rapide';

  @override
  String moodsForDate(Object date) {
    return 'Humeurs pour $date';
  }

  @override
  String get close => 'Fermer';

  @override
  String get filter => 'Filtrer';

  @override
  String get all => 'Tous';

  @override
  String get positive => 'Positif';

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
  String get howAreYou => 'Comment allez-vous ?';

  @override
  String get yourMood => 'Votre humeur';

  @override
  String get howAreYouFeelingRightNow => 'Comment vous sentez-vous maintenant ?';

  @override
  String get tapOptionBestDescribesMood => 'Appuyez sur l\'option qui décrit le mieux votre humeur';

  @override
  String get addNoteOptional => 'Ajouter une note (facultatif)';

  @override
  String get whatsOnYourMind => 'Qu\'est-ce qui vous préoccupe ?';

  @override
  String get moodAdded => 'Humeur ajoutée';

  @override
  String get moodUpdated => 'Humeur mise à jour';

  @override
  String get somethingWentWrong => 'Quelque chose s\'est mal passé';

  @override
  String get reallyStruggling => 'Vraiment difficile';

  @override
  String get notGreat => 'Pas terrible';

  @override
  String get okay => 'Correct';

  @override
  String get prettyGood => 'Assez bien';

  @override
  String get great => 'Excellent';

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
  String get signInWithApple => 'Se connecter avec Apple';

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
  String get noTasksInCategory => 'No tasks in this category';

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
  String get mostCommonMood => 'Humeur la Plus Courante';

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
  String get noTasksFound => 'Aucune tâche trouvée';

  @override
  String get searchHint => 'Rechercher des tâches...';

  @override
  String get deleteTaskConfirmationTitle => 'Supprimer la Tâche';

  @override
  String get deleteSubtask => 'Supprimer la Sous-tâche';

  @override
  String get confirmDeleteSubtask => 'Êtes-vous sûr de supprimer cette sous-tâche ?';

  @override
  String get collapse => 'Réduire';

  @override
  String get expand => 'Développer';

  @override
  String get copySuffix => '(Copie)';

  @override
  String get highPriority => 'Élevée';

  @override
  String get mediumPriority => 'Moyenne';

  @override
  String get lowPriority => 'Faible';

  @override
  String get addSubtask => 'Ajouter une Sous-tâche';

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
  String get checkPendingNotifications => 'Vérifier les En Attente';

  @override
  String get cancelAllNotifications => 'Annuler Tout';

  @override
  String get allNotificationsCancelled => 'Toutes les notifications annulées !';

  @override
  String get moodCheckInNotificationTitle => 'Check-in d\'Humeur';

  @override
  String get moodCheckInNotificationBody => 'Comment vous sentez-vous maintenant ? Touchez pour enregistrer votre humeur.';

  @override
  String get testMoodNotificationTitle => 'Notification de Test d\'Humeur';

  @override
  String get testMoodNotificationBody => 'Ceci est une notification de test pour le check-in d\'humeur.';

  @override
  String get testReminderIn10Seconds => 'Test de Rappel dans 10 Secondes';

  @override
  String get testReminderScheduled => 'Rappel de test programmé pour 10 secondes à partir de maintenant';

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
  String get updatePersonalInfo => 'Mettre à Jour les Informations Personnelles';

  @override
  String get sunday => 'Dimanche';

  @override
  String get monday => 'Lundi';

  @override
  String get tuesday => 'Mardi';

  @override
  String get wednesday => 'Mercredi';

  @override
  String get thursday => 'Jeudi';

  @override
  String get friday => 'Vendredi';

  @override
  String get saturday => 'Samedi';

  @override
  String get focusMode => 'Mode Focus';

  @override
  String get motivationalQuoteHigh => 'Vous l\'avez ! 🚀';

  @override
  String get motivationalQuoteMedium => 'Continuez ! 💪';

  @override
  String get motivationalQuoteLow => 'Prenez-le doucement ! 😊';

  @override
  String get taskDetails => 'Détails de la Tâche';

  @override
  String get noDueDate => 'Aucune date d\'échéance';

  @override
  String priority(Object priority) {
    return 'Priorité';
  }

  @override
  String get reminders => 'Rappels';

  @override
  String get repeat => 'Répéter';

  @override
  String get noSubtasks => 'Aucune sous-tâche pour le moment';

  @override
  String get subtasks => 'Sous-tâches';

  @override
  String get sessions => 'Sessions';

  @override
  String get timeSpent => 'Temps Passé';

  @override
  String get avgSession => 'Session Moyenne';

  @override
  String get pomodoroSessions => 'Sessions Pomodoro';

  @override
  String get startPomodoroSession => 'Démarrer une Session Pomodoro';

  @override
  String get timeline => 'Chronologie';

  @override
  String get created => 'Créé';

  @override
  String get lastModified => 'Dernière Modification';

  @override
  String get taskProgress => 'Progrès de la Tâche';

  @override
  String get statusLabel => 'Statut :';

  @override
  String get setReminderButton => 'Définir un Rappel';

  @override
  String get uncompleteTaskButton => 'Annuler l\'Achèvement de la Tâche';

  @override
  String get completeTaskButton => 'Achever la Tâche';

  @override
  String get completeSubtasksFirst => 'Achevez les Sous-tâches D\'abord';

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
  String get moodInsightsSubtitle => 'Suivez vos schémas émotionnels et obtenez des informations';

  @override
  String get yourMoodJourney => 'Votre Voyage Émotionnel';

  @override
  String get aIPoweredAnalysis => 'Analyse Alimentée par l\'IA';

  @override
  String get thisWeek => 'Cette Semaine';

  @override
  String get goodDays => 'Bons Jours';

  @override
  String get neutralDays => 'Jours Neutres';

  @override
  String get challengingDays => 'Jours Défiant';

  @override
  String get dominantMood => 'Humeur Dominante';

  @override
  String get hiThere => 'Salut !';

  @override
  String get howIsYourDay => 'Comment va ta journée ?';

  @override
  String get imHereForYou => 'Je suis là pour toi !';

  @override
  String get itsOkayToHaveToughDays => 'C\'est normal d\'avoir des jours difficiles';

  @override
  String get sendingYouStrength => 'Je t\'envoie de la force';

  @override
  String get everyDayIsANewOpportunity => 'Chaque jour est une nouvelle opportunité';

  @override
  String get findingBalance => 'Trouver l\'équilibre';

  @override
  String get sometimesNeutralIsExactlyWhereWeNeedToBe => 'Parfois neutre est exactement là où nous devons être';

  @override
  String get youreDoingGreat => 'Tu le fais très bien !';

  @override
  String get keepShiningBright => 'Continue de briller fort !';

  @override
  String get absolutelyAmazing => 'Absolument incroyable !';

  @override
  String get yourJoyIsContagious => 'Ta joie est contagieuse !';

  @override
  String get moodIntensity => 'Intensité de l\'Humeur';

  @override
  String get smartView => 'Intelligent';

  @override
  String get timelineView => 'Chronologie';

  @override
  String get patternsView => 'Motifs';

  @override
  String get goodIntensity => 'Intensité Bonne';

  @override
  String get veryGoodIntensity => 'Intensité Très Bonne';

  @override
  String get noMoodRecorded => 'Aucune humeur enregistrée';

  @override
  String get goodMorning => 'Bonjour !';

  @override
  String get howAreYouFeelingToday => 'Comment te sens-tu aujourd\'hui ?';

  @override
  String get todayYoureFeeling => 'Aujourd\'hui tu te sens';

  @override
  String get addAnother => 'Ajouter un Autre';

  @override
  String get earlierToday => 'Plus tôt aujourd\'hui';

  @override
  String get struggling => 'Luttant';

  @override
  String get down => 'Abattu';

  @override
  String get wantToShareMoreDetails => 'Veux-tu partager plus de détails ?';

  @override
  String get guidedCheckIn => 'Check-in Guidé';

  @override
  String get detailedEntry => 'Entrée Détaillée';

  @override
  String get quickInsights => 'Aperçus Rapides';

  @override
  String get recentMoods => 'Humeurs Récentes';

  @override
  String get noInsightsYet => 'Pas encore d\'aperçus';

  @override
  String get trackYourMoodForAWeek => 'Suivez votre humeur pendant une semaine pour voir des aperçus';

  @override
  String get daysStreak => 'jours d\'affilée';

  @override
  String get moodBuddyFeelingSad => 'Tu te sens triste ?';

  @override
  String get moodBuddyTipSad => 'Essaye une marche douce ou écoute de la musique relaxante';

  @override
  String get moodBuddyFeelingDown => 'Tu te sens abattu ?';

  @override
  String get moodBuddyTipDown => 'Contacte un ami ou pratique la respiration profonde';

  @override
  String get moodBuddyFeelingOkay => 'Tu te sens bien ?';

  @override
  String get moodBuddyTipOkay => 'Maintiens l\'équilibre avec de l\'exercice léger ou des passe-temps';

  @override
  String get moodBuddyFeelingGood => 'Tu te sens bien ?';

  @override
  String get moodBuddyTipGood => 'Partage ta positivité et aide les autres';

  @override
  String get moodBuddyFeelingGreat => 'Tu te sens génial ?';

  @override
  String get moodBuddyTipGreat => 'Canalise cette énergie dans des projets créatifs';

  @override
  String get moodPatternsTitle => 'Vos Schémas Émotionnels';

  @override
  String get moodPatternsSubtitle => 'Découvrez les tendances de votre bien-être émotionnel';

  @override
  String get moodSuggestionsTitle => 'Suggestions Personnalisées';

  @override
  String get moodSuggestionsSubtitle => 'Recommandations alimentées par l\'IA basées sur votre humeur';

  @override
  String get veryBadIntensity => 'Intensité Très Mauvaise';

  @override
  String get badIntensity => 'Intensité Mauvaise';

  @override
  String get neutralIntensity => 'Intensité Neutre';

  @override
  String get insightGenerallyPositive => 'Généralement positif 😊';

  @override
  String get insightNeedsSupport => 'A besoin de soutien 🤗';

  @override
  String get insightGreatConsistency => 'Grande cohérence ! 🔥';

  @override
  String get insightMissingToday => 'Manque aujourd\'hui 📝';

  @override
  String get pleaseTryAgainLater => 'Veuillez réessayer plus tard';

  @override
  String icon(Object icon) {
    return 'Icône';
  }

  @override
  String get categories => 'Catégories';

  @override
  String get searchCategories => 'Rechercher des catégories...';

  @override
  String get keyInsights => 'Perspectives Clés';

  @override
  String get patternAnalysis => 'Analyse des Motifs';

  @override
  String get aiPredictions => 'Prédictions IA';

  @override
  String get positiveTrend => 'Tendance Positive';

  @override
  String get yourOverallMoodIsGenerallyPositive => 'Votre humeur générale est généralement positive';

  @override
  String get supportNeeded => 'Soutien Nécessaire';

  @override
  String get youMightBenefitFromAdditionalSupport => 'Pourriez bénéficier d\'un soutien supplémentaire';

  @override
  String get greatConsistency => 'Grande Cohérence';

  @override
  String youveBeenTrackingYourMoodForDays(Object days) {
    return 'Vous suivez votre humeur depuis $days jours';
  }

  @override
  String get missingToday => 'Manquant Aujourd\'hui';

  @override
  String get youHaventLoggedYourMoodTodayYet => 'Vous n\'avez pas encore enregistré votre humeur aujourd\'hui';

  @override
  String get recentImprovement => 'Amélioration Récente';

  @override
  String get yourMoodHasBeenImprovingLately => 'Votre humeur s\'est améliorée récemment';

  @override
  String get challengingPeriod => 'Période Difficile';

  @override
  String get recentEntriesSuggestAChallengingTime => 'Les entrées récentes suggèrent une période difficile';

  @override
  String get moreDataNeeded => 'Plus de Données Nécessaires';

  @override
  String get trackYourMoodForAWeekToGetAIPredictions => 'Suivez votre humeur pendant une semaine pour obtenir des prédictions IA';

  @override
  String get positiveOutlook => 'Perspective Positive';

  @override
  String get basedOnRecentPatternsTomorrowLooksPromising => 'Basé sur les motifs récents, demain looks prometteur';

  @override
  String get selfCareRecommended => 'Soin de Soi Recommandé';

  @override
  String get considerPrioritizingSelfCareActivitiesTomorrow => 'Envisagez de prioriser les activités de soin de soi demain';

  @override
  String get balancedDayAhead => 'Journée Équilibrée à Venir';

  @override
  String get tomorrowShouldBeATypicalDayForYou => 'Demain devrait être une journée typique pour vous';

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
