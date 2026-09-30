import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/theme/app_spacing.dart';

/// Shown only at start-up while a stored session is checked against the
/// server (GET /auth/me); the router leaves it for the Dashboard or /login.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppSpacing.lg),
            Text(context.l10n.splashCheckingSession),
          ],
        ),
      ),
    );
  }
}
