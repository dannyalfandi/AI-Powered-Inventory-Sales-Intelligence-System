import 'package:flutter/material.dart';

import '../../core/error/failure.dart';
import '../../core/l10n/l10n.dart';

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

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: CircularProgressIndicator());
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}
