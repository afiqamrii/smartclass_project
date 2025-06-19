const pool = require("../../config/database").pool;

const UtilityModel = {
    // Add a new utility to the database
    async addUtility(utility) {
        try {
            console.log("Adding utility:", utility);
            const query = `INSERT INTO Utility (utilityName, device_id , classroomId , utilityType) VALUES (?, ? , ? , ?)`;
            const [result] = await pool.query(query, [utility.name, utility.device_id , utility.classroomId, utility.utilityType]);
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
    async getAllUtilities(classroomId) {
        if (!classroomId) {
            throw new Error("Classroom ID is required to retrieve utilities");
        }
        try {
            const query = `SELECT * FROM Utility WHERE classroomId = ?`;
            const [rows] = await pool.query(query , [classroomId]);
            if (rows.length === 0) {
                throw new Error("No utilities found for the specified classroom");
            }
            return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    // Update utility status by ID
    async updateUtilityStatus(utilityId, utilityStatus) {
        if (!utilityId || utilityStatus === undefined) {
            throw new Error("Utility ID and status are required to update utility");
        }
        try {
            const query = `UPDATE Utility SET utilityStatus = ? WHERE utilityId = ?`;
            const [result] = await pool.query(query, [utilityStatus, utilityId]);
            if (result.affectedRows === 0) {
                throw new Error("No rows affected, utility status not updated");
            }
            return result; // Return the result of the update operation
        } catch (err) {
            console.error("Error updating data:", err.message);
            throw new Error("Error in Model: Failed to update utility status");
        }
    },

    // Delete utility by ID
    async deleteUtility(utilityId) {
        if (!utilityId) {
            throw new Error("Utility ID is required to delete utility");
        }
        try {
            const query = `DELETE FROM Utility WHERE utilityId = ?`;
            const [result] = await pool.query(query, [utilityId]);
            if (result.affectedRows === 0) {
                throw new Error("No rows affected, utility not deleted");
            }
            return result; // Return the result of the delete operation
        } catch (err) {
            console.error("Error deleting data:", err.message);
            throw new Error("Error in Model: Failed to delete utility");
        }
    }
};

module.exports = UtilityModel;