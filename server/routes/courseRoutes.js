const express = require("express");
const courseController = require("../controllers/courseController");


const router = express.Router();

//Course
router.get("/viewcourse", courseController.viewCourse); //Get all course

module.exports = router;
