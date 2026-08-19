import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/data/data_revision.dart';
import '../../../core/data/entity_kind.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/models/collection_entry.dart' show PaymentMode;
import '../../../core/models/loan.dart';
import '../../../data/repositories/collection_repository.dart'
    show PaymentReceipt;
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

/// The Loan Closure screen's controller. Reuses PaymentReceipt so the
/// success flow can be the same PaymentSuccessScreen/PaymentReceiptScreen
/// a regular payment lands on.
@riverpod
class CloseLoanController extends _$CloseLoanController {
  @override
  FutureOr<PaymentReceipt?> build() => null;

  Future<PaymentReceipt?> submit(
    String loanId, {
    required PaymentMode mode,
    String? notes,
  }) async {
    state = const AsyncLoading<PaymentReceipt?>();
    final result = await AsyncValue.guard(
      () => ref
          .read(loanRepositoryProvider)
          .closeLoan(loanId, mode: mode, notes: notes),
    );
    if (!ref.mounted) return null;
    state = result;
    return result.value;
  }
}
