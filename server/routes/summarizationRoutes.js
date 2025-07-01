const express = require("express");
const summarizationController = require("../controllers/summarizationController");

const router = express.Router();

// Route to view Summarization Status
router.get("/viewSummarizationStatus/:lecturerId", summarizationController.viewSummarizationStatus);

// Route to access summarization by class id
router.get("/accesssummarization/:classId", summarizationController.accessSummarizationById);


//Route for student to access summarization by class id
router.get("/studentaccesssummarization/:classId", summarizationController.studentAccessSummarizationById);

//Lecturer summarize the transcription
router.post("/summarizetranscription", summarizationController.summarizeTranscription);

//Route to save summarization
router.put("/editsummarizedtext", summarizationController.editSummarization);

//Route to update publish status
router.put("/updatepublishstatus", summarizationController.updatePublishStatus);

//PUT API to add summarized text to the database
// Endpoint: /classrecording/savesummarizedtext
router.put("/savesummarizedtext", summarizationController.saveSummarization);

//Summary prompt route
router.get("/summaryprompt/:lecturerId", summarizationController.getSummaryPrompt);

//Save summary prompt route
router.post("/savesummaryprompt", summarizationController.saveSummaryPrompt);

module.exports = router;