import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/admin/manage_report/models/report_models.dart';

// This class is responsible for fetching reports from the API
// It uses the http package to make GET requests and parse the JSON response
class ReportApi {
  static Future<List<UtilityIssueModel>> fetchreports() async {
    final response =
        await http.get(Uri.parse('${ApiConstants.baseUrl}/report/getreport'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      // Extract the "Data" key and ensure it is a list
      if (jsonData.containsKey('reports') && jsonData['reports'] is List) {
        return (jsonData['reports'] as List)
            .map((course) => UtilityIssueModel.fromJson(course))
            .toList();
      } else {
        throw Exception(
            'Invalid JSON structure: "Data" key not found or not a list');
      }
    } else {
      throw Exception('Failed to load courses');
    }
  }

  //Retrieve the report by ID
  static Future<UtilityIssueModel> fetchReportById(int id) async {
    final response = await http
        .get(Uri.parse('${ApiConstants.baseUrl}/report/getreport/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      // Extract the "Data" key and ensure it is a Map
      if (jsonData.containsKey('report') && jsonData['report'] is Map) {
        return UtilityIssueModel.fromJson(jsonData['report']);
      } else {
        throw Exception(
            'Invalid JSON structure: "Data" key not found or not a Map');
      }
    } else {
      throw Exception('Failed to load courses');
    }
  }

  //Update report status
  static Future<void> updateReportStatus(String userId, int reportId) async {
    final response = await http.put(
      Uri.parse(
          '${ApiConstants.baseUrl}/report/updatereportstatus/$reportId/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'status': 'completed',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update report status');
    }
  }

  //Get report by user ID
  static Future<List<UtilityIssueModel>> fetchReportByUserId(
      String userId) async {
    final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/report/getreportbyuser/$userId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      // Extract the "Data" key and ensure it is a list
      if (jsonData.containsKey('reports') && jsonData['reports'] is List) {
        return (jsonData['reports'] as List)
            .map((course) => UtilityIssueModel.fromJson(course))
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
