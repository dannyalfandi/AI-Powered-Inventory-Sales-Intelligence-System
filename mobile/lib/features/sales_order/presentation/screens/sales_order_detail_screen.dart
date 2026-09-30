import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/permissions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_refresh_indicator.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../domain/entities/sales_order.dart';
import '../providers/sales_order_detail_provider.dart';
import '../widgets/order_status_badge.dart';

/// Order detail: status, customer, items, total, and one button per status
/// the state machine allows next (none for SHIPPED / CANCELLED).
class SalesOrderDetailScreen extends ConsumerStatefulWidget {
  const SalesOrderDetailScreen({super.key, required this.orderId});

  final int orderId;

  @override
  ConsumerState<SalesOrderDetailScreen> createState() => _SalesOrderDetailScreenState();
}

class _SalesOrderDetailScreenState extends ConsumerState<SalesOrderDetailScreen> {
  /// The status change in flight. While set, every action button is
  /// disabled, so a second tap can't send a duplicate (or conflicting)
  /// request.
  OrderStatus? _pending;

  Future<void> _change(SalesOrder order, OrderStatus target) async {
    if (_pending != null) return;
    if (!await _confirm(order, target) || !mounted) return;

    setState(() => _pending = target);
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final updated = await ref.read(salesOrderDetailProvider(widget.orderId).notifier).changeStatus(target);
      if (!mounted) return;
      // Confirming or shipping an order moves real stock. A single light tap
      // marks that it went through, so the user does not have to re-read the
      // badge to be sure.
      unawaited(HapticFeedback.lightImpact());
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.orderStatusChanged(updated.orderNumber, updated.status.label(context))),
        ),
      );
    } on Failure catch (f) {
      if (!mounted) return;
      // The request is over: stop the spinner before showing the error.
      setState(() => _pending = null);
      final lines = statusChangeErrorLines(context, f, order);
      final stockProblem = f is ValidationFailure && f.messages.keys.any((k) => k.startsWith('items['));
      if (stockProblem || lines.length > 1) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            key: const Key('order_status_error_dialog'),
            icon: const Icon(Icons.inventory_2_outlined),
            title: Text(
              target == OrderStatus.confirmed ? l10n.orderConfirmBlockedTitle : l10n.orderStatusBlockedTitle,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (stockProblem) Text(l10n.orderStockProblemBody),
                const SizedBox(height: AppSpacing.sm),
                for (final line in lines)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [const Text('•  '), Expanded(child: Text(line))],
                    ),
                  ),
              ],
            ),
            actions: [FilledButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.commonUnderstood))],
          ),
        );
      } else {
        messenger.showSnackBar(SnackBar(content: Text(lines.single)));
      }
    } finally {
      if (mounted) setState(() => _pending = null);
    }
  }

  Future<bool> _confirm(SalesOrder order, OrderStatus target) async {
    final l10n = context.l10n;
    // Listed under the bodies that talk about stock moving, so the user sees
    // exactly which products are affected before confirming.
    final affected = l10n.orderDialogItemsAffected(
      order.items.map((i) => '${i.productName} × ${i.quantity}').join('\n'),
    );
    final (title, body) = switch (target) {
      OrderStatus.confirmed => (l10n.orderConfirmDialogTitle, '${l10n.orderConfirmDialogBody}\n\n$affected'),
      OrderStatus.shipped => (l10n.orderShipDialogTitle, l10n.orderShipDialogBody),
      OrderStatus.cancelled when order.status == OrderStatus.confirmed => (
          l10n.orderCancelDialogTitle,
          '${l10n.orderCancelDialogBodyConfirmed}\n\n$affected'
        ),
      OrderStatus.cancelled => (l10n.orderCancelDialogTitle, l10n.orderCancelDialogBodyPending),
      OrderStatus.pending => (l10n.orderChangeStatusDialogTitle, ''),
    };
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        key: const Key('order_confirm_dialog'),
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonBack)),
          FilledButton(
            key: const Key('order_confirm_dialog_ok'),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(target.actionLabel(context)),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final order = ref.watch(salesOrderDetailProvider(widget.orderId));

    return Scaffold(
      appBar: AppBar(title: Text(order.value?.orderNumber ?? context.l10n.orderDetailTitle)),
      body: order.when(
        skipLoadingOnRefresh: true,
        skipLoadingOnReload: true,
        loading: () => const SkeletonDetail(rows: 4),
        error: (e, _) => ErrorView(
          message: errorMessage(context, e),
          onRetry: () => ref.invalidate(salesOrderDetailProvider(widget.orderId)),
        ),
        data: (o) => AppRefreshIndicator(
          onRefresh: () => ref.refresh(salesOrderDetailProvider(widget.orderId).future),
          child: _OrderBody(order: o),
        ),
      ),
      bottomNavigationBar: switch (order.value) {
        final o? => _actionBar(o),
        null => null,
      },
    );
  }

  /// The transitions the state machine allows *and* the user may perform.
  /// A final order still says so; an order this user can't move on shows no
  /// bar at all rather than buttons that would only earn a 403.
  Widget? _actionBar(SalesOrder o) {
    final allowed = [
      for (final target in o.status.next)
        if (ref.hasPermission(_permissionFor(target))) target,
    ];
    if (o.status.next.isNotEmpty && allowed.isEmpty) return null;
    return _ActionBar(order: o, actions: allowed, pending: _pending, onAction: (t) => _change(o, t));
  }

  /// Mirrors the backend's RequireStatusPermission.
  static String _permissionFor(OrderStatus target) => switch (target) {
    OrderStatus.confirmed => Permissions.salesOrdersConfirm,
    OrderStatus.shipped => Permissions.salesOrdersShip,
    OrderStatus.cancelled => Permissions.salesOrdersCancel,
    // Never a target of the state machine; no permission unlocks it.
    OrderStatus.pending => '',
  };
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.order, required this.actions, required this.pending, required this.onAction});

  final SalesOrder order;

  /// The transitions to offer: `order.status.next`, filtered by permission.
  final List<OrderStatus> actions;
  final OrderStatus? pending;
  final ValueChanged<OrderStatus> onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final next = actions;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
        decoration: BoxDecoration(border: Border(top: BorderSide(color: theme.dividerColor))),
        child: next.isEmpty
            ? Text(
                context.l10n.orderNoMoreActions(order.status.label(context)),
                key: const Key('order_no_actions'),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              )
            : Row(
                children: [
                  for (final (i, target) in next.indexed) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.md),
                    Expanded(child: _actionButton(context, target)),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _actionButton(BuildContext context, OrderStatus target) {
    final busy = pending != null;
    final child = pending == target
        ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
        : Text(target.actionLabel(context));
    final onPressed = busy ? null : () => onAction(target);
    final key = Key('order_action_${target.name}');
    if (target == OrderStatus.cancelled) {
      final error = Theme.of(context).colorScheme.error;
      return OutlinedButton(
        key: key,
        style: OutlinedButton.styleFrom(foregroundColor: error, side: BorderSide(color: busy ? Colors.transparent : error)),
        onPressed: onPressed,
        child: child,
      );
    }
    return FilledButton(key: key, onPressed: onPressed, child: child);
  }
}

