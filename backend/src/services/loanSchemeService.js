const prisma = require('../config/prisma');
const { nextId } = require('../utils/idGenerator');
const { NotFoundError, ValidationError } = require('../utils/errors');
const { toNumber } = require('../utils/serialize');

function serialize(s) {
  return {
    id: s.id,
    code: s.code,
    name: s.name,
    active: s.active,
    principalMin: toNumber(s.principalMin),
    principalMax: toNumber(s.principalMax),
    tenureMin: s.tenureMin,
    tenureMax: s.tenureMax,
    tenureUnit: s.tenureUnit,
    frequency: s.frequency,
  };
}

async function list() {
  const rows = await prisma.loanScheme.findMany({ orderBy: { id: 'asc' } });
  return rows.map(serialize);
}

async function get(id) {
  const row = await prisma.loanScheme.findUnique({ where: { id } });
  if (!row) throw new NotFoundError('Loan scheme', id);
  return serialize(row);
}

async function create(draft) {
  if (draft.principalMin > draft.principalMax) {
    throw new ValidationError('principalMin must not exceed principalMax');
  }
  if (draft.tenureMin > draft.tenureMax) {
    throw new ValidationError('tenureMin must not exceed tenureMax');
  }
  return prisma.$transaction(async (tx) => {
    const id = await nextId(tx.loanScheme, 'SCH');
    const row = await tx.loanScheme.create({ data: { id, ...draft } });
    return serialize(row);
  });
}

async function update(id, patch) {
  const existing = await prisma.loanScheme.findUnique({ where: { id } });
  if (!existing) throw new NotFoundError('Loan scheme', id);
  const row = await prisma.loanScheme.update({ where: { id }, data: patch });
  return serialize(row);
}

async function remove(id) {
  const existing = await prisma.loanScheme.findUnique({ where: { id } });
  if (!existing) throw new NotFoundError('Loan scheme', id);
  await prisma.loanScheme.delete({ where: { id } });
}

module.exports = { list, get, create, update, remove };
