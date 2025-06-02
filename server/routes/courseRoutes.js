const express = require("express");
const courseController = require("../controllers/courseController");


const router = express.Router();

//Course
// POST API to add a course
router.post("/addcourse", courseController.addCourse); //Add a course
router.get("/viewcourse", courseController.viewCourse); //Get all course

//Get course by lecturer ID
router.get("/viewcourse/:lecturerId", courseController.getCourseByLecturerId); //Get course by lecturer ID

module.exports = router;
