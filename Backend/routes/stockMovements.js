const router = require('express').Router();
const handleError = require('../middleware/errorHandler');
const { authMiddleware } = require('../middleware/auth');
const sessionController = require('../controllers/sessionController');

router.get('/', authMiddleware, async (req, res) => {
  try {
    await sessionController.getStockMovements(req, res);
  } catch (err) {
    handleError(res, err, '/api/stock-movements [GET]');
  }
});

module.exports = router;