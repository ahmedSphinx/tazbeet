import 'package:tazbeet/services/app_logging.dart';

import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UpdateStatus { checking, available, downloading, installing, upToDate, error }

class UpdateInfo {
  final String version;
  final String? releaseNotes;
  final bool isImmediateUpdate;
  final UpdateStatus status;

  const UpdateInfo({required this.version, this.releaseNotes, this.isImmediateUpdate = false, required this.status});
}

class UpdateService extends ChangeNotifier {
  UpdateStatus _status = UpdateStatus.upToDate;
  UpdateInfo? _updateInfo;
  double _downloadProgress = 0.0;
  String _currentVersion = '';

  UpdateStatus get status => _status;
  UpdateInfo? get updateInfo => _updateInfo;
  double get downloadProgress => _downloadProgress;
  String get currentVersion => _currentVersion;

  UpdateService() {
    _initializePackageInfo();
  }

  Future<void> _initializePackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _currentVersion = packageInfo.version;
      notifyListeners();
    } catch (e) {
      AppLogging.logInfo('Error getting package info: $e');
    }
  }

  Future<UpdateInfo?> checkForUpdates() async {
    if (!Platform.isAndroid) {
      // InAppUpdate plugin only supports Android
      AppLogging.logInfo('Update check skipped: Not running on Android');
      return null;
    }
    try {
      _setStatus(UpdateStatus.checking);

      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        final newVersion = updateInfo.availableVersionCode?.toString() ?? 'Unknown';

        _updateInfo = UpdateInfo(version: newVersion, isImmediateUpdate: updateInfo.immediateUpdateAllowed, status: UpdateStatus.available);

        _setStatus(UpdateStatus.available);
        notifyListeners();
        return _updateInfo;
      } else {
        _setStatus(UpdateStatus.upToDate);
        notifyListeners();
        return null;
      }
    } catch (e) {
      AppLogging.logError('Error checking for updates: $e');
      _setStatus(UpdateStatus.error);
      notifyListeners();
      return null;
    }
  }

  Future<bool> startFlexibleUpdate() async {
    if (!Platform.isAndroid) {
      // InAppUpdate plugin only supports Android
      AppLogging.logInfo('Flexible update skipped: Not running on Android');
      return false;
    }
    try {
      if (_updateInfo == null || !_updateInfo!.isImmediateUpdate) {
        await InAppUpdate.startFlexibleUpdate();
        _setStatus(UpdateStatus.downloading);
        return true;
      }
      return false;
    } catch (e) {
      AppLogging.logInfo('Error starting flexible update: $e');
      _setStatus(UpdateStatus.error);
      return false;
    }
  }

  Future<bool> startImmediateUpdate() async {
    if (!Platform.isAndroid) {
      // InAppUpdate plugin only supports Android
      AppLogging.logInfo('Immediate update skipped: Not running on Android');
      return false;
    }
    try {
      if (_updateInfo?.isImmediateUpdate == true) {
        await InAppUpdate.performImmediateUpdate();
        return true;
      }
      return false;
    } catch (e) {
      AppLogging.logInfo('Error starting immediate update: $e');
      _setStatus(UpdateStatus.error);
      return false;
    }
  }

  Future<void> completeFlexibleUpdate() async {
    try {
      await InAppUpdate.completeFlexibleUpdate();
      _setStatus(UpdateStatus.upToDate);
      notifyListeners();
    } catch (e) {
      AppLogging.logInfo('Error completing flexible update: $e');
      _setStatus(UpdateStatus.error);
    }
  }

  void _setStatus(UpdateStatus status) {
    _status = status;
    notifyListeners();
  }

  void reset() {
    _status = UpdateStatus.upToDate;
    _updateInfo = null;
    _downloadProgress = 0.0;
    notifyListeners();
  }

  bool get isChecking => _status == UpdateStatus.checking;
  bool get isUpdateAvailable => _status == UpdateStatus.available;
  bool get isDownloading => _status == UpdateStatus.downloading;
  bool get isInstalling => _status == UpdateStatus.installing;
  bool get isUpToDate => _status == UpdateStatus.upToDate;
  bool get hasError => _status == UpdateStatus.error;

  /// Check for updates automatically (called on app startup)
  Future<void> checkForUpdatesAutomatically() async {
    try {
      // Get shared preferences instance
      final prefs = await SharedPreferences.getInstance();
      const lastCheckKey = 'last_update_check';

      // Only check if we haven't checked in the last 24 hours
      final lastCheck = prefs.getInt(lastCheckKey);
      final now = DateTime.now().millisecondsSinceEpoch;
      const oneDayInMs = 24 * 60 * 60 * 1000; // 24 hours

      if (lastCheck != null && (now - lastCheck) < oneDayInMs) {
        AppLogging.logInfo('Update check skipped - checked within last 24 hours');
        return; // Skip if checked within last 24 hours
      }

      // Save current timestamp
      await prefs.setInt(lastCheckKey, now);

      // Perform the update check
      AppLogging.logInfo('Performing automatic update check...');
      await checkForUpdates();
    } catch (e) {
      AppLogging.logInfo('Error in automatic update check: $e');
    }
  }
}
