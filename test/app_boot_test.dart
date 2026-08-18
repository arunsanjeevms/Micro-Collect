import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:microcollect/app.dart';

void main() {
  testWidgets('app boots to the dashboard with bottom navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MicroCollectApp()));
    await tester.pumpAndSettle();

    expect(find.text('MicroCollect'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Borrowers'), findsOneWidget);
    expect(find.text('Collect'), findsOneWidget);
    expect(find.text('Reports'), findsOneWidget);
  });

  testWidgets('tapping a bottom nav tab navigates to that screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MicroCollectApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Borrowers'));
    await tester.pumpAndSettle();

    expect(find.text('Borrowers'), findsWidgets);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets(
    'the add-borrower FAB opens the registration form, not a borrower detail page',
    (WidgetTester tester) async {
      // Regression test: "/borrowers/:id" was declared before "/borrowers/add"
      // in the route table, so go_router matched "/borrowers/add" as a detail
      // route with id "add" and threw looking up a borrower with that id.
      await tester.pumpWidget(const ProviderScope(child: MicroCollectApp()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Borrowers'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
      await tester.pumpAndSettle();

      expect(find.text('Add Borrower'), findsOneWidget);
      expect(find.text('Register Borrower'), findsOneWidget);
      expect(find.text('Borrower not found'), findsNothing);
    },
  );

  testWidgets(
    'tapping a loan card on a borrower profile opens that loan\'s detail page',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MicroCollectApp()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Borrowers'));
      await tester.pumpAndSettle();

      // Rajesh Kumar (B001) is seeded with loan L001.
      await tester.tap(find.text('Rajesh Kumar'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('L001'));
      await tester.tap(find.text('L001'));
      await tester.pumpAndSettle();

      expect(find.text('Loan L001'), findsOneWidget);
    },
  );
}
