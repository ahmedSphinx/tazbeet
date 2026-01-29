import 'package:flutter/material.dart';
import '../../services/focus_mode.dart';

class FocusModeIndicator extends StatefulWidget {
  const FocusModeIndicator({super.key});

  @override
  State<FocusModeIndicator> createState() => _FocusModeIndicatorState();
}

class _FocusModeIndicatorState extends State<FocusModeIndicator> {
  @override
  void initState() {
    super.initState();
    // Listen to focus mode events
    FocusMode.events.listen((event) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!FocusMode.isActive) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.green.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.center_focus_strong, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            'FOCUS',
            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
        ],
      ),
    );
  }
}

class FocusModeOverlay extends StatelessWidget {
  const FocusModeOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (FocusMode.isActive)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.green.withValues(alpha: 0.8), Colors.green.withValues(alpha: 0.4), Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
            ),
          ),
      ],
    );
  }
}

class QuickFocusModeButton extends StatefulWidget {
  const QuickFocusModeButton({super.key});

  @override
  State<QuickFocusModeButton> createState() => _QuickFocusModeButtonState();
}

class _QuickFocusModeButtonState extends State<QuickFocusModeButton> {
  @override
  void initState() {
    super.initState();
    // Listen to focus mode events
    FocusMode.events.listen((event) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (FocusMode.isActive) {
      return FloatingActionButton.extended(
        onPressed: () async {
          await FocusMode.disableFocusMode(reason: 'Quick stop');
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.stop),
        label: const Text('Stop Focus'),
      );
    }

    return FloatingActionButton.extended(onPressed: () => _showFocusModeOptions(context), backgroundColor: Colors.red, foregroundColor: Colors.white, icon: const Icon(Icons.play_arrow), label: const Text('Start Focus'));
  }

  void _showFocusModeOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Quick Focus Mode', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('25 Minutes'),
              subtitle: const Text('Standard Pomodoro'),
              onTap: () async {
                Navigator.pop(context);
                await FocusMode.enableFocusMode(durationMinutes: 25);
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer_outlined),
              title: const Text('45 Minutes'),
              subtitle: const Text('Deep work session'),
              onTap: () async {
                Navigator.pop(context);
                await FocusMode.enableFocusMode(durationMinutes: 45);
              },
            ),
            ListTile(
              leading: const Icon(Icons.hourglass_empty),
              title: const Text('60 Minutes'),
              subtitle: const Text('Extended focus session'),
              onTap: () async {
                Navigator.pop(context);
                await FocusMode.enableFocusMode(durationMinutes: 60);
              },
            ),
            ListTile(
              leading: const Icon(Icons.all_inclusive),
              title: const Text('No Time Limit'),
              subtitle: const Text('Until manually stopped'),
              onTap: () async {
                Navigator.pop(context);
                await FocusMode.enableFocusMode();
              },
            ),
          ],
        ),
      ),
    );
  }
}
