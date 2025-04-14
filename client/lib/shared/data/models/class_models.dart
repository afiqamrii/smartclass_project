import 'package:intl/intl.dart';

class ClassCreateModel {
  final int classId;
  final String courseCode;
  final String courseName;
  final String location;
  final String startTime;
  final String endTime;
  final String date;
  final String lecturerId;
  final String imageUrl;

  ClassCreateModel({
    required this.classId,
    required this.courseCode,
    required this.courseName,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.lecturerId,
    required this.imageUrl,
  });

  // Convert JSON object to ClassModel
  factory ClassCreateModel.fromJson(Map<String, dynamic> json) {
    // Fix date parsing
    DateTime parsedDate = DateTime.parse(json['date']);
    String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);

    // Fix time parsing
    String formattedStartTime = _formatTime(json['timeStart']);
    String formattedEndTime = _formatTime(json['timeEnd']);

    return ClassCreateModel(
      classId: json['classId'] ?? 0,
      courseCode: json['courseCode'] ?? "Unknown Code",
      courseName: json['className'] ?? "Unknown Class",
      location: json['classLocation'] ?? "Not Specified",
      startTime: formattedStartTime,
      endTime: formattedEndTime,
      date: formattedDate,
      lecturerId: json['lecturerId'] ?? "Unknown",
      imageUrl: json['imageUrl'] ?? "Image Not Available",
    );
  }

  // Convert ClassModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'classId': classId,
      'courseCode': courseCode,
      'className': courseName,
      'classLocation': location,
      'timeStart': timeToJSON(startTime),
      'timeEnd': timeToJSON(endTime),
      'date': formatDate(date),
      'lecturerId': lecturerId,
    };
  }

  // Parse time safely

  static String _formatTime(String time) {
    try {
      List<String> parts = time.split(":");
      if (parts.length < 2) return "Invalid Time";
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      final dt = DateTime(0, 0, 0, hour, minute);
      return DateFormat.jm().format(dt); // Converts to '6:00 AM'
    } catch (e) {
      return "Invalid Time";
    }
  }

  //Format Date to save in database
  static String formatDate(String date) {
    DateTime parsedDate = DateFormat('dd MMMM yyyy').parse(date);
    return DateFormat('yyyy-MM-dd').format(parsedDate); // Corrected format
  }

  //Format Time to save in database
  static String timeToJSON(String time) {
    try {
      // print("Input time: $time");

      String cleanedTime = time.replaceAll(RegExp(r'\s+'), ' ').trim();

      DateTime parsedTime;

      // Try parsing as 12-hour format with AM/PM
      try {
        parsedTime = DateFormat("hh:mm a").parseStrict(cleanedTime);
      } catch (_) {
        // If 12-hour parsing fails, try 24-hour format
        parsedTime = DateFormat("HH:mm").parseStrict(cleanedTime);
      }

      String formattedTime = DateFormat("HH:mm:ss").format(parsedTime);
      return formattedTime;
    } catch (e) {
      // print("Error parsing time: $e");
      // print("Input time: $time");
      return "00:00:00";
    }
  }
}
