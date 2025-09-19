import 'package:equatable/equatable.dart';
import '../../models/mood.dart';

abstract class MoodState extends Equatable {
  const MoodState();

  @override
  List<Object?> get props => [];
}

class MoodInitial extends MoodState {}

class MoodLoading extends MoodState {}

class MoodLoaded extends MoodState {
  final List<Mood> moods;

  const MoodLoaded(this.moods);

  @override
  List<Object?> get props => [moods];
}

class MoodStatisticsLoaded extends MoodState {
  final Map<String, dynamic> statistics;

  const MoodStatisticsLoaded(this.statistics);

  @override
  List<Object?> get props => [statistics];
}

class MoodTrendsLoaded extends MoodState {
  final List<Map<String, dynamic>> trends;

  const MoodTrendsLoaded(this.trends);

  @override
  List<Object?> get props => [trends];
}

class MoodError extends MoodState {
  final String message;

  const MoodError(this.message);

  @override
  List<Object?> get props => [message];
}
