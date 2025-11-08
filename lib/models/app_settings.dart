import 'package:equatable/equatable.dart';

/// نموذج إعدادات التطبيق العامة
/// يتم تخزينها في Firestore ويمكن للأدمن فقط تعديلها
class AppSettings extends Equatable {
  /// هل التطبيق في وضع الصيانة؟
  final bool maintenanceMode;

  /// رسالة الصيانة التي تظهر للمستخدمين
  final String maintenanceMessage;

  /// هل التسجيل مفعّل؟
  final bool registrationEnabled;

  /// البريد الإلكتروني للدعم
  final String supportEmail;

  /// وقت آخر تحديث
  final DateTime lastUpdated;

  /// معرّف الأدمن الذي قام بآخر تحديث
  final String? lastUpdatedBy;

  const AppSettings({
    this.maintenanceMode = false,
    this.maintenanceMessage = 'التطبيق قيد الصيانة حالياً. سنعود قريباً!',
    this.registrationEnabled = true,
    this.supportEmail = 'support@tazbeet.com',
    required this.lastUpdated,
    this.lastUpdatedBy,
  });

  /// القيم الافتراضية
  factory AppSettings.defaults() {
    return AppSettings(maintenanceMode: false, maintenanceMessage: 'التطبيق قيد الصيانة حالياً. سنعود قريباً!', registrationEnabled: true, supportEmail: 'support@tazbeet.com', lastUpdated: DateTime.now());
  }

  /// من JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      maintenanceMode: json['maintenanceMode'] as bool? ?? false,
      maintenanceMessage: json['maintenanceMessage'] as String? ?? 'التطبيق قيد الصيانة حالياً. سنعود قريباً!',
      registrationEnabled: json['registrationEnabled'] as bool? ?? true,
      supportEmail: json['supportEmail'] as String? ?? 'support@tazbeet.com',
      lastUpdated: json['lastUpdated'] != null ? DateTime.fromMillisecondsSinceEpoch(json['lastUpdated'] as int) : DateTime.now(),
      lastUpdatedBy: json['lastUpdatedBy'] as String?,
    );
  }

  /// إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'maintenanceMode': maintenanceMode,
      'maintenanceMessage': maintenanceMessage,
      'registrationEnabled': registrationEnabled,
      'supportEmail': supportEmail,
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
      'lastUpdatedBy': lastUpdatedBy,
    };
  }

  /// نسخ مع تعديلات
  AppSettings copyWith({bool? maintenanceMode, String? maintenanceMessage, bool? registrationEnabled, String? supportEmail, DateTime? lastUpdated, String? lastUpdatedBy}) {
    return AppSettings(
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      maintenanceMessage: maintenanceMessage ?? this.maintenanceMessage,
      registrationEnabled: registrationEnabled ?? this.registrationEnabled,
      supportEmail: supportEmail ?? this.supportEmail,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
    );
  }

  @override
  List<Object?> get props => [maintenanceMode, maintenanceMessage, registrationEnabled, supportEmail, lastUpdated, lastUpdatedBy];
}
