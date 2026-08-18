import '../models/installment.dart';

/// The result of allocating a payment across a loan's instalments.
class PaymentAllocationResult {
  const PaymentAllocationResult({
    required this.updatedInstallments,
    required this.touchedInstallmentIds,
  });

  final List<Installment> updatedInstallments;
  final List<String> touchedInstallmentIds;
}

/// Frontend-only payment allocation, isolated for the same reason as
/// LoanCalculator: a future backend owns this for real.
///
/// Applies an amount to a loan's unpaid instalments oldest-due-first
/// (overdue, then partial, then pending in due-date order). An instalment
/// fully covered is marked paid (or advance, if its due date hasn't
/// arrived yet); one only partly covered by what's left is marked partial;
/// anything beyond the last instalment in the list is simply not applied -
/// callers are expected to validate the amount against outstanding balance
/// before calling this.
class PaymentAllocator {
  PaymentAllocator._();

  static PaymentAllocationResult allocate({
    required List<Installment> installments,
    required double amount,
    required DateTime asOf,
  }) {
    final ordered = _payableOrder(installments);
    final updates = <String, Installment>{};
    var remaining = amount;

    for (final installment in ordered) {
      if (remaining <= 0) break;

      final alreadyPaid = installment.paidAmount ?? 0;
      final outstanding = installment.amount - alreadyPaid;
      if (outstanding <= 0) continue;

      if (remaining >= outstanding) {
        final isAdvance = installment.dueDate.isAfter(asOf);
        updates[installment.id] = installment.copyWith(
          paidAmount: installment.amount,
          paidDate: asOf,
          status: isAdvance
              ? InstallmentStatus.advance
              : InstallmentStatus.paid,
        );
        remaining -= outstanding;
      } else {
        updates[installment.id] = installment.copyWith(
          paidAmount: alreadyPaid + remaining,
          paidDate: asOf,
          status: InstallmentStatus.partial,
        );
        remaining = 0;
      }
    }

    return PaymentAllocationResult(
      updatedInstallments: installments.map((i) => updates[i.id] ?? i).toList(),
      touchedInstallmentIds: updates.keys.toList(),
    );
  }

  static List<Installment> _payableOrder(List<Installment> installments) {
    final unpaid = installments
        .where(
          (i) =>
              i.status == InstallmentStatus.overdue ||
              i.status == InstallmentStatus.pending ||
              i.status == InstallmentStatus.partial,
        )
        .toList();
    unpaid.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return unpaid;
  }
}
