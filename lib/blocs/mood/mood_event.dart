import 'package:equatable/equatable.dart';
import '../../models/mood.dart';

abstract class MoodEvent extends Equatable {
  const MoodEvent();

  @override
  List<Object?> get props => [];
}

class LoadMoods extends MoodEvent {}

class AddMood extends MoodEvent {
  final Mood mood;

  const AddMood(this.mood);

  @override
  List<Object?> get props => [mood];
}

class UpdateMood extends MoodEvent {
  final Mood mood;

  const UpdateMood(this.mood);

  @override
  List<Object?> get props => [mood];
}

class DeleteMood extends MoodEvent {
  final String id;

  const DeleteMood(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadMoodStatistics extends MoodEvent {}

class LoadMoodTrends extends MoodEvent {
  final int days;

  const LoadMoodTrends(this.days);

  @override
  List<Object?> get props => [days];
}
