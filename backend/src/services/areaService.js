const prisma = require('../config/prisma');
const { nextId } = require('../utils/idGenerator');
const { NotFoundError, ValidationError } = require('../utils/errors');
const { toNumber } = require('../utils/serialize');

/**
 * Customers/activeLoans/outstanding are computed from the Borrowers
 * actually assigned to this area (Borrower.areaId) - real numbers, not
 * the fixed demo figures the "More" screens used before Area had a
 * backing model.
 */
function serialize(area) {
  const borrowers = area.borrowers || [];
  return {
    id: area.id,
    code: area.code,
    name: area.name,
    active: area.active,
    customers: borrowers.length,
    activeLoans: borrowers.reduce((sum, b) => sum + b.activeLoans, 0),
    outstanding: borrowers.reduce((sum, b) => sum + toNumber(b.totalOutstanding), 0),
  };
}

const withBorrowers = { borrowers: true };

async function list() {
  const rows = await prisma.area.findMany({ orderBy: { id: 'asc' }, include: withBorrowers });
  return rows.map(serialize);
}

async function get(id) {
  const row = await prisma.area.findUnique({ where: { id }, include: withBorrowers });
  if (!row) throw new NotFoundError('Area', id);
  return serialize(row);
}

async function create(draft) {
  return prisma.$transaction(async (tx) => {
    const existingCode = await tx.area.findUnique({ where: { code: draft.code } });
    if (existingCode) throw new ValidationError('An area with this code already exists');

    const id = await nextId(tx.area, 'AREA');
    await tx.area.create({
      data: { id, code: draft.code, name: draft.name, active: draft.active ?? true },
    });
    const row = await tx.area.findUnique({ where: { id }, include: withBorrowers });
    return serialize(row);
  });
}

async function update(id, patch) {
  const existing = await prisma.area.findUnique({ where: { id } });
  if (!existing) throw new NotFoundError('Area', id);
  await prisma.area.update({ where: { id }, data: patch });
  const row = await prisma.area.findUnique({ where: { id }, include: withBorrowers });
  return serialize(row);
}

async function remove(id) {
  const existing = await prisma.area.findUnique({
    where: { id },
    include: { borrowers: true, employees: true },
  });
  if (!existing) throw new NotFoundError('Area', id);
  if (existing.borrowers.length > 0 || existing.employees.length > 0) {
    throw new ValidationError(
      'This area still has borrowers or employees assigned - reassign them first',
    );
  }
  await prisma.area.delete({ where: { id } });
}

module.exports = { list, get, create, update, remove };
