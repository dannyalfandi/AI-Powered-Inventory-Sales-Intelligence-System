import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import '../../core/l10n/l10n.dart';
import 'state_views.dart';

/// Opens a bottom sheet with a search field and results from
/// [resultsFor](query). Resolves to the tapped item, or null if dismissed.
/// Items for which [disabledReason] returns text are shown but can't be picked.
Future<T?> showSearchPicker<T>(
  BuildContext context, {
  required String title,
  required String searchHint,
  required ProviderBase<AsyncValue<List<T>>> Function(String query) resultsFor,
  required String Function(T item) titleOf,
  String Function(T item)? subtitleOf,
  Widget Function(T item)? trailingOf,
  String? Function(T item)? disabledReason,
  String? emptyMessage,
}) {
  final message = emptyMessage ?? context.l10n.commonNoResults;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.85,
      child: _SearchPickerSheet<T>(
        title: title,
        searchHint: searchHint,
        resultsFor: resultsFor,
        titleOf: titleOf,
        subtitleOf: subtitleOf,
        trailingOf: trailingOf,
        disabledReason: disabledReason,
        emptyMessage: message,
      ),
    ),
  );
}

class _SearchPickerSheet<T> extends ConsumerStatefulWidget {
  const _SearchPickerSheet({
    required this.title,
    required this.searchHint,
    required this.resultsFor,
    required this.titleOf,
    required this.subtitleOf,
    required this.trailingOf,
    required this.disabledReason,
    required this.emptyMessage,
  });

  final String title;
  final String searchHint;
  final ProviderBase<AsyncValue<List<T>>> Function(String query) resultsFor;
  final String Function(T item) titleOf;
  final String Function(T item)? subtitleOf;
  final Widget Function(T item)? trailingOf;
  final String? Function(T item)? disabledReason;
  final String emptyMessage;

  @override
  ConsumerState<_SearchPickerSheet<T>> createState() => _SearchPickerSheetState<T>();
}

class _SearchPickerSheetState<T> extends ConsumerState<_SearchPickerSheet<T>> {
  String _query = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(widget.resultsFor(_query));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SearchBar(
            key: const Key('search_picker_field'),
            hintText: widget.searchHint,
            leading: const Icon(Icons.search),
            elevation: const WidgetStatePropertyAll(0),
            onChanged: _onChanged,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: results.when(
            skipLoadingOnReload: true,
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(
              message: errorMessage(context, e),
              onRetry: () => ref.invalidate(widget.resultsFor(_query)),
            ),
            data: (items) {
              if (items.isEmpty) return EmptyView(icon: Icons.search_off, message: widget.emptyMessage);
              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final item = items[i];
                  final disabled = widget.disabledReason?.call(item);
                  final subtitle = [widget.subtitleOf?.call(item), disabled].whereType<String>().join(' · ');
                  return ListTile(
                    enabled: disabled == null,
                    title: Text(widget.titleOf(item), maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: subtitle.isEmpty ? null : Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: widget.trailingOf?.call(item),
                    onTap: disabled == null ? () => Navigator.of(context).pop(item) : null,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
