const express = require("express");
const classroomController = require("../controllers/classroomController");


const router = express.Router();

//CLassroom Routes
router.post("/addclassroom", classroomController.addClassroom); //Add a classroom
router.get("/getclassroom", classroomController.getClassroom); //Get all classroom

//Get classroom develop id and esp32 id for spesific esp32 id (esp32 subsystem to control utility)
router.get("/getgroupid/:esp32Id", classroomController.getClassroomByEsp32Id); //Get classroom by esp32 id

module.exports = router;
