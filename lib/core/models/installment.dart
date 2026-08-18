/// ─── Installment Model ──────────────────────────────────────────
class Installment {
  final String id;
  final int number;
  final DateTime dueDate;
  final double amount;
  final double? paidAmount;
  final DateTime? paidDate;
  final InstallmentStatus status;

  const Installment({
    required this.id,
    required this.number,
    required this.dueDate,
    required this.amount,
    this.paidAmount,
    this.paidDate,
    required this.status,
  });
}

enum InstallmentStatus { paid, pending, overdue, partial, advance }
