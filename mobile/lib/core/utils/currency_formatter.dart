import 'package:intl/intl.dart';

final _rupiah = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

/// Formats whole Rupiah, e.g. 45000 → "Rp 45.000".
String formatRupiah(int amount) => _rupiah.format(amount);
