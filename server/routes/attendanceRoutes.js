const express = require("express");
const attendanceController = require("../controllers/attendanceController");

const router = express.Router();

//Routes
//Add attendance route
router.post("/addattendance", attendanceController.addAttendance);

// //View attendance
// router.get("/viewattendance", attendanceController.viewAttendance);

// //View attendance by id
// router.get("/viewattendancebyid/:id", attendanceController.viewAttendanceById);

// //Update attendance
// router.put("/updateattendance/:id", attendanceController.updateAttendance);

// //Delete attendance
// router.delete("/deleteattendance/:id", attendanceController.deleteAttendance);

//Export module router
module.exports = router;