const pool = require("../../config/database").pool;

const UtilityModel = {
    // Add a new utility to the database
    async addUtility(utility) {
        try {
            console.log("Adding utility:", utility);
            const query = `INSERT INTO Utility (utilityName, device_id , classroomId , topic) VALUES (?, ? , ?, ?)`;
            const [result] = await pool.query(query, [utility.name, utility.device_id , utility.classroomId, utility.topic]);
            if (result.affectedRows === 0) {
                throw new Error("No rows affected, utility not added");
            }
            return result.insertId; // Return the ID of the newly created utility
        } catch (err) {
            console.error("Error inserting data:", err.message);
            throw new Error("Error in Model: Failed to add utility");
        }
    },

    // Get all utilities from the database
    async getAllUtilities() {
        try {
            const query = `SELECT * FROM Utility`;
            const [rows] = await pool.query(query);
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },
};

module.exports = UtilityModel;