import '../../core/models/collection_entry.dart';
import '../../core/models/payment.dart';

/// Aggregate figures for a day's collections - the numbers the collections
/// screen's summary card and the dashboard both need, computed once by the
/// repository instead of by every screen that wants them.
class CollectionSummary {
  const CollectionSummary({
    required this.totalDue,
    required this.totalCollected,
    required this.collectedCount,
    required this.pendingCount,
    required this.overdueCount,
    required this.partialCount,
  });

  final double totalDue;
  final double totalCollected;
  final int collectedCount;
  final int pendingCount;
  final int overdueCount;
  final int partialCount;

  double get efficiency => totalDue > 0 ? (totalCollected / totalDue) * 100 : 100;
}

/// What recordPayment needs: which of today's collection entries this
/// payment is against, and how much/how/for what.
class RecordPaymentInput {
  const RecordPaymentInput({
    required this.collectionId,
    required this.amount,
    required this.mode,
    this.notes,
  });

  final String collectionId;
  final double amount;
  final PaymentMode mode;
  final String? notes;
}

/// What the confirmation screen renders. Built from the repository's own
/// record of what happened, not re-derived from whatever the amount field
/// said client-side, so the receipt can never disagree with what was
/// actually applied (e.g. how a surplus was allocated).
class PaymentReceipt {
  const PaymentReceipt({
    required this.payment,
    required this.touchedInstallmentNumbers,
    required this.newLoanOutstanding,
    required this.newBorrowerOutstanding,
  });

  final Payment payment;
  final List<int> touchedInstallmentNumbers;
  final double newLoanOutstanding;
  final double newBorrowerOutstanding;
}

abstract interface class CollectionRepository {
  Future<List<CollectionEntry>> fetchForDate(DateTime date);

  Future<CollectionSummary> summaryForDate(DateTime date);

  Future<PaymentReceipt> recordPayment(RecordPaymentInput input);

  Future<List<Payment>> paymentsForLoan(String loanId);

  Future<List<Payment>> paymentsForBorrower(String borrowerId, {int limit});
}
