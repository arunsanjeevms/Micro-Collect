import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/data/data_revision.dart';
import '../../../core/data/entity_kind.dart';
import '../../../core/models/collection_entry.dart';
import '../../../core/models/payment.dart';
import '../../../data/repositories/collection_repository.dart';
import '../../../data/repositories/repository_providers.dart';

part 'collection_providers.g.dart';

@riverpod
Future<List<CollectionEntry>> todayCollections(Ref ref) {
  ref.watch(dataRevisionProvider(EntityKind.collection));
  return ref.watch(collectionRepositoryProvider).fetchForDate(DateTime.now());
}

@riverpod
Future<CollectionSummary> collectionSummary(Ref ref) {
  ref.watch(dataRevisionProvider(EntityKind.collection));
  return ref.watch(collectionRepositoryProvider).summaryForDate(DateTime.now());
}

@riverpod
class CollectionStatusFilter extends _$CollectionStatusFilter {
  @override
  CollectionStatus? build() => null; // null = every status ("All Due")

  void set(CollectionStatus? status) => state = status;
}

@riverpod
Future<List<CollectionEntry>> filteredCollections(Ref ref) async {
  final all = await ref.watch(todayCollectionsProvider.future);
  final status = ref.watch(collectionStatusFilterProvider);
  if (status == null) return all;
  return all.where((e) => e.status == status).toList();
}

@riverpod
Future<List<Payment>> todayPayments(Ref ref) {
  ref.watch(dataRevisionProvider(EntityKind.payment));
  return ref
      .watch(collectionRepositoryProvider)
      .paymentsForDate(DateTime.now());
}

@riverpod
Future<List<Payment>> paymentsForLoan(Ref ref, String loanId) {
  ref.watch(dataRevisionProvider(EntityKind.payment));
  return ref.watch(collectionRepositoryProvider).paymentsForLoan(loanId);
}

@riverpod
Future<List<Payment>> paymentsForBorrower(Ref ref, String borrowerId) {
  ref.watch(dataRevisionProvider(EntityKind.payment));
  return ref
      .watch(collectionRepositoryProvider)
      .paymentsForBorrower(borrowerId);
}

/// The record-payment sheet's controller. Deliberately doesn't call
/// ref.invalidate anywhere - MockDatabase.recordPayment's DataChange
/// propagates through dataRevisionProvider to every provider above (and to
/// borrower/loan providers) on its own.
@riverpod
class RecordPaymentController extends _$RecordPaymentController {
  @override
  FutureOr<PaymentReceipt?> build() => null;

  Future<PaymentReceipt?> submit(RecordPaymentInput input) async {
    // No copyWithPrevious: this controller's state is always null between
    // submissions (build() returns null), so there's nothing worth
    // retaining through the loading state.
    state = const AsyncLoading<PaymentReceipt?>();
    final result = await AsyncValue.guard(
      () => ref.read(collectionRepositoryProvider).recordPayment(input),
    );
    if (!ref.mounted) return null;
    state = result;
    return result.value;
  }
}
