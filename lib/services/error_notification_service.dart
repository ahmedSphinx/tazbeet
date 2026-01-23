import 'package:flutter/material.dart';

/// Simple service to show error messages to users
/// Used to surface errors that were previously only logged
class ErrorNotificationService {
  static final ErrorNotificationService _instance = ErrorNotificationService._internal();
  factory ErrorNotificationService() => _instance;
  ErrorNotificationService._internal();

  /// Global navigator key to show snackbars without context
  static GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  /// Track last shown message to prevent duplicates
  String? _lastSyncError;
  DateTime? _lastSyncErrorTime;

  /// Show error message to user
  void showError(BuildContext context, String message, {bool isWarning = false}) {
    final messenger = scaffoldMessengerKey?.currentState;
    if (messenger == null) return;

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isWarning ? Colors.orange : Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(label: 'Dismiss', textColor: Colors.white, onPressed: () => messenger.hideCurrentSnackBar()),
      ),
    );
  }

  /// Show sync error with retry option
  /// Throttled to prevent spam - only shows once per 10 seconds
  void showSyncError(String operation, VoidCallback? onRetry) {
    final messenger = scaffoldMessengerKey?.currentState;
    if (messenger == null) return;

    // Throttle: only show if different message OR 10+ seconds since last
    final now = DateTime.now();
    if (_lastSyncError == operation && _lastSyncErrorTime != null) {
      if (now.difference(_lastSyncErrorTime!).inSeconds < 10) {
        return; // Skip duplicate within 10 seconds
      }
    }

    _lastSyncError = operation;
    _lastSyncErrorTime = now;

    messenger.showSnackBar(
      SnackBar(
        content: Text('Failed to sync $operation to cloud'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        action: onRetry != null ? SnackBarAction(label: 'Retry', textColor: Colors.white, onPressed: onRetry) : null,
      ),
    );
  }

  /// Show info message
  void showInfo(String message) {
    final messenger = scaffoldMessengerKey?.currentState;
    if (messenger == null) return;

    messenger.showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.blue, behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 3)));
  }
}
