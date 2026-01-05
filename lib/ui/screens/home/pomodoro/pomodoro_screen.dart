import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import '../../../../models/pomodoro_templates.dart';
import '../../../../services/pomodoro_service.dart';
import '../../../../services/settings_service.dart';
import '../../../../services/emergency_service.dart';
import '../../../../models/task.dart';
import '../../../../repositories/task_repository.dart';

/// Global PomodoroTimer instance to persist state across tab switches
PomodoroTimer? _globalPomodoroTimer;

class PomodoroScreen extends StatefulWidget {
  final Task? initialTask;

  const PomodoroScreen({super.key, this.initialTask});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  bool _initialTaskSet = false;

  // Enhanced UI state
  late ConfettiController _confettiController;
  late FlutterTts _flutterTts;
  bool _showCustomization = true;

  // Session customization
  int _workDuration = 25;
  int _breakDuration = 5;
  int _longBreakDuration = 15;
  int _sessionsBeforeLongBreak = 4;
  late List<PomodoroTemplate> templates;
  bool _templatesInitialized = false;
  bool _timerInitialized = false;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _pulseController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    // Initialize enhanced features
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _flutterTts = FlutterTts();
    // Configure TTS - language will be set in didChangeDependencies
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);

    // Load settings
    _loadSettingsDefaults();
  }

  void _loadSettingsDefaults() {
    final settings = SettingsService().settings;
    _workDuration = settings.customWorkDuration;
    _breakDuration = settings.customShortBreakDuration;
    _longBreakDuration = settings.customLongBreakDuration;
    _sessionsBeforeLongBreak = settings.sessionsUntilLongBreak;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_templatesInitialized) {
      final l10n = AppLocalizations.of(context)!;
      templates = [
        PomodoroTemplate(name: l10n.classicPreset, work: 25, rest: 5, longRest: 15, cycles: 4, recommendedFor: RecommendedFor.normal),
        PomodoroTemplate(name: l10n.quickstart, work: 15, rest: 3, longRest: 8, cycles: 4, recommendedFor: RecommendedFor.adhd),
        PomodoroTemplate(name: l10n.deepWork, work: 50, rest: 10, longRest: 20, cycles: 3, recommendedFor: RecommendedFor.no),
        PomodoroTemplate(name: l10n.students, work: 30, rest: 5, longRest: 10, cycles: 4, recommendedFor: RecommendedFor.no),
        PomodoroTemplate(name: l10n.custom, work: 0, rest: 0, longRest: 0, cycles: 0, recommendedFor: RecommendedFor.no),
      ];
      _templatesInitialized = true;

      // Set TTS language based on app locale
      final locale = AppLocalizations.of(context)?.localeName ?? 'en';
      _flutterTts.setLanguage(
        locale == 'ar'
            ? 'ar-SA'
            : locale == 'es'
            ? 'es-ES'
            : locale == 'fr'
            ? 'fr-FR'
            : 'en-US',
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _confettiController.dispose();
    _flutterTts.stop();

    // Clean up global timer if this is the last instance
    if (_globalPomodoroTimer != null) {
      _globalPomodoroTimer!.onStateChange = null;
      EmergencyService().setPomodoroTimer(null);
    }

    super.dispose();
  }

  void _onPomodoroStateChange(PomodoroState oldState, PomodoroState newState) {
    // Play confetti on work session completion
    if (oldState == PomodoroState.work && (newState == PomodoroState.shortBreak || newState == PomodoroState.longBreak)) {
      _confettiController.play();
      _announceStateChange(newState);
    } else if ((oldState == PomodoroState.shortBreak || oldState == PomodoroState.longBreak) && newState == PomodoroState.work) {
      _announceStateChange(newState);
    }
  }

  void _announceStateChange(PomodoroState newState) {
    final l10n = AppLocalizations.of(context)!;
    String message;
    switch (newState) {
      case PomodoroState.work:
        message = l10n.work;
        break;
      case PomodoroState.shortBreak:
        message = l10n.shortBreak;
        break;
      case PomodoroState.longBreak:
        message = l10n.longBreak;
        break;
      default:
        return;
    }
    _flutterTts.speak(message);
  }

  String _getLocalizedLabel(PomodoroState state, bool isPaused, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String label;
    switch (state) {
      case PomodoroState.work:
        label = l10n.work;
        break;
      case PomodoroState.shortBreak:
        label = l10n.shortBreak;
        break;
      case PomodoroState.longBreak:
        label = l10n.longBreak;
        break;
      case PomodoroState.idle:
        label = l10n.idle;
        break;
      default:
        label = l10n.idle;
    }
    if (isPaused) {
      label += ' (${l10n.paused})';
    }
    return label;
  }

  int _getTotalSecondsForState(PomodoroState state) {
    switch (state) {
      case PomodoroState.work:
        return _workDuration * 60;
      case PomodoroState.shortBreak:
        return _breakDuration * 60;
      case PomodoroState.longBreak:
        return _longBreakDuration * 60;
      case PomodoroState.idle:
        return _workDuration * 60; // Default to work duration for idle state
      default:
        return _workDuration * 60;
    }
  }

  void showPomodoroTemplatesSheet({required BuildContext context, required List<PomodoroTemplate> items, required void Function(PomodoroTemplate) onSelect, required PomodoroTimer timer}) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Text('🥕 ${l10n.pomodoroFocus}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final t = items[i];
                    // Check if this is the custom template by checking work == 0
                    final isCustomize = t.work == 0;
                    final isRecommended = t.recommendedFor == RecommendedFor.adhd || t.recommendedFor == RecommendedFor.normal;
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isRecommended ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.2), width: isRecommended ? 2 : 1),
                        color: isCustomize ? Theme.of(context).primaryColor.withOpacity(0.05) : Colors.transparent,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: isCustomize ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          child: Icon(isCustomize ? Icons.tune : Icons.timer_outlined, size: 28, color: isCustomize ? Theme.of(context).primaryColor : Colors.grey[700]),
                        ),
                        title: Text(
                          t.name,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: isCustomize ? 16 : 15, fontStyle: isCustomize ? FontStyle.italic : null),
                        ),
                        subtitle: isCustomize
                            ? Text(l10n.customizePomodoroSession, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text('${t.work} ${l10n.minutes} ${l10n.work} • ${t.rest} ${l10n.minutes} ${l10n.shortBreak}', style: const TextStyle(fontSize: 13)),
                                  if (isRecommended) ...[
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                      child: Text(
                                        t.recommendedFor == RecommendedFor.adhd ? '✨ ${l10n.recommendedForAdhd}' : '⭐ ${l10n.mostPopular}',
                                        style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                        trailing: Icon(isCustomize ? Icons.arrow_forward_ios_rounded : Icons.play_circle_outline, size: 24, color: isCustomize ? Theme.of(context).primaryColor : Colors.grey[600]),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                          if (isCustomize) {
                            _showCustomizationSheet(context, timer);
                          } else {
                            onSelect(t);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showCustomizationSheet(BuildContext context, PomodoroTimer timer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, modalSetState) => _buildCustomizationSheet(modalSetState, () {
          setState(() => _showCustomization = false);
          timer.updateSession(PomodoroSession(workDuration: _workDuration, shortBreakDuration: _breakDuration, longBreakDuration: _longBreakDuration, sessionsUntilLongBreak: _sessionsBeforeLongBreak));
          timer.start();
          _animationController.forward();
        }),
      ),
    );
  }

  Widget _buildCustomizationSheet(StateSetter modalSetState, VoidCallback onStart) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.customizePomodoroSession, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Text(AppLocalizations.of(context)!.workDurationLabel, style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: _workDuration.toDouble(),
              min: 5,
              max: 60,
              divisions: 11, // 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60
              label: '${_workDuration}m',
              onChanged: (value) {
                HapticFeedback.selectionClick();
                modalSetState(() {
                  _workDuration = value.toInt();
                });
              },
            ),
            const SizedBox(height: 16),
            Text('${AppLocalizations.of(context)!.shortBreakLabel}: $_breakDuration ${AppLocalizations.of(context)!.minutes}', style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: _breakDuration.toDouble(),
              min: 1,
              max: 15,
              divisions: 14, // 1-15 minutes
              label: '${_breakDuration}m',
              onChanged: (value) {
                HapticFeedback.selectionClick();
                modalSetState(() {
                  _breakDuration = value.toInt();
                });
              },
            ),
            const SizedBox(height: 16),
            Text('${AppLocalizations.of(context)!.longBreakLabel}: $_longBreakDuration ${AppLocalizations.of(context)!.minutes}', style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: _longBreakDuration.toDouble(),
              min: 5,
              max: 30,
              divisions: 5, // 5, 10, 15, 20, 25, 30
              label: '${_longBreakDuration}m',
              onChanged: (value) {
                HapticFeedback.selectionClick();
                modalSetState(() {
                  _longBreakDuration = value.toInt();
                });
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancelButton)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onStart();
                    },
                    child: Text(AppLocalizations.of(context)!.startSession),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskSelectionView(PomodoroTimer timer) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, spreadRadius: 5)],
              ),
              child: Icon(Icons.timer_outlined, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 32),
            Text(
              AppLocalizations.of(context)!.pomodoroFocus,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                AppLocalizations.of(context)!.pomodoroDescription,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withOpacity(0.9), height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 48),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))],
              ),
              child: ElevatedButton.icon(
                onPressed: () => showPomodoroTemplatesSheet(
                  context: context,
                  items: templates,
                  timer: timer,
                  onSelect: (template) {
                    setState(() {
                      _workDuration = template.work;
                      _breakDuration = template.rest;
                      _longBreakDuration = template.longRest;
                      _showCustomization = false;
                    });
                    timer.updateSession(PomodoroSession(workDuration: _workDuration, shortBreakDuration: _breakDuration, longBreakDuration: _longBreakDuration, sessionsUntilLongBreak: _sessionsBeforeLongBreak));
                    timer.start();
                    _animationController.forward();
                  },
                ),
                icon: const Icon(Icons.play_circle_filled, size: 28),
                label: Text(AppLocalizations.of(context)!.startSession, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerView(PomodoroTimer timer) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Task info header
          if (timer.selectedTask != null) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.task_alt, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      timer.selectedTask!.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Enhanced timer display with radial gauge
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: _buildTimeAdjustButton(icon: Icons.remove, label: '-5 min', onPressed: () => timer.subtractTime(5), enabled: timer.remainingSeconds > 300),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: _buildTimeAdjustButton(icon: Icons.add, label: '+5 min', onPressed: () => timer.addTime(5), enabled: true),
                ),
                Center(
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: _getTotalSecondsForState(timer.effectiveState).toDouble(),
                        showLabels: false,
                        showTicks: false,
                        axisLineStyle: AxisLineStyle(thickness: 15, color: Colors.white.withOpacity(0.2)),
                        pointers: <GaugePointer>[
                          RangePointer(value: (timer.remainingMinutes * 60 + timer.remainingSecondsInMinute).toDouble(), width: 15, color: Colors.white, enableAnimation: true, animationDuration: 1000),
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            widget: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${timer.remainingMinutes.toString().padLeft(2, '0')}:${timer.remainingSecondsInMinute.toString().padLeft(2, '0')}',
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(_getLocalizedLabel(timer.effectiveState, timer.isPaused, context), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white.withOpacity(0.8))),
                              ],
                            ),
                            angle: 90,
                            positionFactor: 0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Time adjustment buttons
          const SizedBox(height: 24),

          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.sessionProgress,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(value: timer.progress, backgroundColor: Colors.white.withOpacity(0.2), valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), minHeight: 8),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Enhanced controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(
                icon: timer.isRunning ? Icons.pause : Icons.play_arrow,
                label: timer.isRunning ? AppLocalizations.of(context)!.pause : AppLocalizations.of(context)!.start,
                onPressed: () {
                  if (timer.isRunning) {
                    timer.pause();
                    _animationController.reverse();
                  } else {
                    // Only update session if timer is idle, not when resuming from pause
                    if (timer.state == PomodoroState.idle) {
                      timer.updateSession(PomodoroSession(workDuration: _workDuration, shortBreakDuration: _breakDuration, longBreakDuration: _longBreakDuration, sessionsUntilLongBreak: _sessionsBeforeLongBreak));
                    }
                    timer.start();
                    _animationController.forward();
                  }
                },
              ),
              const SizedBox(width: 24),
              _buildControlButton(icon: Icons.stop, label: AppLocalizations.of(context)!.stop, onPressed: () => _showStopConfirmation(timer), backgroundColor: Colors.red.withOpacity(0.3)),
              const SizedBox(width: 24),
              _buildControlButton(icon: Icons.skip_next, label: AppLocalizations.of(context)!.skip, onPressed: timer.skip),
            ],
          ),

          const SizedBox(height: 24),

          // Stats
          _buildStats(timer),
        ],
      ),
    );
  }

  void _showStopConfirmation(PomodoroTimer timer) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.stop),
        content: Text(l10n.stopPomodoroConfirmation),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancelButton)),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.mediumImpact();
              timer.stop();
              _animationController.reverse();
              setState(() => _showCustomization = true);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.stop),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use global timer instance to persist state across tab switches
    _globalPomodoroTimer ??= PomodoroTimer(taskRepository: TaskRepository());

    // Initialize timer if not done yet
    if (!_timerInitialized) {
      _timerInitialized = true;
      _globalPomodoroTimer!.initialize();
      _globalPomodoroTimer!.onStateChange = _onPomodoroStateChange;

      // Register with EmergencyService so it can pause the timer
      EmergencyService().setPomodoroTimer(_globalPomodoroTimer);

      // If timer is already running, show timer view
      if (_globalPomodoroTimer!.state != PomodoroState.idle) {
        _showCustomization = false;
        _animationController.forward();
      }
    }

    return ChangeNotifierProvider.value(
      value: _globalPomodoroTimer!,
      child: Scaffold(
        body: Stack(
          children: [
            Consumer<PomodoroTimer>(
              builder: (context, timer, child) {
                // Set initial task if provided and not already set
                if (widget.initialTask != null && !_initialTaskSet) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    timer.setSelectedTask(widget.initialTask);
                    setState(() => _initialTaskSet = true);
                  });
                }

                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: _getBackgroundColors(timer.effectiveState)),
                  ),
                  child: SafeArea(child: _showCustomization ? _buildTaskSelectionView(timer) : _buildTimerView(timer)),
                );
              },
            ),
            // Confetti overlay
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(PomodoroTimer timer) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.statistics,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(AppLocalizations.of(context)!.completedLabel, '${timer.completedSessions}', Icons.check_circle_outline),
              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
              _buildStatItem(AppLocalizations.of(context)!.workTime, '${timer.getTotalWorkTime().inMinutes}m', Icons.work_outline),
              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
              _buildStatItem(AppLocalizations.of(context)!.breakTime, '${timer.getTotalBreakTime().inMinutes}m', Icons.coffee_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.9), size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.8), fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required String label, required VoidCallback onPressed, Color? backgroundColor}) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor ?? Colors.white.withOpacity(0.2),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 32),
            onPressed: () {
              HapticFeedback.mediumImpact();
              onPressed();
            },
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTimeAdjustButton({required IconData icon, required String label, required VoidCallback onPressed, required bool enabled}) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            ),
            child: IconButton(
              icon: Icon(icon, color: Colors.white, size: 24),
              onPressed: enabled
                  ? () {
                      HapticFeedback.lightImpact();
                      onPressed();
                    }
                  : null,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w500, fontSize: 11),
          ),
        ],
      ),
    );
  }

  List<Color> _getBackgroundColors(PomodoroState effectiveState) {
    switch (effectiveState) {
      case PomodoroState.work:
        return [const Color(0xFF667EEA), const Color(0xFF764BA2)];
      case PomodoroState.shortBreak:
        return [const Color(0xFF11998E), const Color(0xFF38EF7D)];
      case PomodoroState.longBreak:
        return [const Color(0xFFf093fb), const Color(0xFFf5576c)];
      case PomodoroState.idle:
        return [const Color(0xFF667EEA), const Color(0xFF764BA2)];
      default:
        return [const Color(0xFF667EEA), const Color(0xFF764BA2)];
    }
  }
}
