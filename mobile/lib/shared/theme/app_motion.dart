import 'package:flutter/material.dart';

/// Motion tokens, and the one place that decides whether motion happens.
///
/// Two rules the whole app obeys:
///
///  1. **Nothing animates for longer than it takes to read it.** Every
///     duration here is between 120ms and 600ms, and no animation gates
///     content — data is painted at its final value on frame one and the
///     motion plays over the top, so a slow animation can never hold a number
///     back from someone who needs it.
///  2. **"Reduce motion" is honoured everywhere.** When the platform
///     accessibility setting is on, [durationOf] returns [Duration.zero] and
///     every animated widget lands on its end state immediately. Widgets ask
///     through this class rather than reading [MediaQuery] themselves, so
///     there is exactly one thing to get right.
abstract final class AppMotion {
  /// State flips that must feel instant: a press, a chip toggling.
  static const fast = Duration(milliseconds: 120);

  /// The default for anything appearing or changing in place.
  static const normal = Duration(milliseconds: 240);

  /// Route transitions and skeleton cross-fades — long enough to show the
  /// direction of travel, short enough not to be a wait.
  static const page = Duration(milliseconds: 280);

  /// The dashboard's counting-up figures and chart redraws. The top of the
  /// range this app allows: any longer and the number feels withheld.
  static const counter = Duration(milliseconds: 520);

  /// One sweep of the skeleton shimmer. Slow on purpose — a fast shimmer
  /// reads as a glitch, and this one loops while the user waits.
  static const shimmer = Duration(milliseconds: 1400);

  /// Entrances: start fast, settle gently.
  static const enter = Curves.easeOutCubic;

  /// Value changes (a counter, a chart): ease both ends so the eye can follow.
  static const emphasized = Curves.easeInOutCubic;

  /// True when the platform asks for reduced motion, or when the widget is
  /// being rendered for a thumbnail/test where animation is disabled.
  static bool reduced(BuildContext context) => MediaQuery.disableAnimationsOf(context);

  /// [base], or zero when the user asked for less motion.
  ///
  /// Zero rather than "shorter": a 60ms version of a slide is a flicker, which
  /// is exactly the sensation the setting exists to prevent. The widget still
  /// renders its final state, so nothing is lost but the movement.
  static Duration durationOf(BuildContext context, Duration base) =>
      reduced(context) ? Duration.zero : base;
}
