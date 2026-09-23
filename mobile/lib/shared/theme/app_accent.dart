import 'package:flutter/material.dart';

/// The accent colours a user can choose from in Settings.
///
/// A fixed set of six rather than a free colour picker, on purpose: every seed
/// here has been checked to produce a readable `ColorScheme.fromSeed` in both
/// light and dark mode. An open picker would let someone land on a yellow that
/// turns white-on-primary buttons unreadable, and no amount of runtime
/// clamping makes that pleasant.
///
/// The hues are spread around the wheel so the choice is obvious at a glance,
/// and all six stay away from the greens and reds used by [AppStatusColors] —
/// the accent must never be mistaken for "sales are up".
///
/// To add one: give it a stable [code] (it is what lands in storage), pick a
/// mid-tone seed, and add a `settingsAccent<Name>` key to both ARB files.
/// `test/shared/theme/status_contrast_test.dart` then checks it automatically.
enum AppAccent {
  /// The original brand colour, so an existing install looks unchanged.
  teal('teal', Color(0xFF0F766E)),
  indigo('indigo', Color(0xFF4353B0)),
  violet('violet', Color(0xFF7A4BC4)),
  magenta('magenta', Color(0xFFB03A79)),
  amber('amber', Color(0xFF9A6410)),
  slate('slate', Color(0xFF4A5A6B));

  const AppAccent(this.code, this.seed);

  /// Stored in SharedPreferences; never shown to the user.
  final String code;

  /// Fed to `ColorScheme.fromSeed`, which derives the rest of the palette.
  final Color seed;

  static const fallback = AppAccent.teal;

  /// Parses a stored code; anything unknown (an old or hand-edited value)
  /// falls back rather than throwing on startup.
  static AppAccent fromCode(String? code) => AppAccent.values.firstWhere(
        (accent) => accent.code == code,
        orElse: () => fallback,
      );
}
