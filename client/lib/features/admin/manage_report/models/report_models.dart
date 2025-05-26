import 'package:intl/intl.dart';

class UtilityIssueModel {
  final int issueId;
  final String issueTitle;
  final String issueDescription;
  final String userId;
  final String issueStatus;
  final String imageUrl;
  final int classroomId;
  final String userName;
  final String classroomName;
  final String createdAt;

  UtilityIssueModel({
    required this.issueId,
    required this.issueTitle,
    required this.issueDescription,
    required this.userId,
    required this.issueStatus,
    required this.imageUrl,
    required this.classroomId,
    required this.userName,
    required this.classroomName,
    required this.createdAt,
  });

  // Convert JSON object to UtilityIssueModel
  factory UtilityIssueModel.fromJson(Map<String, dynamic> json) {
    final rawTimestamp = json['timestamp'];
    final formattedTimestamp = _formatTimestamp(rawTimestamp);
    return UtilityIssueModel(
      issueId: json['issueId'],
      issueTitle: json['issueTitle'],
      issueDescription: json['issueDescription'],
      userId: json['userId'],
      issueStatus: json['issueStatus'],
      imageUrl: json['imageUrl'],
      classroomId: json['classroomId'],
      userName: json['userName'],
      classroomName: json['classroomName'],
      createdAt: formattedTimestamp,
    );
  }

  // Convert UtilityIssueModel to JSON
  Map<String, dynamic> toJson() {
    return {
      // 'issueId': issueId,
      'issueTitle': issueTitle,
      'issueDescription': issueDescription,
      // 'userId': userId,
      // 'issueStatus': issueStatus,
      // 'imageUrl': imageUrl,
      'classroomId': classroomId,
      // 'userName': userName,
      // 'classroomName': classroomName,
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
