import 'package:flutter/widgets.dart';

/// The spacing scale. Every gap, padding and inset in the app is one of these,
/// so blocks line up across screens instead of drifting by a pixel or two.
///
/// The steps are a 4pt grid that doubles: 4 / 8 / 12 / 16 / 24 / 32. Anything
/// that does not fit one of them is usually a sign that the layout, not the
/// number, needs rethinking.
abstract final class AppSpacing {
  /// 4 — between a label and the thing it labels.
  static const xs = 4.0;

  /// 8 — inside a chip or between two tightly related lines.
  static const sm = 8.0;

  /// 12 — grid gutters, padding inside a dense card.
  static const md = 12.0;

  /// 16 — the default screen margin and the gap between form fields.
  static const lg = 16.0;

  /// 24 — between two sections of a page.
  static const xl = 24.0;

  /// 32 — around a centred empty or error state.
  static const xxl = 32.0;

  /// Clears the floating action button at the end of a scrolling list.
  static const listBottomInset = 96.0;

  static const allSm = EdgeInsets.all(sm);
  static const allMd = EdgeInsets.all(md);
  static const allLg = EdgeInsets.all(lg);
  static const allXl = EdgeInsets.all(xl);

  /// The standard left/right page margin.
  static const pageHorizontal = EdgeInsets.symmetric(horizontal: lg);

  static const gapXs = SizedBox(height: xs, width: xs);
  static const gapSm = SizedBox(height: sm, width: sm);
  static const gapMd = SizedBox(height: md, width: md);
  static const gapLg = SizedBox(height: lg, width: lg);
  static const gapXl = SizedBox(height: xl, width: xl);
}

/// Corner radii. Three steps only, and they carry meaning: the bigger the
/// surface, the softer the corner, so size reads as hierarchy rather than
/// every box sharing one rounded look.
abstract final class AppRadius {
  /// 8 — badges, chips, small inline tags.
  static const sm = 8.0;

  /// 12 — cards, tiles, input fields.
  static const md = 12.0;

  /// 20 — sheets and dialogs.
  static const lg = 20.0;

  static const smAll = BorderRadius.all(Radius.circular(sm));
  static const mdAll = BorderRadius.all(Radius.circular(md));
  static const lgAll = BorderRadius.all(Radius.circular(lg));
}
