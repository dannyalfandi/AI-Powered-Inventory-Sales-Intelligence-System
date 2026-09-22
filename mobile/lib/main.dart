import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/locale/locale_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Read the stored language before the first frame, so the app never starts
  // in one language and switches to another a moment later.
  final preferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      // Riverpod 3 retries failed providers automatically. Our failures are
      // user-facing (offline, 404, validation), so show them and let the user
      // retry explicitly instead of silently retrying in the background.
      retry: (retryCount, error) => null,
      child: const InventoryApp(),
    ),
  );
}
