import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/theme/app_status_colors.dart';
import '../../domain/entities/inventory.dart';

extension MovementTypeLabel on MovementType {
  /// Needs a context because the label is read from the ARB files; the enum
  /// value itself (`in`/`out`/`adjustment`) is what travels to the API.
  String label(BuildContext context) => switch (this) {
        MovementType.stockIn => context.l10n.movementLabelIn,
        MovementType.stockOut => context.l10n.movementLabelOut,
        MovementType.adjustment => context.l10n.movementLabelAdjustment,
      };

  IconData get icon => switch (this) {
        MovementType.stockIn => Icons.south_west,
        MovementType.stockOut => Icons.north_east,
        MovementType.adjustment => Icons.tune,
      };
}

/// One stock history entry: "+5 In", "−4 Out" or "= 7 Adjustment",
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
    // Stock arriving is positive, stock leaving is negative, a correction is
    // neither — the same three meanings the rest of the app uses.
    final colors = AppStatusColors.of(context);
    final color = switch (m.type) {
      MovementType.stockIn => colors.positive.accent,
      MovementType.stockOut => colors.negative.accent,
      MovementType.adjustment => colors.info.accent,
    };
    final when = formatDateTime(m.createdAt);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        foregroundColor: color,
        child: Icon(m.type.icon, size: 20),
      ),
      title: Text('$amount  ${m.type.label(context)}'),
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
