import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_entry.freezed.dart';

enum CollectionStatus { collected, pending, overdue, partial }

/// ─── Collection Entry ───────────────────────────────────────────
@freezed
abstract class CollectionEntry with _$CollectionEntry {
  const factory CollectionEntry({
    required String id,
    required String borrowerId,
    required String borrowerName,
    required String loanId,
    required double amountDue,
    double? amountPaid,
    required DateTime dueDate,
    DateTime? paidDate,
    String? paymentMode, // cash, upi, bank
    String? notes,
    required CollectionStatus status,
  }) = _CollectionEntry;
}
