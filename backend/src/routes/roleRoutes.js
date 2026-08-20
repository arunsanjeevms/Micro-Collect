const { Router } = require('express');
const { z } = require('zod');
const asyncHandler = require('../middleware/asyncHandler');
const { requireAuth, requireRole } = require('../middleware/auth');
const roleService = require('../services/roleService');

const router = Router();
router.use(requireAuth);

router.get(
  '/',
  asyncHandler(async (req, res) => res.json(await roleService.listRoles())),
);

router.get(
  '/permissions',
  asyncHandler(async (req, res) => res.json(await roleService.listPermissions())),
);

router.get(
  '/:id',
  asyncHandler(async (req, res) => res.json(await roleService.getRole(req.params.id))),
);

router.post(
  '/',
  requireRole('ADMIN'),
  asyncHandler(async (req, res) => {
    const { name } = z.object({ name: z.string().min(1) }).parse(req.body);
    res.status(201).json(await roleService.createRole(name));
  }),
);

router.patch(
  '/:id/permissions/:permissionId',
  requireRole('ADMIN'),
  asyncHandler(async (req, res) => {
    const { granted } = z.object({ granted: z.boolean() }).parse(req.body);
    res.json(await roleService.setPermission(req.params.id, req.params.permissionId, granted));
  }),
);

router.delete(
  '/:id',
  requireRole('ADMIN'),
  asyncHandler(async (req, res) => {
    await roleService.deleteRole(req.params.id);
    res.status(204).send();
  }),
);

module.exports = router;
