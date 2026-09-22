import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_intel/core/error/failure.dart';
import 'package:inventory_intel/features/inventory/domain/entities/inventory.dart';
import 'package:inventory_intel/features/inventory/presentation/providers/inventory_providers.dart';
import 'package:inventory_intel/features/inventory/presentation/widgets/movement_form_sheet.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/inventory_fixtures.dart';
import '../../../../helpers/l10n_harness.dart';

void main() {
  late MockInventoryRepository repo;

  setUpAll(registerInventoryFallbacks);
  setUp(() {
    repo = MockInventoryRepository();
    when(() => repo.getInventory(1)).thenAnswer((_) async => inventory(1, quantity: 20));
    when(() => repo.getMovements(1, page: any(named: 'page'), pageSize: any(named: 'pageSize')))
        .thenAnswer((_) async => pageOf(<StockMovement>[]));
    when(() => repo.getLowStock(page: any(named: 'page'), pageSize: any(named: 'pageSize')))
        .thenAnswer((_) async => pageOf(<LowStockItem>[]));
  });

  /// A page with a button that opens the sheet; the sheet's result is shown
  /// as text so tests can assert on it.
  Widget app() => ProviderScope(
        overrides: [inventoryRepositoryProvider.overrideWithValue(repo)],
        retry: (_, _) => null,
        child: localizedApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return _Opener(
                  open: () => showMovementFormSheet(context, productId: 1),
                );
              },
            ),
          ),
        ),
      );

  Future<void> openSheet(WidgetTester tester) async {
    await tester.pumpWidget(app());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Future<void> enterQuantity(WidgetTester tester, String value) =>
      tester.enterText(find.byKey(const Key('movement_form_quantity')), value);

  Future<void> submit(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('movement_form_submit')));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the current stock as a hint', (tester) async {
    await openSheet(tester);

    expect(find.text(l10nOf(tester).movementCurrentStock(20)), findsOneWidget);
  });

  testWidgets('empty quantity is rejected locally', (tester) async {
    await openSheet(tester);

    await submit(tester);

    expect(find.text(l10nOf(tester).validationQuantityRequired), findsOneWidget);
    verifyNever(() => repo.recordMovement(any(), any()));
  });

  testWidgets('zero is rejected for IN but allowed for ADJUSTMENT', (tester) async {
    when(() => repo.recordMovement(1, any())).thenAnswer(
      (_) async => MovementResult(
        movement: movement(1, type: MovementType.adjustment, quantity: 0, before: 20, after: 0),
        inventory: inventory(1, quantity: 0),
      ),
    );
    await openSheet(tester);

    await enterQuantity(tester, '0');
    await submit(tester);
    expect(find.text(l10nOf(tester).validationQuantityPositive), findsOneWidget);

    await tester.tap(find.text(l10nOf(tester).movementLabelAdjustment));
    await tester.pumpAndSettle();
    await submit(tester);

    verify(
      () => repo.recordMovement(1, const MovementInput(type: MovementType.adjustment, quantity: 0)),
    ).called(1);
  });

  testWidgets('OUT larger than the stock: backend 422 appears under the quantity field', (tester) async {
    when(() => repo.recordMovement(1, any())).thenThrow(insufficientStockFailure);
    await openSheet(tester);

    await tester.tap(find.text(l10nOf(tester).movementLabelOut));
    await tester.pumpAndSettle();
    await enterQuantity(tester, '21');
    await submit(tester);

    expect(find.text('insufficient stock: 20 available, 21 requested'), findsOneWidget);
    expect(find.byKey(const Key('movement_form_submit')), findsOneWidget); // sheet stays open

    // Editing the quantity clears the server error.
    await enterQuantity(tester, '5');
    await tester.pumpAndSettle(); // the error text fades out
    expect(find.text('insufficient stock: 20 available, 21 requested'), findsNothing);
  });

  testWidgets('success sends type, quantity and trimmed reason, then closes with the result', (tester) async {
    const sent = MovementInput(type: MovementType.stockIn, quantity: 5, reason: 'restock');
    when(() => repo.recordMovement(1, sent)).thenAnswer(
      (_) async => MovementResult(movement: movement(9, before: 20), inventory: inventory(1, quantity: 25)),
    );
    await openSheet(tester);

    await enterQuantity(tester, '5');
    await tester.enterText(find.byKey(const Key('movement_form_reason')), ' restock ');
    await submit(tester);

    verify(() => repo.recordMovement(1, sent)).called(1);
    expect(find.byKey(const Key('movement_form_submit')), findsNothing);
    expect(find.text('result: 9'), findsOneWidget);
  });

  testWidgets('network failure is shown inside the sheet', (tester) async {
    when(() => repo.recordMovement(1, any())).thenThrow(const NetworkFailure('Tidak dapat terhubung ke server.'));
    await openSheet(tester);

    await enterQuantity(tester, '1');
    await submit(tester);

    expect(find.text(l10nOf(tester).networkUnreachable), findsOneWidget);
  });
}

class _Opener extends StatefulWidget {
  const _Opener({required this.open});

  final Future<MovementResult?> Function() open;

  @override
  State<_Opener> createState() => _OpenerState();
}

class _OpenerState extends State<_Opener> {
  MovementResult? _result;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () async {
            final r = await widget.open();
            setState(() => _result = r);
          },
          child: const Text('open'),
        ),
        if (_result != null) Text('result: ${_result!.movement.id}'),
      ],
    );
  }
}
