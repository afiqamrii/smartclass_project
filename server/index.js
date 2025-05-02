/**
 * Backend server using Node.js, Express, and MySQL to handle API requests.
 * Includes an API endpoint to add class details into the database.
 */

/**
 * Importing required modules:
 * - express: Framework for building the web server.
 * - cors: Middleware to enable Cross-Origin Resource Sharing (CORS).
 * - pool: Database connection pool.
 * - lectCreateClassRoutres: Routes for lecturer to create new class.
 * - path: Module for working with file paths.
 */
const express = require("express");
const cors = require("cors");
const authRouter = require("./routes/authRoutes");
const classRoutes = require("./routes/classRoutes");
const courseRoutes = require("./routes/courseRoutes");
const attendanceRoutes = require("./routes/attendanceRoutes");
const summarizationRoutes = require("./routes/summarizationRoutes");
const generateTranscriptionTextRoutes = require("./routes/saveTranscriptionText");
const sendCommandToMQTT = require("./routes/sendCommandToMQTT");
const path = require("path");

// Initialize the Express application.
const app = express(); 

// Enable CORS to allow requests from different origins.
app.use(cors());

// Middleware to parse JSON and URL-encoded data from requests.
app.use(express.json());

//Static Files
app.use(express.static(path.join(__dirname, 'public')));

//Routes
//Authentication
app.use(authRouter);

//Class Management
// app.use("/class", lectCreateClassRoutes);
app.use("/class", classRoutes);

//Course Management
app.use("/course", courseRoutes);

//Attendance Management
app.use("/clockInAttendance", attendanceRoutes);

//Summarization Management
app.use("/summarization", summarizationRoutes);

// Class transcription and summarization
app.use("/classrecording", generateTranscriptionTextRoutes);


// app.use("/classrecording", generateSummarizedTextRoutes);
// app.use("/classSummarization", lectAccessSummarizationRoutes);

//Send to MQTT
app.use("/mqtt", sendCommandToMQTT);

// Start the server and listen on the specified port.
const PORT = 3000;

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});