import 'dart:convert';
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/super_admin/manage_user/models/user_models.dart';
import 'package:http/http.dart' as http;

class ManageUserApi {
  // Pass the token as a parameter or get it from your user/session storage
  static Future<List<UserModels>> fetchUsers(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/superadmin/getallusers'),
      headers: {
        'x-auth-token':
            token, // Pass the token as a header to verify authentication for super admin
        'Content-Type': 'application/json',
      },
    );

    //Debug
    // print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (jsonData.containsKey('Data') && jsonData['Data'] is List) {
        return (jsonData['Data'] as List)
            .map((course) => UserModels.fromJson(course))
            .toList();
      } else {
        throw Exception(
            'Invalid JSON structure: "Data" key not found or not a list');
      }
    } else {
      throw Exception('Failed to load users');
    }
  }

  //Get all pending approval
  static Future<List<UserModels>> fetchPendingApproval(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/superadmin/getallpendingapprovals'),
      headers: {
        'x-auth-token':
            token, // Pass the token as a header to verify authentication for super admin
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (jsonData.containsKey('Data') && jsonData['Data'] is List) {
        return (jsonData['Data'] as List)
            .map((course) => UserModels.fromJson(course))
            .toList();
      } else {
        throw Exception(
            'Invalid JSON structure: "Data" key not found or not a list');
      }
    } else {
      throw Exception('Failed to load users');
    }
  }
}
