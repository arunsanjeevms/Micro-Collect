/**
 * Loan calculation utilities. Ported 1:1 from
 * lib/core/utils/loan_calculator.dart so the backend and the Flutter
 * prototype agree on every number until the Flutter app is fully wired to
 * this API.
 */

function totalRepayable({ principal, annualRate, tenureMonths }) {
  const interest = (principal * annualRate * tenureMonths) / (12 * 100);
  return principal + interest;
}

function installmentAmount({ totalRepayable, numberOfInstallments }) {
  if (numberOfInstallments <= 0) return 0;
  return Math.ceil(totalRepayable / numberOfInstallments);
}

function advanceDeduction({ totalRepayable, advanceInstallments, totalInstallments }) {
  if (totalInstallments <= 0) return 0;
  const perInstallment = totalRepayable / totalInstallments;
  return perInstallment * advanceInstallments;
}

function disbursementAmount({ principal, advanceDeduction }) {
  return principal - advanceDeduction;
}

function installmentCount({ tenureMonths, frequency }) {
  switch ((frequency || '').toLowerCase()) {
    case 'daily':
      return tenureMonths * 30;
    case 'weekly':
      return Math.ceil((tenureMonths * 30) / 7);
    case 'monthly':
      return tenureMonths;
    default:
      return tenureMonths;
  }
}

function collectionEfficiency({ collected, due }) {
  if (due <= 0) return 100;
  return Math.min(100, Math.max(0, (collected / due) * 100));
}

module.exports = {
  totalRepayable,
  installmentAmount,
  advanceDeduction,
  disbursementAmount,
  installmentCount,
  collectionEfficiency,
};
