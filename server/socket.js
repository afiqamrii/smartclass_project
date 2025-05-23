global.connectedUsers = {};
const reportService = require('./services/reportService');


function setupSocket(io) {
  console.log('⏳ Initializing socket...');

  io.on('connection', (socket) => {
  console.log('A user connected');

  socket.on('identify', async (userId) => {
    // Store socket ID for the user in global map
    global.connectedUsers = global.connectedUsers || {};
    global.connectedUsers[userId] = socket.id;

    // Get unread report count for this user
    const count = await reportService.getNewReportCountByUser(userId);

    // Emit count only to this user's socket
    socket.emit('new_report_count', { count });
  });

  socket.on('disconnect', () => {
    console.log('User disconnected');
    // Optionally remove from global.connectedUsers
  });
});


  global._io = io;
}

module.exports = setupSocket;