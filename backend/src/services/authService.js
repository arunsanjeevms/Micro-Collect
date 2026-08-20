const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const prisma = require('../config/prisma');
const { UnauthorizedError, ValidationError } = require('../utils/errors');

function signToken(user) {
  return jwt.sign(
    { sub: user.id, email: user.email, name: user.name, role: user.role },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN || '12h' },
  );
}

function serializeUser(user) {
  return { id: user.id, email: user.email, name: user.name, role: user.role };
}

async function login(email, password) {
  const user = await prisma.user.findUnique({ where: { email } });
  if (!user) throw new UnauthorizedError();

  const ok = await bcrypt.compare(password, user.passwordHash);
  if (!ok) throw new UnauthorizedError();

  return { token: signToken(user), user: serializeUser(user) };
}

async function createUser({ email, password, name, role }) {
  const existing = await prisma.user.findUnique({ where: { email } });
  if (existing) throw new ValidationError('A user with this email already exists');

  const passwordHash = await bcrypt.hash(password, 10);
  const user = await prisma.user.create({
    data: { email, passwordHash, name, role: role || 'FIELD_OFFICER' },
  });
  return serializeUser(user);
}

module.exports = { login, createUser, serializeUser };
