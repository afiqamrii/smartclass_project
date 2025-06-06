const express = require("express");
const attendanceController = require("../controllers/attendanceController");

const router = express.Router();

//Routes
//Add attendance route
router.put("/addattendance", attendanceController.addAttendance);

//Check student attendance
router.get("/checkattendance/:classId/:studentId", attendanceController.checkAttendance);

// //View attendance
// router.get("/viewattendance", attendanceController.viewAttendance);

// //View attendance by id
// router.get("/viewattendancebyid/:id", attendanceController.viewAttendanceById);

// //Update attendance
// router.put("/updateattendance/:id", attendanceController.updateAttendance);

// //Delete attendance
// router.delete("/deleteattendance/:id", attendanceController.deleteAttendance);

//Route to generate attendance report
router.get("/generateattendancereport/:classId", attendanceController.generateAttendanceReport);

//Route to generate attendance report in PDF format
router.get('/attendance/report/:classId/pdf', attendanceController.generateAttendanceReportPDF);

//Export module router
module.exports = router;