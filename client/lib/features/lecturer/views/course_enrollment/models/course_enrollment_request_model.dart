class CourseEnrollmentRequest {
  final int enrollmentId;
  final String studentId;
  final int courseId;
  final String requestedAt;
  final String courseName;
  final String courseCode;
  final String? imageUrl;
  final String status;
  final String studentName;
  final String approvedAt;

  CourseEnrollmentRequest({
    required this.enrollmentId,
    required this.studentId,
    required this.courseId,
    required this.requestedAt,
    required this.courseName,
    required this.courseCode,
    this.imageUrl,
    required this.status,
    required this.studentName,
    required this.approvedAt,
  });

  // Convert JSON object to CourseEnrollmentRequest
  factory CourseEnrollmentRequest.fromJson(Map<String, dynamic> json) {
    return CourseEnrollmentRequest(
      enrollmentId: json['enrollment_id'],
      studentId: json['student_id'],
      courseId: json['courseId'],
      requestedAt: json['requested_at'],
      courseName: json['courseName'],
      courseCode: json['courseCode'],
      imageUrl: json['imageUrl'],
      status: json['status'],
      studentName: json['studentName'],
      approvedAt: json['approved_at'] ?? '0000-00-00',
    );
  }

  // Convert CourseEnrollmentRequest to JSON
  Map<String, dynamic> toJson() {
    return {
      'enrollment_id': enrollmentId,
      'student_id': studentId,
      'courseId': courseId,
      'requested_at': requestedAt,
      'courseName': courseName,
      'courseCode': courseCode,
      'imageUrl': imageUrl,
      'status': status,
      'studentName': studentName,
    };
  }
}
