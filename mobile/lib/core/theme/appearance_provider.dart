import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/theme/app_accent.dart';
import '../locale/locale_provider.dart';

part 'appearance_provider.g.dart';

/// Keys of the stored choices. Changing one resets everybody to the default,
/// so treat them as part of the app's storage contract.
const themeModePreferenceKey = 'app_theme_mode';
const accentPreferenceKey = 'app_accent';

/// Parses a stored `ThemeMode` name; anything unknown means "follow the
/// system", which is also what a fresh install gets.
ThemeMode themeModeFromName(String? name) => switch (name) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

/// Light / dark / follow-the-system, remembered across launches.
///
/// Same shape as [LanguageController]: state is read straight out of
/// SharedPreferences in `build`, so the first frame is already correct and
/// there is no async gap where the app shows the wrong theme.
@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  @override
  ThemeMode build() =>
      themeModeFromName(ref.watch(sharedPreferencesProvider).getString(themeModePreferenceKey));

  Future<void> select(ThemeMode mode) async {
    if (state == mode) return;
    state = mode;
    await ref.read(sharedPreferencesProvider).setString(themeModePreferenceKey, mode.name);
  }
}

/// The accent colour the whole palette is generated from.
///
/// Only the seed is stored. Both `ColorScheme`s are derived from it at build
/// time, so a preset can be re-tuned later without migrating anyone's
/// preference.
@Riverpod(keepAlive: true)
class AccentController extends _$AccentController {
  @override
  AppAccent build() =>
      AppAccent.fromCode(ref.watch(sharedPreferencesProvider).getString(accentPreferenceKey));

  Future<void> select(AppAccent accent) async {
    if (state == accent) return;
    state = accent;
    await ref.read(sharedPreferencesProvider).setString(accentPreferenceKey, accent.code);
  }
}
