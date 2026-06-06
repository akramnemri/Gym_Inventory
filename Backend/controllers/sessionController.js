const query = require('../config/database');

const getSessions = async (req, res) => {
  try {
    const { user_id, is_admin } = req.query;
    
    let sql = `
      SELECT sl.user_id, u.first_name, u.last_name, 
        CONVERT_TZ(sl.login_time, '+00:00', '+01:00') as login_time,
        CONVERT_TZ(sl.logout_time, '+00:00', '+01:00') as logout_time
      FROM session_logs sl
      JOIN users u ON sl.user_id = u.id
    `;
    
    let params = [];
    if (is_admin === 'true') {
      sql += ' ORDER BY sl.login_time DESC LIMIT 100';
    } else if (user_id) {
      sql += ' WHERE sl.user_id=? ORDER BY sl.login_time DESC LIMIT 100';
      params = [user_id];
    } else {
      sql += ' ORDER BY sl.login_time DESC LIMIT 100';
    }
    
    const logs = await query(sql, params);
    
    function getWeekKey(dtStr) {
      try {
        let dt;
        if (typeof dtStr === 'string') {
          dt = new Date(dtStr.includes('T') ? dtStr : dtStr.replace(' ', 'T'));
        } else if (dtStr instanceof Date) {
          dt = dtStr;
        } else {
          throw new Error('Invalid dtStr type');
        }
        const year = dt.getFullYear();
        const month = dt.getMonth() + 1;
        const day = dt.getDate();
        const week = Math.floor((day - dt.getDay() + 10) / 7);
        return `${year}-${month.toString().padStart(2, '0')}-W${week}`;
      } catch (err) {
        console.error('getWeekKey error:', err, 'input:', dtStr);
        return 'unknown-week';
      }
    }
    
    function formatDateTime(dateTime) {
      if (!dateTime) return null;
      try {
        if (typeof dateTime === 'string') {
          return dateTime;
        } else if (dateTime instanceof Date) {
          return dateTime.toISOString().slice(0, 19).replace('T', ' ');
        } else {
          return String(dateTime);
        }
      } catch (err) {
        console.error('formatDateTime error:', err, 'input:', dateTime);
        return null;
      }
    }
    
    const grouped = {};
    
    for (let i = 0; i < logs.length; i++) {
      const log = logs[i];
      const userId = log.user_id;
      const fullName = `${log.first_name} ${log.last_name}`;
      
      const loginTime = formatDateTime(log.login_time);
      let logoutTime = formatDateTime(log.logout_time);
      
      if (!logoutTime || logoutTime === '' || logoutTime === 'null') {
        const isActiveSessions = logs.filter(l => l.user_id === userId && !l.logout_time);
        const timestamps = isActiveSessions.map(l => new Date(l.login_time).getTime()).filter(t => !isNaN(t));
        const mostRecentActiveLogin = timestamps.length > 0 ? Math.max(...timestamps) : 0;
        const currentLoginTime = new Date(log.login_time).getTime();
        
        if (currentLoginTime === mostRecentActiveLogin) {
          logoutTime = '~';
        } else {
          logoutTime = null;
          for (let j = i - 1; j >= 0; j--) {
            if (logs[j].user_id === userId) {
              logoutTime = formatDateTime(logs[j].login_time);
              break;
            }
          }
          
          if (!logoutTime) {
            try {
              const currentTimeResult = await query('SELECT CONVERT_TZ(NOW(), "+00:00", "+01:00") as current_time');
              logoutTime = formatDateTime(currentTimeResult[0].current_time);
            } catch (err) {
              console.error('Error getting current time from database:', err);
              logoutTime = new Date().toISOString().slice(0, 19).replace('T', ' ');
            }
          }
        }
      }
      
      const weekKey = getWeekKey(loginTime);
      let dayKey;
      try {
        if (typeof loginTime === 'string') {
          dayKey = loginTime.slice(0, 10);
        } else if (loginTime instanceof Date) {
          dayKey = loginTime.toISOString().slice(0, 10);
        } else {
          dayKey = String(loginTime).slice(0, 10);
        }
      } catch (err) {
        console.error('dayKey error:', err, 'loginTime:', loginTime);
        dayKey = 'unknown-day';
      }
      
      grouped[weekKey] = grouped[weekKey] || {};
      grouped[weekKey][userId] = grouped[weekKey][userId] || {
        user_id: userId,
        fullName,
        days: {}
      };
      grouped[weekKey][userId].days[dayKey] = grouped[weekKey][userId].days[dayKey] || [];
      grouped[weekKey][userId].days[dayKey].push({
        login: loginTime,
        logout: logoutTime
      });
    }
    
    res.json({
      grouped_sessions: grouped,
      raw_logs: logs
    });
  } catch (err) {
    throw err;
  }
};

