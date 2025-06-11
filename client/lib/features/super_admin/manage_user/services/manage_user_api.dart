import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
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

  //Get all users by id
  static Future<List<UserModels>> fetchUsersById(String token , int userId  ) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/superadmin/getallusers/$userId'),
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

  //Disable user account
  static Future<void> disableUserAccount(int userId, String token,
      BuildContext context, String email, String status) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/superadmin/disableuser/$userId'),
        headers: {
          'x-auth-token': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'user_email': email, 'status': status}),
      );

      // print(response.body);

      if (response.statusCode == 200) {
        await Flushbar(
          message: 'User account disabled successfully!',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green.shade600,
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
        ).show(context);
        // Navigator.pop(context);
      } else {
        final jsonData = jsonDecode(response.body);
        final error = jsonData['error'] ?? 'Failed to disable user account.';
        await Flushbar(
          message: error,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red.shade600,
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(
            Icons.error,
            color: Colors.white,
          ),
        ).show(context);
      }
    } catch (e) {
      throw Exception(
        e is Exception
            ? e.toString().replaceFirst('Exception: ', '')
            : 'Could not disable user account now. Please try again later.',
      );
    }
  }
}
