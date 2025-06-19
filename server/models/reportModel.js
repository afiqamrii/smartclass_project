
const pool = require("../config/database").pool;
const path = require('path');

// Model to interact with reports table
const reportModel = {
    async createReport(reportData) {
        try {
        const query = `
            INSERT INTO UtilityIssue (issueTitle , issueDescription , userId, classroomId , imageUrl , timestamp)
            VALUES (?, ?, ?, ?, ? , ?)
        `;
        const values = [reportData.title, reportData.description, reportData.userId , reportData.classroomId , reportData.imageUrl , reportData.timeStamp];
        const [result] = await pool.query(query, values);
        return result.insertId; // Return the ID of the newly created report
        } catch (error) {
        console.error("Error inserting report data:", error.message);
        throw new Error("Failed to create report");
        }
    },

    // Function to get all reports
    async getAllReports() {
        try {
            const query = `
                SELECT 
                    ui.issueId,
                    ui.issueTitle,
                    ui.issueDescription,
                    ui.userId,
                    ui.issueStatus,
                    ui.imageUrl,
                    ui.classroomId,
                    u.userName,
                    c.classroomName,
                    ui.timestamp
                FROM UtilityIssue ui
                JOIN User u ON ui.userId = u.externalId
                JOIN Classroom c ON ui.classroomId = c.classroomId
                ORDER BY ui.timestamp DESC
            `;
            const [rows] = await pool.query(query);
            return rows;
        } catch (error) {
            console.error("Error retrieving reports:", error.message);
            throw new Error("Failed to retrieve reports");
        }
    },

    // Function to get report by ID
    async getReportById(reportId) {
        try {
            const query = `
                SELECT 
                    ui.issueId,
                    ui.issueTitle,
                    ui.issueDescription,
                    ui.userId,
                    ui.issueStatus,
                    ui.imageUrl,
                    ui.classroomId,
                    u.userName,
                    c.classroomName,
                    ui.timestamp
                FROM UtilityIssue ui
                JOIN User u ON ui.userId = u.externalId
                JOIN Classroom c ON ui.classroomId = c.
                ORDER BY ui.timestamp DESC
                WHERE ui.issueId = ?
                
            `;
            const [rows] = await pool.query(query, [reportId]);

            //Debug code: 
            console.log("[DEBUG] Rows:", rows);
            return rows[0]; // Return the first report found
        } catch (error) {
            console.error("Error retrieving report by ID:", error.message);
            throw new Error("Failed to retrieve report by ID");
        }
    },

    // Function to update report by ID
    // Function to update report by ID
    async updateReportStatus(reportId) {
        try {
            // Update the report status first
            const updateQuery = `
                UPDATE UtilityIssue
                SET issueStatus = 'Resolved'
                WHERE issueId = ?
            `;
            const [updateResult] = await pool.query(updateQuery, [reportId]);

            if (updateResult.affectedRows === 0) {
                // No report updated (maybe invalid id)
                return null;
            }

            // Then fetch the full updated report record, including userId
            const selectQuery = `
                SELECT * FROM UtilityIssue WHERE issueId = ?
            `;
            const [rows] = await pool.query(selectQuery, [reportId]);

            // Return the report object or null if not found
            return rows.length > 0 ? rows[0] : null;
        } catch (error) {
            console.error("Error updating report status:", error.message);
            throw new Error("Failed to update report status");
        }
    },


    // Function to get report by user ID
    async getReportByUserId(userId) {
        try {
            const query = `
                SELECT 
                    ui.issueId,
                    ui.issueTitle,
                    ui.issueDescription,
                    ui.userId,
                    ui.issueStatus,
                    ui.imageUrl,
                    ui.classroomId,
                    u.userName,
                    c.classroomName,
                    ui.timestamp
                FROM UtilityIssue ui
                JOIN User u ON ui.userId = u.externalId
                JOIN Classroom c ON ui.classroomId = c.classroomId
                WHERE ui.userId = ?
                ORDER BY ui.timestamp DESC
                
            `;
            const [rows] = await pool.query(query, [userId]);
            return rows;
        } catch (error) {
            console.error("Error retrieving report by user ID:", error.message);
            throw new Error("Failed to retrieve report by user ID");
        }
    },

    // Function to update report by ID
    async updateReport(reportId, reportData) {
        try {
            
            const query = `
                UPDATE UtilityIssue
                SET issueTitle = ?, issueDescription = ?, imageUrl = ? , classroomId = ? 
                WHERE issueId = ?
            `;
            const values = [reportData.title, reportData.description, reportData.imageUrl, reportData.classroomId, reportId];
            const [result] = await pool.query(query, values);
            return result.affectedRows > 0; // Return true if the report was updated
        } catch (error) {
            console.error("Error updating report:", error.message);
            throw new Error("Failed to update report");
        }
    },

    //Funciton to update report by ID without image
    async updateReportWithoutIMage(reportId,reportData){
        try{
            const query = `
                UPDATE UtilityIssue
                SET issueTitle = ?, issueDescription = ? , classroomId = ? 
                WHERE issueId = ?
            `;
            const values = [reportData.title, reportData.description, reportData.classroomId, reportId];
            const [result] = await pool.query(query, values);
            return result.affectedRows > 0; // Return true if the report was updated

        } catch(error){
            console.error("Error updating report:", error.message);
            throw new Error("Failed to update report");
        }
    },

    //Function to count report by user id
    async getNewReportCountByUser(userId) {
        try {
            const query = `
                SELECT COUNT(*) AS newReportCount
                FROM UtilityIssue
                WHERE userId = ? AND is_read_by_technician = 'Unread'
            `;
            const [rows] = await pool.query(query, [userId]);
            return rows[0].newReportCount; // Return the count of new reports
        } catch (error) {
            console.error("Error retrieving new report count by user ID:", error.message);
            throw new Error("Failed to retrieve new report count by user ID");
        }
    },

    // Function to get new report count
    async getNewReportCount() {
        try {
            const query = `
                SELECT COUNT(*) AS newReportCount
                FROM UtilityIssue
                WHERE is_read_by_technician = 'Unread'
            `;
            const [rows] = await pool.query(query);
            return rows[0].newReportCount; // Return the count of new reports
        } catch (error) {
            console.error("Error retrieving new report count:", error.message);
            throw new Error("Failed to retrieve new report count");
        }
    },

    //Get latest report id
    async getLatestReportId() {
        try {
            const query = `
                SELECT issueId
                FROM UtilityIssue
                ORDER BY issueId DESC
                LIMIT 1
            `;
            const [rows] = await pool.query(query);
            return rows[0].issueId; // Return the latest report ID
        } catch (error) {
            console.error("Error retrieving latest report ID:", error.message);
            throw new Error("Failed to retrieve latest report ID");
        }
    },

    // Function to mark all reports as read
    async markAsRead() {
        try {
            const query = `
                UPDATE UtilityIssue
                SET is_read_by_technician = 'Read'
                WHERE is_read_by_technician = 'Unread'
            `;
            const [result] = await pool.query(query);
            return result.affectedRows > 0; // Return true if the reports were updated
        } catch (error) {
            console.error("Error marking reports as read:", error.message);
            throw new Error("Failed to mark reports as read");
        }
    },
};


module.exports = reportModel;
