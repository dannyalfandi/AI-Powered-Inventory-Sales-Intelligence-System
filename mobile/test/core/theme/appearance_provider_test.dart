import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/locale/locale_provider.dart';
import 'package:inventory_intel/core/theme/appearance_provider.dart';
import 'package:inventory_intel/shared/theme/app_accent.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  /// A container over in-memory storage seeded with [stored] — a fresh install
  /// when empty, a returning user otherwise.
  Future<(ProviderContainer, SharedPreferences)> makeContainer({Map<String, Object> stored = const {}}) async {
    SharedPreferences.setMockInitialValues(stored);
    final preferences = await SharedPreferences.getInstance();
    final container = ProviderContainer.test(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      retry: (_, _) => null,
    );
    return (container, preferences);
  }

  group('themeModeFromName', () {
    final cases = <({String name, String? stored, ThemeMode want})>[
      (name: 'nothing stored follows the system', stored: null, want: ThemeMode.system),
      (name: 'light', stored: 'light', want: ThemeMode.light),
      (name: 'dark', stored: 'dark', want: ThemeMode.dark),
      (name: 'system', stored: 'system', want: ThemeMode.system),
      (name: 'an unknown value follows the system', stored: 'sepia', want: ThemeMode.system),
    ];
    for (final c in cases) {
      test(c.name, () => expect(themeModeFromName(c.stored), c.want));
    }
  });

  group('ThemeModeController', () {
    test('defaults to following the system', () async {
      final (container, _) = await makeContainer();

      expect(container.read(themeModeControllerProvider), ThemeMode.system);
    });

    test('starts in the stored mode', () async {
      final (container, _) = await makeContainer(stored: {themeModePreferenceKey: 'dark'});

      expect(container.read(themeModeControllerProvider), ThemeMode.dark);
    });

    test('select switches and persists', () async {
      final (container, preferences) = await makeContainer();

      await container.read(themeModeControllerProvider.notifier).select(ThemeMode.dark);

      expect(container.read(themeModeControllerProvider), ThemeMode.dark);
      expect(preferences.getString(themeModePreferenceKey), 'dark');
    });

    test('the choice survives a restart', () async {
      final (first, preferences) = await makeContainer();
      await first.read(themeModeControllerProvider.notifier).select(ThemeMode.light);

      // Same storage, a new provider graph — as if the app were relaunched.
      final restarted = ProviderContainer.test(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
        retry: (_, _) => null,
      );

      expect(restarted.read(themeModeControllerProvider), ThemeMode.light);
    });

    test('re-selecting the active mode writes nothing', () async {
      final (container, preferences) = await makeContainer();

      await container.read(themeModeControllerProvider.notifier).select(ThemeMode.system);

      expect(preferences.getString(themeModePreferenceKey), isNull);
    });
  });

  group('AccentController', () {
    test('defaults to the original brand colour', () async {
      final (container, _) = await makeContainer();

      expect(container.read(accentControllerProvider), AppAccent.teal);
      expect(AppAccent.fallback, AppAccent.teal);
    });

    test('starts in the stored accent', () async {
      final (container, _) = await makeContainer(stored: {accentPreferenceKey: 'violet'});

      expect(container.read(accentControllerProvider), AppAccent.violet);
    });

    test('an accent the app no longer ships falls back', () async {
      final (container, _) = await makeContainer(stored: {accentPreferenceKey: 'chartreuse'});

      expect(container.read(accentControllerProvider), AppAccent.fallback);
    });

    test('select switches and persists', () async {
      final (container, preferences) = await makeContainer();

      await container.read(accentControllerProvider.notifier).select(AppAccent.magenta);

      expect(container.read(accentControllerProvider), AppAccent.magenta);
      expect(preferences.getString(accentPreferenceKey), 'magenta');
    });

    test('the choice survives a restart', () async {
      final (first, preferences) = await makeContainer();
      await first.read(accentControllerProvider.notifier).select(AppAccent.amber);

      final restarted = ProviderContainer.test(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
        retry: (_, _) => null,
      );

      expect(restarted.read(accentControllerProvider), AppAccent.amber);
    });

    test('re-selecting the active accent writes nothing', () async {
      final (container, preferences) = await makeContainer();

      await container.read(accentControllerProvider.notifier).select(AppAccent.teal);

      expect(preferences.getString(accentPreferenceKey), isNull);
    });
  });

  test('theme mode and accent are stored independently', () async {
    final (container, preferences) = await makeContainer();

    await container.read(themeModeControllerProvider.notifier).select(ThemeMode.dark);
    await container.read(accentControllerProvider.notifier).select(AppAccent.indigo);

    expect(preferences.getString(themeModePreferenceKey), 'dark');
    expect(preferences.getString(accentPreferenceKey), 'indigo');
    expect(container.read(themeModeControllerProvider), ThemeMode.dark);
    expect(container.read(accentControllerProvider), AppAccent.indigo);
  });
}
