const summarizationModel = require("../models/summarizationModels");

// Function to view Summarization Status
const viewSummarizationStatus = async () => {
    try{
        const summarizationStatus = await summarizationModel.getSummarizationStatus();
        return summarizationStatus || [];
    } catch(error){
        throw new Error("Error in service while fetching summarization status: " + error.message);
    }
};

// Function to access summarization by class id
const accessSummarizationById = async (classId) => {
    try{
        const summarizationByIdResults = await summarizationModel.getSummarizationById(classId);
        return summarizationByIdResults || [];
    } catch(error){
        throw new Error("Error in service while fetching summarization by class id: " + error.message);
    }
};

//Fuunction to edit summarization
const editSummarization = async (summarizedText, classId) => {
    try{
        const result = await summarizationModel.editSummarization(summarizedText, classId);
        return result || []; // To ensure not return as null 
    } catch(error){
        throw new Error("Error in service while updating summarization data: " + error.message);
    }
};

const updatePublishStatus = async (publishStatus , classId) => {
    try{
        

        const result = await summarizationModel.updatePublishStatus(publishStatus, classId);
        return result || []; // To ensure not return as null
    
    } catch(error){
        throw new Error("Error in service while updating publish status: " + error.message);
    }
}

//Export module
module.exports = { viewSummarizationStatus  , accessSummarizationById , editSummarization , updatePublishStatus };