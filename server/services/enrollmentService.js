const enrollmentModel = require("../models/enrollmentModel");

// Function to enroll a student in a course
exports.enrollStudent = async (studentId, courseId) => {
    try {
        return await enrollmentModel.enrollStudent(studentId, courseId);
    } catch (error) {
        // If the error is due to a duplicate entry, throw a specific error
        if (error.status === 409) {
            throw new Error("You have already enrolled in this course. Only one enrollment per course is allowed!");
        }
        throw new Error("Error in service while enrolling student: " + error.message);
    }
};

//+// Function to get all enrollments for a student
exports.getStudentEnrollment = async (studentId) => {
    try {
        return await enrollmentModel.getStudentEnrollment(studentId);
    } catch (error) {
        throw new Error("Error in service while fetching student enrollments: " + error.message);
    }
};

// Function to get enrollments for a course for a lecturer to verify
exports.lecturerGetEnrollment = async (lecturerId, courseId) => {
    try {
        return await enrollmentModel.lecturerGetEnrollment(lecturerId, courseId);
    } catch (error) {
        console.error("Service Error:", error);
        throw new Error("Failed to retrieve enrollment data.");
    }
};


// Function to get all enrollments for a student
exports.getAllEnrollments = async (studentId) => {
    try {
        return await enrollmentModel.getAllEnrollments(studentId);
    } catch (error) {
        throw new Error("Error in service while fetching all enrollments: " + error.message);
    }
};

// Function to update enrollment status
exports.updateEnrollmentStatus = async (enrollmentId, status) => {
    try {
        return await enrollmentModel.updateEnrollmentStatus(enrollmentId, status);
    } catch (error) {
        console.error("Service Error:", error);
        throw new Error("Failed to update enrollment status.");
    }
};
