import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/permissions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_refresh_indicator.dart';
import '../../../../shared/widgets/paged_list.dart';
import '../../../../shared/widgets/press_effect.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../../shared/widgets/state_views.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
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

  /// Shorthand so the callbacks below read like the build method.
  AppLocalizations get l10n => context.l10n;

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
        title: Text(l10n.customerDeleteConfirmTitle),
        content: Text(l10n.customerDeleteConfirmBody(c.name)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.commonDelete)),
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
      unawaited(HapticFeedback.lightImpact());
      messenger.showSnackBar(SnackBar(content: Text(l10n.customerDeleted(c.name))));
      return true;
    } on Failure catch (f) {
      if (!mounted) return false;
      final message = customerDeleteErrorMessage(context, f, c);
      if (f is ServerFailure && f.isConflict) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            icon: const Icon(Icons.receipt_long_outlined),
            title: Text(l10n.customerDeleteBlockedTitle),
            content: Text(message),
            actions: [
              FilledButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.commonUnderstood)),
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
    final canEdit = ref.hasPermission(Permissions.customersUpdate);
    final canDelete = ref.hasPermission(Permissions.customersDelete);
    final search = ref.watch(customerSearchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customersTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
            child: SearchBar(
              controller: _searchController,
              hintText: l10n.customersSearchHint,
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              onChanged: _onSearchChanged,
              onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    tooltip: l10n.commonClearSearch,
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
      floatingActionButton: ref.hasPermission(Permissions.customersCreate)
          ? FloatingActionButton.extended(
              heroTag: 'customer_fab',
              onPressed: () => context.pushNamed(AppRoutes.customerCreate),
              icon: const Icon(Icons.person_add_alt),
              label: Text(l10n.customersTitle),
            )
          : null,
      body: customers.when(
        loading: () => const SkeletonList(),
        error: (e, _) => RefreshableView(
          onRefresh: _refresh,
          child: ErrorView(message: errorMessage(context, e), onRetry: () => ref.invalidate(customerListProvider)),
        ),
        data: (state) {
          if (state.items.isEmpty) {
            return RefreshableView(
              onRefresh: _refresh,
              child: EmptyView(
                icon: search.isEmpty ? Icons.people_outline : Icons.search_off,
                message: search.isEmpty
                    ? l10n.customersEmptyHint
                    : l10n.customersEmptyForSearch(search),
              ),
            );
          }
          return AppRefreshIndicator(
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
                    totalLabel: (n) => l10n.customersCount(n),
                  );
                }
                final c = state.items[i];
                final tile = PressEffect(
                  child: CustomerTile(
                    customer: c,
                    // The row opens the edit form: only for users who may edit.
                    onTap: canEdit
                        ? () => context.pushNamed(AppRoutes.customerEdit, pathParameters: {'id': '${c.id}'})
                        : null,
                  ),
                );
                if (!canDelete) return KeyedSubtree(key: ValueKey(c.id), child: tile);
                return Dismissible(
                  key: ValueKey(c.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(context).colorScheme.errorContainer,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: const Icon(Icons.delete_outline),
                  ),
                  // The provider already removed the row once the server confirmed.
                  confirmDismiss: (_) => _confirmAndDelete(c),
                  child: tile,
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
      subtitle: Text(
        contact.isEmpty ? context.l10n.customerNoContact : contact,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
