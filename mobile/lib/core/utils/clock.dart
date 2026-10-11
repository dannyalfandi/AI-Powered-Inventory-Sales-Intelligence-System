import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clock.g.dart';

/// The current time, injectable: tests override it to move time forward
/// (e.g. past a throttle window) without waiting.
@Riverpod(keepAlive: true)
DateTime Function() clock(Ref ref) => DateTime.now;
