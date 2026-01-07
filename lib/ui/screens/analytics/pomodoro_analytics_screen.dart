import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../models/task.dart';
import '../../../models/pomodoro_plan.dart';
import '../../../services/pomodoro_recommendation_engine.dart' as rec;
import '../../../services/adaptive_session_timing_service.dart' as timing;

/// Analytics dashboard for pomodoro insights and productivity tracking
class PomodoroAnalyticsScreen extends StatefulWidget {
  const PomodoroAnalyticsScreen({super.key});

  @override
  State<PomodoroAnalyticsScreen> createState() => _PomodoroAnalyticsScreenState();
}

class _PomodoroAnalyticsScreenState extends State<PomodoroAnalyticsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;

  // Analytics data
  List<CompletedPomodoroSession> _sessionHistory = [];
  List<Task> _completedTasks = [];
  Map<String, dynamic> _analyticsData = {};

  // Services
  final rec.PomodoroRecommendationEngine _recommendationEngine = rec.PomodoroRecommendationEngine();
  final timing.AdaptiveSessionTimingService _timingService = timing.AdaptiveSessionTimingService();

  // UI state
  bool _isLoading = true;
  String _selectedTimeRange = 'Week';
  DateTimeRange _selectedDateRange = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _animationController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _loadAnalyticsData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadAnalyticsData() async {
    setState(() => _isLoading = true);

    try {
      // In a real implementation, this would load from Firebase/local storage
      await Future.delayed(const Duration(milliseconds: 1000)); // Simulate loading

      // Mock data for demonstration
      _sessionHistory = _generateMockSessionHistory();
      _completedTasks = _generateMockCompletedTasks();
      _analyticsData = _calculateAnalyticsData();

      _animationController.forward();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading analytics: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Map<String, dynamic> _calculateAnalyticsData() {
    if (_sessionHistory.isEmpty) return {};

    // Calculate key metrics
    final totalSessions = _sessionHistory.length;
    final totalMinutes = _sessionHistory.fold<int>(0, (sum, session) => sum + session.actualDuration);
    final avgFocus = _sessionHistory.fold<double>(0, (sum, session) => sum + session.focusRating) / totalSessions;
    final completionRate = _sessionHistory.where((s) => s.completed).length / totalSessions;

    // Calculate productivity by hour
    final hourlyProductivity = <int, double>{};
    for (final session in _sessionHistory) {
      final hour = session.startTime.hour;
      hourlyProductivity[hour] = (hourlyProductivity[hour] ?? 0) + session.focusRating;
    }

    // Normalize hourly productivity
    for (final entry in hourlyProductivity.entries) {
      final sessionCount = _sessionHistory.where((s) => s.startTime.hour == entry.key).length;
      hourlyProductivity[entry.key] = entry.value / sessionCount;
    }

    // Calculate task completion by priority
    final priorityCompletion = <TaskPriority, int>{};
    for (final task in _completedTasks) {
      priorityCompletion[task.priority] = (priorityCompletion[task.priority] ?? 0) + 1;
    }

    return {
      'totalSessions': totalSessions,
      'totalHours': (totalMinutes / 60).toStringAsFixed(1),
      'avgFocus': avgFocus.toStringAsFixed(1),
      'completionRate': (completionRate * 100).toStringAsFixed(0),
      'hourlyProductivity': hourlyProductivity,
      'priorityCompletion': priorityCompletion,
      'mostProductiveHour': hourlyProductivity.entries.isEmpty ? null : hourlyProductivity.entries.reduce((a, b) => a.value > b.value ? a : b).key,
      'currentStreak': _calculateCurrentStreak(),
      'weeklyGoal': 20, // Mock weekly goal
      'weeklyProgress': totalSessions % 20,
    };
  }

  int _calculateCurrentStreak() {
    // Calculate consecutive days with pomodoro sessions
    final today = DateTime.now();
    int streak = 0;

    for (int i = 0; i < 30; i++) {
      final date = today.subtract(Duration(days: i));
      final hasSession = _sessionHistory.any((session) => session.startTime.year == date.year && session.startTime.month == date.month && session.startTime.day == date.day);

      if (hasSession) {
        streak++;
      } else if (i > 0) {
        break;
      }
    }

    return streak;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Analytics', style: Theme.of(context).textTheme.titleLarge),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Productivity'),
            Tab(text: 'Insights'),
            Tab(text: 'Trends'),
          ],
        ),
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : TabBarView(controller: _tabController, children: [_buildOverviewTab(), _buildProductivityTab(), _buildInsightsTab(), _buildTrendsTab()]),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Range Selector
          _buildTimeRangeSelector(),
          const SizedBox(height: 24),

          // Key Metrics Cards
          _buildMetricsGrid(),
          const SizedBox(height: 24),

          // Weekly Progress
          _buildWeeklyProgressCard(),
          const SizedBox(height: 24),

          // Current Streak
          _buildStreakCard(),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(Icons.date_range, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text('Time Range:', style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          DropdownButton<String>(
            value: _selectedTimeRange,
            items: ['Day', 'Week', 'Month', 'Year'].map((range) {
              return DropdownMenuItem(value: range, child: Text(range));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedTimeRange = value;
                  _updateDateRange();
                });
                _loadAnalyticsData();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildMetricCard('Total Sessions', _analyticsData['totalSessions']?.toString() ?? '0', Icons.timer, Colors.blue),
        _buildMetricCard('Total Hours', '${_analyticsData['totalHours'] ?? '0'}h', Icons.schedule, Colors.green),
        _buildMetricCard('Avg Focus', '${_analyticsData['avgFocus'] ?? '0'}/10', Icons.psychology, Colors.orange),
        _buildMetricCard('Completion Rate', '${_analyticsData['completionRate'] ?? '0'}%', Icons.check_circle, Colors.purple),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgressCard() {
    final weeklyGoal = _analyticsData['weeklyGoal'] as int? ?? 20;
    final weeklyProgress = _analyticsData['weeklyProgress'] as int? ?? 0;
    final progress = weeklyProgress / weeklyGoal;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Goal Progress', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(progress >= 1.0 ? Colors.green : Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('$weeklyProgress of $weeklyGoal sessions'), Text('${(progress * 100).toInt()}%')]),
        ],
      ),
    );
  }

  Widget _buildStreakCard() {
    final currentStreak = _analyticsData['currentStreak'] as int? ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.orange.withOpacity(0.1), Colors.red.withOpacity(0.1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.local_fire_department, color: Colors.orange, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Streak', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  '$currentStreak days',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductivityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Productivity Analysis', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),

          // Hourly Productivity Chart
          _buildHourlyProductivityChart(),
          const SizedBox(height: 24),

          // Task Priority Distribution
          _buildTaskPriorityChart(),
          const SizedBox(height: 24),

          // Focus Score Distribution
          _buildFocusScoreChart(),
        ],
      ),
    );
  }

  Widget _buildInsightsTab() {
    final patternAnalysis = timing.SessionPatternAnalysis(
      averageSessionDuration: 25,
      optimalDurationRange: timing.DurationRange(min: 20, max: 30),
      performanceTrend: timing.PerformanceTrend.stable,
      recommendedAdjustments: [],
      focusPattern: timing.FocusPattern.inconsistent,
      energyPattern: timing.EnergyPattern.inconsistent,
    );

    _timingService.analyzeSessionPatterns(_sessionHistory);
    final recommendations = _recommendationEngine.suggestTasksForCurrentTime(_completedTasks);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personalized Insights', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),

          // Pattern Analysis
          _buildPatternAnalysisCard(patternAnalysis),
          const SizedBox(height: 16),

          // Recommendations
          _buildRecommendationsCard(recommendations),
          const SizedBox(height: 16),

          // Performance Tips
          _buildPerformanceTipsCard(),
        ],
      ),
    );
  }

  Widget _buildPatternAnalysisCard(timing.SessionPatternAnalysis analysis) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Session Pattern Analysis', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),

          _buildInsightRow('Average Session Duration', '${analysis.averageSessionDuration} min'),
          _buildInsightRow('Optimal Range', '${analysis.optimalDurationRange.min}-${analysis.optimalDurationRange.max} min'),
          _buildInsightRow('Performance Trend', analysis.performanceTrend.name),
          _buildInsightRow('Focus Pattern', analysis.focusPattern.name),
          _buildInsightRow('Energy Pattern', analysis.energyPattern.name),

          if (analysis.recommendedAdjustments.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Recommended Adjustments:', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            ...analysis.recommendedAdjustments.map((adjustment) => Padding(padding: const EdgeInsets.only(left: 16, top: 4), child: Text('• $adjustment'))),
          ],
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard(List<Task> recommendations) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Task Recommendations', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),

          if (recommendations.isEmpty)
            Text('No recommendations available at this time.')
          else
            ...recommendations
                .take(5)
                .map(
                  (task) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Theme.of(context).colorScheme.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(task.title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                              Text('${task.priority.name} • ${task.focusScore}/10 focus', style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTipsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue.withOpacity(0.1), Colors.purple.withOpacity(0.1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates, color: Colors.blue, size: 24),
              const SizedBox(width: 12),
              Text('Performance Tips', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 16),

          ..._generatePerformanceTips().map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.blue, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(tip, style: Theme.of(context).textTheme.bodyMedium)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Performance Trends', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),

          // Weekly Trend Chart
          _buildPlaceholderChart('Weekly Session Count', 'Chart visualization coming soon'),
          const SizedBox(height: 24),

          // Focus Trend Chart
          _buildPlaceholderChart('Weekly Focus Trend', 'Chart visualization coming soon'),
          const SizedBox(height: 24),

          // Session Duration Trend
          _buildPlaceholderChart('Session Duration Trend', 'Chart visualization coming soon'),
        ],
      ),
    );
  }

  // Helper methods

  Widget _buildHourlyProductivityChart() {
    final hourlyData = [
      HourlyProductivityData('6AM', 65),
      HourlyProductivityData('8AM', 85),
      HourlyProductivityData('10AM', 92),
      HourlyProductivityData('12PM', 78),
      HourlyProductivityData('2PM', 88),
      HourlyProductivityData('4PM', 75),
      HourlyProductivityData('6PM', 70),
      HourlyProductivityData('8PM', 45),
    ];

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hourly Productivity', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(labelStyle: TextStyle(fontSize: 10), majorGridLines: const MajorGridLines(width: 0)),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 100,
                labelStyle: TextStyle(fontSize: 10),
                majorGridLines: MajorGridLines(width: 0.5, color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<HourlyProductivityData, String>>[
                SplineAreaSeries<HourlyProductivityData, String>(
                  dataSource: hourlyData,
                  xValueMapper: (HourlyProductivityData data, _) => data.hour,
                  yValueMapper: (HourlyProductivityData data, _) => data.productivity,
                  gradient: LinearGradient(
                    colors: [Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderColor: Theme.of(context).colorScheme.primary,
                  borderWidth: 2,
                  dataLabelSettings: DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.outside),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskPriorityChart() {
    final priorityData = [PriorityData('High', 35, Colors.red), PriorityData('Medium', 45, Colors.orange), PriorityData('Low', 20, Colors.green)];

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Task Priority Distribution', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Expanded(
            child: SfCircularChart(
              tooltipBehavior: TooltipBehavior(enable: true),
              legend: Legend(isVisible: true, position: LegendPosition.bottom, textStyle: TextStyle(fontSize: 12)),
              series: <CircularSeries>[
                PieSeries<PriorityData, String>(
                  dataSource: priorityData,
                  xValueMapper: (PriorityData data, _) => data.priority,
                  yValueMapper: (PriorityData data, _) => data.percentage,
                  pointColorMapper: (PriorityData data, _) => data.color,
                  dataLabelSettings: const DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.outside),
                  enableTooltip: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusScoreChart() {
    final focusData = [FocusScoreData('Mon', 85), FocusScoreData('Tue', 78), FocusScoreData('Wed', 92), FocusScoreData('Thu', 88), FocusScoreData('Fri', 75), FocusScoreData('Sat', 65), FocusScoreData('Sun', 70)];

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Focus Score Distribution', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(labelStyle: TextStyle(fontSize: 10), majorGridLines: const MajorGridLines(width: 0)),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 100,
                labelStyle: TextStyle(fontSize: 10),
                majorGridLines: MajorGridLines(width: 0.5, color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<FocusScoreData, String>>[
                ColumnSeries<FocusScoreData, String>(
                  dataSource: focusData,
                  xValueMapper: (FocusScoreData data, _) => data.day,
                  yValueMapper: (FocusScoreData data, _) => data.score,
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderChart(String title, String message) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.insert_chart, size: 48, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(message, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  List<String> _generatePerformanceTips() {
    final avgFocus = double.tryParse(_analyticsData['avgFocus'] as String? ?? '0') ?? 0;
    final completionRate = double.tryParse(_analyticsData['completionRate'] as String? ?? '0') ?? 0;

    final tips = <String>[];

    if (avgFocus < 6) {
      tips.add('Try shorter sessions (15-20 min) to maintain focus');
      tips.add('Consider taking more frequent breaks');
    } else if (avgFocus >= 8) {
      tips.add('Great focus! Consider extending sessions to 30-35 min');
    }

    if (completionRate < 70) {
      tips.add('Set more realistic session goals');
      tips.add('Break down complex tasks into smaller pieces');
    } else if (completionRate >= 90) {
      tips.add('Excellent completion rate! Keep up the great work');
    }

    tips.add('Stay hydrated during sessions');
    tips.add('Use the 5-minute rule: if a task takes less than 5 minutes, do it now');
    tips.add('Review your completed sessions weekly to identify patterns');

    return tips;
  }

  void _updateDateRange() {
    final now = DateTime.now();
    switch (_selectedTimeRange) {
      case 'Day':
        _selectedDateRange = DateTimeRange(start: now, end: now);
        break;
      case 'Week':
        _selectedDateRange = DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now);
        break;
      case 'Month':
        _selectedDateRange = DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now);
        break;
      case 'Year':
        _selectedDateRange = DateTimeRange(start: now.subtract(const Duration(days: 365)), end: now);
        break;
    }
  }

  // Mock data generators (in real implementation, these would come from Firebase/local storage)

  List<CompletedPomodoroSession> _generateMockSessionHistory() {
    final now = DateTime.now();
    final sessions = <CompletedPomodoroSession>[];

    for (int i = 0; i < 50; i++) {
      final sessionTime = now.subtract(Duration(hours: i * 2));
      sessions.add(
        CompletedPomodoroSession(
          id: 'session_$i',
          taskId: 'task_${i % 10}',
          sessionNumber: (i % 4) + 1,
          type: SessionType.work,
          startTime: sessionTime,
          endTime: sessionTime.add(Duration(minutes: 20 + (i % 15))),
          actualDuration: 20 + (i % 15),
          completed: (i % 10) < 8,
          focusRating: 5 + (i % 6),
        ),
      );
    }

    return sessions;
  }

  List<Task> _generateMockCompletedTasks() {
    final tasks = <Task>[];
    final priorities = TaskPriority.values;

    for (int i = 0; i < 20; i++) {
      tasks.add(
        Task(
          id: 'task_$i',
          title: 'Sample Task $i',
          description: 'Description for task $i',
          priority: priorities[i % priorities.length],
          focusScore: 3 + (i % 8),
          isCompleted: true,
          createdAt: DateTime.now().subtract(Duration(days: i)),
          updatedAt: DateTime.now().subtract(Duration(days: i)),
        ),
      );
    }

    return tasks;
  }
}

// Data model classes for charts
class HourlyProductivityData {
  final String hour;
  final double productivity;

  HourlyProductivityData(this.hour, this.productivity);
}

class PriorityData {
  final String priority;
  final double percentage;
  final Color color;

  PriorityData(this.priority, this.percentage, this.color);
}

class FocusScoreData {
  final String day;
  final double score;

  FocusScoreData(this.day, this.score);
}

// Chart data class
class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}
