import 'package:flutter/material.dart';

/// The type scale.
///
/// It stays on the platform's own UI font (Roboto on Android, SF on iOS)
/// rather than shipping a display face: an inventory app is read in a
/// warehouse on a cheap phone, and a bundled font costs startup and download
/// while a network-loaded one risks a flash of unstyled text. The personality
/// comes from the *scale* instead — a wider spread between levels, deliberate
/// weights, and tracking that tightens as text gets larger.
///
/// Three rules run through it:
///
///  * **Numbers outrank labels.** A figure on a dashboard card is `headline`
///    weight; the word next to it is a quiet `label`. That is the opposite of
///    Flutter's defaults, where both land near the same visual weight.
///  * **Tracking follows size.** Large text is set tight (negative tracking)
///    because default spacing looks loose at display sizes; small text is set
///    slightly open so it survives at 11–12px on a dense list.
///  * **Only two weights do the work**, 600 and 400. Medium (500) is reserved
///    for controls, so "bold" always means the same thing to the eye.
abstract final class AppTypography {
  /// Tabular figures, so a column of amounts does not jitter as digits change
  /// width — used for money and counts that sit above one another.
  static const tabularFigures = [FontFeature.tabularFigures()];

  static TextTheme apply(TextTheme base) {
    return base.copyWith(
      // Display — the one-off hero number (current stock on a product page).
      displaySmall: base.displaySmall?.copyWith(
        fontSize: 34,
        height: 1.15,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.8,
      ),

      // Headline — the value on a dashboard card, an order total.
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 23,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
      ),

      // Title — screen and section headings.
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 20,
        height: 1.25,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 16,
        height: 1.3,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 14,
        height: 1.35,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),

      // Body — sentences: error messages, descriptions, dialog copy.
      bodyLarge: base.bodyLarge?.copyWith(fontSize: 16, height: 1.45, letterSpacing: 0),
      bodyMedium: base.bodyMedium?.copyWith(fontSize: 14, height: 1.45, letterSpacing: 0.05),
      bodySmall: base.bodySmall?.copyWith(fontSize: 12.5, height: 1.4, letterSpacing: 0.1),

      // Label — buttons, chips, and the caption under a number.
      labelLarge: base.labelLarge?.copyWith(fontSize: 14, height: 1.2, fontWeight: FontWeight.w500,
          letterSpacing: 0.1),
      labelMedium: base.labelMedium?.copyWith(fontSize: 12, height: 1.2, fontWeight: FontWeight.w500,
          letterSpacing: 0.15),
      labelSmall: base.labelSmall?.copyWith(fontSize: 11, height: 1.2, fontWeight: FontWeight.w500,
          letterSpacing: 0.2),
    );
  }
}

/// Shorthands for the two treatments that recur all over the app, so screens
/// ask for the *role* instead of re-deriving a style from `titleLarge`.
extension AppTextStyles on TextTheme {
  /// A figure the user reads first: dashboard values, totals, stock counts.
  TextStyle? get metric => headlineSmall?.copyWith(fontFeatures: AppTypography.tabularFigures);

  /// The quiet word that explains a [metric].
  TextStyle? get metricLabel => labelMedium;
}
