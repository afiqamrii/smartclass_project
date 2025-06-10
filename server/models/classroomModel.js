const { get } = require("../routes/reportRoutes");

const pool = require("../config/database").pool;

const ClassroomModel = {

    // Add a new classroom to the database
    async addClassroom(classroom) {
        try {
            console.log("Adding classroom:", classroom);
            const query = `INSERT INTO Classroom (classroomName, group_developer_id) VALUES (?, ?)`;
            const [result] = await pool.query(query, [classroom.classroomName, classroom.groupDevId]);
            return result.insertId; // Return the ID of the newly created classroom
        } catch (err) {
            if (err.code === 'ER_DUP_ENTRY') {
                throw new Error("Classroom name already exists. Please choose a different name.");
            }
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
            const query = `SELECT * FROM Classroom WHERE is_active = 'Yes'`;
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
    },

    //Soft Delete classroom
    async softDeleteClassroom(classroomId) {
        try {
            const query = `UPDATE Classroom SET is_active = 'No' WHERE classroomId = ?`;
            const [result] = await pool.query(query, [classroomId]);
            return result.affectedRows > 0; // Return true if the deletion was successful
        } catch (err) {
            console.error("Error deleting classroom:", err.message);
            throw new Error("Error in Model : Failed to delete classroom");
        }
    },

    //Function to get deleted classroom
    async getDeletedClassroom() {
        try {
            const query = `SELECT * FROM Classroom WHERE is_active = 'No'`;
            const [rows] = await pool.query(query);
            return rows;
        } catch (err) {
            console.error("Error retrieving deleted classroom:", err.message);
            throw new Error("Error in Model : Failed to fetch deleted classroom");
        }
    },

    //Function to restore deleted classroom
    async restoreClassroom(classroomId) {
        try {
            const query = `UPDATE Classroom SET is_active = 'Yes' WHERE classroomId = ?`;
            const [result] = await pool.query(query, [classroomId]);
            return result.affectedRows > 0; // Return true if the restore was successful
        } catch (err) {
            console.error("Error restoring classroom:", err.message);
            throw new Error("Error in Model : Failed to restore classroom");
        }
    },

    //Function to completely delete classroom
    async deleteClassroom(classroomId) {
        try {
            const query = `DELETE FROM Classroom WHERE classroomId = ?`;
            const [result] = await pool.query(query, [classroomId]);
            return result.affectedRows > 0; // Return true if the deletion was successful
        } catch (err) {
            console.error("Error deleting classroom:", err.message);
            throw new Error("Error in Model : Failed to delete classroom");
        }
    },

    //Function to edit classroom
    async editClassroom(classroomId, updatedClassroom) {
        try {
            const query = `UPDATE Classroom SET classroomName = ? WHERE classroomId = ?`;
            const [result] = await pool.query(query, [updatedClassroom.classroomName, classroomId]);
            return result.affectedRows > 0; // Return true if the update was successful
        } catch (err) {
            console.error("Error updating classroom:", err.message);
            throw new Error("Error in Model : Failed to update classroom");
        }
    },
};



module.exports = ClassroomModel;
