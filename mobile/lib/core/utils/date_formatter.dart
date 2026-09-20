import 'package:intl/intl.dart';

// Numeric pattern: needs no locale data (no initializeDateFormatting call).
final _dateTime = DateFormat('dd/MM/yyyy HH:mm');

/// Formats in the device's local time zone, e.g. "19/09/2026 14:05".
String formatDateTime(DateTime value) => _dateTime.format(value.toLocal());

final _date = DateFormat('dd/MM/yyyy');
final _dayMonth = DateFormat('dd/MM');

/// "20/09/2026".
String formatDate(DateTime value) => _date.format(value);

/// "20/09" — for chart axis labels, where the year is already in the header.
String formatDayMonth(DateTime value) => _dayMonth.format(value);

/// "22/08/2026 – 20/09/2026", the label of the dashboard date range.
String formatDateRange(DateTime from, DateTime to) => '${_date.format(from)} – ${_date.format(to)}';
