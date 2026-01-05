import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/voice_task_service.dart';
import '../../models/voice_task_result.dart';
import '../widgets/voice_task_recorder.dart';
import '../widgets/voice_task_confirmation.dart';
import '../../ui/themes/design_system.dart';

/// Voice Task Screen - Main interface for voice task creation
class VoiceTaskScreen extends StatefulWidget {
  const VoiceTaskScreen({super.key});

  @override
  State<VoiceTaskScreen> createState() => _VoiceTaskScreenState();
}

class _VoiceTaskScreenState extends State<VoiceTaskScreen> {
  final VoiceTaskService _voiceService = VoiceTaskService();
  bool _showRecorder = false;
  VoiceTaskResult? _lastResult;

  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Tasks'), backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Theme.of(context).colorScheme.onPrimary, elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.mic, color: Theme.of(context).colorScheme.primary, size: 32),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Voice Task Creation', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: AppSpacing.xs),
                        Text('Create tasks naturally with your voice', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Voice Recorder or Welcome
              Expanded(
                child: _showRecorder ? VoiceTaskRecorder(onTaskCreated: _onTaskCreated, onCancelled: _onRecordingCancelled) : _buildWelcomeState(),
              ),

              // Quick Actions
              _buildQuickActions(),
            ],
          ),
        ),
      ),
      floatingActionButton: _showRecorder ? null : FloatingActionButton.extended(onPressed: _startVoiceRecording, icon: const Icon(Icons.mic), label: Text('Start Recording')),
    );
  }

  Widget _buildWelcomeState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Illustration
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3), borderRadius: BorderRadius.circular(100)),
          child: Icon(Icons.mic, size: 80, color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Welcome text
        Text(
          'Ready to create tasks with your voice?',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.md),

        Text(
          'Simply tap the microphone button and speak naturally. I\'ll understand and create tasks for you!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Example phrases
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(AppRadius.lg)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Try saying:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(height: AppSpacing.md),
              _buildExamplePhrase('Remind me to call the doctor tomorrow morning'),
              const SizedBox(height: AppSpacing.sm),
              _buildExamplePhrase('Buy groceries and eggs after work'),
              const SizedBox(height: AppSpacing.sm),
              _buildExamplePhrase('Schedule team meeting for next week, high priority'),
              const SizedBox(height: AppSpacing.sm),
              _buildExamplePhrase('أذكرني أتم تقرير المشروع بكرة الصبح'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExamplePhrase(String phrase) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.chat_bubble_outline, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(phrase, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(icon: Icons.keyboard, label: 'Type Instead', onTap: _showTextInput),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildQuickAction(icon: Icons.history, label: 'Recent Tasks', onTap: _showRecentTasks),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
            const SizedBox(height: AppSpacing.xs),
            Text(label, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _startVoiceRecording() {
    HapticFeedback.lightImpact();
    setState(() {
      _showRecorder = true;
    });
  }

  void _onTaskCreated(VoiceTaskResult result) {
    setState(() {
      _lastResult = result;
      _showRecorder = false;
    });

    _showConfirmationDialog(result);
  }

  void _onRecordingCancelled() {
    setState(() {
      _showRecorder = false;
    });
  }

  void _showConfirmationDialog(VoiceTaskResult result) {
    showDialog(
      context: context,
      builder: (context) => VoiceTaskConfirmation(
        result: result,
        onCancelled: () {
          Navigator.of(context).pop();
          setState(() {
            _showRecorder = true;
          });
        },
        onCompleted: () {
          Navigator.of(context).pop();
          _showSuccessMessage();
        },
      ),
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tasks created successfully!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'View Tasks',
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _showTextInput() {
    // TODO: Implement text input dialog
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Text input coming soon!'), duration: Duration(seconds: 2)));
  }

  void _showRecentTasks() {
    // TODO: Implement recent tasks view
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recent tasks coming soon!'), duration: Duration(seconds: 2)));
  }
}
