import 'dart:async';
import 'package:tazbeet/services/app_logging_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../repositories/mood_repository.dart';
import '../../services/data_sync_service.dart';
import '../../services/mood_achievement_service.dart';
import '../../models/mood.dart';
import 'mood_event.dart';
import 'mood_state.dart';

class MoodBloc extends Bloc<MoodEvent, MoodState> {
  final MoodRepository moodRepository;
  final DataSyncService _dataSyncService = DataSyncService();
  final MoodAchievementService _achievementService = MoodAchievementService();

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

  // Validation methods
  bool _validateMoodData(Mood mood) {
    // Validate metric ranges (1-10)
    if (mood.energyLevel < 1 || mood.energyLevel > 10) return false;
    if (mood.focusLevel < 1 || mood.focusLevel > 10) return false;
    if (mood.stressLevel < 1 || mood.stressLevel > 10) return false;

    // Validate date is not in future
    if (mood.date.isAfter(DateTime.now().add(const Duration(hours: 1)))) return false;

    // Validate date is not too old (more than 1 year)
    if (mood.date.isBefore(DateTime.now().subtract(const Duration(days: 365)))) return false;

    return true;
  }

  Future<bool> _checkForDuplicateEntry(Mood mood) async {
    try {
      final allMoods = await moodRepository.getAllMoods();

      // Check for mood entry on the same day
      final sameDayMoods = allMoods
          .where(
            (existingMood) =>
                existingMood.date.year == mood.date.year && existingMood.date.month == mood.date.month && existingMood.date.day == mood.date.day && existingMood.id != mood.id, // Exclude current mood for updates
          )
          .toList();

      return sameDayMoods.isNotEmpty;
    } catch (e) {
      AppLogging.logError('Error checking for duplicate mood entry: $e');
      return false; // Allow entry if validation fails
    }
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
      // Validate mood data
      if (!_validateMoodData(event.mood)) {
        emit(MoodError('Invalid mood data. Please check your entries and try again.'));
        return;
      }

      // Check for duplicate entry
      final isDuplicate = await _checkForDuplicateEntry(event.mood);
      if (isDuplicate) {
        emit(MoodError('You have already logged your mood today. You can update today\'s entry instead.'));
        return;
      }

      await moodRepository.addMood(event.mood);

      // Update streak and check achievements
      await _achievementService.updateStreak(event.mood.date);

      // Check for detailed notes achievement
      final allMoods = await moodRepository.getAllMoods();
      await _achievementService.checkDetailedNotesAchievement(allMoods);

      emit(MoodLoaded(allMoods));

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
      final now = DateTime.now();
      // Use timestamp + microseconds + random to avoid ID collisions
      final newId = '${now.millisecondsSinceEpoch}_${now.microsecond}_${now.hashCode.abs() % 10000}';
      final mood = Mood(
        id: newId,
        level: event.level,
        note: event.note,
        date: now,
        createdAt: now,
        updatedAt: now,
        energyLevel: 5, // Default values for quick add
        focusLevel: 5,
        stressLevel: 5,
      );

      // Validate mood data
      if (!_validateMoodData(mood)) {
        emit(MoodError('Invalid mood data. Please try again.'));
        return;
      }

      // Check for duplicate entry
      final isDuplicate = await _checkForDuplicateEntry(mood);
      if (isDuplicate) {
        emit(MoodError('You have already logged your mood today. You can update today\'s entry instead.'));
        return;
      }

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
