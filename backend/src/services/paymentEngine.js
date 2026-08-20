const paymentAllocator = require('./paymentAllocator');
const { nextId } = require('../utils/idGenerator');
const { toNumber } = require('../utils/serialize');

/**
 * The core payment mutation shared by collectionService.recordPayment
 * (tied to today's collection entry) and loanService.closeLoan (a
 * lump-sum payoff outside the daily collection cycle). Allocates the
 * amount across the loan's installments oldest-due-first, updates the
 * loan's totals/status, and inserts the Payment + PaymentInstallment
 * rows - everything except the caller's own CollectionEntry update
 * (recordPayment) or closedDate stamping (closeLoan), which differ
 * between the two callers.
 *
 * Must run inside the caller's `tx` transaction.
 */
async function applyPayment(tx, { loan, amount, mode, notes, now }) {
  const installments = await tx.installment.findMany({ where: { loanId: loan.id } });

  const allocation = paymentAllocator.allocate({
    installments: installments.map((i) => ({
      ...i,
      amount: toNumber(i.amount),
      paidAmount: i.paidAmount === null ? null : toNumber(i.paidAmount),
    })),
    amount,
    asOf: now,
  });

  const touched = allocation.updatedInstallments.filter((i) =>
    allocation.touchedInstallmentIds.includes(i.id),
  );
  for (const inst of touched) {
    await tx.installment.update({
      where: { id: inst.id },
      data: { paidAmount: inst.paidAmount, paidDate: inst.paidDate, status: inst.status },
    });
  }

  const newTotalPaid = toNumber(loan.totalPaid) + amount;
  const paidInstallments = allocation.updatedInstallments.filter(
    (i) => i.status === 'paid' || i.status === 'advance',
  ).length;
  const isClosed = newTotalPaid >= toNumber(loan.totalRepayable);
  const stillOverdue = allocation.updatedInstallments.some((i) => i.status === 'overdue');

  const updatedLoan = await tx.loan.update({
    where: { id: loan.id },
    data: {
      totalPaid: newTotalPaid,
      paidInstallments,
      status: isClosed ? 'closed' : stillOverdue ? 'overdue' : 'active',
      closedDate: isClosed ? now : loan.closedDate,
    },
  });

  const paymentId = await nextId(tx.payment, 'P');
  const payment = await tx.payment.create({
    data: {
      id: paymentId,
      receiptNo: `RCP-${paymentId.slice(1)}`,
      borrowerId: loan.borrowerId,
      borrowerName: loan.borrowerName,
      loanId: loan.id,
      amount,
      mode,
      notes: notes || null,
      paidAt: now,
    },
  });
  await tx.paymentInstallment.createMany({
    data: allocation.touchedInstallmentIds.map((installmentId) => ({
      paymentId,
      installmentId,
    })),
  });

  const touchedInstallmentNumbers = allocation.updatedInstallments
    .filter((i) => allocation.touchedInstallmentIds.includes(i.id))
    .map((i) => i.number);

  return {
    updatedLoan,
    payment,
    touchedInstallmentIds: allocation.touchedInstallmentIds,
    touchedInstallmentNumbers,
  };
}

module.exports = { applyPayment };
