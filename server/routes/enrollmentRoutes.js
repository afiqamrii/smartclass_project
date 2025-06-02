const express = require("express");
const enrollmentController = require("../controllers/enrollmentController");
const router = express.Router();

// Enrollment Routes
// POST API to enroll a student in a course
router.post("/course", enrollmentController.enrollStudent); //Enroll a student

//GET API for student enrollment not verified
router.get("/getenrollment/:studentId", enrollmentController.getStudentEnrollment); 

//Get all enrollments for a student
router.get("/allenrollment/:studentId", enrollmentController.getAllEnrollment); //Get all enrollments for a student

//Get enrollments for a course for a lecturer to verify
router.get("/courseenrollment/:lecturerId/:courseId", enrollmentController.lecturerGetEnrollment); //Get enrollments for a course for a lecturer to verify 

module.exports = router;