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

module.exports = {
  submitReport, 
  getReport
};
