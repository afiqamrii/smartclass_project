import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badges;
import 'package:smartclass_fyp_2024/main.dart';
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

    // Remove any old listeners
    socket.off('new_notification_count_student');
    socket.off('new_notification_count_lecturer');
    socket.off('new_enrollment_request'); // Clean up first

    final roleBasedEvent = user.roleId == 1
        ? 'new_notification_count_student'
        : user.roleId == 2
            ? 'new_notification_count_lecturer'
            : 'new_notification_count_admin';

    socket.on(roleBasedEvent, (data) {
      if (!mounted) return;
      ref.invalidate(unreadNotificationCountProvider);
    });

    // ✅ Listen for enrollment request alert if user is lecturer
    if (user.roleId == 2) {
      socket.on('new_enrollment_request', (data) {
        if (!mounted) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showEnrollmentNotification(
            data,
          ); // Use notification instead of dialog
        });
      });
    }
  }

  @override
  void dispose() {
    socket.off('new_notification_count');
    socket.off('new_enrollment_request');
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
          final total = unreadCount;

          return badges.Badge(
            position: badges.BadgePosition.topEnd(top: -0, end: -0),
            showBadge: total > 0,
            badgeContent: Text(
              total.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: () {
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
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
        error: (err, _) => IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {},
        ),
      ),
    );
  }
}


// Function to show a custom notification for enrollment requests
Future<void> _showEnrollmentNotification(dynamic data) async {
  final studentId = data['studentId'] ?? 'Unknown';
  final courseId = data['courseId'] ?? 'Unknown';

  // Vibration pattern (milliseconds): wait 0, vibrate 1000, pause 500, vibrate 2000
  final Int64List vibrationPattern = Int64List.fromList([0, 1000, 500, 2000]);

  // Note: You need to place your custom sound file (e.g., notification.wav) inside
  // android/app/src/main/res/raw/ folder.
  // If the 'raw' folder doesn't exist, create it.
  // const String soundName = 'notification'; // without extension

  final androidDetails = AndroidNotificationDetails(
    'enrollment_channel', // channel ID
    'Enrollment Requests', // channel name
    channelDescription: 'Notifications for new enrollment requests',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    enableLights: true,
    ledColor: const Color(0xFF673AB7), // deep purple led light
    ledOnMs: 1000,
    ledOffMs: 500,
    vibrationPattern: vibrationPattern,
    enableVibration: true,
    sound: const RawResourceAndroidNotificationSound('notification'),
    styleInformation: BigTextStyleInformation(
      'Student $studentId requested to enroll in course $courseId',
      htmlFormatBigText: true,
    ),
    // Optional: Add a large icon if you have one in drawable resources
    largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    color: const Color(0xFF673AB7), // Notification color tint
  );

  final platformDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0, // notification ID
    'New Enrollment Request',
    'Student $studentId requested to enroll in course $courseId',
    platformDetails,
  );
}
