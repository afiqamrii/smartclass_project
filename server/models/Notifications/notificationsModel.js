const db = require("../../config/database").pool;

const NotificationModel = {
  // Create new notification
  create: async ({ userId, type, message }) => {
    const date = new Date();
    const offsetMs = 8 * 60 * 60 * 1000; // 8 hours offset
    const localDate = new Date(date.getTime() + offsetMs);

    const formattedDate = localDate.toISOString().split('T')[0];
    const formattedTime = localDate.toISOString().split('T')[1].split('.')[0];
    const timeStamp = `${formattedDate} ${formattedTime}`;

    const [result] = await db.execute(
      'INSERT INTO Notifications (userId, type, message, created_at) VALUES (?, ?, ?, ?)',
      [userId, type, message, timeStamp]
    );
    return result.insertId;
  },

  // Get unread notifications by user
  getUnreadByUserId: async (userId) => {
    const [rows] = await db.execute(
      'SELECT * FROM Notifications WHERE userId = ? AND is_read = FALSE ORDER BY created_at DESC',
      [userId]
    );
    return rows;
  },

  // Get unread notification count by user
  getUnreadCountByUserId: async (userId) => {
    const [rows] = await db.execute(
      `SELECT COUNT(*) AS unreadCount FROM Notifications WHERE userId = ? AND is_read = 'Unread'`,
      [userId]
    );
    return rows[0].unreadCount;
  },

  // Mark all notifications as read
  markAllAsRead: async (userId) => {
    await db.execute(
      'UPDATE Notifications SET is_read = "Read" WHERE userId = ?',
      [userId]
    );
  }
};

module.exports = NotificationModel;
