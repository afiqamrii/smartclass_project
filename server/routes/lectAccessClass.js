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
            INSERT INTO class (courseCode, className, date, timeStart, timeEnd, classLocation)
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
            SELECT * FROM class ORDER BY date DESC, timeStart DESC;
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
});

//GET API to retrieve data from table Class and ClassRecording to get recordingStatus on summarization
router.get("/viewSummarizationStatus", async (req, res) => {
    try {
        // SQL query to retrieve data
        const query = `
            SELECT
                c.*,
                cr.recordingStatus
            FROM
                class c
            LEFT JOIN
                ClassRecording cr ON c.classId = cr.classId
            WHERE
                cr.recordingStatus IS NOT NULL;
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
});

// PUT API to update a class in the database
// Endpoint: /class/updateclass
router.put("/updateclass/:id", async (req, res) => {
    try {
      console.log("Received data:", req.body);
      const { courseCode, className, date, timeStart, timeEnd, classLocation } = req.body;
      const id = req.params.id;
  
    //   if (!id || !courseCode || !className || !date || !timeStart || !timeEnd || !classLocation) {
    //     return res.status(400).send({
    //       "Status_Code": 400,
    //       "Message": "Missing required fields"
    //     });
    //   }
  
      const formattedDate = moment(date, "YYYY-MM-DD").format("YYYY-MM-DD");
      const formattedTimeStart = moment(timeStart, "HH:mm:ss").format("HH:mm:ss");
      const formattedTimeEnd = moment(timeEnd, "HH:mm:ss").format("HH:mm:ss");
  
      const query = `
        UPDATE class
        SET courseCode = ?, className = ?, date = ?, timeStart = ?, timeEnd = ?, classLocation = ?
        WHERE classId = ?
      `;
  
      const values = [courseCode, className, formattedDate, formattedTimeStart, formattedTimeEnd, classLocation, id];
  
      const [result] = await pool.query(query, values);
  
      console.log("Class updated successfully:", result);
  
      res.status(200).send({
        "Status_Code": 200,
        "Message": "Class Data Is Updated Successfully",
        "Updated_Id": id
      });
    } catch (err) {
      console.error("Error updating data:", err.message);
      console.error("Error stack trace:", err.stack);
  
      res.status(500).send({
        "Status_Code": 500,
        "Message": "Failed to update class data",
        "Error": {
          "Message": err.message,
          "Stack": err.stack
        }
      });
    }
  });

// DELETE API to delete a class from the database
// Endpoint: /class/deleteclass
router.delete("/deleteclass/:id", async (req, res) => {
    try {
        const id = req.params.id;

        // SQL query to delete data
        const query = `
            DELETE FROM class
            WHERE classId = ?
        `;

        // Use the pool to execute the query
        const [result] = await pool.query(query, [id]);

        console.log("Class deleted successfully:", result);

        res.status(200).send({
            "Status_Code": 200,
            "Message": "Class Data Is Deleted Successfully",
            "Deleted_Id": id
        });
    } catch (err) {
        console.error("Error deleting data:", err.message);

        res.status(500).send({
            "Status_Code": 500,
            "Message": "Failed to delete class data",
            "Error": err.message
        });
    }
})
        


module.exports = router;
