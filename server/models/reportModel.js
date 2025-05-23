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
                JOIN Classroom c ON ui.classroomId = c.classroomId
                WHERE ui.issueId = ?
            `;
            const [rows] = await pool.query(query, [reportId]);
            return rows[0]; // Return the first report found
        } catch (error) {
            console.error("Error retrieving report by ID:", error.message);
            throw new Error("Failed to retrieve report by ID");
        }
    },

    // Function to update report by ID
    async updateReportStatus(reportId) {
        try {
            const query = `
                UPDATE UtilityIssue
                SET issueStatus = 'Resolved'
                WHERE issueId = ?
            `;
            const [result] = await pool.query(query, [reportId]);
            return result.affectedRows > 0; // Return true if the report was updated
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
    }
};


module.exports = reportModel;
