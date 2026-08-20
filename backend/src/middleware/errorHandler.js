const { AppError } = require('../utils/errors');

// eslint-disable-next-line no-unused-vars
function errorHandler(err, req, res, next) {
  if (err instanceof AppError) {
    return res.status(err.status).json({ error: { code: err.code, message: err.message } });
  }

  if (err && err.code === 'P2025') {
    // Prisma "record to update/delete not found"
    return res.status(404).json({ error: { code: 'not_found', message: 'Record not found' } });
  }

  console.error(err); // eslint-disable-line no-console
  return res
    .status(500)
    .json({ error: { code: 'internal', message: 'Something went wrong' } });
}

module.exports = errorHandler;
