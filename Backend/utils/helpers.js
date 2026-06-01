const query = require('../config/database');

async function fetchAdditionalInfo(tableName, idColumn, id) {
  if (!id || isNaN(Number(id))) {
    console.error(`fetchAdditionalInfo: Invalid id:`, id);
    return [];
  }
  
  try {
    const table = tableName === 'component' ? 'component_additional_info' : 'product_additional_info';
    const column = tableName === 'component' ? 'component_id' : 'product_id';
    
    // Only add is_deleted condition for component_additional_info table
    // product_additional_info table doesn't have is_deleted column
    const whereClause = tableName === 'component' 
      ? `WHERE ${column}=? AND is_deleted=0`
      : `WHERE ${column}=?`;
    
    const rows = await query(`SELECT info FROM ${table} ${whereClause}`, [id]);
    
    if (rows.length === 0) return [];
    
    let info = rows[0].info;
    if (info == null) return [];
    
    // Handle various data formats
    if (Array.isArray(info)) return info;
    
    if (Buffer.isBuffer(info)) {
      info = info.toString('utf8').trim();
    }
    
    if (typeof info === 'string') {
      info = info.trim();
      if (!info) return [];
      try {
        const parsed = JSON.parse(info);
        return Array.isArray(parsed) ? parsed : [];
      } catch {
        return [];
      }
    }
    
    return [];
  } catch (err) {
    console.error(`fetchAdditionalInfo error for ${tableName} id`, id, err);
    return [];
  }
}

async function fetchRequiredComponents(prodId) {
  try {
    const rows = await query(
      `SELECT pc.component_id, pc.quantity_required, c.name, c.stock 
       FROM product_components pc 
       JOIN components c ON pc.component_id = c.id 
       WHERE pc.product_id = ? AND c.is_deleted = 0`,
      [prodId]
    );
    
    return rows.map(row => ({
      component_id: Number(row.component_id),
      quantity_required: Number(row.quantity_required),
      name: row.name,
      stock: Number(row.stock)
    }));
  } catch (err) {
    console.error('fetchRequiredComponents error for prodId', prodId, err);
    return [];
  }
}

const currentDateTime = () => new Date().toISOString().slice(0, 19).replace('T', ' ');

module.exports = {
  fetchAdditionalInfo,
  fetchRequiredComponents,
  currentDateTime
};