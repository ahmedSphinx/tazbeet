import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/services/app_logging_service.dart';
import '../../../../blocs/mood/mood_bloc.dart';
import '../../../../blocs/mood/mood_event.dart';
import '../../../../blocs/mood/mood_state.dart';
import '../../../../models/mood.dart';
import '../../../../models/mood_streak.dart';
import '../../../../l10n/app_localizations.dart';
import 'mood_detail_screen.dart';
import 'ultimate_mood_buddy.dart';
import 'ultimate_mood_calendar.dart';
import 'ultimate_insights_engine.dart';

/// Ultimate mood tracking screen combining best features from all implementations
class UltimateMoodScreen extends StatefulWidget {
  final TabController tabController;

  const UltimateMoodScreen({super.key, required this.tabController});

  @override
  State<UltimateMoodScreen> createState() => _UltimateMoodScreenState();
}

class _UltimateMoodScreenState extends State<UltimateMoodScreen> with TickerProviderStateMixin {
  // Animation controllers for rich interactions
  late AnimationController _headerController;
  late AnimationController _buddyController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;

  late Animation<double> _headerAnimation;
  late Animation<double> _buddyAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _particleAnimation;

  // State management
  List<Mood> _moods = [];
  MoodStreak? _currentStreak;
  String _selectedView = 'smart'; // smart, timeline, calendar, patterns

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadMoods();
  }

  @override
  void dispose() {
    _disposeAnimations();
    super.dispose();
  }

  void _initializeAnimations() {
    // Header entrance animation
    _headerController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _headerAnimation = CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic);

    // Mood buddy animation
    _buddyController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _buddyAnimation = CurvedAnimation(parent: _buddyController, curve: Curves.elasticOut);

    // Background gradient animation
    _backgroundController = AnimationController(duration: const Duration(seconds: 8), vsync: this);
    _backgroundAnimation = CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut);

    // Particle animation
    _particleController = AnimationController(duration: const Duration(seconds: 12), vsync: this);
    _particleAnimation = CurvedAnimation(parent: _particleController, curve: Curves.linear);

    // Start animations
    _headerController.forward();
    _buddyController.forward();
    _backgroundController.repeat(reverse: true);
    _particleController.repeat();
  }

  void _disposeAnimations() {
    _headerController.dispose();
    _buddyController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
  }

  void _loadMoods() {
    context.read<MoodBloc>().add(LoadMoods());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () {MoodInputScreen();}, child: const Icon(Icons.add)),
      body: Stack(
        children: [
          // Animated background
          _buildAnimatedBackground(),

          // Main content
          TabBarView(controller: widget.tabController, children: [_buildTodayTab(), _buildHistoryTab(), _buildInsightsTab()]),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [colorScheme.surface.withValues(alpha: 0.3 + _backgroundAnimation.value * 0.2), colorScheme.surfaceContainer.withValues(alpha: 0.2 + _backgroundAnimation.value * 0.1), colorScheme.surface]
                  : [Colors.blue.shade50.withValues(alpha: 0.3 + _backgroundAnimation.value * 0.2), Colors.purple.shade50.withValues(alpha: 0.2 + _backgroundAnimation.value * 0.1), Colors.white],
            ),
          ),
          child: AnimatedBuilder(
            animation: _particleAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(_particleAnimation.value, isDark: isDark),
                size: Size.infinite,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTodayTab() {
    return BlocBuilder<MoodBloc, MoodState>(
      builder: (context, state) {
        if (state is MoodLoading) {
          return _buildLoadingState();
        } else if (state is MoodLoaded) {
          _moods = state.moods;
          final todayMoods = _getTodayMoods(_moods);

          if (todayMoods.isEmpty) {
            return _buildMorningCheckIn();
          } else {
            return _buildTodayOverview(todayMoods);
          }
        } else if (state is MoodError) {
          logandsnak(state.message);
          return _buildErrorState(state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMorningCheckIn() {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Animated header
          AnimatedBuilder(
            animation: _headerAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, (1 - _headerAnimation.value) * 30),
                child: Opacity(
                  opacity: _headerAnimation.value,
                  child: Column(
                    children: [
                      // Mood buddy
                      AnimatedBuilder(
                        animation: _buddyAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _buddyAnimation.value,
                            child: UltimateMoodBuddy(currentMood: null, streak: _currentStreak, showMessage: true),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // Greeting
                      Text(
                        l10n.goodMorning,
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        l10n.howAreYouFeelingToday,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 48),

          // Quick mood selector
          _buildQuickMoodSelector(),

          const SizedBox(height: 32),

          // Alternative options
          _buildAlternativeOptions(),
        ],
      ),
    );
  }

  Widget _buildTodayOverview(List<Mood> todayMoods) {
    final l10n = AppLocalizations.of(context)!;
    final latestMood = todayMoods.last;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Current mood display
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [_getMoodColor(latestMood.level).withValues(alpha: 0.1), Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _getMoodColor(latestMood.level).withValues(alpha: 0.3), width: 2),
              boxShadow: [BoxShadow(color: _getMoodColor(latestMood.level).withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Column(
              children: [
                // Mood buddy with current mood
                UltimateMoodBuddy(currentMood: latestMood.level, streak: _currentStreak, showMessage: true),

                const SizedBox(height: 24),

                // Mood details
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_getMoodEmoji(latestMood.level), style: const TextStyle(fontSize: 64)),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.todayYoureFeeling,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Text(_formatTime(latestMood.date), style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                      ],
                    ),
                  ],
                ),

                if (latestMood.note != null && latestMood.note!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(latestMood.note!, style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                  ),
                ],

                const SizedBox(height: 32),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _editMood(latestMood),
                        icon: const Icon(Icons.edit),
                        label: Text(l10n.edit),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: _getMoodColor(latestMood.level)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _addAnotherMood,
                        icon: const Icon(Icons.add),
                        label: Text(l10n.addAnother),
                        style: ElevatedButton.styleFrom(backgroundColor: _getMoodColor(latestMood.level), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Previous moods today
          if (todayMoods.length > 1) ...[
            Text(
              l10n.earlierToday,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            ...todayMoods.take(todayMoods.length - 1).map((mood) => _buildCompactMoodCard(mood)),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickMoodSelector() {
    final l10n = AppLocalizations.of(context)!;
    final options = [
      {'emoji': '😢', 'text': l10n.struggling, 'level': MoodLevel.very_bad},
      {'emoji': '😔', 'text': l10n.down, 'level': MoodLevel.bad},
      {'emoji': '😐', 'text': l10n.okay, 'level': MoodLevel.neutral},
      {'emoji': '🙂', 'text': l10n.prettyGood, 'level': MoodLevel.good},
      {'emoji': '😊', 'text': l10n.great, 'level': MoodLevel.very_good},
    ];

    return Column(
      children: options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final level = option['level'] as MoodLevel;

        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + index * 100),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.only(bottom: 12),
          child: AnimatedBuilder(
            animation: _headerAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, (1 - _headerAnimation.value) * (30 - index * 5)),
                child: Opacity(opacity: _headerAnimation.value, child: _buildMoodOption(option, level)),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMoodOption(Map<String, dynamic> option, MoodLevel level) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _selectMood(level),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: isDark ? colorScheme.surface : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? colorScheme.outline.withValues(alpha: 0.3) : Colors.grey.shade200),
          boxShadow: [BoxShadow(color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            Text(option['emoji'] as String, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                option['text'] as String,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: isDark ? colorScheme.onSurface : Colors.black87),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: isDark ? colorScheme.onSurface.withValues(alpha: 0.6) : Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAlternativeOptions() {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainer : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? colorScheme.outline.withValues(alpha: 0.3) : Colors.blue.shade200),
      ),
      child: Column(
        children: [
          Text(
            'Need more options?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? colorScheme.onSurface : Colors.black87),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _openConversationalCheckIn,
                  icon: const Icon(Icons.chat),
                  label: Text(l10n.guidedCheckIn),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isDark ? colorScheme.outline : Colors.blue.shade400),
                    foregroundColor: isDark ? colorScheme.onSurface : Colors.blue.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _openDetailedMoodInput,
                  icon: const Icon(Icons.edit_note),
                  label: Text(l10n.detailedEntry),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isDark ? colorScheme.outline : Colors.blue.shade400),
                    foregroundColor: isDark ? colorScheme.onSurface : Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactMoodCard(Mood mood) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? colorScheme.outline.withValues(alpha: 0.3) : Colors.grey.shade200),
        boxShadow: [BoxShadow(color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Text(_getMoodEmoji(mood.level), style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getMoodText(mood.level),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? colorScheme.onSurface : Colors.black87),
                ),
                Text(_formatTime(mood.date), style: TextStyle(fontSize: 12, color: isDark ? colorScheme.onSurface.withValues(alpha: 0.6) : Colors.grey.shade600)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: isDark ? colorScheme.onSurface.withValues(alpha: 0.6) : Colors.grey.shade400, size: 20),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Column(
      children: [
        // View toggle
        _buildViewToggle(),

        // Content based on selected view
        Expanded(
          child: BlocBuilder<MoodBloc, MoodState>(
            builder: (context, state) {
              if (state is MoodLoading) {
                return _buildLoadingState();
              } else if (state is MoodLoaded) {
                _moods = state.moods;

                switch (_selectedView) {
                  case 'smart':
                    return _buildSmartHistory(_moods);
                  case 'timeline':
                    return _buildTimelineHistory(_moods);
                  case 'calendar':
                    return _buildCalendarHistory(_moods);
                  case 'patterns':
                    return _buildPatternsHistory(_moods);
                  default:
                    return _buildSmartHistory(_moods);
                }
              } else if (state is MoodError) {
                logandsnak(state.message);
                return _buildErrorState(state.message);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildViewToggle() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(children: [_buildViewButton('smart', '🧠', l10n.smartView), _buildViewButton('timeline', '⏱️', l10n.timelineView), _buildViewButton('calendar', '📆', l10n.calendarView), _buildViewButton('patterns', '📊', l10n.patternsView)]),
    );
  }

  Widget _buildViewButton(String view, String emoji, String label) {
    final isSelected = _selectedView == view;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => _selectedView = view);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: isSelected ? Colors.blue.shade100 : Colors.transparent, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Text(emoji, style: TextStyle(fontSize: 20, color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600)),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmartHistory(List<Mood> moods) {
    if (moods.isEmpty) {
      return _buildEmptyHistory();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Quick insights
          _buildQuickInsights(moods),

          const SizedBox(height: 24),

          // Recent moods
          _buildRecentMoods(moods),

          const SizedBox(height: 24),

          // Mood buddy
          UltimateMoodBuddy(currentMood: _getMostRecentMood(moods)?.level, streak: _currentStreak, showMessage: true),
        ],
      ),
    );
  }

  Widget _buildTimelineHistory(List<Mood> moods) {
    if (moods.isEmpty) {
      return _buildEmptyHistory();
    }

    final sortedMoods = List<Mood>.from(moods)..sort((a, b) => b.date.compareTo(a.date));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedMoods.length,
      itemBuilder: (context, index) {
        final mood = sortedMoods[index];
        final isToday = _isToday(mood.date);

        return Column(children: [if (index == 0 || !_isSameDay(sortedMoods[index - 1].date, mood.date)) _buildDateHeader(mood.date, isToday), _buildTimelineMoodCard(mood, isToday), if (index < sortedMoods.length - 1) const SizedBox(height: 8)]);
      },
    );
  }

  Widget _buildCalendarHistory(List<Mood> moods) {
    return UltimateMoodCalendar(
      moods: moods,
      onDateSelected: (date) {
        // Show mood details for selected date
      },
    );
  }

  Widget _buildPatternsHistory(List<Mood> moods) {
    if (moods.isEmpty) {
      return _buildEmptyHistory();
    }

    return UltimateInsightsEngine(
      moods: moods,
      onInsightSelected: (insight) {
        // Handle insight selection
      },
    );
  }

  Widget _buildInsightsTab() {
    return BlocBuilder<MoodBloc, MoodState>(
      builder: (context, state) {
        if (state is MoodLoaded) {
          return UltimateInsightsEngine(
            moods: state.moods,
            onInsightSelected: (insight) {
              // Handle insight selection
            },
          );
        } else if (state is MoodLoading) {
          return _buildLoadingState();
        } else if (state is MoodError) {
          logandsnak(state.message);
          return _buildErrorState(state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }

  logandsnak(String message) {
    final l10n = AppLocalizations.of(context)!;
    AppLogging.logError(message);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Enhanced error handling with specific actions for duplicate mood errors
        if (message.contains('already logged your mood today')) {
          _showDuplicateMoodDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red.shade400,
              action: SnackBarAction(label: l10n.dismiss, onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
            ),
          );
        }
      }
    });
  }

  void _showDuplicateMoodDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.moodAlreadyLoggedToday)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.updateTodaysEntryInstead),
            const SizedBox(height: 16),
            Text(l10n.viewAndUpdateTodaysMoodEntry, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancelButton)),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to today's mood entry for editing
              _navigateToTodaysMood();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text(l10n.viewAndUpdateMood),
          ),
        ],
      ),
    );
  }

  void _navigateToTodaysMood() {
    // Find today's mood and navigate to edit screen
    final todayMoods = _getTodayMoods(_moods);
    if (todayMoods.isNotEmpty) {
      final todayMood = todayMoods.first;
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MoodDetailScreen(mood: todayMood)));
    }
  }

  Widget _buildQuickInsights(List<Mood> moods) {
    final l10n = AppLocalizations.of(context)!;
    final insights = _generateInsights(moods);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quickInsights,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Wrap(spacing: 8, runSpacing: 8, children: insights.map((insight) => _buildInsightChip(insight)).toList()),
        ],
      ),
    );
  }

  Widget _buildInsightChip(String insight) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Text(
        insight,
        style: TextStyle(fontSize: 14, color: Colors.blue.shade700, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildRecentMoods(List<Mood> moods) {
    final l10n = AppLocalizations.of(context)!;
    final recentMoods = moods.where((m) => !_isToday(m.date)).take(5).toList();

    if (recentMoods.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recentMoods,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        ...recentMoods.map((mood) => _buildCompactMoodCard(mood)),
      ],
    );
  }

  Widget _buildDateHeader(DateTime date, bool isToday) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Text(
            isToday ? l10n.today : _formatDate(date),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isToday ? Colors.black87 : Colors.grey.shade600),
          ),
          if (isToday) ...[
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: Colors.blue.shade400, shape: BoxShape.circle),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineMoodCard(Mood mood, bool isToday) {
    return GestureDetector(
      onTap: () => _editMood(mood),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isToday ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isToday ? Colors.blue.shade200 : Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Center(child: Text(_getMoodEmoji(mood.level), style: const TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getMoodText(mood.level),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  if (mood.note != null && mood.note!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      mood.note!,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(_formatDateTime(mood.date), style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyHistory() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            child: Center(child: Text('🌱', style: const TextStyle(fontSize: 48))),
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

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(message) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            l10n.somethingWentWrong,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          if (kDebugMode) Text(message, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)) else Text(l10n.pleaseTryAgainLater, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  // Helper methods
  List<Mood> _getTodayMoods(List<Mood> moods) {
    final today = DateTime.now();
    return moods.where((mood) => mood.date.year == today.year && mood.date.month == today.month && mood.date.day == today.day).toList();
  }

  Mood? _getMostRecentMood(List<Mood> moods) {
    if (moods.isEmpty) return null;
    return moods.reduce((a, b) => a.date.isAfter(b.date) ? a : b);
  }

  void _selectMood(MoodLevel level) {
    HapticFeedback.mediumImpact();

    context.read<MoodBloc>().add(QuickAddMood(level, null));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [Text(_getMoodEmoji(level)), const SizedBox(width: 8), Text('Mood recorded: ${_getMoodText(level)}')]),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _editMood(Mood mood) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MoodDetailScreen(mood: mood)));
  }

  void _addAnotherMood() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MoodDetailScreen()));
  }

  void _openConversationalCheckIn() {
    // Navigate to conversational check-in
  }

  void _openDetailedMoodInput() {
    // Navigate to detailed mood input
  }

  List<String> _generateInsights(List<Mood> moods) {
    final insights = <String>[];
    final l10n = AppLocalizations.of(context)!;

    if (moods.isNotEmpty) {
      final avgMood = _calculateAverageMood(moods);
      if (avgMood >= 4) {
        insights.add(l10n.insightGenerallyPositive);
      } else if (avgMood <= 2) {
        insights.add(l10n.insightNeedsSupport);
      }

      final streak = _calculateStreak(moods);
      if (streak >= 7) {
        insights.add(l10n.insightGreatConsistency);
      }

      final todayCount = _getTodayMoods(moods).length;
      if (todayCount == 0) {
        insights.add(l10n.insightMissingToday);
      }
    }

    return insights;
  }

  int _calculateStreak(List<Mood> moods) {
    if (moods.isEmpty) return 0;

    final sortedMoods = List<Mood>.from(moods)..sort((a, b) => a.date.compareTo(b.date));

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

  double _calculateAverageMood(List<Mood> moods) {
    if (moods.isEmpty) return 0;

    final total = moods.map((m) => m.level.index + 1).reduce((a, b) => a + b);
    return total / moods.length;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDateTime(DateTime date) {
    final dateStr = _formatDate(date);
    final timeStr = _formatTime(date);
    return '$dateStr at $timeStr';
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
    final l10n = AppLocalizations.of(context)!;
    switch (level) {
      case MoodLevel.very_bad:
        return l10n.moodVeryBad;
      case MoodLevel.bad:
        return l10n.moodBad;
      case MoodLevel.neutral:
        return l10n.moodNeutral;
      case MoodLevel.good:
        return l10n.moodGood;
      case MoodLevel.very_good:
        return l10n.moodVeryGood;
    }
  }
}

/// Custom painter for animated background particles
class ParticlePainter extends CustomPainter {
  final double animation;
  final bool isDark;

  ParticlePainter(this.animation, {this.isDark = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.05) // Subtle white particles for dark mode
          : Colors.blue.withValues(alpha: 0.1) // Blue particles for light mode
      ..style = PaintingStyle.fill;

    // Draw floating particles
    for (int i = 0; i < 20; i++) {
      final x = (size.width * 0.1 + i * size.width * 0.04) + (animation * 50 * (i % 2 == 0 ? 1 : -1)) % size.width;
      final y = (size.height * 0.1 + i * size.height * 0.05) + (animation * 30 * (i % 3 == 0 ? 1 : -1)) % size.height;

      canvas.drawCircle(Offset(x, y), 2 + i % 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
