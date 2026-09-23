// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Single shared Dio instance for the whole app.
///
/// It watches the language: the backend localizes its messages from
/// `Accept-Language`, so switching language in Settings must change what the
/// server writes too, not only the app's own labels.

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Single shared Dio instance for the whole app.
///
/// It watches the language: the backend localizes its messages from
/// `Accept-Language`, so switching language in Settings must change what the
/// server writes too, not only the app's own labels.

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Single shared Dio instance for the whole app.
  ///
  /// It watches the language: the backend localizes its messages from
  /// `Accept-Language`, so switching language in Settings must change what the
  /// server writes too, not only the app's own labels.
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'a5bb59349a67188b8d641272c0a0789a9bf601d9';
