import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/task.dart';
import '../models/voice_task_result.dart';
import 'app_logging_service.dart';

/// Voice Task Service for converting speech to actionable tasks
class VoiceTaskService {
  static final VoiceTaskService _instance = VoiceTaskService._internal();
  factory VoiceTaskService() => _instance;
  VoiceTaskService._internal();

  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _currentRecordingPath;
  StreamSubscription? _amplitudeSubscription;

  /// Start voice recording
  Future<void> startRecording() async {
    try {
      // Check permissions
      final hasPermission = await _checkPermissions();
      if (!hasPermission) {
        throw Exception('Microphone permission denied');
      }

      // Create recording file
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentRecordingPath = '${directory.path}/voice_task_$timestamp.wav';

      // Start recording
      await _audioRecorder.start(const RecordConfig(encoder: AudioEncoder.wav, bitRate: 128000, sampleRate: 44100), path: _currentRecordingPath!);

      _isRecording = true;

      // Start amplitude monitoring for visualization (simplified for now)
      // Note: Amplitude monitoring will be implemented in Phase 2
      AppLogging.logInfo('Amplitude monitoring started', name: 'VoiceTaskService');

      AppLogging.logInfo('Voice recording started', name: 'VoiceTaskService');
    } catch (e) {
      AppLogging.logError('Failed to start recording: $e', name: 'VoiceTaskService');
      rethrow;
    }
  }

  /// Stop and process recording
  Future<VoiceTaskResult> stopAndProcess() async {
    if (!_isRecording) {
      throw Exception('No recording in progress');
    }

    try {
      // Stop recording
      await _audioRecorder.stop();
      _isRecording = false;
      await _amplitudeSubscription?.cancel();
      _amplitudeSubscription = null;

      AppLogging.logInfo('Voice recording stopped', name: 'VoiceTaskService');

      // Process the recorded audio
      if (_currentRecordingPath != null) {
        return await processAudio(File(_currentRecordingPath!));
      } else {
        throw Exception('No recording file found');
      }
    } catch (e) {
      AppLogging.logError('Failed to stop recording: $e', name: 'VoiceTaskService');
      rethrow;
    }
  }

  /// Process audio file directly
  Future<VoiceTaskResult> processAudio(File audioFile) async {
    try {
      AppLogging.logInfo('Processing audio file: ${audioFile.path}', name: 'VoiceTaskService');

      // Phase 1: Basic speech-to-text (using platform APIs)
      final transcription = await _transcribeAudio(audioFile);

      // Phase 1: Simple task extraction (basic parsing)
      final tasks = await _extractTasksFromText(transcription);

      return VoiceTaskResult(
        tasks: tasks,
        confidence: 0.85, // Basic confidence for Phase 1
        originalTranscription: transcription,
        audioPath: audioFile.path,
        alternatives: [],
        extractedEntities: {},
      );
    } catch (e) {
      AppLogging.logError('Failed to process audio: $e', name: 'VoiceTaskService');
      rethrow;
    }
  }

  /// Process text as if it was spoken (natural language)
  Future<VoiceTaskResult> processNaturalText(String text) async {
    try {
      AppLogging.logInfo('Processing natural text: $text', name: 'VoiceTaskService');

      final tasks = await _extractTasksFromText(text);

      return VoiceTaskResult(
        tasks: tasks,
        confidence: 0.90, // Higher confidence for direct text input
        originalTranscription: text,
        audioPath: null,
        alternatives: [],
        extractedEntities: {},
      );
    } catch (e) {
      AppLogging.logError('Failed to process text: $e', name: 'VoiceTaskService');
      rethrow;
    }
  }

  /// Check if recording is currently active
  bool get isRecording => _isRecording;

  /// Get current recording amplitude for visualization (simplified for Phase 1)
  Stream<double> get amplitudeStream => Stream.periodic(const Duration(milliseconds: 100), (_) => 0.5);

