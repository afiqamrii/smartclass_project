import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smartclass_fyp_2024/constants/api_constants.dart';
import 'package:smartclass_fyp_2024/features/lecturer/manage_attendance/models/attendance_models.dart';

class AttendanceService {
  //Fetch attendance report
  Future<List<AttendanceReport>> fetchAttendanceReport(int classId) async {
    final response = await http.get(Uri.parse(
        '${ApiConstants.baseUrl}/clockInAttendance/generateattendancereport/$classId'));

    //Debug
    // print('Status: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<dynamic> reports = jsonData['report'];
      return reports.map((e) => AttendanceReport.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load attendance report');
    }
  }

  //Download attendance report in PDF format
  Future<String?> downloadAttendanceReport(int classId) async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Storage permission denied');
      }

      final dir = await getExternalStorageDirectory();
      final filePath = '${dir!.path}/attendance_report_$classId.pdf';

      final dio = Dio();
      final response = await dio.download(
        '${ApiConstants.baseUrl}/clockInAttendance/attendance/report/$classId/pdf',
        filePath,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        print('File downloaded to $filePath');
        return filePath;
      } else {
        throw Exception('Failed to download PDF');
      }
    } catch (e) {
      print('Download error: $e');
      return null;
    }
  }
}
