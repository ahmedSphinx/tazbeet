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
  String get pomodoroSection => 'Temporizador Pomodoro';

  @override
  String get dataBackupSection => 'Datos y Copia de Seguridad';

  @override
  String get privacyAnalyticsSection => 'Privacidad y Análisis';

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
  String get noTasksFound => 'No se encontraron tareas';

  @override
  String get searchHint => 'Buscar tareas...';

  @override
  String get deleteTaskConfirmationTitle => 'Delete Task';

  @override
  String get deleteSubtask => 'Eliminar Subtarea';

  @override
  String get confirmDeleteSubtask => 'Are you sure you want to delete this subtask?';

  @override
  String get highPriority => 'High';

  @override
  String get mediumPriority => 'Medium';

  @override
  String get lowPriority => 'Low';

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
  String get updatePersonalInfo => 'Update your personal information';

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
  String get subtasks => 'Subtareas';

  @override
  String get sessions => 'Sessions';

  @override
  String get timeSpent => 'Time Spent';

  @override
  String get avgSession => 'Avg Session';

  @override
  String get pomodoroSessions => 'Sesiones Pomodoro';

  @override
  String get startPomodoroSession => 'Start Pomodoro Session';

  @override
  String get timeline => 'Timeline';

  @override
  String get created => 'Created';

  @override
  String get lastModified => 'Last Modified';

  @override
  String get taskProgress => 'Progreso';

  @override
  String get statusLabel => 'Estado:';
}