const getStockMovements = async (req, res) => {
  try {
    const results = await query(`
      SELECT 
        sm.id, sm.user_id, sm.component_id, sm.product_id, 
        sm.quantity_change, CONVERT_TZ(sm.change_time, '+00:00', '+01:00') as change_time,
        c.name AS component_name, c.reference AS component_reference,
        fp.name AS product_name,
        u.first_name, u.last_name
      FROM stock_movements sm
      LEFT JOIN components c ON sm.component_id = c.id
      LEFT JOIN final_products fp ON sm.product_id = fp.id
      LEFT JOIN users u ON sm.user_id = u.id
      WHERE (c.is_deleted IS NULL OR c.is_deleted = 0)
      AND (fp.is_deleted IS NULL OR fp.is_deleted = 0)
      ORDER BY sm.change_time DESC
      LIMIT 20
    `);
    
    res.json(results.map(row => ({
      id: Number(row.id),
      user_id: Number(row.user_id),
      component_id: row.component_id ? Number(row.component_id) : null,
      product_id: row.product_id ? Number(row.product_id) : null,
      quantity_change: Number(row.quantity_change),
      change_time: row.change_time,
      component_name: row.component_name,
      component_reference: row.component_reference,
      product_name: row.product_name,
      user_name: row.first_name && row.last_name ? `${row.first_name} ${row.last_name}` : 'Unknown'
    })));
  } catch (err) {
    throw err;
  }
};

const getLowStock = async (req, res) => {
  try {
    const threshold = Number(req.query.threshold) || 5;
    
    const results = await query(
      `SELECT c.*, ct.name as type_name 
       FROM components c 
       LEFT JOIN component_types ct ON c.type_id = ct.id 
       WHERE c.stock <= ? AND c.is_deleted = 0
       ORDER BY c.stock ASC`,
      [threshold]
    );
    
    res.json(results.map(row => ({
      ...row,
      id: Number(row.id),
      stock: Number(row.stock)
    })));
  } catch (err) {
    throw err;
  }
};



const getDashboardStatistics = async (req, res) => {
  try {
    const stats = {};

    // Total components count
    const totalComponentsResult = await query(
      'SELECT COUNT(*) as count FROM components WHERE is_deleted = 0'
    );
    stats.totalComponents = Number(totalComponentsResult[0].count) || 0; // Ensure it's a number, default to 0

    // Components by type
    const componentsByType = await query(`
      SELECT ct.name, COUNT(c.id) as count
      FROM component_types ct
      LEFT JOIN components c ON ct.id = c.type_id AND c.is_deleted = 0
      GROUP BY ct.id, ct.name
      ORDER BY count DESC
    `);
    // Ensure 'count' is a number for each entry
    stats.componentsByType = componentsByType.map(item => ({
      ...item,
      count: Number(item.count) || 0
    }));

    // Total products count
    const totalProductsResult = await query(
      'SELECT COUNT(*) as count FROM final_products WHERE is_deleted = 0'
    );
    stats.totalProducts = Number(totalProductsResult[0].count) || 0; // Ensure it's a number, default to 0

    // Low stock components count
    const threshold = 5;
    const lowStockCountResult = await query(
      'SELECT COUNT(*) as count FROM components WHERE stock <= ? AND is_deleted = 0',
      [threshold]
    );
    stats.lowStockCount = Number(lowStockCountResult[0].count) || 0; // Ensure it's a number, default to 0

    // Active sessions count (FIXED: now only checking for NULL logout_time)
    const activeSessionsResult = await query(`
      SELECT COUNT(*) as count FROM session_logs
      WHERE logout_time IS NULL
    `);
    stats.activeSessions = Number(activeSessionsResult[0].count) || 0; // Ensure it's a number, default to 0

    // Recent stock movements count
    const recentMovementsResult = await query(
      'SELECT COUNT(*) as count FROM stock_movements WHERE DATE(change_time) = CURDATE()'
    );
    stats.recentMovements = Number(recentMovementsResult[0].count) || 0; // Ensure it's a number, default to 0

    // Most frequently low stock component
    const frequentLowStock = await query(`
      SELECT c.name, c.id, c.stock
      FROM components c
      WHERE c.stock <= ? AND c.is_deleted = 0
      ORDER BY c.stock ASC
      LIMIT 1
    `, [threshold]);
    // Ensure 'stock' is a number if the item exists
    stats.frequentLowStock = frequentLowStock[0] ? {
      ...frequentLowStock[0],
      stock: Number(frequentLowStock[0].stock) || 0
    } : null;

    res.json(stats);
  } catch (err) {
    throw err;
  }
};


