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
            cl.classroomName AS classLocation,
            c.timeStart,
            c.timeEnd,
            c.date,
            cr.recordingStatus

            FROM ClassSession c
            JOIN Course co ON c.courseId = co.courseId
            JOIN Classroom cl ON c.classroomId = cl.classroomId
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

    //Lecturer access transcription by class id
    async accessTranscriptionById(classId) {
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

    //Retrieve summarizaation by class id for student
    async studentAccessSummarizationById(classId) {
        try{
            const query = `
            SELECT * FROM ClassRecording WHERE classId = ? AND publishStatus = "Published"
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

        //debug
        // console.log("Saving summarization with data:", {
        //     summarizedText,
        //     recordingId,
        //     classId,
        //     recordingStatus
        // });

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
        
    },

    // Function to get summary and save it
    async getSummaryPrompt(lecturerId) {
        try{
            const query = `
            SELECT * FROM SummaryPrompt WHERE lecturerId = ?
        `;
        const [result] = await pool.execute(query, [lecturerId]);
        return result;
        } catch (err) {
            console.error("Error updating data:", err.message);
            return [];
        }
    },

    //Function to save summary prompt
    async saveSummaryPrompt(prompt, lecturerId) {
        try{
            const query = `
            INSERT INTO SummaryPrompt (summary_prompt, lecturerId) VALUES (?, ?)
        `;
        const [result] = await pool.execute(query, [prompt, lecturerId]);
        return result;
        } catch (err) {
            console.error("Error updating data:", err.message);
            return [];
        }
    },
};

module.exports = SummarizationModel;

