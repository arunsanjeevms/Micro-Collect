const prisma = require('../config/prisma');
const { serializePayment } = require('../utils/serialize');

const withLinks = { installmentLinks: true };

/**
 * paidAt alone isn't a safe sort key: two payments recorded moments apart
 * can land in the same instant, and payment ids are assigned sequentially,
 * so they break the tie in actual recording order. Matches
 * MockDatabase._newestFirst.
 */
const newestFirst = [{ paidAt: 'desc' }, { id: 'desc' }];

async function paymentsForLoan(loanId) {
  const rows = await prisma.payment.findMany({
    where: { loanId },
    orderBy: newestFirst,
    include: withLinks,
  });
  return rows.map(serializePayment);
}

async function paymentsForBorrower(borrowerId, { limit = 10 } = {}) {
  const rows = await prisma.payment.findMany({
    where: { borrowerId },
    orderBy: newestFirst,
    include: withLinks,
    take: limit,
  });
  return rows.map(serializePayment);
}

function dayRange(date) {
  const start = new Date(date);
  start.setHours(0, 0, 0, 0);
  const end = new Date(start);
  end.setDate(end.getDate() + 1);
  return { gte: start, lt: end };
}

async function paymentsForDate(date) {
  const rows = await prisma.payment.findMany({
    where: { paidAt: dayRange(date) },
    orderBy: newestFirst,
    include: withLinks,
  });
  return rows.map(serializePayment);
}

module.exports = { paymentsForLoan, paymentsForBorrower, paymentsForDate };