// NEW: Production statistics
const getProductionStatistics = async (req, res) => {
  try {
    const period = req.query.period || 'month';
    
    let dateFilter = '';
    switch(period) {
      case '3months':
        dateFilter = 'AND sm.change_time >= DATE_SUB(NOW(), INTERVAL 3 MONTH)';
        break;
      case '6months':
        dateFilter = 'AND sm.change_time >= DATE_SUB(NOW(), INTERVAL 6 MONTH)';
        break;
      case 'year':
        dateFilter = 'AND sm.change_time >= DATE_SUB(NOW(), INTERVAL 1 YEAR)';
        break;
      default: // month
        dateFilter = 'AND sm.change_time >= DATE_SUB(NOW(), INTERVAL 1 MONTH)';
    }

    // Products produced (positive stock movements for products)
    const productsProduced = await query(`
      SELECT fp.name, fp.id, SUM(sm.quantity_change) as total_produced
      FROM stock_movements sm
      JOIN final_products fp ON sm.product_id = fp.id
      WHERE sm.quantity_change > 0 AND fp.is_deleted = 0 ${dateFilter}
      GROUP BY fp.id, fp.name
      ORDER BY total_produced DESC
    `);

    // Monthly production trends
    const monthlyTrends = await query(`
      SELECT 
        DATE_FORMAT(sm.change_time, '%Y-%m') as month,
        SUM(sm.quantity_change) as total_produced
      FROM stock_movements sm
      JOIN final_products fp ON sm.product_id = fp.id
      WHERE sm.product_id IS NOT NULL 
        AND sm.quantity_change > 0
        AND fp.is_deleted = 0
        AND sm.change_time >= DATE_SUB(NOW(), INTERVAL 12 MONTH)
      GROUP BY DATE_FORMAT(sm.change_time, '%Y-%m')
      ORDER BY month DESC
    `);

    // All-time most produced product
    const allTimeMost = await query(`
      SELECT fp.name, fp.id, SUM(sm.quantity_change) as total_produced
      FROM stock_movements sm
      JOIN final_products fp ON sm.product_id = fp.id
      WHERE sm.quantity_change > 0 AND fp.is_deleted = 0
      GROUP BY fp.id, fp.name
      ORDER BY total_produced DESC
      LIMIT 1
    `);

    res.json({
      period,
      productsProduced: productsProduced.slice(0, 10), // Top 10
      leastProduced: productsProduced.slice(-10).reverse(), // Bottom 10
      monthlyTrends,
      allTimeMost: allTimeMost[0] || null
    });
  } catch (err) {
    throw err;
  }
};


// NEW: User activity statistics
const getUserActivityStatistics = async (req, res) => {
  try {
    const activeUsers = await query(`
      SELECT
        u.username, u.first_name, u.last_name, u.id, u.profile_picture,
        COUNT(sl.id) as session_count,
        AVG(
          CASE
            WHEN sl.logout_time IS NOT NULL
            THEN TIMESTAMPDIFF(MINUTE, sl.login_time, sl.logout_time)
            ELSE NULL
          END
        ) as avg_session_minutes
      FROM users u
      LEFT JOIN session_logs sl ON u.id = sl.user_id
      WHERE sl.login_time >= DATE_SUB(NOW(), INTERVAL 30 DAY)
      GROUP BY u.id, u.username, u.first_name, u.last_name, u.profile_picture
      ORDER BY session_count DESC, avg_session_minutes DESC
      LIMIT 3
    `);

    // Explicitly convert session_count and avg_session_minutes to numbers or null
    const processedActiveUsers = activeUsers.map(user => ({
      ...user,
      session_count: Number(user.session_count) || 0, // Ensure it's a number
      avg_session_minutes: user.avg_session_minutes != null // If it's not null, convert to number
        ? Number(user.avg_session_minutes)
        : null // Otherwise, keep it null
    }));

    res.json({ activeUsers: processedActiveUsers });
  } catch (err) {
    throw err;
  }
};


// NEW: Stock evolution over time
const getStockEvolution = async (req, res) => {
  try {
    const days = parseInt(req.query.days) || 30;
    
    const stockEvolution = await query(`
      SELECT 
        DATE(sm.change_time) as date,
        ct.name as type_name,
        SUM(sm.quantity_change) as net_change,
        COUNT(*) as movement_count
      FROM stock_movements sm
      JOIN components c ON sm.component_id = c.id
      JOIN component_types ct ON c.type_id = ct.id
      WHERE sm.change_time >= DATE_SUB(NOW(), INTERVAL ? DAY)
        AND sm.component_id IS NOT NULL
        AND c.is_deleted = 0
      GROUP BY DATE(sm.change_time), ct.id, ct.name
      ORDER BY date DESC, ct.name
    `, [days]);

    res.json({ stockEvolution, days });
  } catch (err) {
    throw err;
  }
};

module.exports = {
  getSessions,
  getStockMovements,
  getLowStock,
  getDashboardStatistics,
  getProductionStatistics,
  getUserActivityStatistics,
  getStockEvolution
};