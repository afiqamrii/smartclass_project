import 'package:intl/intl.dart';

class NotificationModel {
  final int id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final String isRead;
  final String createdAt;
  final int relatedId;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.relatedId,
  });

  // Convert a JSON to a NotificationModel
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['idNotifications'],
      userId: json['userId'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      isRead: json['is_read'],
      createdAt: json['created_at'],
      relatedId: json['related_id'],
    );
  }

  /// 🕒 Formatted date string
  String get formattedDate {
    try {
      final parsedDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(createdAt);
      return DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);
    } catch (_) {
      return createdAt;
    }
  }
}
