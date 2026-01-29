import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Attachment data class
class TaskAttachment {
  final String id;
  final String name;
  final String path;
  final AttachmentType type;
  final int size;
  final DateTime createdAt;
  final String? thumbnailPath;
  final Map<String, dynamic>? metadata;

  const TaskAttachment({required this.id, required this.name, required this.path, required this.type, required this.size, required this.createdAt, this.thumbnailPath, this.metadata});

  String get sizeFormatted {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  IconData get icon {
    switch (type) {
      case AttachmentType.image:
        return Icons.image;
      case AttachmentType.video:
        return Icons.videocam;
      case AttachmentType.audio:
        return Icons.audiotrack;
      case AttachmentType.document:
        return Icons.description;
      case AttachmentType.archive:
        return Icons.archive;
      case AttachmentType.other:
        return Icons.attach_file;
    }
  }

  Color get color {
    switch (type) {
      case AttachmentType.image:
        return Colors.green;
      case AttachmentType.video:
        return Colors.red;
      case AttachmentType.audio:
        return Colors.purple;
      case AttachmentType.document:
        return Colors.blue;
      case AttachmentType.archive:
        return Colors.orange;
      case AttachmentType.other:
        return Colors.grey;
    }
  }
}

/// Types of attachments
enum AttachmentType { image, video, audio, document, archive, other }

/// Rich attachment gallery widget
class AttachmentGallery extends StatefulWidget {
  final List<TaskAttachment> attachments;
  final VoidCallback? onAddPhoto;
  final VoidCallback? onAddFile;
  final VoidCallback? onAddVoiceNote;
  final Function(TaskAttachment)? onAttachmentTap;
  final Function(TaskAttachment)? onAttachmentDelete;
  final bool isEditable;
  final EdgeInsetsGeometry padding;

  const AttachmentGallery({super.key, required this.attachments, this.onAddPhoto, this.onAddFile, this.onAddVoiceNote, this.onAttachmentTap, this.onAttachmentDelete, this.isEditable = true, this.padding = const EdgeInsets.all(16.0)});

  @override
  State<AttachmentGallery> createState() => _AttachmentGalleryState();
}

class _AttachmentGalleryState extends State<AttachmentGallery> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AttachmentType? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<TaskAttachment> get _filteredAttachments {
    if (_selectedFilter == null) return widget.attachments;
    return widget.attachments.where((a) => a.type == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.attachments.isEmpty) {
      return _buildEmptyGallery(context);
    }

