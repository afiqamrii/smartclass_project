const express = require("express");
const classController = require("../controllers/classController");
// const summarizationController = require("../controllers/summarizationController");


const router = express.Router();

router.post("/addclass", classController.addClass); // Add a class
router.get("/viewclass", classController.viewClass); // View all classes 
router.get("/viewclassbyid/:id", classController.viewClassById); // View a class by id
router.get("/studentviewclass", classController.studentViewTodayClass); // View all today classes student
router.get("/viewupcomingclass", classController.viewUpcomingClass); // View all today classes lecturer
router.get("/viewcurrentclass", classController.viewCurrentClass); // View all today classes lecturer
router.get("/viewpastclass", classController.viewPastClass); // View all today classes lecturer
router.put("/updateclass/:id", classController.updateClass); // Update a class
router.delete("/deleteclass/:id", classController.deleteClass);

module.exports = router;
