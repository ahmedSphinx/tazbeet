import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Connection status enum
enum ConnectionStatus { online, offline, syncing, error }

/// Pending change data
class PendingChange {
  final String id;
  final String type;
  final String description;
  final DateTime timestamp;
  final Map<String, dynamic> data;

  const PendingChange({required this.id, required this.type, required this.description, required this.timestamp, required this.data});
}

/// Offline sync manager for handling connection status and pending changes
class OfflineSyncManager extends ChangeNotifier {
  ConnectionStatus _status = ConnectionStatus.online;
  final List<PendingChange> _pendingChanges = [];
  bool _isAutoSyncEnabled = true;

  ConnectionStatus get status => _status;
  List<PendingChange> get pendingChanges => List.unmodifiable(_pendingChanges);
  int get pendingCount => _pendingChanges.length;
  bool get isOnline => _status == ConnectionStatus.online;
  bool get isOffline => _status == ConnectionStatus.offline;
  bool get isSyncing => _status == ConnectionStatus.syncing;
  bool get hasError => _status == ConnectionStatus.error;
  bool get isAutoSyncEnabled => _isAutoSyncEnabled;

  /// Updates connection status
  void updateStatus(ConnectionStatus newStatus) {
    if (_status != newStatus) {
      _status = newStatus;
      notifyListeners();

      // Auto-sync when coming back online
      if (newStatus == ConnectionStatus.online && _isAutoSyncEnabled && _pendingChanges.isNotEmpty) {
        syncPendingChanges();
      }
    }
  }

  /// Adds a pending change when offline
  void addPendingChange(PendingChange change) {
    _pendingChanges.add(change);
    notifyListeners();
  }

  /// Removes a pending change after successful sync
  void removePendingChange(String changeId) {
    _pendingChanges.removeWhere((change) => change.id == changeId);
    notifyListeners();
  }

  /// Syncs all pending changes
  Future<void> syncPendingChanges() async {
    if (_pendingChanges.isEmpty || _status != ConnectionStatus.online) return;

    updateStatus(ConnectionStatus.syncing);

    try {
      // Simulate sync process
      for (final change in List.from(_pendingChanges)) {
        await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay

        // In a real app, this would make actual API calls
        // await _syncChange(change);

        removePendingChange(change.id);
      }

      updateStatus(ConnectionStatus.online);
    } catch (error) {
      updateStatus(ConnectionStatus.error);
      // Retry after a delay
      Future.delayed(const Duration(seconds: 5), () {
        if (_status == ConnectionStatus.error) {
          updateStatus(ConnectionStatus.online);
        }
      });
    }
  }

  /// Toggles auto-sync
  void toggleAutoSync() {
    _isAutoSyncEnabled = !_isAutoSyncEnabled;
    notifyListeners();
  }

  /// Clears all pending changes
  void clearPendingChanges() {
    _pendingChanges.clear();
    notifyListeners();
  }

  /// Simulates going offline
  void goOffline() {
    updateStatus(ConnectionStatus.offline);
  }

  /// Simulates coming back online
  void goOnline() {
    updateStatus(ConnectionStatus.online);
  }
}

/// Offline sync indicator widget
class OfflineSyncIndicator extends StatelessWidget {
  final OfflineSyncManager syncManager;
  final VoidCallback? onTap;
  final bool showDetails;
  final EdgeInsetsGeometry margin;

