import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassModel {
  final int id;
  final String courseCode;
  final String courseName;
  final String location;
  final String startTime;
  final String endTime;
  final String date;

  ClassModel({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    DateTime parsedDate = DateFormat('dd MMMM yyyy').parse(date);
    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

    return {
      'id': id,
      'courseCode': courseCode,
      'title': courseName,
      'classLocation': location,
      'timeStart': startTime,
      'timeEnd': endTime,
      'date': formattedDate,
    };
  }

  // Convert JSON object to ClassModel
  factory ClassModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.parse(json['date']);
    String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);

    TimeOfDay startTime = _parseTime(json['timeStart']);
    TimeOfDay endTime = _parseTime(json['timeEnd']);
    String formattedStartTime = _formatTime(startTime);
    String formattedEndTime = _formatTime(endTime);

    return ClassModel(
      id: json['id'],
      courseCode: json['courseCode'],
      courseName: json['title'],
      location: json['classLocation'] ?? "Not Specified",
      startTime: formattedStartTime,
      endTime: formattedEndTime,
      date: formattedDate,
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
