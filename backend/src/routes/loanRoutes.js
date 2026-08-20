const { Router } = require('express');
const { z } = require('zod');
const asyncHandler = require('../middleware/asyncHandler');
const { requireAuth } = require('../middleware/auth');
const loanService = require('../services/loanService');
const paymentService = require('../services/paymentService');

const router = Router();
router.use(requireAuth);

router.get(
  '/',
  asyncHandler(async (req, res) => {
    res.json(await loanService.listLoans());
  }),
);

router.get(
  '/:id',
  asyncHandler(async (req, res) => {
    res.json(await loanService.getLoan(req.params.id));
  }),
);

router.get(
  '/:id/payments',
  asyncHandler(async (req, res) => {
    res.json(await paymentService.paymentsForLoan(req.params.id));
  }),
);

const loanDraftSchema = z.object({
  borrowerId: z.string().min(1),
  principal: z.number().positive(),
  annualRate: z.number().positive(),
  tenureMonths: z.number().int().positive(),
  frequency: z.enum(['daily', 'weekly', 'monthly']),
});

router.post(
  '/',
  asyncHandler(async (req, res) => {
    const draft = loanDraftSchema.parse(req.body);
    res.status(201).json(await loanService.createLoan(draft));
  }),
);

const closeLoanSchema = z.object({
  mode: z.enum(['cash', 'upi', 'bank']),
  notes: z.string().optional(),
});

router.post(
  '/:id/close',
  asyncHandler(async (req, res) => {
    const { mode, notes } = closeLoanSchema.parse(req.body);
    res.json(await loanService.closeLoan(req.params.id, { mode, notes }));
  }),
);

module.exports = router;
