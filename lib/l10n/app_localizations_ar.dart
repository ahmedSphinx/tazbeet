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
  String get pickAColor => 'اختر لوناً';

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
  String get low => 'منخفض';

  @override
  String get high => 'عالي';

  @override
  String get moodNoteOptional => 'ملاحظة (اختيارية)';

  @override
  String get moodNoteHint => 'أضف ملاحظة عن مزاجك...';

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
  String get profile => 'الحساب الشخصي';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get noTasksYet => 'لا توجد مهام بعد';

  @override
  String get noTasksInCategory => 'لا توجد مهام في هذه الفئة';

  @override
  String get addTaskToGetStarted => 'أضف مهمة للبدء';

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
  String get insights => 'الإحصائيات';

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
  String get testNotificationSent => 'تم إرسال إشعار تجريبي';

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
  String get moodCheckIns => 'تسجيلات المزاج';

  @override
  String get pomodoroNotifications => 'بومودورو';

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
  String get medium => 'متوسط';

  @override
  String get urgent => 'عاجل';

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
  String get minutes => 'دقيقة';

  @override
  String get recommendedForAdhd => 'موصى به لمن يعاني من ADHD';

  @override
  String get mostPopular => 'الأكثر شعبية';

  @override
  String get stopPomodoroConfirmation => 'هل أنت متأكد من إيقاف الجلسة الحالية؟ سيتم فقدان تقدمك.';

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
  String get icon => 'أيقونة';

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
  String get errorTitle => 'عفواً! حدث خطأ ما';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String deleteTaskConfirmation(String task) {
    return 'هل أنت متأكد من حذف \"$task\"؟';
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
  String get noRecurringTasksFound => 'لم يتم العثور على مهام متكررة';

  @override
  String get recurringTasksOptimized => 'تم تحسين المهام المتكررة للأداء';
}
