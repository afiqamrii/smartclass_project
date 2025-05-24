const NotificationService = require('../../services/Notifications/notificationsService');

const getUnreadNotifications = async (req, res) => {
  try {
    const userId = req.params.userId;
    const notifications = await NotificationService.getUnreadNotifications(userId);
    res.status(200).json(notifications);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const markAllAsRead = async (req, res) => {
  try {
    const userId = req.params.userId;
    await NotificationService.markAllAsRead(userId);
    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

//Get unread notification count
const getUnreadCount = async (req, res) => {
  try {
    const userId = req.params.userId;
    const count = await NotificationService.getUnreadCount(userId);
    res.json({ count });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  getUnreadNotifications,
  markAllAsRead,
  getUnreadCount,
};
