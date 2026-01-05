import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../services/app_logging_service.dart';

/// Voice Task Permission Helper
class VoiceTaskPermissions {
  static Future<bool> checkMicrophonePermission() async {
    final status = await Permission.microphone.status;
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> checkAndRequestPermissions() async {
    try {
      // Check current permission status
      final hasPermission = await checkMicrophonePermission();

      if (hasPermission) {
        AppLogging.logInfo('Microphone permission already granted', name: 'VoiceTaskPermissions');
        return true;
      }

      // Request permission
      final granted = await requestMicrophonePermission();

      if (granted) {
        AppLogging.logInfo('Microphone permission granted', name: 'VoiceTaskPermissions');
      } else {
        AppLogging.logWarning('Microphone permission denied', name: 'VoiceTaskPermissions');
      }

      return granted;
    } catch (e) {
      AppLogging.logError('Error checking microphone permission: $e', name: 'VoiceTaskPermissions');
      return false;
    }
  }

  static Future<bool> checkSpeechRecognitionPermission() async {
    // iOS: Speech recognition permission
    // Android: Usually granted with microphone permission
    if (Platform.isIOS) {
      // Check for speech recognition permission on iOS
      return await checkMicrophonePermission();
    }
    return true;
  }

  static Future<void> openAppSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      AppLogging.logError('Failed to open app settings: $e', name: 'VoiceTaskPermissions');
    }
  }

  static void showPermissionDialog(BuildContext context, {required VoidCallback onGranted, VoidCallback? onDenied}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Microphone Permission Required'),
        content: const Text(
          'To use voice task creation, Tazbeet needs access to your microphone. '
          'This allows the app to record your voice and convert it to text.\n\n'
          'Your voice data is processed locally and never sent to external servers.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDenied?.call();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final granted = await requestMicrophonePermission();
              if (granted) {
                onGranted();
              } else {
                onDenied?.call();
              }
            },
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );
  }

  static void showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text(
          'Microphone permission was denied. You can enable it in:\n\n'
          'Settings > Tazbeet > Microphone\n\n'
          'Without microphone access, you won\'t be able to use voice task creation.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
