const express = require("express");
const pool = require("../config/database"); // Import the MySQL pool

const router = express.Router();

// GET API to retrieve data for a class from the database
// Endpoint: /classSummarization/accesssummarization
router.get("/accesssummarization/:classId", async (req, res) => {
    try {
        const { classId } = req.params; // Extract classId from the URL parameter

        // SQL query to retrieve data with a parameter placeholder
        const query = `
            SELECT * FROM ClassRecording WHERE classId = ?
        `;

        // Pass the `classId` parameter to the query
        const [rows] = await pool.query(query, [classId]);

        res.status(200).send({
            "Status_Code": 200,
            "Message": "Class Data Is Fetched Successfully",
            "Data": rows
        });
    } catch (err) {
        console.error("Error retrieving data:", err.message);

        res.status(500).send({
            "Status_Code": 500,
            "Message": "Failed to fetch class data",
            "Error": err.message
        });
    }
});


module.exports = router;
