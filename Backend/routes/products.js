const router = require('express').Router();
const { upload } = require('../middleware/upload');
const handleError = require('../middleware/errorHandler');
const { authMiddleware, adminOnly } = require('../middleware/auth');
const productController = require('../controllers/productController');

router.get('/', async (req, res) => {
  try {
    await productController.getAllProducts(req, res);
  } catch (err) {
    handleError(res, err, '/api/products [GET]');
  }
});

router.get('/:id', async (req, res) => {
  try {
    await productController.getProduct(req, res);
  } catch (err) {
    handleError(res, err, '/api/products/:id [GET]', { params: req.params });
  }
});

router.post('/', authMiddleware, adminOnly, upload.single('image'), async (req, res) => {
  try {
    await productController.createProduct(req, res);
  } catch (err) {
    handleError(res, err, '/api/products [POST]', { body: req.body, file: req.file });
  }
});

router.put('/:id', authMiddleware, adminOnly, upload.single('image'), async (req, res) => {
  try {
    await productController.updateProduct(req, res);
  } catch (err) {
    handleError(res, err, '/api/products/:id [PUT]', { body: req.body, file: req.file });
  }
});

router.delete('/:id', authMiddleware, adminOnly, async (req, res) => {
  try {
    await productController.deleteProduct(req, res);
  } catch (err) {
    handleError(res, err, '/api/products/:id [DELETE]', { params: req.params });
  }
});

router.post('/:id/produce', authMiddleware, async (req, res) => {
  try {
    await productController.produceProduct(req, res);
  } catch (err) {
    handleError(res, err, '/api/products/:id/produce [POST]', { body: req.body });
  }
});

module.exports = router;