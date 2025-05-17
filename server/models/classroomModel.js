const { get } = require("../routes/reportRoutes");

const pool = require("../config/database").pool;

const ClassroomModel = {
    //Get all courses from the database
    async getAllClassroom() {
        try {
            const query = `SELECT * FROM Classroom`;
            const [rows] = await pool.query(query);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },
};

module.exports = ClassroomModel;