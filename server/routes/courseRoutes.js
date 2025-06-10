const express = require("express");
const courseController = require("../controllers/courseController");


const router = express.Router();

//Course
// POST API to add a course
router.post("/addcourse", courseController.addCourse); //Add a course
router.get("/viewcourse", courseController.viewCourse); //Get all course

//Edit course
router.put("/editcourse/:courseId", courseController.editCourse);

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
