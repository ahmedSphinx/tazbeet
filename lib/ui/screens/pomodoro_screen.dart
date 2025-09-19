import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/pomodoro_service.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PomodoroTimer(),
      child: Scaffold(
        
        body: Consumer<PomodoroTimer>(
          builder: (context, timer, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _getBackgroundColors(timer.state),
                ),
              ),
              child: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTimerDisplay(timer),
                              const SizedBox(height: 32),
                              _buildProgressIndicator(timer),
                              const SizedBox(height: 32),
                              _buildControls(timer),
                              const SizedBox(height: 32),
                              _buildStats(timer),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimerDisplay(PomodoroTimer timer) {
    return Column(
      children: [
        Text(
          timer.currentStateLabel,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
        ),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: timer.isRunning ? _scaleAnimation.value : 1.0,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                  border: Border.all(
                    color: Colors.white.withValues(alpha:0.3),
                    width: 2,
                  ),
                ),
                child: Text(
                  '${timer.remainingMinutes.toString().padLeft(2, '0')}:${timer.remainingSecondsInMinute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFeatures: [const FontFeature.tabularFigures()],
                      ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Next: ${timer.nextStateLabel}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha:0.8),
              ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(PomodoroTimer timer) {
    return Column(
      children: [
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white.withValues(alpha:0.3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: timer.progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withValues(alpha:0.8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            4,
            (index) => Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index < timer.completedSessions % 4
                    ? Colors.white
                    : Colors.white.withValues(alpha:0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControls(PomodoroTimer timer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildControlButton(
          icon: timer.isRunning ? Icons.pause : Icons.play_arrow,
          label: timer.isRunning ? 'Pause' : 'Start',
          onPressed: () {
            if (timer.isRunning) {
              timer.pause();
              _animationController.reverse();
            } else {
              timer.start();
              _animationController.forward();
            }
          },
          color: Colors.white,
          backgroundColor: Colors.white.withValues(alpha:0.2),
        ),
        const SizedBox(width: 24),
        _buildControlButton(
          icon: Icons.stop,
          label: 'Stop',
          onPressed: () {
            timer.stop();
            _animationController.reverse();
          },
          color: Colors.white,
          backgroundColor: Colors.red.withValues(alpha:0.3),
        ),
        const SizedBox(width: 24),
        _buildControlButton(
          icon: Icons.skip_next,
          label: 'Skip',
          onPressed: timer.skip,
          color: Colors.white,
          backgroundColor: Colors.white.withValues(alpha:0.2),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    required Color backgroundColor,
  }) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
          ),
          child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
        ),
      ],
    );
  }

  Widget _buildStats(PomodoroTimer timer) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha:0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Session Stats',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                'Completed',
                '${timer.completedSessions}',
                Icons.check_circle,
              ),
              _buildStatItem(
                'Work Time',
                '${timer.getTotalWorkTime().inMinutes}m',
                Icons.work,
              ),
              _buildStatItem(
                'Break Time',
                '${timer.getTotalBreakTime().inMinutes}m',
                Icons.coffee,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha:0.8), size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha:0.7),
              ),
        ),
      ],
    );
  }

  List<Color> _getBackgroundColors(PomodoroState state) {
    switch (state) {
      case PomodoroState.work:
        return [
          const Color(0xFF667EEA),
          const Color(0xFF764BA2),
        ];
      case PomodoroState.shortBreak:
        return [
          const Color(0xFF11998E),
          const Color(0xFF38EF7D),
        ];
      case PomodoroState.longBreak:
        return [
          const Color(0xFF667EEA),
          const Color(0xFF764BA2),
        ];
      case PomodoroState.paused:
        return [
          const Color(0xFF2C3E50),
          const Color(0xFF34495E),
        ];
      case PomodoroState.idle:
      default:
        return [
          const Color(0xFF667EEA),
          const Color(0xFF764BA2),
        ];
    }
  }
}
