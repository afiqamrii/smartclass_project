const express = require("express");
const summarizationController = require("../controllers/summarizationController");

const router = express.Router();

// Route to view Summarization Status
router.get("/viewSummarizationStatus", summarizationController.viewSummarizationStatus);

// Route to access summarization by class id
router.get("/accesssummarization/:classId", summarizationController.accessSummarizationById);

//Route to save summarization
router.put("/editsummarizedtext", summarizationController.editSummarization);

//Route to update publish status
router.put("/updatepublishstatus", summarizationController.updatePublishStatus);

module.exports = router;