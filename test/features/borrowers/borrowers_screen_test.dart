import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:microcollect/core/widgets/empty_state_widget.dart';

import '../../support/test_app.dart';

void main() {
  testWidgets('lists every seeded borrower on open', (tester) async {
    await tester.pumpWidget(appUnderTest());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Borrowers'));
    await tester.pumpAndSettle();

    expect(find.text('Rajesh Kumar'), findsOneWidget);
    expect(find.text('Lakshmi Devi'), findsOneWidget);
    expect(find.text('8 borrowers'), findsOneWidget);
  });

  testWidgets('typing in the search box narrows the list', (tester) async {
    await tester.pumpWidget(appUnderTest());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Borrowers'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Rajesh');
    await tester.pumpAndSettle();

    expect(find.text('Rajesh Kumar'), findsOneWidget);
    expect(find.text('Lakshmi Devi'), findsNothing);
    expect(find.text('1 borrower'), findsOneWidget);
  });

  testWidgets('the clear button resets the search and restores the list', (
    tester,
  ) async {
    await tester.pumpWidget(appUnderTest());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Borrowers'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Rajesh');
    await tester.pumpAndSettle();
    expect(find.text('Lakshmi Devi'), findsNothing);

    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();

    expect(find.text('Lakshmi Devi'), findsOneWidget);
    expect(find.text('8 borrowers'), findsOneWidget);
  });

  testWidgets('tapping the Overdue chip filters to only overdue borrowers', (
    tester,
  ) async {
    await tester.pumpWidget(appUnderTest());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Borrowers'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Overdue'));
    await tester.pumpAndSettle();

    // Lakshmi Devi and Sarita Bai are seeded overdue; Rajesh Kumar is active.
    expect(find.text('Lakshmi Devi'), findsOneWidget);
    expect(find.text('Sarita Bai'), findsOneWidget);
    expect(find.text('Rajesh Kumar'), findsNothing);
  });

  testWidgets('tapping All after a status filter restores the full list', (
    tester,
  ) async {
    await tester.pumpWidget(appUnderTest());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Borrowers'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Closed'));
    await tester.pumpAndSettle();
    expect(find.text('Rajesh Kumar'), findsNothing);

    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    expect(find.text('Rajesh Kumar'), findsOneWidget);
    expect(find.text('8 borrowers'), findsOneWidget);
  });

  testWidgets(
    'a search with no matches shows the empty state, not a blank list',
    (tester) async {
      await tester.pumpWidget(appUnderTest());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Borrowers'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Nonexistent Name');
      await tester.pumpAndSettle();

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text('No matches'), findsOneWidget);
    },
  );
}
