/// ─── Collection Entry ───────────────────────────────────────────
class CollectionEntry {
  final String id;
  final String borrowerId;
  final String borrowerName;
  final String loanId;
  final double amountDue;
  final double? amountPaid;
  final DateTime dueDate;
  final DateTime? paidDate;
  final String? paymentMode; // cash, upi, bank
  final String? notes;
  final CollectionStatus status;

  const CollectionEntry({
    required this.id,
    required this.borrowerId,
    required this.borrowerName,
    required this.loanId,
    required this.amountDue,
    this.amountPaid,
    required this.dueDate,
    this.paidDate,
    this.paymentMode,
    this.notes,
    required this.status,
  });
}

enum CollectionStatus { collected, pending, overdue, partial }
