const bcrypt = require('bcrypt');
const crypto = require('crypto');
const query = require('../config/database');
const transporter = require('../config/email');
const { validateSignupData, validateEmail, validatePassword } = require('../utils/validators');
const { ADMIN_CODE, TOKEN_EXPIRY_MINUTES } = require('../config/constants');
const { generateToken } = require('../middleware/auth');

const signup = async (req, res) => {
  try {
    const validation = validateSignupData(req.body);
    if (!validation.valid) {
      return res.status(400).json({ field: validation.field, message: validation.message });
    }
    
    const { first_name, last_name, username, email, phone, password, admin_code } = req.body;
    
    // Check existing username
    const usernameCheck = await query('SELECT id FROM users WHERE username=?', [username]);
    if (usernameCheck.length > 0) {
      return res.status(400).json({ field: 'username', message: 'Username already exists.' });
    }
    
    // Check existing email
    const emailCheck = await query('SELECT id FROM users WHERE email=?', [email]);
    if (emailCheck.length > 0) {
      return res.status(400).json({ field: 'email', message: 'Email already exists.' });
    }
    
    const password_hash = await bcrypt.hash(password, 10);
    let type_account = 'user';
    
    if (admin_code && admin_code.trim() !== '') {
      if (admin_code === ADMIN_CODE) {
        type_account = 'admin';
      } else {
        return res.status(400).json({ field: 'admin_code', message: 'Invalid admin code.' });
      }
    }
    
    await query(
      `INSERT INTO users (first_name, last_name, username, email, phone, password_hash, type_account)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [first_name, last_name, username, email, phone, password_hash, type_account]
    );
    
    res.json({ message: `Account created as ${type_account}. You can now log in.` });
  } catch (err) {
    throw err;
  }
};

const login = async (req, res) => {
  try {
    const { identifier, password } = req.body;
    
    if (!identifier || !password) {
      return res.status(400).json({ field: 'general', message: 'Missing credentials.' });
    }
    
    let users = [];
    if (validateEmail(identifier)) {
      users = await query('SELECT * FROM users WHERE email=?', [identifier]);
      if (users.length === 0) {
        return res.status(401).json({ field: 'email', message: 'Email not found.' });
      }
    } else {
      users = await query('SELECT * FROM users WHERE username=?', [identifier]);
      if (users.length === 0) {
        return res.status(401).json({ field: 'username', message: 'Username not found.' });
      }
    }
    
    const user = users[0];
    const match = await bcrypt.compare(password, user.password_hash);
    
    if (!match) {
      return res.status(401).json({ field: 'password', message: 'Incorrect password.' });
    }
    
    const token = generateToken(user);
    
    await query('INSERT INTO session_logs (user_id, login_time) VALUES (?, NOW())', [user.id]);
    
    res.json({
      message: `You have logged in as ${user.type_account}.`,
      token,
      id: Number(user.id),
      first_name: user.first_name,
      last_name: user.last_name,
      username: user.username,
      email: user.email,
      phone: user.phone,
      type_account: user.type_account
    });
  } catch (err) {
    throw err;
  }
};

const logout = async (req, res) => {
  try {
    const { user_id } = req.body;
    
    if (!user_id) {
      return res.status(400).json({ message: 'Missing user_id' });
    }
    
    await query(
      'UPDATE session_logs SET logout_time=NOW() WHERE user_id=? AND logout_time IS NULL ORDER BY login_time DESC LIMIT 1',
      [user_id]
    );
    
    res.json({ message: 'Logout successful' });
  } catch (err) {
    throw err;
  }
};

const forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;
    
    if (!email) {
      return res.status(400).json({ field: 'email', message: 'Email required.' });
    }
    
    const users = await query('SELECT * FROM users WHERE email=?', [email]);
    if (users.length === 0) {
      return res.status(404).json({ field: 'email', message: 'Email not found.' });
    }
    
    const user = users[0];
    const token = crypto.randomBytes(32).toString('hex');
    const expiresAt = new Date(Date.now() + 1000 * 60 * TOKEN_EXPIRY_MINUTES);
    
    await query(
      'INSERT INTO password_reset_tokens (user_id, token, expires_at, created_at) VALUES (?, ?, ?, NOW())',
      [user.id, token, expiresAt]
    );
    
    const mailOptions = {
      from: 'reactstream0@gmail.com',
      to: email,
      subject: 'Password Reset Request for Your Gym Machine Inventory App Account',
      html: `
        <p>Dear ${user.first_name},</p>
        <p>We received a request to reset the password for your account.</p>
        <p>Your password reset token is: <strong>${token}</strong></p>
        <p>This token is valid for ${TOKEN_EXPIRY_MINUTES} minutes. Please enter this token into your desktop application to set a new password.</p>
        <p>If you did not request a password reset, please ignore this email.</p>
        <p>Thanks,</p>
        <p>The Gym Machine Inventory App Team</p>
      `
    };
    
    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.error('Error sending password reset email:', error);
        return res.status(500).json({ message: 'Failed to send password reset email.' });
      }
      console.log('Password reset email sent:', info.response);
      res.json({ message: 'A password reset token has been sent to your email. Please check your inbox (and spam folder).' });
    });
  } catch (err) {
    throw err;
  }
};

const resetPassword = async (req, res) => {
  try {
    const { token, newPassword } = req.body;
    
    if (!token || !newPassword) {
      return res.status(400).json({ message: 'Token and new password required.' });
    }
    
    const tokens = await query(
      'SELECT * FROM password_reset_tokens WHERE token=? AND expires_at > NOW()',
      [token]
    );
    
    if (tokens.length === 0) {
      return res.status(400).json({ message: 'Invalid or expired token.' });
    }
    
    const resetRow = tokens[0];
    
    if (!validatePassword(newPassword)) {
      return res.status(400).json({ 
        field: 'password', 
        message: 'Password must be at least 8 chars with letters and numbers.' 
      });
    }
    
    const password_hash = await bcrypt.hash(newPassword, 10);
    await query('UPDATE users SET password_hash=? WHERE id=?', [password_hash, resetRow.user_id]);
    await query('DELETE FROM password_reset_tokens WHERE id=?', [resetRow.id]);
    
    res.json({ message: 'Password has been reset successfully.' });
  } catch (err) {
    throw err;
  }
};

module.exports = {
  signup,
  login,
  logout,
  forgotPassword,
  resetPassword
};