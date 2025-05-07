const reportService = require('../services/reportService');

const submitReport = async (req, res) => {
  const { title, description } = req.body;
  const imageFile = req.file;

  console.log('Received data:', req.body, req.file);

  if (!title || !description || !imageFile) {
    return res.status(400).send('Title, description, and image are required');
  }

  try {
    // Call service layer to handle image upload and saving data
    const imageUrl = await reportService.uploadImageToGCS(imageFile);
    if (!imageUrl) {
      return res.status(500).send('Failed to upload image');
    }
    const reportData = { title, description, imageUrl };

    const result = await reportService.saveReportToDB(reportData);
    return res.status(200).json({ message: 'Report saved successfully', result });
  } catch (error) {
    console.error('Error in submitReport:', error);
    return res.status(500).send('Error saving report');
  }
};

module.exports = {
  submitReport,
};
