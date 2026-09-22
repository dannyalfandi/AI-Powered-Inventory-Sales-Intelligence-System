import 'package:intl/intl.dart';

final _rupiah = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

/// Formats whole Rupiah, e.g. 45000 → "Rp 45.000".
///
/// Deliberately `id_ID` in both app languages: the amount is Rupiah whichever
/// language the labels are in, and Rupiah is conventionally written with a
/// dot as the thousands separator.
String formatRupiah(int amount) => _rupiah.format(amount);

final _decimal = <String, NumberFormat>{};

/// A plain number with at most one decimal, in the app's language: "1.5" in
/// English, "1,5" in Indonesian. For counts and averages — not for money,
/// which stays Rupiah-formatted.
String formatDecimal(String languageCode, num value) =>
    _decimal.putIfAbsent(languageCode, () => NumberFormat('#,##0.#', languageCode)).format(value);

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
