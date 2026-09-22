import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/l10n/l10n.dart';
import 'package:inventory_intel/core/locale/locale_provider.dart';
import 'package:inventory_intel/features/settings/presentation/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences preferences;

  Future<void> pumpSettings(WidgetTester tester, {String? stored}) async {
    SharedPreferences.setMockInitialValues(stored == null ? {} : {languagePreferenceKey: stored});
    preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
        retry: (_, _) => null,
        child: Consumer(
          // Watches the locale the same way InventoryApp does, so the test
          // sees the whole "switch language → app re-renders" path.
          builder: (context, ref, _) => MaterialApp(
            locale: ref.watch(appLocaleProvider),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SettingsScreen(),
          ),
        ),
      ),
    );
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
}
