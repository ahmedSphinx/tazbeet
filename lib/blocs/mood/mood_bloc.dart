import 'dart:async';
import 'dart:developer' show log;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../repositories/mood_repository.dart';
import '../../services/data_sync_service.dart';
import 'mood_event.dart';
import 'mood_state.dart';

class MoodBloc extends Bloc<MoodEvent, MoodState> {
  final MoodRepository moodRepository;
  final DataSyncService _dataSyncService = DataSyncService();

  MoodBloc(this.moodRepository) : super(MoodInitial()) {
    on<LoadMoods>(_onLoadMoods);
    on<AddMood>(_onAddMood);
    on<UpdateMood>(_onUpdateMood);
    on<DeleteMood>(_onDeleteMood);
    on<LoadMoodStatistics>(_onLoadMoodStatistics);
    on<LoadMoodTrends>(_onLoadMoodTrends);
  }

  Future<void> _onLoadMoods(LoadMoods event, Emitter<MoodState> emit) async {
    emit(MoodLoading());
    try {
      final moods = await moodRepository.getAllMoods();
      emit(MoodLoaded(moods));
    } catch (e) {
      emit(MoodError('Failed to load moods: ${e.toString()}'));
    }
  }

  Future<void> _onAddMood(AddMood event, Emitter<MoodState> emit) async {
    try {
      await moodRepository.addMood(event.mood);
      final moods = await moodRepository.getAllMoods();
      emit(MoodLoaded(moods));

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          log('Failed to sync mood addition to Firestore: $e');
        }
      }
    } catch (e) {
      emit(MoodError('Failed to add mood: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateMood(UpdateMood event, Emitter<MoodState> emit) async {
    try {
      await moodRepository.updateMood(event.mood);
      final moods = await moodRepository.getAllMoods();
      emit(MoodLoaded(moods));

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          log('Failed to sync mood update to Firestore: $e');
        }
      }
    } catch (e) {
      emit(MoodError('Failed to update mood: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteMood(DeleteMood event, Emitter<MoodState> emit) async {
    try {
      await moodRepository.deleteMood(event.id);
      final moods = await moodRepository.getAllMoods();
      emit(MoodLoaded(moods));

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          log('Failed to sync mood deletion to Firestore: $e');
        }
      }
    } catch (e) {
      emit(MoodError('Failed to delete mood: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoodStatistics(
    LoadMoodStatistics event,
    Emitter<MoodState> emit,
  ) async {
    emit(MoodLoading());
    try {
      final statistics = await moodRepository.getMoodStatistics();
      emit(MoodStatisticsLoaded(statistics));
    } catch (e) {
      emit(MoodError('Failed to load mood statistics: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoodTrends(
    LoadMoodTrends event,
    Emitter<MoodState> emit,
  ) async {
    emit(MoodLoading());
    try {
      final trends = await moodRepository.getMoodTrends(event.days);
      emit(MoodTrendsLoaded(trends));
    } catch (e) {
      emit(MoodError('Failed to load mood trends: ${e.toString()}'));
    }
  }
}
