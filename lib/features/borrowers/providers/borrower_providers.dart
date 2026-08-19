import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/data/data_revision.dart';
import '../../../core/data/entity_kind.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/models/borrower.dart';
import '../../../data/repositories/borrower_repository.dart';
import '../../../data/repositories/repository_providers.dart';

part 'borrower_providers.freezed.dart';
part 'borrower_providers.g.dart';

@riverpod
Future<List<Borrower>> borrowers(Ref ref) {
  ref.watch(dataRevisionProvider(EntityKind.borrower));
  return ref.watch(borrowerRepositoryProvider).fetchAll();
}

@riverpod
Future<Borrower> borrowerById(Ref ref, String id) async {
  ref.watch(dataRevisionProvider(EntityKind.borrower));
  final borrower = await ref.watch(borrowerRepositoryProvider).findById(id);
  if (borrower == null) throw NotFoundException('Borrower', id);
  return borrower;
}

/// Counts per status, for the filter chips - derived from the same list the
/// screen already fetched rather than a separate repository round trip.
@riverpod
Future<Map<BorrowerStatus, int>> borrowerStatusCounts(Ref ref) async {
  final all = await ref.watch(borrowersProvider.future);
  return {
    for (final status in BorrowerStatus.values)
      status: all.where((b) => b.status == status).length,
  };
}

@freezed
abstract class BorrowerFilter with _$BorrowerFilter {
  const BorrowerFilter._();

  const factory BorrowerFilter({
    @Default('') String search,
    BorrowerStatus? status,
  }) = _BorrowerFilter;

  bool get isDefault => search.isEmpty && status == null;

  bool matches(Borrower borrower) {
    if (status != null && borrower.status != status) return false;
    if (search.isEmpty) return true;
    final query = search.toLowerCase();
    return borrower.name.toLowerCase().contains(query) ||
        borrower.village.toLowerCase().contains(query) ||
        borrower.mobile.contains(query);
  }
}

/// Search/filter state lives client-side rather than as a repository
/// parameter: with injected network latency, a per-keystroke repository
/// call would feel terrible. When the borrower list is large enough that
/// this stops scaling, fetchAll() becomes fetch(BorrowerQuery) and
/// filteredBorrowersProvider collapses to a one-line passthrough.
@riverpod
class BorrowerQuery extends _$BorrowerQuery {
  @override
  BorrowerFilter build() => const BorrowerFilter();

  void setSearch(String value) => state = state.copyWith(search: value);

  void setStatus(BorrowerStatus? value) =>
      state = state.copyWith(status: value);

  void clear() => state = const BorrowerFilter();
}

@riverpod
Future<List<Borrower>> filteredBorrowers(Ref ref) async {
  final all = await ref.watch(borrowersProvider.future);
  final filter = ref.watch(borrowerQueryProvider);
  return all.where(filter.matches).toList();
}

/// The borrower-registration form's controller, mirroring
/// CreateLoanController and RecordPaymentController's guard/mounted
/// pattern. No invalidate needed - MockDatabase.insertBorrower's
/// DataChange propagates to borrowersProvider on its own.
@riverpod
class CreateBorrowerController extends _$CreateBorrowerController {
  @override
  FutureOr<Borrower?> build() => null;

  Future<Borrower?> submit(BorrowerDraft draft) async {
    state = const AsyncLoading<Borrower?>();
    final result = await AsyncValue.guard(
      () => ref.read(borrowerRepositoryProvider).create(draft),
    );
    if (!ref.mounted) return null;
    state = result;
    return result.value;
  }
}
