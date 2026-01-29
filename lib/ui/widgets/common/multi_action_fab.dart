import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Action data for floating action button
class FloatingActionButtonAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  const FloatingActionButtonAction({required this.icon, required this.label, required this.onPressed, required this.backgroundColor, required this.foregroundColor});
}

/// Multi-action floating action button with smooth animations
class MultiActionFAB extends StatefulWidget {
  final IconData mainIcon;
  final String mainLabel;
  final Color backgroundColor;
  final Color foregroundColor;
  final String heroTag;
  final List<FloatingActionButtonAction> actions;

  const MultiActionFAB({super.key, required this.mainIcon, required this.mainLabel, required this.backgroundColor, required this.foregroundColor, required this.heroTag, required this.actions});

  @override
  State<MultiActionFAB> createState() => _MultiActionFABState();
}

class _MultiActionFABState extends State<MultiActionFAB> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  bool _isOpen = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    _rotationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.75).animate(CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut));

    _slideAnimations = List.generate(widget.actions.length, (index) => Tween<Offset>(begin: const Offset(0, 0), end: Offset(0, -(1.2 + index * 0.8))).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack)));

    _fadeAnimations = List.generate(
      widget.actions.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.0, 0.5 + (index * 0.1), curve: Curves.easeOut),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.lightImpact();

    if (_isOpen) {
      _animationController.reverse();
      _rotationController.reverse();
    } else {
      _animationController.forward();
      _rotationController.forward();
    }

    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      clipBehavior: Clip.none,
      children: [
        // Action buttons
        ..._buildActionButtons(),

        // Main FAB
        _buildMainFAB(),
      ],
    );
  }

  List<Widget> _buildActionButtons() {
    return widget.actions.asMap().entries.map((entry) {
      final index = entry.key;
      final action = entry.value;

      return Positioned(
        bottom: 16 + (index * 72), // Position above main FAB
        right: 0,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return SlideTransition(
              position: _slideAnimations[index],
              child: FadeTransition(opacity: _fadeAnimations[index], child: child),
            );
          },
          child: _buildActionButton(action),
        ),
      );
    }).toList();
  }

  Widget _buildActionButton(FloatingActionButtonAction action) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Label
          AnimatedOpacity(
            opacity: _isOpen ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(20)),
              child: Text(
                action.label,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Action button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: action.backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: action.backgroundColor.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  HapticFeedback.lightImpact();
                  action.onPressed();
                  _toggle(); // Close after action
                },
                child: Icon(action.icon, color: action.foregroundColor, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainFAB() {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _rotationAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 2 * 3.14159,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [widget.backgroundColor, widget.backgroundColor.withValues(alpha: 0.8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: widget.backgroundColor.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
              ),
              child: FloatingActionButton(
                heroTag: widget.heroTag,
                onPressed: _toggle,
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Icon(widget.mainIcon, color: widget.foregroundColor, size: 28),
              ),
            ),
          ),
        );
      },
    );
  }
}
