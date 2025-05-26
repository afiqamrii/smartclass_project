const { get } = require("../routes/reportRoutes");

const pool = require("../config/database").pool;

const ClassroomModel = {

    // Add a new classroom to the database
    async addClassroom(classroom) {
        try {
            console.log("Adding classroom:", classroom);
            const query = `INSERT INTO Classroom (classroomName, group_developer_id) VALUES (?, ?)`;
            const [result] = await pool.query(query, [classroom.classroomName, classroom.groupDevId ]);
            return result.insertId; // Return the ID of the newly created classroom
        } catch (err) {
            console.error("Error inserting data:", err.message);
            throw new Error("Error in Model : Failed to add classroom");
        }
    },

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