import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../l10n/app_localizations.dart';

/// Widget displaying notification statistics and analytics
class NotificationStatsWidget extends StatelessWidget {
  final Map<String, dynamic> analytics;
  final int days;

  const NotificationStatsWidget({super.key, required this.analytics, this.days = 7});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notification Analytics (Last $days Days)', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            // Overview Statistics
            _buildOverviewStats(analytics, theme),

            const SizedBox(height: 24),

            // Delivery and Engagement Chart
            _buildEngagementChart(analytics, theme, context),

            const SizedBox(height: 24),

            // Type Breakdown
            _buildTypeBreakdown(analytics, theme),

            const SizedBox(height: 16),

            // Response Time
            if (analytics['averageResponseTime'] != null) _buildResponseTime(analytics['averageResponseTime'] as Duration, theme, context),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewStats(Map<String, dynamic> analytics, ThemeData theme) {
    final totalSent = analytics['totalSent'] ?? 0;
    final totalDelivered = analytics['totalDelivered'] ?? 0;
    final totalOpened = analytics['totalOpened'] ?? 0;
    final totalFailed = analytics['totalFailed'] ?? 0;

    return Row(
      children: [
        Expanded(child: _buildStatCard('Sent', totalSent.toString(), Icons.send, Colors.blue, theme)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Delivered', totalDelivered.toString(), Icons.check_circle, Colors.green, theme)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Opened', totalOpened.toString(), Icons.open_in_new, Colors.orange, theme)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Failed', totalFailed.toString(), Icons.error, Colors.red, theme)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color),
          ),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildEngagementChart(Map<String, dynamic> analytics, ThemeData theme, context) {
    final deliveryRate = (analytics['deliveryRate'] ?? 0.0) as double;
    final openRate = (analytics['openRate'] ?? 0.0) as double;
    final actionRate = (analytics['actionRate'] ?? 0.0) as double;

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: theme.colorScheme.surfaceVariant.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Engagement Rates', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 1.0,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return Text(AppLocalizations.of(context)!.deliveryLabel, style: const TextStyle(fontSize: 10));
                          case 1:
                            return Text(AppLocalizations.of(context)!.openLabel, style: const TextStyle(fontSize: 10));
                          case 2:
                            return Text(AppLocalizations.of(context)!.actionLabel, style: const TextStyle(fontSize: 10));
                          default:
                            return const Text('');
                        }
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text('${(value * 100).toInt()}%', style: const TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true, drawVerticalLine: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [BarChartRodData(toY: deliveryRate, color: Colors.green, width: 20)],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [BarChartRodData(toY: openRate, color: Colors.blue, width: 20)],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [BarChartRodData(toY: actionRate, color: Colors.orange, width: 20)],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBreakdown(Map<String, dynamic> analytics, ThemeData theme) {
    final byType = analytics['byType'] as Map<String, dynamic>? ?? {};

    if (byType.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Breakdown by Type', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...byType.entries.map((entry) {
          final typeData = entry.value as Map<String, dynamic>;
          final sent = typeData['sent'] ?? 0;
          final deliveryRate = ((typeData['deliveryRate'] ?? 0.0) * 100).toStringAsFixed(0);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text(_formatTypeName(entry.key), style: theme.textTheme.bodyMedium)),
                Expanded(child: Text('$sent sent', style: theme.textTheme.bodySmall)),
                Expanded(
                  child: LinearProgressIndicator(value: (typeData['deliveryRate'] ?? 0.0) as double, backgroundColor: Colors.grey.withOpacity(0.2), valueColor: AlwaysStoppedAnimation<Color>(_getTypeColor(entry.key))),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 40,
                  child: Text('$deliveryRate%', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildResponseTime(Duration responseTime, ThemeData theme, context) {
    final seconds = responseTime.inSeconds;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: theme.colorScheme.primaryContainer.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(Icons.timer, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.averageResponseTime, style: const TextStyle(fontSize: 12)),
              Text(minutes > 0 ? '${minutes}m ${remainingSeconds}s' : '${seconds}s', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTypeName(String typeString) {
    // Convert "NotificationType.taskReminder" to "Task Reminder"
    final parts = typeString.split('.');
    if (parts.length > 1) {
      final name = parts[1];
      // Insert spaces before capital letters
      final formatted = name.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}');
      return formatted.trim();
    }
    return typeString;
  }

  Color _getTypeColor(String typeString) {
    if (typeString.contains('task')) return Colors.blue;
    if (typeString.contains('mood')) return Colors.purple;
    if (typeString.contains('pomodoro')) return Colors.red;
    if (typeString.contains('emergency')) return Colors.red;
    return Colors.grey;
  }
}
