import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/l10n/l10n.dart';
import 'core/locale/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/appearance_provider.dart';
import 'features/auth/presentation/providers/permission_refresher.dart';
import 'shared/theme/app_theme.dart';

class InventoryApp extends ConsumerStatefulWidget {
  const InventoryApp({super.key});

  @override
  ConsumerState<InventoryApp> createState() => _InventoryAppState();
}

class _InventoryAppState extends ConsumerState<InventoryApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Permissions are read at start-up and login; a Super Admin may change
    // them while the app is in the background. Back in the foreground,
    // re-read them (throttled), so tabs and buttons follow without a new
    // login. Reading the refresher here also starts its 403 listener.
    final refresher = ref.read(permissionRefresherProvider);
    _lifecycle = AppLifecycleListener(onResume: refresher.onResumed);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The locale comes from the user's choice (stored), not from the device:
    // the same setting also decides the Accept-Language of every API call, so
    // the UI and the server's messages always speak the same language.
    final locale = ref.watch(appLocaleProvider);
    // Both themes are rebuilt from the chosen accent, and MaterialApp picks
    // between them with themeMode — so switching accent or mode re-themes the
    // whole app in place, with Flutter cross-fading the colours for us.
    final accent = ref.watch(accentControllerProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(accent),
      darkTheme: AppTheme.dark(accent),
      themeMode: ref.watch(themeModeControllerProvider),
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
