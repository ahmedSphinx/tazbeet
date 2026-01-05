import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import '../../services/voice_task_service.dart';
import '../../models/voice_task_result.dart';
import '../../ui/themes/design_system.dart';

/// Voice Task Recording Widget
class VoiceTaskRecorder extends StatefulWidget {
  final Function(VoiceTaskResult) onTaskCreated;
  final VoidCallback? onCancelled;

  const VoiceTaskRecorder({super.key, required this.onTaskCreated, this.onCancelled});

  @override
  State<VoiceTaskRecorder> createState() => _VoiceTaskRecorderState();
}

class _VoiceTaskRecorderState extends State<VoiceTaskRecorder> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  final VoiceTaskService _voiceService = VoiceTaskService();
  VoiceTaskStatus _status = VoiceTaskStatus.idle;
  String _transcription = '';
  double _amplitude = 0.0;
  VoiceTaskErrorDetails? _error;
  Timer? _silenceTimer;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupAmplitudeListener();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(duration: const Duration(seconds: 1), vsync: this);

    _waveController = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _waveAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _waveController, curve: Curves.easeInOut));

    _pulseController.repeat(reverse: true);
    _waveController.repeat(reverse: true);
  }

  void _setupAmplitudeListener() {
    _voiceService.amplitudeStream.listen((amplitude) {
      if (mounted) {
        setState(() {
          _amplitude = amplitude;
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _silenceTimer?.cancel();
    _voiceService.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      setState(() {
        _status = VoiceTaskStatus.recording;
        _error = null;
        _transcription = '';
      });

      await _voiceService.startRecording();
      _startSilenceDetection();
    } catch (e) {
      setState(() {
        _status = VoiceTaskStatus.error;
        _error = VoiceTaskErrorDetails(type: VoiceTaskError.recordingFailed, message: 'Failed to start recording', details: e.toString());
      });
    }
  }

  void _startSilenceDetection() {
    _silenceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_amplitude < 0.1) {
        timer.cancel();
        _stopRecording();
      }
    });
  }

  Future<void> _stopRecording() async {
    _silenceTimer?.cancel();

    try {
      setState(() {
        _status = VoiceTaskStatus.processing;
      });

      final result = await _voiceService.stopAndProcess();

      setState(() {
        _status = VoiceTaskStatus.completed;
        _transcription = result.originalTranscription;
      });

      widget.onTaskCreated(result);
    } catch (e) {
      setState(() {
        _status = VoiceTaskStatus.error;
        _error = VoiceTaskErrorDetails(type: VoiceTaskError.parsingFailed, message: 'Failed to process voice input', details: e.toString());
      });
    }
  }

  void _cancelRecording() {
    _silenceTimer?.cancel();
    _voiceService.cancelRecording();

    setState(() {
      _status = VoiceTaskStatus.idle;
      _error = null;
    });

    widget.onCancelled?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 32, // Account for padding
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.mic, color: Theme.of(context).colorScheme.primary, size: 24),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Voice Task Recording',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (_status != VoiceTaskStatus.idle) IconButton(onPressed: _cancelRecording, icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Recording Interface
          if (_status == VoiceTaskStatus.idle) ...[
            _buildIdleState(),
          ] else if (_status == VoiceTaskStatus.recording) ...[
            _buildRecordingState(),
          ] else if (_status == VoiceTaskStatus.processing) ...[
            _buildProcessingState(),
          ] else if (_status == VoiceTaskStatus.completed) ...[
            _buildCompletedState(),
          ] else if (_status == VoiceTaskStatus.error) ...[
            _buildErrorState(),
          ],
        ],
      ),
    );
  }

  Widget _buildIdleState() {
    return Column(
      children: [
        // Microphone button
        GestureDetector(
          onTap: _startRecording,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                    boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), blurRadius: 20, spreadRadius: 2)],
                  ),
                  child: const Icon(Icons.mic, color: Colors.white, size: 32),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Instructions
        Text(
          'Tap to start recording',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Tips
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3), borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Theme.of(context).colorScheme.primary, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text('Speak clearly and naturally', style: Theme.of(context).textTheme.bodySmall)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingState() {
    return Column(
      children: [
        // Waveform visualization
        Container(
          height: 100,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.md), color: Theme.of(context).colorScheme.surfaceVariant),
          child: AnimatedBuilder(
            animation: _waveAnimation,
            builder: (context, child) {
              return CustomPaint(painter: WaveformPainter(_amplitude, _waveAnimation.value), child: Container());
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Recording indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Recording...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Stop button
        GestureDetector(
          onTap: _stopRecording,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: const Text(
              'Stop',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingState() {
    return Column(
      children: [
        // Lottie animation
        SizedBox(
          height: 120,
          child: Lottie.asset(
            'assets/animations/voice_processing.json',
            controller: _waveController,
            onLoaded: (composition) {
              _waveController.repeat();
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        Text('Processing your voice...', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
      ],
    );
  }

  Widget _buildCompletedState() {
    return Column(
      children: [
        // Success icon
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
          child: const Icon(Icons.check, color: Colors.white, size: 30),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Transcription
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('I heard:', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(height: AppSpacing.xs),
              Text(_transcription, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Column(
      children: [
        // Error icon
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
          child: const Icon(Icons.error_outline, color: Colors.white, size: 30),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Error message
        Text(
          _error?.message ?? 'An error occurred',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
        ),
        if (_error?.details != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            _error!.details!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),

        // Retry button
        GestureDetector(
          onTap: () {
            setState(() {
              _status = VoiceTaskStatus.idle;
              _error = null;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: const Text(
              'Try Again',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for waveform visualization
class WaveformPainter extends CustomPainter {
  final double amplitude;
  final double animation;

  WaveformPainter(this.amplitude, this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.7)
      ..strokeWidth = 2.0;

    final path = Path();
    final centerY = size.height / 2;

    for (int i = 0; i < size.width.toInt(); i += 2) {
      final x = i.toDouble();
      final normalizedAmplitude = amplitude * animation;
      final y = centerY + (normalizedAmplitude * (i % 10 - 5) * 3);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
