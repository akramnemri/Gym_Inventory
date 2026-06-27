const fs = require('fs');
const path = require('path');
const query = require('../config/database');
const { fetchAdditionalInfo } = require('../utils/helpers');
const { createStockMovement } = require('../utils/stockTracker');
const { uploadDir } = require('../middleware/upload');

const getAllComponents = async (req, res) => {
  try {
    const typeId = req.query.type_id;
    let sql = `SELECT c.*, ct.name AS type_name 
               FROM components c 
               JOIN component_types ct ON c.type_id=ct.id 
               WHERE c.is_deleted=0`;
    const params = [];
    
    if (typeId) {
      sql += ` AND ct.id=?`;
      params.push(Number(typeId));
    }
    
    const results = await query(sql, params);
    
    for (let comp of results) {
      comp.id = Number(comp.id);
      comp.additional_info = await fetchAdditionalInfo('component', 'component_id', comp.id);
    }
    
    res.json(results);
  } catch (err) {
    throw err;
  }
};

const getComponent = async (req, res) => {
  try {
    const compId = Number(req.params.id);
    
    if (isNaN(compId)) {
      return res.status(400).json({ message: 'Invalid component ID' });
    }
    
    const componentRows = await query(
      `SELECT c.*, ct.name AS type_name 
       FROM components c 
       JOIN component_types ct ON c.type_id=ct.id 
       WHERE c.id=? AND c.is_deleted=0`,
      [compId]
    );
    
    const component = componentRows[0];
    if (!component) {
      return res.status(404).json({ message: 'Component not found' });
    }
    
    component.id = Number(component.id);
    component.additional_info = await fetchAdditionalInfo('component', 'component_id', component.id);
    
    res.json(component);
  } catch (err) {
    throw err;
  }
};

const createComponent = async (req, res) => {
  try {
    const { name, type_id, length, weight, stock, description, dimensions, height, diameter, reference, additional_info } = req.body;
    
    if (!name || name.trim() === '') {
      return res.status(400).json({ message: 'Name is required' });
    }
    
    if (!type_id || isNaN(Number(type_id))) {
      return res.status(400).json({ message: 'Valid type is required' });
    }
    
    const image_path = req.file ? req.file.filename : null;
    
    const result = await query(
      `INSERT INTO components (name, type_id, length, weight, stock, description, dimensions, height, diameter, reference, image_path) 
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [name, Number(type_id), length || 0, weight || 0, stock || 0, description || '', dimensions || '', height || 0, diameter || 0, reference || '', image_path]
    );
    
    if (result.insertId) {
      let parsedInfo = [];
      if (additional_info) {
        try {
          parsedInfo = Array.isArray(additional_info) ? additional_info : JSON.parse(additional_info);
        } catch (err) {
          console.error('Failed to parse additional_info:', additional_info, err);
        }
      }
      
      await query(
        `INSERT INTO component_additional_info (component_id, info) VALUES (?, ?)`,
        [result.insertId, JSON.stringify(parsedInfo)]
      );
    }
    
    const newCompRows = await query(
      `SELECT c.*, ct.name AS type_name 
       FROM components c 
       JOIN component_types ct ON c.type_id=ct.id 
       WHERE c.id=?`,
      [result.insertId]
    );
    
    const newComp = newCompRows[0];
    newComp.id = Number(newComp.id);
    newComp.additional_info = await fetchAdditionalInfo('component', 'component_id', newComp.id);
    
    res.json(newComp);
  } catch (err) {
    throw err;
  }
};

const updateComponent = async (req, res) => {
  try {
    const compId = Number(req.params.id);
    
    if (isNaN(compId) || compId <= 0) {
      return res.status(400).json({ message: 'Invalid component ID' });
    }
    
    const { name, type_id, length, weight, stock, description, dimensions, height, diameter, reference, additional_info, remove_image } = req.body;
    const userId = req.user.id;
    
    if (!name || name.trim() === '') {
      return res.status(400).json({ message: 'Name is required' });
    }
    
    if (!type_id || isNaN(Number(type_id))) {
      return res.status(400).json({ message: 'Valid type is required' });
    }
    
    const currentCompRows = await query(
      `SELECT image_path, stock FROM components WHERE id=? AND is_deleted=0`,
      [compId]
    );
    
    const currentComp = currentCompRows[0];
    if (!currentComp) {
      return res.status(404).json({ message: 'Component not found' });
    }
    
    const oldStock = currentComp.stock || 0;
    const newStock = Number(stock) || 0;
    
    let finalImage = currentComp.image_path;
    
    if (req.file) {
      if (currentComp.image_path) {
        const oldPath = path.join(uploadDir, currentComp.image_path);
        if (fs.existsSync(oldPath)) fs.unlinkSync(oldPath);
      }
      finalImage = req.file.filename;
    } else if (remove_image === 'true') {
      if (currentComp.image_path) {
        const oldPath = path.join(uploadDir, currentComp.image_path);
        if (fs.existsSync(oldPath)) fs.unlinkSync(oldPath);
      }
      finalImage = null;
    }
    
    await query(
      `UPDATE components SET name=?, type_id=?, length=?, weight=?, stock=?, description=?, dimensions=?, height=?, diameter=?, reference=?, image_path=? 
       WHERE id=?`,
      [name, Number(type_id), length || 0, weight || 0, newStock, description || '', dimensions || '', height || 0, diameter || 0, reference || '', finalImage, compId]
    );
    
    if (oldStock !== newStock) {
      const quantityChange = newStock - oldStock;
      await createStockMovement(userId, compId, null, quantityChange);
    }
    
    let parsedInfo = [];
    if (additional_info) {
      try {
        parsedInfo = Array.isArray(additional_info) ? additional_info : JSON.parse(additional_info);
      } catch (err) {
        console.error('Failed to parse additional_info:', additional_info, err);
      }
    }
    
    const existingRows = await query(
      `SELECT id FROM component_additional_info WHERE component_id=? AND is_deleted=0`,
      [compId]
    );
    
    if (existingRows.length > 0) {
      await query(
        `UPDATE component_additional_info SET info=? WHERE component_id=?`,
        [JSON.stringify(parsedInfo), compId]
      );
    } else {
      await query(
        `INSERT INTO component_additional_info (component_id, info) VALUES (?, ?)`,
        [compId, JSON.stringify(parsedInfo)]
      );
    }
    
    const updatedCompRows = await query(
      `SELECT c.*, ct.name AS type_name 
       FROM components c 
       JOIN component_types ct ON c.type_id=ct.id 
       WHERE c.id=?`,
      [compId]
    );
    
    const updatedComp = updatedCompRows[0];
    updatedComp.id = Number(updatedComp.id);
    updatedComp.additional_info = await fetchAdditionalInfo('component', 'component_id', updatedComp.id);
    
    res.json(updatedComp);
  } catch (err) {
    throw err;
  }
};

const deleteComponent = async (req, res) => {
  try {
    const compId = Number(req.params.id);
    
    if (isNaN(compId)) {
      return res.status(400).json({ message: 'Invalid component ID' });
    }
    
    const result = await query('UPDATE components SET is_deleted=1 WHERE id=?', [compId]);
    
    if ((result.affectedRows ?? 0) === 0) {
      return res.status(404).json({ message: 'Component not found' });
    }
    
    res.json({ message: 'Component soft deleted' });
  } catch (err) {
    throw err;
  }
};

module.exports = {
  getAllComponents,
  getComponent,
  createComponent,
  updateComponent,
  deleteComponent
};