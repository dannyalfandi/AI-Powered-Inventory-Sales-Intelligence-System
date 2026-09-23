import 'package:flutter/material.dart';

/// One status colour, as the three values a widget actually needs.
///
/// Keeping them together is what stops a badge from being drawn with a fill
/// from one place and a text colour from another — the pairing is the thing
/// that is contrast-checked, so it travels as a pair.
@immutable
class StatusPalette {
  const StatusPalette({required this.container, required this.onContainer, required this.accent});

  /// Fill behind a badge or chip.
  final Color container;

  /// Text and icons drawn on [container]. At least 7:1 against it.
  final Color onContainer;

  /// The same status drawn *on the page surface* — a chart line, an arrow, a
  /// number that must not sit in a box. At least 4.5:1 against the surface,
  /// which is why it is a different (darker/lighter) value than [container].
  final Color accent;

  StatusPalette lerpTo(StatusPalette other, double t) => StatusPalette(
        container: Color.lerp(container, other.container, t)!,
        onContainer: Color.lerp(onContainer, other.onContainer, t)!,
        accent: Color.lerp(accent, other.accent, t)!,
      );
}

/// Semantic status colours, shared by everything that reports a state:
/// trend badges, order-status badges, stock levels, movement rows.
///
/// They are deliberately *not* derived from the accent colour. The accent is
/// the user's choice and can be any of six hues; "sales are down" has to read
/// as down whichever one they picked, so these stay fixed and are only
/// re-tuned per brightness.
///
/// Five roles cover the whole app, and each maps to a fixed meaning:
///
/// | role       | used by                                              |
/// |------------|------------------------------------------------------|
/// | [positive] | rising trend, shipped order, healthy stock, stock in  |
/// | [negative] | falling trend, out of stock, stock out                |
/// | [warning]  | low stock, an order still waiting to be confirmed     |
/// | [info]     | a confirmed order, an adjustment — noted, not urgent  |
/// | [neutral]  | a steady trend, a cancelled order — nothing to act on |
///
/// Every pairing is checked by `test/shared/theme/status_contrast_test.dart`,
/// which fails the build if a value is edited below WCAG AA.
@immutable
class AppStatusColors extends ThemeExtension<AppStatusColors> {
  const AppStatusColors({
    required this.positive,
    required this.negative,
    required this.warning,
    required this.info,
    required this.neutral,
  });

  final StatusPalette positive;
  final StatusPalette negative;
  final StatusPalette warning;
  final StatusPalette info;
  final StatusPalette neutral;

  /// Light mode: pale tinted fills with a deep text colour on top. The fills
  /// are a step more saturated than Material's own tonal containers so a badge
  /// still separates from a near-white card without needing an outline.
  static const light = AppStatusColors(
    positive: StatusPalette(
      container: Color(0xFFBEE8CE),
      onContainer: Color(0xFF0C4428),
      accent: Color(0xFF136B3E),
    ),
    negative: StatusPalette(
      container: Color(0xFFF8CBC7),
      onContainer: Color(0xFF73170F),
      accent: Color(0xFFB3261E),
    ),
    warning: StatusPalette(
      container: Color(0xFFF6D99E),
      onContainer: Color(0xFF5A3705),
      accent: Color(0xFF8A5300),
    ),
    info: StatusPalette(
      container: Color(0xFFC8DAF7),
      onContainer: Color(0xFF0F3566),
      accent: Color(0xFF1B4E96),
    ),
    neutral: StatusPalette(
      container: Color(0xFFD7DBE0),
      onContainer: Color(0xFF35393F),
      accent: Color(0xFF5A6068),
    ),
  );

  /// Dark mode: the relationship inverts — a deep desaturated fill with a
  /// light tint on top. The hues are pulled back from the light values because
  /// a saturated green or red glows unpleasantly on a dark surface.
  static const dark = AppStatusColors(
    positive: StatusPalette(
      container: Color(0xFF123526),
      onContainer: Color(0xFF9FE3B8),
      accent: Color(0xFF63CE93),
    ),
    negative: StatusPalette(
      container: Color(0xFF4E1F1F),
      onContainer: Color(0xFFFFB4AB),
      accent: Color(0xFFFF897D),
    ),
    warning: StatusPalette(
      container: Color(0xFF3D2E0E),
      onContainer: Color(0xFFF0CB80),
      accent: Color(0xFFE0B25C),
    ),
    info: StatusPalette(
      container: Color(0xFF152F4D),
      onContainer: Color(0xFFA9CBF5),
      accent: Color(0xFF8FBBF0),
    ),
    neutral: StatusPalette(
      container: Color(0xFF2B2F34),
      onContainer: Color(0xFFC4C9CF),
      accent: Color(0xFF9BA2AA),
    ),
  );

  static AppStatusColors of(BuildContext context) =>
      Theme.of(context).extension<AppStatusColors>() ?? light;

  /// Every role in the order of the table above — for tests and for the
  /// Settings preview, so a new role cannot be added without both seeing it.
  Map<String, StatusPalette> get all => {
        'positive': positive,
        'negative': negative,
        'warning': warning,
        'info': info,
        'neutral': neutral,
      };

  @override
  AppStatusColors copyWith({
    StatusPalette? positive,
    StatusPalette? negative,
    StatusPalette? warning,
    StatusPalette? info,
    StatusPalette? neutral,
  }) =>
      AppStatusColors(
        positive: positive ?? this.positive,
        negative: negative ?? this.negative,
        warning: warning ?? this.warning,
        info: info ?? this.info,
        neutral: neutral ?? this.neutral,
      );

  @override
  AppStatusColors lerp(ThemeExtension<AppStatusColors>? other, double t) {
    if (other is! AppStatusColors) return this;
    return AppStatusColors(
      positive: positive.lerpTo(other.positive, t),
      negative: negative.lerpTo(other.negative, t),
      warning: warning.lerpTo(other.warning, t),
      info: info.lerpTo(other.info, t),
      neutral: neutral.lerpTo(other.neutral, t),
    );
  }
}
