// routes/dashboard.js
const router = require('express').Router();
const handleError = require('../middleware/errorHandler');
const { authMiddleware, adminOnly } = require('../middleware/auth');
const sessionController = require('../controllers/sessionController');


// Dashboard statistics endpoint
router.get('/statistics', authMiddleware, async (req, res) => {
  try {
    await sessionController.getDashboardStatistics(req, res);
  } catch (err) {
    handleError(res, err, '/api/dashboard/statistics [GET]');
  }
});

// Production statistics endpoint
router.get('/production-stats', authMiddleware, async (req, res) => {
  try {
    await sessionController.getProductionStatistics(req, res);
  } catch (err) {
    handleError(res, err, '/api/dashboard/production-stats [GET]');
  }
});

// User activity statistics endpoint (admin only)
router.get('/user-activity', authMiddleware, adminOnly, async (req, res) => {
  try {
    await sessionController.getUserActivityStatistics(req, res);
  } catch (err) {
    handleError(res, err, '/api/dashboard/user-activity [GET]');
  }
});

// Stock evolution endpoint
router.get('/stock-evolution', authMiddleware, async (req, res) => {
  try {
    await sessionController.getStockEvolution(req, res);
  } catch (err) {
    handleError(res, err, '/api/dashboard/stock-evolution [GET]');
  }
});

module.exports = router;