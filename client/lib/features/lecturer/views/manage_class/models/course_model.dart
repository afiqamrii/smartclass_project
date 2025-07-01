class CourseModel {
  final int courseId;
  final String courseCode;
  final String courseName;
  final String lecturerId;
  final String lecturerName;
  final String lecturerEmail;

  CourseModel({
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.lecturerId,
    required this.lecturerName,
    required this.lecturerEmail,
  });

  // Convert a Map to a CourseModel object
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      courseId: json['courseId'],
      courseCode: json['courseCode'],
      courseName: json['courseName'],
      lecturerId: json['lecturerId'] ?? '',
      lecturerName: json['lecturerName'] ?? '', 
      lecturerEmail: json['lecturerEmail'] ?? '', 
    );
  }

  @override
  String toString() => "$courseCode - $courseName";
}
