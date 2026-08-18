import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:microcollect/core/models/collection_entry.dart';
import 'package:microcollect/data/mock/mock_bindings.dart';
import 'package:microcollect/data/repositories/collection_repository.dart';
import 'package:microcollect/features/collections/providers/collection_providers.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(overrides: mockBackendOverrides());
    addTearDown(container.dispose);
  });

  group('todayCollectionsProvider', () {
    test('resolves to every seeded entry for today', () async {
      final entries = await container.read(todayCollectionsProvider.future);
      expect(entries, hasLength(7));
    });
  });

  group('collectionSummaryProvider', () {
    test('aggregates totals across today\'s entries', () async {
      final entries = await container.read(todayCollectionsProvider.future);
      final summary = await container.read(collectionSummaryProvider.future);

      expect(
        summary.totalDue,
        entries.fold<double>(0, (s, e) => s + e.amountDue),
      );
    });
  });

  group('filteredCollectionsProvider', () {
    setUp(() {
      container.listen(filteredCollectionsProvider, (_, _) {});
    });

    test('is unfiltered by default', () async {
      final all = await container.read(todayCollectionsProvider.future);
      final filtered = await container.read(filteredCollectionsProvider.future);
      expect(filtered, hasLength(all.length));
    });

    test('narrows to a single status', () async {
      await container.read(filteredCollectionsProvider.future);
      container
          .read(collectionStatusFilterProvider.notifier)
          .set(CollectionStatus.pending);

      final filtered = await container.read(filteredCollectionsProvider.future);
      expect(filtered, isNotEmpty);
      expect(
        filtered.every((e) => e.status == CollectionStatus.pending),
        isTrue,
      );
    });

    test('setting the filter back to null restores every entry', () async {
      await container.read(filteredCollectionsProvider.future);
      final notifier = container.read(collectionStatusFilterProvider.notifier);

      notifier.set(CollectionStatus.overdue);
      await container.read(filteredCollectionsProvider.future);

      notifier.set(null);
      final all = await container.read(todayCollectionsProvider.future);
      final filtered = await container.read(filteredCollectionsProvider.future);
      expect(filtered, hasLength(all.length));
    });
  });

  group('RecordPaymentController', () {
    setUp(() {
      // Auto-dispose: a bare container.read wouldn't hold this notifier
      // alive across the async gap inside submit(), which would tear it
      // down mid-await and make ref.mounted false - listen pins it the
      // way a mounted screen watching the controller would.
      container.listen(recordPaymentControllerProvider, (_, _) {});
    });

    test('submit records the payment and returns a receipt', () async {
      final receipt = await container
          .read(recordPaymentControllerProvider.notifier)
          .submit(
            const RecordPaymentInput(
              collectionId: 'C006',
              amount: 1520,
              mode: PaymentMode.upi,
            ),
          );

      expect(receipt, isNotNull);
      expect(receipt!.payment.amount, 1520);
    });

    test(
      'a failed submission surfaces as an error, not a thrown exception',
      () async {
        final receipt = await container
            .read(recordPaymentControllerProvider.notifier)
            .submit(
              const RecordPaymentInput(
                collectionId: 'C999', // unknown entry
                amount: 100,
                mode: PaymentMode.cash,
              ),
            );

        expect(receipt, isNull);
        expect(
          container.read(recordPaymentControllerProvider).hasError,
          isTrue,
        );
      },
    );

    test('recording a payment updates todayCollectionsProvider', () async {
      container.listen(todayCollectionsProvider, (_, _) {});
      await container.read(todayCollectionsProvider.future);

      await container
          .read(recordPaymentControllerProvider.notifier)
          .submit(
            const RecordPaymentInput(
              collectionId: 'C006',
              amount: 1520,
              mode: PaymentMode.upi,
            ),
          );
      // The store's change stream delivers asynchronously (broadcast
      // StreamController defaults to microtask delivery), so the revision
      // bump that todayCollectionsProvider depends on may not have been
      // processed the instant submit() resolves - give it a beat.
      await Future<void>.delayed(Duration.zero);

      final entries = await container.read(todayCollectionsProvider.future);
      final updated = entries.firstWhere((e) => e.id == 'C006');
      expect(updated.status, CollectionStatus.collected);
    });
  });

  group('paymentsForLoanProvider', () {
    setUp(() {
      container.listen(recordPaymentControllerProvider, (_, _) {});
    });

    test('reflects a payment just recorded through the controller', () async {
      await container
          .read(recordPaymentControllerProvider.notifier)
          .submit(
            const RecordPaymentInput(
              collectionId: 'C006',
              amount: 1520,
              mode: PaymentMode.upi,
            ),
          );

      final payments = await container.read(
        paymentsForLoanProvider('L008').future,
      );
      expect(payments, hasLength(1));
    });
  });
}
