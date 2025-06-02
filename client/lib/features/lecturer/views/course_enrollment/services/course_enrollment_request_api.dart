import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/course_enrollment/models/course_enrollment_request_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CourseEnrollmentRequestApi {
  // Get enrolled requested courses for a student
  static Future<List<CourseEnrollmentRequest>> getEnrolledRequests(
      String lecturerId, int courseId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}/enrollment/courseenrollment/$lecturerId/$courseId'),
      );

      // Debug: print status and body
      print('Status: ${response.statusCode}, Body: ${response.body}');

      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData.containsKey('result') && jsonData['result'] is List) {
          return (jsonData['result'] as List<dynamic>)
              .map((course) => CourseEnrollmentRequest.fromJson(course))
              .toList();
        } else {
          throw Exception('Invalid data received from server.');
        }
      } else if (response.statusCode == 404) {
        final message = jsonData['message'] ??
            'No students have enrolled in this course yet.';
        throw Exception(message);
      } else {
        final error = jsonData['error'] ??
            jsonData['message'] ??
            'Failed to load enrollment requests. Please try again.';
        throw Exception(error);
      }
    } catch (e) {
      // Print the error for debugging
      print('Error in getEnrolledRequests: $e');
      throw Exception(e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Could not fetch enrollment requests. Please try again later.');
    }
  }

  //Function to update the enrollment request status
  static Future<void> updateEnrollmentRequestStatus(
      int enrollmentId, String status) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/enrollment/updateenrollment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'enrollmentId': enrollmentId,
          'status': status,
        }),
      );

      print('Status: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        // Check for presence of error key instead of success key
        if (jsonData.containsKey('error')) {
          throw Exception(jsonData['error']);
        }
        // success path: do nothing (return)
      } else {
        final jsonData = jsonDecode(response.body);
        final error = jsonData['error'] ?? 'Failed to update request.';
        throw Exception(error);
      }
    } catch (e) {
      print('Error in updateEnrollmentRequestStatus: $e');
      throw Exception(
        e is Exception
            ? e.toString().replaceFirst('Exception: ', '')
            : 'Could not update enrollment request status. Please try again later.',
      );
    }
  }
}
