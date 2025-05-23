const express = require('express');
const router = express.Router();
const multer = require('multer');
const upload = multer(); // Use memory storage (or set up diskStorage if you prefer)

// Import controller
const reportController = require('../controllers/reportController');

// Define routes
router.post('/create', upload.single('image'), reportController.submitReport);
router.get('/getreport', reportController.getReport); // Get all reports
router.get('/getreport/:id', reportController.getReportById); // Get report by ID
router.put('/updatereportstatus/:id/:userId', reportController.updateReportStatus); // Update report by 
router.post('/updatereport/:id', upload.single('image'), reportController.updateReport); // Update report by ID
router.put('/updatereport/withoutimage/:id', reportController.updateReportWithoutImage); // Update report by ID

//Report Notification
router.get('/newReportsCount', reportController.getNewReportCount);
router.put('/markReportsAsRead', reportController.markAsRead);

//Student View Their Report
router.get('/getreportbyuser/:userId', reportController.getReportByUserId); // Get report by user ID

module.exports = router;
