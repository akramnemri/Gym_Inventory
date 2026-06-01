const currentDateTime = () => new Date().toISOString().slice(0, 19).replace('T', ' ');

const safeSerialize = (obj, maxDepth = 3) => {
  try {
    if (maxDepth <= 0) return '...';
    if (obj === null || obj === undefined) return obj;
    if (typeof obj !== 'object') return obj;
    if (Array.isArray(obj)) return obj.slice(0, 10).map(item => safeSerialize(item, maxDepth - 1));
    const seen = new Set();
    const result = {};
    for (const [key, value] of Object.entries(obj)) {
      if (seen.has(value)) continue;
      seen.add(value);
      try { result[key] = safeSerialize(value, maxDepth - 1); } catch (_) { result[key] = '[unserializable]'; }
    }
    return result;
  } catch (_) { return '[unserializable]'; }
};

const handleError = (res, err, endpoint, extra = {}) => {
  console.error(`\n[${currentDateTime()}] Error in [${endpoint}]:`, err);
  if (Object.keys(extra).length > 0) {
    console.error('Additional info:', JSON.stringify(safeSerialize(extra), null, 2));
  }

  res.status(500).json({
    message: 'Server error',
    endpoint,
    error: typeof err === 'object' ? (err.message || 'Unknown') : String(err),
    stack: process.env.NODE_ENV === 'development' ? (typeof err === 'object' ? err.stack : undefined) : undefined,
  });
};

// Express global error handler (4 args = error middleware)
const errorMiddleware = (err, req, res, next) => {
  if (res.headersSent) return next(err);
  console.error(`\n[${currentDateTime()}] Unhandled error [${req.method} ${req.originalUrl}]:`, err);
  res.status(err.statusCode || 500).json({
    message: err.message || 'Server error',
    error: err.statusCode === 500 && process.env.NODE_ENV !== 'development' ? undefined : (typeof err === 'object' ? err.message : String(err)),
    stack: process.env.NODE_ENV === 'development' ? (typeof err === 'object' ? err.stack : undefined) : undefined,
  });
};

module.exports = handleError;
module.exports.middleware = errorMiddleware;