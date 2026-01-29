import 'package:flutter/material.dart';
import 'package:tazbeet/services/performance_monitor_service.dart';
import 'package:tazbeet/services/memory_manager_service.dart';
import 'package:tazbeet/services/animation_optimizer_service.dart';
import 'package:tazbeet/services/code_quality_monitor_service.dart';
import 'package:tazbeet/services/sync_status_service.dart';
import 'package:tazbeet/services/notification_verification_service.dart';
import 'package:tazbeet/repositories/task_repository.dart';
import 'package:tazbeet/l10n/app_localizations.dart';

/// Developer tools screen to view monitoring services
class DeveloperToolsScreen extends StatefulWidget {
  const DeveloperToolsScreen({super.key});

  @override
  State<DeveloperToolsScreen> createState() => _DeveloperToolsScreenState();
}

class _DeveloperToolsScreenState extends State<DeveloperToolsScreen> {
  final _performanceMonitor = PerformanceMonitorService();
  final _memoryManager = MemoryManagerService();
  final _animationOptimizer = AnimationOptimizerService();
  final _codeQualityMonitor = CodeQualityMonitorService();
  final _syncStatus = SyncStatusService();
  final _notificationVerification = NotificationVerificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.developerTools),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => setState(() {}), tooltip: AppLocalizations.of(context)!.refresh)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPerformanceSection(),
          const SizedBox(height: 24),
          _buildMemorySection(),
          const SizedBox(height: 24),
          _buildAnimationSection(),
          const SizedBox(height: 24),
          _buildCodeQualitySection(),
          const SizedBox(height: 24),
          _buildSyncStatusSection(),
          const SizedBox(height: 24),
          _buildNotificationSection(),
          const SizedBox(height: 24),
          _buildActionsSection(),
        ],
      ),
    );
  }

  Widget _buildPerformanceSection() {
    final metrics = _performanceMonitor.getAllMetrics();
    final slowOps = _performanceMonitor.getSlowOperations();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.speed, color: Colors.blue),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.performanceMonitor, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.trackedOperations(metrics.length)),
            if (slowOps.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.slowOperations(slowOps.length), style: const TextStyle(color: Colors.orange)),
              ...slowOps.map(
                (op) => Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Text('• $op', style: const TextStyle(fontSize: 12)),
                ),
              ),
            ],
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                _performanceMonitor.logPerformanceReport();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.performanceReportLoggedToConsole)));
              },
              icon: const Icon(Icons.article),
              label: Text(AppLocalizations.of(context)!.logReport),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemorySection() {
    final stats = _memoryManager.getMemoryStats();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.memory, color: Colors.green),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.memoryManager, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text('Hive Boxes: ${stats.length}'),
            ...stats.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text('• ${entry.key}: ${entry.value['length']} items', style: const TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await _memoryManager.forceCleanup();
                    setState(() {});
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.memoryCleanupCompleted)));
                    }
                  },
                  icon: const Icon(Icons.cleaning_services),
                  label: Text(AppLocalizations.of(context)!.forceCleanup),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    _memoryManager.logMemoryStats();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.memoryStatsLoggedToConsole)));
                  },
                  icon: const Icon(Icons.article),
                  label: Text(AppLocalizations.of(context)!.logStats),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationSection() {
    final stats = _animationOptimizer.getPerformanceStats();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.animation, color: Colors.purple),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.animationOptimizer, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text('Current FPS: ${stats['currentFPS']?.toStringAsFixed(1) ?? 'N/A'}'),
            Text('Low-end device: ${stats['isLowEndDevice']}'),
            Text('Reduce animations: ${stats['reduceAnimations']}'),
            Text('Simple animations: ${stats['shouldUseSimpleAnimations']}'),
            Text('Skip animations: ${stats['shouldSkipAnimations']}'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                _animationOptimizer.logPerformanceStats();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.animationStatsLoggedToConsole)));
              },
              icon: const Icon(Icons.article),
              label: Text(AppLocalizations.of(context)!.logStats),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeQualitySection() {
    final metrics = _codeQualityMonitor.getQualityMetrics();
    final score = metrics['qualityScore'] as double;
    final health = _codeQualityMonitor.healthStatus;

    Color scoreColor = Colors.green;
    if (score < 70) scoreColor = Colors.orange;
    if (score < 50) scoreColor = Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.code, color: Colors.indigo),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.codeQualityMonitor, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(AppLocalizations.of(context)!.qualityScore, style: const TextStyle(fontSize: 16)),
                Text(
                  '${score.toStringAsFixed(1)}/100',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: scoreColor),
                ),
                const SizedBox(width: 16),
                Chip(label: Text(health), backgroundColor: scoreColor.withValues(alpha: 0.2)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Total Errors: ${metrics['totalErrors']}'),
            Text('Total Warnings: ${metrics['totalWarnings']}'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                _codeQualityMonitor.logQualityReport();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.qualityReportLoggedToConsole)));
              },
              icon: const Icon(Icons.article),
              label: Text(AppLocalizations.of(context)!.logReport),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStatusSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cloud, color: Colors.cyan),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.syncStatus, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<SyncStatus>(
              valueListenable: _syncStatus.status,
              builder: (context, status, _) {
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Status: ${_syncStatus.getStatusDescription()}'), Text('Icon: ${_syncStatus.getStatusIcon()}')]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications, color: Colors.amber),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.notificationVerification, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final count = await _notificationVerification.getPendingNotificationCount();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.pendingNotifications(count))));
                }
              },
              icon: const Icon(Icons.check),
              label: Text(AppLocalizations.of(context)!.checkPending),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () async {
                final taskRepo = TaskRepository();
                await taskRepo.init();
                final tasks = await taskRepo.getAllTasks();
                await _notificationVerification.logVerificationReport(tasks);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.verificationReportLoggedToConsole)));
                }
              },
              icon: const Icon(Icons.article),
              label: Text(AppLocalizations.of(context)!.verifyAllTasks),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.build, color: Colors.grey),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.actions, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _performanceMonitor.clearMetrics();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.performanceMetricsCleared)));
                  },
                  icon: const Icon(Icons.clear),
                  label: Text(AppLocalizations.of(context)!.clearPerformance),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _codeQualityMonitor.clearMetrics();
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.qualityMetricsCleared)));
                  },
                  icon: const Icon(Icons.clear),
                  label: Text(AppLocalizations.of(context)!.clearQuality),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
