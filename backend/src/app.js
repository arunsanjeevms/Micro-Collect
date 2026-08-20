const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const { ZodError } = require('zod');

const errorHandler = require('./middleware/errorHandler');
const { ValidationError } = require('./utils/errors');
const authRoutes = require('./routes/authRoutes');
const borrowerRoutes = require('./routes/borrowerRoutes');
const loanRoutes = require('./routes/loanRoutes');
const collectionRoutes = require('./routes/collectionRoutes');

const app = express();

app.use(helmet());
app.use(cors({ origin: process.env.CORS_ORIGIN || '*' }));
app.use(express.json());
app.use(morgan('dev'));

app.get('/health', (req, res) => res.json({ status: 'ok' }));

app.use('/auth', authRoutes);
app.use('/borrowers', borrowerRoutes);
app.use('/loans', loanRoutes);
app.use('/collections', collectionRoutes);

app.use((req, res) => {
  res.status(404).json({ error: { code: 'not_found', message: 'Route not found' } });
});

// Turns a Zod parse failure into the same 422 shape as ValidationError,
// so route handlers can just call schema.parse(req.body) and let this
// middleware chain translate it instead of each one catching it by hand.
app.use((err, req, res, next) => {
  if (err instanceof ZodError) {
    return errorHandler(
      new ValidationError(err.issues.map((i) => i.message).join('; ')),
      req,
      res,
      next,
    );
  }
  return errorHandler(err, req, res, next);
});

module.exports = app;
