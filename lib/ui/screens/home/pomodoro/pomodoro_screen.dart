import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import '../../../../models/task.dart';
import '../../../../services/pomodoro_service.dart';

class PomodoroScreen extends StatefulWidget {
  final Task? initialTask;
  final List<Task>? taskQueue;

  const PomodoroScreen({super.key, this.initialTask, this.taskQueue});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> with TickerProviderStateMixin {
  // ====================================================================
  // CORE UI LOGIC CONCEPTS - Clean Architecture
  // ====================================================================

  // 1. STATE-DRIVEN UI ARCHITECTURE
  final _uiState = PomodoroUiState();

  // 2. MULTI-CONTROLLER ANIMATION SYSTEM
  late final _animationSystem = PomodoroAnimationSystem(this);

  // 3. LAYERED STACK ARCHITECTURE
  final _layerManager = PomodoroLayerManager();

  // 4. CONTEXT-AWARE DYNAMIC BACKGROUNDS
  final _backgroundSystem = PomodoroBackgroundSystem();

  // 5. CONDITIONAL VIEW RENDERING
  final _viewController = PomodoroViewController();

  // 6. PROVIDER PATTERN INTEGRATION
  // late final _stateManager = PomodoroStateManager();

  // 7. SAFE ASYNC INITIALIZATION
  final _initializer = PomodoroInitializer();

  // 8. POST-FRAME CALLBACK PATTERN
  // final _safeUpdater = PomodoroSafeUpdater();

  // 9. MODULAR WIDGET BUILDING
  final _widgetFactory = PomodoroWidgetFactory();

  // 10. ENHANCED VISUAL EFFECTS SYSTEM
  final _effectsSystem = PomodoroEffectsSystem();

  // 11. RESPONSIVE LAYOUT STRATEGY
  final _layoutSystem = PomodoroLayoutSystem();

  // 12. THEME INTEGRATION
  final _themeSystem = PomodoroThemeSystem();

  // 13. DYNAMIC TIME ADJUSTMENT
  late PomodoroTimeAdjustment _timeAdjustment;

  // 14. CONTEXTUAL QUICK ACTIONS
  late PomodoroQuickActions _quickActions;

  // ====================================================================
  // CORE TIMER MANAGEMENT
  // ====================================================================
  late PomodoroTimer _timer;

  // ====================================================================
  // SESSION CUSTOMIZATION (Available for future use)
  // ====================================================================
  // int _workDuration = 25;
  // int _breakDuration = 5;
  // int _longBreakDuration = 15;
  // int _sessionsBeforeLongBreak = 4;
  // late List<PomodoroTemplate> _templates;

  // ====================================================================
  // TASK QUEUE MANAGEMENT (Available for future use)
  // ====================================================================
  // List<Task> _currentTaskQueue = [];
  // Task? _currentTask;
  // PomodoroPlan? _currentPlan;

  // ====================================================================
  // INITIALIZATION
  // ====================================================================
  @override
  void initState() {
    super.initState();

    // Initialize timer
    _initializeTimer();

    // Initialize UI systems with context
    _timeAdjustment = PomodoroTimeAdjustment(context: context);
    _quickActions = PomodoroQuickActions(context: context);

    // Initialize UI systems
    _initializer.initializeAll(onInitialized: () => setState(() {}), animationSystem: _animationSystem, effectsSystem: _effectsSystem);

    // Setup timer listeners
    _setupTimerListeners();

    // Update UI state
    _updateUIState(context);
  }

  void _initializeTimer() {
    _timer = PomodoroTimer(session: const PomodoroSession(workDuration: 25, shortBreakDuration: 5, longBreakDuration: 15, sessionsUntilLongBreak: 4));

    // Set initial task if provided
    if (widget.initialTask != null) {
      _timer.setSelectedTask(widget.initialTask);
      _uiState.setTaskName(widget.initialTask?.title ?? 'Unknown Task');
    }
  }

  void _setupTimerListeners() {
    _timer.addListener(() {
      if (mounted) {
        setState(() {
          _updateUIState(context);
        });
      }
    });
  }

  void _updateUIState(BuildContext context) {
    _uiState.updateTheme(context);

    // Update completion percentage
    final totalSeconds = _getTotalSecondsForState(_timer.effectiveState);
    final completedSeconds = totalSeconds - _timer.remainingSeconds;
    _uiState.updateCompletion(completedSeconds / totalSeconds);
  }

  int _getTotalSecondsForState(PomodoroState state) {
    switch (state) {
      case PomodoroState.work:
        return 25 * 60; // 25 minutes
      case PomodoroState.shortBreak:
        return 5 * 60; // 5 minutes
      case PomodoroState.longBreak:
        return 15 * 60; // 15 minutes
      default:
        return 25 * 60;
    }
  }

  @override
  void dispose() {
    _timer.dispose();
    _animationSystem.dispose();
    _effectsSystem.dispose();
    super.dispose();
  }

  // ====================================================================
  // MAIN BUILD METHOD - Clean Architecture
  // ====================================================================
  @override
  Widget build(BuildContext context) {
    // 7. SAFE ASYNC INITIALIZATION
    if (!_initializer.isReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 6. PROVIDER PATTERN INTEGRATION
    return ChangeNotifierProvider.value(
      value: _timer,
      child: Scaffold(
        body: _layerManager.buildStack(
          children: [
            // 4. CONTEXT-AWARE DYNAMIC BACKGROUNDS
            _backgroundSystem.buildBackground(context, _timer),

            // 5. CONDITIONAL VIEW RENDERING
            Consumer<PomodoroTimer>(
              builder: (context, timer, child) => _viewController.buildCurrentView(
                context: context,
                timer: timer,
                widgetFactory: _widgetFactory,
                layoutSystem: _layoutSystem,
                themeSystem: _themeSystem,
                timeAdjustment: _timeAdjustment,
                quickActions: _quickActions,
                uiState: _uiState,
              ),
            ),

            // 3. LAYERED STACK ARCHITECTURE - Floating Elements
            ..._layerManager.buildFloatingLayers(context: context, timer: _timer, timeAdjustment: _timeAdjustment, quickActions: _quickActions, effectsSystem: _effectsSystem),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// UI LOGIC CONCEPT 1: STATE-DRIVEN UI ARCHITECTURE
// ====================================================================
class PomodoroUiState {
  bool showCustomization = true;
  int selectedTemplateIndex = 0;
  bool isDarkMode = false;
  String currentTaskName = '';
  double completionPercentage = 0.0;
  bool showQuickControls = true;
  int quickAdjustAmount = 5;

  final List<String> motivationalQuotes = [
    "Focus on progress, not perfection",
    "Every moment is a fresh beginning",
    "Small steps daily lead to big changes",
    "Your only limit is your mind",
    "Success is the sum of small efforts",
    "Stay focused, stay brilliant",
    "One session at a time",
    "Your future self will thank you",
  ];

  void updateTheme(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
  }

  void setTaskName(String name) {
    currentTaskName = name;
  }

  void updateCompletion(double percentage) {
    completionPercentage = percentage;
  }
}

// ====================================================================
// UI LOGIC CONCEPT 2: MULTI-CONTROLLER ANIMATION SYSTEM
// ====================================================================
class PomodoroAnimationSystem {
  late final AnimationController mainController;
  late final AnimationController pulseController;
  late final AnimationController slideController;
  late final AnimationController fadeController;

  final TickerProvider vsync;

  PomodoroAnimationSystem(this.vsync) {
    mainController = AnimationController(duration: const Duration(milliseconds: 300), vsync: vsync);
    pulseController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: vsync);
    slideController = AnimationController(duration: const Duration(milliseconds: 600), vsync: vsync);
    fadeController = AnimationController(duration: const Duration(milliseconds: 800), vsync: vsync);
  }

  void startEntranceAnimations() {
    Future.delayed(const Duration(milliseconds: 100), () {
      slideController.forward();
      fadeController.forward();
    });
  }

  void dispose() {
    mainController.dispose();
    pulseController.dispose();
    slideController.dispose();
    fadeController.dispose();
  }
}

// ====================================================================
// UI LOGIC CONCEPT 3: LAYERED STACK ARCHITECTURE
// ====================================================================
class PomodoroLayerManager {
  Widget buildStack({required List<Widget> children}) {
    return Stack(children: children);
  }

  List<Widget> buildFloatingLayers({
    required BuildContext context,
    required PomodoroTimer timer,
    required PomodoroTimeAdjustment timeAdjustment,
    required PomodoroQuickActions quickActions,
    required PomodoroEffectsSystem effectsSystem,
  }) {
    return [
      // Floating Controls Layer
      _buildFloatingControls(context, timer, timeAdjustment),

      // Motivational Quote Layer
      _buildMotivationalQuote(context, timer),

      // Effects Layer (Confetti)
      effectsSystem.buildConfettiOverlay(),
    ];
  }

  Widget _buildFloatingControls(BuildContext context, PomodoroTimer timer, PomodoroTimeAdjustment timeAdjustment) {
    return Positioned(top: 20, right: 20, child: _buildFloatingControlPanel(context, timer, timeAdjustment));
  }

  Widget _buildFloatingControlPanel(BuildContext context, PomodoroTimer timer, PomodoroTimeAdjustment timeAdjustment) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [_buildTimeAdjustButtons(context, timer, timeAdjustment), const SizedBox(height: 8), _buildTimerControlButtons(context, timer, timeAdjustment)]),
    );
  }

  Widget _buildTimeAdjustButtons(BuildContext context, PomodoroTimer timer, PomodoroTimeAdjustment timeAdjustment) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFloatingButton(context: context, icon: Icons.add, label: '+5m', color: Theme.of(context).colorScheme.primary, onTap: () => timeAdjustment.addTime(timer, 5)),
        const SizedBox(height: 4),
        _buildFloatingButton(context: context, icon: Icons.remove, label: '-5m', color: Theme.of(context).colorScheme.error, onTap: () => timeAdjustment.addTime(timer, -5)),
      ],
    );
  }

  Widget _buildTimerControlButtons(BuildContext context, PomodoroTimer timer, PomodoroTimeAdjustment timeAdjustment) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(height: 1, color: Theme.of(context).colorScheme.outline.withOpacity(0.3), margin: const EdgeInsets.symmetric(horizontal: 8)),
        const SizedBox(height: 8),
        _buildFloatingButton(
          context: context,
          icon: timer.isPaused ? Icons.play_arrow : Icons.pause,
          label: timer.isPaused ? 'Play' : 'Pause',
          color: Theme.of(context).colorScheme.primary,
          onTap: timer.isPaused ? timer.start : timer.pause,
        ),
        const SizedBox(height: 4),
        _buildFloatingButton(context: context, icon: Icons.stop, label: 'Stop', color: Theme.of(context).colorScheme.error, onTap: () => timeAdjustment.stopTimer(timer)),
      ],
    );
  }

  Widget _buildFloatingButton({required BuildContext context, required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalQuote(BuildContext context, PomodoroTimer timer) {
    if (timer.state == PomodoroState.idle) return const SizedBox.shrink();

    final quotes = [
      "Focus on progress, not perfection",
      "Every moment is a fresh beginning",
      "Small steps daily lead to big changes",
      "Your only limit is your mind",
      "Success is the sum of small efforts",
      "Stay focused, stay brilliant",
      "One session at a time",
      "Your future self will thank you",
    ];

    final quoteIndex = (timer.currentSession - 1) % quotes.length;
    final quote = quotes[quoteIndex];

    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Theme.of(context).colorScheme.surface.withOpacity(0.9), Theme.of(context).colorScheme.surface.withOpacity(0.7)]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.format_quote, color: Theme.of(context).colorScheme.primary, size: 20),
            const SizedBox(height: 8),
            Text(
              quote,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// UI LOGIC CONCEPT 4: CONTEXT-AWARE DYNAMIC BACKGROUNDS
// ====================================================================
class PomodoroBackgroundSystem {
  Widget buildBackground(BuildContext context, PomodoroTimer timer) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: _getBackgroundColors(timer.effectiveState, context)),
      ),
    );
  }

  List<Color> _getBackgroundColors(PomodoroState state, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (state) {
      case PomodoroState.work:
        return isDark
            ? [const Color(0xFFE63946).withOpacity(0.8), const Color(0xFFD62828).withOpacity(0.9), const Color(0xFFA61E4D).withOpacity(0.95)]
            : [const Color(0xFFFF6B6B), const Color(0xFFE63946), const Color(0xFFD62828)];

      case PomodoroState.shortBreak:
        return isDark
            ? [const Color(0xFF2A9D8F).withOpacity(0.8), const Color(0xFF264653).withOpacity(0.9), const Color(0xFF1B5E3F).withOpacity(0.95)]
            : [const Color(0xFF52B788), const Color(0xFF2A9D8F), const Color(0xFF40916C)];

      case PomodoroState.longBreak:
        return isDark
            ? [const Color(0xFF457B9D).withOpacity(0.8), const Color(0xFF1D3557).withOpacity(0.9), const Color(0xFF1A237E).withOpacity(0.95)]
            : [const Color(0xFF90E0EF), const Color(0xFF48CAE4), const Color(0xFF00B4D8)];

      case PomodoroState.idle:
        return isDark
            ? [const Color(0xFF2D3436).withOpacity(0.9), const Color(0xFF636E72).withOpacity(0.85), const Color(0xFFB2BEC3).withOpacity(0.8)]
            : [const Color(0xFFDFE6E9), const Color(0xFFB2BEC3), const Color(0xFF74B9FF)];

      default:
        return isDark
            ? [const Color(0xFF6C5CE7).withOpacity(0.8), const Color(0xFFA29BFE).withOpacity(0.85), const Color(0xFFFD79A8).withOpacity(0.9)]
            : [const Color(0xFF667EEA), const Color(0xFF764BA2), const Color(0xFFF093FB)];
    }
  }
}

