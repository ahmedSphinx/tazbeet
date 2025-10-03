import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tazbeet/l10n/app_localizations.dart';

import '../../services/pomodoro_service.dart';
import '../../models/task.dart';
import '../../repositories/task_repository.dart';
import '../../repositories/category_repository.dart';
import '../../services/notification_service.dart';
import '../../blocs/task_list/task_list_bloc.dart';
import '../../blocs/task_list/task_list_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PomodoroScreen extends StatefulWidget {
  final Task? initialTask;

  const PomodoroScreen({super.key, this.initialTask});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _initialTaskSet = false;

  // Enhanced UI state
  late ConfettiController _confettiController;
  late FlutterTts _flutterTts;
  late AudioPlayer _audioPlayer;
  bool _showCustomization = true;

  // Session customization
  int _workDuration = 25;
  int _breakDuration = 5;
  int _longBreakDuration = 15;
  final int _sessionsBeforeLongBreak = 4;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    // Initialize enhanced features
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _flutterTts = FlutterTts();
    _audioPlayer = AudioPlayer();

    // Configure TTS
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    _flutterTts.stop();
    super.dispose();
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

  void _showCustomizationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(builder: (context, modalSetState) => _buildCustomizationSheet(modalSetState, () => setState(() => _showCustomization = false))),
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
              min: 15,
              max: 60,
              divisions: 9,
              label: '${_workDuration}m',
              onChanged: (value) {
                modalSetState(() {
                  _workDuration = value.toInt();
                });
              },
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.shortBreakLabel, /* 'Short Break: $_breakDuration minutes', */ style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: _breakDuration.toDouble(),
              min: 3,
              max: 15,
              divisions: 4,
              label: '${_breakDuration}m',
              onChanged: (value) {
                modalSetState(() {
                  _breakDuration = value.toInt();
                });
              },
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.longBreakLabel, /* 'Long Break: $_longBreakDuration minutes' */ style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: _longBreakDuration.toDouble(),
              min: 10,
              max: 30,
              divisions: 4,
              label: '${_longBreakDuration}m',
              onChanged: (value) {
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
            Icon(Icons.timer, size: 80, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.pomodoroFocus,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.pomodoroDescription,
              /*               'Choose a task to focus on and customize your session',
 */
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withOpacity(0.8)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _showCustomizationSheet(context),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), backgroundColor: Colors.white, foregroundColor: Theme.of(context).primaryColor),
              child: Text(AppLocalizations.of(context)!.startSession /* 'Start Pomodoro Session' */),
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Icon(Icons.task, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      timer.selectedTask!.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Enhanced timer display with radial gauge
          Expanded(
            child: Center(
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: math.max((timer.remainingMinutes * 60 + timer.remainingSecondsInMinute).toDouble(), 1.0),
                    showLabels: false,
                    showTicks: false,
                    axisLineStyle: AxisLineStyle(thickness: 20, color: Colors.white.withOpacity(0.2)),
                    pointers: <GaugePointer>[
                      RangePointer(value: (timer.remainingMinutes * 60 + timer.remainingSecondsInMinute).toDouble(), width: 20, color: Colors.white, enableAnimation: true, animationDuration: 1000),
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
          ),

          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Text(AppLocalizations.of(context)!.sessionProgress, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: timer.progress, backgroundColor: Colors.white.withOpacity(0.3), valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
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
                    timer.updateSession(PomodoroSession(workDuration: _workDuration, shortBreakDuration: _breakDuration, longBreakDuration: _longBreakDuration, sessionsUntilLongBreak: _sessionsBeforeLongBreak));
                    timer.start();
                    _animationController.forward();
                  }
                },
              ),
              const SizedBox(width: 24),
              _buildControlButton(
                icon: Icons.stop,
                label: AppLocalizations.of(context)!.stop,
                onPressed: () {
                  timer.stop();
                  _animationController.reverse();
                  setState(() => _showCustomization = true);
                },
                backgroundColor: Colors.red.withOpacity(0.3),
              ),
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskListBloc(taskRepository: TaskRepository(), categoryRepository: CategoryRepository(), notificationService: NotificationService())..add(LoadTasks()),
      child: ChangeNotifierProvider(
        create: (context) => PomodoroTimer(taskRepository: TaskRepository()),
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
      ),
    );
  }

  Widget _buildStats(PomodoroTimer timer) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.statistics,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(AppLocalizations.of(context)!.completedLabel, '${timer.completedSessions}', Icons.check_circle),
              _buildStatItem(AppLocalizations.of(context)!.workTime, '${timer.getTotalWorkTime().inMinutes}m', Icons.work),
              _buildStatItem(AppLocalizations.of(context)!.breakTime, '${timer.getTotalBreakTime().inMinutes}m', Icons.coffee),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.7))),
      ],
    );
  }

  Widget _buildControlButton({required IconData icon, required String label, required VoidCallback onPressed, Color? backgroundColor}) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor ?? Colors.white.withOpacity(0.2)),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
      ],
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
