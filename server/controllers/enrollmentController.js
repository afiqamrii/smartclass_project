
const enrollmentService = require('../services/enrollmentService');
const NotificationService = require('../services/Notifications/notificationsService');

const enrollStudent = async (req, res) => {
    try {
        const {courseId ,studentId , lecturerId} = req.body;
        const studentEmail = req.body.studentEmail; 
        const lecturerEmail = req.body.lecturerEmail;
        const courseName = req.body.courseName;
        

        
        // Log the received request for debugging
        console.log("Received enroll student request:", { courseId, studentId, lecturerId, studentEmail, lecturerEmail , courseName });
        
        // Validate input
        if (!courseId || !studentId) {
            return res.status(400).json({ error: "Course ID and Student ID are required" });
        }
        const result = await enrollmentService.enrollStudent(studentId, courseId, studentEmail, lecturerEmail, courseName, lecturerId);

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
        const courseId = req.params.courseId;

        console.log("Received get all enrollments request:", { lecturerId , courseId });

        if (!lecturerId || !courseId || lecturerId.trim() === "" || courseId.trim() === "") {
            console.warn("Missing lecturerId or courseId");
            return res.status(400).json({ error: "Lecturer ID and Course ID are required." });
        }

        const result = await enrollmentService.lecturerGetEnrollment(lecturerId, courseId);

        if (!result || result.length === 0) {
            console.warn("No students have requested to enroll in this course yet.");
            return res.status(404).json({ message: "No students have requested to enroll in this course yet." });
        }

        res.status(200).json({ message: "Enrollment data fetched successfully", result });
    } catch (error) {
        console.error("Controller Error:", error); // Keep this in backend logs
        res.status(500).json({
            error: "Something went wrong while retrieving enrollment data. Please try again later.",
        });
    }
};

// Update enrollment status
const updateEnrollmentStatus = async (req, res) => {
    try {
        const { enrollmentId, status , email, courseName, courseCode} = req.body;

        // Debugging purpose
        console.log("Received request to update enrollment status:", { enrollmentId, status , email, courseName, courseCode });

        // Validate input
        if (!enrollmentId || !status) {
            return res.status(400).json({ error: "Enrollment ID and status are required" });
        }

        // Call service to update enrollment status
        const result = await enrollmentService.updateEnrollmentStatus(enrollmentId, status, email, courseName, courseCode);
        res.status(200).json({ message: "Enrollment status updated successfully", result });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ error: error.message });
    }
};

//Withdraw enrollment
const withdrawEnrollment = async (req, res) => {
    try {
        //Debug
        console.log("Received request to withdraw enrollment");
        const enrollmentId = req.params.enrollmentId;

        //Get from body
        const { studentId, courseName, studentEmail} = req.body;


        // Validate input
        if (!enrollmentId || !studentId || !courseName || !studentEmail) {
            return res.status(400).json({ error: "Enrollment ID, Student ID, Course Name, and Student Email are required" });
        }

        // Call service to withdraw enrollment
        const result = await enrollmentService.withdrawEnrollment(enrollmentId , studentId);

        //If success, send email notification to student 
        //



        res.status(200).json({ message: "Enrollment withdrawn successfully", result });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ error: error.message });
    }
};


module.exports = { enrollStudent , getStudentEnrollment , getAllEnrollment, lecturerGetEnrollment , updateEnrollmentStatus , withdrawEnrollment };

