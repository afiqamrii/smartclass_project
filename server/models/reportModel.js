const pool = require("../config/database").pool;
const path = require('path');

// Model to interact with reports table
const reportModel = {
    async createReport(reportData) {
        try {
        const query = `
            INSERT INTO Report (reportTitle,reportDesc,imageUrl)
            VALUES (?, ?, ?)
        `;
        const values = [reportData.title, reportData.decription, reportData.imageUrl];
        const [result] = await pool.query(query, values);
        return result.insertId; // Return the ID of the newly created report
        } catch (error) {
        console.error("Error inserting report data:", error.message);
        throw new Error("Failed to create report");
        }
    },
};

module.exports = reportModel;
