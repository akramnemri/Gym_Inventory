module.exports = {
  // Validation patterns
  EMAIL_REGEX: /^[^\s@]+@[^\s@]+\.[^\s@]{2,8}$/,
  PHONE_REGEX: /^[0-9]{8}$/,
  PASSWORD_REGEX: /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/,
  
  // Admin code
  ADMIN_CODE: '0000',
  
  // Server config
  PORT: process.env.PORT || 3000,
  
  // CORS config
  CORS_ORIGIN: process.env.CORS_ORIGIN || 'http://localhost:3000',
  
  // Password reset token expiry (15 minutes)
  TOKEN_EXPIRY_MINUTES: 15
};