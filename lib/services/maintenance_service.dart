import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_settings.dart';
import '../services/firebase_service_wrapper.dart';
import 'app_logging_service.dart';

/// خدمة إدارة وضع الصيانة وإعدادات التطبيق العامة
class MaintenanceService {
  static final MaintenanceService _instance = MaintenanceService._internal();
  factory MaintenanceService() => _instance;
  MaintenanceService._internal();

  FirebaseFirestore? get _firestore => FirebaseServiceWrapper.firestore;

  /// معرّف الإعدادات في Firestore
  static const String _settingsDocId = 'app_settings';

  /// جلب إعدادات التطبيق الحالية
  Future<AppSettings> getSettings() async {
    if (_firestore == null) {
      AppLogging.logWarning('Firestore not available, returning default settings');
      return AppSettings.defaults();
    }

    try {
      final doc = await _firestore!.collection('admin_settings').doc(_settingsDocId).get();

      if (doc.exists && doc.data() != null) {
        return AppSettings.fromJson(doc.data()!);
      } else {
        // إذا لم توجد الإعدادات، أنشئ الافتراضية
        final defaultSettings = AppSettings.defaults();
        await _saveSettings(defaultSettings);
        return defaultSettings;
      }
    } catch (e) {
      AppLogging.logError('Error fetching app settings: $e');
      return AppSettings.defaults();
    }
  }

  /// الاستماع للتغييرات في وضع الصيانة (real-time)
  Stream<AppSettings> watchSettings() {
    if (_firestore == null) {
      AppLogging.logWarning('Firestore not available, returning default settings stream');
      return Stream.value(AppSettings.defaults());
    }

    try {
      return _firestore!
          .collection('admin_settings')
          .doc(_settingsDocId)
          .snapshots()
          .map((doc) {
            if (doc.exists && doc.data() != null) {
              return AppSettings.fromJson(doc.data()!);
            } else {
              return AppSettings.defaults();
            }
          })
          .handleError((error) {
            AppLogging.logError('Error watching app settings: $error');
            return AppSettings.defaults();
          });
    } catch (e) {
      AppLogging.logError('Error creating settings stream: $e');
      return Stream.value(AppSettings.defaults());
    }
  }

  /// حفظ الإعدادات (داخلي)
  Future<void> _saveSettings(AppSettings settings) async {
    if (_firestore == null) {
      throw Exception('Firestore not initialized');
    }

    try {
      await _firestore!.collection('admin_settings').doc(_settingsDocId).set(settings.toJson(), SetOptions(merge: true));

      AppLogging.logInfo('App settings saved successfully');
    } catch (e) {
      AppLogging.logError('Error saving app settings: $e');
      rethrow;
    }
  }

  /// تفعيل وضع الصيانة
  Future<void> enableMaintenanceMode({required String adminId, String? customMessage}) async {
    try {
      final currentSettings = await getSettings();
      final updatedSettings = currentSettings.copyWith(maintenanceMode: true, maintenanceMessage: customMessage ?? currentSettings.maintenanceMessage, lastUpdated: DateTime.now(), lastUpdatedBy: adminId);

      await _saveSettings(updatedSettings);
      AppLogging.logInfo('Maintenance mode ENABLED by admin: $adminId');
    } catch (e) {
      AppLogging.logError('Error enabling maintenance mode: $e');
      rethrow;
    }
  }

  /// إيقاف وضع الصيانة
  Future<void> disableMaintenanceMode({required String adminId}) async {
    try {
      final currentSettings = await getSettings();
      final updatedSettings = currentSettings.copyWith(maintenanceMode: false, lastUpdated: DateTime.now(), lastUpdatedBy: adminId);

      await _saveSettings(updatedSettings);
      AppLogging.logInfo('Maintenance mode DISABLED by admin: $adminId');
    } catch (e) {
      AppLogging.logError('Error disabling maintenance mode: $e');
      rethrow;
    }
  }

  /// تحديث رسالة الصيانة
  Future<void> updateMaintenanceMessage({required String adminId, required String message}) async {
    try {
      final currentSettings = await getSettings();
      final updatedSettings = currentSettings.copyWith(maintenanceMessage: message, lastUpdated: DateTime.now(), lastUpdatedBy: adminId);

      await _saveSettings(updatedSettings);
      AppLogging.logInfo('Maintenance message updated by admin: $adminId');
    } catch (e) {
      AppLogging.logError('Error updating maintenance message: $e');
      rethrow;
    }
  }

  /// تحديث إعداد محدد
  Future<void> updateSetting({required String adminId, bool? maintenanceMode, String? maintenanceMessage, bool? registrationEnabled, String? supportEmail}) async {
    try {
      final currentSettings = await getSettings();
      final updatedSettings = currentSettings.copyWith(
        maintenanceMode: maintenanceMode,
        maintenanceMessage: maintenanceMessage,
        registrationEnabled: registrationEnabled,
        supportEmail: supportEmail,
        lastUpdated: DateTime.now(),
        lastUpdatedBy: adminId,
      );

      await _saveSettings(updatedSettings);
      AppLogging.logInfo('Settings updated by admin: $adminId');
    } catch (e) {
      AppLogging.logError('Error updating settings: $e');
      rethrow;
    }
  }

  /// فحص سريع: هل التطبيق في وضع الصيانة؟
  Future<bool> isMaintenanceMode() async {
    try {
      final settings = await getSettings();
      return settings.maintenanceMode;
    } catch (e) {
      AppLogging.logError('Error checking maintenance mode: $e');
      return false; // في حالة الخطأ، اسمح بالوصول
    }
  }
}
