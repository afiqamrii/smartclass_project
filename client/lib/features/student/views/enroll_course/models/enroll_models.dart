import 'package:intl/intl.dart';

class EnrollModels {
  final int enrollmentId;
  final String studentId;
  final int courseId;
  final String requestedAt;
  final String courseName;
  final String courseCode;
  final String courseImageUrl;
  final String status;

  EnrollModels({
    required this.enrollmentId,
    required this.studentId,
    required this.courseId,
    required this.requestedAt,
    required this.courseName,
    required this.courseCode,
    required this.courseImageUrl,
    required this.status,
  });

  // Convert JSON object to EnrollModels
  factory EnrollModels.fromJson(Map<String, dynamic> json) {
    // Ensure requestedAt is a valid timestamp and format it
    final rawTimestamp = json['requested_at'] ?? "Unknown Date";
    final formattedTimestamp = _formatTimestamp(rawTimestamp);
    return EnrollModels(
      enrollmentId: json['enrollment_id'] ?? 0,
      studentId: json['student_id'] ?? "Unknown Student",
      courseId: json['courseId'] ?? 0,
      requestedAt: formattedTimestamp,
      courseName: json['courseName'] ?? "Unknown Course",
      courseCode: json['courseCode'] ?? "Unknown Code",
      courseImageUrl: json['imageUrl'] ?? "Image Not Available",
      status: json['status'] ?? "Pending",
    );
  }

  // Convert EnrollModels to JSNO
  Map<String, dynamic> toJson() {
    return {
      'enrollmentId': enrollmentId,
      'studentId': studentId,
      'courseId': courseId,
      'requestedAt': requestedAt,
      'courseName': courseName,
      'courseCode': courseCode,
      'courseImageUrl': courseImageUrl,
      'status': status,
    };
  }

  static String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final formatter = DateFormat('dd MMM yyyy, h:mm a');
      return formatter.format(dateTime);
    } catch (e) {
      return timestamp; // fallback if parsing fails
    }
  }
}
