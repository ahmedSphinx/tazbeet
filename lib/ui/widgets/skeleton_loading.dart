import 'package:flutter/material.dart';

/// Skeleton loading widget for creating shimmer effects
class SkeletonLoader extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Duration duration;

  const SkeletonLoader({super.key, required this.child, this.isLoading = true, this.duration = const Duration(milliseconds: 1500)});

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    if (widget.isLoading) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(SkeletonLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [Colors.transparent, Colors.white54, Colors.transparent],
              stops: [_animation.value - 0.3, _animation.value, _animation.value + 0.3].map((stop) => stop.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

/// Skeleton container with rounded corners
class SkeletonContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;

  const SkeletonContainer({super.key, this.width, this.height, this.borderRadius, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: borderRadius ?? BorderRadius.circular(8)),
    );
  }
}

/// Skeleton text line
class SkeletonText extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsetsGeometry? margin;

  const SkeletonText({super.key, this.width, this.height = 16, this.margin});

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(width: width, height: height, margin: margin, borderRadius: BorderRadius.circular(height / 2));
  }
}

/// Skeleton for task details screen components
class TaskDetailsSkeleton extends StatelessWidget {
  const TaskDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Skeleton App Bar
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: Colors.grey[200],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.grey[300]!, Colors.grey[200]!], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: const Center(child: SkeletonContainer(width: 200, height: 24, borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SkeletonLoader(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Action Bar Skeleton
                    _buildActionBarSkeleton(),
                    const SizedBox(height: 16),

                    // Essential Info Card Skeleton
                    _buildEssentialInfoSkeleton(),
                    const SizedBox(height: 16),

                    // Focus Assistant Skeleton
                    _buildFocusAssistantSkeleton(),
                    const SizedBox(height: 16),

                    // Reminder Skeleton
                    _buildReminderSkeleton(),
                    const SizedBox(height: 16),

                    // Subtasks Skeleton
                    _buildSubtasksSkeleton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBarSkeleton() {
    return Row(
      children: [
        Expanded(flex: 7, child: SkeletonContainer(height: 48, borderRadius: BorderRadius.circular(16))),
        const SizedBox(width: 12),
        Expanded(flex: 3, child: SkeletonContainer(height: 48, borderRadius: BorderRadius.circular(16))),
      ],
    );
  }

  Widget _buildEssentialInfoSkeleton() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                SkeletonContainer(width: 24, height: 24, borderRadius: BorderRadius.circular(12)),
                const SizedBox(width: 12),
                const SkeletonText(width: 120, height: 20),
              ],
            ),
            const SizedBox(height: 16),

            // Info rows
            ...List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    SkeletonContainer(width: 32, height: 32, borderRadius: BorderRadius.circular(8)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonText(width: 80, height: 12, margin: EdgeInsets.only(bottom: 4)),
                          SkeletonText(width: double.infinity, height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFocusAssistantSkeleton() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                SkeletonContainer(width: 24, height: 24, borderRadius: BorderRadius.circular(12)),
                const SizedBox(width: 12),
                const SkeletonText(width: 140, height: 20),
              ],
            ),
            const SizedBox(height: 16),

            // Progress Ring
            const SkeletonContainer(width: 120, height: 120, borderRadius: BorderRadius.all(Radius.circular(60))),
            const SizedBox(height: 16),

            // Button
            SkeletonContainer(width: double.infinity, height: 48, borderRadius: BorderRadius.circular(16)),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderSkeleton() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                SkeletonContainer(width: 24, height: 24, borderRadius: BorderRadius.circular(12)),
                const SizedBox(width: 12),
                const SkeletonText(width: 120, height: 20),
              ],
            ),
            const SizedBox(height: 16),

            // Suggestion box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonText(width: double.infinity, height: 16),
                  const SizedBox(height: 8),
                  const SkeletonText(width: 200, height: 14),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(child: SkeletonContainer(height: 40, borderRadius: BorderRadius.circular(12))),
                const SizedBox(width: 8),
                Expanded(child: SkeletonContainer(height: 40, borderRadius: BorderRadius.circular(12))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtasksSkeleton() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                SkeletonContainer(width: 24, height: 24, borderRadius: BorderRadius.circular(12)),
                const SizedBox(width: 12),
                const SkeletonText(width: 80, height: 20),
              ],
            ),
            const SizedBox(height: 16),

            // Subtask items
            ...List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SkeletonContainer(width: 20, height: 20, borderRadius: BorderRadius.circular(10)),
                    const SizedBox(width: 12),
                    Expanded(child: SkeletonText(width: double.infinity, height: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
