import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/ui/design_system/ds_spacing.dart';
import 'package:tazbeet/ui/design_system/ds_border_radius.dart';
import 'package:tazbeet/ui/controllers/search_manager.dart';

/// Enhanced search bar with history and suggestions
class EnhancedSearchBar extends StatefulWidget {
  final SearchManager searchManager;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? hintText;
  final bool autofocus;
  final VoidCallback? onClear;

  const EnhancedSearchBar({super.key, required this.searchManager, this.onChanged, this.onSubmitted, this.hintText, this.autofocus = false, this.onClear});

  @override
  State<EnhancedSearchBar> createState() => _EnhancedSearchBarState();
}

class _EnhancedSearchBarState extends State<EnhancedSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    widget.searchManager.loadSearchHistory();

    _controller.addListener(() {
      widget.searchManager.onSearchChanged(_controller.text);
      widget.onChanged?.call(_controller.text);
    });

    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus && (widget.searchManager.suggestions.isNotEmpty || widget.searchManager.searchHistory.isNotEmpty);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: DSBorderRadius.lgRadius,
            border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              const SizedBox(width: DSSpacing.md),
              Icon(Icons.search_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
              const SizedBox(width: DSSpacing.sm),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: widget.autofocus,
                  decoration: InputDecoration(
                    hintText: widget.hintText ?? AppLocalizations.of(context)!.searchHint,
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  onSubmitted: (value) {
                    widget.onSubmitted?.call(value);
                    _focusNode.unfocus();
                    setState(() => _showSuggestions = false);
                  },
                ),
              ),
              if (_controller.text.isNotEmpty)
                IconButton(
                  onPressed: () {
                    _controller.clear();
                    widget.searchManager.clearSearch();
                    widget.onClear?.call();
                  },
                  icon: Icon(Icons.close_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
                ),
              const SizedBox(width: DSSpacing.sm),
            ],
          ),
        ),

        // Suggestions dropdown
        if (_showSuggestions) ...[
          const SizedBox(height: DSSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: DSBorderRadius.lgRadius,
              border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.searchManager.suggestions.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(DSSpacing.md),
                    child: Text(
                      AppLocalizations.of(context)!.searchHint ?? 'Suggestions',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                    ),
                  ),
                  ...widget.searchManager.suggestions.map((suggestion) => _buildSuggestionItem(suggestion)),
                ],

                if (widget.searchManager.searchHistory.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(DSSpacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Searches',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                          onPressed: widget.searchManager.clearHistory,
                          child: Text(AppLocalizations.of(context)!.clearAllButton ?? 'Clear', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  ...widget.searchManager.searchHistory.map((historyItem) => _buildHistoryItem(historyItem)),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSuggestionItem(String suggestion) {
    return ListTile(
      dense: true,
      leading: Icon(Icons.search_rounded, size: 18, color: Theme.of(context).colorScheme.primary),
      title: Text(
        suggestion,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        _controller.text = suggestion;
        widget.searchManager.setSearchImmediate(suggestion);
        widget.onChanged?.call(suggestion);
        _focusNode.unfocus();
        setState(() => _showSuggestions = false);
      },
    );
  }

  Widget _buildHistoryItem(String historyItem) {
    return ListTile(
      dense: true,
      leading: Icon(Icons.history_rounded, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
      title: Text(historyItem, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
      trailing: IconButton(
        onPressed: () {
          widget.searchManager.removeFromHistory(historyItem);
          HapticFeedback.lightImpact();
        },
        icon: Icon(Icons.close_rounded, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      onTap: () {
        _controller.text = historyItem;
        widget.searchManager.setSearchImmediate(historyItem);
        widget.onChanged?.call(historyItem);
        _focusNode.unfocus();
        setState(() => _showSuggestions = false);
      },
    );
  }
}
