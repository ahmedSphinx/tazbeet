import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import '../../../../models/task.dart';
import '../../../../services/pomodoro_service.dart';

class PomodoroScreenClean extends StatefulWidget {
  final Task? initialTask;
  final List<Task>? taskQueue;

  const PomodoroScreenClean({super.key, this.initialTask, this.taskQueue});

  @override
  State<PomodoroScreenClean> createState() => _PomodoroScreenCleanState();
}

class _PomodoroScreenCleanState extends State<PomodoroScreenClean> with TickerProviderStateMixin {
  // ====================================================================
  // UI STATE MANAGEMENT
  // ====================================================================
  final _uiState = PomodoroUIState();

  // ====================================================================
  // ANIMATION SYSTEM
  // ====================================================================
  late final _animationSystem = PomodoroAnimationSystem(vsync: this);

  // ====================================================================
  // CLEAN ARCHITECTURE COMPONENTS
  // ====================================================================
  final _initializer = PomodoroInitializer();
  final _widgetFactory = PomodoroWidgetFactory();
  final _effectsSystem = PomodoroEffectsSystem();
  final _layoutSystem = PomodoroLayoutSystem();
  final _themeSystem = PomodoroThemeSystem();
  late PomodoroTimeAdjustment _timeAdjustment;
  late PomodoroQuickActions _quickActions;

