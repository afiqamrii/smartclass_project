import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this package for date and time formatting

class ClassModel {
  final String courseCode;
  final String courseName;
  final String location;
  final String startTime;
  final String endTime;
  final String date;

  ClassModel({
    required this.courseCode,
    required this.courseName,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.date,
  });

  /// Factory method to create a `ClassModel` from API JSON data
  factory ClassModel.fromJson(Map<String, dynamic> json) {
    // Parse and format the date
    DateTime parsedDate = DateTime.parse(json['date']);
    String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);

    // Parse and format start and end times
    TimeOfDay startTime = _parseTime(json['timeStart']);
    TimeOfDay endTime = _parseTime(json['timeEnd']);
    String formattedStartTime = _formatTime(startTime);
    String formattedEndTime = _formatTime(endTime);

    return ClassModel(
      courseCode: json['courseCode'],
      courseName: json['title'], // Map `title` to `courseName`
      location: json['classLocation'] ?? "Not Specified",
      startTime: formattedStartTime,
      endTime: formattedEndTime,
      date: formattedDate,
    );
  }

  /// Converts the raw time string to a `TimeOfDay`
  static TimeOfDay _parseTime(String time) {
    final parts = time.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  /// Formats a `TimeOfDay` to a 12-hour string with "a.m." or "p.m."
  static String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final formattedTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat('h:mm a').format(formattedTime).replaceAll('.', '');
  }
}







// // import 'package:flutter/material.dart';

// class ClassModel {
//   final String courseCode;
//   final String courseName;
//   final String location;
//   final String startTime;
//   final String endTime;
//   final String date;

//   ClassModel({
//     required this.courseCode,
//     required this.courseName,
//     required this.location,
//     required this.startTime,
//     required this.endTime,
//     required this.date,
//   });

//   static List<ClassModel> getClasses() {
//     return [
//       ClassModel(
//         courseCode: "CSE3023",
//         courseName: "Object Oriented Programming (K1)",
//         location: "B12-03",
//         startTime: "11 a.m.",
//         endTime: "1 p.m.",
//         date: "21 June 2024",
//       ),
//       ClassModel(
//         courseCode: "CSF3253",
//         courseName: "Intelligent Systems (K2)",
//         location: "B12-03",
//         startTime: "4 p.m.",
//         endTime: "6 p.m.",
//         date: "21 June 2024",
//       ),
//       ClassModel(
//         courseCode: "CSF3253",
//         courseName: "Intelligent Systems (K2)",
//         location: "B12-03",
//         startTime: "4 p.m.",
//         endTime: "6 p.m.",
//         date: "21 June 2024",
//       ),
//       ClassModel(
//         courseCode: "CSF3253",
//         courseName: "Intelligent Systems (K2)",
//         location: "B12-03",
//         startTime: "4 p.m.",
//         endTime: "6 p.m.",
//         date: "21 June 2024",
//       ),
//     ];
//   }
// }