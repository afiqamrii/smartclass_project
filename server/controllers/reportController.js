const reportService = require('../services/reportService');

const submitReport = async (req, res) => {
  const { title, description , classroomId ,  userId } = req.body;
  const imageFile = req.file;

  console.log('Received data:', req.body, req.file);

  if (!title || !description ) {
    return res.status(400).send('Title and description are required');
  }

  try {
    // Call service layer to handle image upload and saving data
    const imageUrl = await reportService.uploadImageToGCS(imageFile);
    if (!imageUrl) {
      return res.status(500).send('Failed to upload image');
    }
    const reportData = { title, description , classroomId, userId ,  imageUrl };

    const result = await reportService.saveReportToDB(reportData);
    return res.status(200).json({ message: 'Report saved successfully', result });
  } catch (error) {
    console.error('Error in submitReport:', error);
    return res.status(500).send('Error saving report');
  }
};

// Function to get all reports
// This function retrieves all reports from the database
const getReport = async (req, res) => {
  try {
    const reports = await reportService.getAllReports();
    return res.status(200).json({ message: 'Reports fetched successfully', reports });
  } catch (error) {
    console.error('Error in getReport:', error);
    return res.status(500).send('Error fetching reports');
  }
};

//Function to get report by ID
// This function retrieves a specific report by its ID from the database
const getReportById = async (req, res) => {
  const reportId = req.params.id;

  console.log('Received report ID:', reportId);

  if (!reportId) {
    return res.status(400).send('Report ID is required');
  }

  try {
    const report = await reportService.getReportById(reportId);
    if (!report) {
      return res.status(404).send('Report not found');
    }

    console.log('Fetched report:', report);
    return res.status(200).json({ message: 'Report fetched successfully', report });
    
  } catch (error) {
    console.error('Error in getReportById:', error);
    return res.status(500).send('Error fetching report');
  }
}

module.exports = {
  submitReport, 
  getReport,
  getReportById
};
