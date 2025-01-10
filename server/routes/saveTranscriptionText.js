/**
 * Routes for lecturer to add a class.
 * Exports API endpoint to insert class details into the database.
 */

const express = require("express");
const pool = require("../data/database"); // Import the MySQL pool

const router = express.Router();

// POST API to add transcription text to the database
// Endpoint: /classrecording/savetranscriptiontext
router.post("/savetranscriptiontext", async (req, res) => {
    try {
        console.log("Received data:", req.body);

        // Destructure and validate the request body
        const { transcriptionText, summarizedText } = req.body;

        if (!transcriptionText) {
            return res.status(400).send({
                "Status_Code": 400,
                "Message": "Missing required field: transcriptionText"
            });
        }

        // SQL query to insert data
        const query = `
            INSERT INTO ClassRecording (transcriptionText, summarizedText)
            VALUES (?,?)
        `;

        // Execute the query
        const [result] = await pool.execute(query, [
            transcriptionText,
            summarizedText || null, // Default summarizedText to null if not provided
        ]);

        // Send response
        res.status(201).send({
            "Status_Code": 201,
            "Message": "Transcription text saved successfully",
            "Data": {
                classRecordingId: result.insertId,
                transcriptionText: transcriptionText,
                summarizedText: summarizedText || null,
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

//GET API to get transcription text from the database
router.get("/gettranscriptiontext", async (req, res) => {
    try {
        // SQL query to retrieve data
        const query = `
            SELECT (transcriptionText) FROM ClassRecording where recordingId = 11
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
