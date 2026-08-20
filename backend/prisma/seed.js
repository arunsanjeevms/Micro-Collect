require('dotenv').config();
const bcrypt = require('bcryptjs');
const { PrismaClient } = require('@prisma/client');
const loanCalculator = require('../src/services/loanCalculator');
const scheduleBuilder = require('../src/services/scheduleBuilder');
const { recomputeBorrower } = require('../src/services/borrowerService');

const prisma = new PrismaClient();

const borrowers = [
  { id: 'B001', name: 'Rajesh Kumar', mobile: '9876543210', aadhaar: '234567891234', village: 'Kothapalli', address: 'H.No 3-45, Main Road', pinCode: '507001', joinDate: new Date(2024, 2, 15) },
  { id: 'B002', name: 'Lakshmi Devi', mobile: '9988776655', aadhaar: '456789012345', village: 'Rampur', address: 'Ward 4, Near Temple', pinCode: '507002', joinDate: new Date(2024, 0, 10) },
  { id: 'B003', name: 'Suresh Reddy', mobile: '8877665544', aadhaar: '567890123456', village: 'Chintalapudi', address: 'Opp. School, Bus Stand Road', pinCode: '507003', joinDate: new Date(2024, 5, 20) },
  { id: 'B004', name: 'Padma Kumari', mobile: '7766554433', aadhaar: '678901234567', village: 'Kothapalli', address: 'H.No 7-12, Cross Road', pinCode: '507001', joinDate: new Date(2023, 10, 5) },
  { id: 'B005', name: 'Venkat Rao', mobile: '9654321098', aadhaar: '789012345678', village: 'Rampur', address: 'Ward 2, Market Area', pinCode: '507002', joinDate: new Date(2024, 7, 1) },
  { id: 'B006', name: 'Sarita Bai', mobile: '9543210987', aadhaar: '890123456789', village: 'Chintalapudi', address: 'H.No 11-3, Lake Road', pinCode: '507003', joinDate: new Date(2024, 3, 12) },
  { id: 'B007', name: 'Mahesh Goud', mobile: '9432109876', aadhaar: '901234567890', village: 'Kothapalli', address: 'Near Water Tank, Main Rd', pinCode: '507001', joinDate: new Date(2024, 1, 28) },
  { id: 'B008', name: 'Anitha Sharma', mobile: '9321098765', aadhaar: '012345678901', village: 'Rampur', address: 'Ward 6, Post Office Lane', pinCode: '507002', joinDate: new Date(2024, 4, 18) },
];

// Rajesh's loan (L001) is kept hand-authored, same as demo_seed.dart, to
// demonstrate a partial installment alongside paid and pending ones.
const rajeshInstallments = [
  { number: 1, dueDate: new Date(2024, 3, 15), amount: 2200, paidAmount: 2200, paidDate: new Date(2024, 3, 15), status: 'paid' },
  { number: 2, dueDate: new Date(2024, 4, 15), amount: 2200, paidAmount: 2200, paidDate: new Date(2024, 4, 14), status: 'paid' },
  { number: 3, dueDate: new Date(2024, 5, 15), amount: 2200, paidAmount: 2200, paidDate: new Date(2024, 5, 15), status: 'paid' },
  { number: 4, dueDate: new Date(2024, 6, 15), amount: 2200, paidAmount: 2200, paidDate: new Date(2024, 6, 16), status: 'paid' },
  { number: 5, dueDate: new Date(2024, 7, 15), amount: 2200, paidAmount: 2200, paidDate: new Date(2024, 7, 15), status: 'paid' },
  { number: 6, dueDate: new Date(2024, 8, 15), amount: 2200, paidAmount: 2200, paidDate: new Date(2024, 8, 14), status: 'paid' },
  { number: 7, dueDate: new Date(2024, 9, 15), amount: 2200, paidAmount: 1000, paidDate: new Date(2024, 9, 18), status: 'partial' },
  { number: 8, dueDate: new Date(2024, 10, 15), amount: 2200, status: 'pending' },
  { number: 9, dueDate: new Date(2024, 11, 15), amount: 2200, status: 'pending' },
  { number: 10, dueDate: new Date(2025, 0, 15), amount: 2200, status: 'pending' },
];

