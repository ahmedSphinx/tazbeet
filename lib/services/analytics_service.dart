import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'app_logging_service.dart';

/// خدمة Firebase Analytics و Crashlytics
///
/// توفر واجهة موحدة لتتبع الأحداث، الشاشات، والأخطاء
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  late FirebaseAnalytics _analytics;
  late FirebaseCrashlytics _crashlytics;

  bool _initialized = false;
  
  /// تهيئة الخدمة
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;

      // تفعيل جمع البيانات في وضع الإصدار فقط
      await _analytics.setAnalyticsCollectionEnabled(!kDebugMode);

      // إعداد Crashlytics
      FlutterError.onError = _crashlytics.recordFlutterFatalError;

      // التقاط الأخطاء من خارج Flutter
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics.recordError(error, stack, fatal: true);
        return true;
      };

      _initialized = true;

      if (kDebugMode) {
        AppLogging.logInfo('✅ Analytics & Crashlytics initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogging.logError('❌ Failed to initialize Analytics: $e');
      }
    }
  }

  /// الحصول على FirebaseAnalytics observer للـ Navigator
  FirebaseAnalyticsObserver getAnalyticsObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }

  // ==================== تتبع الشاشات ====================

  /// تتبع عرض شاشة
  Future<void> logScreenView({required String screenName, String? screenClass}) async {
    if (!_initialized) return;

    try {
      await _analytics.logScreenView(screenName: screenName, screenClass: screenClass ?? screenName);

      if (kDebugMode) {
        AppLogging.logInfo('📊 Screen View: $screenName');
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogging.logError('❌ Failed to log screen view: $e');
      }
    }
  }

  // ==================== أحداث المهام ====================

  /// تتبع إنشاء مهمة
  Future<void> logTaskCreated({required String categoryId, required String priority, bool hasSubtasks = false, bool hasDueDate = false}) async {
    await _logEvent('task_created', parameters: {'category_id': categoryId, 'priority': priority, 'has_subtasks': hasSubtasks ? 'true' : 'false', 'has_due_date': hasDueDate ? 'true' : 'false'});
  }

  /// تتبع إكمال مهمة
  Future<void> logTaskCompleted({required String taskId, required String priority, int? completionTimeSeconds}) async {
    await _logEvent('task_completed', parameters: {'task_id': taskId, 'priority': priority, if (completionTimeSeconds != null) 'completion_time': completionTimeSeconds});
  }

  /// تتبع حذف مهمة
  Future<void> logTaskDeleted({required String taskId, required bool wasCompleted}) async {
    await _logEvent('task_deleted', parameters: {'task_id': taskId, 'was_completed': wasCompleted ? 'true' : 'false'});
  }

  /// تتبع تعديل مهمة
  Future<void> logTaskUpdated({required String taskId, List<String>? changedFields}) async {
    await _logEvent('task_updated', parameters: {'task_id': taskId, if (changedFields != null) 'changed_fields': changedFields.join(',')});
  }

  // ==================== أحداث بومودورو ====================

  /// تتبع بدء جلسة بومودورو
  Future<void> logPomodoroStarted({required int workDuration, required int breakDuration}) async {
    await _logEvent('pomodoro_started', parameters: {'work_duration': workDuration, 'break_duration': breakDuration});
  }

  /// تتبع إكمال جلسة بومودورو
  Future<void> logPomodoroCompleted({required int sessionsCompleted}) async {
    await _logEvent('pomodoro_completed', parameters: {'sessions_completed': sessionsCompleted});
  }

  /// تتبع إلغاء جلسة بومودورو
  Future<void> logPomodoroCancelled({required int remainingSeconds}) async {
    await _logEvent('pomodoro_cancelled', parameters: {'remaining_seconds': remainingSeconds});
  }

  // ==================== أحداث المزاج ====================

  /// تتبع تسجيل المزاج
  Future<void> logMoodRecorded({required String moodLevel, bool hasNote = false}) async {
    await _logEvent('mood_recorded', parameters: {'mood_level': moodLevel, 'has_note': hasNote ? 'true' : 'false'});
  }

  // ==================== أحداث المستخدم ====================

  /// تتبع تسجيل الدخول
  Future<void> logLogin({required String method}) async {
    await _analytics.logLogin(loginMethod: method);

    if (kDebugMode) {
      AppLogging.logInfo('📊 Login: $method');
    }
  }

  /// تتبع تسجيل الخروج
  Future<void> logLogout() async {
    await _logEvent('logout');
  }

  /// تعيين معرف المستخدم
  Future<void> setUserId(String? userId) async {
    if (!_initialized) return;

    try {
      await _analytics.setUserId(id: userId);
      if (userId != null) {
        await _crashlytics.setUserIdentifier(userId);
      }

      if (kDebugMode) {
        AppLogging.logInfo('📊 User ID set: $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogging.logError('❌ Failed to set user ID: $e');
      }
    }
  }

  /// تعيين خصائص المستخدم
  Future<void> setUserProperty({required String name, required String value}) async {
    if (!_initialized) return;

    try {
      await _analytics.setUserProperty(name: name, value: value);

      if (kDebugMode) {
        AppLogging.logInfo('📊 User Property: $name = $value');
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogging.logError('❌ Failed to set user property: $e');
      }
    }
  }

  // ==================== أحداث الفئات ====================

  /// تتبع إنشاء فئة
  Future<void> logCategoryCreated({required String categoryId}) async {
    await _logEvent('category_created', parameters: {'category_id': categoryId});
  }

  /// تتبع حذف فئة
  Future<void> logCategoryDeleted({required String categoryId, required int tasksCount}) async {
    await _logEvent('category_deleted', parameters: {'category_id': categoryId, 'tasks_count': tasksCount});
  }

  // ==================== أحداث الإشعارات ====================

  /// تتبع إرسال إشعار
  Future<void> logNotificationSent({required String type, required String taskId}) async {
    await _logEvent('notification_sent', parameters: {'type': type, 'task_id': taskId});
  }

  /// تتبع فتح إشعار
  Future<void> logNotificationOpened({required String type, required String taskId}) async {
    await _logEvent('notification_opened', parameters: {'type': type, 'task_id': taskId});
  }

  // ==================== أحداث التصدير ====================

  /// تتبع تصدير البيانات
  Future<void> logDataExported({required String format, required int itemsCount}) async {
    await _logEvent('data_exported', parameters: {'format': format, 'items_count': itemsCount});
  }

  // ==================== أحداث البحث ====================

  /// تتبع البحث
  Future<void> logSearch({required String searchTerm, int? resultsCount}) async {
    await _logEvent('search', parameters: {'search_term': searchTerm, if (resultsCount != null) 'results_count': resultsCount});

    if (kDebugMode) {
      AppLogging.logInfo('📊 Search: $searchTerm (${resultsCount ?? 0} results)');
    }
  }

  // ==================== أحداث المشاركة ====================

  /// تتبع المشاركة
  Future<void> logShare({required String contentType, required String itemId, String? method}) async {
    await _logEvent('share', parameters: {'content_type': contentType, 'item_id': itemId, if (method != null) 'method': method});

    if (kDebugMode) {
      AppLogging.logInfo('📊 Share: $contentType - $itemId');
    }
  }

  // ==================== أحداث الإدارة (Admin Events) ====================

  /// تتبع فتح لوحة الإدارة
  Future<void> logAdminPanelOpened({required String userId}) async {
    await _logEvent('admin_panel_opened', parameters: {'user_id': userId});
  }

  /// تتبع حذف مستخدم من قبل الأدمن
  Future<void> logAdminUserDeleted({required String deletedUserId, required String adminId}) async {
    await _logEvent('admin_user_deleted', parameters: {'deleted_user_id': deletedUserId, 'admin_id': adminId});
  }

  /// تتبع ترقية مستخدم إلى أدمن
  Future<void> logAdminUserPromoted({required String userId, required String adminId, required bool promoted}) async {
    await _logEvent(
      'admin_user_promoted',
      parameters: {
        'user_id': userId,
        'admin_id': adminId,
        'promoted': promoted ? 'true' : 'false', // Convert boolean to string
      },
    );
  }

  /// تتبع إنشاء فئة من قبل الأدمن
  Future<void> logAdminCategoryCreated({required String categoryId, required String adminId}) async {
    await _logEvent('admin_category_created', parameters: {'category_id': categoryId, 'admin_id': adminId});
  }

  /// تتبع تعديل فئة من قبل الأدمن
  Future<void> logAdminCategoryUpdated({required String categoryId, required String adminId}) async {
    await _logEvent('admin_category_updated', parameters: {'category_id': categoryId, 'admin_id': adminId});
  }

  /// تتبع حذف فئة من قبل الأدمن
  Future<void> logAdminCategoryDeleted({required String categoryId, required String adminId}) async {
    await _logEvent('admin_category_deleted', parameters: {'category_id': categoryId, 'admin_id': adminId});
  }

  /// تتبع تحديث إعدادات الأدمن
  Future<void> logAdminSettingsUpdated({required String settingKey, required String adminId}) async {
    await _logEvent('admin_settings_updated', parameters: {'setting_key': settingKey, 'admin_id': adminId});
  }

  /// تتبع تعديل مهمة من قبل الأدمن
  Future<void> logAdminTaskUpdated({required String taskId, required String adminId}) async {
    await _logEvent('admin_task_updated', parameters: {'task_id': taskId, 'admin_id': adminId});
  }

  /// تتبع حذف مهمة من قبل الأدمن
  Future<void> logAdminTaskDeleted({required String taskId, required String adminId}) async {
    await _logEvent('admin_task_deleted', parameters: {'task_id': taskId, 'admin_id': adminId});
  }

  // ==================== Crashlytics ====================

  /// تسجيل خطأ في Crashlytics
  Future<void> recordError({required dynamic exception, StackTrace? stackTrace, String? reason, bool fatal = false}) async {
    if (!_initialized) return;

    try {
      await _crashlytics.recordError(exception, stackTrace, reason: reason, fatal: fatal);

      if (kDebugMode) {
        AppLogging.logInfo('🐛 Error recorded: $exception');
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogging.logError('❌ Failed to record error: $e');
      }
    }
  }

  /// تسجيل رسالة في Crashlytics
  Future<void> log(String message) async {
    if (!_initialized) return;

    try {
      await _crashlytics.log(message);

      if (kDebugMode) {
        AppLogging.logInfo('📝 Log: $message');
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogging.logError('❌ Failed to log message: $e');
      }
    }
  }

  /// تعيين مفتاح مخصص في Crashlytics
  Future<void> setCustomKey(String key, dynamic value) async {
    if (!_initialized) return;

    try {
      await _crashlytics.setCustomKey(key, value);
    } catch (e) {
      if (kDebugMode) {
        AppLogging.logError('❌ Failed to set custom key: $e');
      }
    }
  }

  // ==================== مساعدات ====================

  /// تسجيل حدث مخصص
  Future<void> _logEvent(String name, {Map<String, Object>? parameters}) async {
    if (!_initialized) return;

    try {
      await _analytics.logEvent(name: name, parameters: parameters);

      if (kDebugMode) {
        AppLogging.logInfo('📊 Event: $name ${parameters ?? ''}');
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogging.logError('❌ Failed to log event: $e');
      }
    }
  }

  /// تسجيل حدث مخصص عام
  Future<void> logCustomEvent({required String name, Map<String, Object>? parameters}) async {
    await _logEvent(name, parameters: parameters);
  }
}
