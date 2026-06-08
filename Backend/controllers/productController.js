const fs = require('fs');
const path = require('path');
const query = require('../config/database');
const { fetchAdditionalInfo, fetchRequiredComponents, currentDateTime } = require('../utils/helpers');
const { createStockMovement } = require('../utils/stockTracker');
const { uploadDir } = require('../middleware/upload');

const getAllProducts = async (req, res) => {
  try {
    const results = await query(`SELECT * FROM final_products WHERE is_deleted=0`);
    
    for (let prod of results) {
      prod.id = Number(prod.id);
      prod.additional_info = await fetchAdditionalInfo('product', 'product_id', prod.id);
      prod.required_components = await fetchRequiredComponents(prod.id);
    }
    
    res.json(results);
  } catch (err) {
    throw err;
  }
};

const getProduct = async (req, res) => {
  try {
    const prodId = Number(req.params.id);
    
    if (isNaN(prodId)) {
      return res.status(400).json({ message: 'Invalid product ID' });
    }
    
    const productRows = await query(
      `SELECT * FROM final_products WHERE id=? AND is_deleted=0`,
      [prodId]
    );
    
    const product = productRows[0];
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    
    product.id = Number(product.id);
    product.additional_info = await fetchAdditionalInfo('product', 'product_id', product.id);
    product.required_components = await fetchRequiredComponents(product.id);
    
    res.json(product);
  } catch (err) {
    throw err;
  }
};

const createProduct = async (req, res) => {
  try {
    const { name, category, description, stock, additional_info, required_components } = req.body;
    const image_path = req.file ? req.file.filename : null;
    
    const result = await query(
      `INSERT INTO final_products (name, category, description, stock, image_path) 
       VALUES (?, ?, ?, ?, ?)`,
      [name, category, description, stock ?? 0, image_path]
    );
    
    const insertId = result.insertId;
    
    let parsedInfo = [];
    if (additional_info) {
      try {
   parsedInfo = Array.isArray(additional_info) ? additional_info : JSON.parse(additional_info);
      } catch (err) {
        console.error('Failed to parse additional_info:', additional_info, err);
      }
    }
    
    await query(
      `INSERT INTO product_additional_info (product_id, info) VALUES (?, ?)`,
      [insertId, JSON.stringify(parsedInfo)]
    );
    
    let parsedReqComps = [];
    if (required_components) {
      try {
        parsedReqComps = Array.isArray(required_components) ? required_components : JSON.parse(required_components);
      } catch (err) {
        console.error('Failed to parse required_components:', required_components, err);
      }
    }
    
    for (let rc of parsedReqComps) {
      await query(
        `INSERT INTO product_components (product_id, component_id, quantity_required) VALUES (?, ?, ?)`,
        [insertId, rc.component_id, rc.quantity_required]
      );
    }
    
    const newProdRows = await query(`SELECT * FROM final_products WHERE id=?`, [insertId]);
    const newProd = newProdRows[0];
    newProd.id = Number(newProd.id);
    newProd.additional_info = await fetchAdditionalInfo('product', 'product_id', newProd.id);
    newProd.required_components = await fetchRequiredComponents(newProd.id);
    
    res.json(newProd);
  } catch (err) {
    throw err;
  }
};

