import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/paged_list.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../domain/entities/customer.dart';
import '../providers/customer_list_provider.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.text = ref.read(customerSearchQueryProvider);
    listenNearEnd(_scrollController, () => ref.read(customerListProvider.notifier).loadMore());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {}); // toggles the clear button
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(customerSearchQueryProvider.notifier).set(value);
    });
  }

  Future<void> _refresh() async {
    ref.invalidate(customerListProvider);
    try {
      await ref.read(customerListProvider.future);
    } on Failure {
      // Shown by the error state of customerListProvider.
    }
  }

  Future<bool> _confirmDelete(Customer c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus pelanggan?'),
        content: Text('Pelanggan "${c.name}" akan dihapus.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus')),
        ],
      ),
    );
    return ok ?? false;
  }

  /// Confirms, deletes on the server, and returns whether the row may be
  /// dismissed. On failure the row slides back.
  Future<bool> _confirmAndDelete(Customer c) async {
    if (!await _confirmDelete(c)) return false;
    if (!mounted) return false;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(customerListProvider.notifier).delete(c.id);
      messenger.showSnackBar(SnackBar(content: Text('Pelanggan ${c.name} dihapus')));
      return true;
    } on Failure catch (f) {
      if (!mounted) return false;
      final message = customerDeleteErrorMessage(f, c);
      if (f is ServerFailure && f.isConflict) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            icon: const Icon(Icons.receipt_long_outlined),
            title: const Text('Pelanggan masih punya pesanan'),
            content: Text(message),
            actions: [
              FilledButton(onPressed: () => Navigator.pop(ctx), child: const Text('Mengerti')),
            ],
          ),
        );
      } else {
        messenger.showSnackBar(SnackBar(content: Text(message)));
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customerListProvider);
    final search = ref.watch(customerSearchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pelanggan'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Cari nama, email, atau telepon',
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              onChanged: _onSearchChanged,
              onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    tooltip: 'Hapus pencarian',
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'customer_fab',
        onPressed: () => context.pushNamed(AppRoutes.customerCreate),
        icon: const Icon(Icons.person_add_alt),
        label: const Text('Pelanggan'),
      ),
      body: customers.when(
        loading: () => const LoadingView(),
        error: (e, _) => RefreshableView(
          onRefresh: _refresh,
          child: ErrorView(message: errorMessage(e), onRetry: () => ref.invalidate(customerListProvider)),
        ),
        data: (state) {
          if (state.items.isEmpty) {
            return RefreshableView(
              onRefresh: _refresh,
              child: EmptyView(
                icon: search.isEmpty ? Icons.people_outline : Icons.search_off,
                message: search.isEmpty
                    ? 'Belum ada pelanggan.\nTambahkan pelanggan pertama.'
                    : 'Tidak ada pelanggan untuk "$search".',
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 96),
              itemCount: state.items.length + 1,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                if (i == state.items.length) {
                  return PagedListFooter(
                    state: state,
                    onLoadMore: () => ref.read(customerListProvider.notifier).loadMore(),
                    totalLabel: (n) => '$n pelanggan',
                  );
                }
                final c = state.items[i];
                return Dismissible(
                  key: ValueKey(c.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(context).colorScheme.errorContainer,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: const Icon(Icons.delete_outline),
                  ),
                  // The provider already removed the row once the server confirmed.
                  confirmDismiss: (_) => _confirmAndDelete(c),
                  child: CustomerTile(
                    customer: c,
                    onTap: () => context.pushNamed(AppRoutes.customerEdit, pathParameters: {'id': '${c.id}'}),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CustomerTile extends StatelessWidget {
  const CustomerTile({super.key, required this.customer, this.onTap});

  final Customer customer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final contact = [customer.email, customer.phone].whereType<String>().where((s) => s.isNotEmpty).join(' · ');
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(child: Text(customer.name.characters.first.toUpperCase())),
      title: Text(customer.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(contact.isEmpty ? 'Tanpa kontak' : contact, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
