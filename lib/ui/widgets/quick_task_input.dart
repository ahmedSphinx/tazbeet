import 'package:flutter/material.dart';
import '../design_system/ds_spacing.dart';
import '../design_system/ds_typography.dart';
import '../design_system/ds_border_radius.dart';

class QuickTaskInput extends StatefulWidget {
  final Function(String) onSubmitted;
  final String hintText;

  const QuickTaskInput({super.key, required this.onSubmitted, this.hintText = 'Add a quick task...'});

  @override
  State<QuickTaskInput> createState() => _QuickTaskInputState();
}

class _QuickTaskInputState extends State<QuickTaskInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmitted(text);
      _controller.clear();
      // Keep focus to allow adding multiple tasks quickly
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.xs),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: DSBorderRadius.mdRadius,
        border: Border.all(color: _isFocused ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), width: _isFocused ? 2 : 1),
        boxShadow: _isFocused ? [BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))] : null,
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: DSTypography.body(context),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: DSTypography.body(context).copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
          prefixIcon: Icon(Icons.add_circle_outline, color: _isFocused ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
          suffixIcon: _controller.text.isNotEmpty ? IconButton(icon: const Icon(Icons.send_rounded), onPressed: _handleSubmit, color: Theme.of(context).colorScheme.primary) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.md),
        ),
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) => _handleSubmit(),
        textInputAction: TextInputAction.send,
      ),
    );
  }
}
