const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/Notification/notificationController');

router.get('/:userId', notificationController.getUnreadNotifications);
router.post('/read/:userId', notificationController.markAllAsRead);

//Retrieve all notifications for a user
router.get('/all/:userId', notificationController.getAllNotifications);

//Get unread notification count
router.get('/unreadcount/:userId', notificationController.getUnreadCount);

module.exports = router;
