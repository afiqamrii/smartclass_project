import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/notifications/notification_provider.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  Widget getIcon(String type) {
    switch (type) {
      case 'UtilityIssueReport':
        return Image.asset(
          'assets/icons/check.png',
          width: 34,
          height: 34,
        );
      case 'Reminder':
        return const Icon(Icons.alarm_rounded);
      case 'System':
        return const Icon(Icons.settings_rounded);
      default:
        return const Icon(Icons.notifications_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationAsyncValue = ref.watch(notificationProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: notificationAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (notifications) {
          if (notifications.isEmpty) {
            return const Center(
              child: Text(
                'No notifications yet.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notif = notifications[index];
              final isRead = notif.isRead.toLowerCase() == 'Unread';

              return Dismissible(
                key: Key(
                  notif.id.toString(),
                ),
                direction: DismissDirection.horizontal,
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.mark_email_read,
                        color: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Mark as Read",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                secondaryBackground: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.centerRight,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Text("Delete", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    // Swipe left to delete
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Delete Notification"),
                        content: const Text(
                            "Are you sure you want to delete this notification?"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Cancel")),
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Delete")),
                        ],
                      ),
                    );
                  } else {
                    // Swipe right to mark as read
                    // TODO: Implement mark as read logic (e.g. API call or state update)
                    setState(() {
                      // Update state to mark as read
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Marked as read')),
                    );
                    return false; // prevent dismissal
                  }
                },
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    // TODO: Remove notification from state or call delete API
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isRead ? Colors.grey.shade100 : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    leading: getIcon(notif.type),
                    title: Text(
                      notif.title,
                      style: TextStyle(
                        fontWeight: isRead ? FontWeight.w400 : FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          notif.message,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notif.formattedDate,
                          style:
                              const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: !isRead
                        ? const Icon(Icons.fiber_manual_record,
                            color: Colors.redAccent, size: 12)
                        : null,
                    onTap: () {
                      // Optional: navigation or other logic
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "Notifications",
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