class _OrderBody extends StatelessWidget {
  const _OrderBody({required this.order});

  final SalesOrder order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final c = order.customer;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Row(
          children: [
            Expanded(child: Text(order.orderNumber, style: theme.textTheme.titleLarge)),
            OrderStatusBadge(status: order.status),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _Timeline(order: order),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.orderDetailCustomer, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(c?.name ?? l10n.orderCustomerFallback('${order.customerId}')),
            subtitle: Text(
              [c?.email, c?.phone, c?.address]
                  .whereType<String>()
                  .where((s) => s.isNotEmpty)
                  .join('\n')
                  .ifEmpty(l10n.customerNoContact),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.orderDetailItemsHeading(order.items.length), style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              for (final (i, item) in order.items.indexed) ...[
                if (i > 0) const Divider(height: 1),
                ListTile(
                  key: Key('order_item_${item.productId}'),
                  title: Text(item.productName),
                  subtitle: Text(
                    '${item.productSku} · ${l10n.orderItemLine(item.quantity, formatRupiah(item.unitPrice))}',
                  ),
                  trailing: Text(formatRupiah(item.subtotal), style: theme.textTheme.titleSmall),
                ),
              ],
              const Divider(height: 1),
              ListTile(
                title: Text(l10n.orderDetailTotal, style: theme.textTheme.titleMedium),
                trailing: Text(
                  formatRupiah(order.totalAmount),
                  key: const Key('order_total'),
                  style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
        if (order.notes.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.orderDetailNotes, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(order.notes),
        ],
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.orderDetailPriceNote,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.order});

  final SalesOrder order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final style = Theme.of(context).textTheme.bodySmall;
    final entries = [
      (l10n.orderDetailCreatedAt, order.createdAt),
      if (order.confirmedAt case final t?) (l10n.orderDetailConfirmedAt, t),
      if (order.shippedAt case final t?) (l10n.orderDetailShippedAt, t),
      if (order.cancelledAt case final t?) (l10n.orderDetailCancelledAt, t),
    ];
    return Wrap(
      spacing: 16,
      runSpacing: 4,
      children: [for (final (label, t) in entries) Text('$label ${formatDateTime(t)}', style: style)],
    );
  }
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
