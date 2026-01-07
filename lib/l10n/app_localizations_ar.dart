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
    return 'هل أنت متأكد من أنك تريد حذف \"$taskTitle\"؟';
  }

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get addTaskToGetStarted => 'أضف مهمة للبدء';

  @override
  String get voiceTaskCreate => 'إنشاء مهمة بالصوت';

  @override
  String get voiceTaskHint => 'اضغط على الميكروفون للتحدث';

  @override
  String get voiceTaskProcessing => 'جاري معالجة صوتك...';

  @override
  String get voiceTaskCreated => 'تم إنشاء المهمة الصوتية';

  @override
  String get taskValidationFailed => 'فشل التحقق من المهمة';

  @override
  String get errorCreatingTask => 'خطأ في إنشاء المهمة';

  @override
  String get tryVoiceTasks => 'جرب المهام الصوتية! اضغط على الميكروفون لإنشاء مهام فوراً.';

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
  String get notificationHistory => 'سجل الإشعارات';

  @override
  String get notificationPreferences => 'إعدادات الإشعارات';

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
  String get moodSettingsSubtitle => 'إدارة تسجيل المزاج والإشعارات';

  @override
  String get enableMoodNotifications => 'تفعيل إشعارات المزاج';

  @override
  String get moodCheckInTimes => 'أوقات فحص المزاج';

  @override
  String get add => 'إضافة';

  @override
  String get suggestTimes => 'اقتراح الأوقات';

  @override
  String get completedTasks => 'المهام المكتملة';

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
  String get noCategory => 'لا توجد فئة';

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
  String get editCategory => 'تعديل الفئة';

  @override
  String get categoryName => 'اسم الفئة';

  @override
  String get enterCategoryName => 'أدخل اسم الفئة';

  @override
  String get color => 'اللون';

  @override
  String get pickAColor => 'اختر لوناً';

  @override
  String get select => 'اختر';

  @override
  String get deleteCategory => 'حذف الفئة';

  @override
  String confirmDeleteCategory(String categoryName) {
    return 'هل أنت متأكد من حذف \"$categoryName\"؟ سيؤدي هذا إلى إزالة الفئة من جميع المهام المرتبطة.';
  }

  @override
  String tasksCount(int count) {
    return 'عدد المهام';
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
  String get dueDateTitle => 'تاريخ الاستحقاق';

  @override
  String dueDate(Object dueDate) {
    return 'تاريخ الاستحقاق: $dueDate';
  }

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
  String get moodHowAreYouFeeling => 'كيف تشعر؟';

  @override
  String get moodSelectLevel => 'اختر مستوى مزاجك';

  @override
  String get moodEnergyLevel => 'مستوى الطاقة';

  @override
  String get moodFocusLevel => 'مستوى التركيز';

  @override
  String get moodStressLevel => 'مستوى التوتر';

  @override
  String get low => 'منخفضة';

  @override
  String get high => 'عالية';

  @override
  String get moodNoteOptional => 'ملاحظة (اختيارية)';

  @override
  String get moodNoteHint => 'أضف ملاحظة عن مزاجك...';

  @override
  String get moodSaveButton => 'حفظ المزاج';

  @override
  String get moodVeryBad => 'أعاني حقًا';

  @override
  String get moodBad => 'ليس جيدًا';

  @override
  String get moodNeutral => 'حسنًا';

  @override
  String get moodGood => 'جيد جدًا';

  @override
  String get moodVeryGood => 'رائع';

  @override
  String get moodSavedSuccess => 'تم حفظ المزاج بنجاح';

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
  String get moodHistoryTitle => 'تاريخ المزاج';

  @override
  String get startTracking => 'ابدأ رحلة تتبع مزاجك';

  @override
  String get quickMoodCheckIn => 'فحص المزاج السريع';

  @override
  String moodsForDate(Object date) {
    return 'مزاجيات لـ $date';
  }

  @override
  String get close => 'إغلاق';

  @override
  String get filter => 'تصفية';

  @override
  String get all => 'الكل';

  @override
  String get positive => 'إيجابي';

  @override
  String get negative => 'سلبي';

  @override
  String get recent => 'الحديث';

  @override
  String get energy => 'الطاقة';

  @override
  String get focus => 'التركيز';

  @override
  String get stress => 'التوتر';

  @override
  String get howAreYou => 'كيف حالك؟';

  @override
  String get yourMood => 'مزاجك';

  @override
  String get howAreYouFeelingRightNow => 'كيف تشعر الآن؟';

  @override
  String get tapOptionBestDescribesMood => 'اضغط على الخيار الذي يصف مزاجك بشكل أفضل';

  @override
  String get addNoteOptional => 'أضف ملاحظة (اختيارية)';

  @override
  String get whatsOnYourMind => 'ما الذي يدور في ذهنك؟';

  @override
  String get moodAdded => 'تمت إضافة المزاج';

  @override
  String get moodUpdated => 'تم تحديث المزاج';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get reallyStruggling => 'أعاني حقًا';

  @override
  String get notGreat => 'ليس جيدًا';

  @override
  String get okay => 'حسنًا';

  @override
  String get prettyGood => 'جيد جدًا';

  @override
  String get great => 'رائع';

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
  String get taskCompleted => 'تم إكمال المهمة بنجاح';

  @override
  String get taskDeleted => 'تم حذف المهمة بنجاح';

  @override
  String get categoryCreated => 'تم إنشاء الفئة بنجاح';

  @override
  String get categoryDeleted => 'تم حذف الفئة بنجاح';

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
  String get signInWithApple => 'تسجيل الدخول باستخدام آبل';

  @override
  String get termsAndPrivacy => 'بتسجيل الدخول، أنت توافق على شروط الخدمة وسياسة الخصوصية الخاصة بنا';

  @override
  String get moodTracking => 'تتبع الحالة المزاجية';

  @override
  String get ambientMode => 'الوضع المحيط';

  @override
  String get emergency => 'حالة الطوارئ';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get noTasksYet => 'لا توجد مهام بعد';

  @override
  String get noTasksInCategory => 'لا توجد مهام في هذه الفئة';

  @override
  String error(String message) {
    return 'خطأ';
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
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get sound => 'الصوت';

  @override
  String get vibration => 'الاهتزاز';

  @override
  String get pomodoroPreset => 'إعدادات بومودورو';

  @override
  String get classicPreset => 'كلاسيكي';

  @override
  String get quickstart => 'بداية سريعة';

  @override
  String get deepWork => 'عمل عميق';

  @override
  String get students => 'طلاب';

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
  String get insights => 'الرؤى';

  @override
  String get howAreYouFeeling => '😊 كيف تشعر؟';

  @override
  String get tapToLogMood => 'اضغط لتسجيل مزاجك';

  @override
  String get yourMoodInsights => 'إحصائيات حالتك المزاجية';

  @override
  String get totalEntries => 'إجمالي الإدخالات';

  @override
  String get averageMood => 'متوسط المزاج';

  @override
  String get mostCommonMood => 'المزاج الأكثر شيوعاً';

  @override
  String get currentStreak => 'السلسلة الحالية';

  @override
  String get averageEnergy => 'متوسط الطاقة';

  @override
  String get averageFocus => 'متوسط التركيز';

  @override
  String get averageStress => 'متوسط التوتر';

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
  String get highPriority => 'أولوية عالية';

  @override
  String get mediumPriority => 'أولوية متوسطة';

  @override
  String get lowPriority => 'أولوية منخفضة';

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
  String get overdueTasks => 'المهام المتأخرة';

  @override
  String get todayTasks => 'مهام اليوم';

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
  String get testNotificationSent => 'تم إرسال إشعار اختبار';

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
  String get allNotificationsCancelled => 'تم إلغاء جميع الإشعارات';

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
    return 'الإصدار: $version';
  }

  @override
  String get updatePersonalInfo => 'تحديث المعلومات الشخصية';

  @override
  String get sunday => 'الأحد';

  @override
  String get monday => 'الإثنين';

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
  String priority(Object priority) {
    return 'الأولوية: $priority';
  }

  @override
  String get reminders => 'التذكيرات';

  @override
  String get repeat => 'التكرار';

  @override
  String get noSubtasks => 'لا توجد مهام فرعية';

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

  @override
  String get testNotifications => 'اختبار الإشعارات';

  @override
  String get tryAllNotificationFeatures => 'جرب جميع ميزات الإشعارات';

  @override
  String get customizeNotificationBehavior => 'تخصيص سلوك الإشعارات';

  @override
  String get viewPastNotifications => 'عرض الإشعارات السابقة';

  @override
  String get notificationTesting => '🧪 اختبار الإشعارات';

  @override
  String get quickTestGuide => '🎯 دليل الاختبار السريع';

  @override
  String totalNotifications(int count) {
    return 'إجمالي الإشعارات: $count';
  }

  @override
  String get notificationsEnabled => 'مفعّل: ✅';

  @override
  String get notificationsDisabled => 'مفعّل: ❌';

  @override
  String get basicNotifications => '1. الإشعارات الأساسية';

  @override
  String get testSimpleNotification => 'اختبار: إشعار بسيط';

  @override
  String get appearsIn10Seconds => 'يظهر خلال 10 ثوانٍ';

  @override
  String get testTaskReminder => 'اختبار: تذكير بمهمة';

  @override
  String get withActionButtons15Seconds => 'مع أزرار الإجراءات - 15 ثانية';

  @override
  String get testMoodCheckIn => 'اختبار: تسجيل المزاج';

  @override
  String get testIn20Seconds => '20 ثانية';

  @override
  String get priorityLevels => '2. مستويات الأولوية';

  @override
  String get testHighPriority => 'اختبار: أولوية عالية';

  @override
  String get urgentNotification10Seconds => 'إشعار عاجل - 10 ثوانٍ';

  @override
  String get testLowPriority => 'اختبار: أولوية منخفضة';

  @override
  String get silentNotification10Seconds => 'إشعار صامت - 10 ثوانٍ';

  @override
  String get notificationManagement => '3. إدارة الإشعارات';

  @override
  String get viewNotificationHistory => 'عرض سجل الإشعارات';

  @override
  String get seeAllPastNotifications => 'عرض جميع الإشعارات السابقة';

  @override
  String get configureNotificationSettings => 'تكوين إعدادات الإشعارات';

  @override
  String get testingTips => 'نصائح الاختبار';

  @override
  String get grantNotificationPermissions => '1. امنح أذونات الإشعارات عند المطالبة';

  @override
  String get keepAppInBackground => '2. احتفظ بالتطبيق في الخلفية بعد الجدولة';

  @override
  String get checkHistoryAfterDelivery => '3. تحقق من سجل الإشعارات بعد التسليم';

  @override
  String get tryActionButtons => '4. جرب أزرار الإجراءات في إشعارات المهام';

  @override
  String get testDNDMode => '5. اختبر وضع عدم الإزعاج في التفضيلات';

  @override
  String get notificationScheduledFor10Seconds => '⏰ تم جدولة الإشعار لمدة 10 ثوانٍ';

  @override
  String get taskNotificationIn15Seconds => '⏰ إشعار المهمة خلال 15 ثانية (يحتوي على أزرار إجراءات!)';

  @override
  String get moodNotificationIn20Seconds => '⏰ إشعار المزاج خلال 20 ثانية';

  @override
  String get highPriorityNotificationIn10Seconds => '⏰ إشعار عالي الأولوية خلال 10 ثوانٍ';

  @override
  String get lowPriorityNotificationIn10Seconds => '⏰ إشعار منخفض الأولوية (صامت) خلال 10 ثوانٍ';

  @override
  String get testNotificationTitle => '✅ إشعار اختباري';

  @override
  String get testNotificationBody => 'نظام الإشعارات الجديد يعمل!';

  @override
  String get taskCompleteReport => '📋 مهمة: إكمال التقرير';

  @override
  String get dueInOneHour => 'مستحق خلال ساعة واحدة - اضغط للعرض';

  @override
  String get highPriorityAlert => '🚨 تنبيه عالي الأولوية';

  @override
  String get urgentNotificationMessage => 'هذا إشعار عاجل!';

  @override
  String get lowPriorityInfo => 'ℹ️ معلومات منخفضة الأولوية';

  @override
  String get quietNotificationMessage => 'هذا إشعار هادئ';

  @override
  String get filters => 'الفلاتر';

  @override
  String get searchNotifications => 'البحث في الإشعارات...';

  @override
  String get filterByType => 'تصفية حسب النوع';

  @override
  String get filterByStatus => 'تصفية حسب الحالة';

  @override
  String get notificationAnalyticsLast7Days => 'التحليلات (آخر 7 أيام)';

  @override
  String get notificationAnalyticsSent => 'تم الإرسال';

  @override
  String get notificationAnalyticsDelivered => 'تم التسليم';

  @override
  String get notificationAnalyticsOpened => 'تم الفتح';

  @override
  String get notificationAnalyticsAction => 'معدل الإجراء';

  @override
  String get notificationStatusDelivered => 'تم التسليم';

  @override
  String get notificationStatusPending => 'قيد الانتظار';

  @override
  String get notificationStatusFailed => 'فشل';

  @override
  String get notificationStatusCancelled => 'تم الإلغاء';

  @override
  String get notificationStatusExpired => 'منتهي الصلاحية';

  @override
  String get doNotDisturb => 'عدم الإزعاج';

  @override
  String get scheduledQuietHours => 'ساعات الهدوء المجدولة';

  @override
  String get allowUrgentNotifications => 'السماح بالإشعارات العاجلة أثناء عدم الإزعاج';

  @override
  String get smartScheduling => 'الجدولة الذكية';

  @override
  String get enableSmartScheduling => 'تفعيل الجدولة الذكية';

  @override
  String get maxNotificationsPerHour => 'الحد الأقصى للإشعارات في الساعة';

  @override
  String get minimumMinutesBetweenSameType => 'الحد الأدنى من الدقائق بين نفس النوع';

  @override
  String get groupSimilarNotifications => 'تجميع الإشعارات المتشابهة';

  @override
  String get respectSystemDND => 'احترام وضع عدم الإزعاج للنظام';

  @override
  String get notificationTypes => 'أنواع الإشعارات';

  @override
  String get taskReminders => 'تذكيرات المهام';

  @override
  String get moodCheckIns => 'فحوصات المزاج';

  @override
  String get pomodoroNotifications => 'إشعارات بومودورو';

  @override
  String get emergencyNotifications => 'الطوارئ';

  @override
  String get enabled => 'مفعّل';

  @override
  String get adaptiveTiming => 'التوقيت التكيفي';

  @override
  String get openSystemSettings => 'فتح إعدادات النظام';

  @override
  String get viewHistory => 'عرض السجل';

  @override
  String get emergencyAlertsWillBypassQuietHours => 'تنبيهات الطوارئ ستتجاوز ساعات الهدوء';

  @override
  String get intelligentNotificationManagement => 'إدارة الإشعارات الذكية';

  @override
  String get automaticallyOptimizeNotificationTiming => 'تحسين توقيت الإشعارات تلقائيًا لتجنب مقاطعتك';

  @override
  String get combineNotificationsOfTheSameType => 'دمج الإشعارات من نفس النوع في مجموعات';

  @override
  String get honorDeviceDoNotDisturbSettings => 'احترام إعدادات عدم الإزعاج للجهاز';

  @override
  String get customizeEachNotificationType => 'تخصيص كل نوع إشعار';

  @override
  String get disabled => 'معطل';

  @override
  String get enable => 'تفعيل';

  @override
  String get showBadge => 'إظهار الشارة';

  @override
  String get enableActions => 'تفعيل الإجراءات';

  @override
  String get showActionButtons => 'إظهار أزرار الإجراءات';

  @override
  String get advancedSettings => 'الإعدادات المتقدمة';

  @override
  String get expertOptions => 'خيارات الخبراء للمستخدمين المتقدمين';

  @override
  String get badgeOnlyMode => 'وضع الشارة فقط';

  @override
  String get badgeOnlyModeSubtitle => 'إظهار الشارة بدون صوت أو نافذة منبثقة';

  @override
  String get deliveryTracking => 'تتبع التسليم';

  @override
  String get trackWhenNotificationsAreDelivered => 'تتبع متى يتم تسليم الإشعارات وفتحها';

  @override
  String get trackNotificationInteractionStatistics => 'تتبع إحصائيات تفاعل الإشعارات';

  @override
  String get learnFromYourBehaviorToOptimizeNotificationTiming => 'التعلم من سلوكك لتحسين توقيت الإشعارات';

  @override
  String get moodCheckIn => 'تسجيل المزاج';

  @override
  String get masterToggleForAllNotifications => 'التبديل الرئيسي لجميع الإشعارات';

  @override
  String get activeNotificationsMuted => 'نشط - الإشعارات مكتومة';

  @override
  String get configureQuietHours => 'تكوين ساعات الهدوء';

  @override
  String get setAutomaticQuietHours => 'تعيين ساعات الهدوء التلقائية';

  @override
  String get sendTestNotification => 'إرسال إشعار تجريبي';

  @override
  String get taskDue => 'مهمة مستحقة';

  @override
  String get pomodoroWork => 'بومودورو عمل';

  @override
  String get pomodoroBreak => 'بومودورو استراحة';

  @override
  String get pomodoroComplete => 'بومودورو مكتمل';

  @override
  String get medium => 'متوسطة';

  @override
  String get urgent => 'عاجلة';

  @override
  String get notificationPreferencesInfo => 'معلومات تفضيلات الإشعارات';

  @override
  String get notificationPreferencesInfoDetails => 'قم بتكوين كيفية ووقت استلام الإشعارات. خصص كل نوع إشعار، وعيّن ساعات الهدوء، وتحكم في سلوك الإشعارات.';

  @override
  String get smartSchedulingInfo => 'تتعلم الجدولة الذكية من أنماط استخدامك لتقديم الإشعارات في الأوقات المثلى.';

  @override
  String get dndInfo => 'يُسكت وضع عدم الإزعاج جميع الإشعارات باستثناء حالات الطوارئ خلال الساعات المحددة.';

  @override
  String get manualDND => 'عدم الإزعاج اليدوي';

  @override
  String get resetSettings => 'إعادة تعيين الإعدادات';

  @override
  String get resetSettingsConfirmation => 'هل أنت متأكد أنك تريد إعادة تعيين جميع الإعدادات إلى الافتراضية؟';

  @override
  String get searchSettings => 'البحث في الإعدادات';

  @override
  String get typeToFilterSettingsSections => 'اكتب لتصفية أقسام الإعدادات';

  @override
  String get searchSettingsHint => 'بحث...';

  @override
  String get increaseContrastForBetterVisibility => 'زيادة التباين لرؤية أفضل';

  @override
  String get taskCompletionSounds => 'أصوات إكمال المهام';

  @override
  String get enableTaskCompletionSound => 'تفعيل صوت إكمال المهمة';

  @override
  String get playSoundWhenTasksAreCompleted => 'تشغيل الصوت عند إكمال المهام';

  @override
  String get soundSelection => 'اختيار الصوت';

  @override
  String get testSound => 'اختبار الصوت';

  @override
  String get customDurationsMinutes => 'مدد مخصصة (بالدقائق)';

  @override
  String get workDuration => 'مدة العمل';

  @override
  String get shortBreakDuration => 'مدة الاستراحة القصيرة';

  @override
  String get longBreakDuration => 'مدة الاستراحة الطويلة';

  @override
  String get helpImproveTheAppWithUsageData => 'ساعد في تحسين التطبيق ببيانات الاستخدام';

  @override
  String get sendCrashReportsToHelpFixIssues => 'إرسال تقارير الأعطال للمساعدة في إصلاح المشاكل';

  @override
  String get failedToCheckForUpdates => 'فشل التحقق من التحديثات';

  @override
  String get mood => 'المزاج';

  @override
  String get appearance => 'المظهر';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get taskSounds => 'أصوات المهام';

  @override
  String get pomodoro => 'بومودورو';

  @override
  String get backup => 'النسخ الاحتياطي';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get regional => 'الإقليمي';

  @override
  String get updates => 'التحديثات';

  @override
  String get calendar => 'التقويم';

  @override
  String get clearDateFilter => 'مسح تصفية التاريخ';

  @override
  String tasksForDate(String date) {
    return 'مهام ليوم $date';
  }

  @override
  String tasksDue(int count) {
    return '$count مهمة مستحقة';
  }

  @override
  String get undatedTasks => 'مهام بدون تواريخ';

  @override
  String get monthView => 'شهر';

  @override
  String get weekView => 'أسبوع';

  @override
  String get calendarView => 'عرض التقويم';

  @override
  String get rescheduleTask => 'إعادة جدولة المهمة';

  @override
  String get taskRescheduled => 'تم إعادة جدولة المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get viewDayTasks => 'عرض مهام اليوم';

  @override
  String get noTasksForThisDay => 'لا توجد مهام لهذا اليوم';

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get pullToRefresh => 'اسحب للأسفل للتحديث عند الاتصال';

  @override
  String get showCalendar => 'عرض التقويم';

  @override
  String get minutes => 'دقائق';

  @override
  String get recommendedForAdhd => 'موصى به لمن يعاني من ADHD';

  @override
  String get mostPopular => 'الأكثر شعبية';

  @override
  String get stopPomodoroConfirmation => 'هل أنت متأكد من إيقاف الجلسة الحالية؟ سيتم فقدان تقدمك.';

  @override
  String get selectATemplateOrCustomizeYourSession => 'اختر قالباً أو خصص جلستك';

  @override
  String get stopPomodoroTimer => 'إيقاف المؤقت';

  @override
  String get resume => 'استئناف';

  @override
  String get sessionsUntilLongBreak => 'الجلسات حتى الاستراحة الطويلة';

  @override
  String get customizeYourPomodoroSession => 'خصص جلسة البومودورو الخاصة بك';

  @override
  String get whatsHappeningRightNow => 'ما الذي يحدث الآن؟';

  @override
  String get wantToShareMore => 'هل تريد مشاركة المزيد؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get failedToAccessGallery => 'فشل في الوصول إلى المعرض';

  @override
  String get nameRequiredForProfile => 'الاسم مطلوب للملف الشخصي';

  @override
  String get birthdayRequiredForProfile => 'تاريخ الميلاد مطلوب للملف الشخصي';

  @override
  String get failedToUploadImage => 'فشل في رفع الصورة';

  @override
  String get userNotAuthenticated => 'المستخدم غير مصادق عليه';

  @override
  String get notificationPermissionRequired => 'إذن الإشعارات مطلوب';

  @override
  String get notificationPermissionMessage => 'يرجى تمكين الإشعارات لضبط التذكيرات';

  @override
  String get grantPermission => 'منح الإذن';

  @override
  String get cannotSetReminderWithoutPermission => 'لا يمكن ضبط التذكير بدون إذن الإشعارات';

  @override
  String get customColors => 'ألوان مخصصة';

  @override
  String get personalizeAppTheme => 'تخصيص مظهر التطبيق';

  @override
  String get primaryColor => 'اللون الأساسي';

  @override
  String get choosePrimaryColor => 'اختر اللون الأساسي';

  @override
  String subtasksCount(int count) {
    return '$count مهام فرعية';
  }

  @override
  String get deliveryLabel => 'التسليم';

  @override
  String get openLabel => 'فتح';

  @override
  String get actionLabel => 'إجراء';

  @override
  String get averageResponseTime => 'متوسط وقت الاستجابة';

  @override
  String get helpUsUnderstandState => 'ساعدنا على فهم حالتك الحالية';

  @override
  String get optionalAddContext => 'اختياري: أضف سياقًا';

  @override
  String get optionalWriteNote => 'اختياري: اكتب ملاحظة';

  @override
  String get imGratefulFor => 'أنا ممتن لـ';

  @override
  String get todayI => 'اليوم أنا';

  @override
  String get imFeeling => 'أنا أشعر بـ';

  @override
  String get whatsWeighingOnYou => 'ما الذي يثقل عليك؟';

  @override
  String get whatsMakingTodayTough => 'ما الذي يجعل اليوم صعبًا؟';

  @override
  String get whatsGoingWell => 'ما الذي يسير بشكل جيد؟';

  @override
  String get whatMadeTodayGreat => 'ما الذي جعل اليوم رائعًا؟';

  @override
  String get howsYourDayGoing => 'كيف يسير يومك؟';

  @override
  String get chooseEmojiFeeling => 'اختر رمزًا تعبيريًا يمثل شعورك';

  @override
  String get dayStreak => 'يوم متتالي';

  @override
  String get moodSaved => 'تم حفظ المزاج';

  @override
  String get testButton => 'اختبار';

  @override
  String get clearAllNotifications => 'مسح جميع الإشعارات';

  @override
  String get clearAllNotificationsConfirmation => 'هل أنت متأكد من أنك تريد مسح جميع الإشعارات؟';

  @override
  String get generateRecurringConfirmation => 'هل أنت متأكد من أنك تريد إنشاء مثيلات متكررة؟';

  @override
  String get includeSpecificTime => 'تضمين وقت محدد';

  @override
  String get repeatSameTimeEachDay => 'التكرار في نفس الوقت كل يوم';

  @override
  String get syncStatus => 'حالة المزامنة';

  @override
  String get pendingOperations => 'عمليات معلقة';

  @override
  String get someSyncOperationsFailed => 'فشلت بعض عمليات المزامنة';

  @override
  String get retryButton => 'إعادة المحاولة';

  @override
  String get clearFailedButton => 'مسح الفاشلة';

  @override
  String get closeButton => 'إغلاق';

  @override
  String get syncStatusSuccess => 'نجح';

  @override
  String get syncStatusSyncing => 'جاري المزامنة';

  @override
  String get syncStatusIdle => 'في الانتظار';

  @override
  String get syncStatusFailed => 'فشل';

  @override
  String get moodInsightsSubtitle => 'تابع أنماطك العاطفية واحصل على رؤى';

  @override
  String get yourMoodJourney => 'رحلتك المزاجية';

  @override
  String get aIPoweredAnalysis => 'تحليل مدعوم بالذكاء الاصطناعي';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get goodDays => 'أيام جيدة';

  @override
  String get neutralDays => 'أيام محايدة';

  @override
  String get challengingDays => 'أيام صعبة';

  @override
  String get dominantMood => 'المزاج السائد';

  @override
  String get hiThere => 'مرحباً!';

  @override
  String get howIsYourDay => 'كيف يومك؟';

  @override
  String get imHereForYou => 'أنا هنا من أجلك!';

  @override
  String get itsOkayToHaveToughDays => 'من الطبيعي أن تكون لديك أيام صعبة';

  @override
  String get sendingYouStrength => 'أرسل لك القوة';

  @override
  String get everyDayIsANewOpportunity => 'كل يوم هو فرصة جديدة';

  @override
  String get findingBalance => 'إيجاد التوازن';

  @override
  String get sometimesNeutralIsExactlyWhereWeNeedToBe => 'أحياناً المحايد هو بالضبط حيث نحتاج أن نكون';

  @override
  String get youreDoingGreat => 'أنت تفعل رائعاً!';

  @override
  String get keepShiningBright => 'استمر بالتألق بقوة!';

  @override
  String get absolutelyAmazing => 'مذهل تماماً!';

  @override
  String get yourJoyIsContagious => 'فرحك معدي!';

  @override
  String get moodIntensity => 'شدة المزاج';

  @override
  String get smartView => 'ذكي';

  @override
  String get timelineView => 'الخط الزمني';

  @override
  String get patternsView => 'الأنماط';

  @override
  String get goodIntensity => 'شدة جيدة';

  @override
  String get veryGoodIntensity => 'شدة جيدة جداً';

  @override
  String get noMoodRecorded => 'لا يوجد مزاج مسجل';

  @override
  String get goodMorning => 'صباح الخير!';

  @override
  String get howAreYouFeelingToday => 'كيف تشعر اليوم؟';

  @override
  String get todayYoureFeeling => 'اليوم تشعر';

  @override
  String get addAnother => 'إضافة آخر';

  @override
  String get earlierToday => 'في وقت سابق اليوم';

  @override
  String get struggling => 'تكافح';

  @override
  String get down => 'منخفض';

  @override
  String get wantToShareMoreDetails => 'هل تريد مشاركة المزيد من التفاصيل؟';

  @override
  String get guidedCheckIn => 'فحص موجه';

  @override
  String get detailedEntry => 'مدخلة مفصلة';

  @override
  String get quickInsights => 'رؤى سريعة';

  @override
  String get recentMoods => 'الأمزجة الحديثة';

  @override
  String get noInsightsYet => 'لا توجد رؤى بعد';

  @override
  String get trackYourMoodForAWeek => 'تتبع مزاجك لمدة أسبوع لرؤية الرؤى';

  @override
  String get daysStreak => 'أيام متتالية';

  @override
  String get moodBuddyFeelingSad => 'هل تشعر بالحزن؟';

  @override
  String get moodBuddyTipSad => 'جرب نزهة لطيفة أو استمع إلى موسيقى هادئة';

  @override
  String get moodBuddyFeelingDown => 'هل تشعر بالانخفاض؟';

  @override
  String get moodBuddyTipDown => 'تواصل مع صديق أو مارس التنفس العميق';

  @override
  String get moodBuddyFeelingOkay => 'هل تشعر بالرضا؟';

  @override
  String get moodBuddyTipOkay => 'حافظ على التوازن مع تمرين خفيف أو هوايات';

  @override
  String get moodBuddyFeelingGood => 'هل تشعر بالرضا؟';

  @override
  String get moodBuddyTipGood => 'شارك إيجابيتك وساعد الآخرين';

  @override
  String get moodBuddyFeelingGreat => 'هل تشعر بالرائع؟';

  @override
  String get moodBuddyTipGreat => 'وجّه هذه الطاقة في مشاريع إبداعية';

  @override
  String get moodPatternsTitle => 'أنماطك المزاجية';

  @override
  String get moodPatternsSubtitle => 'اكتشف الاتجاهات في رفاهيتك العاطفية';

  @override
  String get moodSuggestionsTitle => 'اقتراحات مخصصة';

  @override
  String get moodSuggestionsSubtitle => 'توصيات مدعومة بالذكاء الاصطناعي بناءً على مزاجك';

  @override
  String get veryBadIntensity => 'شدة سيئة جداً';

  @override
  String get badIntensity => 'شدة سيئة';

  @override
  String get neutralIntensity => 'شدة محايدة';

  @override
  String get insightGenerallyPositive => 'إيجابي بشكل عام 😊';

  @override
  String get insightNeedsSupport => 'يحتاج دعم 🤗';

  @override
  String get insightGreatConsistency => 'اتساق رائع! 🔥';

  @override
  String get insightMissingToday => 'مفقود اليوم 📝';

  @override
  String get pleaseTryAgainLater => 'يرجى المحاولة مرة أخرى لاحقاً';

  @override
  String icon(Object icon) {
    return 'الأيقونة: $icon';
  }

  @override
  String get categories => 'الفئات';

  @override
  String get searchCategories => 'البحث عن الفئات...';

  @override
  String get keyInsights => 'رؤى رئيسية';

  @override
  String get patternAnalysis => 'تحليل الأنماط';

  @override
  String get aiPredictions => 'تنبؤات الذكاء الاصطناعي';

  @override
  String get positiveTrend => 'اتجاه إيجابي';

  @override
  String get yourOverallMoodIsGenerallyPositive => 'مزاجك العام إيجابي بشكل عام';

  @override
  String get supportNeeded => 'دعم مطلوب';

  @override
  String get youMightBenefitFromAdditionalSupport => 'قد تستفيد من دعم إضافي';

  @override
  String get greatConsistency => 'اتساق رائع';

  @override
  String youveBeenTrackingYourMoodForDays(Object days) {
    return 'كنت تتتبع مزاجك لمدة $days يوم';
  }

  @override
  String get missingToday => 'مفقود اليوم';

  @override
  String get youHaventLoggedYourMoodTodayYet => 'لم تقم بتسجيل مزاجك اليوم بعد';

  @override
  String get recentImprovement => 'تحسن حديث';

  @override
  String get yourMoodHasBeenImprovingLately => 'مزاجك كان يتحسن مؤخراً';

  @override
  String get challengingPeriod => 'فترة صعبة';

  @override
  String get recentEntriesSuggestAChallengingTime => 'المدخلات الحديثة تشير إلى وقت صعب';

  @override
  String get moreDataNeeded => 'بيانات أكثر مطلوبة';

  @override
  String get trackYourMoodForAWeekToGetAIPredictions => 'تتبع مزاجك لمدة أسبوع للحصول على تنبؤات الذكاء الاصطناعي';

  @override
  String get positiveOutlook => 'نظرة إيجابية';

  @override
  String get basedOnRecentPatternsTomorrowLooksPromising => 'بناءً على الأنماط الحديثة، يبدو الغد واعداً';

  @override
  String get selfCareRecommended => 'رعاية الذات موصى بها';

  @override
  String get considerPrioritizingSelfCareActivitiesTomorrow => 'فكر في إعطاء الأولوية لأنشطة رعاية الذات غداً';

  @override
  String get balancedDayAhead => 'يوم متوازن قادم';

  @override
  String get tomorrowShouldBeATypicalDayForYou => 'يجب أن يكون الغد يوماً نموذجياً لك';

  @override
  String get errorTitle => 'أوبس! حدث خطأ ما';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get errorLoadingTasks => 'خطأ في تحميل المهام';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String deleteTaskConfirmation(String task, Object taskTitle) {
    return 'هل أنت متأكد من أنك تريد حذف \"$taskTitle\"؟';
  }

  @override
  String get delete => 'حذف';

  @override
  String get search => 'بحث';

  @override
  String get options => 'خيارات';

  @override
  String get filtersAppliedSuccessfully => 'تم تطبيق الفلاتر بنجاح';

  @override
  String get closeSearch => 'إغلاق البحث';

  @override
  String get adminPanel => 'لوحة الإدارة';

  @override
  String get premium => 'مميز';

  @override
  String get dashboardOverview => 'لوحة المعلومات والنظرة العامة';

  @override
  String get statisticsAnalytics => 'الإحصاءات والتحليلات';

  @override
  String get focusTimeManagement => 'التركيز وإدارة الوقت';

  @override
  String get organizeManage => 'تنظيم وإدارة';

  @override
  String get wellnessEmotions => 'الرفاهية والعواطف';

  @override
  String get preferencesConfiguration => 'التفضيلات والتكوين';

  @override
  String get about => 'حول';

  @override
  String get appInformationHelp => 'معلومات التطبيق والمساعدة';

  @override
  String get biweekly => 'كل أسبوعين';

  @override
  String get monthly => 'شهري';

  @override
  String get repeatForever => '(إلى الأبد)';

  @override
  String repeatUntil(Object date) {
    return 'حتى $date';
  }

  @override
  String repeatCount(Object count) {
    return '($count مرات)';
  }

  @override
  String onDays(Object days) {
    return 'في $days';
  }

  @override
  String get recurringTaskGenerationFailed => 'فشل إنشاء المهمة المتكررة';

  @override
  String get recurringTaskRetry => 'إعادة المحاولة';

  @override
  String get recurringTaskRetryLater => 'إعادة المحاولة لاحقاً';

  @override
  String bulkGenerationComplete(String count) {
    return 'تم إنشاء $count حالات متكررة';
  }

  @override
  String recurringTaskNotification(String title) {
    return 'تم إنشاء مهمة متكررة: $title';
  }

  @override
  String recurringTaskError(String error) {
    return 'خطأ في المهمة المتكررة: $error';
  }

  @override
  String get signingIn => 'جاري تسجيل الدخول..';

  @override
  String get yourPersonalTaskManager => 'مدير المهام الشخصي الخاص بك';

  @override
  String get bySigningInYouAgree => 'بتسجيل الدخول، أنت توافق على شروط الخدمة وسياسة الخصوصية';

  @override
  String get authenticationServiceNotAvailable => 'خدمة المصادقة غير متاحة. يرجى المحاولة مرة أخرى.';

  @override
  String get anErrorOccurredPleaseTryAgain => 'حدث خطأ. يرجى المحاولة مرة أخرى.';

  @override
  String get or => 'أو';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get register => 'تسجيل';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get passwordResetFunctionality => 'وظيفة إعادة تعيين كلمة المرور سيتم تنفيذها قريباً. يرجى الاتصال بالدعم للحصول على المساعدة.';

  @override
  String get ok => 'موافق';

  @override
  String get smartSortingConsidersTimeOfDayEnergyLevelsAndPatterns => 'الفرز الذكي يأخذ في الاعتبار وقت اليوم ومستويات الطاقة والأنماط';

  @override
  String get youCanOverrideWithManualSortingAnytime => 'يمكنك تجاوز الفرز اليدوي في أي وقت';

  @override
  String get trySortingTasksWithSmartSortOption => 'جرب فرز المهام بخيار \"الفرز الذكي\"';

  @override
  String get adaptivePomodoro => 'بومودورو التكيفي';

  @override
  String get adaptivePomodoroDescription => 'جلسات تركيز تتكيف مع أدائك';

  @override
  String get sessionTimingAdjustsBasedOnYourFocusPatterns => 'تتعدل توقيت الجلسة بناءً على أنماط التركيز الخاصة بك';

  @override
  String get breakSuggestionsMatchYourCurrentEnergyLevel => 'تطابق اقتراحات الاستراحة مستوى طاقتك الحالي';

  @override
  String get productivityInsightsHelpYouOptimizeWorkSessions => 'رؤى الإنتاجية تساعدك على تحسين جلسات العمل';

  @override
  String get achievementSystemKeepsYouMotivated => 'نظام الإنجاز يبقيك متحفزًا';

  @override
  String get startAPomodoroSessionToSeeAdaptiveTiming => 'ابدأ جلسة بومودورو لرؤية التوقيت التكيفي';

  @override
  String get energyAwarePlanning => 'التخطيط المدرك للطاقة';

  @override
  String get energyAwarePlanningDescription => 'جدولة المهام بناءً على أنماط الطاقة';

  @override
  String get morningPeakBestForComplexTasks => 'ذروة الصباح: الأفضل للمهام المعقدة';

  @override
  String get afternoonSteadyGoodForRoutineWork => 'فترة ما بعد الظهر: جيدة للعمل الروتيني';

  @override
  String get eveningDeclineLightTasksAndPlanning => 'انخفاض المساء: مهام خفيفة والتخطيط';

  @override
  String get energyTrackingHelpsIdentifyYourPatterns => 'تتبع الطاقة يساعد في تحديد أنماطك';

  @override
  String get checkYourEnergyLevelsThroughoutTheDay => 'تحقق من مستويات طاقتك طوال اليوم';

  @override
  String get analyticsDashboard => 'لوحة التحليلات';

  @override
  String get analyticsDashboardDescription => 'رؤى عميقة في إنتاجيتك';

  @override
  String get trackFocusPatternsAndSessionPerformance => 'تتبع أنماط التركيز وأداء الجلسة';

  @override
  String get identifyYourMostProductiveTimes => 'حدد أوقاتك الأكثر إنتاجية';

  @override
  String get monitorMoodAndEnergyCorrelations => 'راقب ارتباطات المزاج والطاقة';

  @override
  String get getPersonalizedProductivityTips => 'احصل على نصائح إنتاجية مخصصة';

  @override
  String get exploreYourAnalyticsDashboard => 'استكشف لوحة التحليلات الخاصة بك';

  @override
  String get tutorialCompletedYoureAllSetToUseSmartFeatures => 'اكتمل البرنامج التعليمي! أنت جاهز لاستخدام الميزات الذكية.';

  @override
  String get errorCompletingTutorial => 'خطأ في إكمال البرنامج التعليمي';

  @override
  String get accessDenied => 'الوصول مرفوض';

  @override
  String get youDoNotHaveAdminPrivileges => 'ليس لديك صلاحيات المدير.';

  @override
  String get activity => 'نشاط';

  @override
  String get descriptionOfActivity => 'وصف النشاط';

  @override
  String get noUsersFound => 'لم يتم العثور على مستخدمين';

  @override
  String get toggleAdminStatus => 'تبديل حالة المدير';

  @override
  String areYouSureYouWantToToggleAdminRights(Object action, Object userName) {
    return 'هل أنت متأكد من أنك تريد $action $userName؟';
  }

  @override
  String get removeAdminRightsFrom => 'إزالة صلاحيات المدير من';

  @override
  String get grantAdminRightsTo => 'منح صلاحيات المدير لـ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String errorUpdatingUser(Object error) {
    return 'خطأ في تحديث المستخدم: $error';
  }

  @override
  String get deleteUser => 'حذف المستخدم';

  @override
  String areYouSureYouWantToDeleteUser(Object userName) {
    return 'هل أنت متأكد من أنك تريد حذف $userName؟\n\nسيتم حذف ما يلي بشكل دائم:\n• حساب المستخدم\n• جميع المهام\n• جميع الفئات\n• جميع المزاج\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String userAndAllAssociatedDataDeletedSuccessfully(Object userName) {
    return 'تم حذف $userName وكل البيانات المرتبطة بنجاح';
  }

  @override
  String errorDeletingUser(Object error) {
    return 'خطأ في حذف المستخدم: $error';
  }

  @override
  String email(Object email) {
    return 'البريد الإلكتروني: $email';
  }

  @override
  String admin(Object isAdmin) {
    return 'مدير: $isAdmin';
  }

  @override
  String updated(Object date) {
    return 'تم التحديث: $date';
  }

  @override
  String birthday(Object birthday) {
    return 'عيد الميلاد: $birthday';
  }

  @override
  String errorUpdatingTask(Object error) {
    return 'خطأ في تحديث المهمة: $error';
  }

  @override
  String areYouSureYouWantToDeleteTask(Object taskTitle) {
    return 'هل أنت متأكد من أنك تريد حذف \"$taskTitle\"؟';
  }

  @override
  String taskDeletedSuccessfully(Object taskTitle) {
    return 'تم حذف $taskTitle بنجاح';
  }

  @override
  String errorDeletingTask(Object error) {
    return 'خطأ في حذف المهمة: $error';
  }

  @override
  String description(Object description) {
    return 'الوصف: $description';
  }

  @override
  String completed(Object isCompleted) {
    return 'مكتمل: $isCompleted';
  }

  @override
  String userId(Object userId) {
    return 'معرف المستخدم: $userId';
  }

  @override
  String get noCategoriesFound => 'لم يتم العثور على فئات';

  @override
  String get tasks => 'المهام';

  @override
  String get selectIcon => 'اختر الأيقونة';

  @override
  String get errorCreatingCategory => 'خطأ في إنشاء الفئة';

  @override
  String get categoryCreatedSuccessfully => 'تم إنشاء الفئة بنجاح';

  @override
  String get categoryUpdatedSuccessfully => 'تم تحديث الفئة بنجاح';

  @override
  String areYouSureYouWantToDeleteCategory(Object categoryName) {
    return 'هل أنت متأكد من حذف \"$categoryName\"؟\n\nملاحظة: إذا كانت هذه الفئة مستخدمة من قبل أي مهام، فسيفشل الحذف. يرجى إعادة تعيين تلك المهام أولاً.';
  }

  @override
  String categoryDeletedSuccessfully(Object categoryName) {
    return 'تم حذف الفئة \"$categoryName\" بنجاح';
  }

  @override
  String errorDeletingCategory(Object error) {
    return 'خطأ في حذف الفئة: $error';
  }

  @override
  String get na => 'غير متوفر';

  @override
  String get loadingPreferences => 'جاري تحميل التفضيلات...';

  @override
  String get oneHour => 'ساعة واحدة';

  @override
  String get threeHours => '3 ساعات';

  @override
  String get achievementUnlocks => 'فتح الإنجازات';

  @override
  String get systemUpdates => 'تحديثات النظام';

  @override
  String get notificationSounds => 'أصوات الإشعارات';

  @override
  String get scheduleDnd => 'جدولة عدم الإزعاج';

  @override
  String get enableSmartNotifications => 'تفعيل الإشعارات الذكية';

  @override
  String get smartNotificationsDescription => 'ضبط توقيت الإشعارات تلقائياً بناءً على أنماط نشاطك';

  @override
  String get priorityNotifications => 'الإشعارات ذات الأولوية';

  @override
  String get priorityNotificationsDescription => 'عرض الإشعارات ذات الأولوية العالية فقط خلال وقت التركيز';

  @override
  String get quietHours => 'ساعات هادئة';

  @override
  String get quietHoursDescription => 'كتم جميع الإشعارات مؤقتاً';

  @override
  String get notificationChannels => 'قنوات الإشعارات';

  @override
  String get pushNotifications => 'الإشعارات الفورية';

  @override
  String get emailNotifications => 'إشعارات البريد الإلكتروني';

  @override
  String get inAppNotifications => 'الإشعارات داخل التطبيق';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get quickEdit => 'تعديل سريع';

  @override
  String get clear => 'مسح';

  @override
  String noTasksFoundForSearch(Object searchQuery) {
    return 'لم يتم العثور على مهام لـ \"$searchQuery\"';
  }

  @override
  String get addYourFirstTask => 'أضف أول مهمة لك';

  @override
  String get taskUncompleted => 'تم وضع علامة غير مكتمل على المهمة';

  @override
  String get taskUpdated => 'تم تحديث المهمة بنجاح';

  @override
  String get createYourFirstCategory => 'أنشئ أول فئة لك لتنظيم المهام';

  @override
  String get noMoodEntriesFound => 'لم يتم العثور على إدخالات مزاج';

  @override
  String get startTrackingYourMood => 'ابدأ تتبع مزاجك لرؤية الرؤى';

  @override
  String get noPomodoroSessionsFound => 'لم يتم العثور على جلسات بومودورو';

  @override
  String get startYourFirstPomodoroSession => 'ابدأ أول جلسة بومودورو لك لتعزيز الإنتاجية';

  @override
  String get noProgressData => 'لا توجد بيانات تقدم متاحة';

  @override
  String get completeTasksToSeeProgress => 'أكمل المهام لرؤية تقدمك';

  @override
  String get pending => 'معلق';

  @override
  String get inProgress => 'قيد التنفيذ';

  @override
  String get allTasks => 'جميع المهام';

  @override
  String get unableToLoadProgressData => 'غير قادر على تحميل بيانات التقدم';

  @override
  String get progressOverview => 'نظرة عامة على التقدم';

  @override
  String get tasksCompleted => 'المهام المكتملة';

  @override
  String get tasksCompletedThisWeek => 'المهام المكتملة هذا الأسبوع';

  @override
  String averageCompletionTime(Object time) {
    return 'متوسط وقت الإنجاز: $time';
  }

  @override
  String get streakDays => 'أيام المتابعة';

  @override
  String get monthlyProgress => 'التقدم الشهري';

  @override
  String get categoryBreakdown => 'تفصيل الفئات';

  @override
  String get completionRate => 'معدل الإنجاز';

  @override
  String get totalTasks => 'إجمالي المهام';

  @override
  String get pendingTasks => 'المهام المعلقة';

  @override
  String get productivityTrends => 'اتجاهات الإنتاجية';

  @override
  String get last7Days => 'آخر 7 أيام';

  @override
  String get last30Days => 'آخر 30 يوم';

  @override
  String get last90Days => 'آخر 90 يوم';

  @override
  String get noProgressDataAvailable => 'لا توجد بيانات تقدم متاحة';

  @override
  String get completeTasksToSeeYourProgress => 'أكمل المهام لرؤية تقدمك';

  @override
  String get greatProgress => 'تقدم رائع!';

  @override
  String get keepUpTheGoodWork => 'استمر في العمل الجيد';

  @override
  String get youCanDoBetter => 'يمكنك أن تفعل أفضل';

  @override
  String get tryToCompleteMoreTasks => 'حاول إنجاز المزيد من المهام';

  @override
  String get excellentPerformance => 'أداء ممتاز!';

  @override
  String get youAreOnARoll => 'أنت في حالة تألق!';

  @override
  String get voiceTasks => 'المهام الصوتية';

  @override
  String get startRecording => 'بدء التسجيل';

  @override
  String get tasksCreatedSuccessfully => 'تم إنشاء المهام بنجاح!';

  @override
  String get textInputComingSoon => 'إدخال النص قريباً!';

  @override
  String get recentTasksComingSoon => 'المهام الحديثة قريباً!';

  @override
  String get voiceRecording => 'التسجيل الصوتي';

  @override
  String get listening => 'الاستماع...';

  @override
  String get processing => 'المعالجة...';

  @override
  String get tapToStartRecording => 'اضغط لبدء التسجيل';

  @override
  String get recordingInProgress => 'التسجيل قيد التنفيذ';

  @override
  String get stopRecording => 'إيقاف التسجيل';

  @override
  String get errorCreatingVoiceTask => 'خطأ في إنشاء المهمة الصوتية';

  @override
  String get pleaseTryAgain => 'يرجى المحاولة مرة أخرى';

  @override
  String get noSpeechDetected => 'لم يتم اكتشاف كلام';

  @override
  String get speakClearly => 'يرجى التحدث بوضوح';

  @override
  String get voiceCommands => 'الأوامر الصوتية';

  @override
  String get showTasks => 'عرض المهام';

  @override
  String get voiceSettings => 'إعدادات الصوت';

  @override
  String get enableVoiceCommands => 'تفعيل الأوامر الصوتية';

  @override
  String get voiceLanguage => 'لغة الصوت';

  @override
  String get voiceFeedback => 'التغذية الراجعة الصوتية';

  @override
  String get autoDetectLanguage => 'الكشف التلقائي عن اللغة';

  @override
  String get voiceRecognitionAccuracy => 'دقة التعرف الصوتي';

  @override
  String get subtaskCompleted => 'تم إكمال المهمة الفرعية';

  @override
  String get subtaskUncompleted => 'تم وضع علامة غير مكتمل على المهمة الفرعية';

  @override
  String get areYouSureYouWantToDeleteSubtask => 'هل أنت متأكد من أنك تريد حذف هذه المهمة الفرعية؟';

  @override
  String get taskNotes => 'ملاحظات المهمة';

  @override
  String get addNote => 'إضافة ملاحظة';

  @override
  String get noNotes => 'لا توجد ملاحظات';

  @override
  String get taskAttachments => 'المرفقات';

  @override
  String get addAttachment => 'إضافة مرفق';

  @override
  String get noAttachments => 'لا توجد مرفقات';

  @override
  String get taskHistory => 'سجل المهمة';

  @override
  String get modified => 'تم التعديل';

  @override
  String get completedAt => 'تم الإكمال في';

  @override
  String get taskStatistics => 'إحصائيات المهمة';

  @override
  String get completionTime => 'وقت الإنجاز';

  @override
  String get categoryColor => 'لون الفئة';

  @override
  String get categoryIcon => 'أيقونة الفئة';

  @override
  String get selectColor => 'اختر اللون';

  @override
  String get categoryUpdated => 'تم تحديث الفئة بنجاح';

  @override
  String get errorUpdatingCategory => 'خطأ في تحديث الفئة';

  @override
  String categoryTasksCount(Object count) {
    return 'المهام: $count';
  }

  @override
  String get addTasksToCategory => 'أضف مهام إلى هذه الفئة';

  @override
  String get categoryStatistics => 'إحصائيات الفئة';

  @override
  String totalTasksInCategory(Object count) {
    return 'إجمالي المهام: $count';
  }

  @override
  String completedTasksInCategory(Object count) {
    return 'مكتمل: $count';
  }

  @override
  String pendingTasksInCategory(Object count) {
    return 'معلق: $count';
  }

  @override
  String overdueTasksInCategory(Object count) {
    return 'متأخر: $count';
  }

  @override
  String get categoryPerformance => 'أداء الفئة';

  @override
  String categoryEfficiency(Object score) {
    return 'الكفاءة: $score%';
  }

  @override
  String get errorCompletingOnboarding => 'خطأ في إكمال التوجيه';

  @override
  String get accessibilitySettingsAppliedSuccessfully => 'تم تطبيق إعدادات الوصول بنجاح';

  @override
  String errorApplyingSettings(Object error) {
    return 'خطأ في تطبيق الإعدادات: $error';
  }

  @override
  String get skipForNow => 'تخطي حالياً';

  @override
  String get highContrastMode => 'وضع التباين العالي';

  @override
  String get largeTextMode => 'وضع النص الكبير';

  @override
  String get reducedMotion => 'تقليل الحركة';

  @override
  String get accessibilitySetup => 'إعداد الوصول';

  @override
  String get accessibilitySetupDescription => 'خصص تجربة التطبيق الخاصة بك لسهولة الوصول الأفضل';

  @override
  String get weRecommendTheseSettings => 'نوصي بهذه الإعدادات بناءً على تفضيلاتك';

  @override
  String get youCanChangeTheseLater => 'يمكنك تغيير هذه لاحقًا في الإعدادات';

  @override
  String get applySettings => 'تطبيق الإعدادات';

  @override
  String get accessibilityCompleted => 'اكتمل إعداد الوصول';

  @override
  String get continueToApp => 'متابعة إلى التطبيق';

  @override
  String get clearAllLocalData => 'مسح جميع البيانات المحلية';

  @override
  String get thisWillPermanentlyDelete => 'سيتم حذف ما يلي بشكل دائم:';

  @override
  String get allTasksCategoriesMoodsLocalSettings => '• جميع المهام\n• جميع الفئات\n• جميع المزاج\n• جميع الإعدادات المحلية';

  @override
  String get afterDeletionTheAppWillResyncAllDataFromFirebase => 'بعد الحذف، سيعيد التطبيق مزامنة جميع البيانات من Firebase.';

  @override
  String get thisActionCannotBeUndone => 'لا يمكن التراجع عن هذا الإجراء!';

  @override
  String get deleteAllData => 'حذف جميع البيانات';

  @override
  String get forceSyncFromFirebase => 'فرض المزامنة من Firebase';

  @override
  String get thisWill => 'سيقوم هذا بـ:';

  @override
  String get downloadFreshDataOverwriteLocalChanges => '• تنزيل بيانات جديدة من Firebase\n• استبدال أي تغييرات محلية\n• تحديث جميع المستودعات';

  @override
  String get anyUnsyncedLocalChangesWillBeLost => 'ستفقد أي تغييرات محلية غير مزامنة!';

  @override
  String get forceSync => 'فرض المزامنة';

  @override
  String get clearingData => 'جاري مسح البيانات...';

  @override
  String get allDataClearedAndResyncedSuccessfully => 'تم مسح جميع البيانات وإعادة المزامنة بنجاح!';

  @override
  String get syncingFromFirebase => 'جاري المزامنة من Firebase...';

  @override
  String get dataSyncedSuccessfullyFromFirebase => 'تمت مزامنة البيانات بنجاح من Firebase!';

  @override
  String syncError(Object error) {
    return 'خطأ في المزامنة: $error';
  }

  @override
  String get developerTools => 'أدوات المطور';

  @override
  String get performanceMemoryAndQualityMonitoring => 'مراقبة الأداء والذاكرة والجودة';

  @override
  String get enablePomodoroOptimization => 'تفعيل تحسين بومودورو';

  @override
  String get automaticallyPlanWorkSessions => 'تخطيط جلسات العمل تلقائياً';

  @override
  String get suggestedPlan => 'الخطة المقترحة:';

  @override
  String get workSessions => 'جلسات عمل';

  @override
  String get minPerSession => 'دقيقة لكل جلسة';

  @override
  String totalEstimatedTime(Object minutes) {
    return 'الوقت التقديري الإجمالي: $minutes دقيقة';
  }

  @override
  String get taskTitle => 'عنوان المهمة';

  @override
  String get taskDescription => 'وصف المهمة';

  @override
  String get optional => 'اختياري';

  @override
  String get selectCategory => 'اختر الفئة';

  @override
  String get setDueDate => 'تعيين تاريخ الاستحقاق';

  @override
  String get setReminder => 'تعيين تذكير';

  @override
  String get noReminder => 'لا يوجد تذكير';

  @override
  String get setPriority => 'تعيين الأولوية';

  @override
  String get addSubtasks => 'إضافة مهام فرعية';

  @override
  String get saveTask => 'حفظ المهمة';

  @override
  String get taskCreatedSuccessfully => 'تم إنشاء المهمة بنجاح';

  @override
  String get pleaseFillAllRequiredFields => 'يرجى ملء جميع الحقول المطلوبة';

  @override
  String get taskTitleRequired => 'عنوان المهمة مطلوب';

  @override
  String get invalidDueDate => 'تاريخ استحقاق غير صالح';

  @override
  String get dueDateMustBeInFuture => 'يجب أن يكون تاريخ الاستحقاق في المستقبل';

  @override
  String focusModeFor(Object taskTitle) {
    return 'وضع التركيز لـ $taskTitle';
  }

  @override
  String get taskDuplicatedSuccessfully => 'تم تكرار المهمة بنجاح';

  @override
  String get subtaskAddedSuccessfully => 'تمت إضافة المهمة الفرعية بنجاح';

  @override
  String failedToAddSubtask(Object error) {
    return 'فشل في إضافة المهمة الفرعية: $error';
  }

  @override
  String reminderSetFor(Object date) {
    return 'تم تعيين التذكير لـ $date';
  }

  @override
  String get startFocusMode => 'بدء وضع التركيز';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get markAsCompleted => 'وضع علامة مكتمل';

  @override
  String get markAsIncomplete => 'وضع علامة غير مكتمل';

  @override
  String get taskActions => 'إجراءات المهمة';

  @override
  String get taskInformation => 'معلومات المهمة';

  @override
  String get timeTracking => 'تتبع الوقت';

  @override
  String get notes => 'الملاحظات';

  @override
  String get attachments => 'المرفقات';

  @override
  String get noDataAvailable => 'لا توجد بيانات متاحة';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get galleryPermissionIsRequiredToSelectProfileImage => 'إذن المعرض مطلوب لاختيار صورة الملف الشخصي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get profilePicture => 'صورة الملف الشخصي';

  @override
  String get changeProfilePicture => 'تغيير صورة الملف الشخصي';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get chooseFromGallery => 'اختر من المعرض';

  @override
  String get removePhoto => 'إزالة الصورة';

  @override
  String get personalInformation => 'المعلومات الشخصية';

  @override
  String get name => 'الاسم';

  @override
  String get phone => 'الهاتف';

  @override
  String get bio => 'السيرة الذاتية';

  @override
  String get tellUsAboutYourself => 'أخبرنا عن نفسك';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get security => 'الأمان';

  @override
  String get helpAndSupport => 'المساعدة والدعم';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get profileUpdatedSuccessfully => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get errorUpdatingProfile => 'خطأ في تحديث الملف الشخصي';

  @override
  String get profilePictureUpdatedSuccessfully => 'تم تحديث صورة الملف الشخصي بنجاح';

  @override
  String get errorUpdatingProfilePicture => 'خطأ في تحديث صورة الملف الشخصي';

  @override
  String get aboutTazbeet => 'حول تطبيق تزبيت';

  @override
  String get appDescription => 'تطبيق إدارة مهام ذكي مع تكامل بومودورو وتوصيات مدعومة بالذكاء الاصطناعي.';

  @override
  String get features => 'المميزات:';

  @override
  String get smartTaskSortingWithAiRecommendations => '• فرز المهام الذكي مع توصيات الذكاء الاصطناعي';

  @override
  String get pomodoroTimerWithAdaptiveTiming => '• مؤقت بومودورو مع توقيت متكيف';

  @override
  String get analyticsAndProductivityInsights => '• تحليلات ورؤى الإنتاجية';

  @override
  String get moodTrackingAndAmbientSettings => '• تتبع المزاج والإعدادات المحيطة';

  @override
  String get recurringTaskAutomation => '• أتمتة المهام المتكررة';

  @override
  String get welcomeToTazbeet => 'مرحباً بك في تطبيق Tazbeet';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get exploreFeatures => 'استكشف المميزات';

  @override
  String get viewAllTasks => 'عرض جميع المهام';

  @override
  String get createYourFirstTaskToGetStarted => 'أنشئ أول مهمة لك للبدء';

  @override
  String get searchTasks => 'البحث في المهام...';

  @override
  String get filterTasks => 'تصفية المهام';

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get tryDifferentFilters => 'جرب فلاتر أو مصطلحات بحث مختلفة';

  @override
  String errorLoadingAnalytics(Object error) {
    return 'خطأ في تحميل التحليلات: $error';
  }

  @override
  String weeklyProgressOf(Object goal, Object progress) {
    return '$progress من $goal جلسة';
  }

  @override
  String get recommendedAdjustments => 'التعديلات الموصى بها:';

  @override
  String get noRecommendationsAvailableAtThisTime => 'لا توجد توصيات متاحة في هذا الوقت.';

  @override
  String get pomodoroAnalytics => 'تحليلات بومودورو';

  @override
  String get weeklyStats => 'إحصائيات أسبوعية';

  @override
  String get monthlyStats => 'إحصائيات شهرية';

  @override
  String get allTimeStats => 'إحصائيات جميع الأوقات';

  @override
  String get totalSessions => 'إجمالي الجلسات';

  @override
  String get completedSessions => 'الجلسات المكتملة';

  @override
  String get averageSessionLength => 'متوسط طول الجلسة';

  @override
  String get totalFocusTime => 'إجمالي وقت التركيز';

  @override
  String get bestPerformanceDay => 'أفضل أداء يوم';

  @override
  String get mostProductiveHour => 'أكثر ساعة إنتاجية';

  @override
  String get sessionCompletionRate => 'معدل إكمال الجلسة';

  @override
  String get focusTimeDistribution => 'توزيع وقت التركيز';

  @override
  String get breakTimeDistribution => 'توزيع وقت الراحة';

  @override
  String get recommendations => 'التوصيات';

  @override
  String get performanceMetrics => 'مقاييس الأداء';

  @override
  String get sessionHistory => 'سجل الجلسات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get shareReport => 'مشاركة التقرير';

  @override
  String get dateRange => 'نطاق التاريخ';

  @override
  String get customRange => 'نطاق مخصص';

  @override
  String defaultValue(Object isDefault) {
    return 'افتراضي: $isDefault';
  }

  @override
  String get editMaintenanceMessage => 'تحرير رسالة الصيانة';

  @override
  String get blockAllNonAdminUsers => '• حظر جميع المستخدمين غير المسؤولين';

  @override
  String get showMaintenanceScreenToUsers => '• إظهار شاشة الصيانة للمستخدمين';

  @override
  String get onlyAdminsCanAccessTheApp => '• فقط المديرون يمكنهم الوصول إلى التطبيق';

  @override
  String get allowAllUsersToAccessTheApp => '• السماح لجميع المستخدمين بالوصول إلى التطبيق';

  @override
  String get returnToNormalOperation => '• العودة إلى التشغيل الطبيعي';

  @override
  String get maintenanceMode => 'وضع الصيانة';

  @override
  String get maintenanceModeDescription => 'ضع التطبيق في وضع الصيانة';

  @override
  String get maintenanceMessage => 'رسالة الصيانة';

  @override
  String get enterMaintenanceMessage => 'أدخل رسالة الصيانة';

  @override
  String get saveMaintenanceSettings => 'حفظ إعدادات الصيانة';

  @override
  String get maintenanceSettingsSaved => 'تم حفظ إعدادات الصيانة بنجاح';

  @override
  String get errorSavingMaintenanceSettings => 'خطأ في حفظ إعدادات الصيانة';

  @override
  String get viewDetailsButton => 'عرض التفاصيل';

  @override
  String get quickEditButton => 'تعديل سريع';

  @override
  String get clearButton => 'مسح';

  @override
  String get searchButton => 'بحث';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get resetToDefaults => 'إعادة تعيين إلى الافتراضي';

  @override
  String get resetAllThemeSettingsToDefaultValues => 'إعادة تعيين جميع إعدادات السمة إلى القيم الافتراضية';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get resetThemeSettings => 'إعادة تعيين إعدادات السمة';

  @override
  String get thisWillResetAllThemeSettingsToTheirDefaultValues => 'سيؤدي هذا إلى إعادة تعيين جميع إعدادات السمة إلى قيمها الافتراضية. يمكنك دائماً تغييرها لاحقاً.';

  @override
  String get themeSettingsResetToDefaults => 'تم إعادة تعيين إعدادات السمة إلى الافتراضي';

  @override
  String get themeSettings => 'إعدادات السمة';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get systemMode => 'وضع النظام';

  @override
  String get followSystemSettings => 'اتباع إعدادات النظام';

  @override
  String get useDarkTheme => 'استخدام السمة الداكنة';

  @override
  String get useLightTheme => 'استخدام السمة الفاتحة';

  @override
  String get colorTheme => 'سمة اللون';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundColor => 'لون الخلفية';

  @override
  String get surfaceColor => 'لون السطح';

  @override
  String get textColor => 'لون النص';

  @override
  String get enableCustomColors => 'تفعيل الألوان المخصصة';

  @override
  String get customColorSettings => 'إعدادات الألوان المخصصة';

  @override
  String get selectPrimaryColor => 'اختر اللون الأساسي';

  @override
  String get selectAccentColor => 'اختر لون التمييز';

  @override
  String get selectBackgroundColor => 'اختر لون الخلفية';

  @override
  String get selectSurfaceColor => 'اختر لون السطح';

  @override
  String get selectTextColor => 'اختر لون النص';

  @override
  String get colorPicker => 'منتقي الألوان';

  @override
  String get chooseColor => 'اختر اللون';

  @override
  String get selectedColor => 'اللون المحدد';

  @override
  String get applyColors => 'تطبيق الألوان';

  @override
  String get resetColors => 'إعادة تعيين الألوان';

  @override
  String get colorSettingsSaved => 'تم حفظ إعدادات الألوان بنجاح';

  @override
  String get errorSavingColorSettings => 'خطأ في حفظ إعدادات الألوان';

  @override
  String get noMoodHistoryAvailableForSuggestions => 'لا يوجد سجل مزاج متاح للاقتراحات';

  @override
  String addedSuggestedCheckInTimesFromYourMoodHistory(Object count) {
    return 'تمت إضافة $count أوقات تسجيل مقترحة من سجل مزاجك';
  }

  @override
  String get allSuggestedTimesAreAlreadyInYourList => 'جميع الأوقات المقترحة موجودة بالفعل في قائمتك';

  @override
  String failedToGetSuggestions(Object error) {
    return 'فشل في الحصول على الاقتراحات: $error';
  }

  @override
  String get testMoodNotificationSent => 'تم إرسال إشعار المزاج التجريبي!';

  @override
  String failedToSendTestNotification(Object error) {
    return 'فشل في إرسال الإشعار التجريبي: $error';
  }

  @override
  String get pendingMoodNotifications => 'إشعارات المزاج المعلقة';

  @override
  String moodNotificationsScheduledTotalPending(Object count, Object pending) {
    return '$count إشعار مزاج مجدول\nالإجمالي المعلق: $pending';
  }

  @override
  String failedToCheckPendingNotifications(Object error) {
    return 'فشل في التحقق من الإشعارات المعلقة: $error';
  }

  @override
  String get removeThisCheckInTime => 'إزالة وقت التسجيل هذا؟';

  @override
  String get receivePeriodicMoodCheckInReminders => 'تلقي تذكيرات تسجيل المزاج الدورية';

  @override
  String get testMoodNotificationScheduledFor1MinuteFromNow => 'تم جدولة إشعار المزاج التجريبي بعد دقيقة واحدة من الآن!';

  @override
  String failedToScheduleTestNotification(Object error) {
    return 'فشل في جدولة الإشعار التجريبي: $error';
  }

  @override
  String get testScheduledNotification => 'اختبار الإشعار المجدول';

  @override
  String failedToCancelNotifications(Object error) {
    return 'فشل في إلغاء الإشعارات: $error';
  }

  @override
  String get moodSettings => 'إعدادات المزاج';

  @override
  String get notificationTimes => 'أوقات الإشعارات';

  @override
  String get addNotificationTime => 'إضافة وقت الإشعار';

  @override
  String get selectTime => 'اختر الوقت';

  @override
  String get suggestedTimes => 'الأوقات المقترحة';

  @override
  String get getSuggestionsFromHistory => 'الحصول على اقتراحات من السجل';

  @override
  String get notificationTools => 'أدوات الإشعارات';

  @override
  String get noCheckInTimesSetAddOneToGetStarted => 'لا توجد أوقات تسجيل محددة. أضف واحداً للبدء!';

  @override
  String get pomodoroPlanning => 'تخطيط بومودورو';

  @override
  String focusDifficulty(Object score) {
    return 'صعوبة التركيز: $score';
  }

  @override
  String get easyFocusDeepFocusRequired => '1 = تركيز سهل، 10 = تركيز عميق مطلوب';

  @override
  String get priorityTitle => 'الأولوية';

  @override
  String get galleryPermissionRequired => 'إذن المعرض مطلوب لتحديد صورة الملف الشخصي';

  @override
  String get authenticationErrorPleaseLogInAgain => 'خطأ في المصادقة. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get tryAdjustingYourSearchTerms => 'حاول تعديل شروط البحث';

  @override
  String get defaultLabel => 'افتراضي';

  @override
  String get defaultCategory => 'الفئة الافتراضية';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get refreshData => 'تحديث البيانات';

  @override
  String get recentActivity => 'النشاط الأخير';

  @override
  String defaultYes(Object value) {
    return 'افتراضي: $value';
  }

  @override
  String get appSettings => 'إعدادات التطبيق';

  @override
  String get generalSettings => 'الإعدادات العامة';

  @override
  String get userRegistration => 'تسجيل المستخدمين';

  @override
  String get newUsersCanRegister => 'يمكن للمستخدمين الجدد التسجيل';

  @override
  String get registrationIsDisabled => 'التسجيل معطل';

  @override
  String get appInformation => 'معلومات التطبيق';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get supportEmail => 'بريد الدعم';

  @override
  String get lastUpdated => 'آخر تحديث';

  @override
  String get message => 'الرسالة';

  @override
  String get enterMessageUsersWillSee => 'أدخل الرسالة التي سيراها المستخدمون...';

  @override
  String maintenanceModeConfirmation(Object action, Object details) {
    return 'هل أنت متأكد من $action وضع الصيانة؟\n\n$details';
  }

  @override
  String get onlyAdminsCanAccessApp => '• يمكن للمسؤولين فقط الوصول إلى التطبيق';

  @override
  String get allowAllUsersToAccessApp => '• السماح لجميع المستخدمين بالوصول إلى التطبيق';

  @override
  String get enableMaintenanceMode => 'تفعيل وضع الصيانة';

  @override
  String get disableMaintenanceMode => 'تعطيل وضع الصيانة';

  @override
  String get disable => 'تعطيل';

  @override
  String get refresh => 'تحديث';

  @override
  String get performanceMonitor => 'مراقب الأداء';

  @override
  String trackedOperations(Object count) {
    return 'العمليات المتتبعة: $count';
  }

  @override
  String slowOperations(Object count) {
    return 'العمليات البطيئة (>500 مللي ثانية): $count';
  }

  @override
  String get logReport => 'تسجيل التقرير';

  @override
  String get memoryManager => 'مدير الذاكرة';

  @override
  String get forceCleanup => 'فرض التنظيف';

  @override
  String get logStats => 'تسجيل الإحصائيات';

  @override
  String get animationOptimizer => 'محسن الرسوم المتحركة';

  @override
  String get codeQualityMonitor => 'مراقب جودة الكود';

  @override
  String get qualityScore => 'درجة الجودة: ';

  @override
  String get notificationVerification => 'التحقق من الإشعارات';

  @override
  String get checkPending => 'فحص المعلق';

  @override
  String get verifyAllTasks => 'تحقق من جميع المهام';

  @override
  String get actions => 'الإجراءات';

  @override
  String get clearPerformance => 'مسح الأداء';

  @override
  String get clearQuality => 'مسح الجودة';

  @override
  String get performanceReportLoggedToConsole => 'تم تسجيل تقرير الأداء في وحدة التحكم';

  @override
  String get memoryCleanupCompleted => 'تم تنظيف الذاكرة';

  @override
  String get memoryStatsLoggedToConsole => 'تم تسجيل إحصائيات الذاكرة في وحدة التحكم';

  @override
  String get animationStatsLoggedToConsole => 'تم تسجيل إحصائيات الرسوم المتحركة في وحدة التحكم';

  @override
  String get qualityReportLoggedToConsole => 'تم تسجيل تقرير الجودة في وحدة التحكم';

  @override
  String get performanceMetricsCleared => 'تم مسح مقاييس الأداء';

  @override
  String get qualityMetricsCleared => 'تم مسح مقاييس الجودة';

  @override
  String get dataManagement => 'إدارة البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get backupAndRestore => 'النسخ الاحتياطي والاستعادة';

  @override
  String get exportYourTasksToExternalFormats => 'تصدير مهامك إلى تنسيقات خارجية';

  @override
  String get exportCSV => 'تصدير CSV';

  @override
  String get exportJSON => 'تصدير JSON';

  @override
  String get exportICSCalendar => 'تصدير ICS (التقويم)';

  @override
  String get importTasksFromExternalFiles => 'استيراد المهام من ملفات خارجية';

  @override
  String get importFromFile => 'استيراد من ملف';

  @override
  String get createAndRestoreBackups => 'إنشاء واستعادة النسخ الاحتياطية';

  @override
  String get createBackup => 'إنشاء نسخة احتياطية';

  @override
  String get restoreBackup => 'استعادة نسخة احتياطية';

  @override
  String get notificationDeleted => 'تم حذف الإشعار';

  @override
  String get clearHistory => 'مسح السجل';

  @override
  String get areYouSureYouWantToClearAllNotificationHistory => 'هل أنت متأكد من مسح سجل جميع الإشعارات؟';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get historyCleared => 'تم مسح السجل';

  @override
  String get smartFeaturesTutorial => 'دليل الميزات الذكية';

  @override
  String get previous => 'السابق';

  @override
  String get completeTutorial => 'إكمال الدليل';

  @override
  String get customizeYourExperience => 'تخصيص تجربتك';

  @override
  String get adjustTheseSettingsToMakeTheAppWorkBetterForYou => 'اضبط هذه الإعدادات لجعل التطبيق يعمل بشكل أفضل لك';

  @override
  String get minimizeAnimationsAndTransitions => 'تقليل الرسوم المتحركة والانتقالات';

  @override
  String get controlTheAppWithYourVoice => 'تحكم في التطبيق بصوتك';

  @override
  String get increaseColorContrastForBetterVisibility => 'زيادة تباين الألوان لرؤية أفضل';

  @override
  String get makeTextLargerAndEasierToRead => 'جعل النص أكبر وأسهل في القراءة';

  @override
  String get needHelp => 'تحتاج مساعدة؟';

  @override
  String get enableVoiceTasks => 'تفعيل المهام الصوتية';

  @override
  String get createTasksWithYourVoice => 'إنشاء مهام بصوتك';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get thankYouForYourPatience => 'شكراً لصبرك 💙';

  @override
  String get moodAlreadyLoggedToday => 'لقد قمت بتسجيل مزاجك بالفعل اليوم';

  @override
  String get updateTodaysEntryInstead => 'يمكنك تحديث إدخال اليوم بدلاً من ذلك';

  @override
  String get viewAndUpdateMood => 'عرض وتحديث المزاج';

  @override
  String get okButton => 'موافق';

  @override
  String get yourIntelligentTaskManagementCompanionWithAIPoweredFeatures => 'رفيقك الذكي لإدارة المهام مع ميزات تعمل بالذكاء الاصطناعي';

  @override
  String get smartTaskSorting => 'الفرز الذكي للمهام';

  @override
  String get experienceAIPoweredTaskPrioritizationThatAdaptsToYourPatterns => 'تجربة أولويات المهام المدعومة بالذكاء الاصطناعي التي تتكيف مع أنماطك';

  @override
  String get pomodoroIntegration => 'تكامل تقنية البومودورو';

  @override
  String get focusBetterWithAdaptiveTimingAndSmartBreaks => 'ركز بشكل أفضل مع التوقيت التكيفي والاستراحات الذكية';

  @override
  String get moodEnergyTracking => 'تتبع المزاج والطاقة';

  @override
  String get understandYourPatternsAndOptimizeYourProductivity => 'افهم أنماطك وحسن إنتاجيتك';

  @override
  String get accessibilityFeatures => 'ميزات الوصول';

  @override
  String get customizeTheAppToWorkBestForYou => 'خصص التطبيق ليعمل بشكل أفضل لك';

  @override
  String get viewAndUpdateTodaysMoodEntry => 'هل ترغب في عرض وتحديث إدخال المزاج اليوم؟';

  @override
  String hiveBoxes(Object count) {
    return 'صناديق Hive: $count';
  }

  @override
  String status(Object status) {
    return 'الحالة: $status';
  }

  @override
  String pendingNotifications(Object count) {
    return 'الإشعارات المعلقة: $count';
  }

  @override
  String get verificationReportLoggedToConsole => 'تم تسجيل تقرير التحقق في وحدة التحكم';

  @override
  String get performanceMonitoring => 'مراقبة الأداء';

  @override
  String get memoryManagement => 'إدارة الذاكرة';

  @override
  String get animationOptimization => 'تحسين الرسوم المتحركة';

  @override
  String get codeQuality => 'جودة الكود';

  @override
  String get dataSync => 'مزامنة البيانات';

  @override
  String get clearAllMetrics => 'مسح جميع المقاييس';

  @override
  String get developerOptions => 'خيارات المطور';

  @override
  String get debugMode => 'وضع التصحيح';

  @override
  String get enableDebugMode => 'تفعيل وضع التصحيح';

  @override
  String get disableDebugMode => 'تعطيل وضع التصحيح';

  @override
  String get debugModeDescription => 'تفعيل التسجيل الإضافي وميزات التصحيح';

  @override
  String get memoryUsage => 'استخدام الذاكرة';

  @override
  String get databaseSize => 'حجم قاعدة البيانات';

  @override
  String get cacheSize => 'حجم ذاكرة التخزين المؤقت';

  @override
  String get networkRequests => 'طلبات الشبكة';

  @override
  String get errorTracking => 'تتبع الأخطاء';

  @override
  String get logLevel => 'مستوى التسجيل';

  @override
  String get verbose => 'مفصل';

  @override
  String get debug => 'تصحيح';

  @override
  String get info => 'معلومات';

  @override
  String get warning => 'تحذير';

  @override
  String get none => 'لا شيء';

  @override
  String get exportLogs => 'تصدير السجلات';

  @override
  String get importLogs => 'استيراد السجلات';

  @override
  String get clearLogs => 'مسح السجلات';

  @override
  String get logsExported => 'تم تصدير السجلات بنجاح';

  @override
  String get logsImported => 'تم استيراد السجلات بنجاح';

  @override
  String get logsCleared => 'تم مسح السجلات بنجاح';

  @override
  String get errorExportingLogs => 'خطأ في تصدير السجلات';

  @override
  String get errorImportingLogs => 'خطأ في استيراد السجلات';

  @override
  String get errorClearingLogs => 'خطأ في مسح السجلات';
}