const loanSpecs = [
  { id: 'L002', borrowerId: 'B002', borrowerName: 'Lakshmi Devi', principal: 15000, annualRate: 22, tenureMonths: 6, frequency: 'weekly', disbursementDate: new Date(2024, 4, 1), paidInstallments: 12, status: 'overdue' },
  { id: 'L003', borrowerId: 'B002', borrowerName: 'Lakshmi Devi', principal: 25000, annualRate: 20, tenureMonths: 12, frequency: 'monthly', disbursementDate: new Date(2024, 6, 10), paidInstallments: 3, status: 'active' },
  { id: 'L004', borrowerId: 'B003', borrowerName: 'Suresh Reddy', principal: 10000, annualRate: 24, tenureMonths: 6, frequency: 'daily', disbursementDate: new Date(2024, 5, 20), paidInstallments: 90, status: 'active' },
  { id: 'L005', borrowerId: 'B004', borrowerName: 'Padma Kumari', principal: 8000, annualRate: 20, tenureMonths: 6, frequency: 'monthly', disbursementDate: new Date(2023, 10, 5), paidInstallments: 6, status: 'closed', closedDate: new Date(2024, 4, 5) },
  { id: 'L006', borrowerId: 'B005', borrowerName: 'Venkat Rao', principal: 30000, annualRate: 22, tenureMonths: 12, frequency: 'monthly', disbursementDate: new Date(2024, 7, 1), paidInstallments: 2, status: 'active' },
  { id: 'L007', borrowerId: 'B006', borrowerName: 'Sarita Bai', principal: 10000, annualRate: 22, tenureMonths: 6, frequency: 'monthly', disbursementDate: new Date(2024, 3, 12), paidInstallments: 1, status: 'overdue' },
  { id: 'L008', borrowerId: 'B007', borrowerName: 'Mahesh Goud', principal: 18000, annualRate: 24, tenureMonths: 12, frequency: 'monthly', disbursementDate: new Date(2024, 2, 1), paidInstallments: 4, status: 'active' },
  { id: 'L009', borrowerId: 'B008', borrowerName: 'Anitha Sharma', principal: 22000, annualRate: 20, tenureMonths: 12, frequency: 'monthly', disbursementDate: new Date(2024, 4, 20), paidInstallments: 3, status: 'active' },
];

function buildGeneratedLoan(spec) {
  const totalInstallments = loanCalculator.installmentCount({
    tenureMonths: spec.tenureMonths,
    frequency: spec.frequency,
  });
  const totalRepayable = loanCalculator.totalRepayable({
    principal: spec.principal,
    annualRate: spec.annualRate,
    tenureMonths: spec.tenureMonths,
  });
  const installmentAmount = loanCalculator.installmentAmount({
    totalRepayable,
    numberOfInstallments: totalInstallments,
  });

  const schedule = scheduleBuilder.build({
    loanId: spec.id,
    disbursementDate: spec.disbursementDate,
    totalInstallments,
    installmentAmount,
    frequency: spec.frequency,
  });

  const installments = schedule.map((inst, i) => {
    if (i < spec.paidInstallments) {
      return { ...inst, paidAmount: inst.amount, paidDate: inst.dueDate, status: 'paid' };
    }
    if (spec.status === 'overdue' && i === spec.paidInstallments) {
      return { ...inst, status: 'overdue' };
    }
    return inst;
  });

  return {
    loan: {
      id: spec.id,
      borrowerId: spec.borrowerId,
      borrowerName: spec.borrowerName,
      principal: spec.principal,
      annualRate: spec.annualRate,
      tenureMonths: spec.tenureMonths,
      frequency: spec.frequency,
      totalRepayable,
      totalPaid: installmentAmount * spec.paidInstallments,
      paidInstallments: spec.paidInstallments,
      totalInstallments,
      disbursementDate: spec.disbursementDate,
      closedDate: spec.closedDate || null,
      status: spec.status,
    },
    installments,
  };
}

