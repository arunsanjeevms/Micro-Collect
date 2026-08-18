import 'installment.dart';

/// ─── Loan Model ──────────────────────────────────────────────────
class Loan {
  final String id;
  final String borrowerId;
  final String borrowerName;
  final double principal;
  final double annualRate;
  final int tenureMonths;
  final String frequency; // daily, weekly, monthly
  final double totalRepayable;
  final double totalPaid;
  final int paidInstallments;
  final int totalInstallments;
  final DateTime disbursementDate;
  final DateTime? closedDate;
  final LoanStatus status;
  final List<Installment> installments;

  const Loan({
    required this.id,
    required this.borrowerId,
    required this.borrowerName,
    required this.principal,
    required this.annualRate,
    required this.tenureMonths,
    required this.frequency,
    required this.totalRepayable,
    required this.totalPaid,
    required this.paidInstallments,
    required this.totalInstallments,
    required this.disbursementDate,
    this.closedDate,
    required this.status,
    required this.installments,
  });

  double get outstanding => totalRepayable - totalPaid;
  double get progressPercent =>
      totalInstallments > 0 ? (paidInstallments / totalInstallments) * 100 : 0;
  double get installmentAmount =>
      totalInstallments > 0 ? totalRepayable / totalInstallments : 0;
}

enum LoanStatus { active, closed, overdue, disbursed }
