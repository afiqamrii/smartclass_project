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
const bodyParser = require('body-parser');
const authRouter = require("./routes/authRoutes");
const classRoutes = require("./routes/classRoutes");
const courseRoutes = require("./routes/courseRoutes");
const classroomRoutes = require("./routes/classroomRoutes");
const attendanceRoutes = require("./routes/attendanceRoutes");
const summarizationRoutes = require("./routes/summarizationRoutes");
const generateTranscriptionTextRoutes = require("./routes/saveTranscriptionText");
const sendCommandToMQTT = require("./routes/sendCommandToMQTT");
const path = require("path");

// Initialize the Express application.
const app = express(); 

// Enable CORS to allow requests from different origins.
app.use(cors());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
// Middleware to parse JSON and URL-encoded data from requests.
app.use(express.json());

// Import routes
const reportRoutes = require('./routes/reportRoutes');

//Static Files
app.use(express.static(path.join(__dirname, 'public')));

//GCS Token Route
// This route is used to get a token for Google Cloud Storage (GCS) authentication.
const gcsTokenRoute = require("./routes/gcsTokenRoute");
app.use("/gcs", gcsTokenRoute);

//Routes
//Authentication
app.use(authRouter);

//Report Management
// Use routes
app.use((req, res, next) => {
  if (req.method === 'PUT' && req.headers['content-type']?.includes('multipart/form-data')) {
    req.method = 'POST';
  }
  next();
});
app.use('/report', reportRoutes);

//Class Management
// app.use("/class", lectCreateClassRoutes);
app.use("/class", classRoutes);

//Course Management
app.use("/course", courseRoutes);

//Classroom Management
app.use("/classroom", classroomRoutes);

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