// ====================================================================
// UI LOGIC CONCEPT 5: CONDITIONAL VIEW RENDERING
// ====================================================================
class PomodoroViewController {
  Widget buildCurrentView({
    required BuildContext context,
    required PomodoroTimer timer,
    required PomodoroWidgetFactory widgetFactory,
    required PomodoroLayoutSystem layoutSystem,
    required PomodoroThemeSystem themeSystem,
    required PomodoroTimeAdjustment timeAdjustment,
    required PomodoroQuickActions quickActions,
    required PomodoroUiState uiState,
  }) {
    return SafeArea(
      child: uiState.showCustomization
          ? widgetFactory.buildTaskSelectionView(context: context, timer: timer, layoutSystem: layoutSystem, themeSystem: themeSystem)
          : widgetFactory.buildTimerView(context: context, timer: timer, layoutSystem: layoutSystem, themeSystem: themeSystem, timeAdjustment: timeAdjustment, quickActions: quickActions),
    );
  }
}

// ====================================================================
// UI LOGIC CONCEPT 9: MODULAR WIDGET BUILDING
// ====================================================================
class PomodoroWidgetFactory {
  Widget buildTaskSelectionView({required BuildContext context, required PomodoroTimer timer, required PomodoroLayoutSystem layoutSystem, required PomodoroThemeSystem themeSystem}) {
    return layoutSystem.buildResponsiveLayout(context: context, children: [themeSystem.buildModernHeader(context, 'Select Timer'), const SizedBox(height: 20), _buildTemplateGrid(context, timer)]);
  }

