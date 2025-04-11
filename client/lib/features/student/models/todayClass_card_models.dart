import 'package:intl/intl.dart';

class TodayclassCardModels {
  final int classId;
  final String courseCode;
  final String courseName;
  final String location;
  final String startTime;
  final String endTime;
  final String date;
  final String lecturerName;
  

  TodayclassCardModels({
    required this.classId,
    required this.courseCode,
    required this.courseName,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.lecturerName,
    
  });

  // Convert JSON object to ClassModel
  factory TodayclassCardModels.fromJson(Map<String, dynamic> json) {
    // Fix date parsing
    DateTime parsedDate = DateTime.parse(json['date']);
    String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);

    // Fix time parsing
    String formattedStartTime = _formatTime(json['timeStart']);
    String formattedEndTime = _formatTime(json['timeEnd']);

    return TodayclassCardModels(
      classId: json['classId'] ?? 0,
      courseCode: json['courseCode'] ?? "Unknown Code",
      courseName: json['className'] ?? "Unknown Class",
      location: json['classLocation'] ?? "Not Specified",
      startTime: formattedStartTime,
      endTime: formattedEndTime,
      date: formattedDate,
      lecturerName: json['lecturerName'] ?? "Unknown",

    );
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
      // print("Input time: $time"); // Debugging

      // Normalize any irregular spaces and characters
      String cleanedTime = time.replaceAll(RegExp(r'\s+'), ' ').trim();

      DateTime parsedTime = DateFormat("hh:mm a").parse(cleanedTime);
      String formattedTime = DateFormat("HH:mm:ss").format(parsedTime);

      // print("Converted time: $formattedTime"); // Debugging
      return formattedTime;
    } catch (e) {
      // print("Error parsing time: $e");
      return "00:00:00"; // Default invalid time
    }
  }
}
