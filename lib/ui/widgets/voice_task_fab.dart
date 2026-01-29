import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/voice_task_service.dart';
import '../../models/voice_task_result.dart';
import '../widgets/voice_task_recorder.dart';
import '../widgets/voice_task_confirmation.dart';
import '../../helpers/voice_task_permissions.dart';
import '../../ui/themes/design_system.dart';

/// Voice Task FAB - Floating Action Button for quick voice input
class VoiceTaskFab extends StatefulWidget {
  final VoidCallback? onTaskCreated;
  final bool showLabel;

  const VoiceTaskFab({super.key, this.onTaskCreated, this.showLabel = true});

  @override
  State<VoiceTaskFab> createState() => _VoiceTaskFabState();
}

class _VoiceTaskFabState extends State<VoiceTaskFab> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  final VoiceTaskService _voiceService = VoiceTaskService();
  bool _showRecorder = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _voiceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showRecorder) {
      return _buildVoiceRecorder();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showLabel) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Text(
              'Voice Task',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        GestureDetector(
          onLongPress: _startVoiceRecording,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: FloatingActionButton.extended(onPressed: _startVoiceRecording, icon: const Icon(Icons.mic), label: Text('Voice'), backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white, elevation: 8),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceRecorder() {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: VoiceTaskRecorder(onTaskCreated: _onTaskCreated, onCancelled: _onRecordingCancelled),
    );
  }

  Future<void> _startVoiceRecording() async {
    HapticFeedback.lightImpact();

    // Check permissions first
    final hasPermission = await VoiceTaskPermissions.checkAndRequestPermissions();

    if (!hasPermission) {
      VoiceTaskPermissions.showPermissionDialog(
        context,
        onGranted: () {
          setState(() {
            _showRecorder = true;
          });
        },
        onDenied: () {
          VoiceTaskPermissions.showPermissionDeniedDialog(context);
        },
      );
      return;
    }

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
      barrierDismissible: false,
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
          widget.onTaskCreated?.call();
          _showSuccessMessage();
        },
      ),
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Voice task created successfully!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to task list or show tasks
          },
        ),
      ),
    );
  }
}

/// Voice Task Button - Compact version for use in UI
class VoiceTaskButton extends StatelessWidget {
  final VoidCallback? onTaskCreated;
  final bool isCompact;

  const VoiceTaskButton({super.key, this.onTaskCreated, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showVoiceRecorder(context),
      child: Container(
        padding: EdgeInsets.all(isCompact ? AppSpacing.sm : AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(isCompact ? AppRadius.sm : AppRadius.md),
          boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Icon(Icons.mic, color: Colors.white, size: isCompact ? 20 : 24),
      ),
    );
  }

  void _showVoiceRecorder(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: VoiceTaskRecorder(
          onTaskCreated: (result) {
            Navigator.of(context).pop();
            _showConfirmationDialog(context, result);
          },
          onCancelled: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, VoiceTaskResult result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VoiceTaskConfirmation(
        result: result,
        onCancelled: () {
          Navigator.of(context).pop();
        },
        onCompleted: () {
          Navigator.of(context).pop();
          _showSuccessMessage(context);
        },
      ),
    );
  }

  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voice task created successfully!'), backgroundColor: Colors.green, duration: Duration(seconds: 2)));
  }
}
