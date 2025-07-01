const express = require("express");
const attendanceController = require("../controllers/attendanceController");
const multer = require('multer');
const upload = multer({ dest: 'uploads/' });

const router = express.Router();

//Routes to register student faces
router.post('/register/:studentId', upload.single('image'), attendanceController.registerStudentFaces);

//Routes for 2 Face Verification
router.post('/verify/face/:studentId/:classId', upload.single('image'), attendanceController.verifyStudentFaces);

//Routes
//Add attendance route
router.put("/addattendance", attendanceController.addAttendance);

//Manually add attendance for a student
router.post("/manualattendance", attendanceController.addManualAttendance);

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

//Route to generate attend
//Route to generate attendance report in PDF formatance report
router.get("/generateattendancereport/:classId", attendanceController.generateAttendanceReport);

router.get('/attendance/report/:classId/pdf', attendanceController.generateAttendanceReportPDF);

//Export module router
module.exports = router;