const { Router } = require('express');
const { z } = require('zod');
const asyncHandler = require('../middleware/asyncHandler');
const { requireAuth, requireRole } = require('../middleware/auth');
const loanSchemeService = require('../services/loanSchemeService');

const router = Router();
router.use(requireAuth);

router.get(
  '/',
  asyncHandler(async (req, res) => res.json(await loanSchemeService.list())),
);

router.get(
  '/:id',
  asyncHandler(async (req, res) => res.json(await loanSchemeService.get(req.params.id))),
);

const draftSchema = z.object({
  code: z.string().min(1).max(16),
  name: z.string().min(1),
  active: z.boolean().optional(),
  principalMin: z.number().nonnegative(),
  principalMax: z.number().positive(),
  tenureMin: z.number().int().positive(),
  tenureMax: z.number().int().positive(),
  tenureUnit: z.enum(['Days', 'Weeks', 'Months']),
  frequency: z.enum(['daily', 'weekly', 'monthly']),
});

router.post(
  '/',
  requireRole('ADMIN', 'MANAGER'),
  asyncHandler(async (req, res) => {
    const draft = draftSchema.parse(req.body);
    res.status(201).json(await loanSchemeService.create(draft));
  }),
);

const patchSchema = draftSchema.partial();

router.patch(
  '/:id',
  requireRole('ADMIN', 'MANAGER'),
  asyncHandler(async (req, res) => {
    const patch = patchSchema.parse(req.body);
    res.json(await loanSchemeService.update(req.params.id, patch));
  }),
);

router.delete(
  '/:id',
  requireRole('ADMIN', 'MANAGER'),
  asyncHandler(async (req, res) => {
    await loanSchemeService.remove(req.params.id);
    res.status(204).send();
  }),
);

module.exports = router;
