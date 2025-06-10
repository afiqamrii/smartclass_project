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

