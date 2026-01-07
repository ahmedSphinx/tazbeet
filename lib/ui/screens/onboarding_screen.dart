import 'package:flutter/material.dart';
import '../../services/app_logging_service.dart';
import '../../services/onboarding_service.dart';
import '../../services/accessibility_service.dart';
import 'home/main_screen.dart';
import '../../l10n/app_localizations.dart';

/// Interactive onboarding screen for first-time users
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _progressController;

  int _currentPage = 0;
  bool _isAnimating = false;

  final List<OnboardingStep> _steps = OnboardingSteps.steps;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _progressController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            _buildProgressBar(),

            // Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                    _progressController.reset();
                    _progressController.forward();
                  });
                },
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_steps[index]);
                },
              ),
            ),

            // Navigation buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: List.generate(
              _steps.length,
              (index) => Expanded(
                child: AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 4,
                      decoration: BoxDecoration(color: index <= _currentPage ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(2)),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('Step ${_currentPage + 1} of ${_steps.length}', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingStep step) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Title and description
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic)),
                      child: FadeTransition(
                        opacity: _animationController,
                        child: Column(
                          children: [
                            // Icon or illustration
                            _buildIllustration(step),
                            const SizedBox(height: 24),

                            // Title
                            Text(
                              step.title,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),

                            // Description
                            Text(
                              step.description,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8)),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Highlights
          Expanded(
            flex: 1,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic)),
                  child: FadeTransition(opacity: _animationController, child: _buildHighlightsList(step.highlights)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration(OnboardingStep step) {
    // Try to use Lottie animation if available, otherwise use icon
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(24)),
      child: step.customContent ?? _buildDefaultIllustration(step),
    );
  }

  Widget _buildDefaultIllustration(OnboardingStep step) {
    IconData icon;
    switch (step.title.toLowerCase()) {
      case 'welcome to tazbeet':
        icon = Icons.psychology;
        break;
      case 'smart task sorting':
        icon = Icons.sort;
        break;
      case 'pomodoro integration':
        icon = Icons.timer;
        break;
      case 'mood & energy tracking':
        icon = Icons.mood;
        break;
      case 'accessibility features':
        icon = Icons.accessibility;
        break;
      default:
        icon = Icons.lightbulb;
    }

    return Icon(icon, size: 80, color: Theme.of(context).colorScheme.primary);
  }

  Widget _buildHighlightsList(List<String> highlights) {
    return Column(
      children: highlights
          .map(
            (highlight) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 20, color: Colors.green),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(highlight, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Skip button
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(onPressed: _skipOnboarding, child: Text(AppLocalizations.of(context)!.skip)),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),

          // Next/Get Started button
          Expanded(
            flex: _currentPage > 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: _isLastPage ? _completeOnboarding : _nextPage,
              child: _isAnimating
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Text(_isLastPage ? AppLocalizations.of(context)!.getStarted : AppLocalizations.of(context)!.next), const SizedBox(width: 8), Icon(_isLastPage ? Icons.check_circle : Icons.arrow_forward)],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bool get _isLastPage => _currentPage == _steps.length - 1;

  void _nextPage() async {
    if (_isAnimating) return;

    setState(() => _isAnimating = true);
    await _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() => _isAnimating = false);
  }

  void _skipOnboarding() async {
    if (_isAnimating) return;

    setState(() => _isAnimating = true);
    await _pageController.animateToPage(_steps.length - 1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    setState(() => _isAnimating = false);
  }

  void _completeOnboarding() async {
    if (_isAnimating) return;

    setState(() => _isAnimating = true);

    try {
      // Mark onboarding as complete
      await OnboardingService().completeOnboarding();

      if (mounted) {
        // Navigate directly without post-frame callback
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
      }
    } catch (e) {
      AppLogging.logError('Error completing onboarding: $e', name: 'OnboardingScreen');
      if (mounted) {
        setState(() => _isAnimating = false);
        // Show error message but still try to navigate
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorCompletingOnboarding), backgroundColor: Colors.orange));
        // Fallback navigation - try direct navigation
        try {
          if (mounted) {
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
          }
        } catch (navError) {
          AppLogging.logError('Navigation error: $navError', name: 'OnboardingScreen');
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isAnimating = false);
      }
    }
  }
}

/// Enhanced onboarding screen with accessibility setup
class AccessibilityOnboardingScreen extends StatefulWidget {
  const AccessibilityOnboardingScreen({super.key});

  @override
  State<AccessibilityOnboardingScreen> createState() => _AccessibilityOnboardingScreenState();
}

class _AccessibilityOnboardingScreenState extends State<AccessibilityOnboardingScreen> {
  bool _highContrast = false;
  bool _largeText = false;
  bool _reducedMotion = false;
  bool _voiceCommands = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.accessibilitySetup), backgroundColor: Theme.of(context).colorScheme.surface, elevation: 0),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.customizeYourExperience, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.adjustTheseSettingsToMakeTheAppWorkBetterForYou,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 32),

            // High Contrast
            _buildAccessibilityOption(
              AppLocalizations.of(context)!.highContrast,
              AppLocalizations.of(context)!.increaseColorContrastForBetterVisibility,
              Icons.contrast,
              _highContrast,
              (value) => setState(() => _highContrast = value),
            ),

            // Large Text
            _buildAccessibilityOption(AppLocalizations.of(context)!.largeText, AppLocalizations.of(context)!.makeTextLargerAndEasierToRead, Icons.text_fields, _largeText, (value) => setState(() => _largeText = value)),

            // Reduced Motion
            _buildAccessibilityOption(
              AppLocalizations.of(context)!.reducedMotion,
              AppLocalizations.of(context)!.minimizeAnimationsAndTransitions,
              Icons.motion_photos_pause,
              _reducedMotion,
              (value) => setState(() => _reducedMotion = value),
            ),

            // Voice Commands
            _buildAccessibilityOption(AppLocalizations.of(context)!.voiceCommands, AppLocalizations.of(context)!.controlTheAppWithYourVoice, Icons.mic, _voiceCommands, (value) => setState(() => _voiceCommands = value)),

            const SizedBox(height: 32),

            // Apply button
            ElevatedButton(onPressed: _applyAccessibilitySettings, child: Text(AppLocalizations.of(context)!.applySettings)),

            const SizedBox(height: 16),

            // Skip button
            OutlinedButton(onPressed: _skipAccessibilitySetup, child: Text(AppLocalizations.of(context)!.skipForNow)),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessibilityOption(String title, String description, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: ListTile(
          leading: Icon(icon, color: value ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
          title: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
          subtitle: Text(description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
          trailing: Switch(value: value, onChanged: onChanged),
        ),
      ),
    );
  }

  void _applyAccessibilitySettings() async {
    try {
      final accessibilityService = AccessibilityService();
      await accessibilityService.updateSettings(highContrastEnabled: _highContrast, largeTextEnabled: _largeText, reducedMotionEnabled: _reducedMotion, voiceCommandsEnabled: _voiceCommands);

      await OnboardingService().completeAccessibilitySetup();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.accessibilitySettingsAppliedSuccessfully), backgroundColor: Colors.green));
        // Navigate directly without post-frame callback
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error applying accessibility settings: $e'), backgroundColor: Colors.red));
      }
    }
  }

  void _skipAccessibilitySetup() async {
    try {
      await OnboardingService().completeAccessibilitySetup();
      if (mounted) {
        // Navigate directly without post-frame callback
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error skipping accessibility setup: $e'), backgroundColor: Colors.red));
      }
    }
  }
}
