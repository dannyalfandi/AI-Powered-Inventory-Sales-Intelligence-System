import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/state_views.dart';
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
    final messenger = ScaffoldMessenger.of(context);
    try {
      final updated = await ref.read(salesOrderDetailProvider(widget.orderId).notifier).changeStatus(target);
      messenger.showSnackBar(SnackBar(content: Text('Pesanan ${updated.orderNumber} ${updated.status.label.toLowerCase()}')));
    } on Failure catch (f) {
      if (!mounted) return;
      // The request is over: stop the spinner before showing the error.
      setState(() => _pending = null);
      final lines = statusChangeErrorLines(f, order);
      final stockProblem = f is ValidationFailure && f.messages.keys.any((k) => k.startsWith('items['));
      if (stockProblem || lines.length > 1) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            key: const Key('order_status_error_dialog'),
            icon: const Icon(Icons.inventory_2_outlined),
            title: Text(target == OrderStatus.confirmed ? 'Pesanan tidak bisa dikonfirmasi' : 'Status tidak bisa diubah'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (stockProblem) const Text('Tidak ada stok yang berubah. Masalah per produk:'),
                const SizedBox(height: 8),
                for (final line in lines)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [const Text('•  '), Expanded(child: Text(line))],
                    ),
                  ),
              ],
            ),
            actions: [FilledButton(onPressed: () => Navigator.pop(ctx), child: const Text('Mengerti'))],
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
    final items = order.items.map((i) => '${i.productName} × ${i.quantity}').join('\n');
    final (title, body) = switch (target) {
      OrderStatus.confirmed => ('Konfirmasi pesanan?', 'Stok akan dikurangi:\n$items'),
      OrderStatus.shipped => ('Tandai sudah dikirim?', 'Stok tidak berubah (sudah dikurangi saat konfirmasi). Pesanan tidak bisa dibatalkan lagi setelah dikirim.'),
      OrderStatus.cancelled when order.status == OrderStatus.confirmed => (
          'Batalkan pesanan?',
          'Stok yang sudah dikurangi akan dikembalikan:\n$items'
        ),
      OrderStatus.cancelled => ('Batalkan pesanan?', 'Stok tidak berubah. Pesanan yang dibatalkan tidak bisa diaktifkan lagi.'),
      OrderStatus.pending => ('Ubah status?', ''),
    };
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        key: const Key('order_confirm_dialog'),
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Kembali')),
          FilledButton(
            key: const Key('order_confirm_dialog_ok'),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(target.actionLabel),
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
      appBar: AppBar(title: Text(order.value?.orderNumber ?? 'Detail Pesanan')),
      body: order.when(
        skipLoadingOnRefresh: true,
        skipLoadingOnReload: true,
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: errorMessage(e),
          onRetry: () => ref.invalidate(salesOrderDetailProvider(widget.orderId)),
        ),
        data: (o) => RefreshIndicator(
          onRefresh: () => ref.refresh(salesOrderDetailProvider(widget.orderId).future),
          child: _OrderBody(order: o),
        ),
      ),
      bottomNavigationBar: switch (order.value) {
        final o? => _ActionBar(order: o, pending: _pending, onAction: (t) => _change(o, t)),
        null => null,
      },
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.order, required this.pending, required this.onAction});

  final SalesOrder order;
  final OrderStatus? pending;
  final ValueChanged<OrderStatus> onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final next = order.status.next;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(border: Border(top: BorderSide(color: theme.dividerColor))),
        child: next.isEmpty
            ? Text(
                'Pesanan ${order.status.label.toLowerCase()} — tidak ada aksi lagi.',
                key: const Key('order_no_actions'),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              )
            : Row(
                children: [
                  for (final (i, target) in next.indexed) ...[
                    if (i > 0) const SizedBox(width: 12),
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
        : Text(target.actionLabel);
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
    final theme = Theme.of(context);
    final c = order.customer;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: Text(order.orderNumber, style: theme.textTheme.titleLarge)),
            OrderStatusBadge(status: order.status),
          ],
        ),
        const SizedBox(height: 8),
        _Timeline(order: order),
        const SizedBox(height: 16),
        Text('Pelanggan', style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(c?.name ?? 'Pelanggan #${order.customerId}'),
            subtitle: Text(
              [c?.email, c?.phone, c?.address].whereType<String>().where((s) => s.isNotEmpty).join('\n').ifEmpty('Tanpa kontak'),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Produk (${order.items.length})', style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              for (final (i, item) in order.items.indexed) ...[
                if (i > 0) const Divider(height: 1),
                ListTile(
                  key: Key('order_item_${item.productId}'),
                  title: Text(item.productName),
                  subtitle: Text('${item.productSku} · ${item.quantity} × ${formatRupiah(item.unitPrice)}'),
                  trailing: Text(formatRupiah(item.subtotal), style: theme.textTheme.titleSmall),
                ),
              ],
              const Divider(height: 1),
              ListTile(
                title: Text('Total', style: theme.textTheme.titleMedium),
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
          const SizedBox(height: 16),
          Text('Catatan', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(order.notes),
        ],
        const SizedBox(height: 8),
        Text(
          'Harga adalah snapshot saat pesanan dibuat. Item tidak bisa diubah; batalkan dan buat pesanan baru bila salah.',
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
    final style = Theme.of(context).textTheme.bodySmall;
    final entries = [
      ('Dibuat', order.createdAt),
      if (order.confirmedAt case final t?) ('Dikonfirmasi', t),
      if (order.shippedAt case final t?) ('Dikirim', t),
      if (order.cancelledAt case final t?) ('Dibatalkan', t),
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
