const prisma = require('../config/prisma');
const { nextId } = require('../utils/idGenerator');
const { NotFoundError, ValidationError } = require('../utils/errors');
const { serializeLoan, serializePayment, toNumber } = require('../utils/serialize');
const loanCalculator = require('./loanCalculator');
const scheduleBuilder = require('./scheduleBuilder');
const { recomputeBorrower } = require('./borrowerService');
const { applyPayment } = require('./paymentEngine');

const installmentsOrder = { installments: { orderBy: { number: 'asc' } } };

async function listLoans() {
  const rows = await prisma.loan.findMany({ orderBy: { id: 'asc' }, include: installmentsOrder });
  return rows.map(serializeLoan);
}

async function getLoan(id) {
  const row = await prisma.loan.findUnique({ where: { id }, include: installmentsOrder });
  if (!row) throw new NotFoundError('Loan', id);
  return serializeLoan(row);
}

async function loansForBorrower(borrowerId) {
  const rows = await prisma.loan.findMany({
    where: { borrowerId },
    orderBy: { id: 'asc' },
    include: installmentsOrder,
  });
  return rows.map(serializeLoan);
}

/**
 * Creates a new loan: totals, installment count and schedule are all
 * derived from loanCalculator/scheduleBuilder, then the borrower's
 * aggregates are recomputed - ported 1:1 from MockDatabase.insertLoan.
 */
async function createLoan(draft) {
  return prisma.$transaction(async (tx) => {
    const borrower = await tx.borrower.findUnique({ where: { id: draft.borrowerId } });
    if (!borrower) throw new NotFoundError('Borrower', draft.borrowerId);

    const id = await nextId(tx.loan, 'L');
    const totalInstallments = loanCalculator.installmentCount({
      tenureMonths: draft.tenureMonths,
      frequency: draft.frequency,
    });
    const totalRepayable = loanCalculator.totalRepayable({
      principal: draft.principal,
      annualRate: draft.annualRate,
      tenureMonths: draft.tenureMonths,
    });
    const instAmount = loanCalculator.installmentAmount({
      totalRepayable,
      numberOfInstallments: totalInstallments,
    });
    const disbursementDate = new Date();

    await tx.loan.create({
      data: {
        id,
        borrowerId: draft.borrowerId,
        borrowerName: borrower.name,
        principal: draft.principal,
        annualRate: draft.annualRate,
        tenureMonths: draft.tenureMonths,
        frequency: draft.frequency,
        totalRepayable,
        totalPaid: 0,
        paidInstallments: 0,
        totalInstallments,
        disbursementDate,
        status: 'disbursed',
      },
    });

    const schedule = scheduleBuilder.build({
      loanId: id,
      disbursementDate,
      totalInstallments,
      installmentAmount: instAmount,
      frequency: draft.frequency,
    });
    await tx.installment.createMany({ data: schedule });

    await recomputeBorrower(tx, draft.borrowerId);

    const loan = await tx.loan.findUnique({ where: { id }, include: installmentsOrder });
    return serializeLoan(loan);
  });
}

/**
 * Settles a loan's full remaining outstanding in one payment and marks it
 * closed - for a lump-sum payoff outside the normal daily collection
 * cycle. Ported 1:1 from MockDatabase.closeLoan.
 */
async function closeLoan(loanId, { mode, notes }) {
  return prisma.$transaction(async (tx) => {
    const loan = await tx.loan.findUnique({ where: { id: loanId } });
    if (!loan) throw new NotFoundError('Loan', loanId);
    if (loan.status === 'closed') throw new ValidationError('This loan is already closed');

    const now = new Date();
    const amount = toNumber(loan.totalRepayable) - toNumber(loan.totalPaid);

    const { updatedLoan, payment, touchedInstallmentIds, touchedInstallmentNumbers } =
      await applyPayment(tx, { loan, amount, mode, notes, now });

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

module.exports = { listLoans, getLoan, loansForBorrower, createLoan, closeLoan };
