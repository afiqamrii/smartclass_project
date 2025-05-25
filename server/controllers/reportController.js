const reportService = require('../services/reportService');
const NotificationService = require('../services/Notifications/notificationsService');


const submitReport = async (req, res) => {
  const { title, description , classroomId ,  userId } = req.body;
  const imageFile = req.file;

  console.log('Received data:', req.body, req.file);

  if (!title || !description ) {
    return res.status(400).send('Title and description are required');
  }

  // Get current date in UTC+8
  const currentDate = new Date();
  const offsetMs = 8 * 60 * 60 * 1000; // 8 hours in ms
  const localDate = new Date(currentDate.getTime() + offsetMs);

  const formattedDate = localDate.toISOString().split('T')[0];
  const formattedTime = localDate.toISOString().split('T')[1].split('.')[0];
  const timeStamp = `${formattedDate} ${formattedTime}`;

  console.log('Current date and time:', timeStamp);

  try {
    // Call service layer to handle image upload and saving data
    const imageUrl = await reportService.uploadImageToGCS(imageFile);
    if (!imageUrl) {
      return res.status(500).send('Failed to upload image');
    }
    const reportData = { title, description , classroomId, userId ,  imageUrl , timeStamp };

    const result = await reportService.saveReportToDB(reportData);

    // Emit updated new report count after adding new report
    const count = await reportService.getNewReportCount();
    if (global._io) {
      global._io.emit('new_report_count', { count });
      console.log('📡 Emitted updated new_report_count after submitReport:', count);
    }
    
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

// Function to update report by ID
// This function updates a specific report by its ID in the database
const updateReportStatus = async (req, res) => {
  const reportId = req.params.id;
  const userId = req.params.userId;

  if (!reportId) {
    return res.status(400).send('Report ID is required');
  }

  try {
    // Update report status
    const updatedReport = await reportService.updateReportStatus(reportId);
    if (!updatedReport) {
      return res.status(404).send('Report not found');
    }

    // Store notification in database (via notification service)
    await NotificationService.createNotification(
      userId,
      'Report Solved (Report ID: ' + reportId + ')',
      'Your reported issue has been solved!',
      `UtilityIssueReport`,
      reportId
    );

    // Emit report count update
    const count = await NotificationService.getUnreadCount(userId);

    //Print notification count
    console.log('Notification count:', count);

    if (global._io) {
      global._io.emit('new_notification_count', { count });
    }

    // Emit real-time notification to the user
    const socketId = global.connectedUsers?.[userId];
    if (socketId) {
      global._io.to(socketId).emit('report_solved', {
        reportId,
        message: 'Your reported issue has been solved!',
      });

      // Optionally emit a real-time notification event
      global._io.to(socketId).emit('new_notification', {
        type: 'report',
        message: `Your report ID ${reportId} has been resolved!`
      });
    }

    return res.status(200).json({ message: 'Report updated successfully', updatedReport });
  } catch (error) {
    console.error('Error in updateReportStatus:', error);
    return res.status(500).send('Error updating report');
  }
};


// const updateReportStatus = async (req, res) => {
//   // Implement the logic to update a report by ID
//   const reportId = req.params.id;
  
//   console.log('Received report ID for update:', reportId);
//   if (!reportId) {
//     return res.status(400).send('Report ID is required');
//   }

//   try {
//     const updatedReport = await reportService.updateReportStatus(reportId);
//     if (!updatedReport) {
//       return res.status(404).send('Report not found');
//     }

//     console.log('Updated report:', updatedReport);
//     return res.status(200).json({ message: 'Report updated successfully', updatedReport });
//   }
//   catch (error) {
//     console.error('Error in updateReportStatus:', error);
//     return res.status(500).send('Error updating report');
//   }
// };

// Function to get report by user ID
// This function retrieves all reports submitted by a specific user from the database
const getReportByUserId = async (req, res) => {
  const userId = req.params.userId;

  console.log('Received user ID:', userId);

  if (!userId) {
    return res.status(400).send('User ID is required');
  }

  try {
    const reports = await reportService.getReportByUserId(userId);
    if (!reports || reports.length === 0) {
      return res.status(404).send('No reports found for this user');
    }

    console.log('Fetched reports for user:', reports);
    return res.status(200).json({ message: 'Reports fetched successfully', reports });
    
  } catch (error) {
    console.error('Error in getReportByUserId:', error);
    return res.status(500).send('Error fetching reports');
  }
}

//Function to update report by ID
// This function updates the status of a specific report by its ID in the database
const updateReport = async (req, res) => {
  const { title, description , classroomId ,  userId } = req.body;
  const imageFile = req.file;

  console.log('Received data:', req.body, req.file);

  if (!title || !description ) {
    return res.status(400).send('Title and description are requireds');
  }

  try {
    // Call service layer to handle image upload and saving data
    const imageUrl = await reportService.uploadImageToGCS(imageFile);
    if (!imageUrl) {
      return res.status(500).send('Failed to upload image');
    }
    const reportData = { title, description , classroomId, userId ,  imageUrl };

    const result = await reportService.updateReport(req.params.id,reportData);
    return res.status(200).json({ message: 'Report saved successfully', result });
  } catch (error) {
    console.error('Error in submitReport:', error);
    return res.status(500).send('Error saving report');
  }
};

//Function to update report without image
// This function updates a specific report by its ID in the database
const updateReportWithoutImage = async (req, res) => {
  const { title, description, classroomId, userId } = req.body;

  console.log('Received data for update no image:', req.body);

  if (!title || !description) {
    return res.status(400).send('Title and description are required');
  }

  try {
    const reportData = { title, description, classroomId, userId };
    const result = await reportService.updateReportWithImage(req.params.id, reportData);

    return res.status(200).json({ message: 'Report updated successfully', result });
  } catch (error) {
    console.error('Error in updateReport:', error);
    return res.status(500).send('Error updating report');
  }
}

const getNewReportCount = async (req, res) => {
  try {
    const count = await reportService.getNewReportCount();
    res.json({ count });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const markAsRead = async (req, res) => {
  try {
    await reportService.markAsRead();

    // Emit updated count
    const count = await reportService.getNewReportCount();
    if (global._io) {
      global._io.emit('new_report_count', { count });
      console.log('📡 Emitted updated new_report_count after markAsRead:', count);
    }

    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};




// Exporting the functions to be used in routes
module.exports = {
  submitReport, 
  getReport,
  getReportById,
  updateReportStatus,
  getReportByUserId,
  updateReport,
  updateReportWithoutImage,
  getNewReportCount,
  markAsRead
};
