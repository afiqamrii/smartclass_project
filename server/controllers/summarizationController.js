const summarizationService = require('../services/summarizationService');

// Function to view Summarization Status
exports.viewSummarizationStatus = async (req, res) => {
    try {
        const lecturerId = req.params.lecturerId;
        const summarizationData = await summarizationService.viewSummarizationStatus(lecturerId);

        res.status(200).json({
            message: "Summarization status fetched successfully",
            Data: summarizationData ?? [] // ✅ Ensure empty array if null
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch summarization status" });
    }
};

// Function to access summarization by class id
exports.accessSummarizationById = async (req, res) => {
    try{
        const {classId} = req.params

        const summarizationByIdResults = await summarizationService.accessSummarizationById(classId);

        // Response
        res.status(200).json({
            "Status_Code": 200,
            "Message": "Class Data Is Fetched Successfully",
            "Data": summarizationByIdResults
        });
    } catch(error){
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch summarization by class id" });
    }
};

// Function to access summarization by class id
exports.studentAccessSummarizationById = async (req, res) => {
    try{
        const {classId} = req.params

        const summarizationByIdResults = await summarizationService.studentAccessSummarizationById(classId);

        // Response
        res.status(200).json({
            "Status_Code": 200,
            "Message": "Class Data Is Fetched Successfully",
            "Data": summarizationByIdResults
        });
    } catch(error){
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch summarization by class id" });
    }
};

// Function to edit summarization
exports.editSummarization = async (req, res) => {
    try{

        //Debugging
        console.log("Received edit request:", req.body);

        const { summarizedText ,  classId  } = req.body;

        const result = await summarizationService.editSummarization(summarizedText, classId);

        res.status(200).json({ message: "Summarization data updated successfully", Updated_Id: result });
    } catch(error){
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to update summarization data" });
    }

};

exports.updatePublishStatus = async (req, res) => {
    try{
        //Debugging
        console.log("Received publish status update request:", req.body);

        const { publishStatus , classId} = req.body;

        const result = await summarizationService.updatePublishStatus(publishStatus, classId);
        res.status(200).json({ message: "Publish status updated successfully", Updated_Id: result });

    } catch(error){
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to update publish status" });
    }
}

exports.saveSummarization = async (req, res) => {
    try{
        //Debugging
        console.log("Received save summarization request:", req.body);

        const { summarizedText , recordingId , classId , recordingStatus} = req.body;

        const result = await summarizationService.saveSummarization(summarizedText, recordingId ,classId ,recordingStatus);
        res.status(200).json({ message: "Summarization saved successfully", Updated_Id: result });

    } catch(error){
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to save summarization" });
    }
}

// Function to summarize transcription
exports.summarizeTranscription = async (req, res) => {
  try {
    const { transcriptionText, prompt, recordingId, classId } = req.body;

    // Basic validation
    if (!transcriptionText || !recordingId || !classId) {
      return res.status(400).json({ message: 'Missing required fields: transcriptionText, recordingId, classId' });
    }

    // Call the service to perform the summarization
    const result = await summarizationService.getSummaryAndSave(transcriptionText, prompt, recordingId, classId);

    res.status(200).json({
      message: 'Summarization successful',
      data: result
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error during summarization',
      error: error.message
    });
  }
};

// Function to get summary prompt
exports.getSummaryPrompt = async (req, res) => {
    try {

        //Debug
        console.log("Received summary prompt request");

        //Get parameter lecturer id
        const lecturerId = req.params.lecturerId;
        // Call the service to get the summary prompt
        const summaryPrompt = await summarizationService.getSummaryPrompt(lecturerId);

        res.status(200).json({
            message: "Summary prompt fetched successfully",
            prompts: summaryPrompt || []  // return empty list if null
        });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to fetch summary prompt" });
    }
};

//Save summary prompt
exports.saveSummaryPrompt = async (req, res) => {
    try {

        //Debug
        console.log("Received save summary prompt request");
        console.log(req.body);
        
        const {lecturerId , prompt } = req.body;
        const result = await summarizationService.saveSummaryPrompt(prompt, lecturerId);
        res.status(200).json({ message: "Summary prompt saved successfully", Updated_Id: result });
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ message: "Failed to save summary prompt" });
    }
};
