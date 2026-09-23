import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

/// A number that counts up to its value when it first appears or changes.
///
/// The motion is there to say *this figure just changed* — which matters on a
/// dashboard where changing the date range silently rewrites four numbers at
/// once. It is deliberately not a decoration:
///
///  * it never delays the real value — the widget is laid out at the final
///    string's width, and a user who looks away and back sees the answer;
///  * it runs for [AppMotion.counter] (about half a second) and stops;
///  * under "reduce motion" it renders the final value with no tween at all.
///
/// [format] turns the interpolated number into the string to show, so the same
/// widget handles a plain count and a Rupiah amount without knowing about
/// either.
class AnimatedCount extends StatelessWidget {
  const AnimatedCount({
    super.key,
    required this.value,
    required this.format,
    this.style,
    this.maxLines = 1,
  });

  final num value;
  final String Function(num value) format;
  final TextStyle? style;
  final int maxLines;

  static const _firstPaintFrom = 0.72;

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.durationOf(context, AppMotion.counter);
    final text = format(value);

    if (duration == Duration.zero) {
      return Text(text, style: style, maxLines: maxLines, overflow: TextOverflow.ellipsis);
    }

    return TweenAnimationBuilder<double>(
      // On first paint it counts over the last quarter of the way rather than
      // up from zero: "Rp 0" racing up reads for a moment as *no sales today*,
      // which is a different and alarming fact. Starting at 72% keeps every
      // frame the right order of magnitude while still clearly moving.
      //
      // When `value` later changes, TweenAnimationBuilder re-bases `begin` on
      // the figure currently shown, so a date-range change counts from the old
      // number to the new one and this fraction no longer applies.
      tween: Tween(begin: value.toDouble() * _firstPaintFrom, end: value.toDouble()),
      duration: duration,
      curve: AppMotion.emphasized,
      builder: (context, animated, _) => Semantics(
        // The finished string is the label throughout, so a screen reader is
        // never handed a half-counted number.
        label: text,
        child: ExcludeSemantics(
          child: Text(
            format(animated),
            style: style,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
