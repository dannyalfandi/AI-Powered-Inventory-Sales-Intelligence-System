import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/auth/session_events.dart';
import '../../../../core/utils/clock.dart';
import 'auth_controller.dart';

part 'permission_refresher.g.dart';

/// Decides *when* to re-read the user's permissions (`/auth/me`), so that a
/// role changed by a Super Admin reaches the app without a new login:
///
/// - [onResumed] — the app came back to the foreground. Throttled: at most
///   one call per [minInterval] (60 s), whatever the trigger.
/// - [onForbidden] — a business endpoint answered 403. Debounced: a burst of
///   403s (several sections failing together) becomes one call, [debounce]
///   after the last one. Not throttled — a 403 is direct evidence that the
///   permissions changed.
///
/// Calls never overlap: while one is in flight, another trigger joins it.
/// [now] is injectable so the throttle can be tested without waiting.
class PermissionRefresher {
  PermissionRefresher({
    required this._refresh,
    required this._now,
    this.minInterval = const Duration(seconds: 60),
    this.debounce = const Duration(milliseconds: 800),
  });

  final Future<void> Function() _refresh;
  final DateTime Function() _now;
  final Duration minInterval;
  final Duration debounce;

  DateTime? _lastStarted;
  Future<void>? _inFlight;
  Timer? _debounceTimer;

  /// The app is in the foreground again.
  Future<void> onResumed() {
    final last = _lastStarted;
    if (last != null && _now().difference(last) < minInterval) return Future.value();
    return _run();
  }

  /// A business endpoint answered 403.
  void onForbidden() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounce, () => unawaited(_run()));
  }

  Future<void> _run() {
    final running = _inFlight;
    if (running != null) return running;
    _lastStarted = _now();
    return _inFlight = _refresh().whenComplete(() => _inFlight = null);
  }

  void dispose() => _debounceTimer?.cancel();
}

/// The app's [PermissionRefresher]: refreshes through
/// [AuthController.refreshPermissions], and hears every 403 the network layer
/// reports ([permissionDeniedProvider]). `InventoryApp` creates it at start
/// and calls [PermissionRefresher.onResumed] on every resume.
@Riverpod(keepAlive: true)
PermissionRefresher permissionRefresher(Ref ref) {
  final refresher = PermissionRefresher(
    refresh: () => ref.read(authControllerProvider.notifier).refreshPermissions(),
    now: ref.watch(clockProvider),
  );
  // A 403 storm can't become an /auth/me storm: onForbidden debounces.
  ref.listen(permissionDeniedProvider, (_, _) => refresher.onForbidden());
  ref.onDispose(refresher.dispose);
  return refresher;
}
