import '../../core/models/loan.dart';

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
}
