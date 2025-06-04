const pool = require("../config/database").pool;
const moment = require("moment");
// const { get } = require("../routes/summarizationRoutes");

const SummarizationModel = {

    // Retrieve Summarization Status
    async getSummarizationStatus(lecturerId) {
        try{
            const query = `
            SELECT 
            c.classId, 
            co.courseCode,
            co.courseName AS className,
            c.classLocation,
            c.timeStart,
            c.timeEnd,
            c.date,
            cr.recordingStatus

            FROM ClassSession c
            JOIN Course co ON c.courseId = co.courseId
            LEFT JOIN ClassRecording cr ON c.classId = cr.classId
            WHERE cr.recordingStatus IS NOT NULL AND c.lecturerId = ?;
        `;
        const [rows] = await pool.query(query, [lecturerId]);
        return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },  

    // Retrieve Summarization by Class ID
    async getSummarizationById(classId) {
        try{
            const query = `
            SELECT * FROM ClassRecording WHERE classId = ?
        `;
        const [rows] = await pool.query(query, [classId]);
        return rows;
        } catch (err) {
            console.error("Error retrieving data:", err.message);
            return [];
        }
    },

    // Update Summarization
    async editSummarization(summarizedText, classId) {
        try{
            const query = `
            UPDATE ClassRecording SET summaryText = ? WHERE classId = ?
        `;
        const [result] = await pool.execute(query, [summarizedText, classId]);
        return result;

        } catch (err) {
            console.error("Error updating data:", err.message);
            return [];
        }
    },

    // Update Publish Status
    async updatePublishStatus(publishStatus, classId) {
        try{
            const query = `
            update ClassRecording SET publishStatus = ? WHERE classId = ?
        `;
            const [result] = await pool.execute(query, [publishStatus, classId]);
            return result;
        }
    catch (err) {
        console.error("Error updating data:", err.message);
        return [];
    }
    },

    //Save Summarized Text
    async saveSummarization(summarizedText, recordingId ,classId ,recordingStatus) {
        try{
            const query = `
            UPDATE ClassRecording
                SET summaryText = ? , recordingStatus = ?
                WHERE recordingId = ? and classId = ?
        `;
        const [result] = await pool.execute(query, [summarizedText, recordingStatus, recordingId, classId]);
        return result;
        } catch (err) {
            console.error("Error updating data:", err.message);
            return [];
        }
        
    }
};

module.exports = SummarizationModel;

