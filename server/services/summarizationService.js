const summarizationModel = require("../models/summarizationModels");

// Function to view Summarization Status
const viewSummarizationStatus = async (lecturerId) => {
    try{
        const summarizationStatus = await summarizationModel.getSummarizationStatus(lecturerId);
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

// Function for student to access summarization by class id
const studentAccessSummarizationById = async (classId) => {
    try{
        const summarizationByIdResults = await summarizationModel.studentAccessSummarizationById(classId);
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

const saveSummarization = async (summarizedText, recordingId ,classId ,recordingStatus) => {
    try{
        const result = await summarizationModel.saveSummarization(summarizedText, recordingId ,classId ,recordingStatus);
        return result || []; // To ensure not return as null 
    } catch(error){
        throw new Error("Error in service while saving summarization: " + error.message);
    }   
}

//Export module
module.exports = { viewSummarizationStatus  , accessSummarizationById , editSummarization , updatePublishStatus, saveSummarization , studentAccessSummarizationById };