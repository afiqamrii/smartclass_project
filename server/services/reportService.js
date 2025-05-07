const { Storage } = require('@google-cloud/storage');
const reportModel = require('../models/reportModel'); // Import the model here
const axios = require('axios');
const FormData = require('form-data');


// Function to upload image to GCS
const express = require('express');
const { GoogleAuth } = require('google-auth-library');
const router = express.Router();
const storage = new Storage();
require("dotenv").config();
const bucketName = process.env.bucketName; // Set your GCS bucket name in environment variables
const path = require('path');

// GoogleAuth setup for getting access tokens
const auth = new GoogleAuth({
  keyFile: 'gcs-service-account.json', // Use your Google Cloud Service Account
  scopes: ['https://www.googleapis.com/auth/devstorage.read_write'],
});

async function getBearerToken() {
  try {
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
};

const uploadImageToGCS = async (imageFile) => {
  try {
    const accessToken = await getBearerToken(); // Get the access token

    const gcsFileName = `reports/${Date.now()}_${imageFile.originalname}`;
    const uploadUrl = `${process.env.gcsStorageUrl}/${process.env.bucketName}/o?uploadType=multipart&name=${encodeURIComponent(gcsFileName)}`;

    // Construct the multipart form data request
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

    console.log('Image uploaded successfully:', imageUrl);
  } catch (error) {
    console.error('Error uploading image to GCS:', error.response?.data || error.message);
    throw new Error('Failed to upload image');
  }
};

  

// Function to save report data to MySQL database
const saveReportToDB = async (reportData) => {
    try {
        
        const result = await reportModel.createReport(reportData);
        return result;
    } catch (error) {
        console.error('Error saving report to DB:', error);
        throw new Error('Failed to save report to database');
    }
};

module.exports = {
  uploadImageToGCS,
  saveReportToDB,
};
