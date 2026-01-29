import 'package:flutter/material.dart';
import '../../ui/themes/design_system.dart';

/// Voice Task Tutorial Widget
class VoiceTaskTutorial extends StatefulWidget {
  final VoidCallback? onCompleted;
  final VoidCallback? onSkipped;

  const VoiceTaskTutorial({super.key, this.onCompleted, this.onSkipped});

  @override
  State<VoiceTaskTutorial> createState() => _VoiceTaskTutorialState();
}

class _VoiceTaskTutorialState extends State<VoiceTaskTutorial> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentStep = 0;
  final List<TutorialStep> _steps = [
    TutorialStep(title: 'Welcome to Voice Tasks!', description: 'Create tasks naturally with your voice in seconds.', icon: Icons.mic, color: Colors.blue),
    TutorialStep(title: 'Simply Speak', description: 'Say things like "Remind me to call the doctor tomorrow morning"', icon: Icons.record_voice_over, color: Colors.green),
    TutorialStep(title: 'Smart Understanding', description: 'I\'ll automatically detect dates, priorities, and categories.', icon: Icons.psychology, color: Colors.purple),
    TutorialStep(title: 'Multi-Language Support', description: 'Works in both English and Arabic with smart parsing.', icon: Icons.translate, color: Colors.orange),
    TutorialStep(title: 'Ready to Try?', description: 'Tap the microphone button and start creating tasks!', icon: Icons.play_arrow, color: Colors.red),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimation();
  }

  void _initializeAnimations() {
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  void _startAnimation() {
    _controller.forward();
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      _controller.reset();
      _startAnimation();
    } else {
      _completeTutorial();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _controller.reset();
      _startAnimation();
    }
  }

  void _completeTutorial() {
    widget.onCompleted?.call();
  }

  void _skipTutorial() {
    widget.onSkipped?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.surfaceVariant.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress indicator
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(value: (_currentStep + 1) / _steps.length, backgroundColor: Theme.of(context).colorScheme.surfaceVariant, valueColor: AlwaysStoppedAnimation<Color>(step.color)),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text('${_currentStep + 1}/${_steps.length}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Step content
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: step.color.withValues(alpha: 0.1)),
                    child: Icon(step.icon, color: step.color, size: 40),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Title
                  Text(
                    step.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Description
                  Text(
                    step.description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Navigation buttons
          Row(
            children: [
              // Previous button
              if (_currentStep > 0)
                Expanded(
                  child: OutlinedButton(onPressed: _previousStep, child: const Text('Previous')),
                )
              else
                const Expanded(child: SizedBox()),

              const SizedBox(width: AppSpacing.md),

              // Skip button
              if (_currentStep < _steps.length - 1) TextButton(onPressed: _skipTutorial, child: const Text('Skip')) else const SizedBox(width: 60),

              const SizedBox(width: AppSpacing.md),

              // Next/Complete button
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(backgroundColor: step.color, foregroundColor: Colors.white),
                  child: Text(_currentStep == _steps.length - 1 ? 'Complete' : 'Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TutorialStep {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const TutorialStep({required this.title, required this.description, required this.icon, required this.color});
}

/// Voice Task Quick Tips Widget
class VoiceTaskQuickTips extends StatelessWidget {
  const VoiceTaskQuickTips({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = ['Say "tomorrow morning" for 9 AM', 'Add "urgent" or "مهم" for high priority', 'Mention "call" for phone tasks', 'Use "buy" for shopping lists', 'Works in English and Arabic'];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Theme.of(context).colorScheme.primary, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text('Quick Tips:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(tip, style: Theme.of(context).textTheme.bodySmall)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
