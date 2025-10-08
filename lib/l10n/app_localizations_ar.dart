// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تظبيت';

  @override
  String get homeScreenTitle => 'الرئيسية';

  @override
  String get settingsScreenTitle => 'الإعدادات';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get themeLabel => 'السمة';

  @override
  String get darkTheme => 'داكن';

  @override
  String get lightTheme => 'فاتح';

  @override
  String get systemTheme => 'النظام';

  @override
  String get saveButton => 'حفظ';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get taskTitleLabel => 'عنوان المهمة';

  @override
  String get taskDescriptionLabel => 'الوصف (اختياري)';

  @override
  String get addTaskButton => 'إضافة مهمة';

  @override
  String get editTaskButton => 'تعديل المهمة';

  @override
  String get deleteTaskButton => 'حذف المهمة';

  @override
  String confirmDeleteTask(String taskTitle) {
    return 'هل أنت متأكد من حذف \"$taskTitle\"؟';
  }

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get resetButton => 'إعادة تعيين';

  @override
  String get appearanceSection => 'المظهر';

  @override
  String get notificationsSection => 'الإشعارات';

  @override
  String get pomodoroSection => 'مؤقت بومودورو';

  @override
  String get dataBackupSection => 'البيانات والنسخ الاحتياطي';

  @override
  String get privacyAnalyticsSection => 'الخصوصية والتحليلات';

  @override
  String get regionalSection => 'الإقليمي';

  @override
  String get moodSettingsTitle => 'إعدادات المزاج';

  @override
  String get moodSettingsSubtitle => 'تكوين إشعارات فحص المزاج';

  @override
  String get enableMoodNotifications => 'تفعيل إشعارات المزاج';

  @override
  String get moodCheckInTimes => 'أوقات الفحص';

  @override
  String get add => 'إضافة';

  @override
  String get suggestTimes => 'اقتراح أوقات';

  @override
  String get completedTasks => 'مهمات مكتملة';

  @override
  String get work => 'عمل';

  @override
  String get shortBreak => 'استراحة قصيرة';

  @override
  String get longBreak => 'استراحة طويلة';

  @override
  String get paused => 'متوقف مؤقتاً';

  @override
  String get idle => 'خامل';

  @override
  String get pomodoroSessionCompleted => 'انتهت جلسة بومودورو';

  @override
  String get highPriorityLabel => 'عالية';

  @override
  String get mediumPriorityLabel => 'متوسطة';

  @override
  String get lowPriorityLabel => 'منخفضة';

  @override
  String get addTaskTitle => 'إضافة مهمة جديدة';

  @override
  String get priorityLabel => 'الأولوية:';

  @override
  String get dueDateLabel => 'تاريخ الاستحقاق (اختياري)';

  @override
  String get selectDueDate => 'حدد تاريخ الاستحقاق';

  @override
  String get categoryLabel => 'الفئة (اختياري)';

  @override
  String get noCategory => 'بدون فئة';

  @override
  String get repeatSettings => 'إعدادات التكرار';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get editTaskTitle => 'تعديل المهمة';

  @override
  String get updateButton => 'تحديث';

  @override
  String get ambientSounds => 'الأصوات المحيطة';

  @override
  String get focusAndRelaxation => 'التركيز والاسترخاء';

  @override
  String get chooseBackgroundSound => 'اختر صوت خلفية لمساعدتك على التركيز أو الاسترخاء';

  @override
  String get volume => 'مستوى الصوت';

  @override
  String get fadeIn => 'زيادة الصوت تدريجياً';

  @override
  String get fadeOut => 'خفض الصوت تدريجياً';

  @override
  String get noCategoriesYet => 'لا توجد فئات بعد';

  @override
  String get createCategoriesToOrganize => 'قم بإنشاء فئات لتنظيم مهامك';

  @override
  String get createCategory => 'إنشاء فئة';

  @override
  String get edit => 'تعديل';

  @override
  String get addCategory => 'إضافة فئة';

  @override
  String get editCategory => 'تعديل فئة';

  @override
  String get categoryName => 'اسم الفئة';

  @override
  String get enterCategoryName => 'أدخل اسم الفئة';

  @override
  String get color => 'اللون:';

  @override
  String get pickAColor => 'اختر لونًا';

  @override
  String get select => 'اختر';

  @override
  String get deleteCategory => 'حذف فئة';

  @override
  String confirmDeleteCategory(String categoryName) {
    return 'هل أنت متأكد من حذف \"$categoryName\"؟ سيؤدي هذا إلى إزالة الفئة من جميع المهام المرتبطة.';
  }

  @override
  String tasksCount(int count) {
    return '$count مهمة';
  }

  @override
  String get selectButton => 'اختيار';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get start => 'بدء';

  @override
  String get stop => 'إيقاف';

  @override
  String get skip => 'تخطي';

  @override
  String get next => 'التالي';

  @override
  String get statistics => 'الإحصائيات';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get week => 'أسبوع';

  @override
  String get month => 'شهر';

  @override
  String get streak => 'سلسلة';

  @override
  String get productivityScore => 'درجة الإنتاجية';

  @override
  String get weeklyProgress => 'التقدم الأسبوعي';

  @override
  String get categoryProgress => 'تقدم الفئة';

  @override
  String get totaltasks => 'إجمالي المهام';

  @override
  String get dueDate => 'تاريخ الاستحقاق';

  @override
  String get overdue => 'متأخر';

  @override
  String get dueThisWeek => 'مستحق هذا الأسبوع';

  @override
  String get logMood => 'سجل مزاجك';

  @override
  String get notesOptional => 'ملاحظات (اختيارية)';

  @override
  String get energyLevel => 'مستوى الطاقة';

  @override
  String get focusLevel => 'مستوى التركيز';

  @override
  String get stressLevel => 'مستوى التوتر';

  @override
  String get saveMood => 'حفظ المزاج';

  @override
  String get veryBad => 'سيء جداً';

  @override
  String get bad => 'سيء';

  @override
  String get neutral => 'محايد';

  @override
  String get good => 'جيد';

  @override
  String get veryGood => 'جيد جداً';

  @override
  String get moodCheckInTitle => 'فحص المزاج';

  @override
  String get moodHowAreYouFeeling => 'كيف تشعر اليوم؟';

  @override
  String get moodSelectLevel => 'اختر مستوى مزاجك';

  @override
  String get moodEnergyLevel => 'مستوى الطاقة';

  @override
  String get moodFocusLevel => 'مستوى التركيز';

  @override
  String get moodStressLevel => 'مستوى التوتر';

  @override
  String get low => 'منخفض';

  @override
  String get high => 'عالي';

  @override
  String get moodNoteOptional => 'ملاحظة (اختيارية)';

  @override
  String get moodNoteHint => 'كيف تشعر؟';

  @override
  String get moodSaveButton => 'حفظ المزاج';

  @override
  String get moodVeryBad => 'سيء جداً';

  @override
  String get moodBad => 'سيء';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodGood => 'جيد';

  @override
  String get moodVeryGood => 'جيد جداً';

  @override
  String get moodSavedSuccess => 'تم حفظ المزاج بنجاح!';

  @override
  String get moodSaveFailed => 'فشل في حفظ المزاج';

  @override
  String get save => 'حفظ';

  @override
  String get noCategoriesYetDescription => 'قم بإنشاء فئات لتنظيم مهامك';

  @override
  String get editButton => 'تعديل';

  @override
  String get deleteButton => 'حذف';

  @override
  String get addButton => 'إضافة';

  @override
  String get emergencyControls => 'عناصر تحكم الطوارئ';

  @override
  String get emergencyMode => 'وضع الطوارئ';

  @override
  String get activateEmergencyMode => 'تفعيل وضع الطوارئ لتعليق جميع التذكيرات والمؤقتات';

  @override
  String get emergencyModeActive => 'وضع الطوارئ نشط';

  @override
  String get allRemindersSuspended => 'تم تعليق جميع التذكيرات والمؤقتات';

  @override
  String get emergencyModeInactive => 'وضع الطوارئ غير نشط';

  @override
  String get suspendRemindersTimers => 'تعليق جميع التذكيرات والمؤقتات فورًا';

  @override
  String get quickControls => 'عناصر تحكم سريعة';

  @override
  String get fifteenMinPause => 'إيقاف مؤقت 15 دقيقة';

  @override
  String get oneHourPause => 'إيقاف مؤقت ساعة واحدة';

  @override
  String get resumeAll => 'استئناف الكل';

  @override
  String get remindersSuspended => 'تم تعليق التذكيرات';

  @override
  String timeRemaining(String time) {
    return 'الوقت المتبقي: $time';
  }

  @override
  String get resumeNow => 'استئناف الآن';

  @override
  String get moodHistory => 'تاريخ المزاج';

  @override
  String get noMoodEntriesYet => 'لا توجد إدخالات مزاجية بعد';

  @override
  String get startLoggingMoods => 'ابدأ في تسجيل مزاجك لرؤية تاريخك';

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String get rain => 'مطر';

  @override
  String get oceanWaves => 'أمواج المحيط';

  @override
  String get forest => 'غابة';

  @override
  String get whiteNoise => 'ضوضاء بيضاء';

  @override
  String get coffeeShop => 'مقهى';

  @override
  String get fireplace => 'موقد';

  @override
  String get wind => 'رياح';

  @override
  String get thunderstorm => 'عاصفة رعدية';

  @override
  String get taskCompleted => 'تم إنجاز المهمة! 🎉';

  @override
  String get taskDeleted => 'تم حذف المهمة';

  @override
  String get categoryCreated => 'تم إنشاء الفئة';

  @override
  String get categoryDeleted => 'تم حذف الفئة';

  @override
  String get pomodoroStarted => 'بدأت جلسة بومودورو';

  @override
  String get pomodoroCompleted => 'انتهت جلسة بومودورو';

  @override
  String get breakTime => 'وقت الراحة!';

  @override
  String get workTime => 'وقت العمل!';

  @override
  String get sessionComplete => 'انتهت الجلسة';

  @override
  String get allSessionsComplete => 'انتهت جميع الجلسات';

  @override
  String get progressSaved => 'تم حفظ التقدم';

  @override
  String get settingsSaved => 'تم حفظ الإعدادات';

  @override
  String get dataExported => 'تم تصدير البيانات بنجاح';

  @override
  String get dataImported => 'تم استيراد البيانات بنجاح';

  @override
  String get backupCreated => 'تم إنشاء النسخة الاحتياطية';

  @override
  String get backupRestored => 'تم استعادة النسخة الاحتياطية';

  @override
  String get notificationEnabled => 'تم تفعيل الإشعارات';

  @override
  String get notificationDisabled => 'تم تعطيل الإشعارات';

  @override
  String get soundEnabled => 'تم تفعيل الصوت';

  @override
  String get soundDisabled => 'تم تعطيل الصوت';

  @override
  String get vibrationEnabled => 'تم تفعيل الاهتزاز';

  @override
  String get vibrationDisabled => 'تم تعطيل الاهتزاز';

  @override
  String get highContrastEnabled => 'تم تفعيل التباين العالي';

  @override
  String get highContrastDisabled => 'تم تعطيل التباين العالي';

  @override
  String get largeTextEnabled => 'تم تفعيل النص الكبير';

  @override
  String get largeTextDisabled => 'تم تعطيل النص الكبير';

  @override
  String get screenReaderEnabled => 'تم تفعيل قارئ الشاشة';

  @override
  String get screenReaderDisabled => 'تم تعطيل قارئ الشاشة';

  @override
  String get autoBackupEnabled => 'تم تفعيل النسخ الاحتياطي التلقائي';

  @override
  String get autoBackupDisabled => 'تم تعطيل النسخ الاحتياطي التلقائي';

  @override
  String get analyticsEnabled => 'تم تفعيل التحليلات';

  @override
  String get analyticsDisabled => 'تم تعطيل التحليلات';

  @override
  String get crashReportingEnabled => 'تم تفعيل تقارير الأعطال';

  @override
  String get crashReportingDisabled => 'تم تعطيل تقارير الأعطال';

  @override
  String get allCategories => 'جميع الفئات';

  @override
  String get tapToAddFirstTask => 'اضغط على زر + لإضافة مهمتك الأولى';

  @override
  String get deleteTaskTitle => 'حذف المهمة';

  @override
  String get filterTasksTitle => 'تصفية المهام';

  @override
  String get allLabel => 'الكل';

  @override
  String get incompleteLabel => 'غير مكتملة';

  @override
  String get completedLabel => 'مكتملة';

  @override
  String get applyButton => 'تطبيق';

  @override
  String get clearAllButton => 'مسح الكل';

  @override
  String get profileScreenTitle => 'الملف الشخصي';

  @override
  String get nameLabel => 'الاسم';

  @override
  String get birthdayLabel => 'تاريخ الميلاد';

  @override
  String get selectBirthday => 'اختر تاريخ الميلاد';

  @override
  String get profileSaved => 'تم حفظ الملف الشخصي بنجاح';

  @override
  String get pleaseFixErrors => 'يرجى إصلاح الأخطاء أعلاه';

  @override
  String get splashAppName => 'تظبيت';

  @override
  String get splashTagline => 'مدير المهام الشخصي الخاص بك';

  @override
  String get splashBranding => 'ابق منظماً، ابق منتجاً';

  @override
  String get splashVersion => 'الإصدار 1.0.0';

  @override
  String get loginSubtitle => 'نظم مهامك وزد من إنتاجيتك';

  @override
  String get signInWithGoogle => 'تسجيل الدخول باستخدام جوجل';

  @override
  String get termsAndPrivacy => 'بتسجيل الدخول، أنت توافق على شروط الخدمة وسياسة الخصوصية الخاصة بنا';

  @override
  String get moodTracking => 'تتبع الحالة المزاجية';

  @override
  String get ambientMode => 'الوضع المحيط';

  @override
  String get emergency => 'حالة الطوارئ';

  @override
  String get profile => 'الحساب الشخصي';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get noTasksYet => 'لا توجد مهام بعد';

  @override
  String error(String message) {
    return 'خطأ: $message';
  }

  @override
  String get editProfileInfo => 'تعديل معلومات الملف الشخصي';

  @override
  String get theme => 'السمة';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get highContrast => 'تباين عالي';

  @override
  String get increaseContrast => 'زيادة التباين لسهولة القراءة';

  @override
  String get largeText => 'نص كبير';

  @override
  String get useLargerFontSizes => 'استخدام أحجام خطوط أكبر للنص';

  @override
  String get screenReader => 'قارئ الشاشة';

  @override
  String get enableScreenReaderSupport => 'تفعيل دعم قارئ الشاشة';

  @override
  String get enableNotifications => 'تفعيل الإشعارات';

  @override
  String get notificationFrequency => 'تكرار الإشعارات';

  @override
  String get immediate => 'فوري';

  @override
  String get hourly => 'كل ساعة';

  @override
  String get daily => 'يومي';

  @override
  String get weekly => 'أسبوعي';

  @override
  String get sound => 'الصوت';

  @override
  String get vibration => 'الاهتزاز';

  @override
  String get pomodoroPreset => 'إعدادات بومودورو';

  @override
  String get classicPreset => 'كلاسيكي (25/5/15)';

  @override
  String get shortPreset => 'قصير (15/3/10)';

  @override
  String get longPreset => 'طويل (50/10/30)';

  @override
  String get custom => 'مخصص';

  @override
  String get customDurations => 'الأوقات المخصصة (بالدقائق)';

  @override
  String get sessionsToLongBreak => 'الجلسات حتى الاستراحة الطويلة';

  @override
  String get autoBackup => 'النسخ الاحتياطي التلقائي';

  @override
  String get automaticallyBackupData => 'النسخ التلقائي لبياناتك';

  @override
  String get backupFrequency => 'تكرار النسخ الاحتياطي';

  @override
  String days(int count) {
    return '$count يوم';
  }

  @override
  String get analytics => 'التحليلات';

  @override
  String get helpImproveApp => 'مساعدة في تحسين التطبيق من خلال بيانات الاستخدام';

  @override
  String get crashReporting => 'تقارير الأعطال';

  @override
  String get sendCrashReports => 'إرسال تقارير الأعطال للمساعدة في إصلاح المشكلات';

  @override
  String get language => 'اللغة';

  @override
  String get dateFormat => 'تنسيق التاريخ';

  @override
  String get timeFormat => 'تنسيق الوقت';

  @override
  String get twelveHour => '12 ساعة';

  @override
  String get twentyFourHour => '24 ساعة';

  @override
  String get today => 'اليوم';

  @override
  String get history => 'التاريخ';

  @override
  String get insights => 'الإحصائيات';

  @override
  String get howAreYouFeeling => 'كيف تشعر؟';

  @override
  String get tapToLogMood => 'اضغط على زر + لتسجيل حالتك المزاجية';

  @override
  String get yourMoodInsights => 'إحصائيات حالتك المزاجية';

  @override
  String get totalEntries => 'إجمالي الإدخالات';

  @override
  String get averageMood => 'متوسط المزاج';

  @override
  String get mostCommonMood => 'المزاج الأكثر شيوعًا';

  @override
  String get currentStreak => 'السلسلة الحالية';

  @override
  String get averageEnergy => 'متوسط الطاقة';

  @override
  String get averageFocus => 'متوسط التركيز';

  @override
  String get averageStress => 'متوسط التوتر';

  @override
  String get energy => 'الطاقة';

  @override
  String get focus => 'التركيز';

  @override
  String get stress => 'التوتر';

  @override
  String metricValue(String label, int value) {
    return '$label: $value/10';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام';

  @override
  String get searchHint => 'البحث عن المهام...';

  @override
  String get deleteTaskConfirmationTitle => 'حذف المهمة';

  @override
  String get deleteSubtask => 'حذف المهمة الفرعية';

  @override
  String get confirmDeleteSubtask => 'هل أنت متأكد من حذف هذه المهمة الفرعية؟';

  @override
  String get collapse => 'طي';

  @override
  String get expand => 'توسيع';

  @override
  String get copySuffix => '(نسخة)';

  @override
  String get highPriority => 'عالية';

  @override
  String get mediumPriority => 'متوسطة';

  @override
  String get lowPriority => 'منخفضة';

  @override
  String get addSubtask => 'إضافة مهمة فرعية';

  @override
  String get recurringTasksManager => 'مدير المهام المتكررة';

  @override
  String get generateRecurringInstances => 'إنشاء نسخ متكررة';

  @override
  String get recurringInstancesGenerated => 'تم إنشاء النسخ المتكررة بنجاح!';

  @override
  String get errorGeneratingInstances => 'خطأ في إنشاء النسخ المتكررة';

  @override
  String get duplicateTask => 'تكرار المهمة';

  @override
  String get allRecurringUpToDate => 'جميع المهام المتكررة محدثة!';

  @override
  String get generateNextInstance => 'إنشاء النسخة التالية';

  @override
  String get generateAllInstances => 'إنشاء جميع النسخ';

  @override
  String get activeRecurringTasks => 'المهام المتكررة النشطة';

  @override
  String get totalRecurringInstances => 'إجمالي النسخ المتكررة';

  @override
  String get tasksNeedingInstances => 'المهام التي تحتاج نسخ جديدة';

  @override
  String get refreshRecurringTasks => 'تحديث المهام المتكررة';

  @override
  String get subtaskTitle => 'عنوان المهمة الفرعية';

  @override
  String get subtaskDescription => 'الوصف (اختياري)';

  @override
  String get pleaseEnterSubtaskTitle => 'يرجى إدخال عنوان المهمة الفرعية';

  @override
  String get customizePomodoroSession => 'تخصيص جلسة بومودورو';

  @override
  String get workDurationLabel => 'مدة العمل';

  @override
  String get shortBreakLabel => 'استراحة قصيرة';

  @override
  String get longBreakLabel => 'استراحة طويلة';

  @override
  String get startSession => 'بدء الجلسة';

  @override
  String get pomodoroFocus => 'تركيز بومودورو';

  @override
  String get pomodoroDescription => 'اختر مهمة للتركيز عليها وتخصيص جلستك';

  @override
  String get sessionProgress => 'تقدم الجلسة';

  @override
  String get settingsButton => 'الإعدادات';

  @override
  String get tomorrow => 'غداً';

  @override
  String get yesterday => 'أمس';

  @override
  String get overdueTasks => 'مهمات متأخرة - تحتاج إلى انتباه فوري';

  @override
  String get todayTasks => 'مهمات يجب إنجازها اليوم';

  @override
  String get tomorrowTasks => 'مهمات غداً';

  @override
  String get thisWeekTasks => 'مهمات هذا الأسبوع';

  @override
  String get laterTasks => 'مهمات لاحقة';

  @override
  String get noDateTasks => 'مهمات بدون تاريخ محدد';

  @override
  String get receiveNotificationsForTasksAndReminders => 'تلقي إشعارات للمهام والتذكيرات';

  @override
  String get playSoundForNotifications => 'تشغيل صوت للإشعارات';

  @override
  String get vibrateForNotifications => 'اهتزاز للإشعارات';

  @override
  String get noUpcomingTasksWithReminders => 'لا توجد مهام قادمة مع تذكيرات';

  @override
  String get noOverdueTasks => 'لا توجد مهام متأخرة';

  @override
  String get testNotification => 'اختبار الإشعار';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String reminderCancelledFor(String taskTitle) {
    return 'تم إلغاء التذكير لـ: $taskTitle';
  }

  @override
  String get testNotificationSent => 'تم إرسال إشعار الاختبار!';

  @override
  String reminder(String date) {
    return 'تذكير: $date';
  }

  @override
  String get noReminderSet => 'لم يتم تعيين تذكير';

  @override
  String get allNotificationsCleared => 'تم مسح جميع الإشعارات!';

  @override
  String get checkPendingNotifications => 'فحص المعلقة';

  @override
  String get cancelAllNotifications => 'إلغاء الكل';

  @override
  String get allNotificationsCancelled => 'تم إلغاء جميع الإشعارات!';

  @override
  String get moodCheckInNotificationTitle => 'فحص المزاج';

  @override
  String get moodCheckInNotificationBody => 'كيف تشعر الآن؟ اضغط لتسجيل مزاجك.';

  @override
  String get testMoodNotificationTitle => 'اختبار إشعار المزاج';

  @override
  String get testMoodNotificationBody => 'هذا إشعار اختبار لفحص المزاج.';

  @override
  String get testReminderIn10Seconds => 'اختبار تذكير في 10 ثواني';

  @override
  String get testReminderScheduled => 'تم جدولة تذكير الاختبار لمدة 10 ثواني من الآن';

  @override
  String get upcoming => 'قادم';

  @override
  String get appUpdates => 'تحديثات التطبيق';

  @override
  String get checkForUpdates => 'البحث عن تحديثات';

  @override
  String get currentVersion => 'الإصدار الحالي';

  @override
  String get latestVersion => 'أحدث إصدار';

  @override
  String get updateAvailable => 'تحديث متاح';

  @override
  String get updateDownloaded => 'تم تحميل التحديث';

  @override
  String get installUpdate => 'تثبيت التحديث';

  @override
  String get downloadingUpdate => 'جاري تحميل التحديث...';

  @override
  String get installingUpdate => 'جاري تثبيت التحديث...';

  @override
  String get noUpdatesAvailable => 'لا توجد تحديثات متاحة';

  @override
  String get updateError => 'خطأ في التحديث';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String version(String version) {
    return 'الإصدار $version';
  }

  @override
  String get updatePersonalInfo => 'تحديث المعلومات الشخصية';

  @override
  String get sunday => 'الأحد';

  @override
  String get monday => 'الاثنين';

  @override
  String get tuesday => 'الثلاثاء';

  @override
  String get wednesday => 'الأربعاء';

  @override
  String get thursday => 'الخميس';

  @override
  String get friday => 'الجمعة';

  @override
  String get saturday => 'السبت';

  @override
  String get focusMode => 'وضع التركيز';

  @override
  String get motivationalQuoteHigh => 'لديك هذا! 🚀';

  @override
  String get motivationalQuoteMedium => 'استمر! 💪';

  @override
  String get motivationalQuoteLow => 'خذ الأمر ببساطة! 😊';

  @override
  String get taskDetails => 'تفاصيل المهمة';

  @override
  String get noDueDate => 'لا يوجد تاريخ استحقاق';

  @override
  String get priority => 'الأولوية';

  @override
  String get reminders => 'التذكيرات';

  @override
  String get repeat => 'تكرار';

  @override
  String get noSubtasks => 'لا توجد مهام فرعية بعد';

  @override
  String get subtasks => 'المهام الفرعية';

  @override
  String get sessions => 'الجلسات';

  @override
  String get timeSpent => 'الوقت المستغرق';

  @override
  String get avgSession => 'متوسط الجلسة';

  @override
  String get pomodoroSessions => 'جلسات البومودورو';

  @override
  String get startPomodoroSession => 'بدء جلسة بومودورو';

  @override
  String get timeline => 'الجدول الزمني';

  @override
  String get created => 'تم الإنشاء';

  @override
  String get lastModified => 'آخر تعديل';

  @override
  String get taskProgress => 'التقدم';

  @override
  String get statusLabel => 'الحالة:';

  @override
  String get setReminderButton => 'تعيين تذكير';

  @override
  String get uncompleteTaskButton => 'إلغاء إكمال المهمة';

  @override
  String get completeTaskButton => 'إكمال المهمة';

  @override
  String get completeSubtasksFirst => 'أكمل المهام الفرعية أولاً';
}
