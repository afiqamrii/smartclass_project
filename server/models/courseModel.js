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
            const query = `INSERT INTO Course (courseCode, courseName, imageUrl) VALUES (?, ?, ?)`;
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
            const query = `SELECT * FROM Course WHERE is_active = 'Yes'`;
            const [rows] = await pool.query(query);
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
            const query = `SELECT * FROM Course WHERE AND is_active = 'Yes'`;
            const [rows] = await pool.query(query);
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
    }
};

module.exports = CourseModel;