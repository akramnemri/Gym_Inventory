const router = require('express').Router();
const { upload } = require('../middleware/upload');
const handleError = require('../middleware/errorHandler');
const { authMiddleware, adminOnly } = require('../middleware/auth');
const componentController = require('../controllers/componentController');

router.get('/', async (req, res) => {
  try {
    await componentController.getAllComponents(req, res);
  } catch (err) {
    handleError(res, err, '/api/components [GET]');
  }
});

router.get('/:id', async (req, res) => {
  try {
    await componentController.getComponent(req, res);
  } catch (err) {
    handleError(res, err, '/api/components/:id [GET]', { params: req.params });
  }
});

router.post('/', authMiddleware, adminOnly, upload.single('image'), async (req, res) => {
  try {
    await componentController.createComponent(req, res);
  } catch (err) {
    handleError(res, err, '/api/components [POST]', { body: req.body, file: req.file });
  }
});

router.put('/:id', authMiddleware, adminOnly, upload.single('image'), async (req, res) => {
  try {
    await componentController.updateComponent(req, res);
  } catch (err) {
    handleError(res, err, '/api/components/:id [PUT]', { body: req.body, file: req.file });
  }
});

router.delete('/:id', authMiddleware, adminOnly, async (req, res) => {
  try {
    await componentController.deleteComponent(req, res);
  } catch (err) {
    handleError(res, err, '/api/components/:id [DELETE]', { params: req.params });
  }
});

module.exports = router;