const express = require('express');
const router = express.Router();
const multer = require('multer');
const upload = multer(); // Use memory storage (or set up diskStorage if you prefer)

// Import controller
const reportController = require('../controllers/reportController');

// Define routes
router.post('/create', upload.single('image'), reportController.submitReport);

module.exports = router;
