const { PrismaClient } = require('@prisma/client');

// Single shared Prisma client for the process, matching the "one central
// store" reasoning behind MockDatabase on the Flutter side: every write
// that touches more than one table goes through a Prisma $transaction so
// related rows (loan + installments + borrower + payment) never disagree.
const prisma = new PrismaClient();

module.exports = prisma;
