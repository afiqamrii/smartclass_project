import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/shared/data/models/notifications/notification_models.dart';

class NotificationService {
  Future<int> getUnreadCount(String userId) async {
    final url =
        Uri.parse('${ApiConstants.baseUrl}/notification/unreadcount/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['count'] ?? 0;
    } else {
      throw Exception('Failed to fetch notification count');
    }
  }

  //Get all notifications
  Future<List<NotificationModel>> getNotifications(String userId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/notification/all/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((item) => NotificationModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }
}