  Widget buildTimerView({
    required BuildContext context,
    required PomodoroTimer timer,
    required PomodoroLayoutSystem layoutSystem,
    required PomodoroThemeSystem themeSystem,
    required PomodoroTimeAdjustment timeAdjustment,
    required PomodoroQuickActions quickActions,
  }) {
    return layoutSystem.buildResponsiveLayout(
      context: context,
      children: [
        // Timer Display Section
        Expanded(flex: 3, child: _buildTimerDisplay(context, timer)),

        // Controls Section
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [themeSystem.buildModernControls(context, timer), const SizedBox(height: 16), quickActions.buildQuickActions(context, timer, timeAdjustment)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerDisplay(BuildContext context, PomodoroTimer timer) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [_buildAnimatedStateLabel(context, timer), const SizedBox(height: 30), _buildModernCircularTimer(context, timer), const SizedBox(height: 20), _buildSessionProgress(context, timer)],
        ),
      ),
    );
  }

  Widget _buildAnimatedStateLabel(BuildContext context, PomodoroTimer timer) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(
        _getLocalizedLabel(timer.effectiveState, timer.isPaused, context),
        key: ValueKey(timer.effectiveState.toString() + timer.isPaused.toString()),
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildModernCircularTimer(BuildContext context, PomodoroTimer timer) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Theme.of(context).colorScheme.surface.withOpacity(0.1), Theme.of(context).colorScheme.surface.withOpacity(0.05)]),
        boxShadow: [BoxShadow(color: _getGaugeColor(timer.effectiveState, context).withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 10))],
      ),
      child: Stack(children: [_buildBackgroundRing(context), _buildProgressGauge(context, timer), _buildTimerText(context, timer)]),
    );
  }

  Widget _buildBackgroundRing(BuildContext context) {
    return Positioned.fill(
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1), width: 8),
        ),
      ),
    );
  }

  Widget _buildProgressGauge(BuildContext context, PomodoroTimer timer) {
    return Positioned.fill(
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: _getTotalSecondsForState(timer.effectiveState).toDouble(),
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            axisLineStyle: AxisLineStyle(thickness: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1), cornerStyle: CornerStyle.bothCurve),
            pointers: <GaugePointer>[
              RangePointer(
                value: timer.remainingSeconds.toDouble(),
                width: 12,
                color: _getGaugeColor(timer.effectiveState, context),
                cornerStyle: CornerStyle.bothCurve,
                gradient: SweepGradient(colors: [_getGaugeColor(timer.effectiveState, context), _getGaugeColor(timer.effectiveState, context).withOpacity(0.6)], stops: const [0.0, 1.0]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimerText(BuildContext context, PomodoroTimer timer) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatDuration(timer.remainingSeconds),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 36, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text('Session ${timer.currentSession}/4', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
        ],
      ),
    );
  }

  Widget _buildSessionProgress(BuildContext context, PomodoroTimer timer) {
    final totalSessions = 4;
    final completedSessions = timer.currentSession - 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Session Progress', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              totalSessions,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: 16,
                  height: 8,
                  decoration: BoxDecoration(color: index < completedSessions ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline.withOpacity(0.3), borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateGrid(BuildContext context, PomodoroTimer timer) {
    final templates = [
      PomodoroTemplate(
        id: 'classic',
        name: 'Classic Pomodoro',
        workDuration: 25,
        shortBreakDuration: 5,
        longBreakDuration: 15,
        sessionsUntilLongBreak: 4,
        isRecommended: true,
        description: 'Traditional 25-5-15 minute cycle',
      ),
      PomodoroTemplate(id: 'short', name: 'Short Sessions', workDuration: 15, shortBreakDuration: 3, longBreakDuration: 10, sessionsUntilLongBreak: 4, isRecommended: false, description: 'Quick 15-3-10 minute cycles'),
      PomodoroTemplate(id: 'long', name: 'Deep Work', workDuration: 50, shortBreakDuration: 10, longBreakDuration: 30, sessionsUntilLongBreak: 2, isRecommended: false, description: 'Extended 50-10-30 minute sessions'),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Choose Your Timer Style',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 16, mainAxisSpacing: 16),
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                return _buildTemplateCard(context, template, timer);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(BuildContext context, PomodoroTemplate template, PomodoroTimer timer) {
    return GestureDetector(
      onTap: () => _startTemplate(template, timer),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: template.isRecommended
                ? [Theme.of(context).colorScheme.primary.withOpacity(0.1), Theme.of(context).colorScheme.primary.withOpacity(0.05)]
                : [Theme.of(context).colorScheme.surface.withOpacity(0.5), Theme.of(context).colorScheme.surface.withOpacity(0.3)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: template.isRecommended ? Theme.of(context).colorScheme.primary.withOpacity(0.3) : Theme.of(context).colorScheme.outline.withOpacity(0.2), width: template.isRecommended ? 2 : 1),
          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (template.isRecommended)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  'RECOMMENDED',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              template.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: 4),
            Text(template.description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
            const Spacer(),
            Row(children: [_buildDurationChip(context, '${template.workDuration}m', 'Work'), const SizedBox(width: 4), _buildDurationChip(context, '${template.shortBreakDuration}m', 'Break')]),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationChip(BuildContext context, String duration, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(
        duration,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 10),
  void _startTemplate(PomodoroTemplate template, PomodoroTimer timer) {
    HapticFeedback.mediumImpact();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Started ${template.name} template'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
    
    timer.start();
    
    _uiState.showCustomization = false;
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _getLocalizedLabel(PomodoroState state, bool isPaused, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (state) {
      case PomodoroState.work:
        return isPaused ? 'Work (Paused)' : l10n.work;
      case PomodoroState.shortBreak:
        return isPaused ? 'Short Break (Paused)' : l10n.shortBreak;
      case PomodoroState.longBreak:
        return isPaused ? 'Long Break (Paused)' : l10n.longBreak;
      default:
        return 'Ready';
    }
  }

  Color _getGaugeColor(PomodoroState state, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (state) {
      case PomodoroState.work:
        return isDark ? Colors.red.shade300 : Colors.red.shade600;
      case PomodoroState.shortBreak:
        return isDark ? Colors.green.shade300 : Colors.green.shade600;
      case PomodoroState.longBreak:
        return isDark ? Colors.blue.shade300 : Colors.blue.shade600;
      default:
        return isDark ? theme.colorScheme.onSurface.withOpacity(0.6) : Colors.grey.shade600;
    }
  }

  int _getTotalSecondsForState(PomodoroState state) {
    switch (state) {
      case PomodoroState.work:
        return 25 * 60; // 25 minutes
      case PomodoroState.shortBreak:
        return 5 * 60; // 5 minutes
      case PomodoroState.longBreak:
        return 15 * 60; // 15 minutes
      default:
        return 25 * 60;
    }
  }
}

// ====================================================================
// UI LOGIC CONCEPT 11: RESPONSIVE LAYOUT STRATEGY
// ====================================================================
class PomodoroLayoutSystem {
  Widget buildResponsiveLayout({required BuildContext context, required List<Widget> children}) {
    return Column(children: children);
  }
}

// ====================================================================
// UI LOGIC CONCEPT 12: THEME INTEGRATION
// ====================================================================
class PomodoroThemeSystem {
  Widget buildModernHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }

  Widget buildModernControls(BuildContext context, PomodoroTimer timer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(context: context, icon: timer.isPaused ? Icons.play_arrow : Icons.pause, onTap: timer.isPaused ? timer.start : timer.pause, color: Theme.of(context).colorScheme.primary),
          _buildControlButton(context: context, icon: Icons.skip_next, onTap: timer.skip, color: Theme.of(context).colorScheme.secondary),
          _buildControlButton(context: context, icon: Icons.stop, onTap: timer.stop, color: Theme.of(context).colorScheme.error),
        ],
      ),
    );
  }

  Widget _buildControlButton({required BuildContext context, required IconData icon, required VoidCallback onTap, required Color color}) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 28),
        onPressed: onTap,
      ),
    );
  }
}

