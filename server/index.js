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
const pool = require("./data/database");
const lectCreateClassRoutres = require("./routes/lectCreateClass");
const path = require("path");

// Initialize the Express application.
const app = express(); 

// Enable CORS to allow requests from different origins.
app.use(cors());

// Middleware to parse JSON and URL-encoded data from requests.
app.use(express.json());

// Start the server and listen on the specified port.
const PORT = 3000;

app.listen(PORT, "127.0.0.1", () => {
    console.log(`Server is running on port ${PORT}`);
});

//Routes
app.use("/class", lectCreateClassRoutres);
