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
            console.log("Fetching enrollments for student here :", studentId);
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

            // Debugging: Log the retrieved rows
            console.log("Retrieved enrollments:", rows);

            return rows; // Return the list of enrollments
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            throw new Error(`Error in Model: Failed to fetch enrollments: ${err.message}`);
        }
    },

    // Get all enrollments for a course for a lecturer to verify
    async lecturerGetEnrollment(lecturerId, courseId) {
        if (!lecturerId || !courseId) {
            throw new Error("Lecturer ID and Course ID are required");
        }

        try {
            console.log("Fetching enrollments for lecturer:", lecturerId);

            const query = `
                SELECT ce.enrollment_id, ce.student_id, ce.courseId, ce.requested_at,
                    c.courseName, c.courseCode, c.imageUrl, ce.status,
                    u.name AS studentName, ce.approved_at
                FROM CourseEnrollment ce
                JOIN Course c ON ce.courseId = c.courseId
                JOIN User u ON ce.student_id = u.externalId
                WHERE c.lecturerId = ? AND ce.courseId = ? AND ce.status NOT IN ('Rejected')
                ORDER BY ce.requested_at DESC;
            `;

            const [rows] = await pool.query(query, [lecturerId, courseId]);

            if (rows.length === 0) {
                return []; // Let controller handle empty response nicely
            }

            return rows;
        } catch (err) {
            console.error("Model Error:", err.message);
            throw new Error("Database query failed while fetching enrollments.");
        }
    },

    // Update enrollment status
    async updateEnrollmentStatus(enrollmentId, status) {
        // Validate input
        if (!enrollmentId || !status) {
            throw new Error("Enrollment ID and status are required");
        }

        try {
            console.log("Updating enrollment status:", { enrollmentId, status });
            const query = `
            UPDATE CourseEnrollment 
            SET status = ? , approved_at = NOW()
            WHERE enrollment_id = ?`;
            const [result] = await pool.query(query, [status, enrollmentId]);

            if (result.affectedRows === 0) {
                throw new Error("No enrollment found with the provided ID");
            }

            console.log("Enrollment status updated successfully:", result);
            return result; // Return the result of the update operation
        } catch (err) {
            console.error("Error updating data:", err.message);
            throw new Error(`Error in Model: Failed to update enrollment status: ${err.message}`);
        }
    },

    //Function to get all student that enrolled for spesific course
    async getAllEnrollment(courseId) {
        //Validate input
        if (!courseId) {
            throw new Error("Course ID is required");
        }

        try {
            console.log("Fetching enrollments for student:", courseId);
            const query = `
                SELECT student_id
                FROM CourseEnrollment
                WHERE courseId = ? AND status = "Approved"
            `;
            const [rows] = await pool.query(query, [courseId]);
            return rows; // Return the list of enrollments
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            throw new Error(`Error in Model: Failed to fetch enrollments: ${err.message}`);
        }
    }

};

module.exports = EnrollmentModel;