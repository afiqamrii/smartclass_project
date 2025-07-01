const pool = require("../config/database").pool;

const CourseModel = {

    // Add a new course to the database
    async addCourse(courseName, courseCode, imageUrl) {
        // Validate input
        if (!courseName || !courseCode) {
            throw new Error("Course name and code are required");
        }

        try {
            console.log("Adding course:", { courseName, courseCode, imageUrl });
            const query = `
            INSERT INTO Course 
            (courseCode, courseName, imageUrl) 
            VALUES (?, ?, ?)
            `;
            const [result] = await pool.query(query, [courseCode, courseName, imageUrl]);
            console.log("Course added successfully:", result);
            return result.insertId; // Return the ID of the newly created course

            //Throw error if course already exists
        } catch (err) {
            if (err.code === 'ER_DUP_ENTRY') {
                throw new Error("Course already exists. Please choose a different name.");
            }
            console.error("Error inserting data:", err.message);
            throw new Error("Error in Model: Failed to add course");
        }
    },

    //Get all courses from the database
    async getAllCourses() {
        try {
            const query = `
            SELECT 
                c.courseId,
                c.courseCode,
                c.courseName,
                c.imageUrl,
                GROUP_CONCAT(u.name SEPARATOR ', ') AS lecturerNames,
                GROUP_CONCAT(u.userEmail SEPARATOR ', ') AS lecturerEmails
            FROM Course c
            LEFT JOIN CourseAssigned ca ON c.courseId = ca.courseId
            LEFT JOIN User u ON ca.lecturerId = u.externalId
            WHERE c.is_active = 'Yes'
            GROUP BY c.courseId, c.courseCode, c.courseName, c.imageUrl;
            
            `;
            const [rows] = await pool.query(query);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    // Get courses assigned to a lecturer
    async lecturerViewCourses(lecturerId) {
        try {
            const query = `
            SELECT 
                c.courseId,
                c.courseCode,
                c.courseName,
                c.imageUrl,
                ca.lecturerId,
                u.name AS lecturerName,
                u.userEmail AS lecturerEmail
            FROM Course c
            INNER JOIN CourseAssigned ca ON c.courseId = ca.courseId
            INNER JOIN User u ON ca.lecturerId = u.externalId
            LEFT JOIN ClassSession cs 
                ON cs.courseId = c.courseId 
                AND cs.lecturerId = ca.lecturerId
                AND CURDATE() = cs.date
                AND (CURTIME() + INTERVAL 8 HOUR) BETWEEN cs.timeStart AND cs.timeEnd
            WHERE c.is_active = 'Yes'
            AND ca.lecturerId = ?
            AND cs.classId IS NULL
            ORDER BY c.courseName ASC;
            `;
            const [rows] = await pool.query(query, [lecturerId]);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    // Get all courses for students
    async studentViewCourses(studentId) {
        try {
            const query = `
            SELECT 
                c.courseId,
                c.courseCode,
                c.courseName,
                c.imageUrl,
                ca.lecturerId,
                u.name AS lecturerName,
                u.userEmail AS lecturerEmail
            FROM Course c
            INNER JOIN CourseAssigned ca ON c.courseId = ca.courseId
            INNER JOIN User u ON ca.lecturerId = u.externalId 
            WHERE c.is_active = 'Yes'
              AND NOT EXISTS (
                  SELECT 1 
                  FROM CourseEnrollment ce 
                  WHERE ce.courseId = c.courseId
                    AND ce.student_id = ?
              )
            ORDER BY c.courseName ASC;
            `;
            const [rows] = await pool.query(query, [studentId]);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    // Get courses by lecturer ID
    async getCourseByLecturerId(lecturerId) {
        // Validate input
        if (!lecturerId) {
            throw new Error("Lecturer ID is required");
        }

        try {
            console.log("Fetching courses for lecturer:", lecturerId);
            const query = `
            SELECT 
                c.courseId,
                c.courseCode,
                c.courseName,
                c.imageUrl,
                ca.lecturerId,
                u.userEmail AS lecturerEmail
            FROM Course c
            JOIN CourseAssigned ca ON c.courseId = ca.courseId
            JOIN User u ON ca.lecturerId = u.externalId
            WHERE c.is_active = 'Yes' 
            AND ca.lecturerId = ?
            ORDER BY c.courseName ASC;

            
            `;
            const [rows] = await pool.query(query , [lecturerId]);
            return rows; // Return the list of courses
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            throw new Error(`Error in Model: Failed to fetch courses: ${err.message}`);
        }
    },

    //Edit course
    async editCourse(editCourse) {
        // Validate input
        if (!editCourse.courseId || !editCourse.courseCode || !editCourse.courseName) {
            throw new Error("Course ID, name, and code are required");
        }
        try {
            console.log("Updating course:", editCourse);
            const query = `UPDATE Course SET courseCode = ?, courseName = ? WHERE courseId = ?`;
            const [result] = await pool.query(query, [editCourse.courseCode, editCourse.courseName, editCourse.courseId]);
            console.log("Course updated successfully:", result);
            return result.affectedRows; // Return the number of rows affected
        } catch (err) {
            console.error("Error updating data:", err.message);
            throw new Error("Error in Model: Failed to update course");
        }
    },

    //Function to get all assigned lecturers
    async getAssignedLecturers(courseId) {
        try {
            const query = `
            SELECT 
                u.userId,
                u.name,
                u.userEmail,
                u.roleId,
                ur.roleName,
                u.externalId, 
                u.is_approved AS status
            FROM User u
            JOIN UserRole ur ON u.roleId = ur.roleId
            JOIN CourseAssigned ca ON u.externalId = ca.lecturerId
            WHERE u.roleId = 2 
            AND u.is_approved = 'Approved'
            AND ca.courseId = ?

            
            `;
            const [rows] = await pool.query(query, [courseId]);
            return rows; // Return the list of lecturers
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            throw new Error("Error in Model: Failed to fetch lecturers");
        }
    },

    //Function to get all lecturers
    async getLecturers(courseId) {
        try {
            const query = `
            SELECT 
                u.userId,
                u.name,
                u.userEmail,
                u.roleId,
                ur.roleName,
                u.externalId, 
                u.is_approved AS status
            FROM User u
            JOIN UserRole ur ON u.roleId = ur.roleId
            WHERE u.roleId = 2 
			  AND u.is_approved = 'Approved'
			  AND u.externalId NOT IN (
				  SELECT lecturerId 
				  FROM CourseAssigned 
				  WHERE courseId = ?
			  )
			ORDER BY u.name ASC;
            
            `;
            const [rows] = await pool.query(query , [courseId]);
            return rows; // Return the list of lecturers
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            throw new Error("Error in Model: Failed to fetch lecturers");
        }
    },

    //Function to assign course to lecturer
    async assignCourse(courseId, lecturerId) {
        try {
            const query = `
            INSERT INTO CourseAssigned 
            (courseId, lecturerId) 
            VALUES (?, ?) 
            ON DUPLICATE KEY UPDATE lecturerId = ?
            `;
            const [result] = await pool.query(query, [courseId, lecturerId, lecturerId]);
            return result.affectedRows > 0; // Return true if the assignment was successful
        } catch (err) {
            console.error("Error assigning course:", err.message);
            throw new Error("Error in Model : Failed to assign course");
        }
    },

    //Function to soft delete course
    async softDeleteCourse(courseId) {
        try {
            const query = `UPDATE Course SET is_active = 'No' WHERE courseId = ?`;
            const [result] = await pool.query(query, [courseId]);
            return result.affectedRows > 0; // Return true if the deletion was successful
        } catch (err) {
            console.error("Error deleting course:", err.message);
            throw new Error("Error in Model : Failed to delete course");
        }
    },

    //Get deleted course
    async getDeletedCourse() {
        try {
            const query = `SELECT * FROM Course WHERE is_active = 'No'`;
            const [rows] = await pool.query(query);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    //Function to restore course
    async restoreCourse(courseId) {
        try {
            const query = `UPDATE Course SET is_active = 'Yes' WHERE courseId = ?`;
            const [result] = await pool.query(query, [courseId]);
            return result.affectedRows > 0; // Return true if the deletion was successful
        } catch (err) {
            console.error("Error deleting course:", err.message);
            throw new Error("Error in Model : Failed to delete course");
        }
    },

    //Function to completely delete course
    async deleteCourse(courseId) {
        try {
            const query = `DELETE FROM Course WHERE courseId = ?`;
            const [result] = await pool.query(query, [courseId]);
            return result.affectedRows > 0; // Return true if the deletion was successful
        } catch (err) {
            console.error("Error deleting course:", err.message);
            throw new Error("Error in Model : Failed to delete course");
        }
    },

    //Get user email for spesific courseId
    async getUserEmail(courseId) {
        try {
            const query = 
            `
            select 
            u.userEmail,
            cl.classroomName,
            c.courseName,
            cs.date,
            cs.timeStart,
            cs.timeEnd

            FROM CourseEnrollment ce
            join ClassSession cs on cs.courseId = ce.courseId
            join Classroom cl on cl.classroomId = cs.classroomId
            join Course c on c.courseId = ce.courseId
            join User u ON u.externalId = ce.student_id

            where ce.courseId = ?
        
            `;
            const [rows] = await pool.query(query, [courseId]);

            //Debug output
            console.log(rows);

            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },
};

module.exports = CourseModel;