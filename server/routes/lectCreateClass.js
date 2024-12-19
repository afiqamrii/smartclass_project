/**
 * Routes for lecturer to add a class.
 * Exports API endpoint to insert class details into the database.
 */

const express = require("express");
const moment = require("moment");
const pool = require("../data/database"); // Import the MySQL pool

const router = express.Router();

// POST API to add a class to the database
// Endpoint: /class/addclass
router.post("/addclass", async (req, res) => {
    try {
        console.log("Received data:", req.body);

        // Destructure and validate the request body
        const { courseCode, title, date, timeStart, timeEnd, location } = req.body;

        if (!courseCode || !title || !date || !timeStart || !timeEnd || !location) {
            return res.status(400).send({
                "Status_Code": 400,
                "Message": "Missing required fields"
            });
        }

        // Format the date and time for compatibility with MySQL
        const formattedDate = moment(date, "DD/MM/YYYY").format("YYYY-MM-DD");
        const formattedTimeStart = moment(timeStart, "h:mm A").format("HH:mm:ss");
        const formattedTimeEnd = moment(timeEnd, "h:mm A").format("HH:mm:ss");

        // SQL query to insert data
        const query = `
            INSERT INTO class (courseCode, title, date, timeStart, timeEnd, classLocation)
            VALUES (?, ?, ?, ?, ?, ?)
        `;

        const values = [courseCode, title, formattedDate, formattedTimeStart, formattedTimeEnd, location];

        // Use the pool to execute the query
        const [result] = await pool.query(query, values);

        console.log("Class added successfully:", result);

        res.status(200).send({
            "Status_Code": 200,
            "Message": "Class Data Is Added Successfully",
            "Inserted_Id": result.insertId
        });
    } catch (err) {
        console.error("Error inserting data:", err.message);

        res.status(500).send({
            "Status_Code": 500,
            "Message": "Failed to add class data",
            "Error": err.message
        });
    }
});

// GET API to retrieve data for a class from the database
// Endpoint: /class/viewclass
router.get("/viewclass", async (req, res) => {
    try {
        // SQL query to retrieve data
        const query = `
            SELECT * FROM class
        `;

        // Use the pool to execute the query
        const [rows] = await pool.query(query);

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
})

module.exports = router;
