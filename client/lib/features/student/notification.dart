import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:badges/badges.dart' as badges;

class RealTimeNotification extends StatefulWidget {
  final String currentUserId; // Pass this user ID when you create the widget

  RealTimeNotification({required this.currentUserId});

  @override
  _RealTimeNotificationState createState() => _RealTimeNotificationState();
}

class _RealTimeNotificationState extends State<RealTimeNotification> {
  int _newReports = 0;
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();

    // Setup the Socket.IO client
    socket = IO.io(
      'http://192.168.0.99:3000',
      IO.OptionBuilder()
          .setTransports(['websocket']) // required for Flutter
          .disableAutoConnect() // manually control connection
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print('✅ Socket connected');
      // Identify the user to the server by sending userId
      socket.emit('identify', widget.currentUserId);
    });

    socket.onDisconnect((_) => print('❌ Socket disconnected'));
    socket.onError((data) => print('⚠️ Socket error: $data'));

    // Listen for new report count (existing feature)
    socket.on('new_notification_count', (data) {
      setState(() {
        _newReports = data['count'];
      });
    });

    // Listen for 'report_solved' notifications targeted to this user
    socket.on('report_solved', (data) {
      print('📢 Report Solved Notification: ${data['message']}');

      // Show an alert dialog to notify the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Report Update'),
          content: Text(data['message']),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            )
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-Time Notification'),
      ),
      body: Center(
        child: IconButton(
          icon: badges.Badge(
            showBadge: _newReports > 0,
            badgeContent: Text('$_newReports',
                style: TextStyle(color: Colors.white, fontSize: 10)),
            child: Icon(Icons.notifications),
          ),
          onPressed: () {
            // Open reports page or clear badge
            setState(() {
              _newReports = 0;
            });
          },
        ),
      ),
    );
  }
}
