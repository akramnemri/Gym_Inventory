const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'gym-inventory-secret-key-2024';
const JWT_EXPIRY = '8h';

const generateToken = (user) => {
  return jwt.sign(
    { id: user.id, username: user.username, type_account: user.type_account },
    JWT_SECRET,
    { expiresIn: JWT_EXPIRY }
  );
};

const authMiddleware = (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Access token required' });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(401).json({ message: 'Invalid or expired token' });
  }
};

const optionalAuth = (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (authHeader && authHeader.startsWith('Bearer ')) {
    try {
      const token = authHeader.split(' ')[1];
      req.user = jwt.verify(token, JWT_SECRET);
    } catch (err) {
      req.user = null;
    }
  } else {
    req.user = null;
  }
  next();
};

const adminOnly = (req, res, next) => {
  if (!req.user || req.user.type_account !== 'admin') {
    return res.status(403).json({ message: 'Admin access required' });
  }
  next();
};

module.exports = {
  generateToken,
  authMiddleware,
  optionalAuth,
  adminOnly,
  JWT_SECRET
};
