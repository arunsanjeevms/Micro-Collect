const { Router } = require('express');
const { z } = require('zod');
const asyncHandler = require('../middleware/asyncHandler');
const { requireAuth, requireRole } = require('../middleware/auth');
const authService = require('../services/authService');

const router = Router();

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1),
});

router.post(
  '/login',
  asyncHandler(async (req, res) => {
    const { email, password } = loginSchema.parse(req.body);
    const result = await authService.login(email, password);
    res.json(result);
  }),
);

const registerSchema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
  name: z.string().min(1),
  role: z.enum(['ADMIN', 'MANAGER', 'FIELD_OFFICER', 'CASHIER']).optional(),
});

// Only an existing admin can create new accounts - there's no public
// self-registration for a collection-officer app.
router.post(
  '/register',
  requireAuth,
  requireRole('ADMIN'),
  asyncHandler(async (req, res) => {
    const input = registerSchema.parse(req.body);
    const user = await authService.createUser(input);
    res.status(201).json(user);
  }),
);

router.get('/me', requireAuth, (req, res) => {
  res.json({ id: req.user.sub, email: req.user.email, name: req.user.name, role: req.user.role });
});

module.exports = router;
