import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/course_enrollment/models/course_enrollment_request_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CourseEnrollmentRequestApi {
  //Get enrolled requested courses for a student
  static Future<List<CourseEnrollmentRequest>> getEnrolledRequests(
      String lecturerId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}/enrollment/courseenrollment/$lecturerId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('result') && jsonData['result'] is List) {
          return (jsonData['result'] as List<dynamic>)
              .map((course) => CourseEnrollmentRequest.fromJson(course))
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
