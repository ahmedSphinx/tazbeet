import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../services/sync_queue.dart';

/// Widget to display sync status in app bar
class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SyncStatus>(
      stream: syncQueue.statusStream,
      initialData: syncQueue.currentStatus,
      builder: (context, snapshot) {
        final status = snapshot.data ?? SyncStatus.idle;
        return IconButton(icon: _buildStatusIcon(status), onPressed: () => _showStatusDialog(context, status), tooltip: _getStatusDescription(status));
      },
    );
  }

  Widget _buildStatusIcon(SyncStatus status) {
    switch (status) {
      case SyncStatus.success:
        return const Icon(Icons.cloud_done, color: Colors.white);
      case SyncStatus.syncing:
        return const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
      case SyncStatus.idle:
        return const Icon(Icons.cloud_queue, color: Colors.orange);
      case SyncStatus.failed:
        return const Icon(Icons.cloud_off, color: Colors.red);
    }
  }

  String _getStatusDescription(SyncStatus status) {
    switch (status) {
      case SyncStatus.success:
        return 'All data synced';
      case SyncStatus.syncing:
        return 'Syncing data...';
      case SyncStatus.idle:
        return 'Pending sync operations';
      case SyncStatus.failed:
        return 'Sync failed - tap to retry';
    }
  }

  void _showStatusDialog(BuildContext context, SyncStatus status) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: [_buildStatusIcon(status), const SizedBox(width: 12), Text(AppLocalizations.of(context)!.syncStatus)]),
        content: StreamBuilder<int>(
          stream: syncQueue.pendingCountStream,
          initialData: syncQueue.pendingCount,
          builder: (context, pendingSnapshot) {
            final pendingCount = pendingSnapshot.data ?? 0;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${AppLocalizations.of(context)!.statusLabel} ${_getStatusText(status, context)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(_getStatusDescription(status)),
                const SizedBox(height: 12),
                Text('${AppLocalizations.of(context)!.pendingOperations} $pendingCount'),
                if (status == SyncStatus.failed) ...[const SizedBox(height: 12), Text(AppLocalizations.of(context)!.someSyncOperationsFailed, style: TextStyle(color: Theme.of(context).colorScheme.error))],
              ],
            );
          },
        ),
        actions: [
          if (status == SyncStatus.failed) ...[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                syncQueue.retryFailedOperations();
              },
              child: Text(AppLocalizations.of(context)!.retryButton),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                syncQueue.clearFailedOperations();
              },
              child: Text(AppLocalizations.of(context)!.clearFailedButton),
            ),
          ],
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.closeButton)),
        ],
      ),
    );
  }

  String _getStatusText(SyncStatus status, BuildContext context) {
    switch (status) {
      case SyncStatus.success:
        return AppLocalizations.of(context)!.syncStatusSuccess;
      case SyncStatus.syncing:
        return AppLocalizations.of(context)!.syncStatusSyncing;
      case SyncStatus.idle:
        return AppLocalizations.of(context)!.syncStatusIdle;
      case SyncStatus.failed:
        return AppLocalizations.of(context)!.syncStatusFailed;
    }
  }
}
