import 'package:flutter/material.dart';

/// Shown when the ML service is down (`forecast_available: false`).
///
/// Deliberately quiet: this is not a bug and not the user's fault, it is a
/// separate service that happens to be off, while the rest of the dashboard
/// is perfectly fine. So: muted colours, no red, no warning icon, and a
/// low-emphasis retry instead of a prominent button — the opposite of
/// [ErrorView], which means "something actually went wrong".
class UnavailableView extends StatelessWidget {
  const UnavailableView({
    super.key,
    required this.message,
    this.detail,
    this.onRetry,
    this.icon = Icons.insights_outlined,
  });

  final String message;
  final String? detail;
  final VoidCallback? onRetry;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: muted),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
          ),
          if (detail != null) ...[
            const SizedBox(height: 4),
            Text(
              detail!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: muted),
            ),
          ],
          if (onRetry != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
          ],
        ],
      ),
    );
  }
}
