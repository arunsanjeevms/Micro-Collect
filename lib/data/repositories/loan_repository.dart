import '../../core/models/collection_entry.dart' show PaymentMode;
import '../../core/models/loan.dart';
import 'collection_repository.dart' show PaymentReceipt;

/// The fields a new loan application collects.
class LoanDraft {
  const LoanDraft({
    required this.borrowerId,
    required this.principal,
    required this.annualRate,
    required this.tenureMonths,
    required this.frequency,
    this.advanceInstallments = 0,
  });

  final String borrowerId;
  final double principal;
  final double annualRate;
  final int tenureMonths;
  final String frequency; // daily, weekly, monthly
  final int advanceInstallments;
}

abstract interface class LoanRepository {
  Future<List<Loan>> fetchAll();

  Future<Loan?> findById(String id);

  Future<List<Loan>> fetchForBorrower(String borrowerId);

  Future<Loan> create(LoanDraft draft);

  /// Settles a loan's full remaining outstanding in one payment and marks
  /// it closed. Returns the same PaymentReceipt shape recordPayment does,
  /// so the closure flow can reuse PaymentSuccessScreen/PaymentReceiptScreen.
  Future<PaymentReceipt> closeLoan(
    String loanId, {
    required PaymentMode mode,
    String? notes,
  });
}
