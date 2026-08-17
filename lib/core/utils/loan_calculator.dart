/// Frontend-only loan calculation utilities.
/// These are isolated so the future backend can become the source of truth.
class LoanCalculator {
  LoanCalculator._();

  /// Calculate total repayable amount
  /// principal + (principal * rate/100 * tenure)
  static double totalRepayable({
    required double principal,
    required double annualRate,
    required int tenureMonths,
  }) {
    final interest = (principal * annualRate * tenureMonths) / (12 * 100);
    return principal + interest;
  }

  /// Calculate installment amount
  static double installmentAmount({
    required double totalRepayable,
    required int numberOfInstallments,
  }) {
    if (numberOfInstallments <= 0) return 0;
    return (totalRepayable / numberOfInstallments).ceilToDouble();
  }

  /// Calculate simple interest
  static double simpleInterest({
    required double principal,
    required double annualRate,
    required int tenureMonths,
  }) {
    return (principal * annualRate * tenureMonths) / (12 * 100);
  }

  /// Calculate advance deduction amount
  static double advanceDeduction({
    required double totalRepayable,
    required int advanceInstallments,
    required int totalInstallments,
  }) {
    if (totalInstallments <= 0) return 0;
    final perInstallment = totalRepayable / totalInstallments;
    return perInstallment * advanceInstallments;
  }

  /// Calculate disbursement amount (after advance deduction)
  static double disbursementAmount({
    required double principal,
    required double advanceDeduction,
  }) {
    return principal - advanceDeduction;
  }

  /// Calculate outstanding balance
  static double outstandingBalance({
    required double totalRepayable,
    required double totalPaid,
  }) {
    return (totalRepayable - totalPaid).clamp(0, double.infinity);
  }

  /// Calculate penalty amount
  static double penaltyAmount({
    required double installmentAmount,
    required double penaltyRate,
    required int overdueDays,
  }) {
    return (installmentAmount * penaltyRate * overdueDays) / (30 * 100);
  }

  /// Number of installments by frequency
  static int installmentCount({
    required int tenureMonths,
    required String frequency, // 'daily', 'weekly', 'monthly'
  }) {
    switch (frequency.toLowerCase()) {
      case 'daily':
        return tenureMonths * 30;
      case 'weekly':
        return (tenureMonths * 30 / 7).ceil();
      case 'monthly':
        return tenureMonths;
      default:
        return tenureMonths;
    }
  }

  /// Calculate collection efficiency percentage
  static double collectionEfficiency({
    required double collected,
    required double due,
  }) {
    if (due <= 0) return 100.0;
    return ((collected / due) * 100).clamp(0, 100);
  }
}