const updateProduct = async (req, res) => {
  try {
    const prodId = Number(req.params.id);
    
    if (isNaN(prodId) || prodId <= 0) {
      return res.status(400).json({ message: 'Invalid product ID' });
    }
    
    const { name, category, description, stock, additional_info, required_components, remove_image } = req.body;
    const userId = req.user.id;
    
    const currentProdRows = await query(
      `SELECT image_path, stock FROM final_products WHERE id=? AND is_deleted=0`,
      [prodId]
    );
    
    const currentProd = currentProdRows[0];
    if (!currentProd) {
      return res.status(404).json({ message: 'Product not found' });
    }
    
    const oldStock = currentProd.stock || 0;
    const newStock = Number(stock) || 0;
    
    let finalImage = currentProd.image_path;
    
    if (req.file) {
      finalImage = req.file.filename;
      if (currentProd.image_path) {
        const oldPath = path.join(uploadDir, currentProd.image_path);
        if (fs.existsSync(oldPath)) fs.unlinkSync(oldPath);
      }
    } else if (remove_image === 'true') {
      finalImage = null;
      if (currentProd.image_path) {
        const oldPath = path.join(uploadDir, currentProd.image_path);
        if (fs.existsSync(oldPath)) fs.unlinkSync(oldPath);
      }
    }
    
    await query(
      `UPDATE final_products SET name=?, category=?, description=?, stock=?, image_path=? WHERE id=?`,
      [name, category, description, newStock, finalImage, prodId]
    );
    
    if (oldStock !== newStock) {
      const quantityChange = newStock - oldStock;
      await createStockMovement(userId, null, prodId, quantityChange);
    }
    
    let parsedInfo = [];
    if (additional_info) {
      try {
        parsedInfo = Array.isArray(additional_info) ? additional_info : JSON.parse(additional_info);
      } catch (err) {
        console.error('Failed to parse additional_info:', additional_info, err);
      }
    }
    
    const existingInfoRows = await query(
      `SELECT id FROM product_additional_info WHERE product_id=?`,
      [prodId]
    );
    
    if (existingInfoRows.length > 0) {
      await query(
        `UPDATE product_additional_info SET info=? WHERE product_id=?`,
        [JSON.stringify(parsedInfo), prodId]
      );
    } else {
      await query(
        `INSERT INTO product_additional_info (product_id, info) VALUES (?, ?)`,
        [prodId, JSON.stringify(parsedInfo)]
      );
    }
    
    await query(`DELETE FROM product_components WHERE product_id=?`, [prodId]);
    
    let parsedReqComps = [];
    if (required_components) {
      try {
        parsedReqComps = Array.isArray(required_components) ? required_components : JSON.parse(required_components);
      } catch (err) {
        console.error('Failed to parse required_components:', required_components, err);
      }
    }
    
    for (let rc of parsedReqComps) {
      await query(
        `INSERT INTO product_components (product_id, component_id, quantity_required) VALUES (?, ?, ?)`,
        [prodId, rc.component_id, rc.quantity_required]
      );
    }
    
    const updatedProdRows = await query(`SELECT * FROM final_products WHERE id=?`, [prodId]);
    const updatedProd = updatedProdRows[0];
    updatedProd.id = Number(updatedProd.id);
    updatedProd.additional_info = await fetchAdditionalInfo('product', 'product_id', updatedProd.id);
    updatedProd.required_components = await fetchRequiredComponents(updatedProd.id);
    
    res.json(updatedProd);
  } catch (err) {
    throw err;
  }
};

const deleteProduct = async (req, res) => {
  try {
    const prodId = Number(req.params.id);
    
    if (isNaN(prodId)) {
      return res.status(400).json({ message: 'Invalid product ID' });
    }
    
    const result = await query('UPDATE final_products SET is_deleted=1 WHERE id=?', [prodId]);
    
    if ((result.affectedRows ?? 0) === 0) {
      return res.status(404).json({ message: 'Product not found' });
    }
    
    res.json({ message: 'Product soft deleted' });
  } catch (err) {
    throw err;
  }
};

const { transaction } = require('../config/database');

const produceProduct = async (req, res) => {
  try {
    const prodId = Number(req.params.id);

    if (isNaN(prodId)) {
      return res.status(400).json({ message: 'Invalid product ID' });
    }

    const userId = req.user.id;

    await transaction(async (conn) => {
      const requiredComps = await fetchRequiredComponents(prodId);

      if (requiredComps.length > 0) {
        const insufficientComponents = [];

        for (let rc of requiredComps) {
          const [[comp]] = await conn.execute(
            `SELECT stock FROM components WHERE id = ?`,
            [rc.component_id]
          );
          if (!comp) {
            insufficientComponents.push({
              name: rc.name,
              required: rc.quantity_required,
              available: 0,
              shortage: rc.quantity_required,
            });
            continue;
          }
          if (comp.stock < rc.quantity_required) {
            insufficientComponents.push({
              name: rc.name,
              required: rc.quantity_required,
              available: comp.stock,
              shortage: rc.quantity_required - comp.stock,
            });
          }
        }

        if (insufficientComponents.length > 0) {
          return res.status(400).json({
            message: 'Insufficient stock',
            insufficientComponents: insufficientComponents,
          });
        }

        for (let rc of requiredComps) {
          await conn.execute(
            `UPDATE components SET stock = stock - ? WHERE id = ?`,
            [rc.quantity_required, rc.component_id]
          );
          await createStockMovementWithinTx(conn, userId, rc.component_id, null, -rc.quantity_required);
        }
      }

      await conn.execute(
        `UPDATE final_products SET stock = stock + 1 WHERE id = ?`,
        [prodId]
      );
      await createStockMovementWithinTx(conn, userId, null, prodId, 1);

      res.json({ message: 'Product produced successfully' });
    });
  } catch (err) {
    throw err;
  }
};

async function createStockMovementWithinTx(conn, userId, componentId, productId, quantityChange) {
  const now = currentDateTime();
  await conn.execute(
      `INSERT INTO stock_movements (user_id, component_id, product_id, quantity_change, change_time)
     VALUES (?, ?, ?, ?, ?)`,
    [userId, componentId, productId, quantityChange, now]
  );
}

module.exports = {
  getAllProducts,
  getProduct,
  createProduct,
  updateProduct,
  deleteProduct,
  produceProduct
};