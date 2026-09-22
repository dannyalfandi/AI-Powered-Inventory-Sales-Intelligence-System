import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/l10n/l10n.dart';

/// Every language the app ships, so a test can assert that a message is
/// produced correctly in all of them instead of pinning one wording.
const testLocales = [Locale('en'), Locale('id')];

/// Pumps a minimal localized app and hands [body] a [BuildContext] plus the
/// [AppLocalizations] for [locale].
///
/// Functions that turn a `Failure` into a sentence need a context now that
/// the sentences live in the ARB files, and the wording itself is not what a
/// test should assert — the test states which key the message must come from,
/// and this runs it once per supported language.
Future<void> withL10n(
  WidgetTester tester,
  Locale locale,
  void Function(BuildContext context, AppLocalizations l10n) body,
) async {
  late BuildContext captured;
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          captured = context;
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  body(captured, captured.l10n);
}

/// A [MaterialApp] with the app's localization delegates, for widget tests
/// that pump a screen directly. Without the delegates every `context.l10n`
/// in the tree throws, so this is the wrapper screen tests use instead of a
/// bare `MaterialApp`.
Widget localizedApp({Widget? home, RouterConfig<Object>? routerConfig, Locale locale = const Locale('en')}) {
  if (routerConfig != null) {
    return MaterialApp.router(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: routerConfig,
    );
  }
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );
}

/// The strings the pumped app is currently showing, so a test asserts which
/// message appears rather than pinning one language's wording.
AppLocalizations l10nOf(WidgetTester tester) => tester.element(find.byType(Navigator).first).l10n;
