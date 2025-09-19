import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../blocs/mood/mood_bloc.dart';
import '../../blocs/mood/mood_event.dart';
import '../../blocs/mood/mood_state.dart';
import '../../models/mood.dart';
import '../../utils/date_formatter.dart';
import '../utils/page_transitions.dart';
import 'mood_logging_screen.dart';
import 'mood_history_screen.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<MoodBloc>().add(LoadMoods());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracking'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today', icon: Icon(Icons.today)),
            Tab(text: 'History', icon: Icon(Icons.history)),
            Tab(text: 'Insights', icon: Icon(Icons.insights)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTodayTab(),
          const MoodHistoryScreen(),
          _buildInsightsTab(),
        ],
      ),
      floatingActionButton: AnimationConfiguration.synchronized(
        duration: const Duration(milliseconds: 600),
        child: ScaleAnimation(
          scale: 1.0,
          child: FadeInAnimation(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(FadePageRoute(page: const MoodLoggingScreen()));
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodayTab() {
    return BlocBuilder<MoodBloc, MoodState>(
      builder: (context, state) {
        if (state is MoodLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MoodLoaded) {
          final today = DateTime.now();
          final todayMoods = state.moods.where((mood) =>
              mood.date.year == today.year &&
              mood.date.month == today.month &&
              mood.date.day == today.day).toList();

          if (todayMoods.isEmpty) {
            return _buildEmptyTodayState();
          }

          return _buildTodayMoods(todayMoods);
        } else if (state is MoodError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyTodayState() {
    return Center(
      child: AnimationConfiguration.synchronized(
        duration: const Duration(milliseconds: 800),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleAnimation(
              scale: 0.8,
              child: FadeInAnimation(
                delay: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.sentiment_satisfied,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeInAnimation(
              delay: const Duration(milliseconds: 400),
              child: Text(
                'How are you feeling today?',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 8),
            FadeInAnimation(
              delay: const Duration(milliseconds: 600),
              child: Text(
                'Tap the + button to log your mood',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayMoods(List<Mood> moods) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: moods.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 60.0,
              curve: Curves.easeOutCubic,
              child: FadeInAnimation(
                curve: Curves.easeOut,
                child: ScaleAnimation(
                  scale: 0.95,
                  curve: Curves.easeOutBack,
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _buildMoodIcon(moods[index].level),
                              const SizedBox(width: 12),
                              Text(
                                _getMoodText(moods[index].level),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Spacer(),
                              Text(
                                DateFormatter.formatTime(moods[index].date),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          if (moods[index].note != null && moods[index].note!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              moods[index].note!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              _buildMetricChip('Energy', moods[index].energyLevel),
                              _buildMetricChip('Focus', moods[index].focusLevel),
                              _buildMetricChip('Stress', moods[index].stressLevel),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInsightsTab() {
    return BlocBuilder<MoodBloc, MoodState>(
      builder: (context, state) {
        if (state is MoodLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MoodStatisticsLoaded) {
          return _buildStatisticsView(state.statistics);
        } else {
          // Load statistics if not loaded
          context.read<MoodBloc>().add(LoadMoodStatistics());
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildStatisticsView(Map<String, dynamic> stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Mood Insights',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          _buildStatCard('Total Entries', stats['totalEntries'].toString()),
          const SizedBox(height: 16),
          _buildStatCard('Average Mood', _getMoodText(MoodLevel.values[stats['averageMood'].round()])),
          const SizedBox(height: 16),
          _buildStatCard('Most Common Mood', _getMoodText(stats['mostCommonMood'])),
          const SizedBox(height: 16),
          _buildStatCard('Current Streak', '${stats['streakDays']} days'),
          const SizedBox(height: 16),
          _buildStatCard('Average Energy', '${stats['averageEnergy'].round()}/10'),
          const SizedBox(height: 16),
          _buildStatCard('Average Focus', '${stats['averageFocus'].round()}/10'),
          const SizedBox(height: 16),
          _buildStatCard('Average Stress', '${stats['averageStress'].round()}/10'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodIcon(MoodLevel level) {
    IconData icon;
    Color color;

    switch (level) {
      case MoodLevel.very_bad:
        icon = Icons.sentiment_very_dissatisfied;
        color = Colors.red;
        break;
      case MoodLevel.bad:
        icon = Icons.sentiment_dissatisfied;
        color = Colors.orange;
        break;
      case MoodLevel.neutral:
        icon = Icons.sentiment_neutral;
        color = Colors.yellow;
        break;
      case MoodLevel.good:
        icon = Icons.sentiment_satisfied;
        color = Colors.lightGreen;
        break;
      case MoodLevel.very_good:
        icon = Icons.sentiment_very_satisfied;
        color = Colors.green;
        break;
    }

    return Icon(icon, color: color, size: 32);
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

  Widget _buildMetricChip(String label, int value) {
    return Chip(
      label: Text('$label: $value/10'),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}
