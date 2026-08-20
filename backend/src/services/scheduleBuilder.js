/**
 * Installment schedule generation. Ported 1:1 from
 * lib/core/utils/schedule_builder.dart.
 */

function pad3(n) {
  return String(n).padStart(3, '0');
}

function dueDate(start, frequency, number) {
  const d = new Date(start);
  switch ((frequency || '').toLowerCase()) {
    case 'daily':
      d.setDate(d.getDate() + number);
      return d;
    case 'weekly':
      d.setDate(d.getDate() + 7 * number);
      return d;
    case 'monthly':
    default:
      return new Date(d.getFullYear(), d.getMonth() + number, d.getDate());
  }
}

/**
 * Builds a fully-pending installment schedule for a new loan.
 * @returns {Array<{id: string, loanId: string, number: number, dueDate: Date, amount: number, status: 'pending'}>}
 */
function build({ loanId, disbursementDate, totalInstallments, installmentAmount, frequency }) {
  const installments = [];
  for (let i = 0; i < totalInstallments; i++) {
    const number = i + 1;
    installments.push({
      id: `${loanId}-I${pad3(number)}`,
      loanId,
      number,
      dueDate: dueDate(disbursementDate, frequency, number),
      amount: installmentAmount,
      status: 'pending',
    });
  }
  return installments;
}

module.exports = { build };
