const express = require("express");
const classroomController = require("../controllers/classroomController");


const router = express.Router();

//Course
router.get("/getclassroom", classroomController.getClassroom); //Get all classroom

module.exports = router;
