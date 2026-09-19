import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/inventory.dart';

extension MovementTypeLabel on MovementType {
  String get label => switch (this) {
        MovementType.stockIn => 'Masuk',
        MovementType.stockOut => 'Keluar',
        MovementType.adjustment => 'Penyesuaian',
      };

  IconData get icon => switch (this) {
        MovementType.stockIn => Icons.south_west,
        MovementType.stockOut => Icons.north_east,
        MovementType.adjustment => Icons.tune,
      };
}

/// One stock history entry: "+5 Masuk", "−4 Keluar" or "= 7 Penyesuaian",
/// with the balance change on the right.
class MovementTile extends StatelessWidget {
  const MovementTile({super.key, required this.movement});

  final StockMovement movement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final m = movement;
    final amount = switch (m.type) {
      MovementType.stockIn => '+${m.quantity}',
      MovementType.stockOut => '−${m.quantity}',
      MovementType.adjustment => '= ${m.quantity}',
    };
    final color = switch (m.type) {
      MovementType.stockIn => theme.colorScheme.primary,
      MovementType.stockOut => theme.colorScheme.error,
      MovementType.adjustment => theme.colorScheme.tertiary,
    };
    final when = formatDateTime(m.createdAt);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        foregroundColor: color,
        child: Icon(m.type.icon, size: 20),
      ),
      title: Text('$amount  ${m.type.label}'),
      subtitle: Text(
        m.reason.isEmpty ? when : '${m.reason} · $when',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        '${m.quantityBefore} → ${m.quantityAfter}',
        style: theme.textTheme.titleSmall,
      ),
    );
  }
}
