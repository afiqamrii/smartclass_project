import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:smartclass_fyp_2024/shared/WebSocket/provider/socket_provider.dart';
import 'package:badges/badges.dart' as badges;

class RealTimeNotification extends ConsumerStatefulWidget {
  final String currentUserId;

  RealTimeNotification({required this.currentUserId});

  @override
  ConsumerState<RealTimeNotification> createState() =>
      _RealTimeNotificationState();
}

class _RealTimeNotificationState extends ConsumerState<RealTimeNotification> {
  int _newReports = 0;
  IO.Socket? socket;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _setupSocket());
  }

  void _setupSocket() {
    final socketService = ref.read(socketServiceProvider.notifier);
    socketService.init(widget.currentUserId);

    socket = ref.read(socketServiceProvider);
    if (socket == null) return;

    // Remove and re-add listeners (safe way to prevent duplicates)
    socket!.off('new_notification_count');
    socket!.on('new_notification_count', (data) {
      if (!mounted) return;
      setState(() {
        _newReports = data['count'];
      });
    });

    socket!.off('report_solved');
    socket!.on('report_solved', (data) {
      if (!mounted) return;
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
    // DO NOT CALL socket.dispose() or disconnect the global socket here
    socket?.off('new_notification_count');
    socket?.off('report_solved');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Real-Time Notification')),
      body: Center(
        child: IconButton(
          icon: badges.Badge(
            showBadge: _newReports > 0,
            badgeContent: Text(
              '$_newReports',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            child: Icon(Icons.notifications),
          ),
          onPressed: () {
            setState(() {
              _newReports = 0;
            });
          },
        ),
      ),
    );
  }
}
