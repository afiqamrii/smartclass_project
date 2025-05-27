import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/admin/control_utility/models/utility_models.dart';

class UtilityService {
  static Future<List<UtilityModels>> fetchUtility(int classroomId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/utility/getUtility/$classroomId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      //Debug
      print('UtilityService: Fetched utilities for classroom ID $classroomId');
      print('UtilityService: Response data: $jsonData');

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
}
