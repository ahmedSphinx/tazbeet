import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../blocs/mood/mood_bloc.dart';
import '../../../../blocs/mood/mood_event.dart';
import '../../../../blocs/mood/mood_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/mood.dart';
import '../../../../services/mood_insights_service.dart';
import '../../../../services/mood_achievement_service.dart';
import '../../../widgets/mood/mood_calendar_widget.dart';
import '../../../widgets/mood/mood_trends_chart.dart';
import '../../../widgets/mood/mood_suggestions_widget.dart';
import '../../../widgets/mood/mood_patterns_widget.dart';
import 'dart:math' as math;

/// Advanced mood insights screen with analytics, calendar, and suggestions
class MoodInsightsScreen extends StatefulWidget {
  const MoodInsightsScreen({super.key});

  @override
  State<MoodInsightsScreen> createState() => _MoodInsightsScreenState();
}

class _MoodInsightsScreenState extends State<MoodInsightsScreen> with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _floatingController;
  late AnimationController _cardController;
  late Animation<double> _heroAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _cardAnimation;

  final MoodInsightsService _insightsService = MoodInsightsService();
  final MoodAchievementService _achievementService = MoodAchievementService();

  DateTime _selectedMonth = DateTime.now();
  String _selectedTimeframe = 'month';
  List<Mood> _moods = [];

  @override
  void initState() {
    super.initState();

    _heroController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    _floatingController = AnimationController(duration: const Duration(seconds: 4), vsync: this);

    _cardController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    _heroAnimation = CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic);

    _floatingAnimation = CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut);

    _cardAnimation = CurvedAnimation(parent: _cardController, curve: Curves.easeOutBack);

    _heroController.forward();
    _floatingController.repeat(reverse: true);
    _cardController.forward();

    context.read<MoodBloc>().add(LoadMoods());
  }

  @override
  void dispose() {
    _heroController.dispose();
    _floatingController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.08 + _floatingAnimation.value * 0.04),
                      theme.colorScheme.secondary.withValues(alpha: 0.06 + _floatingAnimation.value * 0.03),
                      theme.colorScheme.tertiary.withValues(alpha: 0.04 + _floatingAnimation.value * 0.02),
                      theme.colorScheme.surface,
                    ],
                    stops: const [0.0, 0.3, 0.6, 1.0],
                  ),
                ),
              );
            },
          ),

          // Floating particles
          ...List.generate(10, (index) => _buildFloatingParticle(index)),

          // Main content
          BlocBuilder<MoodBloc, MoodState>(
            builder: (context, state) {
              if (state is MoodLoaded) {
                _moods = state.moods;
                return _buildInsightsContent(theme);
              } else if (state is MoodLoading) {
                return _buildLoadingState(theme);
              } else if (state is MoodError) {
                return _buildErrorState(theme, state.message);
              }
              return _buildEmptyState(theme);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsContent(ThemeData theme) {
    return AnimatedBuilder(
      animation: _heroAnimation,
      builder: (context, child) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Hero header
              Transform.translate(
                offset: Offset(0, (1 - _heroAnimation.value) * 50),
                child: Opacity(opacity: _heroAnimation.value, child: _buildHeroHeader(theme)),
              ),

              const SizedBox(height: 32),

              // Time frame selector
              Transform.translate(
                offset: Offset(0, (1 - _heroAnimation.value) * 30),
                child: Opacity(opacity: _heroAnimation.value, child: _buildTimeFrameSelector(theme)),
              ),

              const SizedBox(height: 24),

              // Calendar heatmap
              AnimationConfiguration.staggeredList(
                position: 0,
                duration: const Duration(milliseconds: 600),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: MoodCalendarWidget(
                      moods: _moods,
                      selectedMonth: _selectedMonth,
                      onMonthChanged: (month) {
                        setState(() => _selectedMonth = month);
                        HapticFeedback.selectionClick();
                      },
                      onDateSelected: (date) {
                        HapticFeedback.lightImpact();
                        _showDayDetails(date);
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Trends chart
              AnimationConfiguration.staggeredList(
                position: 1,
                duration: const Duration(milliseconds: 600),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: MoodTrendsChart(moods: _moods, timeframe: _selectedTimeframe),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Insights grid
              AnimationConfiguration.staggeredGrid(
                position: 0,
                duration: const Duration(milliseconds: 600),
                columnCount: 2,
                child: SlideAnimation(verticalOffset: 50.0, child: FadeInAnimation(child: _buildInsightsGrid(theme))),
              ),

              const SizedBox(height: 24),

              // Suggestions widget
              AnimationConfiguration.staggeredList(
                position: 2,
                duration: const Duration(milliseconds: 600),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: MoodSuggestionsWidget(
                      moods: _moods,
                      onSuggestionTap: (suggestion) {
                        HapticFeedback.mediumImpact();
                        _applySuggestion(suggestion);
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Patterns analysis
              AnimationConfiguration.staggeredList(
                position: 3,
                duration: const Duration(milliseconds: 600),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: MoodPatternsWidget(moods: _moods, insightsService: _insightsService),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [theme.colorScheme.primaryContainer.withValues(alpha: 0.4), theme.colorScheme.secondaryContainer.withValues(alpha: 0.3), theme.colorScheme.tertiaryContainer.withValues(alpha: 0.2)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
        boxShadow: [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.1), blurRadius: 30, offset: const Offset(0, 15), spreadRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Animated icon
              AnimatedBuilder(
                animation: _floatingAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _floatingAnimation.value * 0.1,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.secondary]),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
                      ),
                      child: const Icon(Icons.insights, size: 32, color: Colors.white),
                    ),
                  );
                },
              ),

              const SizedBox(width: 20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.yourMoodInsights,
                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                    ),
                    const SizedBox(height: 8),
                    Text(AppLocalizations.of(context)!.moodInsightsSubtitle, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Quick stats
          Row(children: [_buildQuickStat(theme, '${_moods.length}', 'Total Entries'), const SizedBox(width: 16), _buildQuickStat(theme, '${_getCurrentStreak()}', 'Day Streak'), const SizedBox(width: 16), _buildQuickStat(theme, _getAverageMood(), 'Avg Mood')]),
        ],
      ),
    );
  }

  Widget _buildQuickStat(ThemeData theme, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeFrameSelector(ThemeData theme) {
    final options = ['week', 'month', '3months', 'year'];
    final labels = ['Week', 'Month', '3 Months', 'Year'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.1), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final label = labels[index];
          final isSelected = _selectedTimeframe == option;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedTimeframe = option);
                HapticFeedback.selectionClick();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected ? LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.secondary]) : null,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isSelected ? [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))] : null,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? Colors.white : theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInsightsGrid(ThemeData theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.4),
      itemCount: 4,
      itemBuilder: (context, index) {
        final emojis = ['🎯', '⚡', '🧘', '🎨'];
        final titles = ['Best Day', 'Energy Peak', 'Stress Low', 'Most Used Tag'];
        final values = [_getBestDay(), _getEnergyPeak(), _getStressLow(), _getMostUsedTag()];
        final colors = [Colors.green, Colors.orange, Colors.blue, Colors.purple];

        return _buildInsightCard(theme, emojis[index], titles[index], values[index], colors[index]);
      },
    );
  }

  Widget _buildInsightCard(ThemeData theme, String emoji, String title, String value, Color accentColor) {
    return AnimatedBuilder(
      animation: _cardAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _cardAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [accentColor.withValues(alpha: 0.1), accentColor.withValues(alpha: 0.05), theme.colorScheme.surface], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accentColor.withValues(alpha: 0.2)),
              boxShadow: [BoxShadow(color: accentColor.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7), fontWeight: FontWeight.w600, fontSize: 11),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: accentColor, fontSize: 12),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingParticle(int index) {
    final theme = Theme.of(context);
    final colors = [theme.colorScheme.primary.withValues(alpha: 0.1), theme.colorScheme.secondary.withValues(alpha: 0.08), theme.colorScheme.tertiary.withValues(alpha: 0.06), Colors.amber.withValues(alpha: 0.05), Colors.pink.withValues(alpha: 0.04)];

    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        final offset = (_floatingAnimation.value + index * 0.3) * 2 * math.pi;
        final x = math.sin(offset + index * 0.7) * (40 + index * 15);
        final y = math.cos(offset * 0.8 + index * 0.5) * (30 + index * 12);

        return Positioned(
          left: MediaQuery.of(context).size.width * (0.1 + (index % 4) * 0.25) + x,
          top: MediaQuery.of(context).size.height * (0.15 + (index % 3) * 0.3) + y,
          child: Container(
            width: 6 + (index % 3) * 2,
            height: 6 + (index % 3) * 2,
            decoration: BoxDecoration(
              color: colors[index % colors.length],
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: colors[index % colors.length], blurRadius: 8, spreadRadius: 1)],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary)),
          const SizedBox(height: 16),
          Text('Loading insights...', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text('Error loading insights', style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.error)),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insights, size: 64, color: theme.colorScheme.primary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text('No mood data yet', style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onSurface)),
          const SizedBox(height: 8),
          Text(
            'Start logging your moods to see insights',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helper methods
  int _getCurrentStreak() {
    return _achievementService.getCurrentStreak().currentStreak;
  }

  String _getAverageMood() {
    if (_moods.isEmpty) return 'N/A';
    final avg = _moods.map((m) => m.level.index).reduce((a, b) => a + b) / _moods.length;
    return ['😢', '😕', '😐', '😊', '😄'][avg.round()];
  }

  String _getBestDay() {
    if (_moods.isEmpty) return 'N/A';
    final bestMood = _moods.reduce((a, b) => a.level.index > b.level.index ? a : b);
    return '${bestMood.date.day}/${bestMood.date.month}';
  }

  String _getEnergyPeak() {
    if (_moods.isEmpty) return 'N/A';
    final avgEnergy = _moods.map((m) => m.energyLevel).reduce((a, b) => a + b) / _moods.length;
    return '${avgEnergy.toStringAsFixed(1)}/10';
  }

  String _getStressLow() {
    if (_moods.isEmpty) return 'N/A';
    final avgStress = _moods.map((m) => m.stressLevel).reduce((a, b) => a + b) / _moods.length;
    return '${avgStress.toStringAsFixed(1)}/10';
  }

  String _getMostUsedTag() {
    if (_moods.isEmpty) return 'N/A';
    final tagCounts = <String, int>{};
    for (final mood in _moods) {
      for (final tag in mood.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }
    if (tagCounts.isEmpty) return 'None';
    final mostUsed = tagCounts.entries.reduce((a, b) => a.value > b.value ? a : b);
    return mostUsed.key;
  }

  void _showDayDetails(DateTime date) {
    final dayMoods = _moods.where((m) => m.date.year == date.year && m.date.month == date.month && m.date.day == date.day).toList();

    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => _buildDayDetailsSheet(date, dayMoods));
  }

  Widget _buildDayDetailsSheet(DateTime date, List<Mood> dayMoods) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, -10))],
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: theme.colorScheme.outline.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('${date.day}/${date.month}/${date.year}', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          ),

          // Content
          Expanded(
            child: dayMoods.isEmpty
                ? Center(
                    child: Text('No moods logged for this day', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: dayMoods.length,
                    itemBuilder: (context, index) {
                      final mood = dayMoods[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Text(_getMoodEmoji(mood.level), style: const TextStyle(fontSize: 24)),
                          title: Text(_getMoodText(mood.level)),
                          subtitle: mood.note?.isNotEmpty == true ? Text(mood.note!) : null,
                          trailing: Text('${mood.date.hour}:${mood.date.minute.toString().padLeft(2, '0')}', style: theme.textTheme.bodySmall),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _getMoodEmoji(MoodLevel level) {
    switch (level) {
      case MoodLevel.very_bad:
        return '😢';
      case MoodLevel.bad:
        return '😕';
      case MoodLevel.neutral:
        return '😐';
      case MoodLevel.good:
        return '😊';
      case MoodLevel.very_good:
        return '😄';
    }
  }

  String _getMoodText(MoodLevel level) {
    switch (level) {
      case MoodLevel.very_bad:
        return 'Very Bad';
      case MoodLevel.bad:
        return 'Bad';
      case MoodLevel.neutral:
        return 'Neutral';
      case MoodLevel.good:
        return 'Good';
      case MoodLevel.very_good:
        return 'Very Good';
    }
  }

  void _applySuggestion(String suggestion) {
    // Handle suggestion application
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied suggestion: $suggestion'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
