import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/mood.dart';
import '../../../services/mood_insights_service.dart';
import 'dart:math' as math;

/// Widget displaying mood patterns and correlations analysis
class MoodPatternsWidget extends StatefulWidget {
  final List<Mood> moods;
  final MoodInsightsService insightsService;

  const MoodPatternsWidget({super.key, required this.moods, required this.insightsService});

  @override
  State<MoodPatternsWidget> createState() => _MoodPatternsWidgetState();
}

class _MoodPatternsWidgetState extends State<MoodPatternsWidget> with TickerProviderStateMixin {
  late AnimationController _patternController;
  late Animation<double> _patternAnimation;

  @override
  void initState() {
    super.initState();

    _patternController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);

    _patternAnimation = CurvedAnimation(parent: _patternController, curve: Curves.easeOutCubic);

    _patternController.forward();
  }

  @override
  void dispose() {
    _patternController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final patterns = _analyzePatterns();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.purple.withOpacity(0.1), Colors.pink.withOpacity(0.08), theme.colorScheme.surface], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: theme.colorScheme.shadow.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 15))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(theme),

          const SizedBox(height: 20),

          // Patterns list
          AnimatedBuilder(
            animation: _patternAnimation,
            builder: (context, child) {
              return Column(
                children: patterns.asMap().entries.map((entry) {
                  final index = entry.key;
                  final pattern = entry.value;
                  final delay = index * 0.1;
                  final animationValue = math.max(0.0, math.min(1.0, (_patternAnimation.value - delay) / (1.0 - delay)));

                  return Transform.translate(
                    offset: Offset(0, (1 - animationValue) * 30),
                    child: Opacity(
                      opacity: animationValue,
                      child: Padding(padding: const EdgeInsets.only(bottom: 12), child: _buildPatternCard(theme, pattern)),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 16),

          // Insights summary
          _buildInsightsSummary(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        // Pattern icon
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.purple, Colors.pink]),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: const Icon(Icons.psychology, color: Colors.white, size: 20),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.moodPatternsTitle,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 4),
              Text(AppLocalizations.of(context)!.moodPatternsSubtitle, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
            ],
          ),
        ),

        // Confidence badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.green.withOpacity(0.2), Colors.teal.withOpacity(0.2)]),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Text(
            '${_getConfidenceLevel()}%',
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ),
      ],
    );
  }

  Widget _buildPatternCard(ThemeData theme, MoodPattern pattern) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        _showPatternDetails(pattern);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: pattern.color.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: pattern.color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            // Pattern icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: pattern.color.withOpacity(0.2), shape: BoxShape.circle),
              child: Text(pattern.emoji, style: const TextStyle(fontSize: 20)),
            ),

            const SizedBox(width: 16),

            // Pattern info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pattern.title,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: pattern.color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          '${pattern.strength}%',
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: pattern.color),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pattern.description,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Arrow
            Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.outline),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsSummary(ThemeData theme) {
    final totalPatterns = widget.moods.length;
    final strongPatterns = _analyzePatterns().where((p) => p.strength > 70).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [theme.colorScheme.primaryContainer.withOpacity(0.3), theme.colorScheme.secondaryContainer.withOpacity(0.2)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.insights, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pattern Analysis',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: 4),
                Text('Found $strongPatterns strong patterns from $totalPatterns mood entries', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(
              'View All',
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  List<MoodPattern> _analyzePatterns() {
    if (widget.moods.length < 5) {
      return _getDefaultPatterns();
    }

    final patterns = <MoodPattern>[];

    // Time-based patterns
    final timePatterns = _analyzeTimePatterns();
    patterns.addAll(timePatterns);

    // Day of week patterns
    final dayPatterns = _analyzeDayPatterns();
    patterns.addAll(dayPatterns);

    // Correlation patterns
    final correlationPatterns = _analyzeCorrelationPatterns();
    patterns.addAll(correlationPatterns);

    // Sort by strength
    patterns.sort((a, b) => b.strength.compareTo(a.strength));

    return patterns.take(5).toList();
  }

  List<MoodPattern> _analyzeTimePatterns() {
    final patterns = <MoodPattern>[];
    final hourlyMoods = <int, List<double>>{};

    // Group moods by hour
    for (final mood in widget.moods) {
      final hour = mood.date.hour;
      hourlyMoods.putIfAbsent(hour, () => []).add(mood.level.index.toDouble());
    }

    // Find peak hours
    double bestHour = -1;
    double bestAvg = -1;
    double worstHour = -1;
    double worstAvg = 5;

    for (final entry in hourlyMoods.entries) {
      if (entry.value.length < 3) continue; // Need at least 3 data points

      final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
      if (avg > bestAvg) {
        bestAvg = avg;
        bestHour = entry.key.toDouble();
      }
      if (avg < worstAvg) {
        worstAvg = avg;
        worstHour = entry.key.toDouble();
      }
    }

    if (bestHour >= 0) {
      patterns.add(
        MoodPattern(
          title: 'Peak Hour: ${_formatHour(bestHour.toInt())}',
          description: 'You tend to feel best around ${_formatHour(bestHour.toInt())}',
          emoji: '⏰',
          color: Colors.green,
          strength: ((bestAvg / 4) * 100).round(),
          details: 'Your mood peaks at ${_formatHour(bestHour.toInt())} with an average rating of ${bestAvg.toStringAsFixed(1)}/4',
        ),
      );
    }

    if (worstHour >= 0 && worstHour != bestHour) {
      patterns.add(
        MoodPattern(
          title: 'Low Hour: ${_formatHour(worstHour.toInt())}',
          description: 'Consider extra self-care around ${_formatHour(worstHour.toInt())}',
          emoji: '🕐',
          color: Colors.orange,
          strength: (((4 - worstAvg) / 4) * 100).round(),
          details: 'Your mood tends to dip at ${_formatHour(worstHour.toInt())} with an average rating of ${worstAvg.toStringAsFixed(1)}/4',
        ),
      );
    }

    return patterns;
  }

  List<MoodPattern> _analyzeDayPatterns() {
    final patterns = <MoodPattern>[];
    final dailyMoods = <int, List<double>>{};

    // Group moods by day of week (1 = Monday, 7 = Sunday)
    for (final mood in widget.moods) {
      final day = mood.date.weekday;
      dailyMoods.putIfAbsent(day, () => []).add(mood.level.index.toDouble());
    }

    // Find best and worst days
    double bestDay = -1;
    double bestAvg = -1;
    double worstAvg = 5;

    for (final entry in dailyMoods.entries) {
      if (entry.value.length < 2) continue;

      final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
      if (avg > bestAvg) {
        bestAvg = avg;
        bestDay = entry.key.toDouble();
      }
      if (avg < worstAvg) {
        worstAvg = avg;
      }
    }

    if (bestDay >= 0) {
      patterns.add(
        MoodPattern(
          title: 'Best Day: ${_getDayName(bestDay.toInt())}',
          description: '${_getDayName(bestDay.toInt())}s tend to be your brightest days',
          emoji: '📅',
          color: Colors.blue,
          strength: ((bestAvg / 4) * 100).round(),
          details: 'You feel best on ${_getDayName(bestDay.toInt())}s with an average mood of ${bestAvg.toStringAsFixed(1)}/4',
        ),
      );
    }

    return patterns;
  }

  List<MoodPattern> _analyzeCorrelationPatterns() {
    final patterns = <MoodPattern>[];

    if (widget.moods.length < 10) return patterns;

    // Analyze energy-mood correlation
    final energyMoodCorr = _calculateCorrelation(widget.moods.map((m) => m.energyLevel.toDouble()).toList(), widget.moods.map((m) => m.level.index.toDouble()).toList());

    if (energyMoodCorr.abs() > 0.6) {
      patterns.add(
        MoodPattern(
          title: 'Energy-Mood Link',
          description: energyMoodCorr > 0 ? 'Higher energy strongly correlates with better mood' : 'Lower energy tends to affect your mood negatively',
          emoji: '⚡',
          color: Colors.yellow,
          strength: (energyMoodCorr.abs() * 100).round(),
          details: 'Correlation coefficient: ${energyMoodCorr.toStringAsFixed(2)}',
        ),
      );
    }

    // Analyze stress-mood correlation
    final stressMoodCorr = _calculateCorrelation(widget.moods.map((m) => m.stressLevel.toDouble()).toList(), widget.moods.map((m) => m.level.index.toDouble()).toList());

    if (stressMoodCorr.abs() > 0.5) {
      patterns.add(
        MoodPattern(
          title: 'Stress Impact',
          description: stressMoodCorr < 0 ? 'Higher stress significantly impacts your mood' : 'Stress levels correlate with mood changes',
          emoji: '😰',
          color: Colors.red,
          strength: (stressMoodCorr.abs() * 100).round(),
          details: 'Correlation coefficient: ${stressMoodCorr.toStringAsFixed(2)}',
        ),
      );
    }

    return patterns;
  }

  List<MoodPattern> _getDefaultPatterns() {
    return [
      MoodPattern(
        title: 'Getting Started',
        description: 'Log more moods to discover your unique patterns',
        emoji: '🌱',
        color: Colors.green,
        strength: 0,
        details: 'We need at least 5 mood entries to start identifying patterns',
      ),
    ];
  }

  double _calculateCorrelation(List<double> x, List<double> y) {
    if (x.length != y.length || x.length < 2) return 0.0;

    final n = x.length;
    final meanX = x.reduce((a, b) => a + b) / n;
    final meanY = y.reduce((a, b) => a + b) / n;

    double numerator = 0;
    double sumXSquared = 0;
    double sumYSquared = 0;

    for (int i = 0; i < n; i++) {
      final diffX = x[i] - meanX;
      final diffY = y[i] - meanY;
      numerator += diffX * diffY;
      sumXSquared += diffX * diffX;
      sumYSquared += diffY * diffY;
    }

    final denominator = math.sqrt(sumXSquared * sumYSquared);
    return denominator == 0 ? 0 : numerator / denominator;
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12:00 AM';
    if (hour < 12) return '$hour:00 AM';
    if (hour == 12) return '12:00 PM';
    return '${hour - 12}:00 PM';
  }

  String _getDayName(int day) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[day - 1];
  }

  int _getConfidenceLevel() {
    if (widget.moods.length < 5) return 20;
    if (widget.moods.length < 15) return 60;
    if (widget.moods.length < 30) return 80;
    return 95;
  }

  void _showPatternDetails(MoodPattern pattern) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => _buildPatternDetailsSheet(pattern));
  }

  Widget _buildPatternDetailsSheet(MoodPattern pattern) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [BoxShadow(color: theme.colorScheme.shadow.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, -10))],
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: theme.colorScheme.outline.withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(pattern.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pattern.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        'Strength: ${pattern.strength}%',
                        style: theme.textTheme.bodyMedium?.copyWith(color: pattern.color, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(pattern.description, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  Text('Details', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(pattern.details, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MoodPattern {
  final String title;
  final String description;
  final String emoji;
  final Color color;
  final int strength;
  final String details;

  MoodPattern({required this.title, required this.description, required this.emoji, required this.color, required this.strength, required this.details});
}
