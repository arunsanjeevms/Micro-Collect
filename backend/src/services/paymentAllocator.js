/**
 * Payment allocation across a loan's installments. Ported 1:1 from
 * lib/core/utils/payment_allocator.dart: applies an amount oldest-due-first
 * (overdue/pending/partial, ordered by due date). An installment fully
 * covered is marked paid (or advance, if its due date hasn't arrived yet);
 * one only partly covered is marked partial. Callers must validate the
 * amount against outstanding balance before calling this - anything left
 * over past the last installment is simply not applied.
 */

function payableOrder(installments) {
  return installments
    .filter((i) => i.status === 'overdue' || i.status === 'pending' || i.status === 'partial')
    .slice()
    .sort((a, b) => new Date(a.dueDate) - new Date(b.dueDate));
}

/**
 * @param {Array} installments
 * @param {number} amount
 * @param {Date} asOf
 * @returns {{ updatedInstallments: Array, touchedInstallmentIds: string[] }}
 */
function allocate({ installments, amount, asOf }) {
  const ordered = payableOrder(installments);
  const updates = new Map();
  let remaining = amount;

  for (const installment of ordered) {
    if (remaining <= 0) break;

    const alreadyPaid = installment.paidAmount ? Number(installment.paidAmount) : 0;
    const outstanding = Number(installment.amount) - alreadyPaid;
    if (outstanding <= 0) continue;

    if (remaining >= outstanding) {
      const isAdvance = new Date(installment.dueDate) > asOf;
      updates.set(installment.id, {
        ...installment,
        paidAmount: Number(installment.amount),
        paidDate: asOf,
        status: isAdvance ? 'advance' : 'paid',
      });
      remaining -= outstanding;
    } else {
      updates.set(installment.id, {
        ...installment,
        paidAmount: alreadyPaid + remaining,
        paidDate: asOf,
        status: 'partial',
      });
      remaining = 0;
    }
  }

  return {
    updatedInstallments: installments.map((i) => updates.get(i.id) || i),
    touchedInstallmentIds: Array.from(updates.keys()),
  };
}

module.exports = { allocate };
