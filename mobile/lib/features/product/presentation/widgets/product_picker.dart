import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/search_picker_sheet.dart';
import '../../domain/entities/product.dart';
import '../providers/product_search_provider.dart';

/// Lets the user search and pick a product (name or SKU). Products in
/// [alreadyAdded] are listed but disabled, so an order can't get the same
/// product twice. Null if dismissed.
Future<Product?> pickProduct(BuildContext context, {Set<int> alreadyAdded = const {}}) {
  final l10n = context.l10n;
  return showSearchPicker<Product>(
    context,
    title: l10n.orderFormPickProduct,
    searchHint: l10n.productsSearchHint,
    resultsFor: (q) => productSearchProvider(q),
    titleOf: (p) => p.name,
    subtitleOf: (p) => p.category == null ? p.sku : '${p.sku} · ${p.category!.name}',
    trailingOf: (p) => Text(formatRupiah(p.price)),
    disabledReason: (p) => alreadyAdded.contains(p.id) ? l10n.orderFormProductAlreadyAdded : null,
    emptyMessage: l10n.productsEmpty,
  );
}
