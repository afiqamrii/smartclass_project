import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badges;
import 'package:smartclass_fyp_2024/shared/WebSocket/provider/socket_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/views/notifications/notification_page.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
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
  bool _hasSocketUpdate = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _setupSocket());
  }

  void _setupSocket() {
    final user = ref.read(userProvider);
    final socketService = ref.read(socketServiceProvider.notifier);
    socketService.init(user.externalId);

    socket = ref.read(socketServiceProvider)!;

    socket.off('new_notification_count');
    socket.on('new_notification_count', (data) {
      if (!mounted) return;
      setState(() {
        _newSocketReports = data['count'];
        _hasSocketUpdate = true; // Switch to using socket count after update
      });
    });
  }

  @override
  void dispose() {
    socket.off('new_notification_count');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(userProvider);
    final asyncNotificationCount = ref.watch(unreadNotificationCountProvider);

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: asyncNotificationCount.when(
        data: (unreadCount) {
          final total = _hasSocketUpdate ? _newSocketReports : unreadCount;

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
                  _hasSocketUpdate = false; // Reset to allow next socket update
                });
                Navigator.push(
                  context,
                  toLeftTransition(
                    const NotificationPage(),
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
