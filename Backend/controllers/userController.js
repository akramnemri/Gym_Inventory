const bcrypt = require('bcrypt');
const fs = require('fs');
const path = require('path');
const query = require('../config/database');
const { validatePhone, validatePassword } = require('../utils/validators');
const { uploadDir } = require('../middleware/upload');

const getUser = async (req, res) => {
  try {
    const userId = Number(req.params.id);
    
    if (isNaN(userId)) {
      return res.status(400).json({ message: 'Invalid user ID' });
    }
    
    const results = await query(
      'SELECT id, first_name, last_name, username, email, phone, type_account, profile_picture FROM users WHERE id=?',
      [userId]
    );
    
    if (results.length === 0) {
      return res.status(404).json({ message: 'User not found' });
    }
    
    res.json(results[0]);
  } catch (err) {
    throw err;
  }
};

const updateUser = async (req, res) => {
  try {
    const userId = Number(req.params.id);
    
    if (isNaN(userId)) {
      return res.status(400).json({ message: 'Invalid user ID' });
    }
    
    const { first_name, last_name, username, phone, password, current_password, profile_picture } = req.body;
    
    if (!first_name || !last_name || !username || !phone) {
      return res.status(400).json({ field: 'general', message: 'Required fields missing.' });
    }
    
    if (!validatePhone(phone)) {
      return res.status(400).json({ field: 'phone', message: 'Phone must be 8 digits.' });
    }
    
    // Check if username is already taken by another user
    const usernameCheck = await query('SELECT id FROM users WHERE username=? AND id!=?', [username, userId]);
    if (usernameCheck.length > 0) {
      return res.status(400).json({ field: 'username', message: 'Username already exists.' });
    }
    
    const updates = [first_name, last_name, username, phone];
    let queryStr = 'UPDATE users SET first_name=?, last_name=?, username=?, phone=?';
    
    // If user wants to change password, verify current password first
    if (password) {
      if (!current_password) {
        return res.status(400).json({ 
          field: 'current_password', 
          message: 'Current password is required to set a new password.' 
        });
      }
      
      // Verify current password
      const userRows = await query('SELECT password_hash FROM users WHERE id=?', [userId]);
      if (userRows.length === 0) {
        return res.status(404).json({ message: 'User not found.' });
      }
      
      const match = await bcrypt.compare(current_password, userRows[0].password_hash);
      if (!match) {
        return res.status(401).json({ 
          field: 'current_password', 
          message: 'Current password is incorrect.' 
        });
      }
      
      if (!validatePassword(password)) {
        return res.status(400).json({ 
          field: 'password', 
          message: 'Password must be at least 8 chars with letters and numbers.' 
        });
      }
      
      const password_hash = await bcrypt.hash(password, 10);
      queryStr += ', password_hash=?';
      updates.push(password_hash);
    }
    
    let profilePicFilename = null;
    if (profile_picture) {
      const buffer = Buffer.from(profile_picture, 'base64');
      profilePicFilename = `profile_${userId}_${Date.now()}.png`;
      const filePath = path.join(uploadDir, profilePicFilename);
      fs.writeFileSync(filePath, buffer);
      queryStr += ', profile_picture=?';
      updates.push(profilePicFilename);
    }
    
    queryStr += ' WHERE id=?';
    updates.push(userId);
    
    await query(queryStr, updates);
    
    res.json({ 
      message: 'User updated successfully', 
      profile_picture: profilePicFilename 
    });
  } catch (err) {
    throw err;
  }
};

module.exports = {
  getUser,
  updateUser
};