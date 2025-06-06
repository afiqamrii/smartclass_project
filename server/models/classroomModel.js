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

    //Update esp32_id in the Classroom table
    async updateEsp32Id(classroomId, esp32_id) {
        try {
            const query = `UPDATE Classroom SET esp32_id = ? WHERE classroomId = ?`;
            const [result] = await pool.query(query, [esp32_id, classroomId]);
            return result.affectedRows > 0; // Return true if the update was successful
        } catch (err) {
            console.error("Error updating esp32_id:", err.message);
            throw new Error("Error in Model : Failed to update esp32_id");
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

    // Get classroom by esp32 ID
    async getClassroomByEsp32Id(esp32Id) {
        if (!esp32Id || esp32Id.trim() === "") {
            throw new Error("ESP32 ID is required");
        }
        try {
            const query = 
            `SELECT 
            c.group_developer_id,
            u.device_id

            FROM Classroom c
            JOIN Utility u ON c.classroomId = u.classroomId 
            
            WHERE esp32_id = ?`;

            const [rows] = await pool.query(query, [esp32Id]);
            if (rows.length === 0) {
                throw new Error("No classroom found with the provided ESP32 ID");
            }
            return rows; // Return the first matching classroom
        } catch (err) {
            console.error("Error retrieving classroom by esp32_id:", err.message);
            throw new Error("Error in Model : Failed to fetch classroom by esp32 ID");
        }
    }
};

module.exports = ClassroomModel;