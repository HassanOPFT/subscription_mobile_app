import 'package:flutter/material.dart';

class SubscriptionCardSkeleton extends StatelessWidget {
  const SubscriptionCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final skeletonColor = colorScheme.onSurface.withOpacity(0.1);
    final shimmerColor = colorScheme.onSurface.withOpacity(0.05);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SkeletonContainer(
                  width: 150,
                  height: 20,
                  skeletonColor: skeletonColor,
                  shimmerColor: shimmerColor,
                ),
                _SkeletonContainer(
                  width: 80,
                  height: 20,
                  skeletonColor: skeletonColor,
                  shimmerColor: shimmerColor,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SkeletonContainer(
                  width: 100,
                  height: 16,
                  skeletonColor: skeletonColor,
                  shimmerColor: shimmerColor,
                ),
                _SkeletonContainer(
                  width: 80,
                  height: 24,
                  skeletonColor: skeletonColor,
                  shimmerColor: shimmerColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonContainer extends StatefulWidget {
  final double width;
  final double height;
  final Color skeletonColor;
  final Color shimmerColor;

  const _SkeletonContainer({
    Key? key,
    required this.width,
    required this.height,
    required this.skeletonColor,
    required this.shimmerColor,
  }) : super(key: key);

  @override
  State<_SkeletonContainer> createState() => _SkeletonContainerState();
}

class _SkeletonContainerState extends State<_SkeletonContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    
    _colorAnimation = ColorTween(
      begin: widget.skeletonColor,
      end: widget.shimmerColor,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}