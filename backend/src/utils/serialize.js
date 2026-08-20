// Converts Prisma's Decimal/Date wrapper types into plain JSON-friendly
// values, since the Flutter client's freezed models expect numbers and
// ISO date strings, not Prisma's driver-specific objects.
function toNumber(value) {
  if (value === null || value === undefined) return value;
  return typeof value === 'object' && typeof value.toNumber === 'function'
    ? value.toNumber()
    : Number(value);
}

function serializeInstallment(i) {
  return {
    id: i.id,
    number: i.number,
    dueDate: i.dueDate,
    amount: toNumber(i.amount),
    paidAmount: i.paidAmount === null ? null : toNumber(i.paidAmount),
    paidDate: i.paidDate,
    status: i.status,
  };
}

function serializeBorrower(b) {
  return {
    id: b.id,
    name: b.name,
    mobile: b.mobile,
    aadhaar: b.aadhaar,
    village: b.village,
    address: b.address,
    pinCode: b.pinCode,
    joinDate: b.joinDate,
    activeLoans: b.activeLoans,
    totalOutstanding: toNumber(b.totalOutstanding),
    status: b.status,
  };
}

function serializeLoan(loan) {
  return {
    id: loan.id,
    borrowerId: loan.borrowerId,
    borrowerName: loan.borrowerName,
    principal: toNumber(loan.principal),
    annualRate: toNumber(loan.annualRate),
    tenureMonths: loan.tenureMonths,
    frequency: loan.frequency,
    totalRepayable: toNumber(loan.totalRepayable),
    totalPaid: toNumber(loan.totalPaid),
    paidInstallments: loan.paidInstallments,
    totalInstallments: loan.totalInstallments,
    disbursementDate: loan.disbursementDate,
    closedDate: loan.closedDate,
    status: loan.status,
    installments: (loan.installments || []).map(serializeInstallment),
  };
}

function serializeCollectionEntry(c) {
  return {
    id: c.id,
    borrowerId: c.borrowerId,
    borrowerName: c.borrowerName,
    loanId: c.loanId,
    previousDue: toNumber(c.previousDue),
    amountDue: toNumber(c.amountDue),
    amountPaid: c.amountPaid === null ? null : toNumber(c.amountPaid),
    dueDate: c.dueDate,
    paidDate: c.paidDate,
    paymentMode: c.paymentMode,
    notes: c.notes,
    status: c.status,
  };
}

function serializePayment(p) {
  return {
    id: p.id,
    receiptNo: p.receiptNo,
    borrowerId: p.borrowerId,
    borrowerName: p.borrowerName,
    loanId: p.loanId,
    installmentIds: (p.installmentLinks || []).map((l) => l.installmentId),
    amount: toNumber(p.amount),
    mode: p.mode,
    notes: p.notes,
    paidAt: p.paidAt,
  };
}

module.exports = {
  toNumber,
  serializeBorrower,
  serializeLoan,
  serializeInstallment,
  serializeCollectionEntry,
  serializePayment,
};
