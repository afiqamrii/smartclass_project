const pool = require("../config/database").pool;

const CourseModel = {
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