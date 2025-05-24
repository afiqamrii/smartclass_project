const NotificationModel = require('../../models/Notifications/notificationsModel');

const NotificationService = {
  createNotification: async (userId, type, message) => {
    const id = await NotificationModel.create({ userId, type, message });
    return id;
  },

  getUnreadNotifications: async (userId) => {
    return await NotificationModel.getUnreadByUserId(userId);
  },

  markAllAsRead: async (userId) => {
    await NotificationModel.markAllAsRead(userId);
  },

  //get unread count
  getUnreadCount: async (userId) => {
    console.log(userId);
    return await NotificationModel.getUnreadCountByUserId(userId);
  }
};

module.exports = NotificationService;