  // ====================================================================
  // CORE TIMER MANAGEMENT
  // ====================================================================
  late PomodoroTimer _timer;

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
  // MAIN BUILD METHOD
  // ====================================================================
  @override
  Widget build(BuildContext context) {
    if (!_initializer.isReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ChangeNotifierProvider<PomodoroTimer>.value(
      value: _timer,
      child: Scaffold(
        body: Stack(
          children: [
            // Dynamic background
            _themeSystem.buildBackground(context, _timer),

            // Main content
            SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _uiState.showCustomization ? _widgetFactory.buildTemplateView(context, _timer) : _widgetFactory.buildTimerView(context, _timer, _uiState),
              ),
            ),

            // Floating controls
            if (!_uiState.showCustomization) _widgetFactory.buildFloatingControls(context, _timer, _timeAdjustment),

            // Motivational quote
            _widgetFactory.buildMotivationalQuote(context, _timer),

            // Confetti overlay
            _effectsSystem.buildConfettiOverlay(),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// UI STATE MANAGEMENT
// ====================================================================
class PomodoroUIState {
  bool _isDarkMode = false;
  String _currentTaskName = '';
  double _completionPercentage = 0.0;
  bool showCustomization = false;

  bool get isDarkMode => _isDarkMode;
  String get currentTaskName => _currentTaskName;
  double get completionPercentage => _completionPercentage;

  void updateTheme(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
  }

  void setTaskName(String name) {
    _currentTaskName = name;
  }

  void updateCompletion(double percentage) {
    _completionPercentage = percentage.clamp(0.0, 1.0);
  }
}

// ====================================================================
// ANIMATION SYSTEM
// ====================================================================
class PomodoroAnimationSystem {
  late final AnimationController pulseController;
  late final AnimationController slideController;
  late final Animation<double> pulseAnimation;
  late final Animation<Offset> slideAnimation;

  PomodoroAnimationSystem({required TickerProvider vsync}) {
    pulseController = AnimationController(duration: const Duration(seconds: 2), vsync: vsync);
    slideController = AnimationController(duration: const Duration(milliseconds: 300), vsync: vsync);

    pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(CurvedAnimation(parent: pulseController, curve: Curves.easeInOut));

    slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(CurvedAnimation(parent: slideController, curve: Curves.easeOut));
  }

  void startPulse() {
    pulseController.repeat(reverse: true);
  }

  void stopPulse() {
    pulseController.stop();
  }

  void slideIn() {
    slideController.forward();
  }

  void dispose() {
    pulseController.dispose();
    slideController.dispose();
  }
}

// ====================================================================
// INITIALIZER
// ====================================================================
class PomodoroInitializer {
  bool _isReady = false;

  bool get isReady => _isReady;

  void initializeAll({required VoidCallback onInitialized, required PomodoroAnimationSystem animationSystem, required PomodoroEffectsSystem effectsSystem}) {
    animationSystem.startPulse();
    effectsSystem.initialize();
    _isReady = true;
    onInitialized();
  }
}

// ====================================================================
// WIDGET FACTORY
// ====================================================================
class PomodoroWidgetFactory {
  Widget buildTimerView(BuildContext context, PomodoroTimer timer, PomodoroUIState uiState) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [const SizedBox(height: 40), _buildTimerDisplay(context, timer, uiState), const SizedBox(height: 30), _buildTimerInfo(context, timer), const SizedBox(height: 40), _buildQuickActions(context, timer)],
        ),
      ),
    );
  }

  Widget buildTemplateView(BuildContext context, PomodoroTimer timer) {
    return _buildTemplateGrid(context, timer);
  }

  Widget buildFloatingControls(BuildContext context, PomodoroTimer timer, PomodoroTimeAdjustment timeAdjustment) {
    return Positioned(
      bottom: 30,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [_buildTimeAdjustButtons(context, timer, timeAdjustment), const SizedBox(height: 8), _buildTimerControlButtons(context, timer, timeAdjustment)]),
      ),
    );
  }

  Widget buildMotivationalQuote(BuildContext context, PomodoroTimer timer) {
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
      right: 100,
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

  Widget _buildTimerDisplay(BuildContext context, PomodoroTimer timer, PomodoroUIState uiState) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: _getBackgroundColors(timer.state, uiState.isDarkMode)),
        boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Stack(
        children: [
          Center(
            child: SfRadialGauge(
              axes: [
                RadialAxis(
                  startAngle: 270,
                  endAngle: 270,
                  minimum: 0,
                  maximum: 100,
                  showLabels: false,
                  showTicks: false,
                  axisLineStyle: const AxisLineStyle(thickness: 15, color: Colors.transparent),
                  pointers: [
                    RangePointer(
                      value: uiState.completionPercentage * 100,
                      width: 15,
                      color: _getGaugeColor(timer.state, uiState.isDarkMode),
                      cornerStyle: CornerStyle.bothCurve,
                      enableAnimation: true,
                      animationDuration: 500,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatDuration(timer.remainingSeconds),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(_getLocalizedLabel(timer.state, timer.isPaused, context), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerInfo(BuildContext context, PomodoroTimer timer) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Session', style: Theme.of(context).textTheme.titleMedium),
              Text('${timer.currentSession}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Task', style: Theme.of(context).textTheme.titleMedium),
              Expanded(
                child: Text(
                  'Current Task',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, PomodoroTimer timer) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickActionButton(context, Icons.skip_next, 'Skip', () => timer.skip()),
              _buildQuickActionButton(context, Icons.stop, 'Stop', () => timer.stop()),
              _buildQuickActionButton(context, Icons.note_add, 'Note', () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
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
          color: timer.isPaused ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
          onTap: () {
            if (timer.isPaused) {
              timer.start();
            } else {
              timer.pause();
            }
          },
        ),
      ],
    );
  }

  Widget _buildFloatingButton({required BuildContext context, required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
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
            Row(children: [_buildDurationChip(context, '${template.workDuration}m'), const SizedBox(width: 4), _buildDurationChip(context, '${template.shortBreakDuration}m')]),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationChip(BuildContext context, String duration) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(
        duration,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 10),
      ),
    );
  }

  void _startTemplate(PomodoroTemplate template, PomodoroTimer timer) {
    HapticFeedback.mediumImpact();
    timer.start();
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _getLocalizedLabel(PomodoroState state, bool isPaused, BuildContext context) {
    switch (state) {
      case PomodoroState.work:
        return isPaused ? 'Work (Paused)' : 'Work';
      case PomodoroState.shortBreak:
        return isPaused ? 'Short Break (Paused)' : 'Short Break';
      case PomodoroState.longBreak:
        return isPaused ? 'Long Break (Paused)' : 'Long Break';
      default:
        return 'Ready';
    }
  }

  List<Color> _getBackgroundColors(PomodoroState state, bool isDarkMode) {
    switch (state) {
      case PomodoroState.work:
        return isDarkMode ? [const Color(0xFF2E1A47), const Color(0xFF4A2C6E), const Color(0xFF6B3E8F)] : [const Color(0xFF6B3E8F), const Color(0xFF8B5FA8), const Color(0xFFAB80C2)];
      case PomodoroState.shortBreak:
        return isDarkMode ? [const Color(0xFF1A472E), const Color(0xFF2C6E4A), const Color(0xFF3E8F6B)] : [const Color(0xFF3E8F6B), const Color(0xFF5FA88B), const Color(0xFF80C2AB)];
      case PomodoroState.longBreak:
        return isDarkMode ? [const Color(0xFF471A1A), const Color(0xFF6E2C2C), const Color(0xFF8F3E3E)] : [const Color(0xFF8F3E3E), const Color(0xFFA85F5F), const Color(0xFFC28080)];
      default:
        return isDarkMode ? [const Color(0xFF1A1A47), const Color(0xFF2C2C6E), const Color(0xFF3E3E8F)] : [const Color(0xFF3E3E8F), const Color(0xFF5F5FA8), const Color(0xFF8080C2)];
    }
  }

  Color _getGaugeColor(PomodoroState state, bool isDarkMode) {
    switch (state) {
      case PomodoroState.work:
        return const Color(0xFFAB80C2);
      case PomodoroState.shortBreak:
        return const Color(0xFF80C2AB);
      case PomodoroState.longBreak:
        return const Color(0xFFC28080);
      default:
        return const Color(0xFF8080C2);
    }
  }
}

// ====================================================================
// EFFECTS SYSTEM
// ====================================================================
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
// LAYOUT SYSTEM
// ====================================================================
class PomodoroLayoutSystem {
  // Layout utilities and responsive design helpers
}

// ====================================================================
// THEME SYSTEM
// ====================================================================
class PomodoroThemeSystem {
  Widget buildBackground(BuildContext context, PomodoroTimer timer) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colors = _getBackgroundColors(timer.state, isDarkMode);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
      ),
    );
  }

  List<Color> _getBackgroundColors(PomodoroState state, bool isDarkMode) {
    switch (state) {
      case PomodoroState.work:
        return isDarkMode ? [const Color(0xFF2E1A47), const Color(0xFF4A2C6E), const Color(0xFF6B3E8F)] : [const Color(0xFF6B3E8F), const Color(0xFF8B5FA8), const Color(0xFFAB80C2)];
      case PomodoroState.shortBreak:
        return isDarkMode ? [const Color(0xFF1A472E), const Color(0xFF2C6E4A), const Color(0xFF3E8F6B)] : [const Color(0xFF3E8F6B), const Color(0xFF5FA88B), const Color(0xFF80C2AB)];
      case PomodoroState.longBreak:
        return isDarkMode ? [const Color(0xFF471A1A), const Color(0xFF6E2C2C), const Color(0xFF8F3E3E)] : [const Color(0xFF8F3E3E), const Color(0xFFA85F5F), const Color(0xFFC28080)];
      default:
        return isDarkMode ? [const Color(0xFF1A1A47), const Color(0xFF2C2C6E), const Color(0xFF3E3E8F)] : [const Color(0xFF3E3E8F), const Color(0xFF5F5FA8), const Color(0xFF8080C2)];
    }
  }
}

// ====================================================================
// TIME ADJUSTMENT
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
// QUICK ACTIONS
// ====================================================================
class PomodoroQuickActions {
  final BuildContext? context;

  PomodoroQuickActions({this.context});

  void skipSession(PomodoroTimer timer) {
    timer.skip();
    HapticFeedback.mediumImpact();
    _showFeedbackMessage('Session skipped');
  }

  void takeBreak(PomodoroTimer timer) {
    // Implementation for taking a break
    _showFeedbackMessage('Break started');
  }

  void resetTimer(PomodoroTimer timer) {
    timer.stop();
    HapticFeedback.heavyImpact();
    _showFeedbackMessage('Timer reset');
  }

  void _showFeedbackMessage(String message) {
    if (context != null) {
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2), behavior: SnackBarBehavior.floating));
    }
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