// ====================================================================
// UI LOGIC CONCEPT 13: DYNAMIC TIME ADJUSTMENT
// ====================================================================
class PomodoroTimeAdjustment {
  final BuildContext? context;

  PomodoroTimeAdjustment({this.context});

  void addTime(PomodoroTimer timer, int minutes) {
    if (timer.state == PomodoroState.idle) return;

    timer.addTime(minutes);
    HapticFeedback.lightImpact();
    _showFeedbackMessage('$minutes minutes ${minutes > 0 ? "added" : "removed"}');
  }

  void stopTimer(PomodoroTimer timer) {
    if (timer.state != PomodoroState.idle) {
      timer.stop();
      _showFeedbackMessage('Timer stopped');
    }
  }

  void _showFeedbackMessage(String message) {
    if (context != null) {
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2), behavior: SnackBarBehavior.floating));
    }
  }
}

// ====================================================================
// UI LOGIC CONCEPT 14: CONTEXTUAL QUICK ACTIONS
// ====================================================================
class PomodoroQuickActions {
  final BuildContext? context;

  PomodoroQuickActions({this.context});

  Widget buildQuickActions(BuildContext context, PomodoroTimer timer, PomodoroTimeAdjustment timeAdjustment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildTimeAdjustmentRow(context, timer, timeAdjustment),
          const SizedBox(height: 12),
          Container(height: 1, color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
          const SizedBox(height: 12),
          _buildQuickActionRow(context, timer),
        ],
      ),
    );
  }

  Widget _buildTimeAdjustmentRow(BuildContext context, PomodoroTimer timer, PomodoroTimeAdjustment timeAdjustment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTimeAdjustButton(context: context, icon: Icons.remove_circle_outline, label: '-5 min', onTap: () => timeAdjustment.addTime(timer, -5), color: Theme.of(context).colorScheme.error),
        _buildTimeAdjustButton(context: context, icon: Icons.add_circle_outline, label: '+5 min', onTap: () => timeAdjustment.addTime(timer, 5), color: Theme.of(context).colorScheme.primary),
      ],
    );
  }

  Widget _buildQuickActionRow(BuildContext context, PomodoroTimer timer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickActionButton(
          context: context,
          icon: Icons.coffee,
          label: 'Break',
          onTap: () {
            if (timer.state != PomodoroState.idle) {
              timer.skip();
              _showFeedbackMessage('Skipping to break');
            }
          },
        ),
        _buildQuickActionButton(
          context: context,
          icon: Icons.note_add,
          label: 'Note',
          onTap: () {
            _showFeedbackMessage('Quick note feature coming soon!');
          },
        ),
        _buildQuickActionButton(
          context: context,
          icon: Icons.refresh,
          label: 'Reset',
          onTap: () {
            if (timer.state != PomodoroState.idle) {
              timer.stop();
              _showFeedbackMessage('Timer stopped');
            }
          },
        ),
      ],
    );
  }

  Widget _buildTimeAdjustButton({required BuildContext context, required IconData icon, required String label, required VoidCallback onTap, required Color color}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({required BuildContext context, required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
          ],
        ),
      ),
    );
  }

  void _showFeedbackMessage(String message) {
    if (context != null) {
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2), behavior: SnackBarBehavior.floating));
    }
  }
}

