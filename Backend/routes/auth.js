const router = require('express').Router();
const handleError = require('../middleware/errorHandler');
const { generateToken, authMiddleware } = require('../middleware/auth');
const authController = require('../controllers/authController');

router.post('/signup', async (req, res) => {
  try {
    await authController.signup(req, res);
  } catch (err) {
    handleError(res, err, '/api/auth/signup', { body: req.body });
  }
});

router.post('/login', async (req, res) => {
  try {
    await authController.login(req, res);
  } catch (err) {
    handleError(res, err, '/api/auth/login', { body: req.body });
  }
});

router.post('/logout', authMiddleware, async (req, res) => {
  try {
    req.body.user_id = req.user.id;
    await authController.logout(req, res);
  } catch (err) {
    handleError(res, err, '/api/auth/logout', { body: req.body });
  }
});

router.post('/forgot-password', async (req, res) => {
  try {
    await authController.forgotPassword(req, res);
  } catch (err) {
    handleError(res, err, '/api/auth/forgot-password', { body: req.body });
  }
});

router.post('/reset-password', async (req, res) => {
  try {
    await authController.resetPassword(req, res);
  } catch (err) {
    handleError(res, err, '/api/auth/reset-password', { body: req.body });
  }
});

module.exports = router;