    return Container(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with filters
          _buildHeader(context),
          const SizedBox(height: 16),

          // Filter chips
          _buildFilterChips(context),
          const SizedBox(height: 16),

          // Attachment grid/list
          _buildAttachmentGrid(context),

          // Add attachment buttons
          if (widget.isEditable) ...[const SizedBox(height: 16), _buildAddButtons(context)],
        ],
      ),
    );
  }

  Widget _buildEmptyGallery(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.attach_file, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text('Attachments', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),

          // Empty state
          Icon(Icons.cloud_upload, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('No attachments yet', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text(
            'Add photos, files, or voice notes to provide more context',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),

          // Add buttons
          if (widget.isEditable) ...[const SizedBox(height: 24), _buildAddButtons(context)],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.attach_file, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text('Attachments', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const Spacer(),
        Text('${_filteredAttachments.length} ${_filteredAttachments.length == 1 ? 'item' : 'items'}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final types = AttachmentType.values;
    final typeCounts = <AttachmentType, int>{};

    for (final attachment in widget.attachments) {
      typeCounts[attachment.type] = (typeCounts[attachment.type] ?? 0) + 1;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // All filter
          FilterChip(
            label: Text('All (${widget.attachments.length})'),
            selected: _selectedFilter == null,
            onSelected: (selected) {
              setState(() {
                _selectedFilter = selected ? null : _selectedFilter;
              });
            },
          ),
          const SizedBox(width: 8),

          // Type filters
          ...types.map((type) {
            final count = typeCounts[type] ?? 0;
            if (count == 0) return const SizedBox.shrink();

            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: FilterChip(
                avatar: Icon(_getTypeIcon(type), size: 16, color: _selectedFilter == type ? Colors.white : _getTypeColor(type)),
                label: Text('${_getTypeName(type)} ($count)'),
                selected: _selectedFilter == type,
                selectedColor: _getTypeColor(type),
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = selected ? type : null;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAttachmentGrid(BuildContext context) {
    final attachments = _filteredAttachments;

    if (attachments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.filter_list, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No attachments match this filter', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600])),
          ],
        ),
      );
    }

    // Separate images from other files for different layouts
    final images = attachments.where((a) => a.type == AttachmentType.image).toList();
    final others = attachments.where((a) => a.type != AttachmentType.image).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image grid
        if (images.isNotEmpty) ...[_buildImageGrid(context, images), if (others.isNotEmpty) const SizedBox(height: 16)],

        // Other files list
        if (others.isNotEmpty) _buildFileList(context, others),
      ],
    );
  }

  Widget _buildImageGrid(BuildContext context, List<TaskAttachment> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final attachment = images[index];
        return _buildImageTile(context, attachment);
      },
    );
  }

  Widget _buildImageTile(BuildContext context, TaskAttachment attachment) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onAttachmentTap?.call(attachment);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Stack(
          children: [
            // Image preview
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey[200],
                child: attachment.thumbnailPath != null ? Image.asset(attachment.thumbnailPath!, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder()) : _buildImagePlaceholder(),
              ),
            ),

            // Delete button
            if (widget.isEditable && widget.onAttachmentDelete != null)
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    widget.onAttachmentDelete?.call(attachment);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: const Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.image, color: Colors.grey[400], size: 32),
    );
  }

  Widget _buildFileList(BuildContext context, List<TaskAttachment> files) {
    return Column(children: files.map((attachment) => _buildFileTile(context, attachment)).toList());
  }

  Widget _buildFileTile(BuildContext context, TaskAttachment attachment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onAttachmentTap?.call(attachment);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // File icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: attachment.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(attachment.icon, color: attachment.color, size: 20),
                ),
                const SizedBox(width: 12),

                // File info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attachment.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text('${attachment.sizeFormatted} • ${_formatDate(attachment.createdAt)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                    ],
                  ),
                ),

                // Actions
                if (widget.isEditable && widget.onAttachmentDelete != null)
                  IconButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      widget.onAttachmentDelete?.call(attachment);
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                    iconSize: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButtons(BuildContext context) {
    return Row(
      children: [
        if (widget.onAddPhoto != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.selectionClick();
                widget.onAddPhoto!();
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Photo'),
            ),
          ),

        if (widget.onAddPhoto != null && widget.onAddFile != null) const SizedBox(width: 8),

        if (widget.onAddFile != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.selectionClick();
                widget.onAddFile!();
              },
              icon: const Icon(Icons.attach_file),
              label: const Text('File'),
            ),
          ),

        if ((widget.onAddPhoto != null || widget.onAddFile != null) && widget.onAddVoiceNote != null) const SizedBox(width: 8),

        if (widget.onAddVoiceNote != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.selectionClick();
                widget.onAddVoiceNote!();
              },
              icon: const Icon(Icons.mic),
              label: const Text('Voice'),
            ),
          ),
      ],
    );
  }

  IconData _getTypeIcon(AttachmentType type) {
    switch (type) {
      case AttachmentType.image:
        return Icons.image;
      case AttachmentType.video:
        return Icons.videocam;
      case AttachmentType.audio:
        return Icons.audiotrack;
      case AttachmentType.document:
        return Icons.description;
      case AttachmentType.archive:
        return Icons.archive;
      case AttachmentType.other:
        return Icons.attach_file;
    }
  }

  Color _getTypeColor(AttachmentType type) {
    switch (type) {
      case AttachmentType.image:
        return Colors.green;
      case AttachmentType.video:
        return Colors.red;
      case AttachmentType.audio:
        return Colors.purple;
      case AttachmentType.document:
        return Colors.blue;
      case AttachmentType.archive:
        return Colors.orange;
      case AttachmentType.other:
        return Colors.grey;
    }
  }

  String _getTypeName(AttachmentType type) {
    switch (type) {
      case AttachmentType.image:
        return 'Images';
      case AttachmentType.video:
        return 'Videos';
      case AttachmentType.audio:
        return 'Audio';
      case AttachmentType.document:
        return 'Documents';
      case AttachmentType.archive:
        return 'Archives';
      case AttachmentType.other:
        return 'Other';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// Helper class for creating sample attachments
class AttachmentSamples {
  static List<TaskAttachment> getSampleAttachments() {
    return [
      TaskAttachment(
        id: '1',
        name: 'project_mockup.png',
        path: '/path/to/mockup.png',
        type: AttachmentType.image,
        size: 2048576, // 2MB
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        thumbnailPath: 'assets/images/empty_tasks.png',
      ),
      TaskAttachment(
        id: '2',
        name: 'requirements.pdf',
        path: '/path/to/requirements.pdf',
        type: AttachmentType.document,
        size: 512000, // 500KB
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TaskAttachment(
        id: '3',
        name: 'meeting_notes.mp3',
        path: '/path/to/notes.mp3',
        type: AttachmentType.audio,
        size: 1536000, // 1.5MB
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];
  }
}
