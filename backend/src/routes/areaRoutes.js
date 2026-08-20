const { Router } = require('express');
const { z } = require('zod');
const asyncHandler = require('../middleware/asyncHandler');
const { requireAuth, requireRole } = require('../middleware/auth');
const areaService = require('../services/areaService');

const router = Router();
router.use(requireAuth);

router.get(
  '/',
  asyncHandler(async (req, res) => res.json(await areaService.list())),
);

router.get(
  '/:id',
  asyncHandler(async (req, res) => res.json(await areaService.get(req.params.id))),
);

const draftSchema = z.object({
  code: z.string().min(1).max(16),
  name: z.string().min(1),
  active: z.boolean().optional(),
});

router.post(
  '/',
  requireRole('ADMIN', 'MANAGER'),
  asyncHandler(async (req, res) => {
    const draft = draftSchema.parse(req.body);
    res.status(201).json(await areaService.create(draft));
  }),
);

const patchSchema = z.object({
  code: z.string().min(1).max(16).optional(),
  name: z.string().min(1).optional(),
  active: z.boolean().optional(),
});

router.patch(
  '/:id',
  requireRole('ADMIN', 'MANAGER'),
  asyncHandler(async (req, res) => {
    const patch = patchSchema.parse(req.body);
    res.json(await areaService.update(req.params.id, patch));
  }),
);

router.delete(
  '/:id',
  requireRole('ADMIN', 'MANAGER'),
  asyncHandler(async (req, res) => {
    await areaService.remove(req.params.id);
    res.status(204).send();
  }),
);

module.exports = router;
