import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/shared/data/models/classroom_models.dart';

class ClassroomApi {
  static Future<List<ClassroomModels>> fetchClassrooms() async {
    final response = await http
        .get(Uri.parse('${ApiConstants.baseUrl}/classroom/getclassroom'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      // Extract the "Data" key and ensure it is a list
      if (jsonData.containsKey('Data') && jsonData['Data'] is List) {
        return (jsonData['Data'] as List)
            .map((course) => ClassroomModels.fromJson(course))
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

// // Provider for CourseApi
// final classroomApiProvider = Provider<ClassroomApi>((ref) {
//   return ClassroomApi();
// });
