import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:microcollect/core/errors/app_exception.dart';
import 'package:microcollect/core/widgets/async_value_view.dart';
import 'package:microcollect/core/widgets/error_state_widget.dart';
import 'package:microcollect/core/widgets/skeleton_loader.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('renders the data branch for AsyncData', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AsyncValueView<int>(
          value: const AsyncData(42),
          data: (value) => Text('value: $value'),
        ),
      ),
    );

    expect(find.text('value: 42'), findsOneWidget);
  });

  testWidgets('renders a ListSkeleton while loading by default', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        AsyncValueView<int>(
          value: const AsyncLoading(),
          data: (value) => Text('value: $value'),
        ),
      ),
    );

    expect(find.byType(ListSkeleton), findsOneWidget);
  });

  testWidgets('renders a custom loading widget when supplied', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AsyncValueView<int>(
          value: const AsyncLoading(),
          data: (value) => Text('value: $value'),
          loading: () => const Text('custom loading'),
        ),
      ),
    );

    expect(find.text('custom loading'), findsOneWidget);
    expect(find.byType(ListSkeleton), findsNothing);
  });

  testWidgets('renders ErrorStateWidget for AsyncError', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AsyncValueView<int>(
          value: AsyncError(const NetworkException(), StackTrace.empty),
          data: (value) => Text('value: $value'),
        ),
      ),
    );

    expect(find.byType(ErrorStateWidget), findsOneWidget);
    expect(find.text('You\'re offline'), findsOneWidget);
  });

  testWidgets('wires onRetry through to the error state\'s retry button', (
    tester,
  ) async {
    var retried = false;
    await tester.pumpWidget(
      _wrap(
        AsyncValueView<int>(
          value: AsyncError(const NetworkException(), StackTrace.empty),
          data: (value) => Text('value: $value'),
          onRetry: () => retried = true,
        ),
      ),
    );

    await tester.tap(find.text('Retry'));
    expect(retried, isTrue);
  });

  testWidgets('renders empty when data is present but isEmpty matches', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        AsyncValueView<List<int>>(
          value: const AsyncData(<int>[]),
          data: (value) => Text('count: ${value.length}'),
          empty: const Text('nothing here'),
          isEmpty: (value) => value.isEmpty,
        ),
      ),
    );

    expect(find.text('nothing here'), findsOneWidget);
    expect(find.textContaining('count:'), findsNothing);
  });

  testWidgets('renders data instead of empty when isEmpty does not match', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        AsyncValueView<List<int>>(
          value: const AsyncData([1, 2, 3]),
          data: (value) => Text('count: ${value.length}'),
          empty: const Text('nothing here'),
          isEmpty: (value) => value.isEmpty,
        ),
      ),
    );

    expect(find.text('count: 3'), findsOneWidget);
    expect(find.text('nothing here'), findsNothing);
  });
}
