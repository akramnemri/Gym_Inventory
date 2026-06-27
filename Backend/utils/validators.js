const { EMAIL_REGEX, PHONE_REGEX, PASSWORD_REGEX } = require('../config/constants');

const validateEmail = (email) => EMAIL_REGEX.test(email);
const validatePhone = (phone) => PHONE_REGEX.test(phone);
const validatePassword = (password) => PASSWORD_REGEX.test(password);

const validateSignupData = (data) => {
  const { first_name, last_name, username, email, phone, password } = data;
  
  if (!first_name || !last_name || !username || !email || !phone || !password) {
    return { valid: false, field: 'general', message: 'All fields except admin code are required.' };
  }
  
  if (!validateEmail(email)) {
    return { valid: false, field: 'email', message: 'Invalid email format.' };
  }
  
  if (!validatePhone(phone)) {
    return { valid: false, field: 'phone', message: 'Phone must be 8 digits.' };
  }
  
  if (!validatePassword(password)) {
    return { valid: false, field: 'password', message: 'Password must be at least 8 chars with letters and numbers.' };
  }
  
  return { valid: true };
};

module.exports = {
  validateEmail,
  validatePhone,
  validatePassword,
  validateSignupData
};