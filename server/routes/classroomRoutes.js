const express = require("express");
const classroomController = require("../controllers/classroomController");


const router = express.Router();

//CLassroom Routes
router.post("/addclassroom", classroomController.addClassroom); //Add a classroom
router.get("/getclassroom", classroomController.getClassroom); //Get all classroom

module.exports = router;
