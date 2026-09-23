import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/shared/theme/app_motion.dart';
import 'package:inventory_intel/shared/widgets/animated_count.dart';
import 'package:inventory_intel/shared/widgets/press_effect.dart';
import 'package:inventory_intel/shared/widgets/state_views.dart';

import '../../helpers/l10n_harness.dart';

/// "Reduce motion" is an accessibility setting, not a nicety: for some people
/// the animations in this app are the difference between usable and nauseating.
/// Every animated widget has to honour it, so each one is checked here rather
/// than trusted to have remembered.
void main() {
  /// Pumps [child] with the platform's reduce-motion setting forced [on].
  Future<void> pumpWithMotion(WidgetTester tester, Widget child, {required bool reduced}) async {
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(disableAnimations: reduced),
        child: localizedApp(home: Scaffold(body: child)),
      ),
    );
  }

  group('AppMotion', () {
    testWidgets('durations collapse to zero, not to something merely shorter', (tester) async {
      late Duration reduced;
      late Duration normal;

      await pumpWithMotion(
        tester,
        Builder(builder: (context) {
          reduced = AppMotion.durationOf(context, AppMotion.counter);
          return const SizedBox.shrink();
        }),
        reduced: true,
      );
      await pumpWithMotion(
        tester,
        Builder(builder: (context) {
          normal = AppMotion.durationOf(context, AppMotion.counter);
          return const SizedBox.shrink();
        }),
        reduced: false,
      );

      expect(reduced, Duration.zero);
      expect(normal, AppMotion.counter);
    });

    test('no animation outstays its welcome', () {
      // The rule the whole app is written to: nothing between 0 and 600ms is
      // long enough to be a wait, and the looping shimmer is the one
      // exception because it sits under content that is not there yet.
      for (final d in [AppMotion.fast, AppMotion.normal, AppMotion.page, AppMotion.counter]) {
        expect(d.inMilliseconds, inInclusiveRange(100, 600));
      }
    });
  });

  group('AnimatedCount', () {
    testWidgets('counts up to the value when motion is allowed', (tester) async {
      await pumpWithMotion(
        tester,
        AnimatedCount(value: 1000, format: (v) => v.round().toString()),
        reduced: false,
      );
      await tester.pump();

      // Mid-flight it is on its way, and always in the right magnitude —
      // never zero, which would read as "no sales".
      final midway = tester.widget<Text>(find.byType(Text)).data!;
      expect(int.parse(midway), inInclusiveRange(700, 1000));

      await tester.pumpAndSettle();
      expect(find.text('1000'), findsOneWidget);
    });

    testWidgets('lands on the final value immediately under reduced motion', (tester) async {
      await pumpWithMotion(
        tester,
        AnimatedCount(value: 1000, format: (v) => v.round().toString()),
        reduced: true,
      );
      await tester.pump();

      expect(find.text('1000'), findsOneWidget);
    });

    testWidgets('a screen reader always hears the finished number', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpWithMotion(
        tester,
        AnimatedCount(value: 1000, format: (v) => v.round().toString()),
        reduced: false,
      );
      await tester.pump();

      expect(find.bySemanticsLabel('1000'), findsOneWidget);
      handle.dispose();
    });
  });

  group('PressEffect', () {
    testWidgets('wraps its child in a scale when motion is allowed', (tester) async {
      await pumpWithMotion(tester, const PressEffect(child: Text('row')), reduced: false);

      expect(find.byType(AnimatedScale), findsOneWidget);
      expect(find.text('row'), findsOneWidget);
    });

    testWidgets('disappears entirely under reduced motion', (tester) async {
      await pumpWithMotion(tester, const PressEffect(child: Text('row')), reduced: true);

      expect(find.byType(AnimatedScale), findsNothing);
      expect(find.text('row'), findsOneWidget);
    });

    testWidgets('does nothing when disabled', (tester) async {
      await pumpWithMotion(tester, const PressEffect(enabled: false, child: Text('row')), reduced: false);

      expect(find.byType(AnimatedScale), findsNothing);
    });
  });

  group('EmptyView', () {
    testWidgets('the message is readable on the first frame, animated or not', (tester) async {
      for (final reduced in [true, false]) {
        await pumpWithMotion(tester, const EmptyView(message: 'No products yet.'), reduced: reduced);
        await tester.pump();

        // Only the icon eases in; the sentence telling the user what to do
        // must never be faded out from under them.
        expect(find.text('No products yet.'), findsOneWidget);
      }
    });
  });
}
