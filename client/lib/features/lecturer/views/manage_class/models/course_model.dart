class CourseModel {
  final int courseId;
  final String courseCode;
  final String courseName;

  CourseModel({
    required this.courseId,
    required this.courseCode,
    required this.courseName,
  });

  // Convert a Map to a CourseModel object
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      courseId: json['courseId'] ,
      courseCode: json['courseCode'],
      courseName: json['courseName'],
    );
  }

  @override
  String toString() => "$courseCode - $courseName";
}
