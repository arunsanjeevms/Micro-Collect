import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/test_app.dart';

void main() {
  testWidgets('shows the hero collection figure and quick actions', (
    tester,
  ) async {
    await tester.pumpWidget(appUnderTest());
    await tester.pumpAndSettle();

    // Derived from demo_seed.dart's todayCollections(): totalCollected
    // 2200+62+500+2000=4762 of totalDue (amountDue only, excluding
    // previousDue - see CollectionSummary._summarize) 2200+62+3050+640+
    // 850+1520+2000=10322, i.e. 46.1% efficiency - not hardcoded
    // literals, since the dashboard now reads collectionSummaryProvider
    // like every other screen instead of carrying its own fabricated
    // figures.
    expect(find.text('Good Morning, Arun'), findsOneWidget);
    expect(find.text('₹4,762'), findsOneWidget);
    expect(find.text('46.1%'), findsOneWidget);
    expect(find.text('On track to meet daily target'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text('Collect Payment'), findsOneWidget);
    expect(find.text('Search Customer'), findsOneWidget);
    expect(find.text('New Loan'), findsOneWidget);
  });

  testWidgets('Collect Payment switches to the Collections tab', (
    tester,
  ) async {
    await tester.pumpWidget(appUnderTest());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Collect Payment'));
    await tester.tap(find.text('Collect Payment'));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold).first);
    expect(GoRouterState.of(context).uri.path, '/collections');
  });

  testWidgets('Search Customer navigates to the Borrowers tab', (tester) async {
    await tester.pumpWidget(appUnderTest());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Search Customer'));
    await tester.tap(find.text('Search Customer'));
    await tester.pumpAndSettle();

    expect(find.text('Borrowers'), findsWidgets);
  });
}
