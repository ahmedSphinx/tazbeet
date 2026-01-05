import 'package:equatable/equatable.dart';

/// Types of mood insights
enum MoodInsightType { pattern, correlation, trend, recommendation, achievement }

/// Represents an insight derived from mood data
class MoodInsight extends Equatable {
  final String id;
  final MoodInsightType type;
  final String title;
  final String description;
  final String emoji;
  final DateTime generatedAt;
  final Map<String, dynamic>? data;

  const MoodInsight({required this.id, required this.type, required this.title, required this.description, required this.emoji, required this.generatedAt, this.data});

  MoodInsight copyWith({String? id, MoodInsightType? type, String? title, String? description, String? emoji, DateTime? generatedAt, Map<String, dynamic>? data}) {
    return MoodInsight(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      generatedAt: generatedAt ?? this.generatedAt,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type.name, 'title': title, 'description': description, 'emoji': emoji, 'generatedAt': generatedAt.toIso8601String(), 'data': data};
  }

  factory MoodInsight.fromJson(Map<String, dynamic> json) {
    return MoodInsight(
      id: json['id'],
      type: MoodInsightType.values.firstWhere((e) => e.name == json['type'], orElse: () => MoodInsightType.pattern),
      title: json['title'],
      description: json['description'],
      emoji: json['emoji'],
      generatedAt: DateTime.parse(json['generatedAt']),
      data: json['data'],
    );
  }

  @override
  List<Object?> get props => [id, type, title, description, emoji, generatedAt, data];
}

/// Weekly mood summary
class WeeklyMoodSummary extends Equatable {
  final int goodDays;
  final int neutralDays;
  final int badDays;
  final double averageEnergy;
  final double averageFocus;
  final double averageStress;
  final String dominantMood;
  final List<String> topTags;

  const WeeklyMoodSummary({
    required this.goodDays,
    required this.neutralDays,
    required this.badDays,
    required this.averageEnergy,
    required this.averageFocus,
    required this.averageStress,
    required this.dominantMood,
    required this.topTags,
  });

  int get totalDays => goodDays + neutralDays + badDays;

  String get summary {
    if (goodDays > neutralDays && goodDays > badDays) {
      return 'Great week! $goodDays good days';
    } else if (badDays > goodDays && badDays > neutralDays) {
      return 'Tough week. $badDays challenging days';
    } else {
      return 'Balanced week. $neutralDays neutral days';
    }
  }

  @override
  List<Object?> get props => [goodDays, neutralDays, badDays, averageEnergy, averageFocus, averageStress, dominantMood, topTags];
}

/// Monthly mood summary
class MonthlyMoodSummary extends Equatable {
  final int totalCheckIns;
  final double averageMoodScore;
  final String bestDay;
  final String worstDay;
  final List<String> topActivities;
  final Map<String, int> moodDistribution;

  const MonthlyMoodSummary({required this.totalCheckIns, required this.averageMoodScore, required this.bestDay, required this.worstDay, required this.topActivities, required this.moodDistribution});

  @override
  List<Object?> get props => [totalCheckIns, averageMoodScore, bestDay, worstDay, topActivities, moodDistribution];
}
