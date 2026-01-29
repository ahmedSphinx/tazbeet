import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import '../../../models/task.dart';
import '../../../models/pomodoro_plan.dart';
import '../../../repositories/task_repository.dart';
import '../../../services/pomodoro_recommendation_engine.dart' as rec;
import '../../../services/adaptive_session_timing_service.dart' as timing;

/// Analytics dashboard for pomodoro insights and productivity tracking
class PomodoroAnalyticsScreen extends StatefulWidget {
  const PomodoroAnalyticsScreen({super.key, required this.taskRepository});

  final TaskRepository taskRepository;

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
  late final TaskRepository _taskRepository;

  // UI state
  bool _isLoading = true;
  String _selectedTimeRange = '';
  DateTimeRange _selectedDateRange = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now());

  @override
  void initState() {
    super.initState();
    _taskRepository = widget.taskRepository;
    _tabController = TabController(length: 4, vsync: this);
    _animationController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _loadAnalyticsData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedTimeRange = AppLocalizations.of(context)!.week;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _refreshAnalyticsData() async {
    await _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    setState(() => _isLoading = true);

    try {
      // Load real data from TaskRepository
      await _loadRealSessionHistory();
      await _loadRealCompletedTasks();
      _analyticsData = _calculateAnalyticsData();

      _animationController.forward();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorLoadingAnalytics(e.toString()))));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Map<String, dynamic> _calculateAnalyticsData() {
    final l10n = AppLocalizations.of(context)!;
    final defaultWeeklyGoal = int.tryParse(l10n.defaultWeeklyGoal) ?? 20;

    if (_sessionHistory.isEmpty && _completedTasks.isEmpty) {
      return {
        'totalSessions': 0,
        'totalHours': '0.0',
        'avgFocus': '0.0',
        'completionRate': '0',
        'hourlyProductivity': <int, double>{},
        'priorityCompletion': <TaskPriority, int>{},
        'mostProductiveHour': null,
        'currentStreak': 0,
        'weeklyGoal': defaultWeeklyGoal,
        'weeklyProgress': 0,
        'totalTasks': _completedTasks.length,
        'avgSessionDuration': 0.0,
        'totalFocusTime': Duration.zero,
      };
    }

    // Calculate key metrics from real session data
    final workSessions = _sessionHistory.where((s) => s.type == SessionType.work);
    final totalSessions = workSessions.length;

    if (totalSessions == 0) {
      // Fall back to task-based metrics if no sessions
      return _calculateTaskBasedAnalytics(defaultWeeklyGoal);
    }

    final totalMinutes = workSessions.fold<int>(0, (sum, session) => sum + session.actualDuration);
    final focusSessions = workSessions.where((s) => s.focusRating > 0);
    final avgFocus = focusSessions.isEmpty ? 0.0 : focusSessions.fold<double>(0, (sum, session) => sum + session.focusRating) / focusSessions.length;
    final completedSessions = workSessions.where((s) => s.completed).length;
    final completionRate = totalSessions > 0 ? (completedSessions / totalSessions) * 100 : 0.0;

    // Calculate productivity by hour
    final hourlyProductivity = <int, double>{};
    final hourlySessionCounts = <int, int>{};

    for (final session in workSessions) {
      final hour = session.startTime.hour;
      final productivity = session.completed ? 1.0 : 0.5; // Partial credit for incomplete sessions

      hourlyProductivity[hour] = (hourlyProductivity[hour] ?? 0.0) + productivity;
      hourlySessionCounts[hour] = (hourlySessionCounts[hour] ?? 0) + 1;
    }

    // Average productivity per hour
    for (final hour in hourlyProductivity.keys) {
      if (hourlySessionCounts[hour]! > 0) {
        hourlyProductivity[hour] = hourlyProductivity[hour]! / hourlySessionCounts[hour]!;
      }
    }

    // Calculate priority completion
    final priorityCompletion = <TaskPriority, int>{};
    for (final task in _completedTasks) {
      priorityCompletion[task.priority] = (priorityCompletion[task.priority] ?? 0) + 1;
    }

    // Find most productive hour
    int? mostProductiveHour;
    double maxProductivity = 0.0;
    for (final entry in hourlyProductivity.entries) {
      if (entry.value > maxProductivity) {
        maxProductivity = entry.value;
        mostProductiveHour = entry.key;
      }
    }

    // Calculate total focus time
    final totalFocusTime = Duration(minutes: totalMinutes);
    final avgSessionDuration = totalSessions > 0 ? totalMinutes / totalSessions : 0.0;

    return {
      'totalSessions': totalSessions,
      'totalHours': (totalMinutes / 60).toStringAsFixed(1),
      'avgFocus': avgFocus.toStringAsFixed(1),
      'completionRate': completionRate.toStringAsFixed(0),
      'hourlyProductivity': hourlyProductivity,
      'priorityCompletion': priorityCompletion,
      'mostProductiveHour': mostProductiveHour,
      'currentStreak': _calculateCurrentStreak(),
      'weeklyGoal': defaultWeeklyGoal,
      'weeklyProgress': _calculateWeeklyProgress(),
      'totalTasks': _completedTasks.length,
      'avgSessionDuration': avgSessionDuration.toStringAsFixed(1),
      'totalFocusTime': totalFocusTime,
    };
  }

  Map<String, dynamic> _calculateTaskBasedAnalytics(int defaultWeeklyGoal) {
    // Fallback analytics based on task data when no session data is available
    final totalTasks = _completedTasks.length;
    final totalMinutes = _completedTasks.fold<int>(0, (sum, task) => sum + task.timeSpent.inMinutes);
    final avgFocus = _completedTasks.isEmpty ? 0.0 : _completedTasks.fold<double>(0, (sum, task) => sum + task.focusScore) / _completedTasks.length;

    // Calculate priority completion
    final priorityCompletion = <TaskPriority, int>{};
    for (final task in _completedTasks) {
      priorityCompletion[task.priority] = (priorityCompletion[task.priority] ?? 0) + 1;
    }

    return {
      'totalSessions': _completedTasks.fold<int>(0, (sum, task) => sum + task.pomodoroCount),
      'totalHours': (totalMinutes / 60).toStringAsFixed(1),
      'avgFocus': avgFocus.toStringAsFixed(1),
      'completionRate': '100', // All tasks in this list are either completed or have activity
      'hourlyProductivity': <int, double>{},
      'priorityCompletion': priorityCompletion,
      'mostProductiveHour': null,
      'currentStreak': _calculateCurrentStreak(),
      'weeklyGoal': defaultWeeklyGoal,
      'weeklyProgress': _calculateWeeklyProgress(),
      'totalTasks': totalTasks,
      'avgSessionDuration': totalTasks > 0 ? (totalMinutes / totalTasks).toStringAsFixed(1) : '0.0',
      'totalFocusTime': Duration(minutes: totalMinutes),
    };
  }

  int _calculateCurrentStreak() {
    // Calculate consecutive days with pomodoro sessions from real data
    final today = DateTime.now();
    int streak = 0;

    for (int i = 0; i < 30; i++) {
      final date = today.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      // Check for sessions on this day
      final daySessions = _sessionHistory.where((session) => session.startTime.isAfter(dayStart) && session.startTime.isBefore(dayEnd) && session.type == SessionType.work).toList();

      // Also check for tasks with pomodoro activity on this day
      final dayTasks = _completedTasks.where((task) => task.lastPomodoroDate != null && task.lastPomodoroDate!.isAfter(dayStart) && task.lastPomodoroDate!.isBefore(dayEnd)).toList();

      if (daySessions.isNotEmpty || dayTasks.isNotEmpty) {
        streak++;
      } else if (i > 0) {
        // Break streak if no activity found and this isn't the first day being checked
        break;
      }
    }

    return streak;
  }

  int _calculateWeeklyProgress() {
    // Calculate sessions completed this week
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1)); // Start of current week (Monday)
    final weekStartDay = DateTime(weekStart.year, weekStart.month, weekStart.day);

    int weeklySessions = 0;

    // Count sessions from this week
    for (final session in _sessionHistory) {
      if (session.startTime.isAfter(weekStartDay) && session.startTime.isBefore(now.add(const Duration(days: 1))) && session.type == SessionType.work) {
        weeklySessions++;
      }
    }

    // Also count pomodoro sessions from tasks that don't have detailed session records
    for (final task in _completedTasks) {
      if (task.lastPomodoroDate != null && task.lastPomodoroDate!.isAfter(weekStartDay) && task.lastPomodoroDate!.isBefore(now.add(const Duration(days: 1)))) {
        weeklySessions += task.pomodoroCount;
      }
    }

    return weeklySessions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pomodoroAnalytics, style: Theme.of(context).textTheme.titleLarge),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.overview),
            Tab(text: AppLocalizations.of(context)!.productivity),
            Tab(text: AppLocalizations.of(context)!.insights),
            Tab(text: AppLocalizations.of(context)!.trends),
          ],
        ),
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : TabBarView(controller: _tabController, children: [_buildOverviewTab(), _buildProductivityTab(), _buildInsightsTab(), _buildTrendsTab()]),
    );
  }

  Widget _buildOverviewTab() {
    return RefreshIndicator(
      onRefresh: _refreshAnalyticsData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // Enable pull-to-refresh
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
          Text(AppLocalizations.of(context)!.timeRange, style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          DropdownButton<String>(
            value: _selectedTimeRange,
            items: [
              DropdownMenuItem(value: AppLocalizations.of(context)!.day, child: Text(AppLocalizations.of(context)!.day)),
              DropdownMenuItem(value: AppLocalizations.of(context)!.week, child: Text(AppLocalizations.of(context)!.week)),
              DropdownMenuItem(value: AppLocalizations.of(context)!.month, child: Text(AppLocalizations.of(context)!.month)),
              DropdownMenuItem(value: AppLocalizations.of(context)!.year, child: Text(AppLocalizations.of(context)!.year)),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedTimeRange = value;
                  _updateDateRange();
                });
                _refreshAnalyticsData(); // Refresh data when time range changes
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
        _buildMetricCard(AppLocalizations.of(context)!.totalSessions, _analyticsData['totalSessions']?.toString() ?? '0', Icons.timer, Colors.blue),
        _buildMetricCard(AppLocalizations.of(context)!.totalHours, '${_analyticsData['totalHours'] ?? '0'}${AppLocalizations.of(context)!.hours}', Icons.schedule, Colors.green),
        _buildMetricCard(AppLocalizations.of(context)!.avgFocus(_analyticsData['avgFocus']?.toString() ?? '0'), '${_analyticsData['avgFocus'] ?? '0'}/10', Icons.psychology, Colors.orange),
        _buildMetricCard(AppLocalizations.of(context)!.completionRate, '${_analyticsData['completionRate'] ?? '0'}%', Icons.check_circle, Colors.purple),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
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
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgressCard() {
    final l10n = AppLocalizations.of(context)!;
    final defaultWeeklyGoal = int.tryParse(l10n.defaultWeeklyGoal) ?? 20;
    final weeklyGoal = _analyticsData['weeklyGoal'] as int? ?? defaultWeeklyGoal;
    final weeklyProgress = _analyticsData['weeklyProgress'] as int? ?? 0;
    final progress = weeklyProgress / weeklyGoal;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.weeklyGoalProgress, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: progress, backgroundColor: Theme.of(context).colorScheme.surfaceVariant, valueColor: AlwaysStoppedAnimation<Color>(progress >= 1.0 ? Colors.green : Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('$weeklyProgress ${AppLocalizations.of(context)!.offf} $weeklyGoal ${AppLocalizations.of(context)!.sessions}'), Text('${(progress * 100).toInt()}%')]),
        ],
      ),
    );
  }

  Widget _buildStreakCard() {
    final currentStreak = _analyticsData['currentStreak'] as int? ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.orange.withValues(alpha: 0.1), Colors.red.withValues(alpha: 0.1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.local_fire_department, color: Colors.orange, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.currentStreak, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  '$currentStreak ${AppLocalizations.of(context)!.days(currentStreak)} ',
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
          Text(AppLocalizations.of(context)!.productivityAnalysis, style: Theme.of(context).textTheme.headlineSmall),
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
          Text(AppLocalizations.of(context)!.personalizedInsights, style: Theme.of(context).textTheme.headlineSmall),
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
          Text(AppLocalizations.of(context)!.sessionPatternAnalysis, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),

          _buildInsightRow(AppLocalizations.of(context)!.averageSessionDuration, '${analysis.averageSessionDuration} min'),
          _buildInsightRow(AppLocalizations.of(context)!.optimalRange, '${analysis.optimalDurationRange.min}-${analysis.optimalDurationRange.max} min'),
          _buildInsightRow(AppLocalizations.of(context)!.performanceTrend, analysis.performanceTrend.name),
          _buildInsightRow(AppLocalizations.of(context)!.focusPattern, analysis.focusPattern.name),
          _buildInsightRow(AppLocalizations.of(context)!.energyPattern, analysis.energyPattern.name),

          if (analysis.recommendedAdjustments.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.recommendedAdjustments, style: Theme.of(context).textTheme.titleSmall),
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
          Text(AppLocalizations.of(context)!.taskRecommendations, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),

          if (recommendations.isEmpty)
            Text(AppLocalizations.of(context)!.noRecommendationsAvailable)
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
                              Text('${task.priority.name} • ${task.focusScore}/10 ${AppLocalizations.of(context)!.focus}', style: Theme.of(context).textTheme.bodySmall),
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
        gradient: LinearGradient(colors: [Colors.blue.withValues(alpha: 0.1), Colors.purple.withValues(alpha: 0.1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates, color: Colors.blue, size: 24),
              const SizedBox(width: 12),
              Text(AppLocalizations.of(context)!.performanceTips, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blue)),
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
          Text(AppLocalizations.of(context)!.performanceTrends, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),

          // Weekly Trend Chart
          _buildWeeklySessionCountChart(),
          const SizedBox(height: 24),

          // Focus Trend Chart
          _buildWeeklyFocusTrendChart(),
          const SizedBox(height: 24),

          // Session Duration Trend
          _buildSessionDurationTrendChart(),
        ],
      ),
    );
  }

  // Helper methods

  Widget _buildHourlyProductivityChart() {
    final l10n = AppLocalizations.of(context)!;
    final hourlyData = [
      HourlyProductivityData('6${l10n.am}', 65),
      HourlyProductivityData('8${l10n.am}', 85),
      HourlyProductivityData('10${l10n.am}', 92),
      HourlyProductivityData('12${l10n.pm}', 78),
      HourlyProductivityData('2${l10n.pm}', 88),
      HourlyProductivityData('4${l10n.pm}', 75),
      HourlyProductivityData('6${l10n.pm}', 70),
      HourlyProductivityData('8${l10n.pm}', 45),
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
          Text(AppLocalizations.of(context)!.hourlyProductivity, style: Theme.of(context).textTheme.titleMedium),
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
                  gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
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
    final l10n = AppLocalizations.of(context)!;
    final priorityData = [PriorityData(l10n.high, 35, Colors.red), PriorityData(l10n.medium, 45, Colors.orange), PriorityData(l10n.low, 20, Colors.green)];

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
          Text(AppLocalizations.of(context)!.taskPriorityDistribution, style: Theme.of(context).textTheme.titleMedium),
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
    final l10n = AppLocalizations.of(context)!;
    final focusData = [FocusScoreData(l10n.mon, 85), FocusScoreData(l10n.tue, 78), FocusScoreData(l10n.wed, 92), FocusScoreData(l10n.thu, 88), FocusScoreData(l10n.fri, 75), FocusScoreData(l10n.sat, 65), FocusScoreData(l10n.sun, 70)];

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
          Text(AppLocalizations.of(context)!.focusScoreDistribution, style: Theme.of(context).textTheme.titleMedium),
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

  Widget _buildWeeklySessionCountChart() {
    final weeklyData = _generateWeeklySessionData();

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.weeklySessionCount, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Expanded(
            child: weeklyData.isEmpty
                ? _buildNoDataWidget()
                : SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      labelStyle: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                    ),
                    primaryYAxis: NumericAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      labelStyle: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                    ),
                    series: <CartesianSeries<ChartData, String>>[
                      SplineSeries<ChartData, String>(
                        dataSource: weeklyData,
                        xValueMapper: (ChartData data, _) => data.day,
                        yValueMapper: (ChartData data, _) => data.value.toDouble(),
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                        markerSettings: const MarkerSettings(isVisible: true),
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                          textStyle: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyFocusTrendChart() {
    final focusData = _generateWeeklyFocusData();

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.weeklyFocusTrend, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Expanded(
            child: focusData.isEmpty
                ? _buildNoDataWidget()
                : SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      labelStyle: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                    ),
                    primaryYAxis: NumericAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      labelStyle: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                      minimum: 0,
                      maximum: 10,
                    ),
                    series: <CartesianSeries>[
                      SplineSeries<ChartData, String>(
                        dataSource: focusData,
                        xValueMapper: (ChartData data, _) => data.day,
                        yValueMapper: (ChartData data, _) => data.value.toDouble(),
                        color: Colors.green,
                        width: 3,
                        markerSettings: const MarkerSettings(isVisible: true),
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                          textStyle: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionDurationTrendChart() {
    final l10n = AppLocalizations.of(context)!;
    final durationData = _generateWeeklyDurationData();

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.sessionDurationTrend, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Expanded(
            child: durationData.isEmpty
                ? _buildNoDataWidget()
                : SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      labelStyle: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                    ),
                    primaryYAxis: NumericAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      labelStyle: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                      labelFormat: '{value}${l10n.min}',
                    ),
                    series: <CartesianSeries>[
                      ColumnSeries<ChartData, String>(
                        dataSource: durationData,
                        xValueMapper: (ChartData data, _) => data.day,
                        yValueMapper: (ChartData data, _) => data.value.toDouble(),
                        color: Theme.of(context).colorScheme.primary,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                          textStyle: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insert_chart_outlined, size: 48, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.noDataAvailable, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
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
      tips.add(AppLocalizations.of(context)!.tryShorterSessions);
      tips.add(AppLocalizations.of(context)!.considerMoreFrequentBreaks);
    } else if (avgFocus >= 8) {
      tips.add(AppLocalizations.of(context)!.greatFocusExtendSessions);
    }

    if (completionRate < 70) {
      tips.add(AppLocalizations.of(context)!.setRealisticSessionGoals);
      tips.add(AppLocalizations.of(context)!.breakDownComplexTasks);
    } else if (completionRate >= 90) {
      tips.add(AppLocalizations.of(context)!.excellentCompletionRate);
    }

    tips.add(AppLocalizations.of(context)!.stayHydratedDuringSessions);
    tips.add(AppLocalizations.of(context)!.useFiveMinuteRule);
    tips.add(AppLocalizations.of(context)!.reviewCompletedSessionsWeekly);

    return tips;
  }

  void _updateDateRange() {
    final now = DateTime.now();
    if (_selectedTimeRange == AppLocalizations.of(context)!.day) {
      _selectedDateRange = DateTimeRange(start: now.subtract(const Duration(days: 1)), end: now);
    } else if (_selectedTimeRange == AppLocalizations.of(context)!.week) {
      _selectedDateRange = DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now);
    } else if (_selectedTimeRange == AppLocalizations.of(context)!.month) {
      _selectedDateRange = DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now);
    } else if (_selectedTimeRange == AppLocalizations.of(context)!.year) {
      _selectedDateRange = DateTimeRange(start: now.subtract(const Duration(days: 365)), end: now);
    }
  }

  // Real data loading methods

  Future<void> _loadRealSessionHistory() async {
    final tasks = await _taskRepository.getAllTasks();
    final sessions = <CompletedPomodoroSession>[];

    for (final task in tasks) {
      // Load sessions from both old format (pomodoroSessions) and new format (completedSessions)
      final allSessionData = <Map<String, dynamic>>[];

      // Add sessions from old format (legacy support)
      allSessionData.addAll(task.pomodoroSessions);

      // Add sessions from new format
      allSessionData.addAll(task.completedSessions.map((session) => session.toJson()));

      for (final sessionData in allSessionData) {
        try {
          final session = CompletedPomodoroSession.fromJson(sessionData);
          // Filter by selected date range
          if (session.startTime.isAfter(_selectedDateRange.start) && session.startTime.isBefore(_selectedDateRange.end.add(const Duration(days: 1)))) {
            sessions.add(session);
          }
        } catch (e) {
          // Skip invalid session data
          continue;
        }
      }
    }

    // Sort by start time (most recent first)
    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    _sessionHistory = sessions;
  }

  Future<void> _loadRealCompletedTasks() async {
    final tasks = await _taskRepository.getAllTasks();
    _completedTasks = tasks.where((task) {
      // Include tasks that are completed OR have pomodoro activity
      final hasPomodoroActivity = task.pomodoroCount > 0 || task.pomodoroSessions.isNotEmpty || task.completedSessions.isNotEmpty || task.timeSpent.inMinutes > 0;

      return task.isCompleted || hasPomodoroActivity;
    }).toList();
  }

  // Real weekly data generation methods
  List<ChartData> _generateWeeklySessionData() {
    final now = DateTime.now();
    final data = <ChartData>[];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayName = _getDayName(date.weekday);
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      // Count real sessions for this day
      int daySessions = _sessionHistory
          .where(
            (session) => session.startTime.isAfter(dayStart) && session.startTime.isBefore(dayEnd) && session.type == SessionType.work, // Only count work sessions
          )
          .length;

      // Also count pomodoro sessions from tasks that don't have detailed session records
      for (final task in _completedTasks) {
        if (task.lastPomodoroDate != null && task.lastPomodoroDate!.isAfter(dayStart) && task.lastPomodoroDate!.isBefore(dayEnd)) {
          daySessions += task.pomodoroCount;
        }
      }

      data.add(ChartData(dayName, daySessions));
    }

    return data;
  }

  List<ChartData> _generateWeeklyFocusData() {
    final now = DateTime.now();
    final data = <ChartData>[];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayName = _getDayName(date.weekday);
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      // Calculate average focus score for this day from sessions
      final daySessions = _sessionHistory.where((session) => session.startTime.isAfter(dayStart) && session.startTime.isBefore(dayEnd) && session.type == SessionType.work && session.focusRating > 0);

      double avgFocus = 0.0;
      if (daySessions.isNotEmpty) {
        avgFocus = daySessions.fold<double>(0, (sum, session) => sum + session.focusRating) / daySessions.length;
      } else {
        // Fall back to task focus scores if no session data
        final dayTasks = _completedTasks.where((task) => task.lastPomodoroDate != null && task.lastPomodoroDate!.isAfter(dayStart) && task.lastPomodoroDate!.isBefore(dayEnd)).toList();

        if (dayTasks.isNotEmpty) {
          avgFocus = dayTasks.fold<double>(0, (sum, task) => sum + task.focusScore) / dayTasks.length;
        }
      }

      data.add(ChartData(dayName, avgFocus.round()));
    }

    return data;
  }

  List<ChartData> _generateWeeklyDurationData() {
    final now = DateTime.now();
    final data = <ChartData>[];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayName = _getDayName(date.weekday);
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      // Calculate average session duration for this day from sessions
      final daySessions = _sessionHistory.where((session) => session.startTime.isAfter(dayStart) && session.startTime.isBefore(dayEnd) && session.type == SessionType.work && session.actualDuration > 0);

      double avgDuration = 0.0;
      if (daySessions.isNotEmpty) {
        avgDuration = daySessions.fold<double>(0, (sum, session) => sum + session.actualDuration) / daySessions.length;
      } else {
        // Fall back to task timeSpent if no session data
        final dayTasks = _completedTasks.where((task) => task.lastPomodoroDate != null && task.lastPomodoroDate!.isAfter(dayStart) && task.lastPomodoroDate!.isBefore(dayEnd) && task.timeSpent.inMinutes > 0).toList();

        if (dayTasks.isNotEmpty) {
          avgDuration = dayTasks.fold<double>(0, (sum, task) => sum + task.timeSpent.inMinutes) / dayTasks.length;
        }
      }

      data.add(ChartData(dayName, avgDuration.round()));
    }

    return data;
  }

  String _getDayName(int weekday) {
    final l10n = AppLocalizations.of(context)!;
    switch (weekday) {
      case 1:
        return l10n.mon;
      case 2:
        return l10n.tue;
      case 3:
        return l10n.wed;
      case 4:
        return l10n.thu;
      case 5:
        return l10n.fri;
      case 6:
        return l10n.sat;
      case 7:
        return l10n.sun;
      default:
        return l10n.mon;
    }
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
  final String day;
  final int value;

  ChartData(this.day, this.value);
}
