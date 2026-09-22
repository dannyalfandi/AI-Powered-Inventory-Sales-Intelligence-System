import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/locale/locale_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  /// A container backed by an in-memory SharedPreferences seeded with
  /// [stored], the way a fresh install (null) or a returning user looks.
  Future<(ProviderContainer, SharedPreferences)> makeContainer({String? stored}) async {
    SharedPreferences.setMockInitialValues(stored == null ? {} : {languagePreferenceKey: stored});
    final preferences = await SharedPreferences.getInstance();
    final container = ProviderContainer.test(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      retry: (_, _) => null,
    );
    return (container, preferences);
  }

  group('AppLanguage.fromCode', () {
    final cases = <({String name, String? code, AppLanguage want})>[
      (name: 'null falls back to English', code: null, want: AppLanguage.english),
      (name: 'en', code: 'en', want: AppLanguage.english),
      (name: 'id', code: 'id', want: AppLanguage.indonesian),
      (name: 'region tag keeps the base language', code: 'id-ID', want: AppLanguage.indonesian),
      (name: 'underscore tag', code: 'en_US', want: AppLanguage.english),
      (name: 'uppercase', code: 'ID', want: AppLanguage.indonesian),
      (name: 'unsupported language falls back', code: 'fr', want: AppLanguage.english),
      (name: 'junk falls back', code: '', want: AppLanguage.english),
    ];
    for (final c in cases) {
      test(c.name, () => expect(AppLanguage.fromCode(c.code), c.want));
    }
  });

  test('defaults to English when nothing was stored', () async {
    final (container, _) = await makeContainer();

    expect(container.read(languageControllerProvider), AppLanguage.english);
    expect(container.read(appLocaleProvider), const Locale('en'));
  });

  test('starts in the stored language', () async {
    final (container, _) = await makeContainer(stored: 'id');

    expect(container.read(languageControllerProvider), AppLanguage.indonesian);
    expect(container.read(appLocaleProvider), const Locale('id'));
  });

  test('a language the app no longer supports falls back to English', () async {
    final (container, _) = await makeContainer(stored: 'fr');

    expect(container.read(languageControllerProvider), AppLanguage.english);
  });

  test('select switches the locale and persists the choice', () async {
    final (container, preferences) = await makeContainer();
    container.listen(appLocaleProvider, (_, _) {});

    await container.read(languageControllerProvider.notifier).select(AppLanguage.indonesian);

    expect(container.read(languageControllerProvider), AppLanguage.indonesian);
    expect(container.read(appLocaleProvider), const Locale('id'));
    expect(preferences.getString(languagePreferenceKey), 'id');
  });

  test('the stored choice survives a restart', () async {
    final (first, preferences) = await makeContainer();
    await first.read(languageControllerProvider.notifier).select(AppLanguage.indonesian);

    // Same storage, new provider graph — as if the app were launched again.
    final restarted = ProviderContainer.test(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      retry: (_, _) => null,
    );

    expect(restarted.read(languageControllerProvider), AppLanguage.indonesian);
  });

  test('selecting the language already active writes nothing', () async {
    final (container, preferences) = await makeContainer();

    await container.read(languageControllerProvider.notifier).select(AppLanguage.english);

    expect(container.read(languageControllerProvider), AppLanguage.english);
    expect(preferences.getString(languagePreferenceKey), isNull);
  });
}
