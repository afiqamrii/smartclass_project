const attendanceModel = require("../models/attendanceModel");

// Function to add a class
const addAttendance = async (attendanceData) => {
    try {
        const { classId, studentId, attendanceStatus } = attendanceData;
        const attendance = await attendanceModel.addAttendance(classId, studentId, attendanceStatus);
        return { success: true, attendance };
    } catch (error) {
        // Pass the error with status for controller to handle
        error.status = error.status || 500;
        throw error;
    }
};

module.exports = { addAttendance };