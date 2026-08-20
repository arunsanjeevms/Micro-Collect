const jwt = require('jsonwebtoken');
const { UnauthorizedError, PermissionError } = require('../utils/errors');

function requireAuth(req, res, next) {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token) return next(new UnauthorizedError('Missing bearer token'));

  try {
    req.user = jwt.verify(token, process.env.JWT_SECRET);
    return next();
  } catch {
    return next(new UnauthorizedError('Invalid or expired token'));
  }
}

// Usage: requireRole('ADMIN', 'MANAGER')
function requireRole(...roles) {
  return (req, res, next) => {
    if (!req.user) return next(new UnauthorizedError());
    if (!roles.includes(req.user.role)) {
      return next(new PermissionError(`Requires role: ${roles.join(' or ')}`));
    }
    return next();
  };
}

module.exports = { requireAuth, requireRole };
