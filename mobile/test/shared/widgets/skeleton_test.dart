import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/features/dashboard/domain/entities/dashboard.dart';
import 'package:inventory_intel/features/dashboard/presentation/widgets/dashboard_section.dart';
import 'package:inventory_intel/shared/widgets/skeleton.dart';

import '../../helpers/dashboard_fixtures.dart';
import '../../helpers/l10n_harness.dart';

void main() {
  group('Skeleton', () {
    testWidgets('shimmers by default', (tester) async {
      await tester.pumpWidget(localizedApp(home: const Scaffold(body: SkeletonList(rows: 2))));
      await tester.pump();

      // A ShaderMask means the highlight sweep is running over the boxes.
      expect(find.byType(ShaderMask), findsOneWidget);
      expect(find.byType(SkeletonBox), findsWidgets);
    });

    testWidgets('holds still when the platform asks for reduced motion', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: localizedApp(home: const Scaffold(body: SkeletonList(rows: 2))),
        ),
      );
      await tester.pump();

      // The shape still communicates what is loading; only the sweep is gone.
      expect(find.byType(ShaderMask), findsNothing);
      expect(find.byType(SkeletonBox), findsWidgets);
    });

    testWidgets('is hidden from screen readers', (tester) async {
      await tester.pumpWidget(localizedApp(home: const Scaffold(body: SkeletonList(rows: 2))));
      await tester.pump();

      expect(find.byType(ExcludeSemantics), findsWidgets);
    });

    testWidgets('each placeholder keeps its own shape', (tester) async {
      await tester.pumpWidget(
        localizedApp(
          home: const Scaffold(
            body: Column(
              children: [SkeletonSummaryGrid(), SkeletonChart(height: 60), SkeletonLines(lines: 2)],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('skeleton_summary_grid')), findsOneWidget);
      expect(find.byKey(const Key('skeleton_chart')), findsOneWidget);
      expect(find.byKey(const Key('skeleton_lines')), findsOneWidget);
    });
  });

  group('AsyncSection', () {
    /// A section whose data arrives only when [completer] does, so the test
    /// can look at the loading frame and the data frame separately.
    Widget sectionFor(Completer<DashboardSummary> completer, {Widget? skeleton}) {
      return localizedApp(
        home: Scaffold(
          body: Consumer(
            builder: (context, ref, _) => AsyncSection<DashboardSummary>(
              value: ref.watch(_summaryProvider(completer)),
              onRetry: () {},
              skeleton: skeleton,
              builder: (context, data) => Text('revenue ${data.totalRevenue}'),
            ),
          ),
        ),
      );
    }

    testWidgets('shows a skeleton while loading and drops it once data lands', (tester) async {
      final completer = Completer<DashboardSummary>();
      await tester.pumpWidget(
        ProviderScope(
          retry: (_, _) => null,
          child: sectionFor(completer, skeleton: const SkeletonSummaryGrid()),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('skeleton_summary_grid')), findsOneWidget);
      expect(find.textContaining('revenue'), findsNothing);

      completer.complete(_summary);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('skeleton_summary_grid')), findsNothing);
      expect(find.text('revenue 928000'), findsOneWidget);
    });

    testWidgets('falls back to line placeholders when a section gives no skeleton', (tester) async {
      final completer = Completer<DashboardSummary>();
      await tester.pumpWidget(
        ProviderScope(retry: (_, _) => null, child: sectionFor(completer)),
      );
      await tester.pump();

      expect(find.byKey(const Key('skeleton_lines')), findsOneWidget);

      completer.complete(_summary);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('skeleton_lines')), findsNothing);
    });

    testWidgets('a reload keeps the old data on screen instead of a skeleton', (tester) async {
      final completer = Completer<DashboardSummary>()..complete(_summary);
      await tester.pumpWidget(
        ProviderScope(
          retry: (_, _) => null,
          child: sectionFor(completer, skeleton: const SkeletonSummaryGrid()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('revenue 928000'), findsOneWidget);
      expect(find.byKey(const Key('skeleton_summary_grid')), findsNothing);
    });
  });
}

final _summary = summary(revenue: 928000);

/// Wraps a completer as an `AsyncValue`, which is all `AsyncSection` reads.
final _summaryProvider = FutureProvider.family<DashboardSummary, Completer<DashboardSummary>>(
  (ref, completer) => completer.future,
);
