const NotificationModel = require('../../models/Notifications/notificationsModel');

const NotificationService = {

  //Get all notifications for a user
  getAllNotifications: async (userId) => {
    try {
      return await NotificationModel.getAllByUserId(userId);
    } catch (error) {
      throw new Error('Failed to fetch all notifications');
    }
  },

  // Create new notification
  createNotification: async (userId, title, message, type , related_id) => {
    try {
      const id = await NotificationModel.create({ userId, title, message, type, related_id });
      return id;
    } catch (error) {
      throw new Error('Failed to create notification');
    }
  },

  // Get unread notifications by user
  getUnreadNotifications: async (userId) => {
    try {
      return await NotificationModel.getUnreadByUserId(userId);
    } catch (error) {
      throw new Error('Failed to fetch unread notifications');
    }
  },

  // Mark all notifications as read
  markAllAsRead: async (userId) => {
    try {
      await NotificationModel.markAllAsRead(userId);
    } catch (error) {
      throw new Error('Failed to mark all notifications as read');
    }
  },

  //get unread count
  getUnreadCount: async (userId) => {
    try {
      console.log(userId);
      return await NotificationModel.getUnreadCountByUserId(userId);
    } catch (error) {
      throw new Error('Failed to fetch unread count');
    }
  }
};

module.exports = NotificationService;

