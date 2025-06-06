const attendanceModel = require("../models/attendanceModel");
const enrollmentService = require("../services/enrollmentService");

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

// Function to add student attendance for all enrolled students after lecturer creates class
const addStudentAttendance = async (classId, courseId) => {
    try {
        // Get all students enrolled in this course
        const enrolledStudents = await enrollmentService.getAllEnrollment(courseId);
        console.log("Enrolled students:", enrolledStudents);

        // Add attendance for each student
        const attendancePromises = enrolledStudents.map(student =>
            attendanceModel.addStudentAttendance(classId, student.student_id)
            .then(result => {
                console.log("Attendance added for student:", student.student_id);
                return result;
            })
        );
        const attendanceResults = await Promise.all(attendancePromises);

        //Debug purpose
        console.log(attendanceResults);

        return { success: true, attendance: attendanceResults };
    } catch (error) {
        error.status = error.status || 500;
        throw error;
    }
}

module.exports = { addAttendance , checkAttendance , generateAttendanceReport , addStudentAttendance };