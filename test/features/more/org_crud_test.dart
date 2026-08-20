import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_app.dart';

void main() {
  testWidgets('creating and deleting a loan scheme updates the list', (
    tester,
  ) async {
    await tester.pumpWidget(appUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Loan Schemes'));
    await tester.pumpAndSettle();

    // Seeded schemes are visible.
    expect(find.text('Weekly Micro Loan'), findsOneWidget);

    // Create a new scheme.
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Code'),
      'TST-01',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Name'),
      'Test Scheme',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Min Principal'),
      '1000',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Max Principal'),
      '5000',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Min Tenure'),
      '1',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Max Tenure'),
      '6',
    );
    await tester.ensureVisible(find.text('Create Scheme'));
    await tester.tap(find.text('Create Scheme'));
    await tester.pumpAndSettle();

    expect(find.text('New Loan Scheme'), findsNothing);
    await tester.scrollUntilVisible(
      find.text('Test Scheme'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Test Scheme'), findsOneWidget);

    // Delete it again.
    final deleteIcon = find.descendant(
      of: find
          .ancestor(
            of: find.text('Test Scheme'),
            matching: find.byType(Container),
          )
          .first,
      matching: find.byIcon(Icons.delete_outline_rounded),
    );
    await tester.ensureVisible(deleteIcon);
    await tester.pumpAndSettle();
    await tester.tap(deleteIcon);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Test Scheme'), findsNothing);
  });

  testWidgets('toggling a permission on a role persists', (tester) async {
    await tester.pumpWidget(appUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Roles & Permissions'));
    await tester.pumpAndSettle();

    // Cashier starts with "Can Sync Offline Data" ungranted.
    await tester.tap(find.text('Cashier'));
    await tester.pumpAndSettle();

    final switchFinder = find.widgetWithText(Row, 'Can Sync Offline Data');
    expect(switchFinder, findsOneWidget);

    await tester.tap(
      find.descendant(of: switchFinder, matching: find.byType(Switch)),
    );
    await tester.pumpAndSettle();

    final updatedSwitch = tester.widget<Switch>(
      find.descendant(of: switchFinder, matching: find.byType(Switch)),
    );
    expect(updatedSwitch.value, isTrue);
  });
}
