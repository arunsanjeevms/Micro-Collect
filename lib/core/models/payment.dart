import 'package:freezed_annotation/freezed_annotation.dart';

import 'collection_entry.dart' show PaymentMode;

part 'payment.freezed.dart';

/// A recorded payment. Distinct from CollectionEntry (which represents a
/// day's due row that may or may not have been paid yet) - a Payment is the
/// durable record of money actually collected, and is what payment history
/// and receipts are built from.
@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String receiptNo,
    required String borrowerId,
    required String borrowerName,
    required String loanId,
    required List<String> installmentIds,
    required double amount,
    required PaymentMode mode,
    String? notes,
    required DateTime paidAt,
  }) = _Payment;
}
