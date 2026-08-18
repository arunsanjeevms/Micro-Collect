import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_entry.freezed.dart';

enum CollectionStatus { collected, pending, overdue, partial }

enum PaymentMode { cash, upi, bank }

/// ─── Collection Entry ───────────────────────────────────────────
@freezed
abstract class CollectionEntry with _$CollectionEntry {
  const CollectionEntry._();

  const factory CollectionEntry({
    required String id,
    required String borrowerId,
    required String borrowerName,
    required String loanId,
    /// Arrears carried over from before today - a missed installment from
    /// an earlier collection day that's still outstanding. Kept separate
    /// from [amountDue] (what's due today) so the UI can show both, the
    /// way a field officer needs to when a customer owes for more than
    /// just today.
    @Default(0) double previousDue,
    required double amountDue,
    double? amountPaid,
    required DateTime dueDate,
    DateTime? paidDate,
    PaymentMode? paymentMode,
    String? notes,
    required CollectionStatus status,
  }) = _CollectionEntry;

  double get totalDue => previousDue + amountDue;
}
