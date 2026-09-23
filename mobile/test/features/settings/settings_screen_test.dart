import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/l10n/l10n.dart';
import 'package:inventory_intel/core/locale/locale_provider.dart';
import 'package:inventory_intel/core/theme/appearance_provider.dart';
import 'package:inventory_intel/features/settings/presentation/screens/settings_screen.dart';
import 'package:inventory_intel/shared/theme/app_accent.dart';
import 'package:inventory_intel/shared/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences preferences;

  Future<void> pumpSettings(WidgetTester tester, {String? stored, Map<String, Object> prefs = const {}}) async {
    SharedPreferences.setMockInitialValues({
      languagePreferenceKey: ?stored,
      ...prefs,
    });
    preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
        retry: (_, _) => null,
        child: Consumer(
          // Watches locale, theme mode and accent exactly the way InventoryApp
          // does, so the tests exercise the whole "change a setting → the app
          // re-themes itself" path rather than just the notifier.
          builder: (context, ref, _) => MaterialApp(
            locale: ref.watch(appLocaleProvider),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.light(ref.watch(accentControllerProvider)),
            darkTheme: AppTheme.dark(ref.watch(accentControllerProvider)),
            themeMode: ref.watch(themeModeControllerProvider),
            home: const SettingsScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The brightness the app is actually painting in, read from the theme the
  /// Settings page itself is rendered with.
  Brightness renderedBrightness(WidgetTester tester) =>
      Theme.of(tester.element(find.byType(SettingsScreen))).brightness;

  ColorScheme renderedScheme(WidgetTester tester) =>
      Theme.of(tester.element(find.byType(SettingsScreen))).colorScheme;

  /// The accent swatches sit below the fold on a test-sized screen, so a plain
  /// `tap` would dispatch outside the viewport and hit nothing.
  Future<void> tapAccent(WidgetTester tester, String code) async {
    final swatch = find.byKey(ValueKey('accent_option_$code'));
    await tester.ensureVisible(swatch);
    await tester.pumpAndSettle();
    await tester.tap(swatch);
    await tester.pumpAndSettle();
  }

  RadioListTile<AppLanguage> optionFor(WidgetTester tester, String code) =>
      tester.widget<RadioListTile<AppLanguage>>(find.byKey(ValueKey('language_option_$code')));

  testWidgets('opens in English with English selected', (tester) async {
    await pumpSettings(tester);

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(optionFor(tester, 'en').value, AppLanguage.english);
    expect(tester.widget<RadioGroup<AppLanguage>>(find.byType(RadioGroup<AppLanguage>)).groupValue,
        AppLanguage.english);
  });

  testWidgets('both languages are offered, each written in its own language', (tester) async {
    await pumpSettings(tester);

    expect(find.text('English'), findsOneWidget);
    expect(find.text('Bahasa Indonesia'), findsOneWidget);
  });

  testWidgets('picking Indonesian retitles the page immediately, without a restart', (tester) async {
    await pumpSettings(tester);

    await tester.tap(find.byKey(const ValueKey('language_option_id')));
    await tester.pumpAndSettle();

    expect(find.text('Pengaturan'), findsOneWidget);
    expect(find.text('Bahasa'), findsOneWidget);
    expect(find.text('Settings'), findsNothing);
    expect(tester.widget<RadioGroup<AppLanguage>>(find.byType(RadioGroup<AppLanguage>)).groupValue,
        AppLanguage.indonesian);
  });

  testWidgets('the choice is written to storage', (tester) async {
    await pumpSettings(tester);

    await tester.tap(find.byKey(const ValueKey('language_option_id')));
    await tester.pumpAndSettle();

    expect(preferences.getString(languagePreferenceKey), 'id');
  });

  testWidgets('a stored choice is shown as selected on open', (tester) async {
    await pumpSettings(tester, stored: 'id');

    expect(find.text('Pengaturan'), findsOneWidget);
    expect(tester.widget<RadioGroup<AppLanguage>>(find.byType(RadioGroup<AppLanguage>)).groupValue,
        AppLanguage.indonesian);
  });

  testWidgets('switching back to English works too', (tester) async {
    await pumpSettings(tester, stored: 'id');

    await tester.tap(find.byKey(const ValueKey('language_option_en')));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(preferences.getString(languagePreferenceKey), 'en');
  });

  group('appearance', () {
    testWidgets('offers the three theme modes and follows the system by default', (tester) async {
      await pumpSettings(tester);

      expect(find.text('Appearance'), findsOneWidget);
      final selector = tester.widget<SegmentedButton<ThemeMode>>(find.byKey(const Key('theme_mode_selector')));
      expect(selector.segments.map((s) => s.value), ThemeMode.values);
      expect(selector.selected, {ThemeMode.system});
    });

    testWidgets('picking Dark repaints the page dark straight away', (tester) async {
      await pumpSettings(tester);
      expect(renderedBrightness(tester), Brightness.light);

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      expect(renderedBrightness(tester), Brightness.dark);
      expect(preferences.getString(themeModePreferenceKey), 'dark');
    });

    testWidgets('a stored dark mode is already applied on open', (tester) async {
      await pumpSettings(tester, prefs: {themeModePreferenceKey: 'dark'});

      expect(renderedBrightness(tester), Brightness.dark);
    });

    testWidgets('every accent preset is offered as a swatch', (tester) async {
      await pumpSettings(tester);

      for (final accent in AppAccent.values) {
        expect(
          find.byKey(ValueKey('accent_option_${accent.code}')),
          findsOneWidget,
          reason: '${accent.code} has no swatch',
        );
      }
    });

    testWidgets('picking an accent re-themes the app and is remembered', (tester) async {
      await pumpSettings(tester);
      final before = renderedScheme(tester).primary;

      await tapAccent(tester, 'magenta');

      final after = renderedScheme(tester).primary;
      expect(after, isNot(before));
      expect(after, AppTheme.light(AppAccent.magenta).colorScheme.primary);
      expect(preferences.getString(accentPreferenceKey), 'magenta');
    });

    testWidgets('a stored accent is applied on open', (tester) async {
      await pumpSettings(tester, prefs: {accentPreferenceKey: 'indigo'});

      expect(renderedScheme(tester).primary, AppTheme.light(AppAccent.indigo).colorScheme.primary);
    });

    testWidgets('the preview sits above the controls so the accent can be seen', (tester) async {
      await pumpSettings(tester);

      expect(find.byKey(const Key('accent_preview')), findsOneWidget);
      // It shows a status colour too, which is the point: that green does not
      // change with the accent.
      expect(find.text('Up 12%'), findsOneWidget);
    });

    testWidgets('accent and theme mode are independent', (tester) async {
      await pumpSettings(tester);

      await tapAccent(tester, 'violet');
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      expect(renderedBrightness(tester), Brightness.dark);
      expect(renderedScheme(tester).primary, AppTheme.dark(AppAccent.violet).colorScheme.primary);
    });

    testWidgets('appearance labels follow the language', (tester) async {
      await pumpSettings(tester, stored: 'id');

      expect(find.text('Tampilan'), findsOneWidget);
      expect(find.text('Gelap'), findsOneWidget);
      expect(find.text('Warna aksen'), findsOneWidget);
    });
  });
}
