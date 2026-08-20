const { Router } = require('express');
const { z } = require('zod');
const asyncHandler = require('../middleware/asyncHandler');
const { requireAuth } = require('../middleware/auth');
const borrowerService = require('../services/borrowerService');
const loanService = require('../services/loanService');
const paymentService = require('../services/paymentService');

const router = Router();
router.use(requireAuth);

router.get(
  '/',
  asyncHandler(async (req, res) => {
    res.json(await borrowerService.listBorrowers());
  }),
);

router.get(
  '/:id',
  asyncHandler(async (req, res) => {
    res.json(await borrowerService.getBorrower(req.params.id));
  }),
);

router.get(
  '/:id/loans',
  asyncHandler(async (req, res) => {
    res.json(await loanService.loansForBorrower(req.params.id));
  }),
);

router.get(
  '/:id/payments',
  asyncHandler(async (req, res) => {
    const limit = req.query.limit ? Number(req.query.limit) : 10;
    res.json(await paymentService.paymentsForBorrower(req.params.id, { limit }));
  }),
);

const borrowerDraftSchema = z.object({
  name: z.string().min(2),
  mobile: z.string().regex(/^[6-9]\d{9}$/, 'Enter a valid 10-digit mobile number'),
  aadhaar: z.string().regex(/^\d{12}$/, 'Enter a valid 12-digit Aadhaar number'),
  village: z.string().min(1),
  address: z.string().min(1),
  pinCode: z.string().regex(/^\d{6}$/, 'Enter a valid 6-digit PIN code'),
});

router.post(
  '/',
  asyncHandler(async (req, res) => {
    const draft = borrowerDraftSchema.parse(req.body);
    res.status(201).json(await borrowerService.createBorrower(draft));
  }),
);

module.exports = router;
