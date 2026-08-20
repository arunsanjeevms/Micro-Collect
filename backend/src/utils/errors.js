/**
 * Error taxonomy mirroring lib/core/errors/app_exception.dart, so the
 * client-side error UI (ErrorStateWidget's switch) can eventually key off
 * the same shape whether it's talking to the mock backend or this API.
 * Each carries an HTTP status and a machine-readable `code` the future
 * ApiException on the Flutter side can switch on.
 */
class AppError extends Error {
  constructor(message, { status = 500, code = 'internal' } = {}) {
    super(message);
    this.status = status;
    this.code = code;
  }
}

class NotFoundError extends AppError {
  constructor(kind, id) {
    super(`${kind} ${id} not found`, { status: 404, code: 'not_found' });
  }
}

class ValidationError extends AppError {
  constructor(message) {
    super(message, { status: 422, code: 'validation' });
  }
}

class PaymentFailedError extends AppError {
  constructor(message = 'Payment could not be recorded') {
    super(message, { status: 409, code: 'payment_failed' });
  }
}

class PermissionError extends AppError {
  constructor(message = 'Not allowed') {
    super(message, { status: 403, code: 'permission' });
  }
}

class UnauthorizedError extends AppError {
  constructor(message = 'Invalid credentials') {
    super(message, { status: 401, code: 'unauthorized' });
  }
}

module.exports = {
  AppError,
  NotFoundError,
  ValidationError,
  PaymentFailedError,
  PermissionError,
  UnauthorizedError,
};
