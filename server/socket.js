global.connectedUsers = {};
const reportService = require('./services/reportService');


function setupSocket(io) {
  console.log('⏳ Initializing socket...');

  io.on('connection', (socket) => {
  console.log('A user connected');

  socket.on('identify', async (userId) => {
    global.connectedUsers = global.connectedUsers || {};
    global.connectedUsers[userId] = socket.id;
    socket.userId = userId; // Save for disconnect cleanup

    const count = await reportService.getNewReportCountByUser(userId);
    socket.emit('new_report_count', { count });
  });

  socket.on('disconnect', () => {
    console.log('User disconnected');
    // Remove user from global.connectedUsers
    if (socket.userId && global.connectedUsers[socket.userId] === socket.id) {
      delete global.connectedUsers[socket.userId];
    }
  });
});


  global._io = io;
}

module.exports = setupSocket;