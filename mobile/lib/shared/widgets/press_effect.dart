import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

/// Shrinks its child a hair while a finger is down on it.
///
/// Material's ink splash already says "this is tappable", but on a dense list
/// of rows the splash spreads across the whole tile and is easy to miss on a
/// bright screen outdoors. A 1.5% scale reads instantly and at a glance.
///
/// It wraps rather than replaces the existing tap handling: the child keeps
/// its own `InkWell`/`ListTile` `onTap`, and this listens to raw pointer
/// events alongside it. So a press is still cancelled correctly when the
/// finger slides away, and nothing about hit-testing or semantics changes.
///
/// Costs one [AnimatedScale] per row and no rebuild of the child, and under
/// "reduce motion" it does nothing at all.
class PressEffect extends StatefulWidget {
  const PressEffect({super.key, required this.child, this.enabled = true});

  final Widget child;

  /// False for rows that are not tappable, so they do not react to a scroll
  /// that happens to start on them.
  final bool enabled;

  @override
  State<PressEffect> createState() => _PressEffectState();
}

class _PressEffectState extends State<PressEffect> {
  bool _down = false;

  void _set(bool down) {
    if (_down != down) setState(() => _down = down);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || AppMotion.reduced(context)) return widget.child;

    return Listener(
      // Behaviour is deliberately "translucent": the child's own gesture
      // detectors still receive everything, this only observes.
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down ? 0.985 : 1,
        duration: AppMotion.durationOf(context, AppMotion.fast),
        curve: AppMotion.enter,
        child: widget.child,
      ),
    );
  }
}
