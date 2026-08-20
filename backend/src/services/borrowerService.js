const prisma = require('../config/prisma');
const { nextId } = require('../utils/idGenerator');
const { NotFoundError } = require('../utils/errors');
const { serializeBorrower } = require('../utils/serialize');

/**
 * Recomputes Borrower.activeLoans/totalOutstanding/status from that
 * borrower's loans - the sole writer of those three fields, mirroring
 * MockDatabase._recomputeBorrower. Every write that can change a loan's
 * outstanding balance or status must call this inside the same
 * transaction instead of trusting a caller-supplied value.
 */
async function recomputeBorrower(tx, borrowerId) {
  const loans = await tx.loan.findMany({ where: { borrowerId } });
  const active = loans.filter((l) => l.status !== 'closed');
  const hasOverdue = active.some((l) => l.status === 'overdue');

  const totalOutstanding = active.reduce(
    (sum, l) => sum + (Number(l.totalRepayable) - Number(l.totalPaid)),
    0,
  );

  await tx.borrower.update({
    where: { id: borrowerId },
    data: {
      activeLoans: active.length,
      totalOutstanding,
      status: active.length === 0 ? 'closed' : hasOverdue ? 'overdue' : 'active',
    },
  });
}

async function listBorrowers() {
  const rows = await prisma.borrower.findMany({ orderBy: { id: 'asc' } });
  return rows.map(serializeBorrower);
}

async function getBorrower(id) {
  const row = await prisma.borrower.findUnique({ where: { id } });
  if (!row) throw new NotFoundError('Borrower', id);
  return serializeBorrower(row);
}

async function createBorrower(draft) {
  return prisma.$transaction(async (tx) => {
    const id = await nextId(tx.borrower, 'B');
    const row = await tx.borrower.create({
      data: {
        id,
        name: draft.name,
        mobile: draft.mobile,
        aadhaar: draft.aadhaar,
        village: draft.village,
        address: draft.address,
        pinCode: draft.pinCode,
        joinDate: new Date(),
        activeLoans: 0,
        totalOutstanding: 0,
        status: 'active',
      },
    });
    return serializeBorrower(row);
  });
}

module.exports = { listBorrowers, getBorrower, createBorrower, recomputeBorrower };
