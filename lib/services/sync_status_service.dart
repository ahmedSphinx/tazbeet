import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

/// Sync status states
enum SyncStatus {
  synced, // ✓ All data synced
  syncing, // ⟳ Sync in progress
  offline, // ⚠ No network connection
  error, // ✗ Sync failed
  unknown, // ? Initial state
}

/// Service to track and broadcast sync status
class SyncStatusService {
  static final SyncStatusService _instance = SyncStatusService._internal();
  factory SyncStatusService() => _instance;
  SyncStatusService._internal();

  final ValueNotifier<SyncStatus> _status = ValueNotifier(SyncStatus.unknown);
  final ValueNotifier<String?> _lastError = ValueNotifier(null);
  final ValueNotifier<DateTime?> _lastSyncTime = ValueNotifier(null);

  StreamSubscription? _connectivitySubscription;
  StreamSubscription? _authSubscription;

  bool _isNetworkAvailable = true;
  bool _isUserSignedIn = false;

  /// Current sync status
  ValueNotifier<SyncStatus> get status => _status;

  /// Last error message (if any)
  ValueNotifier<String?> get lastError => _lastError;

  /// Last successful sync time
  ValueNotifier<DateTime?> get lastSyncTime => _lastSyncTime;

  /// Initialize the service
  Future<void> initialize() async {
    // Listen to connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      _isNetworkAvailable = results.isNotEmpty && !results.contains(ConnectivityResult.none);
      _updateStatus();
    });

    // Listen to auth state changes
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      _isUserSignedIn = user != null;
      _updateStatus();
    });

    // Check initial connectivity
    final connectivityResults = await Connectivity().checkConnectivity();
    _isNetworkAvailable = connectivityResults.isNotEmpty && !connectivityResults.contains(ConnectivityResult.none);

    // Check initial auth state
    _isUserSignedIn = FirebaseAuth.instance.currentUser != null;

    _updateStatus();
  }

  /// Update status based on current conditions
  void _updateStatus() {
    if (!_isUserSignedIn) {
      _status.value = SyncStatus.unknown;
      return;
    }

    if (!_isNetworkAvailable) {
      _status.value = SyncStatus.offline;
      return;
    }

    // If we have network and user is signed in, default to synced
    // (will be updated by sync operations)
    if (_status.value == SyncStatus.offline || _status.value == SyncStatus.unknown) {
      _status.value = SyncStatus.synced;
    }
  }

  /// Mark sync as started
  void startSync() {
    if (_isNetworkAvailable && _isUserSignedIn) {
      _status.value = SyncStatus.syncing;
    }
  }

  /// Mark sync as completed successfully
  void syncCompleted() {
    _status.value = SyncStatus.synced;
    _lastSyncTime.value = DateTime.now();
    _lastError.value = null;
  }

  /// Mark sync as failed
  void syncFailed(String error) {
    _status.value = SyncStatus.error;
    _lastError.value = error;
  }

  /// Get status icon
  String getStatusIcon() {
    switch (_status.value) {
      case SyncStatus.synced:
        return '✓';
      case SyncStatus.syncing:
        return '⟳';
      case SyncStatus.offline:
        return '⚠';
      case SyncStatus.error:
        return '✗';
      case SyncStatus.unknown:
        return '?';
    }
  }

  /// Get status description
  String getStatusDescription() {
    switch (_status.value) {
      case SyncStatus.synced:
        final time = _lastSyncTime.value;
        if (time != null) {
          final diff = DateTime.now().difference(time);
          if (diff.inMinutes < 1) return 'Synced just now';
          if (diff.inMinutes < 60) return 'Synced ${diff.inMinutes}m ago';
          if (diff.inHours < 24) return 'Synced ${diff.inHours}h ago';
          return 'Synced ${diff.inDays}d ago';
        }
        return 'All data synced';
      case SyncStatus.syncing:
        return 'Syncing...';
      case SyncStatus.offline:
        return 'No internet connection';
      case SyncStatus.error:
        return _lastError.value ?? 'Sync failed';
      case SyncStatus.unknown:
        return 'Not signed in';
    }
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _authSubscription?.cancel();
    _status.dispose();
    _lastError.dispose();
    _lastSyncTime.dispose();
  }
}
