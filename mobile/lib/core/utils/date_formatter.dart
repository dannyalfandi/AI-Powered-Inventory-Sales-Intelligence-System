import 'package:intl/intl.dart';

// Numeric pattern: needs no locale data (no initializeDateFormatting call).
final _dateTime = DateFormat('dd/MM/yyyy HH:mm');

/// Formats in the device's local time zone, e.g. "19/09/2026 14:05".
String formatDateTime(DateTime value) => _dateTime.format(value.toLocal());
