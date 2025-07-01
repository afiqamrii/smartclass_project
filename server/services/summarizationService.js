const summarizationModel = require("../models/summarizationModels");
const axios = require('axios');


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


const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
const GEMINI_API_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`;

// Function to call Gemini API
async function callGeminiApi(text, customPrompt) {
  // Use the custom prompt if provided, otherwise use a default
  const prompt = customPrompt || "Summarize this text in a simpler and easy-to-understand paragraph. Elaborate on the important parts using bullet points:";

  const payload = {
    contents: [{
      parts: [{
        text: `${prompt}\n\n${text}`
      }]
    }],
    generationConfig: {
      maxOutputTokens: 4096
    }
  };

  try {
    const response = await axios.post(GEMINI_API_URL, payload, {
      headers: { 'Content-Type': 'application/json' }
    });
    // Extract the summarized text from the response
    return response.data.candidates[0].content.parts[0].text;
  } catch (error) {
    console.error('Error calling Gemini API:', error.response ? error.response.data : error.message);
    throw new Error('Failed to get summary from Gemini API.');
  }
}

// Main service function
async function getSummaryAndSave (transcriptionText, prompt, recordingId, classId) {
  // 1. Get the summary from Gemini
  const summarizedText = await callGeminiApi(transcriptionText, prompt);

  //Debug summarized text
  console.log("Summarized Text:", summarizedText);

  //Debug attribute sending to model
    console.log("Recording ID:", recordingId);
    console.log("Class ID:", classId);

    if (!summarizedText) {
        throw new Error('Failed to generate summary from transcription text.');
    }


  // 2. Save the summary to your database
  // The model function will handle the actual database query
  const result = await summarizationModel.saveSummarization(
    summarizedText,
    recordingId,
    classId,
    'Summarized'
  );

  return result;
};

// Function to get summary prompt
const getSummaryPrompt = async (lecturerId) => {
    try{
        const summaryPrompt = await summarizationModel.getSummaryPrompt(lecturerId);
        return summaryPrompt || []; // To ensure not return as null 
    } catch(error){
        throw new Error("Error in service while fetching summary prompt: " + error.message);
    }
};

// Function to save summary prompt
const saveSummaryPrompt = async (prompt, lecturerId) => {
    try{
        const result = await summarizationModel.saveSummaryPrompt(prompt, lecturerId);
        return result || []; // To ensure not return as null 
    } catch(error){
        throw new Error("Error in service while saving summary prompt: " + error.message);
    }
};

//Export module
module.exports = { viewSummarizationStatus  , accessSummarizationById , editSummarization , updatePublishStatus, saveSummarization , studentAccessSummarizationById, getSummaryAndSave, getSummaryPrompt, callGeminiApi, saveSummaryPrompt };