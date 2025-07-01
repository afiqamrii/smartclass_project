import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  // Mark attendance as present
  static Future<void> markAttendance(
    BuildContext context,
    String studentId,
    int classId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/clockInAttendance/manualattendance'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'studentId': studentId,
          'classId': classId,
          'attendanceStatus': 'Present',
        }),
      );

      if (response.statusCode == 200) {
        await Flushbar(
          message: 'Student marked present successfully!',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green.shade600,
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
        ).show(context);
      } else {
        final jsonData = jsonDecode(response.body);
        final error = jsonData['message'] ?? 'Failed to mark attendance.';
        await Flushbar(
          message: error,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red.shade600,
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
      await Flushbar(
        message: 'Error occurred while marking attendance. Please try again.',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red.shade600,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(
          Icons.error_outline,
          color: Colors.white,
        ),
      ).show(context);
    }
  }
}
