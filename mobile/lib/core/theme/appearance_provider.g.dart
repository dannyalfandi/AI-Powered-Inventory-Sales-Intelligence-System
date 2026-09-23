// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appearance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Light / dark / follow-the-system, remembered across launches.
///
/// Same shape as [LanguageController]: state is read straight out of
/// SharedPreferences in `build`, so the first frame is already correct and
/// there is no async gap where the app shows the wrong theme.

@ProviderFor(ThemeModeController)
final themeModeControllerProvider = ThemeModeControllerProvider._();

/// Light / dark / follow-the-system, remembered across launches.
///
/// Same shape as [LanguageController]: state is read straight out of
/// SharedPreferences in `build`, so the first frame is already correct and
/// there is no async gap where the app shows the wrong theme.
final class ThemeModeControllerProvider
    extends $NotifierProvider<ThemeModeController, ThemeMode> {
  /// Light / dark / follow-the-system, remembered across launches.
  ///
  /// Same shape as [LanguageController]: state is read straight out of
  /// SharedPreferences in `build`, so the first frame is already correct and
  /// there is no async gap where the app shows the wrong theme.
  ThemeModeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeControllerHash();

  @$internal
  @override
  ThemeModeController create() => ThemeModeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeModeControllerHash() =>
    r'2c5a10f12e9f8696423758223804778621bd087f';

/// Light / dark / follow-the-system, remembered across launches.
///
/// Same shape as [LanguageController]: state is read straight out of
/// SharedPreferences in `build`, so the first frame is already correct and
/// there is no async gap where the app shows the wrong theme.

abstract class _$ThemeModeController extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeMode, ThemeMode>,
              ThemeMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The accent colour the whole palette is generated from.
///
/// Only the seed is stored. Both `ColorScheme`s are derived from it at build
/// time, so a preset can be re-tuned later without migrating anyone's
/// preference.

@ProviderFor(AccentController)
final accentControllerProvider = AccentControllerProvider._();

/// The accent colour the whole palette is generated from.
///
/// Only the seed is stored. Both `ColorScheme`s are derived from it at build
/// time, so a preset can be re-tuned later without migrating anyone's
/// preference.
final class AccentControllerProvider
    extends $NotifierProvider<AccentController, AppAccent> {
  /// The accent colour the whole palette is generated from.
  ///
  /// Only the seed is stored. Both `ColorScheme`s are derived from it at build
  /// time, so a preset can be re-tuned later without migrating anyone's
  /// preference.
  AccentControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accentControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accentControllerHash();

  @$internal
  @override
  AccentController create() => AccentController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppAccent value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppAccent>(value),
    );
  }
}

String _$accentControllerHash() => r'c41694be3f7d75ac922ebc05aca87d6fd26bf264';

/// The accent colour the whole palette is generated from.
///
/// Only the seed is stored. Both `ColorScheme`s are derived from it at build
/// time, so a preset can be re-tuned later without migrating anyone's
/// preference.

abstract class _$AccentController extends $Notifier<AppAccent> {
  AppAccent build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppAccent, AppAccent>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppAccent, AppAccent>,
              AppAccent,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
