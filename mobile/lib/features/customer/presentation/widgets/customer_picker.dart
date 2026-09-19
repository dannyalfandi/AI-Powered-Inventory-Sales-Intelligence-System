import 'package:flutter/material.dart';

import '../../../../shared/widgets/search_picker_sheet.dart';
import '../../domain/entities/customer.dart';
import '../providers/customer_list_provider.dart';

/// Lets the user search and pick a customer (name, email or phone). Only
/// customers that aren't deleted can be found. Null if dismissed.
Future<Customer?> pickCustomer(BuildContext context, {String title = 'Pilih pelanggan'}) {
  return showSearchPicker<Customer>(
    context,
    title: title,
    searchHint: 'Cari nama, email, atau telepon',
    resultsFor: (q) => customerSearchProvider(q),
    titleOf: (c) => c.name,
    subtitleOf: (c) => [c.email, c.phone].whereType<String>().where((s) => s.isNotEmpty).join(' · '),
    emptyMessage: 'Pelanggan tidak ditemukan.\nTambahkan dulu di tab Pelanggan.',
  );
}
