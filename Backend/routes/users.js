const router = require('express').Router();
const handleError = require('../middleware/errorHandler');
const { authMiddleware } = require('../middleware/auth');
const userController = require('../controllers/userController');

router.get('/:id', authMiddleware, async (req, res) => {
  try {
    await userController.getUser(req, res);
  } catch (err) {
    handleError(res, err, '/api/users/:id', { params: req.params });
  }
});

router.put('/:id', authMiddleware, async (req, res) => {
  try {
    const targetId = Number(req.params.id);
    if (isNaN(targetId)) {
      return res.status(400).json({ message: 'Invalid user ID' });
    }
    if (req.user.id !== targetId && req.user.type_account !== 'admin') {
      return res.status(403).json({ message: 'You can only update your own account' });
    }
    req.body.user_id = req.user.id;
    await userController.updateUser(req, res);
  } catch (err) {
    handleError(res, err, '/api/users/:id [PUT]', { body: req.body });
  }
});

module.exports = router;