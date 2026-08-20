const prisma = require('../config/prisma');
const { NotFoundError, ValidationError } = require('../utils/errors');
const { serializeCollectionEntry, serializePayment, toNumber } = require('../utils/serialize');
const { recomputeBorrower } = require('./borrowerService');
const { applyPayment } = require('./paymentEngine');

function dayRange(date) {
  const start = new Date(date);
  start.setHours(0, 0, 0, 0);
  const end = new Date(start);
  end.setDate(end.getDate() + 1);
  return { gte: start, lt: end };
}

async function fetchForDate(date) {
  const rows = await prisma.collectionEntry.findMany({
    where: { dueDate: dayRange(date) },
    orderBy: { id: 'asc' },
  });
  return rows.map(serializeCollectionEntry);
}

async function summaryForDate(date) {
  const rows = await prisma.collectionEntry.findMany({ where: { dueDate: dayRange(date) } });

  let totalDue = 0;
  let totalCollected = 0;
  let collectedCount = 0;
  let pendingCount = 0;
  let overdueCount = 0;
  let partialCount = 0;

  for (const row of rows) {
    const due = toNumber(row.previousDue) + toNumber(row.amountDue);
    totalDue += due;
    totalCollected += row.amountPaid ? toNumber(row.amountPaid) : 0;
    if (row.status === 'collected') collectedCount++;
    else if (row.status === 'pending') pendingCount++;
    else if (row.status === 'overdue') overdueCount++;
    else if (row.status === 'partial') partialCount++;
  }

  return {
    totalDue,
    totalCollected,
    collectedCount,
    pendingCount,
    overdueCount,
    partialCount,
    efficiency: totalDue > 0 ? (totalCollected / totalDue) * 100 : 100,
  };
}

/**
 * Records a payment against today's collection entry - the one
 * transaction the rest of this architecture exists for. Ported 1:1 from
 * MockDatabase.recordPayment: a single payment touches the loan's
 * installments, its totals/status, the borrower's derived
 * outstanding/status, the collection entry, and the payment log.
 */
async function recordPayment({ collectionId, amount, mode, notes }) {
  if (amount <= 0) throw new ValidationError('Amount must be greater than zero');

  return prisma.$transaction(async (tx) => {
    const entry = await tx.collectionEntry.findUnique({ where: { id: collectionId } });
    if (!entry) throw new NotFoundError('Collection entry', collectionId);
    const loan = await tx.loan.findUnique({ where: { id: entry.loanId } });
    if (!loan) throw new NotFoundError('Loan', entry.loanId);

    const now = new Date();
    const { updatedLoan, payment, touchedInstallmentIds, touchedInstallmentNumbers } =
      await applyPayment(tx, { loan, amount, mode, notes, now });

    const paidTowardsEntry = (entry.amountPaid ? toNumber(entry.amountPaid) : 0) + amount;
    const totalDue = toNumber(entry.previousDue) + toNumber(entry.amountDue);
    await tx.collectionEntry.update({
      where: { id: entry.id },
      data: {
        amountPaid: paidTowardsEntry,
        paidDate: now,
        paymentMode: mode,
        notes: notes || entry.notes,
        status: paidTowardsEntry >= totalDue ? 'collected' : 'partial',
      },
    });

    await recomputeBorrower(tx, loan.borrowerId);
    const borrower = await tx.borrower.findUnique({ where: { id: loan.borrowerId } });

    return {
      payment: serializePayment({
        ...payment,
        installmentLinks: touchedInstallmentIds.map((installmentId) => ({ installmentId })),
      }),
      touchedInstallmentNumbers,
      newLoanOutstanding: toNumber(updatedLoan.totalRepayable) - toNumber(updatedLoan.totalPaid),
      newBorrowerOutstanding: toNumber(borrower.totalOutstanding),
    };
  });
}

module.exports = { fetchForDate, summaryForDate, recordPayment };
