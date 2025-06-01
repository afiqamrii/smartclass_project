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
        } catch (err) {
            console.error("Error inserting data:", err.message);
            throw new Error(`Error in Model: Failed to add course: ${err.message}`);
        }
    },

    //Get all courses from the database
    async getAllCourses() {
        try {
            const query = `SELECT * FROM Course`;
            const [rows] = await pool.query(query);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },
};

module.exports = CourseModel;