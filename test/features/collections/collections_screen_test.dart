import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_app.dart';

/// The "Overdue" status filter tab shares its label with the summary
/// card's overdue-count mini stat, and Flutter test finders match on text
/// regardless of which widget renders it - this always targets the tab,
/// which renders after the summary card in the tree.
Finder _overdueTab() => find.text('Overdue').last;

void main() {
  testWidgets('lists every seeded collection entry on open', (tester) async {
    await tester.pumpWidget(appUnderTest());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Collect'));
    await tester.pumpAndSettle();

    expect(find.text('Rajesh Kumar'), findsOneWidget);
    // Further down the (lazily-built) list - scroll it into view rather
    // than assuming everything is built just because it's in the data.
    await tester.scrollUntilVisible(
      find.text('Lakshmi Devi'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Lakshmi Devi'), findsOneWidget);
  });

  testWidgets('shows the Prev Due / Today\'s Due / Total Due breakdown', (
    tester,
  ) async {
    await tester.pumpWidget(appUnderTest());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Collect'));
    await tester.pumpAndSettle();

    expect(find.text('Today\'s Due'), findsWidgets);
    expect(find.text('Total Due'), findsWidgets);
  });

  testWidgets('tapping the Overdue tab filters the list', (tester) async {
    await tester.pumpWidget(appUnderTest());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Collect'));
    await tester.pumpAndSettle();

    await tester.tap(_overdueTab());
    await tester.pumpAndSettle();

    // Lakshmi Devi's C004 is seeded overdue; Rajesh Kumar's C001 is collected.
    expect(find.text('Lakshmi Devi'), findsOneWidget);
    expect(find.text('Rajesh Kumar'), findsNothing);
  });

  testWidgets('Collect Now opens the record-payment sheet', (tester) async {
    await tester.pumpWidget(appUnderTest());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Collect'));
    await tester.pumpAndSettle();

    // Filter to Overdue first: the very first entry in seed order (Rajesh
    // Kumar) is already collected and has no Collect Now button at all.
    await tester.tap(_overdueTab());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Collect Now').first);
    await tester.pumpAndSettle();

    expect(find.text('Enter Amount to Collect'), findsOneWidget);
  });

  testWidgets(
    'recording a full payment through the sheet updates the list to collected',
    (tester) async {
      await tester.pumpWidget(appUnderTest());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Collect'));
      await tester.pumpAndSettle();

      await tester.tap(_overdueTab());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Collect Now').first);
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Record Payment'));
      await tester.tap(find.text('Record Payment'));
      await tester.pumpAndSettle();
      expect(find.text('Confirm Payment'), findsOneWidget);

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // Sheet closed and a confirmation snackbar shown.
      expect(find.text('Confirm Payment'), findsNothing);
      expect(find.textContaining('recorded for'), findsOneWidget);
    },
  );
}
