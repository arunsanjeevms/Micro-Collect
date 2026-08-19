import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('app boots to the dashboard with bottom navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(appUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('MicroCollect'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Borrowers'), findsOneWidget);
    expect(find.text('Collect'), findsOneWidget);
    expect(find.text('Reports'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);
  });

  testWidgets('the More tab opens the admin/settings hub and its sub-screens', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(appUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();

    expect(find.text('Employees'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Company Profile'), findsOneWidget);
    expect(find.text('Printer Settings'), findsOneWidget);

    await tester.tap(find.text('Company Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Rural Microfinance'), findsOneWidget);
  });

  testWidgets('tapping a bottom nav tab navigates to that screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(appUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Borrowers'));
    await tester.pumpAndSettle();

    expect(find.text('Borrowers'), findsWidgets);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets(
    'the add-borrower FAB opens the registration wizard, not a borrower detail page',
    (WidgetTester tester) async {
      // Regression test: "/borrowers/:id" was declared before "/borrowers/add"
      // in the route table, so go_router matched "/borrowers/add" as a detail
      // route with id "add" and threw looking up a borrower with that id.
      await tester.pumpWidget(appUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Borrowers'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
      await tester.pumpAndSettle();

      expect(find.text('Add Borrower'), findsOneWidget);
      expect(find.text('Step 1 of 5'), findsOneWidget);
      expect(find.text('Borrower not found'), findsNothing);
    },
  );

  testWidgets(
    'completing the registration wizard adds the borrower to the list',
    (WidgetTester tester) async {
      await tester.pumpWidget(appUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Borrowers'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
      await tester.pumpAndSettle();

      // Step 1: Basic Info
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name *'),
        'Test Borrower',
      );
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Step 2: Contact & Address
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Mobile Number *'),
        '9876543210',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Aadhaar Number *'),
        '123456789012',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Address *'),
        '12 Test Street',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Village / Town *'),
        'Test Village',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'PIN Code *'),
        '507001',
      );
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Step 3: KYC & Nominee - every field is optional.
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Step 4: Documents & Signature - signature is required to advance.
      await tester.tap(find.text('Tap to sign here'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Step 5: Review & Submit
      expect(find.text('Register Borrower'), findsOneWidget);
      await tester.tap(find.text('Register Borrower'));
      await tester.pumpAndSettle();

      expect(find.text('Add Borrower'), findsNothing);
      await tester.scrollUntilVisible(
        find.text('Test Borrower'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      expect(find.text('Test Borrower'), findsOneWidget);
    },
  );

  testWidgets(
    'tapping a loan card on a borrower profile opens that loan\'s detail page',
    (WidgetTester tester) async {
      await tester.pumpWidget(appUnderTest());
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
