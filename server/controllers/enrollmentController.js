const enrollmentService = require("../services/enrollmentService");

const enrollStudent = async (req, res) => {
    try {
        const { courseId ,studentId} = req.body;
        
        // Log the received request for debugging
        console.log("Received enroll student request:", { courseId, studentId });
        
        // Validate input
        if (!courseId || !studentId) {
            return res.status(400).json({ error: "Course ID and Student ID are required" });
        }
        const result = await enrollmentService.enrollStudent(studentId, courseId);
        res.status(200).json({ message: "Enrollment successful", result });
    } catch (error) {
        //If error cause of duplicate entry, return error message to the controller
        if (error.status === 409) {
            return res.status(409).json({ error: error.message });
        }
        console.error("Controller Error:", error);
        res.status(500).json({ error: error.message });
    }
};

//Get all enrollments that not been verified yet
const getStudentEnrollment = async (req, res) => {
    try {
        const studentId = req.params.studentId;

        // Validate input
        if (!studentId) {
            return res.status(400).json({ error: "Student ID is required" });
        }

        //Pass the studentId to the service
        const result = await enrollmentService.getStudentEnrollment(studentId);
        res.status(200).json({ message: "Enrollment data fetched successfully", result });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ error: error.message });
    }
};

//Get all enrollments
const getAllEnrollment = async (req, res) => {
    try {
        //Get parameters from request
        const student_id = req.params.studentId ;

        // Log the received request for debugging
        console.log("Received get all enrollments request:", { student_id });

        // Validate input
        if (!student_id || student_id.trim() === "") {
            console.error("Error: Student ID is required");
            return res.status(400).json({ error: "Student ID is required" });
        }
        // Call service to retrieve all enrollments
        const enrollments = await enrollmentService.getAllEnrollments(student_id);
        res.status(200).json({
            message: "All enrollments fetched successfully",
            Data: enrollments ?? [],
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch all enrollments" });
    }
};

module.exports = { enrollStudent , getStudentEnrollment , getAllEnrollment };

