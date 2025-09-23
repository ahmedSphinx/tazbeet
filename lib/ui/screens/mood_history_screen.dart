import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../blocs/mood/mood_bloc.dart';
import '../../blocs/mood/mood_event.dart';
import '../../blocs/mood/mood_state.dart';
import '../../models/mood.dart';
import '../../utils/date_formatter.dart';

class MoodHistoryScreen extends StatefulWidget {
  const MoodHistoryScreen({super.key});

  @override
  State<MoodHistoryScreen> createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MoodBloc>().add(LoadMoods());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MoodBloc, MoodState>(
        builder: (context, state) {
          if (state is MoodLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MoodLoaded) {
            if (state.moods.isEmpty) {
              return _buildEmptyState();
            }
            return _buildMoodList(state.moods);
          } else if (state is MoodError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_satisfied,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No mood entries yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Start logging your moods to see your history',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodList(List<Mood> moods) {
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
                                DateFormatter.formatDateTime(moods[index].date),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          if (moods[index].note != null &&
                              moods[index].note!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              moods[index].note!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildMetricChip(
                                  'Energy',
                                  moods[index].energyLevel,
                                ),
                                const SizedBox(width: 8),
                                _buildMetricChip(
                                  'Focus',
                                  moods[index].focusLevel,
                                ),
                                const SizedBox(width: 8),
                                _buildMetricChip(
                                  'Stress',
                                  moods[index].stressLevel,
                                ),
                              ],
                            ),
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
