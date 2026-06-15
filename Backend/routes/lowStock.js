const router = require('express').Router();
const handleError = require('../middleware/errorHandler');
const { authMiddleware, adminOnly } = require('../middleware/auth');
const sessionController = require('../controllers/sessionController');

router.get('/', authMiddleware, async (req, res) => {
  try {
    await sessionController.getLowStock(req, res);
  } catch (err) {
    handleError(res, err, '/api/low-stock [GET]');
  }
});

module.exports = router;
