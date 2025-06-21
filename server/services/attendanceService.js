const attendanceModel = require("../models/attendanceModel");
const enrollmentService = require("../services/enrollmentService");
const { execFile } = require('child_process');
const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

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
        
        throw new Error(error.message);
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

//Register student faces
const registerStudentFaces = async (studentId, imagePath) => {
    try {
        // Wrap execFile in a Promise for better error handling
        const encoding = await new Promise((resolve, reject) => {
            execFile('python', ['face_recognition_module/register_face_encodings.py', imagePath], (err, stdout, stderr) => {
                // Always delete the file after processing
                fs.unlink(imagePath, () => {});
                if (err || stdout.includes('ERROR')) {
                    return reject(new Error('Face encoding failed.'));
                }
                resolve(stdout.trim());
            });
        });

        // Save encoding in DB
        const result = await attendanceModel.registerStudentFaces(studentId, encoding);
        return { success: true, result };
    } catch (error) {
        error.status = error.status || 500;
        throw error;
    }
};


// Verify student faces
const verifyStudentFaces = async (studentId, imagePath, classId) => {
    try {
        console.log("[DEBUG] Verifying face for student:", studentId);
        console.log("[DEBUG] Uploaded imagePath:", imagePath);

        // Get student face encoding from DB
        const studentFaceEncoding = await attendanceModel.getStudentFaceEncoding(studentId);
        const faceVector = studentFaceEncoding[0].face_vector;

        console.log("[DEBUG] Face vector from DB:", faceVector);

        // Call Python script with correct argument order: encoding, then image path
        const result = await new Promise((resolve, reject) => {
            execFile(
                'python',
                ['face_recognition_module/verify_face.py', faceVector, imagePath],
                async (err, stdout, stderr) => {
                    fs.unlink(imagePath, () => {}); // delete image after processing

                    console.log("[Python stdout]:", stdout);
                    if (stderr) console.error("[Python stderr]:", stderr);
                    if (err) console.error("[execFile error]:", err);
                    
                    //If not matched return error
                    if (err || stdout.includes("ERROR") || stdout.includes("not_match")) {
                        return reject(new Error('Face not matched. Please try again.'));
                    }

                    //If matched add student attendance
                    if (stdout.includes("match")) {

                        console.log("[DEBUG] Face matched for student:", studentId);
                        console.log("[DEBUG] Adding attendance for student:", studentId);

                        // Get the current UTC time
                        const currentDate = new Date();

                        // Format the date directly in 'Asia/Kuala_Lumpur' time zone
                        const timeStamp = currentDate.toLocaleString('en-US', {
                            timeZone: 'Asia/Kuala_Lumpur', // This does the UTC+8 conversion
                            year: 'numeric',
                            month: 'long',
                            day: 'numeric',
                            hour: 'numeric',
                            minute: '2-digit',
                            second: '2-digit',
                            hour12: true
                        });

                        const resultsAttendance = await attendanceModel.addAttendance(classId, studentId , "Present" , timeStamp);

                        //If success add student attendance
                        if(resultsAttendance.affectedRows > 0) {
                            console.log("[DEBUG] Attendance added for student:", studentId);

                            //Trigger socket
                            const socketId = global.connectedUsers?.[studentId];
                            if (socketId) {
                                //Debug
                                // console.log("Socket ID:", socketId);
                                // Emit the 'pending_face_verification' event
                                global._io.to(socketId).emit('attendance_verified', {
                                classId,
                                studentId,
                                message: 'Face Verification Successful',
                                });
                            }
                        }
                    }

                    resolve(stdout.trim());
                }
            );
        });

        // console.log("[DEBUG] Final result from Python:", result);
        return { success: true, result };
    } catch (error) {
        error.status = error.status || 500;
        throw error;
    }
};

module.exports = { addAttendance , checkAttendance , generateAttendanceReport , addStudentAttendance , registerStudentFaces , verifyStudentFaces };