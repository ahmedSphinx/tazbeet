import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../models/task.dart';

class EnhancedPomodoroScreen extends StatefulWidget {
  final Task? initialTask;

  const EnhancedPomodoroScreen({super.key, this.initialTask});

  @override
  State<EnhancedPomodoroScreen> createState() => _EnhancedPomodoroScreenState();
}

class _EnhancedPomodoroScreenState extends State<EnhancedPomodoroScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late ConfettiController _confettiController;
  late FlutterTts _flutterTts;
  late AudioPlayer _audioPlayer;

  // Customization state
  int _totalMinutes = 25;
  int _breakCount = 1;
  int _breakDuration = 5;
  bool _showCustomization = true;

  // Session state
  bool _isWorkSession = true;
  int _currentSession = 0;
  int _totalSessions = 1;
  Duration _remainingTime = const Duration(minutes: 25);
  bool _isRunning = false;
  bool _isPaused = false;

  // Task state
  Task? _currentTask;
  bool _isSubtask = false;
  String? _parentTaskTitle;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _flutterTts = FlutterTts();
    _audioPlayer = AudioPlayer();

    // Initialize TTS settings
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);

    // Set initial task and show customization if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialTask != null) {
        _setInitialTask(widget.initialTask!);
        _showCustomizationSheet();
      }
    });
  }

  void _setInitialTask(Task task) {
    setState(() {
      _currentTask = task;
      _isSubtask = task.parentId != null;

      if (_isSubtask) {
        // Find parent task title (simplified - in real app, fetch from repository)
        _parentTaskTitle = "Parent Task"; // TODO: Fetch actual parent
      }

      // Auto-suggest time based on task complexity
      int suggestedMinutes = 25;
      if (task.subtasks.isNotEmpty) {
        suggestedMinutes += task.subtasks.length * 10;
      }
      if (task.priority == TaskPriority.high) {
        suggestedMinutes += 5;
      }
      _totalMinutes = suggestedMinutes.clamp(25, 300);
    });
  }

  void _showCustomizationSheet() {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => _buildCustomizationSheet());
  }

  Widget _buildCustomizationSheet() {
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
            Text(_isSubtask ? 'Customize Pomodoro for Subtask' : 'Customize Pomodoro Session', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(_currentTask != null ? 'Focusing on: ${_currentTask!.title}' : 'Select a task to focus on', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
            const SizedBox(height: 24),

            // Total time slider
            Text('Total Time: ${_totalMinutes} minutes', style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: _totalMinutes.toDouble(),
              min: 25,
              max: 300,
              divisions: 11,
              label: '${_totalMinutes}m',
              onChanged: (value) {
                setState(() {
                  _totalMinutes = value.toInt();
                  _calculateSessions();
                });
              },
            ),

            const SizedBox(height: 16),

            // Break count stepper
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Number of Breaks: $_breakCount', style: Theme.of(context).textTheme.titleMedium),
                Row(
                  children: [
                    IconButton(
                      onPressed: _breakCount > 0
                          ? () => setState(() {
                              _breakCount--;
                              _calculateSessions();
                            })
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$_breakCount'),
                    IconButton(
                      onPressed: _breakCount < 15
                          ? () => setState(() {
                              _breakCount++;
                              _calculateSessions();
                            })
                          : null,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Break duration slider
            Text('Break Duration: $_breakDuration minutes', style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: _breakDuration.toDouble(),
              min: 3,
              max: 20,
              divisions: 17,
              label: '${_breakDuration}m',
              onChanged: (value) {
                setState(() {
                  _breakDuration = value.toInt();
                });
              },
            ),

            const SizedBox(height: 24),

            // Preview summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Session Plan Preview', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Total: $_totalSessions work sessions + $_breakCount breaks = ${(_totalSessions * _totalMinutes) + (_breakCount * _breakDuration)} minutes', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(onPressed: _showStepsPreview, child: const Text('Continue')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _calculateSessions() {
    // Calculate total sessions based on time and breaks
    _totalSessions = (_totalMinutes / 25).ceil();
    if (_breakCount >= _totalSessions) {
      _breakCount = _totalSessions - 1;
    }
  }

  void _showStepsPreview() {
    Navigator.pop(context); // Close customization sheet

    showDialog(context: context, barrierDismissible: false, builder: (context) => _buildStepsPreviewDialog());
  }

  Widget _buildStepsPreviewDialog() {
    List<String> steps = [];
    int workSession = 1;

    for (int i = 0; i < _totalSessions; i++) {
      steps.add('Step ${steps.length + 1}: Focus for 25 minutes on "${_currentTask?.title ?? 'task'}"');
      if (i < _breakCount) {
        steps.add('Step ${steps.length + 1}: Take a $_breakDuration-minute break');
      }
    }
    steps.add('Step ${steps.length + 1}: Review progress and celebrate completion!');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ready to Begin?', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Here\'s your personalized Pomodoro plan:', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}. ',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                        ),
                        Expanded(child: Text(steps[index].substring(steps[index].indexOf(': ') + 2), style: Theme.of(context).textTheme.bodyMedium)),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '"One Pomodoro at a time – even small steps count!"',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showCustomizationSheet();
                    },
                    child: const Text('Edit Plan'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _startSession();
                    },
                    child: const Text('Start Session'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startSession() {
    setState(() {
      _showCustomization = false;
      _isRunning = true;
      _remainingTime = const Duration(minutes: 25);
      _currentSession = 0;
    });

    _speak('Starting your Pomodoro session. Focus on ${_currentTask?.title ?? 'your task'} for 25 minutes.');
    _startTimer();
  }

  void _startTimer() {
    // Timer logic would go here
    // For now, just set up the UI state
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isWorkSession ? [const Color(0xFF667EEA), const Color(0xFF764BA2)] : [const Color(0xFF11998E), const Color(0xFF38EF7D)],
          ),
        ),
        child: SafeArea(child: _showCustomization ? _buildTaskSelectionView() : _buildTimerView()),
      ),
    );
  }

  Widget _buildTaskSelectionView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer, size: 80, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              'Pomodoro Focus',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Choose a task to focus on and customize your session',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.8)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _showCustomizationSheet,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), backgroundColor: Colors.white, foregroundColor: Theme.of(context).primaryColor),
              child: const Text('Start Pomodoro Session'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header with task info
          if (_currentTask != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(_isSubtask ? Icons.subdirectory_arrow_right : Icons.task, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _currentTask!.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  if (_isSubtask && _parentTaskTitle != null) ...[
                    const SizedBox(height: 4),
                    Text('In: $_parentTaskTitle', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.7))),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Timer display
          Expanded(
            child: Center(
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: _isWorkSession ? 25 * 60 : _breakDuration * 60,
                    showLabels: false,
                    showTicks: false,
                    axisLineStyle: AxisLineStyle(thickness: 20, color: Colors.white.withValues(alpha: 0.2)),
                    pointers: <GaugePointer>[RangePointer(value: _remainingTime.inSeconds.toDouble(), width: 20, color: Colors.white, enableAnimation: true, animationDuration: 1000)],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${_remainingTime.inMinutes.toString().padLeft(2, '0')}:${(_remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(_isWorkSession ? 'Focus Time' : 'Break Time', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white.withValues(alpha: 0.8))),
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

          // Session progress
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Text('Session ${_currentSession + 1} of $_totalSessions', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _totalSessions,
                    (index) => Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: index <= _currentSession ? Colors.white : Colors.white.withValues(alpha: 0.3)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(icon: _isRunning ? Icons.pause : Icons.play_arrow, label: _isRunning ? 'Pause' : 'Start', onPressed: _toggleTimer),
              const SizedBox(width: 24),
              _buildControlButton(icon: Icons.stop, label: 'Stop', onPressed: _stopSession, backgroundColor: Colors.red.withValues(alpha: 0.3)),
            ],
          ),

          const SizedBox(height: 24),

          // Subtasks section (if applicable)
          if (_currentTask != null && _currentTask!.subtasks.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subtasks',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._currentTask!.subtasks.map(
                    (subtask) => CheckboxListTile(
                      title: Text(
                        subtask.title,
                        style: TextStyle(color: Colors.white, decoration: subtask.isCompleted ? TextDecoration.lineThrough : null),
                      ),
                      value: subtask.isCompleted,
                      onChanged: (value) {
                        // Update subtask completion
                        setState(() {
                          // This would normally update via Bloc
                        });
                      },
                      checkColor: Theme.of(context).primaryColor,
                      activeColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required String label, required VoidCallback onPressed, Color? backgroundColor}) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor ?? Colors.white.withValues(alpha: 0.2)),
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

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _stopSession() {
    setState(() {
      _isRunning = false;
      _showCustomization = true;
    });
    _animationController.reverse();
  }
}
