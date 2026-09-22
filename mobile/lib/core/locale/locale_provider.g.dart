// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// SharedPreferences, resolved once at startup and overridden in main() so the
/// rest of the app (and the tests) can read it synchronously.

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// SharedPreferences, resolved once at startup and overridden in main() so the
/// rest of the app (and the tests) can read it synchronously.

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  /// SharedPreferences, resolved once at startup and overridden in main() so the
  /// rest of the app (and the tests) can read it synchronously.
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'bdf49748bece142c907bc28d050b90b97094eaa9';

/// The language the whole app runs in: it drives `MaterialApp.locale` and the
/// `Accept-Language` header of every API call, so the UI and the messages the
/// backend writes always agree.

@ProviderFor(LanguageController)
final languageControllerProvider = LanguageControllerProvider._();

/// The language the whole app runs in: it drives `MaterialApp.locale` and the
/// `Accept-Language` header of every API call, so the UI and the messages the
/// backend writes always agree.
final class LanguageControllerProvider
    extends $NotifierProvider<LanguageController, AppLanguage> {
  /// The language the whole app runs in: it drives `MaterialApp.locale` and the
  /// `Accept-Language` header of every API call, so the UI and the messages the
  /// backend writes always agree.
  LanguageControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'languageControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$languageControllerHash();

  @$internal
  @override
  LanguageController create() => LanguageController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLanguage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLanguage>(value),
    );
  }
}

String _$languageControllerHash() =>
    r'd81509ecd5df712c94ca39e5d5cac47c20d1d3ef';

/// The language the whole app runs in: it drives `MaterialApp.locale` and the
/// `Accept-Language` header of every API call, so the UI and the messages the
/// backend writes always agree.

abstract class _$LanguageController extends $Notifier<AppLanguage> {
  AppLanguage build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppLanguage, AppLanguage>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppLanguage, AppLanguage>,
              AppLanguage,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The active locale, for `MaterialApp.locale`.

@ProviderFor(appLocale)
final appLocaleProvider = AppLocaleProvider._();

/// The active locale, for `MaterialApp.locale`.

final class AppLocaleProvider
    extends $FunctionalProvider<Locale, Locale, Locale>
    with $Provider<Locale> {
  /// The active locale, for `MaterialApp.locale`.
  AppLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLocaleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLocaleHash();

  @$internal
  @override
  $ProviderElement<Locale> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Locale create(Ref ref) {
    return appLocale(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$appLocaleHash() => r'ea4ab66a3916b06870b08b4a1d8e113747668188';
