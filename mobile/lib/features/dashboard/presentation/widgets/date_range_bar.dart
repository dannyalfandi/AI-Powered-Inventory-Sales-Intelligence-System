import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/dashboard.dart';
import '../providers/dashboard_filter_provider.dart';

/// Date range control for the whole page: three presets plus a custom picker.
/// It writes to one provider, which every section watches.
class DateRangeBar extends StatelessWidget {
  const DateRangeBar({super.key, required this.range, required this.onPreset, required this.onCustomRange});

  final AnalyticsRange range;
  final void Function(int days) onPreset;
  final void Function(DateTime from, DateTime to) onCustomRange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_outlined, size: 18, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Expanded(child: Text(formatDateRange(range.from, range.to), style: theme.textTheme.bodyMedium)),
              Text(
                '${range.dayCount} hari',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final days in dashboardPresetDays)
                ChoiceChip(
                  label: Text('$days hari'),
                  // A custom range that happens to equal a preset selects that
                  // chip — the state is the range itself, not "which button".
                  selected: range == AnalyticsRange.lastDays(today, days),
                  onSelected: (_) => onPreset(days),
                ),
              ActionChip(
                avatar: const Icon(Icons.date_range, size: 18),
                label: const Text('Pilih tanggal'),
                onPressed: () => _pickRange(context, today),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickRange(BuildContext context, DateTime today) async {
    final picked = await showDateRangePicker(
      context: context,
      // The backend rejects ranges longer than 366 days; sales can't predate
      // the system, so five years back is more than enough.
      firstDate: DateTime(today.year - 5),
      lastDate: DateTime(today.year, today.month, today.day),
      initialDateRange: DateTimeRange(start: range.from, end: range.to),
      helpText: 'Pilih rentang tanggal',
      saveText: 'Terapkan',
    );
    if (picked != null) onCustomRange(picked.start, picked.end);
  }
}
