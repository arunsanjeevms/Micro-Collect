const { Router } = require('express');
const { z } = require('zod');
const asyncHandler = require('../middleware/asyncHandler');
const { requireAuth } = require('../middleware/auth');
const collectionService = require('../services/collectionService');
const paymentService = require('../services/paymentService');

const router = Router();
router.use(requireAuth);

function parseDate(query) {
  return query.date ? new Date(query.date) : new Date();
}

router.get(
  '/',
  asyncHandler(async (req, res) => {
    res.json(await collectionService.fetchForDate(parseDate(req.query)));
  }),
);

router.get(
  '/summary',
  asyncHandler(async (req, res) => {
    res.json(await collectionService.summaryForDate(parseDate(req.query)));
  }),
);

router.get(
  '/payments',
  asyncHandler(async (req, res) => {
    res.json(await paymentService.paymentsForDate(parseDate(req.query)));
  }),
);

const recordPaymentSchema = z.object({
  amount: z.number().positive(),
  mode: z.enum(['cash', 'upi', 'bank']),
  notes: z.string().nullish(),
});

router.post(
  '/:id/payments',
  asyncHandler(async (req, res) => {
    const { amount, mode, notes } = recordPaymentSchema.parse(req.body);
    res.status(201).json(
      await collectionService.recordPayment({
        collectionId: req.params.id,
        amount,
        mode,
        notes,
      }),
    );
  }),
);

module.exports = router;
