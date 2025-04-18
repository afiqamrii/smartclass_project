const attendanceService = require("../services/attendanceService");

exports.addAttendance = async (req, res) => {
    try {
        const addAttendance = req.body;
        console.log("Received add attendance request:", addAttendance);

        const result = await attendanceService.addAttendance(addAttendance);
        res.status(200).json({ Status_Code: 200, message: "Class Add Attendance successfully", classId: result.classId });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(400).json({ message: error.message });
    }
};