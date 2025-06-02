const enrollmentService = require("../services/enrollmentService");
const NotificationService = require('../services/Notifications/notificationsService');

const enrollStudent = async (req, res) => {
    try {
        const {courseId ,studentId , lecturerId} = req.body;
        
        // Log the received request for debugging
        console.log("Received enroll student request:", { courseId, studentId });
        
        // Validate input
        if (!courseId || !studentId) {
            return res.status(400).json({ error: "Course ID and Student ID are required" });
        }
        const result = await enrollmentService.enrollStudent(studentId, courseId);

        // Step 2 : Store notification in database (via notification service) for student
        await NotificationService.createNotification(
            studentId, // Assuming studentId is the user ID to notify
            'Enrollment Successful',
            'You have successfully enrolled in the course.',
            `CourseEnrollment`,
            courseId, 
        );

        // Emit notification count update to the student
        const studentCount = await NotificationService.getUnreadCount(studentId);

        if (global._io) {
            global._io.emit('new_notification_count_student', { count: studentCount }); // general broadcast
        }

        // Emit real-time notification to the student
        const studentSocketId = global.connectedUsers?.[studentId];
        if (studentSocketId) {
            global._io.to(studentSocketId).emit('new_notification', {
            type: 'enrollment',
            message: 'You have successfully enrolled in the course.',
            });
        }

        // Step 3: Store notification in DB for the lecturer
        await NotificationService.createNotification(
            lecturerId,
            'New Enrollment Request',
            `A student has requested to enroll in your course (Course ID: ${courseId}).`,
            'EnrollmentRequest',
            courseId
        );

        // Step 4: Emit notification count update to the lecturer
        const count = await NotificationService.getUnreadCount(lecturerId);

        // Print notification count for debugging
        // console.log("Sini")
        // console.log('Notification count for lecturer:', count);
        // console.log('Connected users:', global.connectedUsers);
        // console.log('Lecturer ID for notification:', lecturerId);


        if (global._io) {
        global._io.emit('new_notification_count_lecturer', { count }); // general broadcast

        const socketId = global.connectedUsers?.[lecturerId];
        if (socketId) {
            global._io.to(socketId).emit('new_enrollment_request', {
            courseId,
            studentId,
            message: 'A student has requested to enroll in your course.',
            });

            global._io.to(socketId).emit('new_notification', {
            type: 'enrollment',
            message: `New enrollment request for your course ID ${courseId}`,
            });
        }
        }

        return res.status(200).json({ message: "Enrollment request submitted", result });
    } catch (error) {
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

//Lecturer get all enrollments to verify
const lecturerGetEnrollment = async (req, res) => {
    try {
        const lecturerId = req.params.lecturerId;

        // Log the received request for debugging
        console.log("Received get all enrollments request:", { lecturerId });

        // Validate input
        if (!lecturerId ) {
            console.error("Error: Lecturer ID is required");
            return res.status(400).json({ error: "Lecturer ID is required" });
        }

        //Pass the lecturerId to the service
        const result = await enrollmentService.lecturerGetEnrollment(lecturerId);
        if (!result || result.length === 0) {
            return res.status(404).json({ message: "No enrollments found for this course" });
        }
        res.status(200).json({ message: "Enrollment data fetched successfully", result });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ error: error.message });
    }
}

module.exports = { enrollStudent , getStudentEnrollment , getAllEnrollment, lecturerGetEnrollment };