  /// Cancel current recording
  Future<void> cancelRecording() async {
    if (_isRecording) {
      await _audioRecorder.stop();
      _isRecording = false;
      await _amplitudeSubscription?.cancel();
      _amplitudeSubscription = null;

      // Delete temporary file
      if (_currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }

      _currentRecordingPath = null;
      AppLogging.logInfo('Voice recording cancelled', name: 'VoiceTaskService');
    }
  }

  /// Check microphone permissions
  Future<bool> _checkPermissions() async {
    if (kIsWeb) {
      // Web permissions handled differently
      return true;
    }

    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  /// Transcribe audio to text (Phase 1: Basic implementation)
  Future<String> _transcribeAudio(File audioFile) async {
    // Phase 1: Basic implementation using platform speech recognition
    // In a real implementation, this would integrate with:
    // - iOS: Speech framework
    // - Android: SpeechRecognizer
    // - Web: Web Speech API
    // - Cloud: Google Speech-to-Text or Whisper API

    // For now, return a placeholder transcription
    // In production, this would be actual speech-to-text processing
    await Future.delayed(const Duration(seconds: 1)); // Simulate processing time

    // This would be replaced with actual transcription
    return "Buy groceries and call the doctor tomorrow morning";
  }

  /// Extract tasks from text (Phase 1: Basic parsing)
  Future<List<ParsedTask>> _extractTasksFromText(String text) async {
    final tasks = <ParsedTask>[];

    // Phase 1: Basic keyword-based extraction
    final lowerText = text.toLowerCase();

    // Simple task detection patterns
    if (lowerText.contains('buy') || lowerText.contains('get') || lowerText.contains('purchase')) {
      final task = _parseShoppingTask(text);
      if (task != null) tasks.add(task);
    }

    if (lowerText.contains('call') || lowerText.contains('phone') || lowerText.contains('اتصل')) {
      final task = _parseCallTask(text);
      if (task != null) tasks.add(task);
    }

    if (lowerText.contains('meeting') || lowerText.contains('appoint') || lowerText.contains('موعد')) {
      final task = _parseMeetingTask(text);
      if (task != null) tasks.add(task);
    }

    // If no specific pattern matched, create a generic task
    if (tasks.isEmpty) {
      final task = _parseGenericTask(text);
      if (task != null) tasks.add(task);
    }

    return tasks;
  }

  /// Parse shopping-related tasks
  ParsedTask? _parseShoppingTask(String text) {
    // Extract items to buy
    final items = _extractItems(text);
    final title = items.isNotEmpty ? 'Buy ${items.join(', ')}' : 'Buy groceries';

    return ParsedTask(
      title: title,
      dueDate: _extractDate(text),
      reminderDate: _extractReminder(text),
      categoryId: 'shopping', // Would map to actual category ID
      priority: _extractPriority(text),
      subtasks: [],
      confidence: 0.80,
      description: text,
    );
  }

  /// Parse call-related tasks
  ParsedTask? _parseCallTask(String text) {
    final person = _extractPerson(text);
    final title = person.isNotEmpty ? 'Call $person' : 'Make a call';

    return ParsedTask(title: title, dueDate: _extractDate(text), reminderDate: _extractReminder(text), categoryId: 'personal', priority: _extractPriority(text), subtasks: [], confidence: 0.85, description: text);
  }

  /// Parse meeting-related tasks
  ParsedTask? _parseMeetingTask(String text) {
    final subject = _extractSubject(text);
    final title = subject.isNotEmpty ? 'Meeting: $subject' : 'Schedule meeting';

    return ParsedTask(title: title, dueDate: _extractDate(text), reminderDate: _extractReminder(text), categoryId: 'work', priority: _extractPriority(text), subtasks: [], confidence: 0.85, description: text);
  }

  /// Parse generic task when no specific pattern matches
  ParsedTask? _parseGenericTask(String text) {
    // Clean up the text to create a reasonable title
    String title = text.trim();

    // Remove common filler words
    final fillerWords = ['remind me to', 'أذكرني أن', 'i need to', 'أحتاج أن'];
    for (final filler in fillerWords) {
      title = title.replaceFirst(RegExp(filler, caseSensitive: false), '');
    }

    // Capitalize first letter
    if (title.isNotEmpty) {
      title = title[0].toUpperCase() + title.substring(1);
    }

    return ParsedTask(
      title: title.isNotEmpty ? title : 'New task',
      dueDate: _extractDate(text),
      reminderDate: _extractReminder(text),
      categoryId: null, // Let user choose
      priority: _extractPriority(text),
      subtasks: [],
      confidence: 0.70,
      description: text,
    );
  }

  /// Extract date/time from text (Phase 1: Basic patterns)
  DateTime? _extractDate(String text) {
    final now = DateTime.now();
    final lowerText = text.toLowerCase();

    // Today
    if (lowerText.contains('today') || lowerText.contains('اليوم')) {
      return now;
    }

    // Tomorrow
    if (lowerText.contains('tomorrow') || lowerText.contains('غدا') || lowerText.contains('بكرة')) {
      return now.add(const Duration(days: 1));
    }

    // Next week
    if (lowerText.contains('next week') || lowerText.contains('الأسبوع الجاي')) {
      return now.add(const Duration(days: 7));
    }

    // Morning (default to 9 AM)
    if (lowerText.contains('morning') || lowerText.contains('صبح')) {
      final date = _extractDate(text) ?? now;
      return DateTime(date.year, date.month, date.day, 9, 0);
    }

    // Evening (default to 6 PM)
    if (lowerText.contains('evening') || lowerText.contains('مساء')) {
      final date = _extractDate(text) ?? now;
      return DateTime(date.year, date.month, date.day, 18, 0);
    }

    return null; // Let user set manually
  }

  /// Extract reminder time (default: 30 minutes before due)
  DateTime? _extractReminder(String text) {
    final dueDate = _extractDate(text);
    if (dueDate != null) {
      return dueDate.subtract(const Duration(minutes: 30));
    }
    return null;
  }

  /// Extract priority from text
  TaskPriority _extractPriority(String text) {
    final lowerText = text.toLowerCase();

    // High priority indicators
    if (lowerText.contains('urgent') || lowerText.contains('important') || lowerText.contains('مهم') || lowerText.contains('عاجل') || lowerText.contains('ضروري')) {
      return TaskPriority.high;
    }

    // Low priority indicators
    if (lowerText.contains('maybe') || lowerText.contains('might') || lowerText.contains('ربما') || lowerText.contains('قد')) {
      return TaskPriority.low;
    }

    return TaskPriority.medium; // Default
  }

  /// Extract shopping items from text
  List<String> _extractItems(String text) {
    final items = <String>[];
    final commonItems = ['milk', 'eggs', 'bread', 'cheese', 'meat', 'vegetables', 'fruits', 'milk', 'eggs'];

    for (final item in commonItems) {
      if (text.toLowerCase().contains(item)) {
        items.add(item);
      }
    }

    return items;
  }

  /// Extract person names from text (Phase 1: Basic implementation)
  String _extractPerson(String text) {
    // Phase 1: Simple keyword-based person extraction
    final commonNames = ['ahmed', 'mohammed', 'sara', 'fatima', 'doctor', 'mom', 'dad'];

    for (final name in commonNames) {
      if (text.toLowerCase().contains(name)) {
        return name;
      }
    }

    return '';
  }

  /// Extract meeting subject from text
  String _extractSubject(String text) {
    // Phase 1: Simple subject extraction
    if (text.toLowerCase().contains('project')) {
      return 'Project discussion';
    }
    if (text.toLowerCase().contains('report')) {
      return 'Report review';
    }
    if (text.toLowerCase().contains('team')) {
      return 'Team meeting';
    }

    return '';
  }

  /// Dispose resources
  void dispose() {
    _audioRecorder.dispose();
    _amplitudeSubscription?.cancel();
  }
}
