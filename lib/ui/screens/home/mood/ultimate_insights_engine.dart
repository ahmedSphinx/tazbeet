import 'package:flutter/material.dart';
import '../../../../models/mood.dart';
import '../../../../l10n/app_localizations.dart';

/// Ultimate insights engine with advanced pattern recognition and AI-powered analysis
class UltimateInsightsEngine extends StatefulWidget {
  final List<Mood> moods;
  final Function(Map<String, dynamic>)? onInsightSelected;

  const UltimateInsightsEngine({super.key, required this.moods, this.onInsightSelected});

  @override
  State<UltimateInsightsEngine> createState() => _UltimateInsightsEngineState();
}

class _UltimateInsightsEngineState extends State<UltimateInsightsEngine> with TickerProviderStateMixin {
  late AnimationController _insightsController;
  late AnimationController _chartController;
  late Animation<double> _insightsAnimation;
  late Animation<double> _chartAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _disposeAnimations();
    super.dispose();
  }

  void _initializeAnimations() {
    _insightsController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _insightsAnimation = CurvedAnimation(parent: _insightsController, curve: Curves.easeOutCubic);

    _chartController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _chartAnimation = CurvedAnimation(parent: _chartController, curve: Curves.easeOutCubic);

    _insightsController.forward();
    _chartController.forward();
  }

  void _disposeAnimations() {
    _insightsController.dispose();
    _chartController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.moods.isEmpty) {
      return _buildEmptyInsights();
    }

    final insights = _generateComprehensiveInsights();
    final weeklySummary = _generateWeeklySummary();
    final patterns = _analyzePatterns();
    final predictions = _generatePredictions();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),

          const SizedBox(height: 32),

          // Weekly Summary Card
          AnimatedBuilder(
            animation: _insightsAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, (1 - _insightsAnimation.value) * 30),
                child: Opacity(opacity: _insightsAnimation.value, child: _buildWeeklySummaryCard(weeklySummary)),
              );
            },
          ),

          const SizedBox(height: 24),

          // Key Insights
          AnimatedBuilder(
            animation: _insightsAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, (1 - _insightsAnimation.value) * 40),
                child: Opacity(opacity: _insightsAnimation.value, child: _buildKeyInsights(insights)),
              );
            },
          ),

          const SizedBox(height: 24),

          // Pattern Analysis
          AnimatedBuilder(
            animation: _chartAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, (1 - _chartAnimation.value) * 50),
                child: Opacity(opacity: _chartAnimation.value, child: _buildPatternAnalysis(patterns)),
              );
            },
          ),

          const SizedBox(height: 24),

          // Predictions
          AnimatedBuilder(
            animation: _chartAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, (1 - _chartAnimation.value) * 60),
                child: Opacity(opacity: _chartAnimation.value, child: _buildPredictions(predictions)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.yourMoodJourney,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(l10n.aIPoweredAnalysis, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildWeeklySummaryCard(Map<String, dynamic> summary) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue.shade50, Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade200),
        boxShadow: [BoxShadow(color: Colors.blue.shade100.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights, color: Colors.blue.shade600, size: 24),
              const SizedBox(width: 12),
              Text(
                l10n.thisWeek,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Mood distribution
          Row(
            children: [
              _buildMoodStat(l10n.goodDays, summary['goodDays'], Colors.green),
              const SizedBox(width: 16),
              _buildMoodStat(l10n.neutralDays, summary['neutralDays'], Colors.grey),
              const SizedBox(width: 16),
              _buildMoodStat(l10n.challengingDays, summary['badDays'], Colors.orange),
            ],
          ),

          const SizedBox(height: 20),

          // Energy, Focus, Stress averages
          Row(
            children: [
              _buildMetricStat(l10n.averageEnergy, summary['avgEnergy']),
              const SizedBox(width: 16),
              _buildMetricStat(l10n.averageFocus, summary['avgFocus']),
              const SizedBox(width: 16),
              _buildMetricStat(l10n.averageStress, summary['avgStress']),
            ],
          ),

          if (summary['dominantMood'] != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Text(l10n.dominantMood, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  const SizedBox(width: 8),
                  Text(
                    summary['dominantMood'],
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMoodStat(String label, int value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: color.withOpacity(0.8), fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricStat(String label, double value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Text(
              value.toStringAsFixed(1),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyInsights(List<Map<String, dynamic>> insights) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.keyInsights,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        ...insights.map((insight) => _buildInsightCard(insight)),
      ],
    );
  }

  Widget _buildInsightCard(Map<String, dynamic> insight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: insight['color'].withOpacity(0.1), shape: BoxShape.circle),
            child: Center(child: Text(insight['emoji'], style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight['title'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(insight['description'], style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternAnalysis(List<Map<String, dynamic>> patterns) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.patternAnalysis,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        ...patterns.map((pattern) => _buildPatternCard(pattern)),
      ],
    );
  }

  Widget _buildPatternCard(Map<String, dynamic> pattern) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [pattern['color'].withOpacity(0.1), Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: pattern['color'].withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(pattern['emoji'], style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  pattern['title'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(pattern['description'], style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          if (pattern['details'] != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Text(pattern['details'], style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPredictions(List<Map<String, dynamic>> predictions) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.aiPredictions,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        ...predictions.map((prediction) => _buildPredictionCard(prediction)),
      ],
    );
  }

  Widget _buildPredictionCard(Map<String, dynamic> prediction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.purple.shade50, Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.psychology, color: Colors.purple.shade600, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prediction['title'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(prediction['description'], style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyInsights() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            child: Center(child: Text('🔮', style: const TextStyle(fontSize: 48))),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noInsightsYet,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(l10n.trackYourMoodForAWeek, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  // Data analysis methods
  Map<String, dynamic> _generateWeeklySummary() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final weekMoods = widget.moods.where((m) => m.date.isAfter(weekAgo)).toList();

    if (weekMoods.isEmpty) {
      return {'goodDays': 0, 'neutralDays': 0, 'badDays': 0, 'avgEnergy': 5.0, 'avgFocus': 5.0, 'avgStress': 5.0, 'dominantMood': null};
    }

    int goodDays = 0;
    int neutralDays = 0;
    int badDays = 0;
    double totalEnergy = 0;
    double totalFocus = 0;
    double totalStress = 0;

    for (final mood in weekMoods) {
      if (mood.level == MoodLevel.good || mood.level == MoodLevel.very_good) {
        goodDays++;
      } else if (mood.level == MoodLevel.neutral) {
        neutralDays++;
      } else {
        badDays++;
      }

      totalEnergy += mood.energyLevel;
      totalFocus += mood.focusLevel;
      totalStress += mood.stressLevel;
    }

    final count = weekMoods.length;

    String dominantMood;
    if (goodDays > neutralDays && goodDays > badDays) {
      dominantMood = 'Positive';
    } else if (badDays > goodDays && badDays > neutralDays) {
      dominantMood = 'Challenging';
    } else {
      dominantMood = 'Balanced';
    }

    return {'goodDays': goodDays, 'neutralDays': neutralDays, 'badDays': badDays, 'avgEnergy': totalEnergy / count, 'avgFocus': totalFocus / count, 'avgStress': totalStress / count, 'dominantMood': dominantMood};
  }

  List<Map<String, dynamic>> _generateComprehensiveInsights() {
    final insights = <Map<String, dynamic>>[];
    final l10n = AppLocalizations.of(context)!;

    if (widget.moods.isEmpty) return insights;

    final avgMood = _calculateAverageMood();
    final streak = _calculateStreak();
    final todayCount = _getTodayMoods().length;

    // Mood trend insight
    if (avgMood >= 4) {
      insights.add({'title': l10n.positiveTrend, 'description': l10n.yourOverallMoodIsGenerallyPositive, 'emoji': '📈', 'color': Colors.green});
    } else if (avgMood <= 2) {
      insights.add({'title': l10n.supportNeeded, 'description': l10n.youMightBenefitFromAdditionalSupport, 'emoji': '🤗', 'color': Colors.orange});
    }

    // Consistency insight
    if (streak >= 7) {
      insights.add({'title': l10n.greatConsistency, 'description': 'You\'ve been tracking your mood for $streak days', 'emoji': '🔥', 'color': Colors.red});
    }

    // Today's status
    if (todayCount == 0) {
      insights.add({'title': l10n.missingToday, 'description': l10n.youHaventLoggedYourMoodTodayYet, 'emoji': '📝', 'color': Colors.blue});
    }

    return insights;
  }

  List<Map<String, dynamic>> _analyzePatterns() {
    final patterns = <Map<String, dynamic>>[];
    final l10n = AppLocalizations.of(context)!;

    if (widget.moods.isEmpty) return patterns;

    // Most common mood
    final moodCounts = <MoodLevel, int>{};
    for (final mood in widget.moods) {
      moodCounts[mood.level] = (moodCounts[mood.level] ?? 0) + 1;
    }

    final mostCommon = moodCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    patterns.add({
      'title': l10n.mostCommonMood,
      'description': _getMoodText(mostCommon),
      'emoji': _getMoodEmoji(mostCommon),
      'color': _getMoodColor(mostCommon),
      'details': 'You\'ve felt this way ${moodCounts[mostCommon]} times',
    });

    // Recent trend
    final recentMoods = widget.moods.take(7).toList();
    final recentAvg = recentMoods.map((m) => m.level.index + 1).reduce((a, b) => a + b) / recentMoods.length;

    if (recentAvg >= 4) {
      patterns.add({'title': l10n.recentImprovement, 'description': l10n.yourMoodHasBeenImprovingLately, 'emoji': '📈', 'color': Colors.green, 'details': 'Your last 7 entries show positive progress'});
    } else if (recentAvg <= 2) {
      patterns.add({'title': l10n.challengingPeriod, 'description': l10n.recentEntriesSuggestAChallengingTime, 'emoji': '📉', 'color': Colors.orange, 'details': 'Consider reaching out for support if needed'});
    }

    return patterns;
  }

  List<Map<String, dynamic>> _generatePredictions() {
    final predictions = <Map<String, dynamic>>[];
    final l10n = AppLocalizations.of(context)!;

    if (widget.moods.length < 7) {
      predictions.add({'title': l10n.moreDataNeeded, 'description': l10n.trackYourMoodForAWeekToGetAIPredictions});
      return predictions;
    }

    final recentMoods = widget.moods.take(14).toList();
    final avgMood = recentMoods.map((m) => m.level.index + 1).reduce((a, b) => a + b) / recentMoods.length;

    if (avgMood >= 4) {
      predictions.add({'title': l10n.positiveOutlook, 'description': l10n.basedOnRecentPatternsTomorrowLooksPromising});
    } else if (avgMood <= 2) {
      predictions.add({'title': l10n.selfCareRecommended, 'description': l10n.considerPrioritizingSelfCareActivitiesTomorrow});
    } else {
      predictions.add({'title': l10n.balancedDayAhead, 'description': l10n.tomorrowShouldBeATypicalDayForYou});
    }

    return predictions;
  }

  List<Mood> _getTodayMoods() {
    final today = DateTime.now();
    return widget.moods.where((mood) => mood.date.year == today.year && mood.date.month == today.month && mood.date.day == today.day).toList();
  }

  double _calculateAverageMood() {
    if (widget.moods.isEmpty) return 0;

    final total = widget.moods.map((m) => m.level.index + 1).reduce((a, b) => a + b);
    return total / widget.moods.length;
  }

  int _calculateStreak() {
    if (widget.moods.isEmpty) return 0;

    final sortedMoods = List<Mood>.from(widget.moods)..sort((a, b) => a.date.compareTo(b.date));

    int streak = 0;
    DateTime currentDate = DateTime.now();

    for (final mood in sortedMoods.reversed) {
      if (_isSameDay(mood.date, currentDate)) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  Color _getMoodColor(MoodLevel level) {
    switch (level) {
      case MoodLevel.very_bad:
        return const Color(0xFFFF5252);
      case MoodLevel.bad:
        return const Color(0xFFFF9800);
      case MoodLevel.neutral:
        return const Color(0xFF9E9E9E);
      case MoodLevel.good:
        return const Color(0xFF8BC34A);
      case MoodLevel.very_good:
        return const Color(0xFF4CAF50);
    }
  }

  String _getMoodEmoji(MoodLevel level) {
    switch (level) {
      case MoodLevel.very_bad:
        return '😢';
      case MoodLevel.bad:
        return '😔';
      case MoodLevel.neutral:
        return '😐';
      case MoodLevel.good:
        return '🙂';
      case MoodLevel.very_good:
        return '😊';
    }
  }

  String _getMoodText(MoodLevel level) {
    switch (level) {
      case MoodLevel.very_bad:
        return 'Really struggling';
      case MoodLevel.bad:
        return 'Not great';
      case MoodLevel.neutral:
        return 'Okay';
      case MoodLevel.good:
        return 'Pretty good';
      case MoodLevel.very_good:
        return 'Great';
    }
  }
}
