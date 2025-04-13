import 'package:intl/intl.dart';

class ClassCardModel {
  final int classId;
  final String courseName;
  final String date;
  final String recordingStatus;
  final String publishStatus;
  final String classLocation;
  final String imageUrl;

  ClassCardModel({
    required this.classId,
    required this.courseName,
    required this.date,
    required this.recordingStatus,
    required this.publishStatus,
    required this.classLocation,
    required this.imageUrl,
  });

  // Convert JSON object to ClassModel
  factory ClassCardModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.parse(json['date']);
    String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);

    return ClassCardModel(
      classId: json['classId'],
      courseName: json['className'],
      date: formattedDate,
      recordingStatus: json['recordingStatus'],
      publishStatus: json['publishStatus'],
      classLocation: json['classLocation'],
      imageUrl: json['imageUrl'],
    );
  }
}