// ====================================================================
// SUPPORTING SYSTEMS
// ====================================================================

class PomodoroStateManager {
  void initialize() {
    // State management initialization
  }
}

class PomodoroInitializer {
  bool _isReady = false;

  bool get isReady => _isReady;

  void initializeAll({required VoidCallback onInitialized, required PomodoroAnimationSystem animationSystem, required PomodoroEffectsSystem effectsSystem}) {
    // Initialize all systems
    animationSystem.startEntranceAnimations();
    effectsSystem.initialize();

    _isReady = true;
    onInitialized();
  }
}

class PomodoroSafeUpdater {
  void update(VoidCallback callback) {
    // Safe update implementation
  }
}

class PomodoroEffectsSystem {
  late final ConfettiController confettiController;
  late final FlutterTts flutterTts;

  void initialize() {
    confettiController = ConfettiController(duration: const Duration(seconds: 2));
    flutterTts = FlutterTts();

    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.0);
  }

  Widget buildConfettiOverlay() {
    return Positioned.fill(
      child: ConfettiWidget(
        confettiController: confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        particleDrag: 0.05,
        emissionFrequency: 0.05,
        numberOfParticles: 50,
        gravity: 0.1,
        shouldLoop: false,
        colors: const [Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.purple],
      ),
    );
  }

  void dispose() {
    confettiController.dispose();
  }
}

// ====================================================================
// TEMPLATE SYSTEM
// ====================================================================

class PomodoroTemplate {
  final String id;
  final String name;
  final String description;
  final int workDuration;
  final int shortBreakDuration;
  final int longBreakDuration;
  final int sessionsUntilLongBreak;
  final bool isRecommended;

  PomodoroTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.workDuration,
    required this.shortBreakDuration,
    required this.longBreakDuration,
    required this.sessionsUntilLongBreak,
    this.isRecommended = false,
  });
}
