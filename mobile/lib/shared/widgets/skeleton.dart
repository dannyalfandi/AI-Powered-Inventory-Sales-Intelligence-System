/// Loading placeholders shaped like the content that is coming.
///
/// A centred spinner tells you only that something is happening. A skeleton
/// tells you *what* is happening — four cards here, a chart there, a list of
/// rows below — so the page does not jump when the data lands and the wait
/// feels shorter than the same milliseconds spent watching a circle.
///
/// Rules for anything added here:
///
///  * Match the real layout's box sizes and gaps, or the content will shift
///    when it arrives. That shift is the thing skeletons exist to avoid.
///  * Never animate a value the user is trying to read; a skeleton has no
///    content, which is exactly why it is safe to animate.
///  * Under "reduce motion" the shimmer stops and the boxes stay flat. They
///    still communicate the shape, which is most of the benefit.
library;

import 'package:flutter/material.dart';

import '../theme/app_motion.dart';
import '../theme/app_spacing.dart';

/// Wraps a tree of [SkeletonBox]es and sweeps a highlight across all of them
/// together, so one loading area reads as a single object rather than a dozen
/// independently blinking rectangles.
class Skeleton extends StatefulWidget {
  const Skeleton({super.key, required this.child});

  final Widget child;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: AppMotion.shimmer);

  @override
  void initState() {
    super.initState();
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = scheme.surfaceContainerHighest;
    final highlight = Color.alphaBlend(scheme.surface.withValues(alpha: 0.55), base);

    // Excluded from semantics: a screen reader should hear the loading
    // announcement, not a description of six grey rectangles.
    final content = ExcludeSemantics(child: widget.child);

    if (AppMotion.reduced(context)) {
      _controller.stop();
      return content;
    }
    if (!_controller.isAnimating) _controller.repeat();

    return AnimatedBuilder(
      animation: _controller,
      child: content,
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) {
          // Travels from fully off the left to fully off the right, so the
          // highlight enters and leaves instead of popping at the edges.
          final dx = bounds.width * (_controller.value * 3 - 1.5);
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [base, highlight, base],
            stops: const [0.35, 0.5, 0.65],
            transform: _SlideGradient(dx),
          ).createShader(bounds);
        },
        child: child,
      ),
    );
  }
}

class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.dx);

  final double dx;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) => Matrix4.translationValues(dx, 0, 0);
}

/// One grey block. Sized like the thing it stands in for.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, this.height = 14, this.radius = AppRadius.sm});

  /// Null means "as wide as the parent allows".
  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

/// Placeholder for a list of `ListTile`-shaped rows: avatar, title, subtitle.
///
/// [widths] varies the title length down the list; identical rows look like a
/// rendering bug rather than content on its way.
class SkeletonList extends StatelessWidget {
  const SkeletonList({
    super.key,
    this.rows = 6,
    this.hasLeading = true,
    this.padding = const EdgeInsets.symmetric(vertical: AppSpacing.sm),
  });

  final int rows;
  final bool hasLeading;
  final EdgeInsets padding;

  static const _widths = [0.62, 0.45, 0.72, 0.38, 0.55, 0.66];

  @override
  Widget build(BuildContext context) {
    // shrinkWrap, because this is dropped into three different parents: a
    // Scaffold body (bounded and tall), a dashboard card (unbounded), and a
    // bottom-sheet picker (bounded and short). Sizing to content covers the
    // first two, and leaving it scrollable stops the third from overflowing.
    return Skeleton(
      key: const Key('skeleton_list'),
      child: ListView(
        padding: padding,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          for (var i = 0; i < rows; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Row(
                children: [
                  if (hasLeading) ...[
                    const SkeletonBox(width: 40, height: 40, radius: 20),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _widths[i % _widths.length],
                          child: const SkeletonBox(height: 15),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _widths[(i + 3) % _widths.length] * 0.8,
                          child: const SkeletonBox(height: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  const SkeletonBox(width: 54, height: 18),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Placeholder for the dashboard's 2×2 grid of summary cards.
class SkeletonSummaryGrid extends StatelessWidget {
  const SkeletonSummaryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      key: const Key('skeleton_summary_grid'),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1.75,
        children: [
          for (var i = 0; i < 4; i++)
            Container(
              padding: AppSpacing.allMd,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                borderRadius: AppRadius.mdAll,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [SkeletonBox(width: 76, height: 11), SkeletonBox(width: 104, height: 22)],
              ),
            ),
        ],
      ),
    );
  }
}

/// Placeholder for a chart: bars of varying height under a baseline, so the
/// shape reads as "a chart" rather than "a grey rectangle".
class SkeletonChart extends StatelessWidget {
  const SkeletonChart({super.key, this.height = 180});

  final double height;

  static const _heights = [0.45, 0.7, 0.35, 0.85, 0.55, 0.95, 0.6, 0.4];

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      key: const Key('skeleton_chart'),
      child: SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final h in _heights)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  child: SkeletonBox(height: height * h, radius: AppRadius.sm),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for a block of text lines — insights, a paragraph, a form.
class SkeletonLines extends StatelessWidget {
  const SkeletonLines({super.key, this.lines = 3, this.hasLeading = false});

  final int lines;
  final bool hasLeading;

  static const _widths = [0.9, 0.75, 0.82, 0.6];

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      key: const Key('skeleton_lines'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < lines; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                children: [
                  if (hasLeading) ...[
                    const SkeletonBox(width: 32, height: 32, radius: 16),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _widths[i % _widths.length],
                      child: const SkeletonBox(height: 13),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Placeholder for an edit form: a stack of labelled input boxes and a button.
class SkeletonForm extends StatelessWidget {
  const SkeletonForm({super.key, this.fields = 4});

  final int fields;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      key: const Key('skeleton_form'),
      child: ListView(
        padding: AppSpacing.allLg,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (var i = 0; i < fields; i++) ...[
            const SkeletonBox(width: 96, height: 11),
            const SizedBox(height: AppSpacing.sm),
            const SkeletonBox(height: 52, radius: AppRadius.md),
            const SizedBox(height: AppSpacing.lg),
          ],
          const SizedBox(height: AppSpacing.sm),
          const SkeletonBox(height: 48, radius: AppRadius.md),
        ],
      ),
    );
  }
}

/// Placeholder for a detail page: a heading, a couple of meta lines, then a
/// card's worth of rows.
class SkeletonDetail extends StatelessWidget {
  const SkeletonDetail({super.key, this.rows = 3});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      key: const Key('skeleton_detail'),
      child: ListView(
        padding: AppSpacing.allLg,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SkeletonBox(width: 180, height: 22),
          const SizedBox(height: AppSpacing.md),
          const SkeletonBox(width: 240, height: 12),
          const SizedBox(height: AppSpacing.xl),
          for (var i = 0; i < rows; i++) ...[
            Row(
              children: [
                const Expanded(child: SkeletonBox(height: 15)),
                const SizedBox(width: AppSpacing.xl),
                const SkeletonBox(width: 72, height: 15),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}
