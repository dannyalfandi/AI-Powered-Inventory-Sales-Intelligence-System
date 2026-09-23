import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_status_colors.dart';
import '../../domain/entities/sales_order.dart';

extension OrderStatusText on OrderStatus {
  /// Needs a context because the wording is read from the ARB files; the
  /// enum value (`pending`, `confirmed`, …) is what travels to the API.
  String label(BuildContext context) => switch (this) {
        OrderStatus.pending => context.l10n.orderStatusPending,
        OrderStatus.confirmed => context.l10n.orderStatusConfirmed,
        OrderStatus.shipped => context.l10n.orderStatusShipped,
        OrderStatus.cancelled => context.l10n.orderStatusCancelled,
      };

  IconData get icon => switch (this) {
        OrderStatus.pending => Icons.schedule,
        OrderStatus.confirmed => Icons.inventory_2_outlined,
        OrderStatus.shipped => Icons.local_shipping_outlined,
        OrderStatus.cancelled => Icons.cancel_outlined,
      };

  /// Which of the five semantic statuses this order state belongs to, so the
  /// badge is coloured from the same palette as trends and stock levels
  /// instead of its own private set of greens.
  StatusPalette palette(AppStatusColors colors) => switch (this) {
        OrderStatus.pending => colors.warning,
        OrderStatus.confirmed => colors.info,
        OrderStatus.shipped => colors.positive,
        OrderStatus.cancelled => colors.neutral,
      };

  /// Button text for moving an order *to* this status.
  String actionLabel(BuildContext context) => switch (this) {
        OrderStatus.confirmed => context.l10n.orderActionConfirm,
        OrderStatus.shipped => context.l10n.orderActionShip,
        OrderStatus.cancelled => context.l10n.orderActionCancel,
        OrderStatus.pending => context.l10n.orderActionMarkPending,
      };
}

/// Colored status chip. Every status also has its own icon and label, so
/// the color is never the only signal.
class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final palette = status.palette(AppStatusColors.of(context));

    return Container(
      key: ValueKey('status_badge_${status.name}'),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(color: palette.container, borderRadius: AppRadius.smAll),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: palette.onContainer),
          const SizedBox(width: AppSpacing.xs),
          Text(
            status.label(context),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: palette.onContainer),
          ),
        ],
      ),
    );
  }
}
