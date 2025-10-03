import 'package:flutter/material.dart';
import '../themes/design_system.dart';

class AnimatedExpansionCard extends StatefulWidget {
  final Widget title;
  final Widget? leading;
  final List<Widget> children;
  final bool initiallyExpanded;
  final VoidCallback? onExpansionChanged;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BoxDecoration? decoration;

  const AnimatedExpansionCard({super.key, required this.title, this.leading, required this.children, this.initiallyExpanded = false, this.onExpansionChanged, this.padding, this.backgroundColor, this.decoration});

  @override
  State<AnimatedExpansionCard> createState() => _AnimatedExpansionCardState();
}

class _AnimatedExpansionCardState extends State<AnimatedExpansionCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;

    _controller = AnimationController(duration: AppAnimations.normal, vsync: this);

    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(CurvedAnimation(parent: _controller, curve: AppAnimations.standard));

    _heightFactor = CurvedAnimation(parent: _controller, curve: AppAnimations.standard);

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    widget.onExpansionChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = widget.decoration ?? AppCardStyles.standard(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: decoration,
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: _handleTap,
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Padding(
                  padding: widget.padding ?? const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      if (widget.leading != null) ...[widget.leading!, const SizedBox(width: AppSpacing.sm)],
                      Expanded(child: widget.title),
                      RotationTransition(
                        turns: _iconTurns,
                        child: Icon(Icons.expand_more, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
              ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  heightFactor: _heightFactor.value,
                  child: Padding(
                    padding: widget.padding ?? const EdgeInsets.all(AppSpacing.md),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: widget.children),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
