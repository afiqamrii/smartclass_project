import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/manage_class/models/course_model.dart';

class CourseApi {
  static Future<List<CourseModel>> fetchCourses() async {
    final response =
        await http.get(Uri.parse('${ApiConstants.baseUrl}/course/viewcourse'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      // Extract the "Data" key and ensure it is a list
      if (jsonData.containsKey('Data') && jsonData['Data'] is List) {
        return (jsonData['Data'] as List)
            .map((course) => CourseModel.fromJson(course))
            .toList();
      } else {
        throw Exception(
            'Invalid JSON structure: "Data" key not found or not a list');
      }
    } else {
      throw Exception('Failed to load courses');
    }
  }
}

// Provider for CourseApi
final courseApiProvider = Provider<CourseApi>((ref) {
  return CourseApi();
});
