const db = require("../../config/database").pool;

const NotificationModel = {
  
  //Get all notifications for a user
  getAllByUserId: async (userId) => {
    try {
      const [rows] = await db.execute(
        'SELECT * FROM Notifications WHERE userId = ? ORDER BY created_at DESC',
        [userId]
      );
      return rows;
    } catch (error) {
      console.error('Error fetching all notifications for user:', error);
      throw new Error('Failed to fetch all notifications for user');
    }
  },


  // Create new notification
  create: async ({ userId, title, message, type, related_id}) => {
    try {
      const date = new Date();
      const offsetMs = 8 * 60 * 60 * 1000; // 8 hours offset
      const localDate = new Date(date.getTime() + offsetMs);

      const formattedDate = localDate.toISOString().split('T')[0];
      const formattedTime = localDate.toISOString().split('T')[1].split('.')[0];
      const timeStamp = `${formattedDate} ${formattedTime}`;

      const [result] = await db.execute(
        'INSERT INTO Notifications (userId, title, message, type, created_at , related_id) VALUES (?, ?, ?, ? , ? , ?)',
        [userId, title, message, type, timeStamp , related_id]
      );
      return result.insertId;
    } catch (error) {
      console.error('Error creating new notification:', error);
      throw new Error('Failed to create new notification');
    }
  },

  // Get unread notifications by user
  getUnreadByUserId: async (userId) => {
    try {
      const [rows] = await db.execute(
        'SELECT * FROM Notifications WHERE userId = ? AND is_read = FALSE ORDER BY created_at DESC',
        [userId]
      );
      return rows;
    } catch (error) {
      console.error('Error fetching unread notifications for user:', error);
      throw new Error('Failed to fetch unread notifications for user');
    }
  },

  // Get unread notification count by user
  getUnreadCountByUserId: async (userId) => {
    try {
      const [rows] = await db.execute(
        `SELECT COUNT(*) AS unreadCount FROM Notifications WHERE userId = ? AND is_read = 'Unread'`,
        [userId]
      );
      return rows[0].unreadCount;
    } catch (error) {
      console.error('Error fetching unread notification count for user:', error);
      throw new Error('Failed to fetch unread notification count for user');
    }
  },

  // Mark all notifications as read
  markAllAsRead: async (userId) => {
    try {
      await db.execute(
        'UPDATE Notifications SET is_read = "Read" WHERE userId = ?',
        [userId]
      );
    } catch (error) {
      console.error('Error marking all notifications as read:', error);
      throw new Error('Failed to mark all notifications as read');
    }
  }
};

module.exports = NotificationModel;

