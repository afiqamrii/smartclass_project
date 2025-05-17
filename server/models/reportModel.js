const pool = require("../config/database").pool;
const path = require('path');

// Model to interact with reports table
const reportModel = {
    async createReport(reportData) {
        try {
        const query = `
            INSERT INTO UtilityIssue (issueTitle , issueDescription , userId, classroomId , imageUrl)
            VALUES (?, ?, ?, ?, ?)
        `;
        const values = [reportData.title, reportData.description, reportData.userId , reportData.classroomId , reportData.imageUrl];
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
                    c.classroomName
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
    }
};

module.exports = reportModel;
