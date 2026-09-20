import 'package:intl/intl.dart';

final _rupiah = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

/// Formats whole Rupiah, e.g. 45000 → "Rp 45.000".
String formatRupiah(int amount) => _rupiah.format(amount);

final _compact = NumberFormat('#,##0.#', 'id_ID');

/// Short Rupiah for chart axes and tight labels, e.g. 928000 → "Rp 928rb",
/// 1_250_000 → "Rp 1,3jt". Uses Indonesian magnitude suffixes.
String formatRupiahCompact(int amount) {
  final negative = amount < 0;
  final v = amount.abs();
  final (scaled, suffix) = switch (v) {
    >= 1000000000 => (v / 1000000000, 'm'),
    >= 1000000 => (v / 1000000, 'jt'),
    >= 1000 => (v / 1000, 'rb'),
    _ => (v.toDouble(), ''),
  };
  return '${negative ? '-' : ''}Rp ${_compact.format(scaled)}$suffix';
}
