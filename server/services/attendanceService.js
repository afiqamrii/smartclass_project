const attendanceModel = require("../models/attendanceModel");

// Function to add a class
const addAttendance = async (attendanceData) => {
    try {
        const { classId, studentId, attendanceStatus , timeStamp } = attendanceData;
        const attendance = await attendanceModel.addAttendance(classId, studentId, attendanceStatus , timeStamp);
        return { success: true, attendance };
    } catch (error) {
        // Pass the error with status for controller to handle
        error.status = error.status || 500;
        throw error;
    }
};

//Check attendance
const checkAttendance = async (checkAttendance) => {
    try {
        const { classId, studentId } = checkAttendance;
        const attendanceStatus = await attendanceModel.checkAttendance(classId, studentId);
        return { success: true, attendanceStatus };
    } catch (error) {
        throw new Error("Error in service while checking attendance: " + error.message);
    }
};

// Function to generate attendance report
const generateAttendanceReport = async (classId) => {
    try {
        const report = await attendanceModel.generateAttendanceReport(classId);
        return report;
    } catch (error) {
        throw new Error("Error in service while generating attendance report: " + error.message);
    }
};

module.exports = { addAttendance , checkAttendance , generateAttendanceReport };