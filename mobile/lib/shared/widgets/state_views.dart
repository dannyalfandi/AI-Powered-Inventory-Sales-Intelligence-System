import 'package:flutter/material.dart';

import '../../core/error/failure.dart';
import '../../core/l10n/l10n.dart';
import '../theme/app_motion.dart';
import '../theme/app_spacing.dart';

/// User-facing message for any error that reaches the UI.
///
/// Two sources, one rule: a [Failure] the app produced itself carries a
/// [FailureIssue] and is written from the ARB files; a failure that carries a
/// backend message shows that message as it is, because the API already
/// answered in the language this app asked for.
String errorMessage(BuildContext context, Object error) {
  final l10n = context.l10n;
  if (error is Failure) {
    final issue = error.issue;
    if (issue != null) {
      return switch (issue) {
        FailureIssue.timeout => l10n.networkTimeout,
        FailureIssue.cancelled => l10n.networkCancelled,
        FailureIssue.unreachable => l10n.networkUnreachable,
        FailureIssue.malformedResponse => error is ServerFailure && error.statusCode != null
            ? l10n.networkServerError('${error.statusCode}')
            : l10n.networkServerErrorUnknown,
        // A form rejected locally: the fields carry the detail, the banner
        // only needs to say that something needs fixing.
        FailureIssue.localValidation => l10n.commonValidationFailed,
      };
    }
    if (error.message.isNotEmpty) return error.message;
  }
  return l10n.commonUnexpectedError;
}



class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: AppSpacing.allXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: AppSpacing.md),
            Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              FilledButton.tonalIcon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(context.l10n.commonRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.message, this.icon = Icons.inbox_outlined, this.action});

  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: AppSpacing.allXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EmptyIcon(icon: icon),
            const SizedBox(height: AppSpacing.md),
            Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
            if (action != null) ...[const SizedBox(height: AppSpacing.lg), action!],
          ],
        ),
      ),
    );
  }
}

/// The icon of an empty state, easing up to full size as the state appears.
///
/// An empty screen arriving with a hard cut reads as a failed load. A short
/// settle says "there is genuinely nothing here" — so the motion is doing a
/// job, not decorating. The text next to it is not animated: the sentence that
/// explains what to do must be readable on the first frame.
class _EmptyIcon extends StatelessWidget {
  const _EmptyIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outline;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppMotion.durationOf(context, AppMotion.normal),
      curve: AppMotion.enter,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.scale(scale: 0.88 + 0.12 * t, child: child),
      ),
      child: Icon(icon, size: 48, color: color),
    );
  }
}
