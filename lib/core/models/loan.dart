import 'package:freezed_annotation/freezed_annotation.dart';

import 'installment.dart';

part 'loan.freezed.dart';

enum LoanStatus { active, closed, overdue, disbursed }

/// ─── Loan Model ──────────────────────────────────────────────────
@freezed
abstract class Loan with _$Loan {
  const Loan._();

  const factory Loan({
    required String id,
    required String borrowerId,
    required String borrowerName,
    required double principal,
    required double annualRate,
    required int tenureMonths,
    required String frequency, // daily, weekly, monthly
    required double totalRepayable,
    required double totalPaid,
    required int paidInstallments,
    required int totalInstallments,
    required DateTime disbursementDate,
    DateTime? closedDate,
    required LoanStatus status,
    required List<Installment> installments,
  }) = _Loan;

  double get outstanding => totalRepayable - totalPaid;
  double get progressPercent =>
      totalInstallments > 0 ? (paidInstallments / totalInstallments) * 100 : 0;
  double get installmentAmount =>
      totalInstallments > 0 ? totalRepayable / totalInstallments : 0;
}
