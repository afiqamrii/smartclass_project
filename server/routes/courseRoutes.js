const express = require("express");
const courseController = require("../controllers/courseController");


const router = express.Router();

//Course
// POST API to add a course
router.post("/addcourse", courseController.addCourse); //Add a course
router.get("/viewcourse", courseController.viewCourse); //Get all course

//Lecturer get courses that are assigned to them 
router.get("/lecturer/viewcourses/:lecturerId", courseController.lecturerViewCourses);

//Student view courses
router.get("/student/viewcourses/:studentId", courseController.studentViewCourses); //Get all courses for students

//Edit course
router.put("/editcourse/:courseId", courseController.editCourse);

//Get all assigned lecturers
router.get("/getassignedlecturers/:courseId", courseController.getAssignedLecturers); //Get all assigned

//Get all lecturers to assign course
router.get("/getlecturers/:courseId", courseController.getLecturers); //Get all lecturers

//Assign course to lecturer
router.post("/assigncourse", courseController.assignCourse); //Assign course to lecturer

//Get course by lecturer ID
router.get("/viewcourse/:lecturerId", courseController.getCourseByLecturerId); //Get course by lecturer 

//Soft delete
router.put("/softdelete/:courseId", courseController.softDeleteCourse);

//Get deleted course
router.get("/getdeletedcourse", courseController.getDeletedCourse);

//Restore deleted course
router.put("/restorecourse/:courseId", courseController.restoreCourse);

//Completely delete course
router.delete("/delete/:courseId", courseController.deleteCourse);

module.exports = router;
