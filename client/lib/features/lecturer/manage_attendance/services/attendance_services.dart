import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/lecturer/manage_attendance/models/attendance_models.dart';

class AttendanceService {
  Future<List<AttendanceReport>> fetchAttendanceReport(int classId) async {
    final response = await http.get(Uri.parse(
        '${ApiConstants.baseUrl}/clockInAttendance/generateattendancereport/$classId'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<dynamic> reports = jsonData['report'];
      return reports.map((e) => AttendanceReport.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load attendance report');
    }
  }
}
