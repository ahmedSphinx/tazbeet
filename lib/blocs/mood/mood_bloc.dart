import 'dart:async';
import 'package:tazbeet/services/app_logging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../repositories/mood_repository.dart';
import '../../services/data_sync_service.dart';
import '../../models/mood.dart';
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
    on<MoodCheckInTriggered>(_onMoodCheckInTriggered);
    on<QuickAddMood>(_onQuickAddMood);
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
          AppLogging.logInfo('Failed to sync mood addition to Firestore: $e');
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
          AppLogging.logInfo('Failed to sync mood update to Firestore: $e');
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
          AppLogging.logInfo('Failed to sync mood deletion to Firestore: $e');
        }
      }
    } catch (e) {
      emit(MoodError('Failed to delete mood: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoodStatistics(LoadMoodStatistics event, Emitter<MoodState> emit) async {
    emit(MoodLoading());
    try {
      final statistics = await moodRepository.getMoodStatistics();
      emit(MoodStatisticsLoaded(statistics));
    } catch (e) {
      emit(MoodError('Failed to load mood statistics: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoodTrends(LoadMoodTrends event, Emitter<MoodState> emit) async {
    emit(MoodLoading());
    try {
      final trends = await moodRepository.getMoodTrends(event.days);
      emit(MoodTrendsLoaded(trends));
    } catch (e) {
      emit(MoodError('Failed to load mood trends: ${e.toString()}'));
    }
  }

  Future<void> _onMoodCheckInTriggered(MoodCheckInTriggered event, Emitter<MoodState> emit) async {
    // This event is primarily for navigation purposes
    // The actual navigation should be handled by the UI layer
    // We can emit a state to indicate check-in was triggered
    emit(MoodCheckInTriggeredState(event.triggerTime));
  }

  Future<void> _onQuickAddMood(QuickAddMood event, Emitter<MoodState> emit) async {
    try {
      final mood = Mood(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        level: event.level,
        note: event.note,
        date: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        energyLevel: 5, // Default values for quick add
        focusLevel: 5,
        stressLevel: 5,
      );

      await moodRepository.addMood(mood);
      final moods = await moodRepository.getAllMoods();
      emit(MoodLoaded(moods));

      // Sync to Firestore if user is signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await _dataSyncService.syncToFirestore(user.uid);
        } catch (e) {
          AppLogging.logInfo('Failed to sync quick mood addition to Firestore: $e');
        }
      }
    } catch (e) {
      emit(MoodError('Failed to add quick mood: ${e.toString()}'));
    }
  }
}
