/**
 * Routes for lecturer to add a class.
 * Exports API endpoint to insert class details into the database.
 */

const express = require("express");
const pool = require("../data/database"); // Import the MySQL pool

const router = express.Router();

//PUT API to add summarized text to the database
// Endpoint: /classrecording/savesummarizedtext
router.put("/savesummarizedtext", async (req, res) => {
    try {
        console.log("Received data:", req.body);

        // Destructure and validate the request body
        const { summarizedText } = req.body;

        if (!summarizedText) {
            return res.status(400).send({
                "Status_Code": 400,
                "Message": "Missing required field: summarizedText"
            });
        }

        // SQL query to insert data
        const query = `
            UPDATE ClassRecording
            SET summaryText = ?
            WHERE recordingId = 11
        `;

        // Execute the query
        const [result] = await pool.execute(query, [summarizedText]);

        // Send response
        res.status(201).send({
            "Status_Code": 201,
            "Message": "Summarized text saved successfully",
            "Data": result,
        });
    } catch (err) {
        console.error("Error saving summarized text:", err);
        res.status(500).send({
            "Status_Code": 500,
            "Message": "Internal Server Error",
        });
    }
});

module.exports = router;