function todayCollections(now) {
  return [
    { id: 'C001', borrowerId: 'B001', borrowerName: 'Rajesh Kumar', loanId: 'L001', amountDue: 2200, amountPaid: 2200, dueDate: now, paidDate: now, paymentMode: 'cash', status: 'collected' },
    { id: 'C002', borrowerId: 'B003', borrowerName: 'Suresh Reddy', loanId: 'L004', amountDue: 62, amountPaid: 62, dueDate: now, paidDate: now, paymentMode: 'upi', status: 'collected' },
    { id: 'C003', borrowerId: 'B005', borrowerName: 'Venkat Rao', loanId: 'L006', amountDue: 3050, dueDate: now, status: 'pending' },
    { id: 'C004', borrowerId: 'B002', borrowerName: 'Lakshmi Devi', loanId: 'L002', previousDue: 640, amountDue: 640, dueDate: now, status: 'overdue' },
    { id: 'C005', borrowerId: 'B006', borrowerName: 'Sarita Bai', loanId: 'L007', previousDue: 350, amountDue: 850, amountPaid: 500, dueDate: now, paidDate: now, paymentMode: 'cash', notes: 'Will pay remaining tomorrow', status: 'partial' },
    { id: 'C006', borrowerId: 'B007', borrowerName: 'Mahesh Goud', loanId: 'L008', amountDue: 1520, dueDate: now, status: 'pending' },
    { id: 'C007', borrowerId: 'B008', borrowerName: 'Anitha Sharma', loanId: 'L009', amountDue: 2000, amountPaid: 2000, dueDate: now, paidDate: now, paymentMode: 'bank', status: 'collected' },
  ];
}

async function main() {
  console.log('Seeding MicroCollect database...'); // eslint-disable-line no-console

  await prisma.paymentInstallment.deleteMany();
  await prisma.payment.deleteMany();
  await prisma.collectionEntry.deleteMany();
  await prisma.installment.deleteMany();
  await prisma.loan.deleteMany();
  await prisma.borrower.deleteMany();
  await prisma.user.deleteMany();

  await prisma.user.create({
    data: {
      email: 'admin@microcollect.app',
      passwordHash: await bcrypt.hash('admin123', 10),
      name: 'Admin User',
      role: 'ADMIN',
    },
  });
  await prisma.user.create({
    data: {
      email: 'officer@microcollect.app',
      passwordHash: await bcrypt.hash('officer123', 10),
      name: 'Arun (Field Officer)',
      role: 'FIELD_OFFICER',
    },
  });

  for (const b of borrowers) {
    await prisma.borrower.create({
      data: { ...b, activeLoans: 0, totalOutstanding: 0, status: 'active' },
    });
  }

  await prisma.loan.create({
    data: {
      id: 'L001',
      borrowerId: 'B001',
      borrowerName: 'Rajesh Kumar',
      principal: 20000,
      annualRate: 24,
      tenureMonths: 10,
      frequency: 'monthly',
      totalRepayable: 24000,
      totalPaid: 14200,
      paidInstallments: 6,
      totalInstallments: 10,
      disbursementDate: new Date(2024, 2, 15),
      status: 'active',
    },
  });
  await prisma.installment.createMany({
    data: rajeshInstallments.map((i) => ({
      id: `L001-I${String(i.number).padStart(3, '0')}`,
      loanId: 'L001',
      ...i,
    })),
  });

  for (const spec of loanSpecs) {
    const { loan, installments } = buildGeneratedLoan(spec);
    await prisma.loan.create({ data: loan });
    await prisma.installment.createMany({ data: installments });
  }

  const now = new Date();
  await prisma.collectionEntry.createMany({ data: todayCollections(now) });

  for (const b of borrowers) {
    await recomputeBorrower(prisma, b.id);
  }

  console.log('Seed complete.'); // eslint-disable-line no-console
}

main()
  .catch((err) => {
    console.error(err); // eslint-disable-line no-console
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
