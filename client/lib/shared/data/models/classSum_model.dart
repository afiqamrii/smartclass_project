import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassSumModel {
  final int classId;
  final String courseCode;
  final String courseName;
  final String location;
  final String startTime;
  final String endTime;
  final String date;
  final String recordingStatus;

  ClassSumModel({
    required this.classId,
    required this.courseCode,
    required this.courseName,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.recordingStatus,
  });

  // Convert ClassModel to JSON
  Map<String, dynamic> toJson() {
    DateTime parsedDate = DateFormat('dd MMMM yyyy').parse(date);
    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

    return {
      'classId': classId,
      'courseCode': courseCode,
      'className': courseName,
      'classLocation': location,
      'timeStart': startTime,
      'timeEnd': endTime,
      'date': formattedDate,
      'recordingStatus': recordingStatus
    };
  }

  // Convert JSON object to ClassModel
  factory ClassSumModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.parse(json['date']);
    String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);

    TimeOfDay startTime = _parseTime(json['timeStart']);
    TimeOfDay endTime = _parseTime(json['timeEnd']);
    String formattedStartTime = _formatTime(startTime);
    String formattedEndTime = _formatTime(endTime);

    return ClassSumModel(
      classId: json['classId'],
      courseCode: json['courseCode'] ?? "Not Specified",
      courseName: json['className'] ?? "Unknown Class",
      location: json['classLocation'] ?? "Not Specified",
      startTime: formattedStartTime,
      endTime: formattedEndTime,
      date: formattedDate,
      recordingStatus: json['recordingStatus'],
    );
  }

  // Change time format
  static TimeOfDay _parseTime(String time) {
    final parts = time.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // Change time format
  static String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.jm(); // '6:00 AM'
    return format.format(dt);
  }
}
