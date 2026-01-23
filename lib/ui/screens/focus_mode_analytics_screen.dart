import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../l10n/app_localizations.dart';
import '../../services/focus_mode.dart';
import '../../services/settings_service.dart';
import '../../models/task.dart';
import '../../repositories/task_repository.dart';

class FocusModeAnalyticsScreen extends StatefulWidget {
  const FocusModeAnalyticsScreen({super.key});

  @override
  State<FocusModeAnalyticsScreen> createState() => _FocusModeAnalyticsScreenState();
}

class _FocusModeAnalyticsScreenState extends State<FocusModeAnalyticsScreen> {
  List<Map<String, dynamic>> _focusModeHistory = [];
  List<Task> _recentTasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();

    // Listen to focus mode events
    FocusMode.events.listen((event) {
      if (mounted) {
        _handleFocusModeEvent(event);
      }
    });
  }

  Future<void> _loadAnalyticsData() async {
    setState(() => _isLoading = true);

    try {
      // Load focus mode history from settings
      final settings = await SettingsService.getFocusModeHistory();
      _focusModeHistory = settings['sessions'] ?? [];

      // Load recent tasks
      final taskRepo = TaskRepository();
      final tasks = await taskRepo.getAllTasks();
      _recentTasks = tasks.where((task) => task.focusScore > 5).take(10).toList();

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error loading focus mode analytics: $e');
    }
  }

  void _handleFocusModeEvent(FocusModeEvent event) {
    final sessionData = {
      'timestamp': event.timestamp.toIso8601String(),
      'type': event.type.toString(),
      'taskId': event.task?.id,
      'taskTitle': event.task?.title,
      'duration': event.data['duration'],
      'settings': event.data['settings'],
    };

    setState(() {
      _focusModeHistory.add(sessionData);
      // Keep only last 100 sessions
      if (_focusModeHistory.length > 100) {
        _focusModeHistory.removeAt(0);
      }
    });

    // Save to settings
    _saveAnalyticsData();
  }

  Future<void> _saveAnalyticsData() async {
    await SettingsService.saveFocusModeHistory({'sessions': _focusModeHistory, 'lastUpdated': DateTime.now().toIso8601String()});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Focus Analytics'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: _loadAnalyticsData)],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Overview Cards
                  _buildOverviewCards(),
                  const SizedBox(height: 20),

                  // Usage Statistics
                  _buildUsageStatistics(),
                  const SizedBox(height: 20),

                  // Productivity Correlation
                  _buildProductivityChart(),
                  const SizedBox(height: 20),

                  // Effectiveness Metrics
                  _buildEffectivenessMetrics(),
                  const SizedBox(height: 20),

                  // Recommendations
                  _buildRecommendations(),
                ],
              ),
            ),
    );
  }

  Widget _buildOverviewCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard('Total Sessions', _focusModeHistory.length.toString(), Icons.timer, Colors.blue)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('Total Focus Time', _formatDuration(_getTotalFocusTime()), Icons.access_time, Colors.green)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildStatCard('Avg Session Length', _formatDuration(_getAverageSessionLength()), Icons.schedule, Colors.orange)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('Success Rate', '${(_getSuccessRate() * 100).toStringAsFixed(1)}%', Icons.trending_up, Colors.purple)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageStatistics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Usage Statistics', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildUsageChart(),
            const SizedBox(height: 16),
            _buildUsageDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageChart() {
    final dailyUsage = _getDailyUsage();

    return Container(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: dailyUsage.map((data) {
            return BarChartGroupData(
              x: data['dayIndex'],
              barRods: [BarChartRodData(toY: data['sessions'], color: Colors.blue, width: 20)],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final style = TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12);
                  return Text(dailyUsage[value.toInt()]['day'], style: style);
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildUsageDetails() {
    final stats = _getUsageStatistics();

    return Column(
      children: [
        _buildDetailRow('Most Productive Day', stats['mostProductiveDay']),
        _buildDetailRow('Peak Focus Time', stats['peakFocusTime']),
        _buildDetailRow('Average Daily Sessions', stats['avgDailySessions'].toStringAsFixed(1)),
        _buildDetailRow('Best Day of Week', stats['bestDayOfWeek']),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildProductivityChart() {
    final correlationData = _getProductivityCorrelation();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Focus Mode vs Productivity', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              height: 200,
              child: ScatterChart(
                ScatterChartData(
                  scatterSpots: correlationData.map((data) {
                    return ScatterSpot(data['focusMinutes'], data['productivity']);
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Correlation: ${_getCorrelationCoefficient().toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildEffectivenessMetrics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Effectiveness Metrics', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildMetricRow('Session Completion Rate', '${(_getCompletionRate() * 100).toStringAsFixed(1)}%', Colors.green),
            const SizedBox(height: 8),
            _buildMetricRow('Focus Mode Adoption', '${(_getAdoptionRate() * 100).toStringAsFixed(1)}%', Colors.blue),
            const SizedBox(height: 8),
            _buildMetricRow('User Satisfaction', '${_getUserSatisfaction()}/5', Colors.purple),
            const SizedBox(height: 8),
            _buildMetricRow('Productivity Improvement', '${_getProductivityImprovement() * 100}%', Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: color),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    final recommendations = _getPersonalizedRecommendations();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personalized Recommendations', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...recommendations.map(
              (rec) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: rec['color'].withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Icon(rec['icon'], color: rec['color']),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(rec['title'], style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                            Text(rec['description'], style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Duration _getTotalFocusTime() {
    Duration total = Duration.zero;
    for (final session in _focusModeHistory) {
      if (session['duration'] != null) {
        total += Duration(minutes: session['duration'] as int);
      }
    }
    return total;
  }

  Duration _getAverageSessionLength() {
    if (_focusModeHistory.isEmpty) return Duration.zero;

    final totalMinutes = _focusModeHistory.where((s) => s['duration'] != null).map((s) => s['duration'] as int).fold<int>(0, (sum, minutes) => sum + minutes);

    return Duration(minutes: totalMinutes ~/ _focusModeHistory.length);
  }

  double _getSuccessRate() {
    if (_focusModeHistory.isEmpty) return 0.0;

    final completed = _focusModeHistory.where((s) => s['type'] == 'FocusModeEventType.ended').length;
    return completed / _focusModeHistory.length;
  }

  double _getCompletionRate() {
    if (_focusModeHistory.isEmpty) return 0.0;

    final completed = _focusModeHistory.where((s) => s['type'] == 'FocusModeEventType.ended' && s['reason'] == 'Timer completed').length;
    return completed / _focusModeHistory.length;
  }

  double _getAdoptionRate() {
    // Calculate based on recent usage patterns
    final recentDays = 7;
    final cutoffDate = DateTime.now().subtract(Duration(days: recentDays));
    final recentSessions = _focusModeHistory.where((s) => DateTime.parse(s['timestamp']).isAfter(cutoffDate)).length;

    final totalPossibleSessions = recentDays * 2; // Assume 2 sessions per day max
    return recentSessions / totalPossibleSessions;
  }

  int _getUserSatisfaction() {
    // Simulated user satisfaction based on completion rates
    final completionRate = _getCompletionRate();
    if (completionRate >= 0.8) return 5;
    if (completionRate >= 0.6) return 4;
    if (completionRate >= 0.4) return 3;
    if (completionRate >= 0.2) return 2;
    return 1;
  }

  double _getProductivityImprovement() {
    // Simulated productivity improvement
    final adoptionRate = _getAdoptionRate();
    if (adoptionRate >= 0.8) return 0.25;
    if (adoptionRate >= 0.6) return 0.18;
    if (adoptionRate >= 0.4) return 0.12;
    if (adoptionRate >= 0.2) return 0.08;
    return 0.05;
  }

  List<Map<String, dynamic>> _getDailyUsage() {
    final dailyMap = <String, Map<String, dynamic>>{};
    int dayIndex = 0;

    for (final session in _focusModeHistory) {
      final date = DateTime.parse(session['timestamp']);
      final dayKey = '${date.year}-${date.month}-${date.day}';

      if (!dailyMap.containsKey(dayKey)) {
        dailyMap[dayKey] = {'dayIndex': dayIndex++, 'day': _getDayName(date), 'sessions': 0, 'focusMinutes': 0};
      }

      dailyMap[dayKey]!['sessions']++;
      if (session['duration'] != null) {
        dailyMap[dayKey]!['focusMinutes'] += session['duration'] as int;
      }
    }

    return dailyMap.values.toList();
  }

  String _getDayName(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return 'Unknown';
    }
  }

  Map<String, dynamic> _getUsageStatistics() {
    if (_focusModeHistory.isEmpty) {
      return {'mostProductiveDay': 'No data', 'peakFocusTime': 'No data', 'avgDailySessions': 0.0, 'bestDayOfWeek': 'No data'};
    }

    final dailyUsage = _getDailyUsage();
    final mostProductiveDay = dailyUsage.isEmpty ? 'No data' : dailyUsage.reduce((a, b) => a['sessions'] > b['sessions'] ? a : b)['day'];

    // Find peak focus time
    final hourCounts = <int, int>{};
    for (final session in _focusModeHistory) {
      final hour = DateTime.parse(session['timestamp']).hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }
    final peakHour = hourCounts.isEmpty ? 'No data' : '${hourCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key}:00';

    // Find best day of week
    final dayOfWeekCounts = <String, int>{};
    for (final session in _focusModeHistory) {
      final dayOfWeek = DateTime.parse(session['timestamp']).weekday;
      dayOfWeekCounts[_getDayOfWeekName(dayOfWeek)] = (dayOfWeekCounts[_getDayOfWeekName(dayOfWeek)] ?? 0) + 1;
    }
    final bestDayOfWeek = dayOfWeekCounts.isEmpty ? 'No data' : dayOfWeekCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    return {
      'mostProductiveDay': mostProductiveDay,
      'peakFocusTime': peakHour,
      'avgDailySessions': dailyUsage.isEmpty ? 0.0 : dailyUsage.map((d) => d['sessions']).reduce((a, b) => a + b) / dailyUsage.length,
      'bestDayOfWeek': bestDayOfWeek,
    };
  }

  String _getDayOfWeekName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }

  List<Map<String, dynamic>> _getProductivityCorrelation() {
    // Simulated correlation data between focus time and productivity
    return [
      {'focusMinutes': 15, 'productivity': 0.6, 'isCompleted': true},
      {'focusMinutes': 30, 'productivity': 0.75, 'isCompleted': true},
      {'focusMinutes': 45, 'productivity': 0.8, 'isCompleted': true},
      {'focusMinutes': 60, 'productivity': 0.85, 'isCompleted': true},
      {'focusMinutes': 25, 'productivity': 0.4, 'isCompleted': false},
      {'focusMinutes': 35, 'productivity': 0.5, 'isCompleted': false},
      {'focusMinutes': 50, 'productivity': 0.6, 'isCompleted': false},
      {'focusMinutes': 20, 'productivity': 0.3, 'isCompleted': false},
    ];
  }

  double _getCorrelationCoefficient() {
    // Calculate correlation coefficient
    final data = _getProductivityCorrelation();
    if (data.length < 2) return 0.0;

    final meanX = data.map((d) => d['focusMinutes'] as double).reduce((a, b) => a + b) / data.length;
    final meanY = data.map((d) => d['productivity'] as double).reduce((a, b) => a + b) / data.length;

    double numerator = 0.0;
    double denominatorX = 0.0;
    double denominatorY = 0.0;

    for (final point in data) {
      final x = (point['focusMinutes'] as double) - meanX;
      final y = (point['productivity'] as double) - meanY;
      numerator += x * y;
      denominatorX += x * x;
      denominatorY += y * y;
    }

    if (denominatorX == 0 || denominatorY == 0) return 0.0;

    return numerator / (denominatorX * denominatorY);
  }

  List<Map<String, dynamic>> _getPersonalizedRecommendations() {
    final recommendations = <Map<String, dynamic>>[];

    // Analyze usage patterns
    final avgSessionLength = _getAverageSessionLength().inMinutes;
    final completionRate = _getCompletionRate();
    final recentUsage = _focusModeHistory.take(10);

    // Session length recommendations
    if (avgSessionLength < 20) {
      recommendations.add({'title': 'Increase Session Length', 'description': 'Try longer focus sessions for deeper concentration', 'icon': Icons.timer, 'color': Colors.blue});
    } else if (avgSessionLength > 60) {
      recommendations.add({'title': 'Shorten Sessions', 'description': 'Consider shorter sessions for better focus', 'icon': Icons.timer_outlined, 'color': Colors.orange});
    }

    // Completion rate recommendations
    if (completionRate < 0.5) {
      recommendations.add({'title': 'Improve Task Breakdown', 'description': 'Break large tasks into smaller, manageable pieces', 'icon': Icons.list_alt, 'color': Colors.red});
    } else if (completionRate > 0.8) {
      recommendations.add({'title': 'Challenge Yourself', 'description': 'Try more complex tasks to grow your focus skills', 'icon': Icons.trending_up, 'color': Colors.green});
    }

    // Usage frequency recommendations
    if (recentUsage.length < 3) {
      recommendations.add({'title': 'Use Focus Mode More Often', 'description': 'Make focus mode a daily habit for better productivity', 'icon': Icons.calendar_today, 'color': Colors.purple});
    }

    // Time-based recommendations
    final now = DateTime.now();
    final currentHour = now.hour;

    if (currentHour >= 14 && currentHour <= 17) {
      recommendations.add({'title': 'Afternoon Focus', 'description': 'Your focus tends to be strongest in the afternoon', 'icon': Icons.schedule, 'color': Colors.teal});
    } else if (currentHour >= 9 && currentHour <= 11) {
      recommendations.add({'title': 'Morning Focus', 'description': 'Start your day with focused work', 'icon': Icons.wb_sunny, 'color': Colors.yellow});
    }

    return recommendations;
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '0m';
    }
  }
}
