const query = require('../config/database');

async function createStockMovement(userId, componentId, productId, quantityChange) {
  try {
    await query(
      `INSERT INTO stock_movements (user_id, component_id, product_id, quantity_change, change_time) 
       VALUES (?, ?, ?, ?, NOW())`,
      [userId, componentId, productId, quantityChange]
    );
    
    console.log(`Stock movement created: User ${userId}, Component ${componentId}, Product ${productId}, Change ${quantityChange}`);
  } catch (err) {
    console.error('Error creating stock movement:', err);
    throw err;
  }
}

module.exports = { createStockMovement };