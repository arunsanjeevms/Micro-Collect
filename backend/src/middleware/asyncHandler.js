// Wraps an async route handler so a rejected promise reaches
// errorHandler.js instead of crashing the process.
module.exports = (fn) => (req, res, next) => Promise.resolve(fn(req, res, next)).catch(next);
