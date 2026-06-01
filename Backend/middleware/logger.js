const SENSITIVE_FIELDS = ['password', 'newPassword', 'current_password', 'token', 'pass', 'authorization'];

function sanitizeBody(body) {
  if (!body || typeof body !== 'object') return body;
  const sanitized = { ...body };
  for (const field of SENSITIVE_FIELDS) {
    if (field in sanitized) {
      sanitized[field] = '***REDACTED***';
    }
  }
  return sanitized;
}

const logger = (req, res, next) => {
  const logData = {
    method: req.method,
    url: req.url,
    timestamp: new Date().toISOString()
  };
  
  if (req.method === 'POST' || req.method === 'PUT') {
    logData.body = sanitizeBody(req.body);
  }
  
  console.log(`[${logData.timestamp}] ${logData.method} ${logData.url}`, 
    logData.body ? JSON.stringify(logData.body) : '');
  
  next();
};

module.exports = logger;