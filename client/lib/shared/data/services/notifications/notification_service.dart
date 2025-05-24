import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/constants/api_constants.dart';

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
}
