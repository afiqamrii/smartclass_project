import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/student/views/enroll_course/models/enroll_models.dart';

class CourseEnrollmentService {
  static Future<void> enrollCourse(
    BuildContext context,
    int courseId,
    String studentId,
    String courseName,
    String lecturerId,
    String lecturerEmail,
    String studentEmail, // Get email from user provider
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/enrollment/course'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'courseId': courseId,
          'studentId': studentId,
          'lecturerId': lecturerId,
          'courseName': courseName,
          'lecturerEmail': lecturerEmail,
          'studentEmail': studentEmail, // Include student email
        }),
      );

      if (response.statusCode == 200) {
        print('CourseEnrollmentService: Course enrollment successful');
        // Show a success message, then pop after it is dismissed
        await Flushbar(
          message: 'Course enrollment for $courseName successful!',
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
      // print('Error enrolling course: $e');
      Flushbar(
        message: 'Failed to enroll course',
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

  // Method to withdraw from a course
  static Future<void> withdrawFromCourse(
    BuildContext context,
    int enrollmentId,
    String studentId,
    String courseName,
    String studentEmail, // Get email from user provider
  ) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/enrollment/withdraw/$enrollmentId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'studentId': studentId,
          'courseName': courseName,
          'studentEmail': studentEmail, // Include student email
        }),
      );

      if (response.statusCode == 200) {
        print('CourseEnrollmentService: Course enrollment successful');
        // Show a success message, then pop after it is dismissed
        await Flushbar(
          message: 'Course withdrawal for $courseName successful!',
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
          message: 'Failed to withdraw from course: $errorMsg',
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
      // print('Error enrolling course: $e');
      Flushbar(
        message: 'Failed to withdraw from course',
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

  //Get enrolled courses for a student
  static Future<List<EnrollModels>> getEnrolledCourses(String studentId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}/enrollment/allenrollment/$studentId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('Data') && jsonData['Data'] is List) {
          return (jsonData['Data'] as List<dynamic>)
              .map((course) => EnrollModels.fromJson(course))
              .toList();
        } else {
          throw Exception(
              'Invalid JSON structure: "enrolledCourses" key not found or not a list');
        }
      } else {
        throw Exception('Failed to load enrolled courses');
      }
    } catch (e) {
      throw Exception('Error fetching enrolled courses: $e');
    }
  }
}
