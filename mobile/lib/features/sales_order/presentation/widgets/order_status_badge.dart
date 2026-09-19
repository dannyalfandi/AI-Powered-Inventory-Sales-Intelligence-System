import 'package:flutter/material.dart';

import '../../domain/entities/sales_order.dart';

extension OrderStatusText on OrderStatus {
  String get label => switch (this) {
        OrderStatus.pending => 'Menunggu',
        OrderStatus.confirmed => 'Dikonfirmasi',
        OrderStatus.shipped => 'Dikirim',
        OrderStatus.cancelled => 'Dibatalkan',
      };

  IconData get icon => switch (this) {
        OrderStatus.pending => Icons.schedule,
        OrderStatus.confirmed => Icons.inventory_2_outlined,
        OrderStatus.shipped => Icons.local_shipping_outlined,
        OrderStatus.cancelled => Icons.cancel_outlined,
      };

  /// Button text for moving an order *to* this status.
  String get actionLabel => switch (this) {
        OrderStatus.confirmed => 'Konfirmasi',
        OrderStatus.shipped => 'Kirim',
        OrderStatus.cancelled => 'Batalkan',
        OrderStatus.pending => 'Tandai menunggu',
      };
}

/// Colored status chip. Every status also has its own icon and label, so
/// the color is never the only signal.
class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final (bg, fg) = switch (status) {
      OrderStatus.pending => (scheme.tertiaryContainer, scheme.onTertiaryContainer),
      OrderStatus.confirmed => (scheme.primaryContainer, scheme.onPrimaryContainer),
      OrderStatus.shipped => dark
          ? (const Color(0xFF1B5E20), const Color(0xFFC8E6C9))
          : (const Color(0xFFD7F2DA), const Color(0xFF1B5E20)),
      OrderStatus.cancelled => (scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
    };

    return Container(
      key: ValueKey('status_badge_${status.name}'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(status.label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: fg)),
        ],
      ),
    );
  }
}
