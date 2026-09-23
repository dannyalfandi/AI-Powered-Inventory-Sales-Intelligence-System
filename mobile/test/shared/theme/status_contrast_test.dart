import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/shared/theme/app_accent.dart';
import 'package:inventory_intel/shared/theme/app_status_colors.dart';
import 'package:inventory_intel/shared/theme/app_theme.dart';

/// WCAG 2.1 relative luminance.
double _luminance(Color c) {
  double channel(double v) => v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * channel(c.r) + 0.7152 * channel(c.g) + 0.0722 * channel(c.b);
}

/// WCAG 2.1 contrast ratio, 1.0 (identical) to 21.0 (black on white).
double contrast(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

/// Guards the palette against a well-meaning tweak that makes a status
/// unreadable. Colour is the one thing in this app that cannot be checked by
/// looking at a green test run, so it is checked numerically instead.
void main() {
  // WCAG AA for body text. Every pairing here carries words, not just a fill,
  // so the stricter threshold applies rather than the 3:1 one for UI shapes.
  const aaText = 4.5;

  // A badge has to be distinguishable from the card it sits on. WCAG does not
  // cover background-on-background, so this is our own floor — set just under
  // the palette's real values to catch a drift toward invisible, not to
  // demand a loud fill.
  const chipSeparation = 1.25;

  group('status palette contrast', () {
    final modes = {
      'light': (AppStatusColors.light, AppTheme.light().colorScheme),
      'dark': (AppStatusColors.dark, AppTheme.dark().colorScheme),
    };

    for (final MapEntry(key: mode, value: (colors, scheme)) in modes.entries) {
      for (final MapEntry(key: role, value: palette) in colors.all.entries) {
        test('$mode/$role: text on the badge meets AA', () {
          expect(
            contrast(palette.container, palette.onContainer),
            greaterThanOrEqualTo(aaText),
            reason: '$mode $role onContainer is not readable on its container',
          );
        });

        test('$mode/$role: the accent meets AA on the page surface', () {
          expect(
            contrast(palette.accent, scheme.surface),
            greaterThanOrEqualTo(aaText),
            reason: '$mode $role accent is not readable as text or an icon on the surface',
          );
        });

        test('$mode/$role: the badge separates from the surface', () {
          expect(
            contrast(palette.container, scheme.surface),
            greaterThanOrEqualTo(chipSeparation),
            reason: '$mode $role container is too close to the surface to read as a badge',
          );
        });
      }
    }

    test('the two modes define the same set of roles', () {
      expect(AppStatusColors.light.all.keys, AppStatusColors.dark.all.keys);
    });
  });

  group('accent presets', () {
    // A free colour picker was rejected precisely so this can be guaranteed;
    // a new preset that breaks it fails here rather than in someone's hands.
    for (final accent in AppAccent.values) {
      for (final entry in {
        'light': AppTheme.light(accent).colorScheme,
        'dark': AppTheme.dark(accent).colorScheme,
      }.entries) {
        final mode = entry.key;
        final scheme = entry.value;

        test('${accent.code}/$mode: label on a filled button meets AA', () {
          expect(contrast(scheme.primary, scheme.onPrimary), greaterThanOrEqualTo(aaText));
        });

        test('${accent.code}/$mode: body text meets AA on the surface', () {
          expect(contrast(scheme.surface, scheme.onSurface), greaterThanOrEqualTo(aaText));
        });

        test('${accent.code}/$mode: text on a tonal container meets AA', () {
          expect(contrast(scheme.primaryContainer, scheme.onPrimaryContainer), greaterThanOrEqualTo(aaText));
        });
      }
    }

    test('codes are unique and stable — they are what lands in storage', () {
      final codes = AppAccent.values.map((a) => a.code).toList();
      expect(codes.toSet().length, codes.length);
    });

    test('an unknown stored code falls back instead of throwing', () {
      expect(AppAccent.fromCode('chartreuse'), AppAccent.fallback);
      expect(AppAccent.fromCode(null), AppAccent.fallback);
      expect(AppAccent.fromCode(''), AppAccent.fallback);
    });
  });

  group('theme wiring', () {
    test('both themes carry the status extension', () {
      expect(AppTheme.light().extension<AppStatusColors>(), AppStatusColors.light);
      expect(AppTheme.dark().extension<AppStatusColors>(), AppStatusColors.dark);
    });

    test('the accent changes the palette but never the status colours', () {
      final teal = AppTheme.light(AppAccent.teal);
      final magenta = AppTheme.light(AppAccent.magenta);

      expect(teal.colorScheme.primary, isNot(magenta.colorScheme.primary));
      expect(
        teal.extension<AppStatusColors>()!.positive.accent,
        magenta.extension<AppStatusColors>()!.positive.accent,
      );
    });
  });
}
