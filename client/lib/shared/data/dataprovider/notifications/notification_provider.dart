import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/notifications/notification_models.dart';
import 'package:smartclass_fyp_2024/shared/data/services/notifications/notification_service.dart';

// Provide NotificationService instance
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

// FutureProvider to get unread notification count
final unreadNotificationCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final user = ref.watch(userProvider); // assuming userProvider holds the current user
  if (user.externalId.isEmpty) return 0;

  final notificationService = ref.read(notificationServiceProvider);
  return await notificationService.getUnreadCount(user.externalId);
});

//Get all notifications
final notificationProvider = FutureProvider.autoDispose<List<NotificationModel>>((ref) async {
  final user = ref.watch(userProvider); // assuming userProvider holds the current user
  if (user.externalId.isEmpty) return [];
  final notificationService = ref.read(notificationServiceProvider);
  return await notificationService.getNotifications(user.externalId);
});
