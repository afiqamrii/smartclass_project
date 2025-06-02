const pool = require("../config/database").pool;

const EnrollmentModel = {
    // Enroll a student in a course
    async enrollStudent(studentId, courseId) {
        // Validate input
        if (!studentId || !courseId) {
            throw new Error("Student ID and Course ID are required");
        }

        const date = new Date();
        const offsetMs = 8 * 60 * 60 * 1000; // 8 hours offset
        const localDate = new Date(date.getTime() + offsetMs);

        const formattedDate = localDate.toISOString().split('T')[0];
        const formattedTime = localDate.toISOString().split('T')[1].split('.')[0];
        const timeStamp = `${formattedDate} ${formattedTime}`;

        try {
            console.log("Enrolling student:", { studentId, courseId });
            const query = `INSERT INTO CourseEnrollment (student_id, courseId , requested_at) VALUES (?, ? ,?)`;
            const [result] = await pool.query(query, [studentId, courseId , timeStamp]);
            console.log("Enrollment successful:", result);
            return result.insertId; // Return the ID of the newly created enrollment
        } catch (err) {
            //If error cause of duplicate entry, return error message to the controller
            if (err.code === 'ER_DUP_ENTRY') {
                const customError = new Error("You have already enrolled in this course. Only one enrollment per course is allowed.");
                customError.status = 409; // Conflict
                throw customError;
            }
            console.error("Error inserting data:", err.message);
            throw new Error(`Error in Model: Failed to enroll student: ${err.message}`);
        }
    },

    // Get all enrollments for a student that are not verified yet
    async getStudentEnrollment(studentId) {
        // Validate input
        if (!studentId) {
            throw new Error("Student ID is required");
        }

        try {
            console.log("Fetching enrollments for student:", studentId);
            const query = `
                SELECT ce.enrollment_id, ce.student_id, ce.courseId, ce.requested_at, c.courseName, c.courseCode, c.imageUrl, ce.status ,c.lecturerId , u.name AS lecturerName
                FROM CourseEnrollment ce
                JOIN Course c ON ce.courseId = c.courseId
                JOIN User u ON c.lecturerId = u.externalId
                WHERE ce.student_id = ? AND ce.status = "Pending" 
                ORDER BY ce.requested_at DESC;
            `;
            const [rows] = await pool.query(query, [studentId]);
            return rows; // Return the list of enrollments
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            throw new Error(`Error in Model: Failed to fetch enrollments: ${err.message}`);
        }
    },

    // Get all enrollments for a student
    async getAllEnrollments(studentId) {

        try {
            console.log("Fetching enrollments for student:", studentId);
            const query = `
                SELECT ce.enrollment_id, ce.student_id, ce.courseId, ce.requested_at, c.courseName, c.courseCode, c.imageUrl, ce.status ,c.lecturerId , u.name AS lecturerName
                FROM CourseEnrollment ce
                JOIN Course c ON ce.courseId = c.courseId
                JOIN User u ON c.lecturerId = u.externalId
                WHERE ce.student_id = ?
                ORDER BY ce.requested_at DESC;
            `;
            const [rows] = await pool.query(query, [studentId]);
            return rows; // Return the list of enrollments
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            throw new Error(`Error in Model: Failed to fetch enrollments: ${err.message}`);
        }
    },

    // Get all enrollments for a course for a lecturer to verify
    async lecturerGetEnrollment(lecturerId) {
        // Validate input
        if (!lecturerId) {
            throw new Error("Lecturer ID is required");
        }

        try {
            console.log("Fetching enrollments for lecturer:", lecturerId);
            const query = `
                SELECT ce.enrollment_id, ce.student_id, ce.courseId, ce.requested_at, c.courseName, c.courseCode, c.imageUrl, ce.status , u.name AS studentName
                FROM CourseEnrollment ce
                JOIN Course c ON ce.courseId = c.courseId
                JOIN User u ON ce.student_id = u.externalId
                WHERE c.lecturerId = ?
                ORDER BY ce.requested_at DESC;
            `;
            const [rows] = await pool.query(query, [lecturerId]);
            return rows; // Return the list of enrollments
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            throw new Error(`Error in Model: Failed to fetch course enrollments for lecturer: ${err.message}`);
        }
    }


};

module.exports = EnrollmentModel;