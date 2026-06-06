const router = require('express').Router();
const handleError = require('../middleware/errorHandler');
const { authMiddleware } = require('../middleware/auth');
const sessionController = require('../controllers/sessionController');

router.get('/', authMiddleware, async (req, res) => {
  try {
    await sessionController.getSessions(req, res);
  } catch (err) {
    handleError(res, err, '/api/sessions [GET]');
  }
});

module.exports = router;