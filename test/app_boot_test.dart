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
}
