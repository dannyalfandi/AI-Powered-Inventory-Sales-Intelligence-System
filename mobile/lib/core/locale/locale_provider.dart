import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_provider.g.dart';

/// The languages the app ships. English is the default: the backend falls back
/// to Indonesian when a client sends no `Accept-Language`, so the app always
/// states what it wants instead of relying on that fallback.
enum AppLanguage {
  english('en'),
  indonesian('id');

  const AppLanguage(this.code);

  /// The tag used both for `Locale` and for the `Accept-Language` header.
  final String code;

  Locale get locale => Locale(code);

  static const fallback = AppLanguage.english;

  /// Parses a stored or system tag ("en", "en-US", "id"); unknown → [fallback].
  static AppLanguage fromCode(String? code) {
    if (code == null) return fallback;
    final base = code.split(RegExp('[-_]')).first.toLowerCase();
    return AppLanguage.values.firstWhere(
      (language) => language.code == base,
      orElse: () => fallback,
    );
  }
}

/// Key of the stored choice. Bumping it would reset everyone to the default.
const languagePreferenceKey = 'app_language';

/// SharedPreferences, resolved once at startup and overridden in main() so the
/// rest of the app (and the tests) can read it synchronously.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) =>
    throw UnimplementedError('sharedPreferencesProvider must be overridden in main()');

/// The language the whole app runs in: it drives `MaterialApp.locale` and the
/// `Accept-Language` header of every API call, so the UI and the messages the
/// backend writes always agree.
@Riverpod(keepAlive: true)
class LanguageController extends _$LanguageController {
  @override
  AppLanguage build() {
    final stored = ref.watch(sharedPreferencesProvider).getString(languagePreferenceKey);
    return AppLanguage.fromCode(stored);
  }

  /// Switches language and remembers it. The UI updates immediately; the
  /// write is awaited only so a caller can react to a storage failure.
  Future<void> select(AppLanguage language) async {
    if (state == language) return;
    state = language;
    await ref.read(sharedPreferencesProvider).setString(languagePreferenceKey, language.code);
  }
}

/// The active locale, for `MaterialApp.locale`.
@Riverpod(keepAlive: true)
Locale appLocale(Ref ref) => ref.watch(languageControllerProvider).locale;
