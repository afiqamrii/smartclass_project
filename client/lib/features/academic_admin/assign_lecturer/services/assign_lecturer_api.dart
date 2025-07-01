import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/super_admin/manage_user/models/user_models.dart';

class AssignLecturerApi {
  //Get all assigned lecturer for a course
  static Future<List<UserModels>> fetchAssignedLecturers(int courseId) async {
    final response = await http.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/course/getassignedlecturers/$courseId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      // //Debug
      // print('UtilityService: Fetched utilities for classroom ID $classroomId');
      // print('UtilityService: Response data: $jsonData');

      // Extract the "Data" key and ensure it is a list
      if (jsonData.containsKey('Data') && jsonData['Data'] is List) {
        return (jsonData['Data'] as List)
            .map((utility) => UserModels.fromJson(utility))
            .toList();
      } else {
        throw Exception(
            'Invalid JSON structure: "Data" key not found or not a list');
      }
    } else if (response.statusCode == 404) {
      // Handle the case where no utilities are found for the classroom
      throw Exception('No lecturers found');
    } else {
      throw Exception('Failed to load lecturers');
    }
  }

  //Get all lecturer
  static Future<List<UserModels>> fetchLecturers(int courseId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/course/getlecturers/$courseId'),
    );

    //Debug
    //Debug sending request
    // print('AssignLecturerApi: Fetching lecturers for course ID $courseId');
    // print('AssignLecturerApi: Response status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      // Extract the "Data" key and ensure it is a list
      if (jsonData.containsKey('Data') && jsonData['Data'] is List) {
        return (jsonData['Data'] as List)
            .map((utility) => UserModels.fromJson(utility))
            .toList();
      } else {
        throw Exception(
            'Invalid JSON structure: "Data" key not found or not a list');
      }
    } else if (response.statusCode == 404) {
      // Handle the case where no lecturers are found for the course
      throw Exception('No lecturers found');
    } else {
      throw Exception('Failed to load lecturers');
    }
  }

  static Future<void> assignLecturer(
    int courseId,
    String lecturerId,
    String courseName,
    String lecturerEmail,
    String courseCode,
    BuildContext context,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/course/assigncourse'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'courseId': courseId,
          'lecturerId': lecturerId,
          'courseName': courseName,
          'courseCode': courseCode,
          'lecturerEmail': lecturerEmail,
        }),
      );

      // Debugging output
      print('AssignLecturerApi: Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Show success message
        await Flushbar(
          message: 'Lecturer assigned successfully to $courseName!',
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ),
        ).show(context);

        // Pop back after flushbar
        Navigator.pop(context, true);
      } else {
        final errorMsg = jsonDecode(response.body)['message'] ??
            'Failed to assign lecturer to course, please try again.';
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
      Flushbar(
        message: 'Failed to assign lecturer',
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
}
