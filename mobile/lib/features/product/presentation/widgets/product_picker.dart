import 'package:flutter/material.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/search_picker_sheet.dart';
import '../../domain/entities/product.dart';
import '../providers/product_search_provider.dart';

/// Lets the user search and pick a product (name or SKU). Products in
/// [alreadyAdded] are listed but disabled, so an order can't get the same
/// product twice. Null if dismissed.
Future<Product?> pickProduct(BuildContext context, {Set<int> alreadyAdded = const {}}) {
  return showSearchPicker<Product>(
    context,
    title: 'Tambah produk',
    searchHint: 'Cari nama atau SKU',
    resultsFor: (q) => productSearchProvider(q),
    titleOf: (p) => p.name,
    subtitleOf: (p) => p.category == null ? p.sku : '${p.sku} · ${p.category!.name}',
    trailingOf: (p) => Text(formatRupiah(p.price)),
    disabledReason: (p) => alreadyAdded.contains(p.id) ? 'sudah ditambahkan' : null,
    emptyMessage: 'Produk tidak ditemukan.',
  );
}
