import 'package:flutter/material.dart';
import '../../services/onboarding_service.dart';
import '../../l10n/app_localizations.dart';

/// Smart features tutorial screen
class SmartFeaturesTutorialScreen extends StatefulWidget {
  const SmartFeaturesTutorialScreen({super.key});

  @override
  State<SmartFeaturesTutorialScreen> createState() => _SmartFeaturesTutorialScreenState();
}

class _SmartFeaturesTutorialScreenState extends State<SmartFeaturesTutorialScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _highlightController;

  int _currentPage = 0;
  bool _isAnimating = false;

  List<TutorialStep> get _steps => [
    TutorialStep(
      title: AppLocalizations.of(context)!.adaptivePomodoro,
      description: AppLocalizations.of(context)!.adaptivePomodoroDescription,
      icon: Icons.psychology,
      highlights: [
        AppLocalizations.of(context)!.sessionTimingAdjustsBasedOnYourFocusPatterns,
        AppLocalizations.of(context)!.breakSuggestionsMatchYourCurrentEnergyLevel,
        AppLocalizations.of(context)!.productivityInsightsHelpYouOptimizeWorkSessions,
        AppLocalizations.of(context)!.achievementSystemKeepsYouMotivated,
      ],
      action: AppLocalizations.of(context)!.startAPomodoroSessionToSeeAdaptiveTiming,
    ),
    TutorialStep(
      title: AppLocalizations.of(context)!.energyAwarePlanning,
      description: AppLocalizations.of(context)!.energyAwarePlanningDescription,
      icon: Icons.timer,
      highlights: [
        AppLocalizations.of(context)!.morningPeakBestForComplexTasks,
        AppLocalizations.of(context)!.afternoonSteadyGoodForRoutineWork,
        AppLocalizations.of(context)!.eveningDeclineLightTasksAndPlanning,
        AppLocalizations.of(context)!.energyTrackingHelpsIdentifyYourPatterns,
      ],
      action: AppLocalizations.of(context)!.checkYourEnergyLevelsThroughoutTheDay,
    ),
    TutorialStep(
      title: AppLocalizations.of(context)!.analyticsDashboard,
      description: AppLocalizations.of(context)!.analyticsDashboardDescription,
      icon: Icons.bolt,
      highlights: [
        AppLocalizations.of(context)!.trackFocusPatternsAndSessionPerformance,
        AppLocalizations.of(context)!.identifyYourMostProductiveTimes,
        AppLocalizations.of(context)!.monitorMoodAndEnergyCorrelations,
        AppLocalizations.of(context)!.getPersonalizedProductivityTips,
      ],
      action: AppLocalizations.of(context)!.exploreYourAnalyticsDashboard,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _highlightController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _highlightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.smartFeaturesTutorial),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [IconButton(onPressed: _skipTutorial, icon: const Icon(Icons.close))],
      ),
      body: Column(
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
                  _highlightController.reset();
                  _highlightController.forward();
                });
              },
              itemCount: _steps.length,
              itemBuilder: (context, index) {
                return _buildTutorialPage(_steps[index]);
              },
            ),
          ),

          // Action buttons
          _buildActionButtons(),
        ],
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
                  animation: _highlightController,
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
          Text('Feature ${_currentPage + 1} of ${_steps.length}', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
        ],
      ),
    );
  }

  Widget _buildTutorialPage(TutorialStep step) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Icon and title
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
                            // Animated icon
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(24)),
                              child: AnimatedBuilder(
                                animation: _highlightController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: 1.0 + (_highlightController.value * 0.1),
                                    child: Icon(step.icon, size: 60, color: Theme.of(context).colorScheme.primary),
                                  );
                                },
                              ),
                            ),
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

  Widget _buildHighlightsList(List<String> highlights) {
    return Column(
      children: highlights.asMap().entries.map((entry) {
        final index = entry.key;
        final highlight = entry.value;

        return AnimatedBuilder(
          animation: _highlightController,
          builder: (context, child) {
            return SlideTransition(
              position: Tween<Offset>(begin: Offset(-0.3, 0), end: Offset.zero).animate(
                CurvedAnimation(
                  parent: _highlightController,
                  curve: Interval(index * 0.2, (index + 1) * 0.2, curve: Curves.easeOutCubic),
                ),
              ),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _highlightController,
                    curve: Interval(index * 0.2, (index + 1) * 0.2, curve: Curves.easeOutCubic),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      AnimatedBuilder(
                        animation: _highlightController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 0.8 + (_highlightController.value * 0.2),
                            child: Icon(Icons.check_circle, size: 20, color: Colors.green),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(highlight, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    final step = _steps[_currentPage];
    final isLastPage = _currentPage == _steps.length - 1;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Action suggestion
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(step.action, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Navigation buttons
          Row(
            children: [
              // Previous button
              if (_currentPage > 0)
                Expanded(
                  child: OutlinedButton(onPressed: _previousPage, child: Text(AppLocalizations.of(context)!.previous)),
                ),
              if (_currentPage > 0) const SizedBox(width: 16),

              // Next/Complete button
              Expanded(
                flex: _currentPage > 0 ? 1 : 2,
                child: ElevatedButton(
                  onPressed: isLastPage ? _completeTutorial : _nextPage,
                  child: _isAnimating
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(isLastPage ? AppLocalizations.of(context)!.completeTutorial : AppLocalizations.of(context)!.next),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _nextPage() async {
    if (_isAnimating) return;

    setState(() => _isAnimating = true);
    await _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() => _isAnimating = false);
  }

  void _previousPage() async {
    if (_isAnimating) return;

    setState(() => _isAnimating = true);
    await _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() => _isAnimating = false);
  }

  void _skipTutorial() async {
    if (_isAnimating) return;

    setState(() => _isAnimating = true);
    await _pageController.animateToPage(_steps.length - 1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    setState(() => _isAnimating = false);
  }

  void _completeTutorial() async {
    if (_isAnimating) return;

    setState(() => _isAnimating = true);

    try {
      // Mark tutorial as completed
      await OnboardingService().completeTutorial();

      // Show completion animation
      await _animationController.reverse();

      if (mounted) {
        // Navigate directly without post-frame callback
        Navigator.of(context).pop();

        // Show completion message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.tutorialCompletedYoureAllSetToUseSmartFeatures), backgroundColor: Colors.green, duration: const Duration(seconds: 3)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorCompletingTutorial), backgroundColor: Colors.red));
      }
    } finally {
      setState(() => _isAnimating = false);
    }
  }
}

/// Tutorial step data class
class TutorialStep {
  final String title;
  final String description;
  final IconData icon;
  final List<String> highlights;
  final String action;

  TutorialStep({required this.title, required this.description, required this.icon, required this.highlights, required this.action});
}
