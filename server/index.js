const express = require("express");
const cors = require("cors");
const socketIo = require("socket.io");
const http = require("http");
const bodyParser = require("body-parser");
const path = require("path");

// Import routes
const authRouter = require("./routes/authRoutes");
const classRoutes = require("./routes/classRoutes");
const courseRoutes = require("./routes/courseRoutes");
const classroomRoutes = require("./routes/classroomRoutes");
const attendanceRoutes = require("./routes/attendanceRoutes");
const summarizationRoutes = require("./routes/summarizationRoutes");
const generateTranscriptionTextRoutes = require("./routes/saveTranscriptionText");
const sendCommandToMQTT = require("./routes/sendCommandToMQTT");
const gcsTokenRoute = require("./routes/gcsTokenRoute");
const reportRoutes = require('./routes/reportRoutes');

// Initialize app and server
const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: "*", // Allow all origins or specify one
  },
});

// Middleware
app.use(cors());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// GCS Token Route
app.use("/gcs", gcsTokenRoute);

// API Routes
app.use(authRouter);

// Convert PUT to POST for multipart/form-data
app.use((req, res, next) => {
  if (req.method === 'PUT' && req.headers['content-type']?.includes('multipart/form-data')) {
    req.method = 'POST';
  }
  next();
});

app.use('/report', reportRoutes);
app.use("/class", classRoutes);
app.use("/course", courseRoutes);
app.use("/classroom", classroomRoutes);
app.use("/clockInAttendance", attendanceRoutes);
app.use("/summarization", summarizationRoutes);
app.use("/classrecording", generateTranscriptionTextRoutes);
app.use("/mqtt", sendCommandToMQTT);

// ✅ Start WebSocket logic from socket.js
const setupSocket = require('./socket');
setupSocket(io);

// Start server
const PORT = 3000;
server.listen(PORT, () => {
  console.log(`🚀 Server + WebSocket running on http://localhost:${PORT}`);
});
