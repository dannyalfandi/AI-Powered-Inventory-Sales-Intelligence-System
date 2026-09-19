import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  runApp(
    ProviderScope(
      // Riverpod 3 retries failed providers automatically. Our failures are
      // user-facing (offline, 404, validation), so show them and let the user
      // retry explicitly instead of silently retrying in the background.
      retry: (retryCount, error) => null,
      child: const InventoryApp(),
    ),
  );
}
