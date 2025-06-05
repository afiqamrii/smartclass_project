class AttendanceReport {
  final String studentId;
  final String studentName;
  final String studentEmail;
  final String attendanceStatus;
  final String attendanceTime;
  final String courseCode;
  final String className;
  final String lecturerName;
  final String classDate;
  final String classStartTime;
  final String classEndTime;
  final String classLocation;

  AttendanceReport({
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.attendanceStatus,
    required this.attendanceTime,
    required this.courseCode,
    required this.className,
    required this.lecturerName,
    required this.classDate,
    required this.classStartTime,
    required this.classEndTime,
    required this.classLocation,
  });

  factory AttendanceReport.fromJson(Map<String, dynamic> json) {
    return AttendanceReport(
      studentId: json['studentId'],
      studentName: json['studentName'],
      studentEmail: json['studentEmail'],
      attendanceStatus: json['attendanceStatus'],
      attendanceTime: json['attendanceTime'],
      courseCode: json['courseCode'],
      className: json['className'],
      lecturerName: json['lecturerName'],
      classDate: json['classDate'],
      classStartTime: json['classStartTime'],
      classEndTime: json['classEndTime'],
      classLocation: json['classLocation'],
    );
  }
}