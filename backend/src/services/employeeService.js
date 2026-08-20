const prisma = require('../config/prisma');
const { nextId } = require('../utils/idGenerator');
const { NotFoundError } = require('../utils/errors');

function serialize(e) {
  return {
    id: e.id,
    name: e.name,
    mobile: e.mobile,
    areaId: e.areaId,
    areaName: e.area ? e.area.name : null,
    status: e.status,
    joinDate: e.joinDate,
  };
}

const withArea = { area: true };

async function list() {
  const rows = await prisma.employee.findMany({ orderBy: { id: 'asc' }, include: withArea });
  return rows.map(serialize);
}

async function get(id) {
  const row = await prisma.employee.findUnique({ where: { id }, include: withArea });
  if (!row) throw new NotFoundError('Employee', id);
  return serialize(row);
}

async function create(draft) {
  return prisma.$transaction(async (tx) => {
    const id = await nextId(tx.employee, 'EMP');
    await tx.employee.create({
      data: {
        id,
        name: draft.name,
        mobile: draft.mobile,
        areaId: draft.areaId || null,
        status: draft.status || 'active',
      },
    });
    const row = await tx.employee.findUnique({ where: { id }, include: withArea });
    return serialize(row);
  });
}

async function update(id, patch) {
  const existing = await prisma.employee.findUnique({ where: { id } });
  if (!existing) throw new NotFoundError('Employee', id);
  await prisma.employee.update({ where: { id }, data: patch });
  const row = await prisma.employee.findUnique({ where: { id }, include: withArea });
  return serialize(row);
}

async function remove(id) {
  const existing = await prisma.employee.findUnique({ where: { id } });
  if (!existing) throw new NotFoundError('Employee', id);
  await prisma.employee.delete({ where: { id } });
}

module.exports = { list, get, create, update, remove };
