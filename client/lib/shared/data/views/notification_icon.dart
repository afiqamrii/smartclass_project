import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badges;
import 'package:smartclass_fyp_2024/shared/WebSocket/provider/socket_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:smartclass_fyp_2024/features/student/notification.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/notifications/notification_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';

class NotificationIcon extends ConsumerStatefulWidget {
  const NotificationIcon({super.key});

  @override
  ConsumerState<NotificationIcon> createState() => _NotificationIconState();
}

class _NotificationIconState extends ConsumerState<NotificationIcon> {
  late IO.Socket socket;
  int _newSocketReports = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() => _setupSocket());
    // or:
    // WidgetsBinding.instance.addPostFrameCallback((_) => _setupSocket());
  }

  void _setupSocket() {
    final user = ref.read(userProvider);
    final socketService = ref.read(socketServiceProvider.notifier);
    socketService.init(user.externalId); // modifies provider state

    socket = ref.read(socketServiceProvider)!;
    socket.on('new_notification_count', (data) {
      setState(() {
        _newSocketReports = data['count'];
      });
    });

    // socket.on('report_solved', (data) {
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: const Text('Report Update'),
    //       content: Text(data['message']),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.of(context).pop(),
    //           child: const Text('OK'),
    //         )
    //       ],
    //     ),
    //   );
    // });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final asyncNotificationCount = ref.watch(unreadNotificationCountProvider);

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: asyncNotificationCount.when(
        data: (unreadCount) {
          final total = unreadCount + _newSocketReports;
          return badges.Badge(
            showBadge: total > 0,
            badgeContent: Text(
              total.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                setState(() {
                  _newSocketReports = 0;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RealTimeNotification(
                      currentUserId: user.externalId,
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (err, _) => IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {},
        ),
      ),
    );
  }
}
