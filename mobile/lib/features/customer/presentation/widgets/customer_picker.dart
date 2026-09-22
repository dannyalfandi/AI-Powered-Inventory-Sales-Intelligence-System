import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/search_picker_sheet.dart';
import '../../domain/entities/customer.dart';
import '../providers/customer_list_provider.dart';

/// Lets the user search and pick a customer (name, email or phone). Only
/// customers that aren't deleted can be found. Null if dismissed.
Future<Customer?> pickCustomer(BuildContext context, {String? title}) {
  final l10n = context.l10n;
  return showSearchPicker<Customer>(
    context,
    title: title ?? l10n.customerPick,
    searchHint: l10n.customersSearchHint,
    resultsFor: (q) => customerSearchProvider(q),
    titleOf: (c) => c.name,
    subtitleOf: (c) => [c.email, c.phone].whereType<String>().where((s) => s.isNotEmpty).join(' · '),
    emptyMessage: l10n.customersPickerEmpty,
  );
}
