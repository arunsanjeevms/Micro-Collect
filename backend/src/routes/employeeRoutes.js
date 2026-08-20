const { Router } = require('express');
const { z } = require('zod');
const asyncHandler = require('../middleware/asyncHandler');
const { requireAuth, requireRole } = require('../middleware/auth');
const employeeService = require('../services/employeeService');

const router = Router();
router.use(requireAuth);

router.get(
  '/',
  asyncHandler(async (req, res) => res.json(await employeeService.list())),
);

router.get(
  '/:id',
  asyncHandler(async (req, res) => res.json(await employeeService.get(req.params.id))),
);

const statusEnum = z.enum(['active', 'onField', 'office']);

const draftSchema = z.object({
  name: z.string().min(2),
  mobile: z.string().regex(/^[6-9]\d{9}$/, 'Enter a valid 10-digit mobile number'),
  areaId: z.string().nullish(),
  status: statusEnum.optional(),
});

router.post(
  '/',
  requireRole('ADMIN', 'MANAGER'),
  asyncHandler(async (req, res) => {
    const draft = draftSchema.parse(req.body);
    res.status(201).json(await employeeService.create(draft));
  }),
);

const patchSchema = z.object({
  name: z.string().min(2).optional(),
  mobile: z.string().regex(/^[6-9]\d{9}$/).optional(),
  areaId: z.string().nullish(),
  status: statusEnum.optional(),
});

router.patch(
  '/:id',
  requireRole('ADMIN', 'MANAGER'),
  asyncHandler(async (req, res) => {
    const patch = patchSchema.parse(req.body);
    res.json(await employeeService.update(req.params.id, patch));
  }),
);

router.delete(
  '/:id',
  requireRole('ADMIN', 'MANAGER'),
  asyncHandler(async (req, res) => {
    await employeeService.remove(req.params.id);
    res.status(204).send();
  }),
);

module.exports = router;
