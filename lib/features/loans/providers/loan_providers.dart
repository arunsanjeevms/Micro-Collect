import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/data/data_revision.dart';
import '../../../core/data/entity_kind.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/models/loan.dart';
import '../../../data/repositories/loan_repository.dart';
import '../../../data/repositories/repository_providers.dart';

part 'loan_providers.g.dart';

@riverpod
Future<List<Loan>> loans(Ref ref) {
  ref.watch(dataRevisionProvider(EntityKind.loan));
  return ref.watch(loanRepositoryProvider).fetchAll();
}

@riverpod
Future<Loan> loanById(Ref ref, String id) async {
  ref.watch(dataRevisionProvider(EntityKind.loan));
  final loan = await ref.watch(loanRepositoryProvider).findById(id);
  if (loan == null) throw NotFoundException('Loan', id);
  return loan;
}

@riverpod
Future<List<Loan>> loansForBorrower(Ref ref, String borrowerId) {
  ref.watch(dataRevisionProvider(EntityKind.loan));
  return ref.watch(loanRepositoryProvider).fetchForBorrower(borrowerId);
}

/// The create-loan form's controller. Like RecordPaymentController, calls
/// no invalidate anywhere - MockDatabase.insertLoan's DataChange (loan +
/// borrower) propagates to every dependent provider on its own.
@riverpod
class CreateLoanController extends _$CreateLoanController {
  @override
  FutureOr<Loan?> build() => null;

  Future<Loan?> submit(LoanDraft draft) async {
    state = const AsyncLoading<Loan?>();
    final result = await AsyncValue.guard(
      () => ref.read(loanRepositoryProvider).create(draft),
    );
    if (!ref.mounted) return null;
    state = result;
    return result.value;
  }
}
