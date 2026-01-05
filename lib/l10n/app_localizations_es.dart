// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Aplicación de Lista de Tareas';

  @override
  String get homeScreenTitle => 'Inicio';

  @override
  String get settingsScreenTitle => 'Configuración';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get themeLabel => 'Tema';

  @override
  String get darkTheme => 'Oscuro';

  @override
  String get lightTheme => 'Claro';

  @override
  String get systemTheme => 'Sistema';

  @override
  String get saveButton => 'Guardar';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get taskTitleLabel => 'Título de la Tarea';

  @override
  String get taskDescriptionLabel => 'Description (Optional)';

  @override
  String get addTaskButton => 'Agregar Tarea';

  @override
  String get editTaskButton => 'Editar Tarea';

  @override
  String get deleteTaskButton => 'Eliminar Tarea';

  @override
  String confirmDeleteTask(String taskTitle) {
    return '¿Estás seguro de que quieres eliminar \"$taskTitle\"?';
  }

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get resetButton => 'Restablecer';

  @override
  String get appearanceSection => 'Apariencia';

  @override
  String get notificationsSection => 'Notificaciones';

  @override
  String get notificationHistory => 'Notification History';

  @override
  String get notificationPreferences => 'Notification Preferences';

  @override
  String get pomodoroSection => 'Temporizador Pomodoro';

  @override
  String get dataBackupSection => 'Datos y Copia de Seguridad';

  @override
  String get privacyAnalyticsSection => 'Privacidad y Análisis';

  @override
  String get regionalSection => 'Regional';

  @override
  String get moodSettingsTitle => 'Configuración de Estado de Ánimo';

  @override
  String get moodSettingsSubtitle => 'Configurar notificaciones de check-in de estado de ánimo';

  @override
  String get enableMoodNotifications => 'Habilitar notificaciones de estado de ánimo';

  @override
  String get moodCheckInTimes => 'Tiempos de Check-in';

  @override
  String get add => 'Agregar';

  @override
  String get suggestTimes => 'Sugerir tiempos';

  @override
  String get completedTasks => 'Tareas completadas';

  @override
  String get work => 'Trabajo';

  @override
  String get shortBreak => 'Descanso Corto';

  @override
  String get longBreak => 'Descanso Largo';

  @override
  String get paused => 'Pausado';

  @override
  String get idle => 'Inactivo';

  @override
  String get pomodoroSessionCompleted => 'Sesión Pomodoro Completada';

  @override
  String get highPriorityLabel => 'Alta';

  @override
  String get mediumPriorityLabel => 'Media';

  @override
  String get lowPriorityLabel => 'Baja';

  @override
  String get addTaskTitle => 'Agregar Nueva Tarea';

  @override
  String get priorityLabel => 'Prioridad:';

  @override
  String get dueDateLabel => 'Due Date (Optional)';

  @override
  String get selectDueDate => 'Select due date';

  @override
  String get categoryLabel => 'Category (Optional)';

  @override
  String get noCategory => 'Sin Categoría';

  @override
  String get repeatSettings => 'Configuración de Repetición';

  @override
  String get nameRequired => 'El nombre es obligatorio';

  @override
  String get editTaskTitle => 'Editar Tarea';

  @override
  String get updateButton => 'Actualizar';

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
    return '$count tareas';
  }

  @override
  String get selectButton => 'Seleccionar';

  @override
  String get pause => 'Pausar';

  @override
  String get start => 'Iniciar';

  @override
  String get stop => 'Detener';

  @override
  String get skip => 'Omitir';

  @override
  String get next => 'Siguiente';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get overview => 'Resumen';

  @override
  String get week => 'Semana';

  @override
  String get month => 'Mes';

  @override
  String get streak => 'Racha';

  @override
  String get productivityScore => 'Puntuación de Productividad';

  @override
  String get weeklyProgress => 'Progreso Semanal';

  @override
  String get categoryProgress => 'Progreso de Categoría';

  @override
  String get totaltasks => 'Tareas Totales';

  @override
  String get dueDate => 'Fecha de Vencimiento';

  @override
  String get overdue => 'Vencido';

  @override
  String get dueThisWeek => 'Vencido Esta Semana';

  @override
  String get logMood => 'Registra Tu Estado de Ánimo';

  @override
  String get notesOptional => 'Notas (opcional)';

  @override
  String get energyLevel => 'Nivel de Energía';

  @override
  String get focusLevel => 'Nivel de Enfoque';

  @override
  String get stressLevel => 'Nivel de Estrés';

  @override
  String get saveMood => 'Guardar Estado de Ánimo';

  @override
  String get veryBad => 'Muy Malo';

  @override
  String get bad => 'Malo';

  @override
  String get neutral => 'Neutral';

  @override
  String get good => 'Bueno';

  @override
  String get veryGood => 'Muy Bueno';

  @override
  String get moodCheckInTitle => 'Check-in de Estado de Ánimo';

  @override
  String get moodHowAreYouFeeling => '¿Cómo te sientes hoy?';

  @override
  String get moodSelectLevel => 'Selecciona tu nivel de estado de ánimo';

  @override
  String get moodEnergyLevel => 'Nivel de Energía';

  @override
  String get moodFocusLevel => 'Nivel de Enfoque';

  @override
  String get moodStressLevel => 'Nivel de Estrés';

  @override
  String get low => 'Bajo';

  @override
  String get high => 'Alto';

  @override
  String get moodNoteOptional => 'Nota (opcional)';

  @override
  String get moodNoteHint => '¿Cómo te sientes?';

  @override
  String get moodSaveButton => 'Guardar Estado de Ánimo';

  @override
  String get moodVeryBad => 'Muy Malo';

  @override
  String get moodBad => 'Malo';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodGood => 'Bueno';

  @override
  String get moodVeryGood => 'Muy Bueno';

  @override
  String get moodSavedSuccess => '¡Estado de ánimo guardado exitosamente!';

  @override
  String get moodSaveFailed => 'Error al guardar estado de ánimo';

  @override
  String get save => 'Guardar';

  @override
  String get noCategoriesYetDescription => 'Crea categorías para organizar tus tareas';

  @override
  String get editButton => 'Editar';

  @override
  String get deleteButton => 'Eliminar';

  @override
  String get addButton => 'Agregar';

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
  String get somethingWentWrong => 'Algo salió mal';

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
  String get taskCompleted => '¡Tarea completada! 🎉';

  @override
  String get taskDeleted => 'Tarea eliminada';

  @override
  String get categoryCreated => 'Categoría creada';

  @override
  String get categoryDeleted => 'Categoría eliminada';

  @override
  String get pomodoroStarted => 'Sesión Pomodoro iniciada';

  @override
  String get pomodoroCompleted => 'Sesión Pomodoro completada';

  @override
  String get breakTime => '¡Tiempo de descanso!';

  @override
  String get workTime => '¡Tiempo de trabajo!';

  @override
  String get sessionComplete => 'Sesión completa';

  @override
  String get allSessionsComplete => 'Todas las sesiones completas';

  @override
  String get progressSaved => 'Progreso guardado';

  @override
  String get settingsSaved => 'Configuración guardada';

  @override
  String get dataExported => 'Datos exportados exitosamente';

  @override
  String get dataImported => 'Datos importados exitosamente';

  @override
  String get backupCreated => 'Copia de seguridad creada';

  @override
  String get backupRestored => 'Copia de seguridad restaurada';

  @override
  String get notificationEnabled => 'Notificaciones habilitadas';

  @override
  String get notificationDisabled => 'Notificaciones deshabilitadas';

  @override
  String get soundEnabled => 'Sonido habilitado';

  @override
  String get soundDisabled => 'Sonido deshabilitado';

  @override
  String get vibrationEnabled => 'Vibración habilitada';

  @override
  String get vibrationDisabled => 'Vibración deshabilitada';

  @override
  String get highContrastEnabled => 'Alto contraste habilitado';

  @override
  String get highContrastDisabled => 'Alto contraste deshabilitado';

  @override
  String get largeTextEnabled => 'Texto grande habilitado';

  @override
  String get largeTextDisabled => 'Texto grande deshabilitado';

  @override
  String get screenReaderEnabled => 'Lector de pantalla habilitado';

  @override
  String get screenReaderDisabled => 'Lector de pantalla deshabilitado';

  @override
  String get autoBackupEnabled => 'Copia de seguridad automática habilitada';

  @override
  String get autoBackupDisabled => 'Copia de seguridad automática deshabilitada';

  @override
  String get analyticsEnabled => 'Análisis habilitados';

  @override
  String get analyticsDisabled => 'Análisis deshabilitados';

  @override
  String get crashReportingEnabled => 'Reportes de fallos habilitados';

  @override
  String get crashReportingDisabled => 'Reportes de fallos deshabilitados';

  @override
  String get allCategories => 'Todas las categorías';

  @override
  String get tapToAddFirstTask => 'Toca el botón + para agregar tu primera tarea';

  @override
  String get deleteTaskTitle => 'Eliminar Tarea';

  @override
  String get filterTasksTitle => 'Filtrar Tareas';

  @override
  String get allLabel => 'Todas';

  @override
  String get incompleteLabel => 'Incompleta';

  @override
  String get completedLabel => 'Completada';

  @override
  String get applyButton => 'Aplicar';

  @override
  String get clearAllButton => 'Limpiar Todo';

  @override
  String get profileScreenTitle => 'Perfil';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get birthdayLabel => 'Cumpleaños';

  @override
  String get selectBirthday => 'Seleccionar cumpleaños';

  @override
  String get profileSaved => 'Perfil guardado exitosamente';

  @override
  String get pleaseFixErrors => 'Por favor arregla los errores arriba';

  @override
  String get splashAppName => 'Aplicación de Lista de Tareas';

  @override
  String get splashTagline => 'Tu Administrador Personal de Tareas';

  @override
  String get splashBranding => 'Mantente Organizado, Mantente Productivo';

  @override
  String get splashVersion => 'Versión 1.0.0';

  @override
  String get loginSubtitle => 'Organiza tus tareas y aumenta tu productividad';

  @override
  String get signInWithGoogle => 'Iniciar sesión con Google';

  @override
  String get signInWithApple => 'Iniciar sesión con Apple';

  @override
  String get termsAndPrivacy => 'Al iniciar sesión, aceptas nuestros Términos de Servicio y Política de Privacidad';

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
  String get mostCommonMood => 'Estado de Ánimo Más Común';

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
  String get noTasksFound => 'No se encontraron tareas';

  @override
  String get searchHint => 'Buscar tareas...';

  @override
  String get deleteTaskConfirmationTitle => 'Eliminar Tarea';

  @override
  String get deleteSubtask => 'Eliminar Subtarea';

  @override
  String get confirmDeleteSubtask => '¿Estás seguro de eliminar esta subtarea?';

  @override
  String get collapse => 'Colapsar';

  @override
  String get expand => 'Expandir';

  @override
  String get copySuffix => '(Copia)';

  @override
  String get highPriority => 'Alta';

  @override
  String get mediumPriority => 'Media';

  @override
  String get lowPriority => 'Baja';

  @override
  String get addSubtask => 'Agregar Subtarea';

  @override
  String get recurringTasksManager => 'Administrador de Tareas Recurrentes';

  @override
  String get generateRecurringInstances => 'Generar Instancias Recurrentes';

  @override
  String get recurringInstancesGenerated => '¡Instancias recurrentes generadas exitosamente!';

  @override
  String get errorGeneratingInstances => 'Error al generar instancias recurrentes';

  @override
  String get duplicateTask => 'Duplicar Tarea';

  @override
  String get allRecurringUpToDate => 'Todas las tareas recurrentes están actualizadas';

  @override
  String get generateNextInstance => 'Generar Siguiente Instancia';

  @override
  String get generateAllInstances => 'Generar Todas las Instancias';

  @override
  String get activeRecurringTasks => 'Tareas Recurrentes Activas';

  @override
  String get totalRecurringInstances => 'Total de Instancias Recurrentes';

  @override
  String get tasksNeedingInstances => 'Tareas que Necesitan Instancias';

  @override
  String get refreshRecurringTasks => 'Actualizar Tareas Recurrentes';

  @override
  String get subtaskTitle => 'Título de Subtarea';

  @override
  String get subtaskDescription => 'Descripción (opcional)';

  @override
  String get pleaseEnterSubtaskTitle => 'Por favor ingresa un título de subtarea';

  @override
  String get customizePomodoroSession => 'Personalizar Sesión Pomodoro';

  @override
  String get workDurationLabel => 'Duración del Trabajo';

  @override
  String get shortBreakLabel => 'Descanso Corto';

  @override
  String get longBreakLabel => 'Descanso Largo';

  @override
  String get startSession => 'Iniciar Sesión';

  @override
  String get pomodoroFocus => 'Enfoque Pomodoro';

  @override
  String get pomodoroDescription => 'Elige una tarea en la que enfocarte y personaliza tu sesión';

  @override
  String get sessionProgress => 'Progreso de la Sesión';

  @override
  String get settingsButton => 'Configuración';

  @override
  String get tomorrow => 'Mañana';

  @override
  String get yesterday => 'Ayer';

  @override
  String get overdueTasks => 'Tareas vencidas - requieren atención inmediata';

  @override
  String get todayTasks => 'Tareas para completar hoy';

  @override
  String get tomorrowTasks => 'Tareas de mañana';

  @override
  String get thisWeekTasks => 'Tareas de esta semana';

  @override
  String get laterTasks => 'Tareas posteriores';

  @override
  String get noDateTasks => 'Tareas sin fecha específica';

  @override
  String get receiveNotificationsForTasksAndReminders => 'Recibir notificaciones para tareas y recordatorios';

  @override
  String get playSoundForNotifications => 'Reproducir sonido para notificaciones';

  @override
  String get vibrateForNotifications => 'Vibrar para notificaciones';

  @override
  String get noUpcomingTasksWithReminders => 'No hay tareas próximas con recordatorios';

  @override
  String get noOverdueTasks => 'No hay tareas vencidas';

  @override
  String get testNotification => 'Notificación de Prueba';

  @override
  String get quickActions => 'Acciones Rápidas';

  @override
  String reminderCancelledFor(String taskTitle) {
    return 'Recordatorio cancelado para: $taskTitle';
  }

  @override
  String get testNotificationSent => '¡Notificación de prueba enviada!';

  @override
  String reminder(String date) {
    return 'Recordatorio: $date';
  }

  @override
  String get noReminderSet => 'No se ha establecido recordatorio';

  @override
  String get allNotificationsCleared => '¡Todas las notificaciones limpiadas!';

  @override
  String get checkPendingNotifications => 'Ver Pendientes';

  @override
  String get cancelAllNotifications => 'Cancelar Todo';

  @override
  String get allNotificationsCancelled => '¡Todas las notificaciones canceladas!';

  @override
  String get moodCheckInNotificationTitle => 'Check-in de Estado de Ánimo';

  @override
  String get moodCheckInNotificationBody => '¿Cómo te sientes ahora? Toca para registrar tu estado de ánimo.';

  @override
  String get testMoodNotificationTitle => 'Notificación de Prueba de Estado de Ánimo';

  @override
  String get testMoodNotificationBody => 'Esta es una notificación de prueba para check-in de estado de ánimo.';

  @override
  String get testReminderIn10Seconds => 'Prueba de Recordatorio en 10s';

  @override
  String get testReminderScheduled => 'Recordatorio de prueba programado para 10 segundos desde ahora';

  @override
  String get upcoming => 'Próximas';

  @override
  String get appUpdates => 'Actualizaciones de la App';

  @override
  String get checkForUpdates => 'Buscar Actualizaciones';

  @override
  String get currentVersion => 'Versión Actual';

  @override
  String get latestVersion => 'Última Versión';

  @override
  String get updateAvailable => 'Actualización Disponible';

  @override
  String get updateDownloaded => 'Actualización Descargada';

  @override
  String get installUpdate => 'Instalar Actualización';

  @override
  String get downloadingUpdate => 'Descargando Actualización...';

  @override
  String get installingUpdate => 'Instalando Actualización...';

  @override
  String get noUpdatesAvailable => 'No Hay Actualizaciones Disponibles';

  @override
  String get updateError => 'Error de Actualización';

  @override
  String get retry => 'Reintentar';

  @override
  String version(String version) {
    return 'Versión $version';
  }

  @override
  String get updatePersonalInfo => 'Actualizar Información Personal';

  @override
  String get sunday => 'Domingo';

  @override
  String get monday => 'Lunes';

  @override
  String get tuesday => 'Martes';

  @override
  String get wednesday => 'Miércoles';

  @override
  String get thursday => 'Jueves';

  @override
  String get friday => 'Viernes';

  @override
  String get saturday => 'Sábado';

  @override
  String get focusMode => 'Modo de Enfoque';

  @override
  String get motivationalQuoteHigh => '¡Lo tienes! 🚀';

  @override
  String get motivationalQuoteMedium => '¡Continúa! 💪';

  @override
  String get motivationalQuoteLow => '¡Tómalo con calma! 😊';

  @override
  String get taskDetails => 'Detalles de la Tarea';

  @override
  String get noDueDate => 'Sin fecha de vencimiento';

  @override
  String get priority => 'Prioridad';

  @override
  String get reminders => 'Recordatorios';

  @override
  String get repeat => 'Repetir';

  @override
  String get noSubtasks => 'Sin subtareas aún';

  @override
  String get subtasks => 'Subtareas';

  @override
  String get sessions => 'Sesiones';

  @override
  String get timeSpent => 'Tiempo Gastado';

  @override
  String get avgSession => 'Sesión Promedio';

  @override
  String get pomodoroSessions => 'Sesiones Pomodoro';

  @override
  String get startPomodoroSession => 'Iniciar Sesión Pomodoro';

  @override
  String get timeline => 'Cronograma';

  @override
  String get created => 'Creado';

  @override
  String get lastModified => 'Última Modificación';

  @override
  String get taskProgress => 'Progreso';

  @override
  String get statusLabel => 'Estado:';

  @override
  String get setReminderButton => 'Establecer Recordatorio';

  @override
  String get uncompleteTaskButton => 'Descompletar Tarea';

  @override
  String get completeTaskButton => 'Completar Tarea';

  @override
  String get completeSubtasksFirst => 'Completa las Subtareas Primero';

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
  String get moodInsightsSubtitle => 'Sigue tus patrones emocionales y obtén información';

  @override
  String get yourMoodJourney => 'Tu Viaje Emocional';

  @override
  String get aIPoweredAnalysis => 'Análisis Impulsado por IA';

  @override
  String get thisWeek => 'Esta Semana';

  @override
  String get goodDays => 'Buenos Días';

  @override
  String get neutralDays => 'Días Neutrales';

  @override
  String get challengingDays => 'Días Desafiantes';

  @override
  String get dominantMood => 'Estado de Ánimo Dominante';

  @override
  String get hiThere => '¡Hola!';

  @override
  String get howIsYourDay => '¿Cómo va tu día?';

  @override
  String get imHereForYou => '¡Estoy aquí para ti!';

  @override
  String get itsOkayToHaveToughDays => 'Está bien tener días difíciles';

  @override
  String get sendingYouStrength => 'Te envío fuerza';

  @override
  String get everyDayIsANewOpportunity => 'Cada día es una nueva oportunidad';

  @override
  String get findingBalance => 'Encontrar equilibrio';

  @override
  String get sometimesNeutralIsExactlyWhereWeNeedToBe => 'A veces neutral es exactamente donde necesitamos estar';

  @override
  String get youreDoingGreat => '¡Lo estás haciendo genial!';

  @override
  String get keepShiningBright => '¡Sigue brillando con fuerza!';

  @override
  String get absolutelyAmazing => '¡Absolutamente increíble!';

  @override
  String get yourJoyIsContagious => '¡Tu alegría es contagiosa!';

  @override
  String get moodIntensity => 'Intensidad del Estado de Ánimo';

  @override
  String get smartView => 'Inteligente';

  @override
  String get timelineView => 'Línea de Tiempo';

  @override
  String get patternsView => 'Patrones';

  @override
  String get goodIntensity => 'Intensidad Buena';

  @override
  String get veryGoodIntensity => 'Intensidad Muy Buena';

  @override
  String get noMoodRecorded => 'No hay estado de ánimo registrado';

  @override
  String get goodMorning => '¡Buenos días!';

  @override
  String get howAreYouFeelingToday => '¿Cómo te sientes hoy?';

  @override
  String get todayYoureFeeling => 'Hoy te sientes';

  @override
  String get addAnother => 'Agregar Otro';

  @override
  String get earlierToday => 'Antes hoy';

  @override
  String get struggling => 'Luchando';

  @override
  String get down => 'Abatido';

  @override
  String get wantToShareMoreDetails => '¿Quieres compartir más detalles?';

  @override
  String get guidedCheckIn => 'Check-in Guiado';

  @override
  String get detailedEntry => 'Entrada Detallada';

  @override
  String get quickInsights => 'Perspectivas Rápidas';

  @override
  String get recentMoods => 'Estados de Ánimo Recientes';

  @override
  String get noInsightsYet => 'Sin perspectivas aún';

  @override
  String get trackYourMoodForAWeek => 'Registra tu estado de ánimo durante una semana para ver perspectivas';

  @override
  String get daysStreak => 'días seguidos';

  @override
  String get moodBuddyFeelingSad => '¿Te sientes triste?';

  @override
  String get moodBuddyTipSad => 'Prueba un paseo suave o escucha música relajante';

  @override
  String get moodBuddyFeelingDown => '¿Te sientes abatido?';

  @override
  String get moodBuddyTipDown => 'Contacta a un amigo o practica respiración profunda';

  @override
  String get moodBuddyFeelingOkay => '¿Te sientes bien?';

  @override
  String get moodBuddyTipOkay => 'Mantén el equilibrio con ejercicio ligero o pasatiempos';

  @override
  String get moodBuddyFeelingGood => '¿Te sientes bien?';

  @override
  String get moodBuddyTipGood => 'Comparte tu positividad y ayuda a otros';

  @override
  String get moodBuddyFeelingGreat => '¿Te sientes genial?';

  @override
  String get moodBuddyTipGreat => 'Canaliza esta energía en proyectos creativos';

  @override
  String get moodPatternsTitle => 'Tus Patrones Emocionales';

  @override
  String get moodPatternsSubtitle => 'Descubre tendencias en tu bienestar emocional';

  @override
  String get moodSuggestionsTitle => 'Sugerencias Personalizadas';

  @override
  String get moodSuggestionsSubtitle => 'Recomendaciones impulsadas por IA basadas en tu estado de ánimo';

  @override
  String get veryBadIntensity => 'Intensidad Muy Mala';

  @override
  String get badIntensity => 'Intensidad Mala';

  @override
  String get neutralIntensity => 'Intensidad Neutral';

  @override
  String get insightGenerallyPositive => 'Generalmente positivo 😊';

  @override
  String get insightNeedsSupport => 'Necesita apoyo 🤗';

  @override
  String get insightGreatConsistency => '¡Gran consistencia! 🔥';

  @override
  String get insightMissingToday => 'Falta hoy 📝';

  @override
  String get pleaseTryAgainLater => 'Por favor inténtalo de nuevo más tarde';

  @override
  String get icon => 'Icono';

  @override
  String get categories => 'Categorías';

  @override
  String get searchCategories => 'Buscar categorías...';

  @override
  String get keyInsights => 'Perspectivas Clave';

  @override
  String get patternAnalysis => 'Análisis de Patrones';

  @override
  String get aiPredictions => 'Predicciones IA';

  @override
  String get positiveTrend => 'Tendencia Positiva';

  @override
  String get yourOverallMoodIsGenerallyPositive => 'Tu estado de ánimo general es generalmente positivo';

  @override
  String get supportNeeded => 'Apoyo Necesario';

  @override
  String get youMightBenefitFromAdditionalSupport => 'Podrías beneficiarte de apoyo adicional';

  @override
  String get greatConsistency => 'Gran Consistencia';

  @override
  String youveBeenTrackingYourMoodForDays(Object days) {
    return 'Has estado registrando tu estado de ánimo durante $days días';
  }

  @override
  String get missingToday => 'Falta Hoy';

  @override
  String get youHaventLoggedYourMoodTodayYet => 'Aún no has registrado tu estado de ánimo hoy';

  @override
  String get recentImprovement => 'Mejora Reciente';

  @override
  String get yourMoodHasBeenImprovingLately => 'Tu estado de ánimo ha estado mejorando últimamente';

  @override
  String get challengingPeriod => 'Período Desafiante';

  @override
  String get recentEntriesSuggestAChallengingTime => 'Las entradas recientes sugieren un momento desafiante';

  @override
  String get moreDataNeeded => 'Más Datos Necesarios';

  @override
  String get trackYourMoodForAWeekToGetAIPredictions => 'Registra tu estado de ánimo durante una semana para obtener predicciones IA';

  @override
  String get positiveOutlook => 'Perspectiva Positiva';

  @override
  String get basedOnRecentPatternsTomorrowLooksPromising => 'Basado en patrones recientes, mañana se ve prometedor';

  @override
  String get selfCareRecommended => 'Autocuidado Recomendado';

  @override
  String get considerPrioritizingSelfCareActivitiesTomorrow => 'Considera priorizar actividades de autocuidado mañana';

  @override
  String get balancedDayAhead => 'Día Equilibrado por Delante';

  @override
  String get tomorrowShouldBeATypicalDayForYou => 'Mañana debería ser un día típico para ti';

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
