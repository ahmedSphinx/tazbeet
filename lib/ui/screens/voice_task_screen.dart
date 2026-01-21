import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/task.dart';
import '../../services/voice_task_service.dart';
import '../../models/voice_task_result.dart';
import '../widgets/voice_task_recorder.dart';
import '../widgets/voice_task_confirmation.dart';
import '../../ui/themes/design_system.dart';
import '../../l10n/app_localizations.dart';

/// Voice Task Screen - Main interface for voice task creation
class VoiceTaskScreen extends StatefulWidget {
  const VoiceTaskScreen({super.key});

  @override
  State<VoiceTaskScreen> createState() => _VoiceTaskScreenState();
}

class _VoiceTaskScreenState extends State<VoiceTaskScreen> {
  final VoiceTaskService _voiceService = VoiceTaskService();
  bool _showRecorder = false;
  List<Task> _recentTasks = [];

  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.voiceTasks), backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Theme.of(context).colorScheme.onPrimary, elevation: 0),
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
      floatingActionButton: _showRecorder ? null : FloatingActionButton.extended(onPressed: _startVoiceRecording, icon: const Icon(Icons.mic), label: Text(AppLocalizations.of(context)!.startRecording)),
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
        content: Text(AppLocalizations.of(context)!.tasksCreatedSuccessfully),
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
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.enterTaskManually),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.taskTitle, border: OutlineInputBorder()),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.enterTaskDescription, border: OutlineInputBorder()),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(AppLocalizations.of(context)!.cancel)),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.trim().isNotEmpty) {
                // Create a task from the text input
                final task = Task(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _titleController.text.trim(),
                  description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
                  priority: TaskPriority.medium,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  progress: 0,
                  index: 0,
                  subtasks: [],
                  maxSubtaskDepth: 0,
                  strictCompletionMode: false,
                  reminderIntervals: [],
                  tags: [],
                );

                // Add task to recent tasks list
                setState(() {
                  _recentTasks.insert(0, task);
                  // Keep only the last 10 tasks
                  if (_recentTasks.length > 10) {
                    _recentTasks = _recentTasks.take(10).toList();
                  }
                });

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.taskAddedSuccessfully), duration: const Duration(seconds: 2)));
              }
            },
            child: Text(AppLocalizations.of(context)!.addTask),
          ),
        ],
      ),
    );
  }

  void _showRecentTasks() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.history, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(AppLocalizations.of(context)!.recentTasks, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  if (_recentTasks.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _recentTasks.clear();
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context)!.clearAll),
                    ),
                ],
              ),
            ),

            const Divider(),

            // Tasks list
            Expanded(
              child: _recentTasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_outlined, size: 64, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
                          const SizedBox(height: 16),
                          Text(AppLocalizations.of(context)!.noRecentTasks, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _recentTasks.length,
                      itemBuilder: (context, index) {
                        final task = _recentTasks[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(task.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                            subtitle: task.description != null ? Text(task.description!, maxLines: 2, overflow: TextOverflow.ellipsis) : null,
                            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                            onTap: () {
                              // Here you could navigate to task details or edit the task
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
