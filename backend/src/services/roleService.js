const prisma = require('../config/prisma');
const { nextId } = require('../utils/idGenerator');
const { NotFoundError, ValidationError } = require('../utils/errors');

function serializeRole(role) {
  const groups = {};
  for (const link of role.permissions || []) {
    const group = link.permission.group;
    groups[group] ||= [];
    groups[group].push({
      id: link.permission.id,
      key: link.permission.key,
      label: link.permission.label,
      granted: link.granted,
    });
  }
  return {
    id: role.id,
    name: role.name,
    isSystem: role.isSystem,
    permissionGroups: Object.entries(groups).map(([group, permissions]) => ({
      group,
      permissions,
    })),
  };
}

const withPermissions = {
  permissions: { include: { permission: true }, orderBy: { permissionId: 'asc' } },
};

async function listRoles() {
  const rows = await prisma.role.findMany({ orderBy: { id: 'asc' }, include: withPermissions });
  return rows.map(serializeRole);
}

async function getRole(id) {
  const row = await prisma.role.findUnique({ where: { id }, include: withPermissions });
  if (!row) throw new NotFoundError('Role', id);
  return serializeRole(row);
}

async function listPermissions() {
  return prisma.permission.findMany({ orderBy: { id: 'asc' } });
}

/** New roles start with every permission ungranted - an admin opts in. */
async function createRole(name) {
  return prisma.$transaction(async (tx) => {
    const existing = await tx.role.findUnique({ where: { name } });
    if (existing) throw new ValidationError('A role with this name already exists');

    const id = await nextId(tx.role, 'ROLE');
    await tx.role.create({ data: { id, name, isSystem: false } });

    const permissions = await tx.permission.findMany();
    await tx.rolePermission.createMany({
      data: permissions.map((p) => ({ roleId: id, permissionId: p.id, granted: false })),
    });

    const row = await tx.role.findUnique({ where: { id }, include: withPermissions });
    return serializeRole(row);
  });
}

async function setPermission(roleId, permissionId, granted) {
  const link = await prisma.rolePermission.findUnique({
    where: { roleId_permissionId: { roleId, permissionId } },
  });
  if (!link) throw new NotFoundError('Role permission', `${roleId}/${permissionId}`);

  await prisma.rolePermission.update({
    where: { roleId_permissionId: { roleId, permissionId } },
    data: { granted },
  });
  const row = await prisma.role.findUnique({ where: { id: roleId }, include: withPermissions });
  return serializeRole(row);
}

async function deleteRole(id) {
  const role = await prisma.role.findUnique({ where: { id } });
  if (!role) throw new NotFoundError('Role', id);
  if (role.isSystem) throw new ValidationError('System roles cannot be deleted');

  await prisma.$transaction([
    prisma.rolePermission.deleteMany({ where: { roleId: id } }),
    prisma.role.delete({ where: { id } }),
  ]);
}

module.exports = { listRoles, getRole, listPermissions, createRole, setPermission, deleteRole };
