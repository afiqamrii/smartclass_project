import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/admin/control_utility/models/utility_models.dart';

class UtilityService {
  //Add new utility
  static Future<void> addUtility(
      String deviceName,
      String selectedType,
      int classroomId,
      String classdevId,
      String esp32Id,
      BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/utility/addUtility'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': deviceName,
          'group_developer_id': classdevId,
          'classroomId': classroomId,
          'utilityType': selectedType,
          'esp32_id': esp32Id,
        }),
      );

      // Debugging: Print the response status code and body
      //Print sending data
      // print('UtilityService: Sending data to add utility');
      // print('UtilityService: Device Name: $deviceName');
      // print('UtilityService: Selected Type: $selectedType');
      // print('UtilityService: Response status code: ${response.statusCode}');
      // print('UtilityService: Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('UtilityService: Utility added successfully');
        // Show a success message, then pop after it is dismissed
        await Flushbar(
          message: 'Utility $deviceName added successfully!',
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(
            Icons.check, // Use check icon for success
            color: Colors.white,
          ),
        ).show(context);

        // Now pop after Flushbar is dismissed
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        final errorMsg = jsonDecode(response.body)['error'];
        Flushbar(
          message: errorMsg,
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 3),
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
      // print('Error adding utility: $e');
      Flushbar(
        message: 'Failed to add utility',
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
      ).show(context);
    }
  }

  //Fetch all utilities
  static Future<List<UtilityModels>> fetchUtility(int classroomId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/utility/getUtility/$classroomId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      // //Debug
      // print('UtilityService: Fetched utilities for classroom ID $classroomId');
      // print('UtilityService: Response data: $jsonData');

      // Extract the "Data" key and ensure it is a list
      if (jsonData.containsKey('Data') && jsonData['Data'] is List) {
        return (jsonData['Data'] as List)
            .map((utility) => UtilityModels.fromJson(utility))
            .toList();
      } else {
        throw Exception(
            'Invalid JSON structure: "Data" key not found or not a list');
      }
    } else if (response.statusCode == 404) {
      // Handle the case where no utilities are found for the classroom
      throw Exception('No utilities found for classroom ID: $classroomId');
    } else {
      throw Exception('Failed to load utilities');
    }
  }

  //Update utility status by ID
  static Future<void> updateUtilityStatus(
      int utilityId, String newStatus, int classroomId) async {
    final response = await http.put(
      Uri.parse(
          '${ApiConstants.baseUrl}/utility/updateUtilityStatus/$utilityId'),
      headers: {'Content-Type': 'application/json'},
      body:
          jsonEncode({'utilityStatus': newStatus, 'classroomId': classroomId}),
    );

    if (response.statusCode == 200) {
      // Successfully updated the utility status
      print(
          'UtilityService: Updated utility ID $utilityId to status $newStatus');
    } else {
      throw Exception('Failed to update utility status');
    }
  }
}
