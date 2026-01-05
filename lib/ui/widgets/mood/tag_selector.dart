import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/mood_tag.dart';

/// A widget for selecting mood tags with categories
class TagSelector extends StatefulWidget {
  final List<String> selectedTagIds;
  final ValueChanged<List<String>> onTagsChanged;
  final bool showCategories;
  final int maxTags;

  const TagSelector({super.key, required this.selectedTagIds, required this.onTagsChanged, this.showCategories = true, this.maxTags = 10});

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  MoodTagCategory? _selectedCategory;
  final TextEditingController _customTagController = TextEditingController();

  @override
  void dispose() {
    _customTagController.dispose();
    super.dispose();
  }

  void _toggleTag(String tagId) {
    HapticFeedback.selectionClick();
    final newTags = List<String>.from(widget.selectedTagIds);

    if (newTags.contains(tagId)) {
      newTags.remove(tagId);
    } else {
      if (newTags.length < widget.maxTags) {
        newTags.add(tagId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Maximum ${widget.maxTags} tags allowed'), duration: const Duration(seconds: 2)));
        return;
      }
    }

    widget.onTagsChanged(newTags);
  }

  void _addCustomTag() {
    final text = _customTagController.text.trim();
    if (text.isEmpty) return;

    final customTagId = 'custom_$text';
    _toggleTag(customTagId);
    _customTagController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category selector
        if (widget.showCategories) ...[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip(null, 'All', Icons.apps),
                ...MoodTagCategory.values.map((category) {
                  return _buildCategoryChip(category, _getCategoryName(category), _getCategoryIcon(category));
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _getFilteredTags().map((tag) {
            final isSelected = widget.selectedTagIds.contains(tag.id);
            return _buildTagChip(tag, isSelected);
          }).toList(),
        ),

        // Custom tag input
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _customTagController,
                decoration: InputDecoration(
                  hintText: 'Add custom tag...',
                  prefixIcon: const Icon(Icons.add),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (_) => _addCustomTag(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(onPressed: _addCustomTag, icon: const Icon(Icons.check_circle), color: theme.colorScheme.primary),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryChip(MoodTagCategory? category, String label, IconData icon) {
    final isSelected = _selectedCategory == category;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 16), const SizedBox(width: 4), Text(label)]),
        onSelected: (_) {
          HapticFeedback.selectionClick();
          setState(() {
            _selectedCategory = category;
          });
        },
        selectedColor: theme.colorScheme.primaryContainer,
        checkmarkColor: theme.colorScheme.onPrimaryContainer,
      ),
    );
  }

  Widget _buildTagChip(MoodTag tag, bool isSelected) {
    final theme = Theme.of(context);

    return FilterChip(
      selected: isSelected,
      label: Row(mainAxisSize: MainAxisSize.min, children: [Text(tag.emoji), const SizedBox(width: 4), Text(tag.label)]),
      onSelected: (_) => _toggleTag(tag.id),
      selectedColor: theme.colorScheme.secondaryContainer,
      checkmarkColor: theme.colorScheme.onSecondaryContainer,
    );
  }

  List<MoodTag> _getFilteredTags() {
    if (_selectedCategory == null) {
      return MoodTags.allTags;
    }
    return MoodTags.getTagsByCategory(_selectedCategory!);
  }

  String _getCategoryName(MoodTagCategory category) {
    switch (category) {
      case MoodTagCategory.activity:
        return 'Activities';
      case MoodTagCategory.people:
        return 'People';
      case MoodTagCategory.location:
        return 'Location';
      case MoodTagCategory.physical:
        return 'Physical';
      case MoodTagCategory.event:
        return 'Events';
    }
  }

  IconData _getCategoryIcon(MoodTagCategory category) {
    switch (category) {
      case MoodTagCategory.activity:
        return Icons.directions_run;
      case MoodTagCategory.people:
        return Icons.people;
      case MoodTagCategory.location:
        return Icons.location_on;
      case MoodTagCategory.physical:
        return Icons.favorite;
      case MoodTagCategory.event:
        return Icons.event;
    }
  }
}