  const OfflineSyncIndicator({super.key, required this.syncManager, this.onTap, this.showDetails = true, this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8)});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: syncManager,
      builder: (context, child) {
        // Hide when online with no pending changes
        if (syncManager.isOnline && syncManager.pendingCount == 0) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: margin,
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                onTap?.call();
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getBorderColor(context), width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStatusIcon(),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatusText(context)),
                    if (showDetails && syncManager.isSyncing) const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color color;

    switch (syncManager.status) {
      case ConnectionStatus.online:
        icon = Icons.cloud_done;
        color = Colors.green;
        break;
      case ConnectionStatus.offline:
        icon = Icons.cloud_off;
        color = Colors.orange;
        break;
      case ConnectionStatus.syncing:
        icon = Icons.sync;
        color = Colors.blue;
        break;
      case ConnectionStatus.error:
        icon = Icons.error;
        color = Colors.red;
        break;
    }

    Widget iconWidget = Icon(icon, color: color, size: 20);

    // Add rotation animation for syncing
    if (syncManager.isSyncing) {
      iconWidget = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(seconds: 2),
        builder: (context, value, child) {
          return Transform.rotate(angle: value * 2 * 3.14159, child: child);
        },
        child: iconWidget,
      );
    }

    return iconWidget;
  }

  Widget _buildStatusText(BuildContext context) {
    String primaryText;
    String? secondaryText;

    switch (syncManager.status) {
      case ConnectionStatus.online:
        if (syncManager.pendingCount > 0) {
          primaryText = 'Online';
          secondaryText = '${syncManager.pendingCount} changes synced';
        } else {
          primaryText = 'All synced';
        }
        break;
      case ConnectionStatus.offline:
        primaryText = 'Offline Mode';
        if (syncManager.pendingCount > 0) {
          secondaryText = '${syncManager.pendingCount} changes pending';
        }
        break;
      case ConnectionStatus.syncing:
        primaryText = 'Syncing...';
        if (syncManager.pendingCount > 0) {
          secondaryText = '${syncManager.pendingCount} changes remaining';
        }
        break;
      case ConnectionStatus.error:
        primaryText = 'Sync Error';
        secondaryText = 'Tap to retry';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          primaryText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: _getTextColor(context)),
        ),
        if (secondaryText != null) Text(secondaryText, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: _getTextColor(context).withValues(alpha: 0.8))),
      ],
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (syncManager.status) {
      case ConnectionStatus.online:
        return Colors.green.withValues(alpha: 0.1);
      case ConnectionStatus.offline:
        return Colors.orange.withValues(alpha: 0.1);
      case ConnectionStatus.syncing:
        return Colors.blue.withValues(alpha: 0.1);
      case ConnectionStatus.error:
        return Colors.red.withValues(alpha: 0.1);
    }
  }

  Color _getBorderColor(BuildContext context) {
    switch (syncManager.status) {
      case ConnectionStatus.online:
        return Colors.green.withValues(alpha: 0.3);
      case ConnectionStatus.offline:
        return Colors.orange.withValues(alpha: 0.3);
      case ConnectionStatus.syncing:
        return Colors.blue.withValues(alpha: 0.3);
      case ConnectionStatus.error:
        return Colors.red.withValues(alpha: 0.3);
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (syncManager.status) {
      case ConnectionStatus.online:
        return Colors.green.shade800;
      case ConnectionStatus.offline:
        return Colors.orange.shade800;
      case ConnectionStatus.syncing:
        return Colors.blue.shade800;
      case ConnectionStatus.error:
        return Colors.red.shade800;
    }
  }
}

/// Detailed sync status dialog
class SyncStatusDialog extends StatelessWidget {
  final OfflineSyncManager syncManager;

  const SyncStatusDialog({super.key, required this.syncManager});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(syncManager.isOnline ? Icons.cloud_done : Icons.cloud_off, color: syncManager.isOnline ? Colors.green : Colors.orange),
          const SizedBox(width: 8),
          Text(syncManager.isOnline ? 'Online' : 'Offline'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Connection status
          _buildStatusRow('Connection', syncManager.isOnline ? 'Connected' : 'Disconnected', syncManager.isOnline ? Colors.green : Colors.orange),

          // Pending changes
          _buildStatusRow('Pending Changes', '${syncManager.pendingCount}', syncManager.pendingCount > 0 ? Colors.orange : Colors.green),

          // Auto-sync status
          _buildStatusRow('Auto-sync', syncManager.isAutoSyncEnabled ? 'Enabled' : 'Disabled', syncManager.isAutoSyncEnabled ? Colors.green : Colors.grey),

          if (syncManager.pendingChanges.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Pending Changes:', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...syncManager.pendingChanges
                .take(3)
                .map(
                  (change) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('• ${change.description}', style: Theme.of(context).textTheme.bodySmall),
                  ),
                ),
            if (syncManager.pendingChanges.length > 3) Text('... and ${syncManager.pendingChanges.length - 3} more', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
          ],
        ],
      ),
      actions: [
        if (syncManager.isOffline)
          TextButton(
            onPressed: () {
              syncManager.goOnline();
              Navigator.pop(context);
            },
            child: const Text('Go Online'),
          ),

        if (syncManager.isOnline && syncManager.pendingCount > 0)
          TextButton(
            onPressed: () {
              syncManager.syncPendingChanges();
              Navigator.pop(context);
            },
            child: const Text('Sync Now'),
          ),

        TextButton(
          onPressed: () {
            syncManager.toggleAutoSync();
          },
          child: Text(syncManager.isAutoSyncEnabled ? 'Disable Auto-sync' : 'Enable Auto-sync'),
        ),

        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
      ],
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Text(
              value,
              style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper function to show sync status dialog
void showSyncStatusDialog(BuildContext context, OfflineSyncManager syncManager) {
  showDialog(
    context: context,
    builder: (context) => SyncStatusDialog(syncManager: syncManager),
  );
}
