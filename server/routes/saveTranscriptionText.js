/**
 * Routes for lecturer to add a class.
 * Exports API endpoint to insert class details into the database.
 */

const express = require("express");
const pool = require("../config/database"); // Import the MySQL pool

const router = express.Router();

// POST API to add transcription text to the database
// Endpoint: /classrecording/savetranscriptiontext
router.post("/savetranscriptiontext/:classId", async (req, res) => {
    try {
        console.log("Received data:", req.body);

        // Destructure and validate the request body
        const { transcriptionText, summarizedText , recordingStatus } = req.body;

        //Set default value to summarizedText column
        summarizedTextDefault = "Summary Is Pending";

        const { classId } = req.params;

        if (!transcriptionText || !classId || !recordingStatus ) {
            return res.status(400).send({
                "Status_Code": 400,
                "Message": "Missing required field: transcriptionText"
            });
        }

        // SQL query to insert data
        const query = `
            INSERT INTO ClassRecording (transcriptionText, summaryText , classId , recordingStatus)
            VALUES (?,?, ? , ?)
        `;

        // Execute the query
        const [result] = await pool.execute(query, [
            transcriptionText,
            summarizedTextDefault , // Default summarizedText 
            classId,
            recordingStatus,
        ]);

        // Send response
        res.status(201).send({
            "Status_Code": 201,
            "Message": "Transcription text saved successfully",
            "Data": {
                classRecordingId: result.insertId,
                transcriptionText: transcriptionText,
                summarizedText: summarizedText || null,
                classId
            },
        });
    } catch (error) {
        console.error("Error saving transcription text:", error);
        res.status(500).send({
            "Status_Code": 500,
            "Message": "Internal Server Error",
        });
    }
});

// //PUT API to add summarized text to the database
// // Endpoint: /classrecording/savesummarizedtext
// router.put("/updatetranscriptiontext/:classId", async (req, res) => {
//     try {
//         console.log("Received data:", req.body);

//         // Destructure and validate the request body
//         const { transcriptionText , summarizedText} = req.body;

//         const { classId } = req.params;

//         if (!transcriptionText) {
//             return res.status(400).send({
//                 "Status_Code": 400,
//                 "Message": "Missing required field: transcriptionText"
//             });
//         }

//         // SQL query to insert data
//         const query = `
//             UPDATE ClassRecording
//             SET transcriptionText = ?
//             WHERE classId = ?
//         `;

//         // Execute the query
//         const [result] = await pool.execute(query, [
//             transcriptionText,
//             summarizedText || null, // Default summarizedText to null if not provided
//             classId,
//         ]);

//         // Send response
//         res.status(201).send({
//             "Status_Code": 201,
//             "Message": "Transcription text updated successfully",
//             "Data": {
//                 classRecordingId: result.insertId,
//                 transcriptionText: transcriptionText,
//                 summarizedText: summarizedText || null,
//                 classId
//             },
//         });
//     } catch (error) {
//         console.error("Error saving summarized text:", error);
//         res.status(500).send({
//             "Status_Code": 500,
//             "Message": "Internal Server Error",
//         });
//     }
// });


//GET API to get transcription text from the database
router.get("/gettranscriptiontext", async (req, res) => {
    try {
        // SQL query to retrieve data
        const query = `
            SELECT transcriptionText , classId , recordingId FROM ClassRecording where recordingStatus = "Processing"
        `;

        // Use the pool to execute the query
        const [rows] = await pool.query(query);

        res.status(200).send({
            "Status_Code": 200,
            "Message": "Class Data Is Fetched Successfully",
            "Data": rows
        });
    } catch (err) {
        console.error("Error fetching data:", err.message);

        res.status(500).send({
            "Status_Code": 500,
            "Message": "Failed to fetch class data",
            "Error": err.message
        });
    }   
});




module.exports = router;
