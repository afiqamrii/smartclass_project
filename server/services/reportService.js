const { Storage } = require('@google-cloud/storage');
const reportModel = require('../models/reportModel');
const axios = require('axios');
const FormData = require('form-data');
const { GoogleAuth } = require('google-auth-library');
require("dotenv").config();
const path = require('path');

let credentials;
let auth;

// Initialize GoogleAuth with credentials from environment variable (same as gcsTokenRoute.js)
if (process.env.GOOGLE_APPLICATION_CREDENTIALS_JSON) {
  credentials = JSON.parse(process.env.GOOGLE_APPLICATION_CREDENTIALS_JSON);

  // Fix formatting of private_key by replacing escaped newlines
  if (credentials.private_key) {
    credentials.private_key = credentials.private_key.replace(/\\n/g, '\n');
  }

  auth = new GoogleAuth({
    scopes: ['https://www.googleapis.com/auth/devstorage.read_write'],
  });

  // Load the credentials into the auth instance
  (async () => {
    try {
      await auth.fromJSON(credentials);
    } catch (error) {
      console.error("Failed to initialize GoogleAuth with provided credentials:", error);
    }
  })();
} else {
  console.error("GOOGLE_APPLICATION_CREDENTIALS_JSON environment variable is missing.");
}

async function getBearerToken() {
  try {
    if (!auth) throw new Error('GoogleAuth is not initialized.');
    const client = await auth.getClient();
    const accessTokenResponse = await client.getAccessToken();

    if (!accessTokenResponse || !accessTokenResponse.token) {
      throw new Error('Failed to get access token');
    }
    return accessTokenResponse.token;
  } catch (error) {
    console.error('Error fetching access token:', error);
    throw error;
  }
}

const uploadImageToGCS = async (imageFile) => {
  try {
    const accessToken = await getBearerToken();

    const gcsFileName = `reports/${Date.now()}_${imageFile.originalname}`;
    const uploadUrl = `${process.env.gcsStorageUrl}/${process.env.bucketName}/o?uploadType=multipart&name=${encodeURIComponent(gcsFileName)}`;

    const form = new FormData();
    form.append('metadata', JSON.stringify({
      name: gcsFileName,
      contentType: imageFile.mimetype,
    }), {
      contentType: 'application/json',
    });
    form.append('media', imageFile.buffer, {
      filename: imageFile.originalname,
      contentType: imageFile.mimetype,
    });

    const response = await axios.post(uploadUrl, form, {
      headers: {
        ...form.getHeaders(),
        Authorization: `Bearer ${accessToken}`,
      },
    });

    const imageUrl = `https://storage.googleapis.com/${process.env.bucketName}/${gcsFileName}`;
    return imageUrl;
  } catch (error) {
    console.error('Error uploading image to GCS:', error.response?.data || error.message);
    throw new Error('Failed to upload image');
  }
};

const saveReportToDB = async (reportData) => {
  try {
    const result = await reportModel.createReport(reportData);
    return result;
  } catch (error) {
    console.error('Error saving report to DB:', error);
    throw new Error('Failed to save report to database');
  }
};

// Function to get all reports
const getAllReports = async () => {
  try {
    const results = await reportModel.getAllReports();
    return results;
  } catch (error) {
    console.error('Error fetching reports:', error);
    throw new Error('Failed to fetch reports');
  }
};

//Function to get report by ID
// This function retrieves a specific report by its ID from the database
const getReportById = async (reportId) => {
  try {
    const result = await reportModel.getReportById(reportId);
    return result;
  } catch (error) {
    console.error('Error fetching report by ID:', error);
    throw new Error('Failed to fetch report by ID');
  }
};

// Function to update report by ID
// This function updates the status of a specific report by its ID in the database
const updateReportStatus = async (reportId) => {
  try {
    const result = await reportModel.updateReportStatus(reportId);
    return result;
  } catch (error) {
    console.error('Error updating report status:', error);
    throw new Error('Failed to update report status');
  }
};

// Function to get report by user ID
// This function retrieves all reports submitted by a specific user from the database
const getReportByUserId = async (userId) => {
  try {
    const result = await reportModel.getReportByUserId(userId);
    return result;
  } catch (error) {
    console.error('Error fetching report by user ID:', error);
    throw new Error('Failed to fetch report by user ID');
  }
};

//Function to update report by ID
// This function updates a specific report by its ID in the database
const updateReport = async (reportId, reportData) => {
  try {
    const result = await reportModel.updateReport(reportId, reportData);
    return result;
  } catch (error) {
    console.error('Error updating report:', error);
    throw new Error('Failed to update report');
  }
};

//Function to update report by ID with image
// This function updates a specific report by its ID in the database
const updateReportWithImage = async (reportId, reportData) => {
  try {
    const result = await reportModel.updateReportWithoutIMage(reportId, reportData);
    return result;
  } catch (error) {
    console.error('Error updating report with image:', error);
    throw new Error('Failed to update report with image');
  }
}

// Report notification
const getNewReportCount = async () => {
  try {
    const result = await reportModel.getNewReportCount();
    return result;
  } catch (error) {
    console.error('Error fetching new report count:', error);
    throw new Error('Failed to fetch new report count');
  }
};

// Get latest report id
const getLatestReportId = async () => {
  try {
    const result = await reportModel.getLatestReportId();
    return result;
  } catch (error) {
    console.error('Error fetching latest report ID:', error);
    throw new Error('Failed to fetch latest report ID');
  }
};

//Function to count report by user id
const getNewReportCountByUser = async (userId) => {
  try {
    const result = await reportModel.getNewReportCountByUser(userId);
    return result;
  } catch (error) {
    console.error('Error fetching new report count by user ID:', error);
    throw new Error('Failed to fetch new report count by user ID');
  }
  
};

// Function to mark reports as read
const markAsRead = async (reportIds) => {
  try {
    const result = await reportModel.markAsRead(reportIds);
    return result;
  } catch (error) {
    console.error('Error marking reports as read:', error);
    throw new Error('Failed to mark reports as read');
  }
};

// Exporting the functions to be used in other parts of the application
module.exports = {
  uploadImageToGCS,
  saveReportToDB,
  getAllReports,
  getReportById,
  updateReportStatus,
  getReportByUserId,
  updateReport,
  updateReportWithImage,
  getNewReportCount,
  markAsRead,
  getLatestReportId,
  getNewReportCountByUser
};